Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbXJATx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbXJATx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXJATxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:53:20 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:37284 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbXJATxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:53:19 -0400
Date: Mon, 1 Oct 2007 12:52:56 -0700
From: Zach Brown <zach.brown@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>, mingo@goodmis.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [HACK] convert i_alloc_sem for direct_io.c craziness!
Message-ID: <20071001195256.GB7718@mami.zabbo.net>
References: <Pine.LNX.4.58.0709241700290.13164@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0709241700290.13164@gandalf.stny.rr.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hopefully I will get some attention from those that are responsible for
> fs/direct_io.c

[ many days later, I find this amongst the lkml noise. ]

> This patch converts the i_alloc_sem into a compat_rw_semaphore for the -rt
> patch.  Seems that the code in fs/direct_io.c does some nasty logic with
> the i_alloc_sem.  For DIO_LOCKING, I'm assuming that the i_alloc_sem is
> used as a reference counter for pending requests. When the request is
> made, the down_read is performed. When the request is handled by the block
> softirq, then that softirq does an up on the request. So the owner is not
> the same between down and up. When all requests are handled, the semaphore
> counter should be zero. This keeps away any write access while requests
> are pending.

Yeah.  This is used for performing concurrent asynchronous O_DIRECT
operations.

> This patch converts (for now) the i_alloc_sem into a compat_rw_semaphore
> to give back the old features to the sem. This fixes deadlocks that we've
> been having WRT direct_io.

*nod*

> The real fix would be to get rid of the read semaphore trickery in
> direct_io.c.

Do you have any suggestions for locking constructs that RT would prefer?

The core problem is that async IO is in flight while no process holds
the usual locks in system calls.  We don't want the blocks referenced by
IOs to be freed and realocated some where else while the IO is in
flight.  Hence the i_alloc_sem acquiry in the file block modification
paths: vmtruncate - free, notify_change - a proxy for allocating writes.

The agents are:

- many tasks issuing concurrent async IO and exiting from system calls
while the IO is still in flight

- operations completed in interrupt handlers from storage devices

- tasks changing file block mapping via system calls

There's some long-term work to integrate the locking between the
buffered and O_DIRECT paths, but it's not close to ready.

- z
