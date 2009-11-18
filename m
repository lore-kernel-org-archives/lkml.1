Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbZKRNXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbZKRNXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbZKRNXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:23:18 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:11438 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466AbZKRNXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:23:18 -0500
Subject: Re: [RFC] Block IO Controller V3 - some results
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-EsZdOURgoDTkQRcReTN5"
Date: Wed, 18 Nov 2009 08:22:58 -0500
Message-ID: <1258550578.2797.15.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EsZdOURgoDTkQRcReTN5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Vivek -

Here are the results w/ Jens' for-2.6.33 branch + your V3 +

http://groups.google.com/group/linux.kernel/browse_thread/thread/3b62f0665f0912b6/34ec9456c7da1bb7?lnk=raot

(slightly modified to work w/ V3 - see attached patch). These runs also
use direct I/O - a new fio job file looks like:

[global]
size=8g
overwrite=0
runtime=120
ioengine=libaio
iodepth=128
iodepth_low=128
iodepth_batch=128
iodepth_batch_complete=32
direct=1
bs=256k
readwrite=write
[/mnt/sdl/data.7]
filename=/mnt/sdl/data.7

I need to do a base run (no ioc patches) to see how that looks w/ direct
I/O - will start that today, but won't get to the results until later
(vacation day today...). 

We'll know more when I get the base runs done.

As before: i1==ioc control enabled, g0=group_idle=1(default),
g1=group_idle=0, s8=slice_idle=8(default), s0=slice_idle=0.

---- ---- - --------- --------- --------- --------- 
Mode RdWr N i1,g1,s8  i1,g0,s8  i1,g1,s0  i1,g0,s0  
---- ---- - --------- --------- --------- --------- 
rnd  rd   2      33.7      33.2      33.2      33.2 
rnd  rd   4      28.6      26.8      26.7      26.7 
rnd  rd   8      20.8      17.6      17.8      17.7 

rnd  wr   2      57.4      55.8      55.9      55.8 
rnd  wr   4      52.1      47.8      47.6      47.6 
rnd  wr   8      41.6      30.8      30.7      30.7 

rnd  rdwr 2      39.0      38.3      38.3      38.5 
rnd  rdwr 4      33.2      30.5      30.4      30.7 
rnd  rdwr 8      24.0      19.0      19.2      19.5 

seq  rd   2     609.5     609.6     608.4     608.5 
seq  rd   4     612.1     612.3     613.5     613.7 
seq  rd   8     614.8     615.4     616.3     616.2 

seq  wr   2     716.2     722.7     732.2     736.9 
seq  wr   4     710.5     734.2     737.4     734.4 
seq  wr   8     700.6     714.0     720.1     715.8 

seq  rdwr 2     666.7     669.1     673.4     673.1 
seq  rdwr 4     668.1     668.5     667.5     667.9 
seq  rdwr 8     674.0     674.9     675.6     676.2 

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
i1,g1,s8    rnd  rd   2  11.1  22.6 
i1,g1,s8    rnd  rd   4   0.8   2.6  10.4  14.8 
i1,g1,s8    rnd  rd   8   0.4   0.7   1.0   1.4   2.0   3.2   5.3   6.8 

i1,g1,s8    rnd  wr   2  12.2  45.3 
i1,g1,s8    rnd  wr   4   0.6   1.3  16.7  33.5 
i1,g1,s8    rnd  wr   8   0.3   0.5   0.7   0.9   1.4   2.2  11.7  24.0 

i1,g1,s8    rnd  rdwr 2  12.6  26.4 
i1,g1,s8    rnd  rdwr 4   0.7   2.2  12.3  18.0 
i1,g1,s8    rnd  rdwr 8   0.3   0.5   0.8   1.2   1.8   3.5   7.1   8.7 


i1,g1,s8    seq  rd   2 234.7 374.8 
i1,g1,s8    seq  rd   4  89.7 130.1 171.8 220.4 
i1,g1,s8    seq  rd   8  34.7  59.1  65.2  74.6  85.4  89.8  97.9 108.1 

i1,g1,s8    seq  wr   2 264.4 451.9 
i1,g1,s8    seq  wr   4  98.4 151.5 203.8 256.8 
i1,g1,s8    seq  wr   8  37.7  65.0  74.3  86.5  96.0 102.8 113.7 124.6 

i1,g1,s8    seq  rdwr 2 240.0 426.7 
i1,g1,s8    seq  rdwr 4  92.3 139.5 191.0 245.3 
i1,g1,s8    seq  rdwr 8  33.7  59.7  68.0  80.2  94.1 103.2 111.9 123.3 

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
i1,g0,s8    rnd  rd   2  12.1  21.1 
i1,g0,s8    rnd  rd   4   2.2   5.8   8.1  10.7 
i1,g0,s8    rnd  rd   8   1.2   1.3   1.6   2.2   2.3   2.5   3.1   3.4 

i1,g0,s8    rnd  wr   2  21.1  34.7 
i1,g0,s8    rnd  wr   4  11.9  12.2  11.9  11.9 
i1,g0,s8    rnd  wr   8   4.0   4.0   4.0   3.9   3.8   3.7   3.7   3.6 

i1,g0,s8    rnd  rdwr 2  13.9  24.3 
i1,g0,s8    rnd  rdwr 4   3.1   7.5   9.3  10.5 
i1,g0,s8    rnd  rdwr 8   1.5   1.6   1.8   2.2   2.5   2.7   3.4   3.3 


i1,g0,s8    seq  rd   2 264.1 345.4 
i1,g0,s8    seq  rd   4  92.7 133.2 169.1 217.3 
i1,g0,s8    seq  rd   8  41.5  64.5  67.1  76.1  85.0  84.6  91.0 105.5 

i1,g0,s8    seq  wr   2 319.1 403.6 
i1,g0,s8    seq  wr   4 108.4 164.0 210.2 251.6 
i1,g0,s8    seq  wr   8  50.8  72.3  78.5  87.3  94.2  99.9 109.0 122.0 

i1,g0,s8    seq  rdwr 2 267.4 401.7 
i1,g0,s8    seq  rdwr 4  94.0 138.5 191.8 244.3 
i1,g0,s8    seq  rdwr 8  38.9  61.5  72.2  83.0  95.1 100.1 106.0 118.1 

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
i1,g1,s0    rnd  rd   2  12.1  21.1 
i1,g1,s0    rnd  rd   4   2.4   6.3   8.4   9.5 
i1,g1,s0    rnd  rd   8   1.0   1.4   1.7   2.1   2.5   2.7   3.1   3.4 

i1,g1,s0    rnd  wr   2  21.8  34.1 
i1,g1,s0    rnd  wr   4  12.6  12.4  11.4  11.2 
i1,g1,s0    rnd  wr   8   5.0   4.5   3.9   3.7   3.5   3.4   3.4   3.3 

i1,g1,s0    rnd  rdwr 2  14.1  24.2 
i1,g1,s0    rnd  rdwr 4   3.6   7.7   9.0  10.1 
i1,g1,s0    rnd  rdwr 8   1.2   1.7   1.9   2.2   2.4   2.8   3.3   3.8 

i1,g1,s0    seq  rd   2 299.7 308.7 
i1,g1,s0    seq  rd   4 102.6 159.5 171.3 180.2 
i1,g1,s0    seq  rd   8  60.2  71.0  61.8  65.6  73.4  87.3  96.9 100.3 

i1,g1,s0    seq  wr   2 351.3 380.9 
i1,g1,s0    seq  wr   4 119.1 181.9 206.2 230.2 
i1,g1,s0    seq  wr   8  63.9  74.9  74.0  81.3  92.2 101.3 111.7 120.8 

i1,g1,s0    seq  rdwr 2 296.1 377.4 
i1,g1,s0    seq  rdwr 4  99.8 137.6 188.5 241.7 
i1,g1,s0    seq  rdwr 8  53.9  64.7  70.5  82.5  92.9  92.5 102.0 116.6 

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
i1,g0,s0    rnd  rd   2  12.3  20.9 
i1,g0,s0    rnd  rd   4   2.6   6.5   7.8   9.8 
i1,g0,s0    rnd  rd   8   1.0   1.4   1.7   2.1   2.4   2.7   3.2   3.4 

i1,g0,s0    rnd  wr   2  21.7  34.2 
i1,g0,s0    rnd  wr   4  13.8  11.9  11.1  10.8 
i1,g0,s0    rnd  wr   8   5.1   4.5   3.9   3.6   3.5   3.4   3.3   3.3 

i1,g0,s0    rnd  rdwr 2  14.1  24.4 
i1,g0,s0    rnd  rdwr 4   3.9   7.6   8.4  10.8 
i1,g0,s0    rnd  rdwr 8   1.1   1.6   1.9   2.3   2.6   3.0   3.3   3.6 

i1,g0,s0    seq  rd   2 300.0 308.5 
i1,g0,s0    seq  rd   4 101.8 160.1 171.4 180.4 
i1,g0,s0    seq  rd   8  61.3  71.7  61.3  65.6  73.9  85.5  96.4 100.4 

i1,g0,s0    seq  wr   2 354.1 382.8 
i1,g0,s0    seq  wr   4 117.6 182.2 206.1 228.4 
i1,g0,s0    seq  wr   8  64.5  75.1  75.7  81.3  90.3 100.4 110.0 118.5 

i1,g0,s0    seq  rdwr 2 297.8 375.3 
i1,g0,s0    seq  rdwr 4 100.1 137.8 190.6 239.3 
i1,g0,s0    seq  rdwr 8  54.4  64.1  71.1  81.9  92.7  93.0 103.2 115.9 

--=-EsZdOURgoDTkQRcReTN5
Content-Disposition: attachment; filename="corrado_patch.txt"
Content-Type: text/plain; name="corrado_patch.txt"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

--- a/block/cfq-iosched.c	2009-11-17 15:47:50.000000000 -0500
+++ b/block/cfq-iosched.c	2009-11-17 15:50:38.000000000 -0500
@@ -234,8 +234,17 @@ struct cfq_data {
 	 */
 	int rq_queued;
 	int hw_tag;
-	int hw_tag_samples;
-	int rq_in_driver_peak;
+
+	/*
+	 * hw_tag can be
+	 * -1 => indeterminate, (cfq will behave as if NCQ is present,
+	 *			 to allow better detection)
+	 *  1 => NCQ is present (hw_tag_est_depth is the estimated max depth)
+	 *  0 => no NCQ
+	 */
+	int hw_tag_est_depth;
+	unsigned int hw_tag_samples;
+
 
 	/*
 	 * idle window management
@@ -3199,8 +3208,11 @@ static void cfq_update_hw_tag(struct cfq
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 
-	if (rq_in_driver(cfqd) > cfqd->rq_in_driver_peak)
-		cfqd->rq_in_driver_peak = rq_in_driver(cfqd);
+	if (rq_in_driver(cfqd) > cfqd->hw_tag_est_depth)
+		cfqd->hw_tag_est_depth = rq_in_driver(cfqd);
+
+	if (cfqd->hw_tag == 1)
+		return;
 
 	if (cfqd->rq_queued <= CFQ_HW_QUEUE_MIN &&
 	    rq_in_driver(cfqd) <= CFQ_HW_QUEUE_MIN)
@@ -3219,13 +3231,10 @@ static void cfq_update_hw_tag(struct cfq
 	if (cfqd->hw_tag_samples++ < 50)
 		return;
 
-	if (cfqd->rq_in_driver_peak >= CFQ_HW_QUEUE_MIN)
+	if (cfqd->hw_tag_est_depth >= CFQ_HW_QUEUE_MIN)
 		cfqd->hw_tag = 1;
 	else
 		cfqd->hw_tag = 0;
-
-	cfqd->hw_tag_samples = 0;
-	cfqd->rq_in_driver_peak = 0;
 }
 
 static void cfq_completed_request(struct request_queue *q, struct request *rq)
@@ -3661,7 +3670,7 @@ static void *cfq_init_queue(struct reque
 	cfqd->cfq_slice_idle = cfq_slice_idle;
 	cfqd->cfq_latency = 1;
 	cfqd->cfq_group_idle = 1;
-	cfqd->hw_tag = 1;
+	cfqd->hw_tag = -1;
 	cfqd->last_end_sync_rq = jiffies;
 	return cfqd;
 }

--=-EsZdOURgoDTkQRcReTN5--

