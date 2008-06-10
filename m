Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYFJTM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYFJTM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYFJTMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:12:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36313 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984AbYFJTMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:12:49 -0400
Date: Tue, 10 Jun 2008 14:12:41 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bugfix: was Re: [ linus-git ] prctl(PR_SET_KEEPCAPS,
	...) is broken for some configs, e.g. CONFIG_SECURITY_SELINUX
Message-ID: <20080610191241.GA17311@us.ibm.com>
References: <1212932321.4675.9.camel@earth> <484BF662.9070100@kernel.org> <20080608110630.08a45cc6.akpm@linux-foundation.org> <484C5E84.2020307@kernel.org> <20080608163926.56f1be3d.akpm@linux-foundation.org> <20080609171741.GA13403@us.ibm.com> <484E0280.2050305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484E0280.2050305@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> I agree. Short term, here is a patch to add dummy support for KEEPCAPS.
>
> Cheers
>
> Andrew
>
> Serge E. Hallyn wrote:
> |>> I fear that nothing will happen, and we'll end up wasting a lot of
> |> peoples' time sending hey-why-did-my-dhcp-break reports.
> |
> | If we decide to get rid of dummy long-term, then it's far less
> | distasteful to have it lie and claim the keepcaps worked in the
> | meantime.
> |
> | So for 2.6.26 we could have dummy lie, then plan to make capabilities
> | the default for 2.6.27?
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
>
> iD8DBQFITgKA+bHCR3gb8jsRAiQYAJ47VnlBq2GSvLQv40tymjybLhNAtQCgya8G
> YZQN/5w1uq+X2MYv1x4T4D4=
> =NhwX
> -----END PGP SIGNATURE-----

> From be19a4716c97c5aaf4c9721eeccfab2d44897ce2 Mon Sep 17 00:00:00 2001
> From: Andrew G. Morgan <morgan@kernel.org>
> Date: Mon, 9 Jun 2008 21:22:18 -0700
> Subject: [PATCH] Add (back) dummy support for KEEPCAPS.
> 
> See: http://bugzilla.kernel.org/show_bug.cgi?id=10748
> 
> Signed-off-by: Andrew G. Morgan <morgan@kernel.org>

Thanks, Andrew.  Just one question inline.  Nevertheless,

Acked-by: Serge Hallyn <serue@us.ibm.com>

Dmitry, does this fix the problem for you?

(Not sure why I'm feeling queasy about this given that
find . -name "*.c" -exec "grep" "-Hn" "issecure" "{}" \;
returns only hits in security/commoncap.c...)

> ---
>  security/dummy.c |   24 +++++++++++++++++++++++-
>  1 files changed, 23 insertions(+), 1 deletions(-)
> 
> diff --git a/security/dummy.c b/security/dummy.c
> index f50c6c3..b891688 100644
> --- a/security/dummy.c
> +++ b/security/dummy.c
> @@ -27,6 +27,8 @@
>  #include <linux/hugetlb.h>
>  #include <linux/ptrace.h>
>  #include <linux/file.h>
> +#include <linux/prctl.h>
> +#include <linux/securebits.h>
>  
>  static int dummy_ptrace (struct task_struct *parent, struct task_struct *child)
>  {
> @@ -607,7 +609,27 @@ static int dummy_task_kill (struct task_struct *p, struct siginfo *info,
>  static int dummy_task_prctl (int option, unsigned long arg2, unsigned long arg3,
>  			     unsigned long arg4, unsigned long arg5, long *rc_p)
>  {
> -	return 0;
> +	switch (option) {
> +	case PR_CAPBSET_READ:
> +		*rc_p = (cap_valid(arg2) ? 1 : -EINVAL);
> +		break;
> +	case PR_GET_KEEPCAPS:
> +		*rc_p = issecure(SECURE_KEEP_CAPS);
> +		break;
> +	case PR_SET_KEEPCAPS:
> +		if (arg2 > 1)
> +			*rc_p = -EINVAL;
> +		else if (arg2)
> +			current->securebits |= issecure_mask(SECURE_KEEP_CAPS);
> +		else
> +			current->securebits &=
> +				~issecure_mask(SECURE_KEEP_CAPS);

In these last two conditions, don't you need to set *rc_p?

Oh, or my kernel tree may be out of date, as I seem to recall a recent
patch initializing error to 0 in sys_prctl(), so this wouldn't
technically be a problem?  Still would seem correct...

> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return 1;
>  }
>  
>  static void dummy_task_reparent_to_init (struct task_struct *p)
> -- 
> 1.5.3.7
> 

