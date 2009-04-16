Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbZDPUA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbZDPUA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 16:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbZDPUAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 16:00:19 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:54758 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756973AbZDPUAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 16:00:18 -0400
Date: Thu, 16 Apr 2009 15:53:09 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org
Subject: Scheduler regression: Too frequent timer interrupts(?)
Message-ID: <alpine.DEB.1.10.0904161539130.23632@qirst.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.22 the Linux scheduler interrupts programs with increasing
frequency. The interrupts cause run time variances that are affecting HPC
jobs. Various low latency jobs show increasing runtimes because of these
additional interrupts by the scheduler.

In the following test a simple program was run that continually retrieves
TSC and measures the times between the TSC retrievals. A run time variance
is noted whenever the time between two TSC retrievals is larger than 1
usec (on a 3.3Ghz Xeon box quad cores dual processor). The numbers given
are the interrupts occuring in a 10 second measurement period. The tests
can be downloaded from http://gentwo.org/ll .


Kernel		Test 1	Test 2	Test 3	Variances(SUM)
2.6.22		383	540	667	1590
2.6.23		2738	2019	2303	7060
2.6.24		2503	573	583	3659
2.6.25		302	359	241	902
2.6.26		2503	2501	2503	7507
2.6.27		2502	2503	2478	7483
2.6.28		2502	2504	2502	7508
2.6.29		2502	2490	2503	7495
2.6.30-rc2	2504	2503	2502	7509

The kernel was compiled with high res timer support and a HZ of 250.

The 2.6.22 kernel has only about 38.3 disruptions per second. That likely
means that HRTIMER is able to eliminate the timer interrupt.

In .23 this is no longer possible and we get the full number of 250 timer
interrupts per second. Fixed again in .25 but .26 looses it again.

Can we restore the .22 situation where a running task without any
competitor on the same cpu does not need the timer interrupt?

