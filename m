Return-Path: <linux-kernel-owner+w=401wt.eu-S933238AbXCaBL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbXCaBL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbXCaBL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:11:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:47599 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259AbXCaBL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:11:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 30 Mar 2007 18:11:55 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch 10/13] signal/timer/event fds v8 - eventfd core ...
In-Reply-To: <20070330124028.c6e54d2e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703301804110.3721@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415840.10>
 <20070330124028.c6e54d2e.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007, Andrew Morton wrote:

> > +struct eventfd_ctx {
> > +	spinlock_t lock;
> > +	wait_queue_head_t wqh;
> > +	__u64 count;
> > +};
> 
> Again, can we borrow wqh.lock?
> 
> `count' needs documentation - these things are key to understanding the
> code.

Added.



> > + */
> 
> So it is the caller's responsibility to ensure that *file refers to an
> eventfd file?

In which function? I lost you ...



> > +int eventfd_signal(struct file *file, int n)
> > +{
> > +	struct eventfd_ctx *ctx = file->private_data;
> > +	unsigned long flags;
> > +
> > +	if (n < 0)
> > +		return -EINVAL;
> > +	spin_lock_irqsave(&ctx->lock, flags);
> > +	if (ULLONG_MAX - ctx->count < n)
> > +		n = (int) (ULLONG_MAX - ctx->count);
> > +	ctx->count += n;
> > +	if (waitqueue_active(&ctx->wqh))
> > +		wake_up_locked(&ctx->wqh);
> > +	spin_unlock_irqrestore(&ctx->lock, flags);
> > +
> > +	return n;
> > +}
> 
> Neither the incoming arg (usefully named "n") nor the return value are
> documented.

Documented now.




> Needs interface documentation, please.  Even the changelog doesn't tell us
> what an EAGAIN return from read() means.

I'll be adding the errno documentation to all of them.




> > +static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t count,
> > +			     loff_t *ppos)
> > +{
> > +	struct eventfd_ctx *ctx = file->private_data;
> > +	ssize_t res;
> > +	__u64 ucnt;
> > +	DECLARE_WAITQUEUE(wait, current);
> > +
> > +	if (count < sizeof(ucnt))
> > +		return -EINVAL;
> > +	if (get_user(ucnt, (const __u64 __user *) buf))
> > +		return -EFAULT;
> 
> Some architectures do not implement 64-bit get_user()

copy_from_user it is, then ...



- Davide


