Return-Path: <linux-kernel-owner+w=401wt.eu-S965259AbXCICWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259AbXCICWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 21:22:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965267AbXCICWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 21:22:06 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43980 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965259AbXCICWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 21:22:04 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 8 Mar 2007 18:22:00 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 2/5] signalfd v4 - signalfd core ...
In-Reply-To: <Pine.LNX.4.64.0703081707280.3670@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703081820040.3670@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703081707280.3670@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Davide Libenzi wrote:

> +static ssize_t signalfd_read(struct file *file, char *buf, size_t count,
> +			     loff_t *ppos)
> +{
> +	struct signalfd_ctx *ctx = file->private_data;
> +	struct sighand_struct *sighand = ctx->sighand;
> +	ssize_t res = 0;
> +	int signo = 0;
> +	siginfo_t info;
> +	DECLARE_WAITQUEUE(wait, current);
> +
> +	if (count < sizeof(struct signalfd_siginfo))
> +		return -EINVAL;
> +	spin_lock_irq(&sighand->siglock);
> +	if (unlikely(sighand != ctx->tsk->sighand))
> +		goto out_unlock;
> +	res = -EAGAIN;
> +	if ((signo = dequeue_signal(ctx->tsk, &ctx->sigmask, &info)) != 0 &&

Grrr, never change the code after you tested it. The above is clearly:

	if ((signo = dequeue_signal(ctx->tsk, &ctx->sigmask, &info)) == 0 &&
		...



- Davide


