Return-Path: <linux-kernel-owner+w=401wt.eu-S1764069AbYEFRd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764069AbYEFRd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756551AbYEFRdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:33:16 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34184 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbYEFRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:31:30 -0400
Date: Tue, 6 May 2008 11:31:29 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506173128.GM19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506102153.5484c6ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 10:21:53AM -0700, Andrew Morton wrote:
> Do we actually know that the locks code is implicated in this regression?

Not yet.  We don't even know it's the BKL.  It's just my best guess.
We're waiting for the original reporter to run some tests Ingo pointed
him at.

> I'd initially thought "lseek" but afaict tmpfs doesn't hit default_llseek()
> or remote_llseek().

Correct.

> Finally: how come we regressed by swapping the semaphore implementation
> anyway?  We went from one sleeping lock implementation to another - I'd
> have expected performance to be pretty much the same.
> 
> <looks at the implementation>
> 
> down(), down_interruptible() and down_try() should use spin_lock_irq(), not
> irqsave.

We talked about this ... the BKL actually requires that you be able to
acquire it with interrupts disabled.  Maybe we should make lock_kernel
do this:

	if (likely(!depth)) {
		unsigned long flags;
		local_save_flags(flags);
		down();
		local_irq_restore(flags);
	}

But tweaking down() is not worth it -- we should be eliminating users of
both the BKL and semaphores instead.

> up() seems to be doing wake-one, FIFO which is nice.  Did the
> implementation which we just removed also do that?  Was it perhaps
> accidentally doing LIFO or something like that?

That's a question for someone who knows x86 assembler, I think.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
