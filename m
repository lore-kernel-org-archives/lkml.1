Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280AbZG1RTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280AbZG1RTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZG1RSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:53 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:30398 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753930AbZG1RSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:23 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i87h203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DS-03-BM6-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 21/26] x86/oprofile: Enable multiplexing only if the model supports it
Date: Tue, 28 Jul 2009 19:07:21 +0200
Message-ID: <1248800846-25422-22-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:50.0947 (UTC) FILETIME=[55F3B330:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch checks if the model supports multiplexing. Only then
multiplexing will be enabled. The code is added to the common x86
initialization.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index dca7240..f0fb447 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -258,6 +258,12 @@ static int nmi_switch_event(void)
 	return 0;
 }
 
+static inline void mux_init(struct oprofile_operations *ops)
+{
+	if (has_mux())
+		ops->switch_events = nmi_switch_event;
+}
+
 #else
 
 inline int op_x86_phys_to_virt(int phys) { return phys; }
@@ -265,6 +271,7 @@ static inline void nmi_shutdown_mux(void) { }
 static inline int nmi_setup_mux(void) { return 1; }
 static inline void
 nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs) { }
+static inline void mux_init(struct oprofile_operations *ops) { }
 
 #endif
 
@@ -682,9 +689,6 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	ops->start		= nmi_start;
 	ops->stop		= nmi_stop;
 	ops->cpu_type		= cpu_type;
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	ops->switch_events	= nmi_switch_event;
-#endif
 
 	if (model->init)
 		ret = model->init(ops);
@@ -694,6 +698,8 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	if (!model->num_virt_counters)
 		model->num_virt_counters = model->num_counters;
 
+	mux_init(ops);
+
 	init_sysfs();
 	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
-- 
1.6.3.3


