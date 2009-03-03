Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbZCCSNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbZCCSNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZCCSNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:13:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZCCSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:13:04 -0500
Subject: Re: Regression - locking (all from 2.6.28)
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jan sonnek <ha2nny@gmail.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, Catalin Marinas <catalin.marinas@arm.com>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <20090302121127.e46dc4be.akpm@linux-foundation.org>
References: <49AC334A.9030800@gmail.com>
	 <20090302121127.e46dc4be.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 03 Mar 2009 19:12:41 +0100
Message-Id: <1236103961.5330.5108.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-02 at 12:11 -0800, Andrew Morton wrote:

> > Mar  1 00:07:03 localhost kernel: [   86.440261] =========================================================
> > Mar  1 00:07:03 localhost kernel: [   86.440266] [ INFO: possible irq lock inversion dependency detected ]
> > Mar  1 00:07:03 localhost kernel: [   86.440271] 2.6.29-rc6-mm1-hanny #17
> > Mar  1 00:07:03 localhost kernel: [   86.440273] ---------------------------------------------------------
> 
> I stared at this for a while, but my brain broke trying to work out
> what lockdep is trying to tell us.
> 
> > Mar  1 00:07:03 localhost kernel: [   86.440277] Xorg/2733 just changed the state of lock:
> > Mar  1 00:07:03 localhost kernel: [   86.440280]  (fasync_lock){.-....}, at: [<c01952bb>] kill_fasync+0x20/0x3a
> > Mar  1 00:07:03 localhost kernel: [   86.440292] but this lock took another, HARDIRQ-READ-irq-unsafe lock in the past:
> > Mar  1 00:07:03 localhost kernel: [   86.440296]  (&f->f_lock){+.+...}
> 
> This message needs help.  A lock cannot "take" another lock. 

It seemed a simple enough way to tell that the latter lock nests inside
the former lock.

So what its saying is that we have:

  fasync_lock
    f->f_lock

nesting, and fasync_lock got used in hardirq context, but the lock that
was previously found to nest inside, was an IRQ-unsafe lock.

So $CODE code take f->f_lock, then IRQ could happen and fasync_lock,
f->f_lock could happen and we'd be stuck.

Would something like:

"but this lock had a %s-irq-unsafe nestee in the past:" read better?

> And why
> is f_lock described as "HARDIRQ-READ-irq-unsafe"?  It's a spinlock and
> the "READ" part is not relevant.

I think that's a bug due to the recent irq state tracking generalization
patches, will hunt.

> > Mar  1 00:07:03 localhost kernel: [   86.440299] 
> > Mar  1 00:07:03 localhost kernel: [   86.440300] and interrupts could create inverse lock ordering between them.
> > Mar  1 00:07:03 localhost kernel: [   86.440302] 



