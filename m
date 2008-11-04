Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYKDTHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYKDTHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbYKDTHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:07:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:38287 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981AbYKDTHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:07:36 -0500
Subject: Re: [PATCH -v2 3/4] AUDIT: collect info when execve results in
 caps in pE
From: Eric Paris <eparis@redhat.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com, sgrubb@redhat.com,
       morgan@kernel.org, viro@ZenIV.linux.org.uk
In-Reply-To: <20081104163540.GA24318@us.ibm.com>
References: <20081103201742.12059.36030.stgit@paris.rdu.redhat.com>
	 <20081103201753.12059.67262.stgit@paris.rdu.redhat.com>
	 <20081104163540.GA24318@us.ibm.com>
Content-Type: text/plain
Date: Tue, 04 Nov 2008 14:07:26 -0500
Message-Id: <1225825646.4662.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-04 at 10:35 -0600, Serge E. Hallyn wrote:
> Quoting Eric Paris (eparis@redhat.com):
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index 8bb95ed..534abb5 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -8,6 +8,7 @@
> >   */
> > 
> >  #include <linux/capability.h>
> > +#include <linux/audit.h>
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> >  #include <linux/kernel.h>
> > @@ -373,6 +374,9 @@ int cap_bprm_set_security (struct linux_binprm *bprm)
> > 
> >  void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
> >  {
> > +	kernel_cap_t pP = current->cap_permitted;
> > +	kernel_cap_t pE = current->cap_effective;
> > +
> >  	if (bprm->e_uid != current->uid || bprm->e_gid != current->gid ||
> >  	    !cap_issubset(bprm->cap_post_exec_permitted,
> >  			  current->cap_permitted)) {
> > @@ -407,6 +411,12 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
> >  	}
> > 
> >  	/* AUD: Audit candidate if current->cap_effective is set */
> > +	if (!cap_isclear(current->cap_effective)) {
> > +		if (!cap_issubset(current->cap_effective, CAP_FULL_SET) ||
> 
> Hi Eric,
> 
> can you explain what the cap_issubset() check is for here?

I'm glad you noticed it, because it is backwards!

should be

if (!cap_issubset(CAP_FULL_SET, current->cap_effective) ||

The idea is that I don't care to audit
1) full set &&
2) this is root &&
3) root should have a full set

This would still consider a root without a full set because the bset had
been changed to be an interesting event.  I'm fine with that.

I'll send -v3 once I hear comments on everything else....

-Eric

