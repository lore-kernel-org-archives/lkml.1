Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYGOVPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYGOVPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbYGOVOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:14:32 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33419 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755318AbYGOVOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:14:30 -0400
Message-Id: <20080715211430.040646000@polaris-admin.engr.sgi.com>
References: <20080715211429.454823000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jul 2008 14:14:33 -0700
From: Mike Travis <travis@sgi.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Dean Nelson <dcn@sgi.com>
Subject: [PATCH 4/8] cpumask: Optimize cpumask_of_cpu in drivers/misc/sgi-xp/xpc_main.c
Content-Disposition: inline; filename=optimize-cpu_mask_of_cpu-in-drivers_misc_sgi-xp_xpc_main_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Optimize various places where a pointer to the cpumask_of_cpu value
    will result in reducing stack pressure.

Based on linux-2.6.tip/master at the following commit:

    commit 0a91813e16ebd5c2d9b5c2acd5b7c91742112c4f
    Merge: 9a635fa... 724dce0...
    Author: Ingo Molnar <mingo@elte.hu>
    Date:   Tue Jul 15 14:55:17 2008 +0200

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Dean Nelson <dcn@sgi.com>
---
 drivers/misc/sgi-xp/xpc_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.tip.orig/drivers/misc/sgi-xp/xpc_main.c
+++ linux-2.6.tip/drivers/misc/sgi-xp/xpc_main.c
@@ -229,10 +229,11 @@ xpc_hb_checker(void *ignore)
 	int last_IRQ_count = 0;
 	int new_IRQ_count;
 	int force_IRQ = 0;
+	cpumask_of_cpu_ptr(cpumask, XPC_HB_CHECK_CPU);
 
 	/* this thread was marked active by xpc_hb_init() */
 
-	set_cpus_allowed(current, cpumask_of_cpu(XPC_HB_CHECK_CPU));
+	set_cpus_allowed_ptr(current, cpumask);
 
 	/* set our heartbeating to other partitions into motion */
 	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);

-- 
