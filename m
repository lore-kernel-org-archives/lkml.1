Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbZHLQXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbZHLQXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZHLQXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:23:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43345 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754207AbZHLQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:23:34 -0400
Date: Wed, 12 Aug 2009 12:23:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
In-Reply-To: <1250092711.4000.33.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.0908121216500.9635-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, James Bottomley wrote:

> This all boils down to "the race window for a deadlock may be narrower".
> 
> Instead of training programmers to narrow deadlock races, we should be
> training them to avoid them.
> 
> The entangled deadlock problem occurs in all of our _sync() APIs as well
> as interrupt and other workqueue stuff.
> 
> The rules are something like
> 
> Never use synchronous operations if you can avoid them.  If you must use
> operations that wait for another thread to complete (say because you're
> about to destroy data structures that queued elements may be using):
>      1. Never hold any locks or mutexes while waiting for the completion
>         of synchronous operations
>      2. If you have to hold a lock while waiting:
>              1. If it's a global lock, make sure you're using a local
>                 queue and that nothing you submitted to the queue can
>                 take the lock
>              2. If it's a local lock, you may use a global queue but
>                 must still make sure that nothing you submitted to the
>                 queue can take the lock.

I haven't seen these rules written down anywhere in the kernel 
documentation.  Presumably people are supposed to be aware of them 
already?

Anyway, 2.1 and 2.2 are wrong.  They should read: "... make sure that
nothing submitted to the queue calls any of your routines that can take
the lock."  The point being that even though _you_ don't submit
anything bad to the queue, somebody else might do so.

If you use cancel_work_sync() instead of flush_scheduled_work() then 
the rules become less onerous.  In place of your 2.1 and 2.2, we have:

	Make sure the work item you are cancelling cannot take
	the lock.

This is much easier to verify.

Alan Stern

