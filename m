Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYCNMOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYCNMOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 08:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYCNMO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 08:14:29 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:26390 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYCNMO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 08:14:28 -0400
Message-ID: <47DA6C1E.8010000@hp.com>
Date: Fri, 14 Mar 2008 08:14:22 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, npiggin@suse.de, dgc@sgi.com
Subject: IO CPU affinity test results
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning Jens - 

I had two machines running the latest patches hang last night: 

o  2-way AMD64 - I inadvertently left the patched kernel running, and I was moving a ton of data (100+GB) back up over the net to this node. It hard hung (believe it or not) about 99% of the way through. Hard hang, wouldn't respond to anything.

o  4-way IA64 - I was performing a simple test: [mkfs / mount / untar linux sources / make allnoconfig / make -j 5 / umount] repeatedly switching rq_affinity to 0/1 between each run. After 22 passes it had a hard hang with rq_affinity set to 1.

Of course, there is no way of knowing if either hang had anything to do with the patches, but it seems a bit ominous as RQ=1 was set in both cases.

This same test worked fine for 30 passes on a 2-way AMD64 box, with the following results:

Part  RQ   MIN     AVG     MAX      Dev
----- --  ------  ------  ------  ------
 mkfs  0  41.656  41.862  42.086   0.141
 mkfs  1  41.618  41.909  42.270   0.192

untar  0  18.055  19.611  20.906   0.720
untar  1  18.523  19.905  21.988   0.738

 make  0  50.480  50.991  51.752   0.340
 make  1  49.819  50.442  51.000   0.292

 comb  0 110.433 112.464 114.176   0.932
 comb  1 110.694 112.256 114.683   0.948

 psys  0  10.28%  10.91%  11.29%   0.243
 psys  1  10.21%  11.05%  11.80%   0.350


All results are in seconds (as measured by Python's time.time()), except for the psys - which was the average of mpstat's %sys column over the life of the whole run. The mkfs part consisted of [mkfs -t ext2 ; sync ; sync], untar [mount; untar linux sources; umount; sync; sync], make [mount; make allnoconfig; make -j 3; umount; sync; sync], and comb is the combined times of the mkfs, untar and make parts. 

So, in a nutshell, we saw slightly better overall performance, but not conclusively, and we saw slightly elevated %system time to accomplish the task. 

On the 4-way, results were much worse: the final data shown before the system hung showed the rq=1 passes taking significantly longer, albeit at lower %system. I'm going to try the runs again, but I have a feeling that the latest "clean" patch based upon Nick's single call mechanism is a step backwards.

Alan
