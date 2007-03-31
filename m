Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbXCaB0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbXCaB0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 21:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933286AbXCaB0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 21:26:23 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58445 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933285AbXCaB0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 21:26:22 -0400
Date: Fri, 30 Mar 2007 18:26:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [patch 10/13] signal/timer/event fds v8 - eventfd core ...
Message-Id: <20070330182603.5d6817d3.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703301804110.3721@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28743.1174415840.10>
	<20070330124028.c6e54d2e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703301804110.3721@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2007 18:11:55 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:

> 
> > > + */
> > 
> > So it is the caller's responsibility to ensure that *file refers to an
> > eventfd file?
> 
> In which function? I lost you ...
> 

eventfd_signal() assumes that the passed in file* refers to an eventfd
file.  So if a caller passes in a file* for /etc/passwd, the kernel will go
splat.

I guess that's caveat emptor, and any violations of that will show up
quickly in testing.  My main concern would be that there might be some way
for a naughty user to force the kernel to pass a non-eventfd file* into
this function.  That depends upon as-yet-unwritten code - is there a risk
of this happening, and how do we prevent it?

> 
> > > +int eventfd_signal(struct file *file, int n)
> > > +{
> > > +	struct eventfd_ctx *ctx = file->private_data;
> > > +	unsigned long flags;
> > > +
> > > +	if (n < 0)
> > > +		return -EINVAL;
> > > +	spin_lock_irqsave(&ctx->lock, flags);
> > > +	if (ULLONG_MAX - ctx->count < n)
> > > +		n = (int) (ULLONG_MAX - ctx->count);
> > > +	ctx->count += n;
> > > +	if (waitqueue_active(&ctx->wqh))
> > > +		wake_up_locked(&ctx->wqh);
> > > +	spin_unlock_irqrestore(&ctx->lock, flags);
> > > +
> > > +	return n;
> > > +}
>
>
>
> > > +	DECLARE_WAITQUEUE(wait, current);
> > > +
> > > +	if (count < sizeof(ucnt))
> > > +		return -EINVAL;
> > > +	if (get_user(ucnt, (const __u64 __user *) buf))
> > > +		return -EFAULT;
> > 
> > Some architectures do not implement 64-bit get_user()
> 
> copy_from_user it is, then ...
> 

spose so.  I think architectures _should_ implement 64-bit get_user() and
put_user() nowadays.  So you could leave the code as-is and inform the arch
maintainers, if you're feeling keen.

If all this code has its own Kconfig options then the architectures won't
break until their maintainers come along to enable the new features, so
they'll implement 64-bit get_user() at that time and things will all unfold
in a nicely non-chaotic fashion.

