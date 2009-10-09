Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbZJIKRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbZJIKRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760622AbZJIKRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:17:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:53523 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760538AbZJIKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:17:21 -0400
Subject: Re: tbench regression with 2.6.32-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1255081889.25078.42.camel@ymzhang>
References: <1255081889.25078.42.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Oct 2009 12:16:40 +0200
Message-Id: <1255083400.8802.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 17:51 +0800, Zhang, Yanmin wrote:
> Comparing with 2.6.31's results, tebench has some regression with
> 2.6.32-rc1.
> COmmandline to start tbench:
> #./tbench_srv &
> #./tbench -t 600 CPU_NUM*2 127.0.0.1  #Use real cpu num to replace CPU_NUM
> So start 2 client processes per cpu.
> 
> 1) On 4*4 core tigerton: 30%;
> 2) On 2*4 core stoakley: 15%;
> 3) On 2*8 core Nehalem: 6%.
> 
> As there are couple of patches which try to turn on/off some sched domain
> flags such like SD_BALANCE_WAKE, I used some walkaround to bisect it.
> On tigerton, below patch is captured. 
> commit 59abf02644c45f1591e1374ee7bb45dc757fcb88
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Wed Sep 16 08:28:30 2009 +0200
> 
>     sched: Add SD_PREFER_LOCAL
> 
> 
> The patch reverting is not clean, so I did some testing by turning on/off
> some domain flags and sched_feaures manually.
> 
> 1) On tigerton: if SD_PREFER_LOCAL=0 (disable it), the regression becomes about 2%.
> 2) On stoakley: if ﻿SD_PREFER_LOCAL=0 (disable it), the regression becomes about 4%.
> 3) On Nehalem: Above method couldn't improve result. I'm still checking it.
> 
> I also tried to turn on/off﻿ FAIR_SLEEPERS and GENTLE_FAIR_SLEEPERS. It seems they
> has limited impact on tbench. I need double check these 2 flags.

So the c2q cpus, and esp the one with smaller cache hurt from this. I
guess we can turn this off without too much down sides. Maybe turn it on
for NUMA on the nehalem?


---
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 25a9284..d823c24 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -143,6 +143,7 @@ extern unsigned long node_remap_size[];
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
+				| 1*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
diff --git a/include/linux/topology.h b/include/linux/topology.h
index fc0bf3e..57e6357 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -129,7 +129,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_PREFER_LOCAL			\
+				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
@@ -162,7 +162,7 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_PREFER_LOCAL			\
+				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\


