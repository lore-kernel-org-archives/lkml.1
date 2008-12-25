Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbYLYSDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbYLYSDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 13:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYLYSDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 13:03:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53951 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbYLYSDQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 13:03:16 -0500
Date: Thu, 25 Dec 2008 19:00:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] signal: let valid_signal() check more
Message-ID: <20081225180054.GA24116@redhat.com>
References: <20081226012612.GI3130@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081226012612.GI3130@hack.private>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26, Américo Wang wrote:
>
> Teach valid_signal() to check sig > 0 case.

Why?

> @@ -727,7 +727,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
>  	{
>  		if (!perm || !capable(CAP_KILL))
>  			goto eperm;
> -		if (!valid_signal(arg) || arg < 1 || arg == SIGKILL)
> +		if (!valid_signal((int)arg) || arg == SIGKILL)
                                  ^^^^^

The patch adds a lot of unnecessary typecasts like this.

> -static inline int valid_signal(unsigned long sig)
> +static inline int valid_signal(int sig)
>  {
> -	return sig <= _NSIG ? 1 : 0;
> +	return sig <= _NSIG ? (sig > 0) : 0;
>  }

This looks a bit strange, why not

	return sig > 0 && sig <= _NSIG;

?

But, more importantly, I don't think the patch is correct.

Unless I misread the patch, now kill(pid, 0) returns -EINVAL, no?

And we have other users of valid_signal() which assume that sig == 0
is OK, for example arch_ptrace().


Imho, the patch has a point, but perhaps it is better to add the
new helper and then convert the users which do something like

	if (valid_signal(sig) && sig)
		...

What do you think?

Oleg.

