Return-Path: <linux-kernel-owner+w=401wt.eu-S1753666AbZCUJNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666AbZCUJNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 05:13:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbZCUJNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 05:13:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:51555 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbZCUJNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 05:13:14 -0400
Subject: [git-pull -tip] x86: mpparse introduce some more helper functions
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 21 Mar 2009 14:42:35 +0530
Message-Id: <1237626755.26347.7.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Log files are available at:
http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tip.git;a=shortlog;h=x86/core

The following changes since commit 7f00a2495bf5b98b097c47be5d6e2d4114ec39bf:
  Ingo Molnar (1):
        Merge branches 'x86/cleanups', 'x86/mm', 'x86/setup' and 'linus' into x86/core

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git x86/core

Jaswinder Singh Rajput (2):
      x86: mpparse.c introduce smp_dump_mptable helper function
      x86: mpparse.c introduce check_physptr helper function

 arch/x86/kernel/mpparse.c |  112 ++++++++++++++++++++++++---------------------
 1 files changed, 60 insertions(+), 52 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 290cb57..dce99dc 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -282,6 +282,14 @@ static void skip_entry(unsigned char **ptr, int *count, int size)
 	*count += size;
 }
 
+static void __init smp_dump_mptable(struct mpc_table *mpc, unsigned char *mpt)
+{
+	printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n"
+		"type %x\n", *mpt);
+	print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
+			1, mpc, mpc->length, 1);
+}
+
 static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 {
 	char str[16];
@@ -340,10 +348,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 			break;
 		default:
 			/* wrong mptable */
-			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
-			printk(KERN_ERR "type %x\n", *mpt);
-			print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
-					1, mpc, mpc->length, 1);
+			smp_dump_mptable(mpc, mpt);
 			count = mpc->length;
 			break;
 		}
@@ -550,6 +555,55 @@ static unsigned long __init get_mpc_size(unsigned long physptr)
 	return size;
 }
 
+static int __init check_physptr(struct mpf_intel *mpf, unsigned int early)
+{
+	struct mpc_table *mpc;
+	unsigned long size;
+
+	size = get_mpc_size(mpf->physptr);
+	mpc = early_ioremap(mpf->physptr, size);
+	/*
+	 * Read the physical hardware table.  Anything here will
+	 * override the defaults.
+	 */
+	if (!smp_read_mpc(mpc, early)) {
+#ifdef CONFIG_X86_LOCAL_APIC
+		smp_found_config = 0;
+#endif
+		printk(KERN_ERR "BIOS bug, MP table errors detected!...\n"
+			"... disabling SMP support. (tell your hw vendor)\n");
+		early_iounmap(mpc, size);
+		return -1;
+	}
+	early_iounmap(mpc, size);
+
+	if (early)
+		return -1;
+
+#ifdef CONFIG_X86_IO_APIC
+	/*
+	 * If there are no explicit MP IRQ entries, then we are
+	 * broken.  We set up most of the low 16 IO-APIC pins to
+	 * ISA defaults and hope it will work.
+	 */
+	if (!mp_irq_entries) {
+		struct mpc_bus bus;
+
+		printk(KERN_ERR "BIOS bug, no explicit IRQ entries, "
+		       "using default mptable. (tell your hw vendor)\n");
+
+		bus.type = MP_BUS;
+		bus.busid = 0;
+		memcpy(bus.bustype, "ISA   ", 6);
+		MP_bus_info(&bus);
+
+		construct_default_ioirq_mptable(0);
+	}
+#endif
+
+	return 0;
+}
+
 /*
  * Scan the memory blocks for an SMP configuration block.
  */
@@ -603,51 +657,8 @@ static void __init __get_smp_config(unsigned int early)
 		construct_default_ISA_mptable(mpf->feature1);
 
 	} else if (mpf->physptr) {
-		struct mpc_table *mpc;
-		unsigned long size;
-
-		size = get_mpc_size(mpf->physptr);
-		mpc = early_ioremap(mpf->physptr, size);
-		/*
-		 * Read the physical hardware table.  Anything here will
-		 * override the defaults.
-		 */
-		if (!smp_read_mpc(mpc, early)) {
-#ifdef CONFIG_X86_LOCAL_APIC
-			smp_found_config = 0;
-#endif
-			printk(KERN_ERR
-			       "BIOS bug, MP table errors detected!...\n");
-			printk(KERN_ERR "... disabling SMP support. "
-			       "(tell your hw vendor)\n");
-			early_iounmap(mpc, size);
+		if (check_physptr(mpf, early))
 			return;
-		}
-		early_iounmap(mpc, size);
-
-		if (early)
-			return;
-#ifdef CONFIG_X86_IO_APIC
-		/*
-		 * If there are no explicit MP IRQ entries, then we are
-		 * broken.  We set up most of the low 16 IO-APIC pins to
-		 * ISA defaults and hope it will work.
-		 */
-		if (!mp_irq_entries) {
-			struct mpc_bus bus;
-
-			printk(KERN_ERR "BIOS bug, no explicit IRQ entries, "
-			       "using default mptable. "
-			       "(tell your hw vendor)\n");
-
-			bus.type = MP_BUS;
-			bus.busid = 0;
-			memcpy(bus.bustype, "ISA   ", 6);
-			MP_bus_info(&bus);
-
-			construct_default_ioirq_mptable(0);
-		}
-#endif
 	} else
 		BUG();
 
@@ -910,10 +921,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 			break;
 		default:
 			/* wrong mptable */
-			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
-			printk(KERN_ERR "type %x\n", *mpt);
-			print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
-					1, mpc, mpc->length, 1);
+			smp_dump_mptable(mpc, mpt);
 			goto out;
 		}
 	}


