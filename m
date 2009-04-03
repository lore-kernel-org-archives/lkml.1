Return-Path: <linux-kernel-owner+w=401wt.eu-S932312AbZDCWg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbZDCWg6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZDCWgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:36:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:52119 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbZDCWgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:36:49 -0400
Message-ID: <49D68F4B.9010808@kernel.org>
Date: Fri, 03 Apr 2009 15:35:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make mtrr code could use debugpat
References: <20090329205805.GA24693@elte.hu> <20090329210103.GA24901@elte.hu> <49CFF517.30001@kernel.org> <alpine.LFD.2.00.0903291553210.3948@localhost.localdomain> <1238434120.4529.783.camel@localhost.localdomain> <20090403175555.GH6295@elte.hu> <alpine.LFD.2.00.0904031203400.4015@localhost.localdomain> <20090403212152.GA3493@linux-os.sc.intel.com> <alpine.LFD.2.00.0904031443340.7007@localhost.localdomain> <alpine.LFD.2.00.0904031521460.3915@localhost.localdomain> <20090403222928.GA6446@elte.hu>
In-Reply-To: <20090403222928.GA6446@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Impact: cleanup

only print out get_mtrr when debugpat

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/mtrr/generic.c |    9 ++++++---
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    4 ++++
 arch/x86/mm/pat.c                  |    6 +++---
 3 files changed, 13 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
@@ -462,9 +462,12 @@ static void generic_get_mtrr(unsigned in
 	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
 	*type = base_lo & 0xff;
 
-	printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
-			cpu, reg, *base, *size,
-			mtrr_attrib_to_str(*type & 0xff));
+#ifdef CONFIG_X86_PAT
+	if (debugpat)
+		printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
+				cpu, reg, *base, *size,
+				mtrr_attrib_to_str(*type & 0xff));
+#endif
 out_put_cpu:
 	put_cpu();
 }
Index: linux-2.6/arch/x86/kernel/cpu/mtrr/mtrr.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -92,3 +92,7 @@ int centaur_init_mtrr(void);
 
 extern int changed_by_mtrr_cleanup;
 extern int mtrr_cleanup(unsigned address_bits);
+
+#if CONFIG_X86_PAT
+extern int debugpat;
+#endif
Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c
+++ linux-2.6/arch/x86/mm/pat.c
@@ -51,17 +51,17 @@ static inline void pat_disable(const cha
 #endif
 
 
-static int debug_enable;
+int debugpat;
 
 static int __init pat_debug_setup(char *str)
 {
-	debug_enable = 1;
+	debugpat = 1;
 	return 0;
 }
 __setup("debugpat", pat_debug_setup);
 
 #define dprintk(fmt, arg...) \
-	do { if (debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
+	do { if (debugpat) printk(KERN_INFO fmt, ##arg); } while (0)
 
 
 static u64 __read_mostly boot_pat_state;
