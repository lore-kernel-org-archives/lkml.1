Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYAIJiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYAIJiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472AbYAIJhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:37:54 -0500
Received: from mga10.intel.com ([192.55.52.92]:25740 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753381AbYAIJhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:37:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,261,1196668800"; 
   d="scan'208";a="490805146"
Subject: Netperf TCP_RR(loopback) 10% regression in 2.6.24-rc6, comparing
	with 2.6.22
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 09 Jan 2008 17:35:30 +0800
Message-Id: <1199871330.3298.132.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regression is:
1)stoakley with 2 qual-core processors: 11%;
2)Tulsa with 4 dual-core(+hyperThread) processors:13%;

The test command is:
#sudo taskset -c 7 ./netserver
#sudo taskset -c 0 ./netperf -t TCP_RR -l 60 -H 127.0.0.1 -i 50,3 -I 99,5 -- -r 1,1

As a matter of fact, 2.6.23 has about 6% regression and 2.6.24-rc's
regression is between 16%~11%.

I tried to use bisect to locate the bad patch between 2.6.22 and 2.6.23-rc1,
but the bisected kernel wasn't stable and went crazy.

I tried both CONFIG_SLUB=y and CONFIG_SLAB=y to make sure SLUB isn't the
culprit.

The oprofile data of CONFIG_SLAB=y. Top cpu utilizations are:
1) 2.6.22 
2067379   9.4888  vmlinux                  schedule
1873604   8.5994  vmlinux                  mwait_idle
1568131   7.1974  vmlinux                  resched_task
1066976   4.8972  vmlinux                  tcp_v4_rcv
986641    4.5285  vmlinux                  tcp_rcv_established
979518    4.4958  vmlinux                  find_busiest_group
767069    3.5207  vmlinux                  sock_def_readable
736808    3.3818  vmlinux                  tcp_sendmsg
595889    2.7350  vmlinux                  task_rq_lock
557193    2.5574  vmlinux                  tcp_ack
470570    2.1598  vmlinux                  __mod_timer
392220    1.8002  vmlinux                  __alloc_skb
358106    1.6436  vmlinux                  skb_release_data
313372    1.4383  vmlinux                  skb_clone

2) 2.6.24-rc7
2668426  12.4497  vmlinux                  vmlinux                  schedule
955698    4.4589  vmlinux                  vmlinux                  skb_release_data
836311    3.9018  vmlinux                  vmlinux                  tcp_v4_rcv
762398    3.5570  vmlinux                  vmlinux                  skb_release_all
728907    3.4007  vmlinux                  vmlinux                  task_rq_lock
705037    3.2894  vmlinux                  vmlinux                  __wake_up
694206    3.2388  vmlinux                  vmlinux                  __mod_timer
617616    2.8815  vmlinux                  vmlinux                  mwait_idle

It looks like tcp in 2.6.22 sends more packets, but frees far less skb than 2.6.24-rc6.
tcp_rcv_established in 2.6.22 is highlighted on cpu utilization.

-yanmin


