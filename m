Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab0BRIIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 03:08:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57398 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0BRIIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 03:08:42 -0500
To: Anton Blanchard <anton@samba.org>
Cc: arun@linux.vnet.ibm.com, tglx@linutronix.de, davem@davemloft.net,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       venkatesh.pallipadi@intel.com
Subject: Re: NO_HZ migration of TCP ack timers
From: Andi Kleen <andi@firstfloor.org>
References: <20100218052820.GD24270@kryten>
Date: Thu, 18 Feb 2010 09:08:35 +0100
In-Reply-To: <20100218052820.GD24270@kryten> (Anton Blanchard's message of "Thu, 18 Feb 2010 16:28:20 +1100")
Message-ID: <87mxz755ks.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Blanchard <anton@samba.org> writes:

> echo 0 > /proc/sys/kernel/timer_migration
>
> makes the problem go away.
>
> I think the problem is the CPU is most likely to be idle when an rx networking
> interrupt comes in. It seems the wrong thing to do to migrate any ack timers
> off the current cpu taking the interrupt, and with enough networks we train
> wreck transferring everyones ack timers to the nohz load balancer cpu. 

If the nohz balancer CPU is otherwise idle, shouldn't it have enough
cycles to handle acks for everyone? Is the problem the cache line
transfer time?

But yes if it's non idle the migration might need to spread out 
to more CPUs.

>
> What should we do? Should we use mod_timer_pinned here? Or is this an issue

Sounds like something that should be controlled by the cpufreq governour's
idle predictor? Only migrate if predicted idle time is long enough.
It's essentially the same problem as deciding how deeply idle to put
a CPU. Heavy measures only pay off if the expected time is long enough.

> other areas might see (eg the block layer) and we should instead avoid
> migrating timers created out of interrupts.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
