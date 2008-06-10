Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbYFJTd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbYFJTd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbYFJTdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:33:18 -0400
Received: from sous-sol.org ([216.99.217.87]:32926 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbYFJTdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:33:18 -0400
Date: Tue, 10 Jun 2008 12:14:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bugfix: was Re: [ linus-git ] prctl(PR_SET_KEEPCAPS,
	...) is broken for some configs, e.g. CONFIG_SECURITY_SELINUX
Message-ID: <20080610191451.GL4018@sequoia.sous-sol.org>
References: <1212932321.4675.9.camel@earth> <484BF662.9070100@kernel.org> <20080608110630.08a45cc6.akpm@linux-foundation.org> <484C5E84.2020307@kernel.org> <20080608163926.56f1be3d.akpm@linux-foundation.org> <20080609171741.GA13403@us.ibm.com> <484E0280.2050305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484E0280.2050305@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew G. Morgan (morgan@kernel.org) wrote:
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

Do we need this one?  It's new to 2.6.25, so I think we could not
worry about emulating it here.

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
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return 1;
>  }
>  
>  static void dummy_task_reparent_to_init (struct task_struct *p)
