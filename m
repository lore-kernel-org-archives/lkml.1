Return-Path: <linux-kernel-owner+w=401wt.eu-S1756308AbXEUEE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308AbXEUEE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 00:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXEUEEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 00:04:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXEUEEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 00:04:48 -0400
Date: Sun, 20 May 2007 21:02:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davi Arnaut <davi@haxent.com.br>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] signalfd: retrieve multiple signals with one read()
 call
Message-Id: <20070520210210.9a895eec.akpm@linux-foundation.org>
In-Reply-To: <464F912F.3040205@haxent.com.br>
References: <464F912F.3040205@haxent.com.br>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 21:07:11 -0300 Davi Arnaut <davi@haxent.com.br> wrote:

> Hi,
> 
> Gathering signals in bulk enables server applications to drain a signal
> queue (almost full of realtime signals) more efficiently by reducing the
> syscall and file look-up overhead.
> 
> Very similar to the sigtimedwait4() call described by Niels Provos,
> Chuck Lever, and Stephen Tweedie in a paper entitled "Analyzing the
> Overload Behavior of a Simple Web Server". The paper lists more details
> and advantages.
> 

static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
			     loff_t *ppos)
{
	struct signalfd_ctx *ctx = file->private_data;
	struct signalfd_siginfo __user *siginfo;
	int nonblock = file->f_flags & O_NONBLOCK;
	ssize_t ret, total = 0;
	siginfo_t info;

	count /= sizeof(struct signalfd_siginfo);
	if (!count)
		return -EINVAL;

	siginfo = (struct signalfd_siginfo __user *) buf;

	do {
		ret = signalfd_dequeue(ctx, &info, nonblock);
		if (unlikely(ret <= 0))
			break;
		ret = signalfd_copyinfo(siginfo, &info);
		if (ret < 0)
			break;
		siginfo++;
		total += ret;
		nonblock = 1;
	} while (--count);

	return total ? total : ret;
}

If 'count' is not a multiple of sizeof(struct signalfd_siginfo)), the read()
will return the next smallest multiple of `count'.

That is, unless `count' happens to be less than 1*sizeof(struct
signalfd_siginfo)), in which case we return -EINVAL.

This seems inconsistent.


Also, I'm desperately hunting for the place where we zero out that local
siginfo_t, and I ain't finding it.  Someone please convince me that we're
not leaking bits of kernel memory out to userspace in that thing.


