Return-Path: <linux-kernel-owner+w=401wt.eu-S933052AbZFMQjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbZFMQjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932818AbZFMQix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:38:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:34563 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbZFMQiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:38:51 -0400
Subject: [RFC][PATCH 5/10 -tip] x86: cpu_debug update MSR list to support
 new architectures
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <1244910655.11733.19.camel@ht.satnam>
References: <1244910436.11733.14.camel@ht.satnam>
	 <1244910511.11733.16.camel@ht.satnam> <1244910575.11733.17.camel@ht.satnam>
	 <1244910618.11733.18.camel@ht.satnam> <1244910655.11733.19.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 22:01:41 +0530
Message-Id: <1244910701.11733.20.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Added support for Intel Xeon MP 7400 series :

Intel Xeon MP 7400 series falls in Intel Core microarchitecture.
Intel Xeon MP 7400 series supports additional:
 0x419, 0x107CC-0x107D3 and 0x107D8

Added support for Intel Core i7, Xeon Processor 5500 series (Nehalem)

Added some extra registers for AMD Family 10h Processor

Also fixed some minor range issues.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu_debug.h |    3 +++
 arch/x86/kernel/cpu/cpu_debug.c  |   36 +++++++++++++++++++++++++++---------
 2 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index da5c221..f2adad3 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -36,6 +36,9 @@ enum cpu_debug_bit {
 	CPU_VER,				/* Version ID		*/
 	CPU_CONF,				/* Configuration	*/
 	CPU_SMM,				/* System mgmt mode	*/
+	CPU_POWER,				/* Power mgmt		*/
+	CPU_PNAME,				/* Processor name	*/
+	CPU_IBS,				/* IBS			*/
 	CPU_SVM,				/*Secure Virtual Machine*/
 	CPU_OSVM,				/* OS-Visible Workaround*/
 /* Standard Registers							*/
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 5c45c52..9435da4 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -60,6 +60,9 @@ static struct cpu_debug_base cpu_base[] = {
 	{ "ver",	CPU_VER,	0	},
 	{ "conf",	CPU_CONF,	0	},
 	{ "smm",	CPU_SMM,	0	},
+	{ "power",	CPU_POWER,	0	},
+	{ "pname",	CPU_PNAME,	0	},
+	{ "ibs",	CPU_IBS,	0	},
 	{ "svm",	CPU_SVM,	0	},
 	{ "osvm",	CPU_OSVM,	0	},
 	{ "tss",	CPU_TSS,	0	},
@@ -90,6 +93,7 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0x00000088, 0x0000008A, CPU_CACHE,	},
 	{ 0x0000008B, 0x0000008B, CPU_BIOS,	},
 	{ 0x0000009B, 0x0000009B, CPU_MONITOR,	},
+	{ 0x000000A0, 0x000000A1, CPU_SMM,	},
 	{ 0x000000C1, 0x000000C4, CPU_PMC,	},
 	{ 0x000000CD, 0x000000CD, CPU_FREQ,	},
 	{ 0x000000E7, 0x000000E8, CPU_PERF,	},
@@ -98,40 +102,49 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0x00000116, 0x0000011E, CPU_CACHE,	},
 	{ 0x00000174, 0x00000176, CPU_SYSENTER,	},
 	{ 0x00000179, 0x0000017B, CPU_MC,	},
+	{ 0x00000180, 0x00000185, CPU_MC,	},
 	{ 0x00000186, 0x00000189, CPU_PMC,	},
 	{ 0x00000198, 0x00000199, CPU_PERF,	},
 	{ 0x0000019A, 0x0000019A, CPU_TIME,	},
 	{ 0x0000019B, 0x0000019D, CPU_THERM,	},
 	{ 0x000001A0, 0x000001A0, CPU_MISC,	},
-	{ 0x000001C9, 0x000001C9, CPU_LBRANCH,	},
+	{ 0x000001A1, 0x000001A1, CPU_PLATFORM,	},
+	{ 0x000001A2, 0x000001A2, CPU_THERM,	},
+	{ 0x000001A6, 0x000001A6, CPU_PMC,	},
+	{ 0x000001AD, 0x000001AD, CPU_FREQ,	},
+	{ 0x000001C8, 0x000001C9, CPU_LBRANCH,	},
 	{ 0x000001D7, 0x000001D8, CPU_LBRANCH,	},
 	{ 0x000001D9, 0x000001D9, CPU_DEBUG,	},
 	{ 0x000001DA, 0x000001E0, CPU_LBRANCH,	},
+	{ 0x000001F2, 0x000001F3, CPU_SMM,	},
 
 	{ 0x00000200, 0x0000020F, CPU_MTRR,	},
 	{ 0x00000250, 0x00000250, CPU_MTRR,	},
 	{ 0x00000258, 0x00000259, CPU_MTRR,	},
 	{ 0x00000268, 0x0000026F, CPU_MTRR,	},
 	{ 0x00000277, 0x00000277, CPU_PAT,	},
+	{ 0x00000280, 0x00000288, CPU_MC,	},
 	{ 0x000002FF, 0x000002FF, CPU_MTRR,	},
 
 	{ 0x00000300, 0x00000311, CPU_PMC,	},
 	{ 0x00000345, 0x00000345, CPU_PMC,	},
 	{ 0x00000360, 0x00000371, CPU_PMC,	},
-	{ 0x0000038D, 0x00000390, CPU_PMC,	},
+	{ 0x0000038D, 0x00000396, CPU_PMC,	},
 	{ 0x000003A0, 0x000003BE, CPU_PMC,	},
 	{ 0x000003C0, 0x000003CD, CPU_PMC,	},
 	{ 0x000003E0, 0x000003E1, CPU_PMC,	},
-	{ 0x000003F0, 0x000003F2, CPU_PMC,	},
+	{ 0x000003F0, 0x000003FD, CPU_PMC,	},
 
-	{ 0x00000400, 0x00000417, CPU_MC,	},
+	{ 0x00000400, 0x00000421, CPU_MC,	},
 	{ 0x00000480, 0x0000048B, CPU_VMX,	},
 
 	{ 0x00000600, 0x00000600, CPU_DEBUG,	},
 	{ 0x00000680, 0x0000068F, CPU_LBRANCH,	},
 	{ 0x000006C0, 0x000006CF, CPU_LBRANCH,	},
 
-	{ 0x000107CC, 0x000107D3, CPU_PMC,	},
+	{ 0x00000800, 0x0000083F, CPU_APIC,	},
+
+	{ 0x000107CC, 0x000107D8, CPU_PMC,	},
 
 	{ 0xC0000080, 0xC0000080, CPU_FEATURES,	},
 	{ 0xC0000081, 0xC0000084, CPU_CALL,	},
@@ -144,18 +157,23 @@ static struct cpu_debug_range cpu_reg_range[] = {
 	{ 0xC0010016, 0xC001001A, CPU_MTRR,	},
 	{ 0xC001001D, 0xC001001D, CPU_MTRR,	},
 	{ 0xC001001F, 0xC001001F, CPU_CONF,	},
-	{ 0xC0010030, 0xC0010035, CPU_BIOS,	},
-	{ 0xC0010044, 0xC0010048, CPU_MC,	},
+	{ 0xC0010022, 0xC0010022, CPU_MC,	},
+	{ 0xC0010030, 0xC0010035, CPU_PNAME,	},
+	{ 0xC0010044, 0xC0010049, CPU_MC,	},
 	{ 0xC0010050, 0xC0010056, CPU_SMM,	},
 	{ 0xC0010058, 0xC0010058, CPU_CONF,	},
 	{ 0xC0010060, 0xC0010060, CPU_CACHE,	},
-	{ 0xC0010061, 0xC0010068, CPU_SMM,	},
-	{ 0xC0010069, 0xC001006B, CPU_SMM,	},
+	{ 0xC0010061, 0xC001006B, CPU_POWER,	},
 	{ 0xC0010070, 0xC0010071, CPU_SMM,	},
+	{ 0xC0010074, 0xC0010074, CPU_TIME,	},
 	{ 0xC0010111, 0xC0010113, CPU_SMM,	},
 	{ 0xC0010114, 0xC0010118, CPU_SVM,	},
 	{ 0xC0010140, 0xC0010141, CPU_OSVM,	},
+
+	{ 0xC0011004, 0xC0011005, CPU_FEATURES,	},
 	{ 0xC0011022, 0xC0011023, CPU_CONF,	},
+	{ 0xC001102A, 0xC001102A, CPU_CONF,	},
+	{ 0xC0011030, 0xC001103A, CPU_IBS,	},
 };
 
 static int is_typeflag_valid(unsigned cpu, unsigned flag)
-- 
1.6.0.6



