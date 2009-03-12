Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZCLAyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZCLAyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbZCLAyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:54:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40656 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZCLAyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:54:12 -0400
Date: Thu, 12 Mar 2009 09:52:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Subject: [RFC][PATCH 0/5] memcg softlimit (Another one) v4
Message-Id: <20090312095247.bf338fe8.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, this is a patch for implemnt softlimit to memcg.

I did some clean up and bug fixes. 

Anyway I have to look into details of "LRU scan algorithm" after this.

How this works:

 (1) Set softlimit threshold to memcg.
     #echo 400M > /cgroups/my_group/memory.softlimit_in_bytes.

 (2) Define priority as victim.
     #echo 3 > /cgroups/my_group/memory.softlimit_priority.
     0 is the lowest, 8 is the highest.
     If "8", softlimit feature ignore this group.
     default value is "8".

 (3) Add some memory pressure and make kswapd() work.
     kswapd will reclaim memory from victims paying regard to priority.

Simple test on my 2cpu 86-64 box with 1.6Gbytes of memory (...vmware)

  While a process malloc 800MB of memory and touch it and sleep in a group,
  run kernel make -j 16 under a victim cgroup with softlimit=300M, priority=3.

  Without softlimit => 400MB of malloc'ed memory are swapped out.
  With softlimit    =>  80MB of malloc'ed memory are swapped out. 

I think 80MB of swap is from direct memory reclaim path. And this
seems not to be terrible result.

I'll do more test on other hosts. Any comments are welcome.

Thanks,
-Kame

