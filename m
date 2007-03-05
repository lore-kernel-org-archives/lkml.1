Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbXCEOjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbXCEOjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932882AbXCEOjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:39:54 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:33574 "EHLO
	outbound4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932439AbXCEOjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:39:53 -0500
X-BigFish: VP
X-Server-Uuid: 519AC16A-9632-469E-B354-112C592D09E8
Date: Mon, 5 Mar 2007 15:39:11 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: discuss@x86-64.org
cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86_64: add reporting of SVM flags to /proc/cpuinfo
Message-ID: <20070305143911.GG30318@amd.com>
References: <20070305143601.GF30318@amd.com>
MIME-Version: 1.0
In-Reply-To: <20070305143601.GF30318@amd.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 05 Mar 2007 14:39:12.0420 (UTC)
 FILETIME=[0A9ABE40:01C75F34]
X-WSS-ID: 69F2F4192X01975720-01-01
Content-Type: multipart/mixed;
 boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds the advanced SVM reporting to /proc/cpuinfo on the x86_64
architecture.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=x86_64-report-svm-features.patch
Content-Transfer-Encoding: 7bit

diff --git a/arch/x86_64/kernel/setup.c b/arch/x86_64/kernel/setup.c
index 3d98b69..4bd06a6 100644
--- a/arch/x86_64/kernel/setup.c
+++ b/arch/x86_64/kernel/setup.c
@@ -612,6 +612,13 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 
 	/* RDTSC can be speculated around */
 	clear_bit(X86_FEATURE_SYNC_RDTSC, &c->x86_capability);
+
+	/* SVM specific flags and information */
+	if (cpu_has(c, X86_FEATURE_SVM)) {
+		c->svm.svm_rev = (__u8)(cpuid_eax(0x8000000a) & 0xff);
+		c->svm.svm_asids = cpuid_ebx(0x8000000a);
+		c->svm.svm_flags = cpuid_edx(0x8000000a);
+	}
 }
 
 static void __cpuinit detect_ht(struct cpuinfo_x86 *c)
@@ -992,6 +999,11 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		/* nothing */	/* constant_tsc - moved to flags */
 	};
 
+	static char *x86_svm_flags[] = {
+		"npt",
+		"lbrv",
+		"svmlock",
+	};
 
 #ifdef CONFIG_SMP
 	if (!cpu_online(c-cpu_data))
@@ -1076,9 +1088,27 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 				else
 					seq_printf(m, " [%d]", i);
 			}
+		seq_printf(m, "\n");
+	}
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
 	}
 
-	seq_printf(m, "\n\n");
+	seq_printf(m, "\n");
 
 	return 0;
 }
diff --git a/include/asm-x86_64/cpufeature.h b/include/asm-x86_64/cpufeature.h
index 0b3c686..869d8a5 100644
--- a/include/asm-x86_64/cpufeature.h
+++ b/include/asm-x86_64/cpufeature.h
@@ -90,6 +90,7 @@
 /* More extended AMD flags: CPUID level 0x80000001, ecx, word 6 */
 #define X86_FEATURE_LAHF_LM	(6*32+ 0) /* LAHF/SAHF in long mode */
 #define X86_FEATURE_CMP_LEGACY	(6*32+ 1) /* If yes HyperThreading not valid */
+#define X86_FEATURE_SVM         (6*32+ 2) /* Secure Virtual Machine */
 
 #define cpu_has(c, bit)                test_bit(bit, (c)->x86_capability)
 #define boot_cpu_has(bit)      test_bit(bit, boot_cpu_data.x86_capability)
diff --git a/include/asm-x86_64/processor.h b/include/asm-x86_64/processor.h
index 76552d7..514520b 100644
--- a/include/asm-x86_64/processor.h
+++ b/include/asm-x86_64/processor.h
@@ -43,6 +43,15 @@
  */
 #define current_text_addr() ({ void *pc; asm volatile("leaq 1f(%%rip),%0\n1:":"=r"(pc)); pc; })
 
+ /*
+  * SVM flags subtype - used in struct cpuinfo_x86
+  */
+struct cpu_svm_info {
+	__u8 svm_rev;
+	__u32 svm_asids;
+	__u32 svm_flags;
+};
+
 /*
  *  CPU type and hardware bug flags. Kept separately for each CPU.
  */
@@ -73,6 +82,8 @@ struct cpuinfo_x86 {
 	__u8	booted_cores;	/* number of cores as seen by OS */
 	__u8	phys_proc_id;	/* Physical Processor id. */
 	__u8	cpu_core_id;	/* Core id. */
+
+	struct cpu_svm_info svm; /* SVM specific feature flags */
 #endif
 } ____cacheline_aligned;
 

--lrZ03NoBR/3+SXJZ--


