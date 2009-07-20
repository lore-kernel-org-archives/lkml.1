Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbZGTQPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbZGTQPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZGTQN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:13:28 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:26972 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZGTQN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:13:26 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KN3920-04-7DZ-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 07/14] mce3: pass mce info to EDAC for decoding
Date: Mon, 20 Jul 2009 18:12:58 +0200
Message-ID: <1248106385-27514-8-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
References: <1248106385-27514-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 Jul 2009 16:13:13.0577 (UTC) FILETIME=[FB8DFD90:01CA0954]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a weakly defined symbol instead of ugly ifdefs.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    7 +++++++
 drivers/edac/amd64_edac.c        |   16 ++++++++++++++++
 drivers/edac/amd64_edac.h        |    1 +
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 484c1e5..36d986c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -183,6 +183,11 @@ void mce_log(struct mce *mce)
 	set_bit(0, &mce_need_notify);
 }
 
+void __attribute__((weak)) decode_mce(struct mce *m)
+{
+	return;
+}
+
 static void print_mce(struct mce *m)
 {
 	printk(KERN_EMERG
@@ -205,6 +210,8 @@ static void print_mce(struct mce *m)
 	printk(KERN_EMERG "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
 			m->cpuvendor, m->cpuid, m->time, m->socketid,
 			m->apicid);
+
+	decode_mce(m);
 }
 
 static void print_mce_head(void)
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 68c5e6b..af08c9e 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2340,6 +2340,22 @@ void amd64_decode_nb_mce(struct mem_ctl_info *mci, struct err_regs *regs,
 		edac_mc_handle_ue_no_info(mci, "UE bit is set");
 }
 
+void decode_mce(struct mce *m)
+{
+	struct err_regs regs;
+
+	if (m->bank != 4)
+		return;
+
+	regs.nbsl  = (u32) m->status;
+	regs.nbsh  = (u32)(m->status >> 32);
+	regs.nbeal = (u32) m->addr;
+	regs.nbeah = (u32)(m->addr >> 32);
+
+	amd64_decode_nb_mce(mci_lookup[0], &regs, 1);
+}
+
+
 /*
  * The main polling 'check' function, called FROM the edac core to perform the
  * error checking and if an error is encountered, error processing.
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 6e3a9a7..7c9138e 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -71,6 +71,7 @@
 #include <linux/mmzone.h>
 #include <linux/edac.h>
 #include <asm/msr.h>
+#include <asm/mce.h>
 #include "edac_core.h"
 
 #define amd64_printk(level, fmt, arg...) \
-- 
1.6.3.3


