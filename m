Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYLHNAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYLHNAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 08:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYLHNAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 08:00:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46462 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYLHNAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 08:00:11 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <20081129195357.813D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081128231933.8daef193.akpm@linux-foundation.org> <20081129195357.813D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081208205842.53F8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  8 Dec 2008 22:00:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

verry sorry for late responce.

> > My changelog does not adequately explain the reasons.
> > 
> > But we don't want to rediscover these reasons in early 2010 :(  Some trolling
> > of the linux-mm and lkml archives around those dates might help us avoid
> > a mistake here.
> 
> I hope to digg past discussion archive.
> Andrew, plese wait merge this patch awhile.

I search past archive patiently.
But unfortunately, I don't find the reason at all.

this reverting fix appeared at 2.6.3-mm3 suddenly.

	http://marc.info/?l=linux-kernel&m=107749956707874&w=2

but I don't find related discussion at near month.
So, I guess akpm find anything problem by himself.


Therefore, instead, I'd like to talk about rik patch safeness by mesurement.


1. Checked this patch break reclaim balancing?


run FFSB bench by following conf.
---------------------------------------------------
directio=0
time=300

[filesystem0]
location=/mnt/sdb1/kosaki/ffsb
num_files=20
num_dirs=10
max_filesize=91534338
min_filesize=65535
[end0]

[threadgroup0]
num_threads=10
write_size=2816
write_blocksize=4096
read_size=2816
read_blocksize=4096
create_weight=100
write_weight=30
read_weight=100
[end0]
--------------------------------------------------------

<without patch>


pgscan_kswapd_dma 10624
pgscan_kswapd_normal 20640

        -> normal/dma ratio 20640 / 10624 = 1.9

pgscan_direct_dma 576
pgscan_direct_normal 2528

        -> normal/dma ratio 2528 / 576 = 4.38

<with patch>

pgscan_kswapd_dma    21824
pgscan_kswapd_normal 47424

        -> normal/dma ratio 20640 / 10624 = 2.17

pgscan_direct_dma     1632
pgscan_direct_normal  6912

        -> normal/dma ratio 2528 / 576 = 4.23


The reason is simple.
This patch only works following two case.

  1) Another process freed large memory in direct reclaim processing.
  2) Another process reclaimed large memory in direct reclaim processing.

IOW, its logic doesn't works on typical workload at all.


2. Mesured most benefit case. (IOW, much thread concurrently process swap-out at the same time)

$ ./hackbench 140 process 300  (ten times mesurement)


	2.6.28-rc6   +this patch
	+bail-out
	--------------------------
	62.514        29.270 
	225.698       30.209 
	114.694       20.881 
	179.108       19.795 
	111.080       19.563 
	189.796       19.226 
	114.124       13.330 
	112.999       10.280 
	227.842        9.669 
	81.869        10.113 

avg	141.972       18.234 
std	55.937         7.099 
min	62.514         9.669 
max	227.842       30.209 


	-> about 10 times improvement


3. Mesured worst case (much thread without swap)

mesured following three case. (ten times)

$ ./hackbench 125 process 3000
$ ./hackbench 130 process 3000
$ ./hackbench 135 process 3000


              2.6.28-rc6
            + evice streaming first          + skip freeing memory
            + rvr bail out
            + kosaki bail out improve

nr_group      125     130      135               125     130      135
	    ----------------------------------------------------------
	    67.302   68.269   77.161		89.450   75.328  173.437 
	    72.616   72.712   79.060 		69.843 	 74.145   76.217 
	    72.475   75.712   77.735 		73.531 	 76.426   85.527 
	    69.229   73.062   78.814 		72.472 	 74.891   75.129 
	    71.551   74.392   78.564 		69.423 	 73.517   75.544 
	    69.227   74.310   78.837 		72.543 	 75.347   79.237 
	    70.759   75.256   76.600 		70.477 	 77.848   90.981 
	    69.966   76.001   78.464 		71.792 	 78.722   92.048 
	    69.068   75.218   80.321 		71.313 	 74.958   78.113 
	    72.057   77.151   79.068 		72.306 	 75.644   79.888 

avg	    70.425   74.208   78.462 		73.315 	 75.683   90.612 
std	     1.665    2.348    1.007  	 	 5.516 	  1.514   28.218 
min	    67.302   68.269   76.600 		69.423 	 73.517   75.129 
max	    72.616   77.151   80.321 		89.450 	 78.722  173.437 


	-> 1 - 10% slow down
	   because zone_watermark_ok() is a bit slow function.




