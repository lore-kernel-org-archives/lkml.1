Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZJIJvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZJIJvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZJIJvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:51:41 -0400
Received: from mga06.intel.com ([134.134.136.21]:48120 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750771AbZJIJvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:51:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,531,1249282800"; 
   d="scan'208";a="455938508"
Subject: tbench regression with 2.6.32-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Oct 2009 17:51:29 +0800
Message-Id: <1255081889.25078.42.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing with 2.6.31's results, tebench has some regression with
2.6.32-rc1.
COmmandline to start tbench:
#./tbench_srv &
#./tbench -t 600 CPU_NUM*2 127.0.0.1  #Use real cpu num to replace CPU_NUM
So start 2 client processes per cpu.

1) On 4*4 core tigerton: 30%;
2) On 2*4 core stoakley: 15%;
3) On 2*8 core Nehalem: 6%.

As there are couple of patches which try to turn on/off some sched domain
flags such like SD_BALANCE_WAKE, I used some walkaround to bisect it.
On tigerton, below patch is captured. 
commit 59abf02644c45f1591e1374ee7bb45dc757fcb88
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Wed Sep 16 08:28:30 2009 +0200

    sched: Add SD_PREFER_LOCAL


The patch reverting is not clean, so I did some testing by turning on/off
some domain flags and sched_feaures manually.

1) On tigerton: if SD_PREFER_LOCAL=0 (disable it), the regression becomes about 2%.
2) On stoakley: if ﻿SD_PREFER_LOCAL=0 (disable it), the regression becomes about 4%.
3) On Nehalem: Above method couldn't improve result. I'm still checking it.

I also tried to turn on/off﻿ FAIR_SLEEPERS and GENTLE_FAIR_SLEEPERS. It seems they
has limited impact on tbench. I need double check these 2 flags.


