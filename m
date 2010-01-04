Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411Ab0ADDOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0ADDOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383Ab0ADDOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:14:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:43287 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab0ADDOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:14:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,496,1257148800"; 
   d="scan'208";a="480967067"
Date: Mon, 4 Jan 2010 05:49:05 -0500
From: "Youquan,Song" <youquan.song@linux.intel.com>
To: hpa@zytor.com, tglx@linutronix.de, akpm@linux-foundation.org
Cc: venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       kent.liu@intel.com, chaohong.guo@intel.com, youquan.song@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]tickless: Fix tick nohz timer irq0 fail to increaase
Message-ID: <20100104104905.GA30574@youquan-linux.bj.intel.com>
References: <20091214130233.GA3898@youquan-linux.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214130233.GA3898@youquan-linux.bj.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tickless is disabled by nohz=off, which is used in OSVs. But in current kernel,
if tickless is disabled, the timer irq0 will not increase. Because the timer 
event handler should be tick_handle_periodic, but actually event handler keep 
as tick_handle_oneshot_broadcast which is used in tickless. The root cause is
that it is default to enable high resolution timer which will force to oneshot
 broadcast mode.

This patch add tickless enable check before enable high resolution timer

On Nehalem-EX:

Before the patch:
linux-a25n:~ # cat /proc/interrupts | grep timer
   0:        334          0          0          0          0          0 ....
 LOC:     192248     193931     193851     184441     193803     193625 ....

After the patch:
cat /proc/interrupts | grep timer
   0:     223788          0          0          0          0          0 ....
 LOC:      13081     238407     238452     229405     238298     235688 ....

Signed-off-by: Youquan, Song <youquan.song@intel.com>
---


diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f992762..a515bed 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -815,7 +815,7 @@ int tick_check_oneshot_change(int allow_nohz)
 	if (!timekeeping_valid_for_hres() || !tick_is_oneshot_available())
 		return 0;
 
-	if (!allow_nohz)
+	if (!allow_nohz && tick_nohz_enabled)
 		return 1;
 
 	tick_nohz_switch_to_nohz();
