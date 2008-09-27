Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYI0Nko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYI0Nko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 09:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYI0Nka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 09:40:30 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:35519 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbYI0Nk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 09:40:28 -0400
Date: Sat, 27 Sep 2008 08:40:07 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 5/6] file capabilities: remove needless inline functions
Message-ID: <20080927134007.GB10978@us.ibm.com>
References: <1222482472-12847-1-git-send-email-serue@us.ibm.com> <7004aef68d149ffb4a11835f37469948496ffc18.1222451103.git.serue@us.ibm.com> <89d3843fc1aaf91ded89d741b2e6d425508e0146.1222451103.git.serue@us.ibm.com> <178a4b5984b7559cb5cdb93b242484386ec3e3ab.1222451103.git.serue@us.ibm.com> <c9c64bbdfd3f1c665f0d1b08b82f77622be701cc.1222451103.git.serue@us.ibm.com> <06b2774a667bc535442305193417ff1a479ef1aa.1222451103.git.serue@us.ibm.com> <48DDB8F5.7040208@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DDB8F5.7040208@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Serge,
> 
> I'd much rather simply remove the target argument from the
> security_capset_check() call. Relying on the caller to not do something

Yes, I did do that in a patch on top of all of these.  It increased the
kernel size by 8 (or was it 16) bytes :)  I assume that was because
now there were more references to 'current' which is inlined?  So I
should be able to fix that by saving current() away at the top of
the fn.

Will try that.

thanks,
-serge

> bad seems fragile... If the code internally operates on current only,
> then it doesn't need a target argument... No? (Evidently, such a change
> is also needed to selinux_capset_check() too, but this doesn't look like
> it will pose a problem for the selinux code.)
> 
> Cheers
> 
> Andrew
> 
> Serge E. Hallyn wrote:
> > cap_limit_ptraced_target always returns 1, so nix it.
> > 
> > cap_block_setpcap can't return 1 any more, because
> > kernel/capabilities.c:sys_capset() will return -EPERM
> > if it is called on a task other than current, and will
> > never get to cap_capset_check.
> > 
> > This brings the vmlinux size with my config down another
> > 16 bytes (making up for the 8 byte increase from the
> > last patch).
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > ---
> >  security/commoncap.c |   22 +++-------------------
> >  1 files changed, 3 insertions(+), 19 deletions(-)
> > 
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index d48fdd8..e5afb7c 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -93,15 +93,6 @@ int cap_capget (struct task_struct *target, kernel_cap_t *effective,
> >  	return 0;
> >  }
> >  
> > -static inline int cap_block_setpcap(struct task_struct *target)
> > -{
> > -	/*
> > -	 * No support for remote process capability manipulation with
> > -	 * filesystem capability support.
> > -	 */
> > -	return (target != current);
> > -}
> > -
> >  static inline int cap_inh_is_capped(void)
> >  {
> >  	/*
> > @@ -112,14 +103,9 @@ static inline int cap_inh_is_capped(void)
> >  	return (cap_capable(current, CAP_SETPCAP) != 0);
> >  }
> >  
> > -static inline int cap_limit_ptraced_target(void) { return 1; }
> > -
> >  int cap_capset_check (struct task_struct *target, kernel_cap_t *effective,
> >  		      kernel_cap_t *inheritable, kernel_cap_t *permitted)
> >  {
> > -	if (cap_block_setpcap(target)) {
> > -		return -EPERM;
> > -	}
> >  	if (cap_inh_is_capped()
> >  	    && !cap_issubset(*inheritable,
> >  			     cap_combine(target->cap_inheritable,
> > @@ -343,11 +329,9 @@ void cap_bprm_apply_creds (struct linux_binprm *bprm, int unsafe)
> >  				bprm->e_uid = current->uid;
> >  				bprm->e_gid = current->gid;
> >  			}
> > -			if (cap_limit_ptraced_target()) {
> > -				bprm->cap_post_exec_permitted = cap_intersect(
> > -					bprm->cap_post_exec_permitted,
> > -					current->cap_permitted);
> > -			}
> > +			bprm->cap_post_exec_permitted = cap_intersect(
> > +				bprm->cap_post_exec_permitted,
> > +				current->cap_permitted);
> >  		}
> >  	}
> >  
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.7 (Darwin)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org
> 
> iD8DBQFI3bjz+bHCR3gb8jsRAqJpAJ9Ca1pADkG5BnGoOVZA+EmZbuRPfgCgoQ95
> ljvsvj7Ssp+0mXDuCy0/TnU=
> =79ni
> -----END PGP SIGNATURE-----
