Return-Path: <linux-kernel-owner+w=401wt.eu-S1765133AbYBMPgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765133AbYBMPgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbYBMPgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:36:11 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:17488 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbYBMPgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:36:09 -0500
Message-ID: <47B30E5F.2060008@hp.com>
Date: Wed, 13 Feb 2008 10:35:59 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, npiggin@suse.de, dgc@sgi.com,
       arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
References: <47B0B69B.1050807@hp.com>
In-Reply-To: <47B0B69B.1050807@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparative results between the original affinity patch and the kthreads-based patch on the 32-way running the kernel make sequence. 

It may be easier to compare/contrast with the graphs provided at http://free.linux.hp.com/~adb/jens/kernmk.png (kernmk.agr also provided, if you want to run xmgrace by hand). 

Tests are:

1. Make Ext2 FS on each of 12 64GB devices in parallel, times include: mkfs, mount & unmount
2. Untar a full Linux source code tree onto the devices in parallel, times include: mount, untar, unmount
3. Make (-j4) of the full source code tree, times include: mount, make -j4, unmount
4. Clean full source code tree, times include: mount, make clean, unmount

The results are so close amongst all the runs (given the large-ish standard deviations), that we probably can't deduce much from this. A bit of a concern on the top two graphs - mkfs & untar - it certainly appears that the kthreads version is a little slower (about 2.9% difference across the values for the mkfs runs, and 3.5% for the untar operations). On the make runs, however, we didn't see hardly any difference between the runs at all...

We are trying to setup to do some AIM7 tests on a different system over the weekend (15 February - 18 February 2008), I'll post those results on the 18th or 19th if we can pull it off. [I'll also try to steal time on the 32-way to run a straight 2.6.24 kernel, do these runs again, and post those results.]

For the tables below:

 q0 == queue_affinity set to -1
 q1 == queue_affinity set to the CPU managing the IRQ for each device
 c0 == completion_affinity set to -1
 c1 == completion_affinity set to CPU managing the IRQ for each device
rq0 == rq_affinity set to 0
rq1 == rq_affinity set to 1

This 4-test sequence was run 10 times (for each kernel), and results averaged. As posted yesterday, here's the original patch sequence results:

mkfs        Min     Avg     Max   Std Dev 
--------- ------- ------- ------- -------
q0.c0.rq0  17.814  30.322  33.263   4.551 
q0.c0.rq1  17.540  30.058  32.885   4.321 
q0.c1.rq0  17.770  31.328  32.958   3.121 
q1.c0.rq0  17.907  31.032  32.767   3.515 
q1.c1.rq0  16.891  30.319  33.097   4.624 

untar       Min     Avg     Max   Std Dev 
--------- ------- ------- ------- -------
q0.c0.rq0  19.747  21.971  26.292   1.215 
q0.c0.rq1  19.680  22.365  36.395   2.010 
q0.c1.rq0  18.823  21.390  24.455   0.976 
q1.c0.rq0  18.433  21.500  23.371   1.009 
q1.c1.rq0  19.414  21.761  34.115   1.378 

make        Min     Avg     Max   Std Dev 
--------- ------- ------- ------- -------
q0.c0.rq0 527.418 543.296 552.030   5.384 
q0.c0.rq1 526.265 542.312 549.477   5.467 
q0.c1.rq0 528.935 544.940 553.823   4.746 
q1.c0.rq0 529.432 544.399 553.212   5.166 
q1.c1.rq0 527.638 543.577 551.323   5.478 

clean       Min     Avg     Max   Std Dev 
--------- ------- ------- ------- -------
q0.c0.rq0  16.962  20.308  33.775   3.179 
q0.c0.rq1  17.436  20.156  29.370   3.097 
q0.c1.rq0  17.061  20.111  31.504   2.791 
q1.c0.rq0  16.745  20.247  29.327   2.953 
q1.c1.rq0  17.346  20.316  31.178   3.283 

And for the kthreads-based kernel:

mkfs        Min     Avg     Max   Std Dev 
--------- ------- ------- ------- -------
q0.c0.rq0  16.686  31.069  33.361   3.452 
q0.c0.rq1  16.976  31.719  32.869   2.395 
q0.c1.rq0  16.857  31.345  33.410   3.209 
q1.c0.rq0  17.317  31.997  34.444   3.099 
q1.c1.rq0  16.791  32.266  33.378   2.035 

untar       Min     Avg     Max   Std Dev 
--------- ------- ------- ------- -------
q0.c0.rq0  19.769  22.398  25.196   1.076 
q0.c0.rq1  19.742  22.517  38.498   1.733 
q0.c1.rq0  20.071  22.698  36.160   2.259 
q1.c0.rq0  19.910  22.377  35.640   1.528 
q1.c1.rq0  19.448  22.339  24.887   0.926 

make        Min     Avg     Max   Std Dev 
--------- ------- ------- ------- -------
q0.c0.rq0 526.971 542.820 550.591   4.607 
q0.c0.rq1 527.320 544.422 550.504   3.798 
q0.c1.rq0 527.367 543.856 550.331   4.152 
q1.c0.rq0 527.406 543.636 552.947   4.315 
q1.c1.rq0 528.921 544.594 550.832   3.786 

clean       Min     Avg     Max   Std Dev 
--------- ------- ------- ------- -------
q0.c0.rq0  16.644  20.242  29.524   2.991 
q0.c0.rq1  16.942  20.008  29.729   2.845 
q0.c1.rq0  17.205  20.117  29.851   2.661 
q1.c0.rq0  17.400  20.147  32.581   2.862 
q1.c1.rq0  16.799  20.072  31.883   2.872 


