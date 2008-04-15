Return-Path: <linux-kernel-owner+w=401wt.eu-S1764338AbYDOMrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764338AbYDOMrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbYDOMrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:47:37 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:1893 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbYDOMrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:47:36 -0400
Message-ID: <4804A3E4.1060605@hp.com>
Date: Tue, 15 Apr 2008 08:47:32 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: Block IO: more io-cpu-affinity results
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a 4-way IA64 box we are seeing definite improvements in overall
system responsiveness w/ the patch series currently in Jens'
io-cpu-affinity branch on his block IO git repository. In this
microbenchmark, I peg 4 processes to 4 separate processors: 2 are doing
CPU-intensive work (sqrts) and 2 are doing IO-intensive work (4KB direct
reads from RAID array cache - thus limiting physical disk accesses).

There are 2 variables: whether rq_affinity is on or off for the devices
under test for the IO-intensive procs, and whether the IO-intensive
procs are pegged onto the same CPU as is handling IRQs for its device.
The results are averaged over 4-minute runs per permutation.

When the IO-intensive procs are pegged onto the CPU that is handling
IRQs for its device, we see no real difference between rq_affinity on or
off:

rq=0 local=1     66.616 (M sqrt/sec)   12.312 (K ios/sec)
rq=1 local=1     66.616 (M sqrt/sec)   12.314 (K ios/sec)

Both see 66.616 million sqrts per second, and 12,300 IOs per second.

However, when we move the 2 IO-intensive threads onto CPUs that are not
handling its IRQs, we see a definite improvement - both in terms of the
amount of CPU-intensive work we can do (about 4%), as well as the number
of IOs per second achieved (about 1%):

rq=0 local=0     61.929 (M sqrt/sec)   11.911 (K ios/sec)
rq=1 local=0     64.386 (M sqrt/sec)   12.026 (K ios/sec)

Alan

