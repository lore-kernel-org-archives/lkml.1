Return-Path: <linux-kernel-owner+w=401wt.eu-S1751119AbZH1EWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751119AbZH1EWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbZH1EWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:22:35 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57388 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbZH1EWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:22:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Aug 2009 13:20:15 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 0/5] memcg: reduce lock conetion
Message-Id: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently, memcg's res_counter->lock contention on big server is reported and
Balbir wrote a workaround for root memcg.
It's good but we need some fix for children, too.

This set is for reducing lock conetion of memcg's children cgroup based on mmotm-Aug27.

I'm sorry I have only 8cpu machine and can't reproduce very troublesome lock conention.
Here is lock_stat of make -j 12 on my 8cpu box, befre-after this patch series.

[Before] time make -j 12 (Best time in 3 test)
real    2m55.170s
user    4m38.351s
sys     6m40.694s
lock_stat version 0.3
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                              class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

                          &counter->lock:       1793728        1824383           0.90       16599.78     1255869.40       24879507       44909568           0.45       31183.88    19505982.15
                          --------------
                          &counter->lock         999561          [<ffffffff81099224>] res_counter_charge+0x94/0x140
                          &counter->lock         824822          [<ffffffff8109911c>] res_counter_uncharge+0x3c/0xb0
                          --------------
                          &counter->lock         835597          [<ffffffff8109911c>] res_counter_uncharge+0x3c/0xb0
                          &counter->lock         988786          [<ffffffff81099224>] res_counter_charge+0x94/0x140

you can see this by "head" ;)

[After] time make -j 12 (Best time in 3 test..but score was very stable.)
real    2m52.612s
user    4m45.450s
sys     6m4.422s

                          &counter->lock:         11159          11406           1.02          30.35        6707.74        1097940        3957860           0.47       17652.17     1534430.74
                          --------------
                          &counter->lock           2016          [<ffffffff810991bd>] res_counter_charge+0x4d/0x110
                          &counter->lock           9390          [<ffffffff81099115>] res_counter_uncharge+0x35/0x90
                          --------------
                          &counter->lock           8962          [<ffffffff81099115>] res_counter_uncharge+0x35/0x90
                          &counter->lock           2444          [<ffffffff810991bd>] res_counter_charge+0x4d/0x110

dcache-lock, zone->lru_lock etc is much heavier than this.


I expects good result on big servers.

But this patch sereis is a  "big change". I (and memcg folks) have to be careful...


Thanks,
-Kame




