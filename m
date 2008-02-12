Return-Path: <linux-kernel-owner+w=401wt.eu-S1755592AbYBLWIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592AbYBLWIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYBLWIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:08:45 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:8983 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYBLWIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:08:44 -0500
Message-ID: <47B218E9.7040405@hp.com>
Date: Tue, 12 Feb 2008 17:08:41 -0500
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       npiggin@suse.de, dgc@sgi.com, arjan@linux.intel.com
Subject: Re: IO queueing and complete affinity w/ threads: Some results
References: <47B0B69B.1050807@hp.com>
In-Reply-To: <47B0B69B.1050807@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back on the 32-way, in this set of tests we're running 12 disks spread out through the 8 cells of the 32-way. Each disk will have an Ext2 FS placed on it, a clean Linux kernel source untar()ed onto it, then a full make (-j4) and then a make clean performed. The 12 series are done in parallel - so each disk will have:

mkfs
tar x
make
make clean

performed. This was performed ten times, and the overall averages are presented below - note this is Jens' original patch sequence NOT the kthread one (those results available tomorrow, hopefully). 

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

Hopefully, the first column is self-explanatory - these are the settings applied to the queue_affinity, completion_affinity and rq_affinity tunables. Due to the fact that the standard deviations are so large coupled with the very close average results, I'm not seeing anything in this set of tests to favor any of the combinations...

As noted, I will be having the machine run the kthreads-variant of the patch stream tonight, and then I have to go back and run a non-patched kernel to see if there are any /regressions/. 

Alan

