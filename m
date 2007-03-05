Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbXCEOnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbXCEOnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:43:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933492AbXCEOnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:43:08 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:55351 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932414AbXCEOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:43:07 -0500
X-BigFish: VP
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Mon, 5 Mar 2007 15:42:40 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] i386: add reporting of SVM flags to /proc/cpuinfo
Message-ID: <20070305144240.GH30318@amd.com>
References: <20070305143601.GF30318@amd.com>
MIME-Version: 1.0
In-Reply-To: <20070305143601.GF30318@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Mar 2007 14:42:40.0979 (UTC)
 FILETIME=[86EA5230:01C75F34]
X-WSS-ID: 69F2F3EE2EW92624-01-01
Content-Type: multipart/mixed;
 boundary=6sX45UoQRIJXqkqR
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds the advanced SVM reporting in /proc/cpuinfo to the i386
architecture.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--6sX45UoQRIJXqkqR
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=i386-report-svm-features.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/i386/kernel/cpu/amd.c b/arch/i386/kernel/cpu/amd.c
index 41cfea5..768c221 100644
--- a/arch/i386/kernel/cpu/amd.c
+++ b/arch/i386/kernel/cpu/amd.c
@@ -241,6 +241,13 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 
 	if (cpuid_eax(0x80000000) >= 0x80000006)
 		num_cache_leaves = 3;
+
+	/* SVM specific flags and information */
+	if (cpu_has(c, X86_FEATURE_SVM)) {
+		c->svm.svm_rev = (__u8)(cpuid_eax(0x8000000a) & 0xff);
+		c->svm.svm_asids = cpuid_ebx(0x8000000a);
+		c->svm.svm_flags = cpuid_edx(0x8000000a);
+	}
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned int size)
diff --git a/arch/i386/kernel/cpu/proc.c b/arch/i386/kernel/cpu/proc.c
index 47e3ebb..ddedf56 100644
--- a/arch/i386/kernel/cpu/proc.c
+++ b/arch/i386/kernel/cpu/proc.c
@@ -76,6 +76,13 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		NULL,	/* constant_tsc - moved to flags */
 		/* nothing */
 	};
+
+	static char *x86_svm_flags[] = {
+		"npt",
+		"lbrv",
+		"svmlock",
+	};
+
 	struct cpuinfo_x86 *c = v;
 	int i, n = c - cpu_data;
 	int fpu_exception;
@@ -159,7 +166,25 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	seq_printf(m, "\nbogomips\t: %lu.%02lu\n",
 		     c->loops_per_jiffy/(500000/HZ),
 		     (c->loops_per_jiffy/(5000/HZ)) % 100);
-	seq_printf(m, "clflush size\t: %u\n\n", c->x86_clflush_size);
+	seq_printf(m, "clflush size\t: %u\n", c->x86_clflush_size);
+
+	if (cpu_has(c, X86_FEATURE_SVM)) {
+		unsigned i, first=1;
+		seq_printf(m, "SVM features\t: rev=%hd #asids=%u flags=(",
+				c->svm.svm_rev, c->svm.svm_asids);
+		for (i=0;i<ARRAY_SIZE(x86_svm_flags);++i) {
+			if (c->svm.svm_flags & (1 << i)) {
+				seq_printf(m,"%s", first ? "" : " ");
+				first = 0;
+				if (x86_svm_flags[i])
+					seq_printf(m, "%s", x86_svm_flags[i]);
+				else
+					seq_printf(m, "[%d]", i);
+			}
+		}
+		seq_printf(m, ")\n");
+	}
+	seq_printf(m, "\n");
 
 	return 0;
 }
diff --git a/include/asm-i386/cpufeature.h b/include/asm-i386/cpufeature.h
index 3f92b94..4da2dba 100644
--- a/include/asm-i386/cpufeature.h
+++ b/include/asm-i386/cpufeature.h
@@ -101,6 +101,7 @@
 /* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
 #define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
 #define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
+#define X86_FEATURE_SVM         (6*32+ 2) /* Secure Virtual Machine */
 
 #define cpu_has(c, bit)		test_bit(bit, (c)->x86_capability)
 #define boot_cpu_has(bit)	test_bit(bit, boot_cpu_data.x86_capability)
diff --git a/include/asm-i386/processor.h b/include/asm-i386/processor.h
index 11bf899..727c54f 100644
--- a/include/asm-i386/processor.h
+++ b/include/asm-i386/processor.h
@@ -41,6 +41,15 @@ struct desc_struct {
 #define current_text_addr() ({ void *pc; __asm__("movl $1f,%0\n1:":"=g" (pc)); pc; })
 
 /*
+ * SVM flags subtype - used in struct cpuinfo_x86
+ */
+struct cpu_svm_info {
+	__u8 svm_rev;
+	__u32 svm_asids;
+	__u32 svm_flags;
+};
+
+/*
  *  CPU type and hardware bug flags. Kept separately for each CPU.
  *  Members of this structure are referenced in head.S, so think twice
  *  before touching them. [mj]
@@ -79,6 +88,7 @@ struct cpuinfo_x86 {
 	__u8 phys_proc_id; 		/* Physical processor id. */
 	__u8 cpu_core_id;  		/* Core id */
 #endif
+	struct cpu_svm_info svm;
 } __attribute__((__aligned__(SMP_CACHE_BYTES)));
 
 #define X86_VENDOR_INTEL 0

--6sX45UoQRIJXqkqR--


