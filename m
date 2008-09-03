Return-Path: <linux-kernel-owner+w=401wt.eu-S1755748AbYICGxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748AbYICGxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbYICGxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:53:19 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:52651 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808AbYICGxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:53:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=foP+tVynCRxDdmUQfjzUZxeFtAu2PTxSwITSVJ2BE1YYwCsGcMR2eIDhnOLJaTISkG
         OSpny6fD4LHB1Cn4cyYlW67nPrDWzXR4qw30euPPI3JZD6dl3LU/jEV9UOlSxbeiOfrs
         5tmzSYlwG+oYumpLyIEuwULDdbE2kmJnyKJXs=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 3/5] x86: make 32bit support show_msr like 64 bit
Date: Tue,  2 Sep 2008 23:52:59 -0700
Message-Id: <1220424781-17752-3-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220424781-17752-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220424781-17752-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/common.c |   51 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -616,6 +616,49 @@ void __cpuinit identify_secondary_cpu(st
 	mtrr_ap_init();
 }
 
+struct msr_range {
+	unsigned min;
+	unsigned max;
+};
+
+static struct msr_range msr_range_array[] __cpuinitdata = {
+	{ 0x00000000, 0x00000418},
+	{ 0xc0000000, 0xc000040b},
+	{ 0xc0010000, 0xc0010142},
+	{ 0xc0011000, 0xc001103b},
+};
+
+static void __cpuinit print_cpu_msr(void)
+{
+	unsigned index;
+	u64 val;
+	int i;
+	unsigned index_min, index_max;
+
+	for (i = 0; i < ARRAY_SIZE(msr_range_array); i++) {
+		index_min = msr_range_array[i].min;
+		index_max = msr_range_array[i].max;
+		for (index = index_min; index < index_max; index++) {
+			if (rdmsrl_amd_safe(index, &val))
+				continue;
+			printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
+		}
+	}
+}
+
+static int show_msr __cpuinitdata;
+static __init int setup_show_msr(char *arg)
+{
+	int num;
+
+	get_option(&arg, &num);
+
+	if (num > 0)
+		show_msr = num;
+	return 1;
+}
+__setup("show_msr=", setup_show_msr);
+
 static __init int setup_noclflush(char *arg)
 {
 	setup_clear_cpu_cap(X86_FEATURE_CLFLSH);
@@ -644,6 +687,14 @@ void __cpuinit print_cpu_info(struct cpu
 		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
 	else
 		printk(KERN_CONT "\n");
+
+#ifdef CONFIG_SMP
+	if (c->cpu_index < show_msr)
+		print_cpu_msr();
+#else
+	if (show_msr)
+		print_cpu_msr();
+#endif
 }
 
 static __init int setup_disablecpuid(char *arg)
