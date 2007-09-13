Return-Path: <linux-kernel-owner+w=401wt.eu-S932077AbXIMVaz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbXIMVaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:30:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbXIMVar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:30:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797AbXIMVap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:30:45 -0400
Message-ID: <46E9ABFF.7080200@redhat.com>
Date: Thu, 13 Sep 2007 17:30:39 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Venkat Subbiah <venkats@cranite.com>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: irq load balancing
References: <3641F7C576757E49AE23AD0D820D72C434DCB8@mailnode1.cranite.com>
In-Reply-To: <3641F7C576757E49AE23AD0D820D72C434DCB8@mailnode1.cranite.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Venkat Subbiah wrote:
> Since most network devices have a single status register for both
> receiver and transmit (and errors and the like), which needs a lock to
> protect access, you will likely end up with serious thrashing of moving
> the lock between cpus.
>> Any ways to measure the trashing of locks?
> 
> Since most network devices have a single status register for both
> receiver and transmit (and errors and the like)
>> These register accesses will be mostly within the irq handler which I
> plan on keeping on the same processor. The network driver is actually
> tg3. Will looks closely into the driver.

Why are you trying to do this, anyway?  This is a classic example of fairness 
hurting both performance and efficiency.  Unbalanced distribution of a single 
IRQ gives superior performance.  There are cases when this is a worthwhile 
tradeoff, but the network stack is not one of them.  In the HPC world, people 
generally want to squeeze maximum performance out of CPU/cache/RAM so they just 
accept the imbalance because it performs better than balancing it, and 
irqbalance can keep things fair over longer intervals if that's important.  In 
the realtime world, people generally bind everything they can to one or two 
CPUs, and bind their realtime applications to the remaining ones to minimize 
contention.

Distributing your network interrupts in a round-robin fashion will make your 
computer do exactly one thing faster: heat up the room.

	-- Chris
