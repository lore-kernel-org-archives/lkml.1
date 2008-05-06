Return-Path: <linux-kernel-owner+w=401wt.eu-S1763460AbYEFRW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763460AbYEFRW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbYEFRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:22:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755906AbYEFRWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:22:41 -0400
Date: Tue, 6 May 2008 10:21:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ingo Molnar <mingo@elte.hu>, "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-Id: <20080506102153.5484c6ac.akpm@linux-foundation.org>
In-Reply-To: <20080506162332.GI19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang>
	<20080506114449.GC32591@elte.hu>
	<20080506120934.GH19219@parisc-linux.org>
	<20080506162332.GI19219@parisc-linux.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 10:23:32 -0600 Matthew Wilcox <matthew@wil.cx> wrote:

> On Tue, May 06, 2008 at 06:09:34AM -0600, Matthew Wilcox wrote:
> > So the only likely things I can see are:
> > 
> >  - file locks
> >  - fasync
> 
> I've wanted to fix file locks for a while.  Here's a first attempt.

Do we actually know that the locks code is implicated in this regression?

I'd initially thought "lseek" but afaict tmpfs doesn't hit default_llseek()
or remote_llseek().

tmpfs tends to do weird stuff - it would be interesting to know if the
regression is also present on ramfs or ext2/ext3/xfs/etc.

It would be interesting to see if the context switch rate has increased.

Finally: how come we regressed by swapping the semaphore implementation
anyway?  We went from one sleeping lock implementation to another - I'd
have expected performance to be pretty much the same.

<looks at the implementation>

down(), down_interruptible() and down_try() should use spin_lock_irq(), not
irqsave.

up() seems to be doing wake-one, FIFO which is nice.  Did the
implementation which we just removed also do that?  Was it perhaps
accidentally doing LIFO or something like that?

