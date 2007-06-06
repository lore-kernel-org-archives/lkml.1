Return-Path: <linux-kernel-owner+w=401wt.eu-S1763926AbXFFR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763926AbXFFR3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbXFFR3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:29:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46512 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754678AbXFFR3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:29:09 -0400
Date: Wed, 6 Jun 2007 10:28:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: markh@compro.net
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Mark Hounschell <dmarkh@cfl.rr.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: floppy.c soft lockup
Message-Id: <20070606102828.752bf955.akpm@linux-foundation.org>
In-Reply-To: <4666B2A4.7090603@compro.net>
References: <20070531192256.GA88@tv-sign.ru>
	<465F2D96.9060502@compro.net>
	<20070601110058.GA83@tv-sign.ru>
	<466028DB.3060509@compro.net>
	<20070601151605.GA108@tv-sign.ru>
	<4660534E.6050903@cfl.rr.com>
	<20070601183642.GA92@tv-sign.ru>
	<466078FF.2080508@cfl.rr.com>
	<20070602123030.GA719@tv-sign.ru>
	<4661D698.5040009@cfl.rr.com>
	<20070603081417.GA81@tv-sign.ru>
	<46641B16.9090701@compro.net>
	<4666B2A4.7090603@compro.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 09:12:04 -0400 Mark Hounschell <markh@compro.net> wrote:

> > 
> > As far as a 100% CPU bound task being a valid thing to do, it has been 
> > done for many years on SMP machines. Any kernel limitation on this 
> > surely must be considered a bug? 
> > 
> 
> Could someone authoritatively comment on this? Is a SCHED_RR/SCHED_FIFO
> 100% Cpu bound process supported in an SMP env on Linux? (vanilla or -rt)

It will kill the kernel, sorry.

The only way in which we can fix that is to allow kernel threads to preempt
rt-priority userspace threads.  But if we were to do that (to benefit the
few) it would cause _all_ people's rt-prio processes to experience glitches
due to kernel activity, which we believe to be worse.

So we're between a rock and a hard place here.

If we really did want to solve this then I guess the kernel would need some
new code to detect a 100%-busy rt-prio process and to then start premitting
preemption of it for kernel thread activity.  That detector would need to
be smart enough to detect a number of 100%-busy rt-prio processes which are
yielding to each other, and one rt-prio process which keeps forking others,
etc.  It might get tricky.
