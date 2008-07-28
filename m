Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYG1WhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYG1WhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYG1WhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:37:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41480
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751270AbYG1WhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:37:03 -0400
Date: Mon, 28 Jul 2008 15:37:02 -0700 (PDT)
Message-Id: <20080728.153702.103032029.davem@davemloft.net>
To: mingo@elte.hu
CC: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: combinatorial explosion in lockdep
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As Peter and some others have known I've been trying to track down a
full system wedge that occurs early in the userland boot on sparc64
Niagara systems when lockdep is enabled.  This has been happening
since I first added sparc64 lockdep support, the problem has always
been there.

Some fiddling around recently showed that booting with max_cpus=16
allowed the system to fully boot, albeit very slowly.

That was a clue.

My suspicion became that somehow the number of active runqueues
contributes to the problem.

Also, the problem seems to occur when udev is forked off to
load driver modules.

So I added a piece of debugging that would capture all cpu's program
counters and initial backtrace even if they had interrupts disabled,
when the softlockup watchdog triggers.  Then I lowered the softlockup
watchdog threshold to only a few seconds so that I could more quickly
trigger the dumps.

The triggering event seems to be kstopmachine as done by the first
module load.  This seems to create the situation where we do double RQ
locking on essentially all the run queues, in order to move the
kstopmachine threads around to their proprer cpus.  I think this is
what starts to make the lockdep dependency chains huge.

Then, all the cpus wedge trying to grab a particular RQ lock, with one
of the cpus cycling seemingly endlessly in find_usage_backwards().

At first I thought we were getting killed by recurion on sparc64.
After going 8 or more entries deep, every recursive call or return
from such a call will write or read 128 bytes from the stack for
the window spill/fill traps sparc uses to manage the register windows.
So I rewrote find_usage_{backwards/forwards} and check_usage() to
use iteration instead of recurion.

The problem persisted, and I was still seeing one of the cpus spending
tons of time in find_usage_backwards().

So I added debugging to count how many lock_class entries are visited
in a single top-level invocation of find_usage_{backwards,forwards}()
and then I printed out this information when the softlockup watchdog
triggered.

We find:

[ 1287.450897] BUG: max_forwards_checks[73290] max_backwards_checks[56968881]
[ 1287.456186] BUG: max_forwards_class --> (&rq->rq_lock_key#3){++..}
[ 1287.461866] BUG: max_backwards_class --> (&rt_b->rt_runtime_lock){+...}

Just under 57 million lock_class entries visited in a single top-level
find_usage_backwards() call, on rt_b->rt_runtime_lock.  No wonder the
machine grinds to a halt :-)

And on the forwards side, the winner is the suspected runqueue lock,
but it's not as bad as the backwards chain from the rt_runtime_lock.

I'm still digging on what exactly makes this happen, but I wanted to
get the information out as soon as I had something useful like this.
