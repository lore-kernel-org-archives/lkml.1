Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbXDIFi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbXDIFi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 01:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbXDIFi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 01:38:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:57592 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752962AbXDIFiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 01:38:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18L9UMqb+ULYRpLPnKNfKMyAV1KNa7QB2pVZkr4R3
	TWU0DuVPmzprPx
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Ed Tomlinson <edt@aei.ca>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704080909.00472.edt@aei.ca>
References: <200703290237.38777.kernel@kolivas.org>
	 <20070406100333.GA19855@elte.hu> <200704071650.43905.kernel@kolivas.org>
	 <200704080909.00472.edt@aei.ca>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 07:38:21 +0200
Message-Id: <1176097101.6355.89.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-08 at 09:08 -0400, Ed Tomlinson wrote:
> Hi,
> 
> I am one of those who have been happily testing Con's patches.  
> 
> They work better than mainline here.

(I tried a UP kernel yesterday, and even a single kernel build would
make noticeable hitches if I move a window around. YMMV etc.)

> If one really needs some sort of interactivity booster (I do not with SD), why
> not move it into user space?  With SD it would be simple enough to export
> some info on estimated latency.  With this user space could make a good
> attempt to keep latency within bounds for a set of tasks just by renicing.... 

I don't think you can have very much effect on latency using nice with
SD once the CPU is fully utilized.  See below.

/*
 * This contains a bitmap for each dynamic priority level with empty slots
 * for the valid priorities each different nice level can have. It allows
 * us to stagger the slots where differing priorities run in a way that
 * keeps latency differences between different nice levels at a minimum.
 * ie, where 0 means a slot for that priority, priority running from left to
 * right:
 * nice -20 0000000000000000000000000000000000000000
 * nice -10 1001000100100010001001000100010010001000
 * nice   0 0101010101010101010101010101010101010101
 * nice   5 1101011010110101101011010110101101011011
 * nice  10 0110111011011101110110111011101101110111
 * nice  15 0111110111111011111101111101111110111111
 * nice  19 1111111111111111111011111111111111111111
 */

Nice allocates bandwidth, but as long as the CPU is busy, tasks always
proceed downward in priority until they hit the expired array.  That's
the design.  If X gets busy and expires, and a nice 20 CPU hog wakes up
after it's previous rotation has ended, but before the current rotation
is ended (ie there is 1 task running at wakeup time), X will take a
guaranteed minimum 160ms latency hit (quite noticeable) independent of
nice level.  The only way to avoid it is to use a realtime class.

A nice -20 task has maximum bandwidth allocated, but that also makes it
a bigger target for preemption from tasks at all nice levels as it
proceeds downward toward expiration.  AFAIKT, low latency scheduling
just isn't possible once the CPU becomes 100% utilized, but it is
bounded to runqueue length.  In mainline OTOH, a nice -20 task will
always preempt a nice 0 task, giving it instant gratification, and
latency of lower priority tasks is bounded by the EXPIRED_STARVING(rq)
safety net.

	-Mike

