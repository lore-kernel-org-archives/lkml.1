Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbYKFT1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbYKFT1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYKFT1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:27:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50734 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbYKFT1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:27:04 -0500
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
Date: Thu, 06 Nov 2008 14:26:55 -0500
Message-Id: <1225999615.3300.177.camel@localhost.localdomain>
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
> 
> thanks,
> -serge
> 
> > +		    (bprm->e_uid != 0) || (current->uid != 0) ||
> > +		    issecure(SECURE_NOROOT))
> > +			audit_log_bprm_fcaps(bprm, &pP, &pE);

So here's the problem....  I can't fail this syscall, it's too late.  I
can do a couple of things.

1) waste lots of space in the execve record so we know memory has
already been allocated
2) just ignore the memory failure and don't worry about it.  We are
still going to get the fcaps info from the patch record and should be
able to piece together the starting and finishing caps by looking at
past audit records if you really need it.
3) I can call audit_log_lost().  I don't think we know are this time
that we really needed this record, but this is the 'safest' approach.
If people have their machines set to panic on lost records we would
panic.   Honestly though, if we don't have enough memory to satisfy this
request (we're talking about 72 bytes or something?) we are going to
fail the next audit message, so doing it now would be just fine.

I vote #2 since I don't think we are really going to have any lose of
info.  But if people want it I'll go #3 since I don't think it will hurt
anything.

-Eric

