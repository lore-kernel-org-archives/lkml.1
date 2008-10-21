Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYJUTSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYJUTSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYJUTQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:16:34 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37709 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbYJUTQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:16:32 -0400
Date: Tue, 21 Oct 2008 14:16:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-audit@redhat.com, viro@zeniv.linux.org.ok, sgrubb@redhat.com
Subject: Re: [PATCH 3/4] AUDIT: audit when fcaps increase the permitted or
	inheritable capabilities
Message-ID: <20081021191625.GA4657@us.ibm.com>
References: <20081020222538.3895.50175.stgit@paris.rdu.redhat.com> <20081020222612.3895.6710.stgit@paris.rdu.redhat.com> <48FD6E49.6060104@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FD6E49.6060104@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Eric Paris wrote:
> > Any time fcaps are used to increase a processes pP or pE we will crate a new
> > audit record which contains the entire set of known information about the 
> > executable in question, fP, fI, fE, version and includes the parent processes
> > pE, pI, pP.  This record type will only be emitted from execve syscalls.
> 
> I'm confused by the choice of when to log this event.
> 
> File capabilities are required to give a process 'any' active
> capabilities. That is they don't affect pI -> pI', but without fI or fP,
> the post-execve() process is guaranteed to have no pP or pE capabilities.
> 
> Logging execve()s where there is only an increase in capabilities seems
> wrong to me. To me it seems equally important to log any event where an
> execve() yields pP != 0.

True.

... except if (!issecure(SECURE_NOROOT) && uid==0) I guess?

And then it also might be interesting in the case where
(!issecure(SECURE_NOROOT) && uid==0) and pP is not full.

> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index 888b292..9bb285d 100644
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
> > @@ -320,6 +321,8 @@ static int get_file_caps(struct linux_binprm *bprm)
> >  
> >  	rc = bprm_caps_from_vfs_caps(&vcaps, bprm);
> >  
> > +	audit_log_bprm_fcaps(bprm, &vcaps);
> > +
> 
> When rc != 0, the execve() will fail. Is it appropriate to log in this case?

It might fail because fP contains bits not in pP', right?  That's
probably interesting to auditors.

-serge
