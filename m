Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998AbYGYQSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbYGYQSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbYGYQRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:17:34 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:26928 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbYGYQRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:17:31 -0400
X-BigFish: VPS5(zz1cddkzz10d3izzz32i62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K4KL8K-01-GGU-01
Message-ID: <20080725162002.976728160@amd.com>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Fri, 25 Jul 2008 18:17:28 +0200
From: Peter Oruba <peter.oruba@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: [patch 5/9] [PATCH 5/9] x86: Structure declaration renaming.
References: <20080725161723.636932280@amd.com>
Content-Disposition: inline;
	filename="0005-x86-Structure-declaration-renaming.patch"
X-OriginalArrivalTime: 25 Jul 2008 16:17:08.0651 (UTC) FILETIME=[E2F56FB0:01C8EE71]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renamed common structures to vendor specific naming scheme
so other vendors will be able to use the same naming
convention.

Signed-off-by: Peter Oruba <peter.oruba@amd.com>

Conflicts:
---
 arch/x86/kernel/microcode_intel.c |   46 +++++++++++++++++++-----------------
 include/asm-x86/microcode.h       |   10 +++++---
 2 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index a30c799..4754137 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -100,17 +100,19 @@ MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
 MODULE_LICENSE("GPL");
 
 #define DEFAULT_UCODE_DATASIZE 	(2000) 	  /* 2000 bytes */
-#define MC_HEADER_SIZE		(sizeof(struct microcode_header))  	  /* 48 bytes */
+#define MC_HEADER_SIZE		(sizeof(struct microcode_header_intel)) /* 48 bytes */
 #define DEFAULT_UCODE_TOTALSIZE (DEFAULT_UCODE_DATASIZE + MC_HEADER_SIZE) /* 2048 bytes */
 #define EXT_HEADER_SIZE		(sizeof(struct extended_sigtable)) /* 20 bytes */
 #define EXT_SIGNATURE_SIZE	(sizeof(struct extended_signature)) /* 12 bytes */
 #define DWSIZE			(sizeof(u32))
 #define get_totalsize(mc) \
-	(((struct microcode *)mc)->hdr.totalsize ? \
-	 ((struct microcode *)mc)->hdr.totalsize : DEFAULT_UCODE_TOTALSIZE)
+	(((struct microcode_intel *)mc)->hdr.totalsize ? \
+	 ((struct microcode_intel *)mc)->hdr.totalsize : \
+	 DEFAULT_UCODE_TOTALSIZE)
+
 #define get_datasize(mc) \
-	(((struct microcode *)mc)->hdr.datasize ? \
-	 ((struct microcode *)mc)->hdr.datasize : DEFAULT_UCODE_DATASIZE)
+	(((struct microcode_intel *)mc)->hdr.datasize ? \
+	 ((struct microcode_intel *)mc)->hdr.datasize : DEFAULT_UCODE_DATASIZE)
 
 #define sigmatch(s1, s2, p1, p2) \
 	(((s1) == (s2)) && (((p1) & (p2)) || (((p1) == 0) && ((p2) == 0))))
@@ -134,7 +136,7 @@ void collect_cpu_info(int cpu_num)
 	/* We should bind the task to the CPU */
 	BUG_ON(raw_smp_processor_id() != cpu_num);
 	uci->pf = uci->rev = 0;
-	uci->mc = NULL;
+	uci->mc.mc_intel = NULL;
 	uci->valid = 1;
 
 	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
@@ -163,7 +165,7 @@ void collect_cpu_info(int cpu_num)
 }
 
 static inline int microcode_update_match(int cpu_num,
-	struct microcode_header *mc_header, int sig, int pf)
+	struct microcode_header_intel *mc_header, int sig, int pf)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu_num;
 
@@ -175,7 +177,7 @@ static inline int microcode_update_match(int cpu_num,
 
 int microcode_sanity_check(void *mc)
 {
-	struct microcode_header *mc_header = mc;
+	struct microcode_header_intel *mc_header = mc;
 	struct extended_sigtable *ext_header = NULL;
 	struct extended_signature *ext_sig;
 	unsigned long total_size, data_size, ext_table_size;
@@ -260,7 +262,7 @@ int microcode_sanity_check(void *mc)
 int get_matching_microcode(void *mc, int cpu)
 {
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-	struct microcode_header *mc_header = mc;
+	struct microcode_header_intel *mc_header = mc;
 	struct extended_sigtable *ext_header;
 	unsigned long total_size = get_totalsize(mc_header);
 	int ext_sigcount, i;
@@ -294,10 +296,10 @@ find:
 	}
 
 	/* free previous update file */
-	vfree(uci->mc);
+	vfree(uci->mc.mc_intel);
 
 	memcpy(new_mc, mc, total_size);
-	uci->mc = new_mc;
+	uci->mc.mc_intel = new_mc;
 	return 1;
 }
 
@@ -311,7 +313,7 @@ void apply_microcode(int cpu)
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu_num != cpu);
 
-	if (uci->mc == NULL)
+	if (uci->mc.mc_intel == NULL)
 		return;
 
 	/* serialize access to the physical write to MSR 0x79 */
@@ -319,8 +321,8 @@ void apply_microcode(int cpu)
 
 	/* write microcode via MSR 0x79 */
 	wrmsr(MSR_IA32_UCODE_WRITE,
-		(unsigned long) uci->mc->bits,
-		(unsigned long) uci->mc->bits >> 16 >> 16);
+	      (unsigned long) uci->mc.mc_intel->bits,
+	      (unsigned long) uci->mc.mc_intel->bits >> 16 >> 16);
 	wrmsr(MSR_IA32_UCODE_REV, 0, 0);
 
 	/* see notes above for revision 1.07.  Apparent chip bug */
@@ -330,14 +332,14 @@ void apply_microcode(int cpu)
 	rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);
 
 	spin_unlock_irqrestore(&microcode_update_lock, flags);
-	if (val[1] != uci->mc->hdr.rev) {
+	if (val[1] != uci->mc.mc_intel->hdr.rev) {
 		printk(KERN_ERR "microcode: CPU%d update from revision "
 			"0x%x to 0x%x failed\n", cpu_num, uci->rev, val[1]);
 		return;
 	}
 	printk(KERN_INFO "microcode: CPU%d updated from revision "
 	       "0x%x to 0x%x, date = %08x \n",
-	       cpu_num, uci->rev, val[1], uci->mc->hdr.date);
+	       cpu_num, uci->rev, val[1], uci->mc.mc_intel->hdr.date);
 	uci->rev = val[1];
 }
 
@@ -347,7 +349,7 @@ extern unsigned int user_buffer_size;   /* it's size */
 
 long get_next_ucode(void **mc, long offset)
 {
-	struct microcode_header mc_header;
+	struct microcode_header_intel mc_header;
 	unsigned long total_size;
 
 	/* No more data */
@@ -378,13 +380,13 @@ long get_next_ucode(void **mc, long offset)
 static long get_next_ucode_from_buffer(void **mc, const u8 *buf,
 	unsigned long size, long offset)
 {
-	struct microcode_header *mc_header;
+	struct microcode_header_intel *mc_header;
 	unsigned long total_size;
 
 	/* No more data */
 	if (offset >= size)
 		return 0;
-	mc_header = (struct microcode_header *)(buf + offset);
+	mc_header = (struct microcode_header_intel *)(buf + offset);
 	total_size = get_totalsize(mc_header);
 
 	if (offset + total_size > size) {
@@ -462,7 +464,7 @@ int apply_microcode_check_cpu(int cpu)
 	int err = 0;
 
 	/* Check if the microcode is available */
-	if (!uci->mc)
+	if (!uci->mc.mc_intel)
 		return 0;
 
 	old = current->cpus_allowed;
@@ -507,7 +509,7 @@ void microcode_fini_cpu(int cpu)
 
 	mutex_lock(&microcode_mutex);
 	uci->valid = 0;
-	kfree(uci->mc);
-	uci->mc = NULL;
+	kfree(uci->mc.mc_intel);
+	uci->mc.mc_intel = NULL;
 	mutex_unlock(&microcode_mutex);
 }
diff --git a/include/asm-x86/microcode.h b/include/asm-x86/microcode.h
index d34a1fc..ef77c6f 100644
--- a/include/asm-x86/microcode.h
+++ b/include/asm-x86/microcode.h
@@ -1,4 +1,4 @@
-struct microcode_header {
+struct microcode_header_intel {
 	unsigned int            hdrver;
 	unsigned int            rev;
 	unsigned int            date;
@@ -11,8 +11,8 @@ struct microcode_header {
 	unsigned int            reserved[3];
 };
 
-struct microcode {
-	struct microcode_header hdr;
+struct microcode_intel {
+	struct microcode_header_intel hdr;
 	unsigned int            bits[0];
 };
 
@@ -35,5 +35,7 @@ struct ucode_cpu_info {
 	unsigned int sig;
 	unsigned int pf;
 	unsigned int rev;
-	struct microcode *mc;
+	union {
+		struct microcode_intel *mc_intel;
+	} mc;
 };
-- 
1.5.4.5




