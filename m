Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYBKU5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYBKU5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:57:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbYBKU5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:57:09 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:20765 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbYBKU5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:57:08 -0500
Message-ID: <47B0B69B.1050807@hp.com>
Date: Mon, 11 Feb 2008 15:56:59 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, npiggin@suse.de, dgc@sgi.com,
       arjan@linux.intel.com
Subject: IO queueing and complete affinity w/ threads: Some results
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test case chosen may not be a very good start, but anyways, here are some initial test results with the "nasty arch bits". This was performed on a 32-way ia64 box with 1 terrabyte of RAM, and 144 FC disks (contained in 24 HP MSA1000 RAID controlers attached to 12 dual-port adapters). Each test case was run for 3 minutes. I had one application per device performing a large amount of direct/asynchronous large reads. Here's the table of results, with explanation below (results are for all 144 devices either accumulated (MBPS) or averaged (other columns)):

A Q C |  MBPS   Avg Lat StdDev |  Q-local Q-remote | C-local C-remote
----- | ------ -------- ------ | -------- -------- | ------- --------
X X X | 3859.9 1.190067 0.0502 |      0.0  19484.7 |     0.0   9758.8
X X A | 3856.3 1.191220 0.0490 |      0.0  19467.2 |     0.0   9750.1
X X I | 3850.3 1.192992 0.0508 |      0.0  19437.3 |  9735.1      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
X A X | 3853.9 1.191891 0.0503 |  19455.4      0.0 |     0.0   9744.2
X A A | 3853.5 1.191935 0.0507 |  19453.2      0.0 |     0.0   9743.1
X A I | 3856.6 1.191043 0.0512 |  19468.7      0.0 |  9750.8      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
X I X | 3854.7 1.191674 0.0491 |      0.0  19459.8 |     0.0   9746.4
X I A | 3855.3 1.191434 0.0501 |      0.0  19461.9 |     0.0   9747.4
X I I | 3856.2 1.191128 0.0506 |      0.0  19466.6 |  9749.8      0.0
===== | ====== ======== ====== | ======== ======== | ======= ========
I X X | 3857.0 1.190987 0.0500 |      0.0  19471.9 |     0.0   9752.5
I X A | 3856.5 1.191082 0.0496 |      0.0  19469.4 |  9751.2      0.0
I X I | 3853.7 1.191938 0.0500 |      0.0  19456.2 |  9744.6      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
I A X | 3854.8 1.191675 0.0502 |  19461.5      0.0 |     0.0   9747.2
I A A | 3855.1 1.191464 0.0503 |  19464.0      0.0 |  9748.5      0.0
I A I | 3854.9 1.191627 0.0483 |  19461.7      0.0 |  9747.4      0.0
----- | ------ -------- ------ | -------- -------- | ------- --------
I I X | 3853.4 1.192070 0.0484 |  19454.8      0.0 |     0.0   9743.9
I I A | 3852.2 1.192403 0.0502 |  19448.5      0.0 |  9740.8      0.0
I I I | 3854.0 1.191822 0.0499 |  19457.9      0.0 |  9745.5      0.0
===== | ====== ======== ====== | ======== ======== | ======= ========
rq=0  | 3854.8 1.191680 0.0480 |  19459.7      0.0 |   202.9   9543.5
rq=1  | 3854.0 1.191965 0.0483 |  19457.0      0.0 |   403.1   9341.9
----- | ------ -------- ------ | -------- -------- | ------- --------

The variables being played with:

'A' - When set to X the application was placed on a CPU other than the one handling IRQs for the device (in another cell)

'Q' - When set to X, queue affinity was placed in another cell from the application OR completion OR IRQ, when set to 'A' it was pegged onto the same CPU as the application, when set to 'I' it was set to the CPU that was managing the IRQ for its device.

'C' - Likewise for the completion affinity: 'X' means on another cell besides the one containing the application or the queueing or the IRQ handling CPU, A means put on the same CPU as the application, and I means put on the same CPU as the IRQ handler.

o  For the last two rows, we set Q == C == -1, and let the application go to any CPU (as dictated by the scheduler). Then we had 'rq_affinity' set to 0 or 1.

The resulting columns include:

MBPS - Total megabytes per second (so we're seeing about 3.8 gigabytes per second for the system)
Avg lat - Average per IO measured latency in seconds (note: I had upwards of 128 X 256K IOs going on per device across the system)
StdDev - Average standard deviation across the devices

Q-local & Q-remote refer to the average number of queue operations handled locally and remotely, respectively. (Average per device)
C-local & C-remote refer to the average number of completion operations handled locally and remotely, respectively. (Average per device)

As noted above, I'm not so sure this is the best test case - it's rather artificial, I was hoping to see some differences based upon affinitization, but whilst there appears to be some trends, the results are so close (0.2% difference from best to worst case MBPS, and the standard deviation on the latencies are +/- within the groups), I doubt there is anything definitive. Unfortunately, most of the disks are all being used for real data right now, so I can't perform significant write tests (with file systems in place, say) which would be more real-worldly. I do have access to about 24 of the disks, so I will try to place file system on those and do some tests. [I won't be able to use XFS without going through some hoops - its a Red Hat installation right now, and they don't support XFS out of the box...] 

BTW: The Q/C local/remote columns were put in place to make sure that I had things set up right, and for the first 18 cases I think they look right. For the RQ cases at the end, I /think/ what is happening is that on occasion we end up with the application on the CPU that had the IRQ handler, and that would cause us to some times be local - but most of the time (due to the pseudo-random nature of the initial process placement) we'd end up elsewhere from the IRQ handling CPU, and thus end up with remoting the queue/complete handling... The disparity between the Q & C results are due to merging - we issue (and hence complete) less IOs than are submitted to the block IO layer (here it looks to be about 2-to-1).

Alan

