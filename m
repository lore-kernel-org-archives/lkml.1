Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbZJ2Vwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbZJ2Vwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbZJ2Vwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:52:45 -0400
Received: from tundra.namei.org ([65.99.196.166]:38136 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbZJ2Vwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:52:45 -0400
Date: Fri, 30 Oct 2009 08:51:52 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: linux-security-module@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] define convenient securebits masks for prctl users
 (v2)
In-Reply-To: <20091029164016.GA21797@us.ibm.com>
Message-ID: <alpine.LRH.2.00.0910300851470.25970@tundra.namei.org>
References: <20091029164016.GA21797@us.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, Serge E. Hallyn wrote:

> Hi James, would you mind taking the following into
> security-testing?


Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

> 
> The securebits are used by passing them to prctl with the
> PR_{S,G}ET_SECUREBITS commands.  But the defines must be
> shifted to be used in prctl, which begs to be confused and
> misused by userspace.  So define some more convenient
> values for userspace to specify.  This way userspace does
> 
> 	prctl(PR_SET_SECUREBITS, SECBIT_NOROOT);
> 
> instead of
> 
> 	prctl(PR_SET_SECUREBITS, 1 << SECURE_NOROOT);
> 
> (Thanks to Michael for the idea)
> 
> This patch also adds include/linux/securebits to the installed headers.
> Then perhaps it can be included by glibc's sys/prctl.h.
> 
> Changelog:
> 	Oct 29: Stephen Rothwell points out that issecure can
> 		be under __KERNEL__.
> 	Oct 14: (Suggestions by Michael Kerrisk):
> 		1. spell out SETUID in SECBIT_NO_SETUID*
> 		2. SECBIT_X_LOCKED does not imply SECBIT_X
> 		3. add definitions for keepcaps
>         Oct 14: As suggested by Michael Kerrisk, don't
> 		use SB_* as that convention is already in
> 		use.  Use SECBIT_ prefix instead.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Acked-by: Andrew G. Morgan <morgan@kernel.org>
> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Ulrich Drepper <drepper@redhat.com>
> Cc: James Morris <jmorris@namei.org>
> ---
>  include/linux/Kbuild       |    1 +
>  include/linux/securebits.h |   24 ++++++++++++++++++------
>  2 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index 1feed71..5a53857 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -330,6 +330,7 @@ unifdef-y += scc.h
>  unifdef-y += sched.h
>  unifdef-y += screen_info.h
>  unifdef-y += sdla.h
> +unifdef-y += securebits.h
>  unifdef-y += selinux_netlink.h
>  unifdef-y += sem.h
>  unifdef-y += serial_core.h
> diff --git a/include/linux/securebits.h b/include/linux/securebits.h
> index d2c5ed8..3340617 100644
> --- a/include/linux/securebits.h
> +++ b/include/linux/securebits.h
> @@ -1,6 +1,15 @@
>  #ifndef _LINUX_SECUREBITS_H
>  #define _LINUX_SECUREBITS_H 1
>  
> +/* Each securesetting is implemented using two bits. One bit specifies
> +   whether the setting is on or off. The other bit specify whether the
> +   setting is locked or not. A setting which is locked cannot be
> +   changed from user-level. */
> +#define issecure_mask(X)	(1 << (X))
> +#ifdef __KERNEL__
> +#define issecure(X)		(issecure_mask(X) & current_cred_xxx(securebits))
> +#endif
> +
>  #define SECUREBITS_DEFAULT 0x00000000
>  
>  /* When set UID 0 has no special privileges. When unset, we support
> @@ -12,6 +21,9 @@
>  #define SECURE_NOROOT			0
>  #define SECURE_NOROOT_LOCKED		1  /* make bit-0 immutable */
>  
> +#define SECBIT_NOROOT		(issecure_mask(SECURE_NOROOT))
> +#define SECBIT_NOROOT_LOCKED	(issecure_mask(SECURE_NOROOT_LOCKED))
> +
>  /* When set, setuid to/from uid 0 does not trigger capability-"fixup".
>     When unset, to provide compatiblility with old programs relying on
>     set*uid to gain/lose privilege, transitions to/from uid 0 cause
> @@ -19,6 +31,10 @@
>  #define SECURE_NO_SETUID_FIXUP		2
>  #define SECURE_NO_SETUID_FIXUP_LOCKED	3  /* make bit-2 immutable */
>  
> +#define SECBIT_NO_SETUID_FIXUP	(issecure_mask(SECURE_NO_SETUID_FIXUP))
> +#define SECBIT_NO_SETUID_FIXUP_LOCKED \
> +			(issecure_mask(SECURE_NO_SETUID_FIXUP_LOCKED))
> +
>  /* When set, a process can retain its capabilities even after
>     transitioning to a non-root user (the set-uid fixup suppressed by
>     bit 2). Bit-4 is cleared when a process calls exec(); setting both
> @@ -27,12 +43,8 @@
>  #define SECURE_KEEP_CAPS		4
>  #define SECURE_KEEP_CAPS_LOCKED		5  /* make bit-4 immutable */
>  
> -/* Each securesetting is implemented using two bits. One bit specifies
> -   whether the setting is on or off. The other bit specify whether the
> -   setting is locked or not. A setting which is locked cannot be
> -   changed from user-level. */
> -#define issecure_mask(X)	(1 << (X))
> -#define issecure(X)		(issecure_mask(X) & current_cred_xxx(securebits))
> +#define SECBIT_KEEP_CAPS	(issecure_mask(SECURE_KEEP_CAPS))
> +#define SECBIT_KEEP_CAPS_LOCKED (issecure_mask(SECURE_KEEP_CAPS_LOCKED))
>  
>  #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
>  				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
> -- 
> 1.6.1
> 

-- 
James Morris
<jmorris@namei.org>
