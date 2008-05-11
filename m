Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYEKLMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYEKLMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 07:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYEKLLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 07:11:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34018 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbYEKLLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 07:11:53 -0400
Date: Sun, 11 May 2008 05:11:36 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, bfields@citi.umich.edu,
       yanmin_zhang@linux.intel.com, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080511111136.GQ19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org> <20080506173128.GM19219@parisc-linux.org> <20080506174954.GB9014@elte.hu> <20080506110752.ca54623f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506110752.ca54623f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 11:07:52AM -0700, Andrew Morton wrote:
> Yeah, the early bootup code.  The kernel does accidental lock_kernel()s in
> various places and if that renables interrupts then powerpc goeth crunch.
> 
> Matthew, that seemingly-unneeded irqsave in lib/semaphore.c is a prime site
> for /* one of these things */, no?

I was just reviewing the code and I came across one of these:

/*
 * Some notes on the implementation:
 *
 * The spinlock controls access to the other members of the semaphore.
 * down_trylock() and up() can be called from interrupt context, so we
 * have to disable interrupts when taking the lock.  It turns out various
 * parts of the kernel expect to be able to use down() on a semaphore in
 * interrupt context when they know it will succeed, so we have to use
 * irqsave variants for down(), down_interruptible() and down_killable()
 * too.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
