Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYEFSJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYEFSJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYEFSJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:09:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbYEFSI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:08:58 -0400
Date: Tue, 6 May 2008 11:07:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: matthew@wil.cx, bfields@citi.umich.edu, yanmin_zhang@linux.intel.com,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-Id: <20080506110752.ca54623f.akpm@linux-foundation.org>
In-Reply-To: <20080506174954.GB9014@elte.hu>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu>
	<20080506120934.GH19219@parisc-linux.org>
	<20080506162332.GI19219@parisc-linux.org>
	<20080506102153.5484c6ac.akpm@linux-foundation.org>
	<20080506173128.GM19219@parisc-linux.org>
	<20080506174954.GB9014@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 19:49:54 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > > down(), down_interruptible() and down_try() should use 
> > > spin_lock_irq(), not irqsave.
> > 
> > We talked about this ... the BKL actually requires that you be able to 
> > acquire it with interrupts disabled. [...]
> 
> hm, where does it require it, besides the early bootup code? (which 
> should just be fixed)

Yeah, the early bootup code.  The kernel does accidental lock_kernel()s in
various places and if that renables interrupts then powerpc goeth crunch.

Matthew, that seemingly-unneeded irqsave in lib/semaphore.c is a prime site
for /* one of these things */, no?

> down_trylock() is OK as irqsave/irqrestore for legacy reasons, but that 
> is fundamentally atomic anyway.

yes, trylock should be made irq-safe.

> > > up() seems to be doing wake-one, FIFO which is nice.  Did the 
> > > implementation which we just removed also do that?  Was it perhaps 
> > > accidentally doing LIFO or something like that?
> > 
> > That's a question for someone who knows x86 assembler, I think.
> 
> the assembly is mostly just for the fastpath - and a 40% regression 
> cannot be about fastpath differences. In the old code the scheduling 
> happens in lib/semaphore-sleeper.c, and from the looks of it it appears 
> to be a proper FIFO as well. (plus this small wakeup weirdness it has)
> 
> i reviewed the new code in kernel/semaphore.c as well and can see 
> nothing bad in it - it does proper wake-up, FIFO queueing, like the 
> mutex code.
> 

There's the weird wakeup in down() which I understood for about five
minutes five years ago.  Perhaps that accidentally sped something up.
Oh well, more investigation needed..
