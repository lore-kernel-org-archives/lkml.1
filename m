Return-Path: <linux-kernel-owner+w=401wt.eu-S1760109AbZDQHAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760109AbZDQHAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbZDQHAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:00:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47969 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbZDQHAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:00:30 -0400
Subject: Re: Scheduler regression: Too frequent timer interrupts(?)
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
References: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 09:00:13 +0200
Message-Id: <1239951613.23397.4107.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-16 at 15:53 -0400, Christoph Lameter wrote:
> Since 2.6.22 the Linux scheduler interrupts programs with increasing
> frequency. The interrupts cause run time variances that are affecting HPC
> jobs. Various low latency jobs show increasing runtimes because of these
> additional interrupts by the scheduler.
> 
> In the following test a simple program was run that continually retrieves
> TSC and measures the times between the TSC retrievals. A run time variance
> is noted whenever the time between two TSC retrievals is larger than 1
> usec (on a 3.3Ghz Xeon box quad cores dual processor). The numbers given
> are the interrupts occuring in a 10 second measurement period. The tests
> can be downloaded from http://gentwo.org/ll .
> 
> 
> Kernel		Test 1	Test 2	Test 3	Variances(SUM)
> 2.6.22		383	540	667	1590
> 2.6.23		2738	2019	2303	7060
> 2.6.24		2503	573	583	3659
> 2.6.25		302	359	241	902
> 2.6.26		2503	2501	2503	7507
> 2.6.27		2502	2503	2478	7483
> 2.6.28		2502	2504	2502	7508
> 2.6.29		2502	2490	2503	7495
> 2.6.30-rc2	2504	2503	2502	7509
> 
> The kernel was compiled with high res timer support and a HZ of 250.
> 
> The 2.6.22 kernel has only about 38.3 disruptions per second. That likely
> means that HRTIMER is able to eliminate the timer interrupt.

This has never been true afaikt, as long as we have a task running, we
take the interrupt, I just looked at the .22 code and that certainly
expects the scheduler_tick() to be called when there is a running
process.

Also, look at /proc/interrupts if you want to determine interrupt
frequency.

