Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632AbZEKMtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632AbZEKMtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbZEKMtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:49:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:39581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbZEKMtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:49:15 -0400
Date: Mon, 11 May 2009 12:48:29 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, andreas.herrmann3@amd.com, jaswinder@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, andreas.herrmann3@amd.com, jaswinder@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090508162350.GO29045@alberich.amd.com>
References: <20090508162350.GO29045@alberich.amd.com>
Subject: [tip:x86/apic] x86: display extended apic registers with print_local_APIC and cpu_debug code
Message-ID: <tip-97a52714658cd959a3cfa35c5b6f489859f0204b@git.kernel.org>
Git-Commit-ID: 97a52714658cd959a3cfa35c5b6f489859f0204b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 12:48:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97a52714658cd959a3cfa35c5b6f489859f0204b
Gitweb:     http://git.kernel.org/tip/97a52714658cd959a3cfa35c5b6f489859f0204b
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 8 May 2009 18:23:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 14:37:36 +0200

x86: display extended apic registers with print_local_APIC and cpu_debug code

Both print_local_APIC (used when apic=debug kernel param is set) and
cpu_debug code missed support for some extended APIC registers that
I'd like to see.

This adds support to show:

 - extended APIC feature register
 - extended APIC control register
 - extended LVT registers

[ Impact: print more debug info ]

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090508162350.GO29045@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apicdef.h  |    8 ++++----
 arch/x86/kernel/apic/apic.c     |    2 +-
 arch/x86/kernel/apic/io_apic.c  |   14 +++++++++++++-
 arch/x86/kernel/cpu/cpu_debug.c |   14 +++++++++++++-
 4 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index bc9514f..7ddb36a 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -22,6 +22,7 @@
 #  define	APIC_INTEGRATED(x)	(1)
 #endif
 #define		APIC_XAPIC(x)		((x) >= 0x14)
+#define		APIC_EXT_SPACE(x)	((x) & 0x80000000)
 #define	APIC_TASKPRI	0x80
 #define		APIC_TPRI_MASK		0xFFu
 #define	APIC_ARBPRI	0x90
@@ -116,7 +117,9 @@
 #define		APIC_TDR_DIV_32		0x8
 #define		APIC_TDR_DIV_64		0x9
 #define		APIC_TDR_DIV_128	0xA
-#define	APIC_EILVT0     0x500
+#define	APIC_EFEAT	0x400
+#define	APIC_ECTRL	0x410
+#define APIC_EILVTn(n)	(0x500 + 0x10 * n)
 #define		APIC_EILVT_NR_AMD_K8	1	/* # of extended interrupts */
 #define		APIC_EILVT_NR_AMD_10H	4
 #define		APIC_EILVT_LVTOFF(x)	(((x) >> 4) & 0xF)
@@ -125,9 +128,6 @@
 #define		APIC_EILVT_MSG_NMI	0x4
 #define		APIC_EILVT_MSG_EXT	0x7
 #define		APIC_EILVT_MASKED	(1 << 16)
-#define	APIC_EILVT1     0x510
-#define	APIC_EILVT2     0x520
-#define	APIC_EILVT3     0x530
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 #define APIC_BASE_MSR	0x800
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 1ee966f..0e6543f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -395,7 +395,7 @@ static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 
 static void setup_APIC_eilvt(u8 lvt_off, u8 vector, u8 msg_type, u8 mask)
 {
-	unsigned long reg = (lvt_off << 4) + APIC_EILVT0;
+	unsigned long reg = (lvt_off << 4) + APIC_EILVTn(0);
 	unsigned int  v   = (mask << 16) | (msg_type << 8) | vector;
 
 	apic_write(reg, v);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 2afe145..65b824c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1739,7 +1739,7 @@ __apicdebuginit(void) print_APIC_bitfield(int base)
 
 __apicdebuginit(void) print_local_APIC(void *dummy)
 {
-	unsigned int v, ver, maxlvt;
+	unsigned int i, v, ver, maxlvt;
 	u64 icr;
 
 	if (apic_verbosity == APIC_QUIET)
@@ -1827,6 +1827,18 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	printk(KERN_DEBUG "... APIC TMCCT: %08x\n", v);
 	v = apic_read(APIC_TDCR);
 	printk(KERN_DEBUG "... APIC TDCR: %08x\n", v);
+
+	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
+		v = apic_read(APIC_EFEAT);
+		maxlvt = (v >> 16) & 0xff;
+		printk(KERN_DEBUG "... APIC EFEAT: %08x\n", v);
+		v = apic_read(APIC_ECTRL);
+		printk(KERN_DEBUG "... APIC ECTRL: %08x\n", v);
+		for (i = 0; i < maxlvt; i++) {
+			v = apic_read(APIC_EILVTn(i));
+			printk(KERN_DEBUG "... APIC EILVT%d: %08x\n", i, v);
+		}
+	}
 	printk("\n");
 }
 
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 46e29ab..2fc4f6b 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -588,8 +588,20 @@ static void print_apic(void *arg)
 	seq_printf(seq, " TMICT\t\t: %08x\n",  apic_read(APIC_TMICT));
 	seq_printf(seq, " TMCCT\t\t: %08x\n",  apic_read(APIC_TMCCT));
 	seq_printf(seq, " TDCR\t\t: %08x\n",  apic_read(APIC_TDCR));
-#endif /* CONFIG_X86_LOCAL_APIC */
+	if (boot_cpu_has(X86_FEATURE_EXTAPIC)) {
+		unsigned int i, v, maxeilvt;
+
+		v = apic_read(APIC_EFEAT);
+		maxeilvt = (v >> 16) & 0xff;
+		seq_printf(seq, " EFEAT\t\t: %08x\n", v);
+		seq_printf(seq, " ECTRL\t\t: %08x\n", apic_read(APIC_ECTRL));
 
+		for (i = 0; i < maxeilvt; i++) {
+			v = apic_read(APIC_EILVTn(i));
+			seq_printf(seq, " EILVT%d\t\t: %08x\n", i, v);
+		}
+	}
+#endif /* CONFIG_X86_LOCAL_APIC */
 	seq_printf(seq, "\n MSR\t:\n");
 }
 
