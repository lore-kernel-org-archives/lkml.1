Return-Path: <linux-kernel-owner+w=401wt.eu-S1757195AbZAIKKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757195AbZAIKKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 05:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbZAIKKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 05:10:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54327 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbZAIKKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 05:10:36 -0500
Date: Fri, 9 Jan 2009 11:08:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
       bfields@fieldses.org
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20090109100821.GA27829@redhat.com>
References: <20081229041352.6bbdf57c@tpl> <20081229124151.GA29634@redhat.com> <20090108162806.48caaa29@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108162806.48caaa29@bike.lwn.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08, Jonathan Corbet wrote:
>
> This patch returns -ENOTTY in both places.  It seems better
> to me, but it *is* a change, and we may well not want to do that.

I'm afraid, this can break user-space applications. But I agree
it looks better.

>  static int setfl(int fd, struct file * filp, unsigned long arg)
>  {
> @@ -176,25 +179,52 @@ static int setfl(int fd, struct file * filp, unsigned long arg)
>  	if (error)
>  		return error;
>
> -	/*
> -	 * We still need a lock here for now to keep multiple FASYNC calls
> -	 * from racing with each other.
> -	 */
> -	lock_kernel();
>  	if ((arg ^ filp->f_flags) & FASYNC) {
> -		if (filp->f_op && filp->f_op->fasync) {
> -			error = filp->f_op->fasync(fd, filp, (arg & FASYNC) != 0);
> -			if (error < 0)
> -				goto out;
> -		}
> +		error = fasync_change(fd, filp, (arg & FASYNC) != 0);
> +		if (error < 0)
> +			goto out;

So, fasync_change() sets/clears FASYNC,

> +	lock_file_flags();
>  	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
> +	unlock_file_flags();

and then we change f_flags again, including F_ASYNC bit.

This is racy?

Suppose T1 does setfl(arg == 0) and preempted before lock_file_flags()
above. T2 does setfl(FASYNC) and succeeds. T1 resumes and clears FASYNC.
Now we have the same problem, the file's state is not consistent.

> +int fasync_change(int fd, struct file *filp, int on)
> +{
> +	int ret;
> +	static DEFINE_MUTEX(fasync_mutex);
> +
> +	if (filp->f_op->fasync == NULL)
> +		return -ENOTTY;
> +
> +	mutex_lock(&fasync_mutex);
> +	lock_file_flags();
> +	if (((filp->f_flags & FASYNC) == 0) == (on == 0)) {
> +		unlock_file_flags();
> +		return 0;
> +	}
> +	if (on)
> +		filp->f_flags |= FASYNC;
> +	else
> +		filp->f_flags &= ~FASYNC;
> +	unlock_file_flags();
> +	ret = filp->f_op->fasync(fd, filp, on);
> +	mutex_unlock(&fasync_mutex);
> +	return ret;

But we must not change ->f_flags if ->fasync() fails?

Now we have the global mutex for ->fasync... Well, not very
good but fasync_helper() takes fasync_lock anyway.

Oleg.

