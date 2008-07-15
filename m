Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbYGOPCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbYGOPCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYGOPBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:01:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54605 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189AbYGOPBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:01:54 -0400
Date: Tue, 15 Jul 2008 17:01:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20080715150137.GA22647@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

this fixes the arch/x86/Kconfig defaults and a few other fixlets.

Thanks,

	Ingo

------------------>
H. Peter Anvin (2):
      x86, suspend, acpi: enter Big Real Mode
      x86, suspend, acpi: correct and add comments about Big Real Mode

Kevin Winchester (1):
      x86: Fix compile error with CONFIG_AS_CFI=n

Thomas Gleixner (2):
      x86: sanitize Kconfig
      Documentation: document debugpat commandline option


 Documentation/kernel-parameters.txt |    2 ++
 arch/x86/Kconfig                    |   22 +++++++++-------------
 arch/x86/kernel/acpi/sleep.c        |   30 ++++++++++++++++++++++++------
 include/asm-x86/dwarf2.h            |   30 +++++++++++++++---------------
 4 files changed, 50 insertions(+), 34 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b3a5aad..681d615 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -571,6 +571,8 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	debug_objects	[KNL] Enable object debugging
 
+	debugpat	[X86] Enable PAT debugging
+
 	decnet.addr=	[HW,NET]
 			Format: <area>[,<node>]
 			See also Documentation/networking/decnet.txt.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6958d6b..2642b4b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -447,7 +447,6 @@ config PARAVIRT_DEBUG
 config MEMTEST
 	bool "Memtest"
 	depends on X86_64
-	default y
 	help
 	  This option adds a kernel parameter 'memtest', which allows memtest
 	  to be set.
@@ -455,7 +454,7 @@ config MEMTEST
 		memtest=1, mean do 1 test pattern;
 		...
 		memtest=4, mean do 4 test patterns.
-	  If you are unsure how to answer this question, answer Y.
+	  If you are unsure how to answer this question, answer N.
 
 config X86_SUMMIT_NUMA
 	def_bool y
@@ -1135,21 +1134,18 @@ config MTRR
 	  See <file:Documentation/mtrr.txt> for more information.
 
 config MTRR_SANITIZER
-	def_bool y
+	bool
 	prompt "MTRR cleanup support"
 	depends on MTRR
 	help
-	  Convert MTRR layout from continuous to discrete, so some X driver
-	  could add WB entries.
+	  Convert MTRR layout from continuous to discrete, so X drivers can
+	  add writeback entries.
 
-	  Say N here if you see bootup problems (boot crash, boot hang,
-	  spontaneous reboots).
+	  Can be disabled with disable_mtrr_cleanup on the kernel command line.
+	  The largest mtrr entry size for a continous block can be set with
+	  mtrr_chunk_size.
 
-	  Could be disabled with disable_mtrr_cleanup. Also mtrr_chunk_size
-	  could be used to send largest mtrr entry size for continuous block
-	  to hold holes (aka. UC entries)
-
-	  If unsure, say Y.
+	  If unsure, say N.
 
 config MTRR_SANITIZER_ENABLE_DEFAULT
 	int "MTRR cleanup enable value (0-1)"
@@ -1166,7 +1162,7 @@ config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
 	depends on MTRR_SANITIZER
 	help
 	  mtrr cleanup spare entries default, it can be changed via
-	  mtrr_spare_reg_nr=
+	  mtrr_spare_reg_nr=N on the kernel command line.
 
 config X86_PAT
 	bool
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index e6a4b56..793ad20 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -23,6 +23,15 @@ static unsigned long acpi_realmode;
 static char temp_stack[10240];
 #endif
 
+/* XXX: this macro should move to asm-x86/segment.h and be shared with the
+   boot code... */
+#define GDT_ENTRY(flags, base, limit)		\
+	(((u64)(base & 0xff000000) << 32) |	\
+	 ((u64)flags << 40) |			\
+	 ((u64)(limit & 0x00ff0000) << 32) |	\
+	 ((u64)(base & 0x00ffffff) << 16) |	\
+	 ((u64)(limit & 0x0000ffff)))
+
 /**
  * acpi_save_state_mem - save kernel state
  *
@@ -51,18 +60,27 @@ int acpi_save_state_mem(void)
 	header->video_mode = saved_video_mode;
 
 	header->wakeup_jmp_seg = acpi_wakeup_address >> 4;
+
+	/*
+	 * Set up the wakeup GDT.  We set these up as Big Real Mode,
+	 * that is, with limits set to 4 GB.  At least the Lenovo
+	 * Thinkpad X61 is known to need this for the video BIOS
+	 * initialization quirk to work; this is likely to also
+	 * be the case for other laptops or integrated video devices.
+	 */
+
 	/* GDT[0]: GDT self-pointer */
 	header->wakeup_gdt[0] =
 		(u64)(sizeof(header->wakeup_gdt) - 1) +
 		((u64)(acpi_wakeup_address +
 			((char *)&header->wakeup_gdt - (char *)acpi_realmode))
 				<< 16);
-	/* GDT[1]: real-mode-like code segment */
-	header->wakeup_gdt[1] = (0x009bULL << 40) +
-		((u64)acpi_wakeup_address << 16) + 0xffff;
-	/* GDT[2]: real-mode-like data segment */
-	header->wakeup_gdt[2] = (0x0093ULL << 40) +
-		((u64)acpi_wakeup_address << 16) + 0xffff;
+	/* GDT[1]: big real mode-like code segment */
+	header->wakeup_gdt[1] =
+		GDT_ENTRY(0x809b, acpi_wakeup_address, 0xfffff);
+	/* GDT[2]: big real mode-like data segment */
+	header->wakeup_gdt[2] =
+		GDT_ENTRY(0x8093, acpi_wakeup_address, 0xfffff);
 
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);
diff --git a/include/asm-x86/dwarf2.h b/include/asm-x86/dwarf2.h
index 0bfe250..738bb9f 100644
--- a/include/asm-x86/dwarf2.h
+++ b/include/asm-x86/dwarf2.h
@@ -38,23 +38,23 @@
 
 /* Due to the structure of pre-exisiting code, don't use assembler line
    comment character # to ignore the arguments. Instead, use a dummy macro. */
-.macro ignore a=0, b=0, c=0, d=0
+.macro cfi_ignore a=0, b=0, c=0, d=0
 .endm
 
-#define CFI_STARTPROC	ignore
-#define CFI_ENDPROC	ignore
-#define CFI_DEF_CFA	ignore
-#define CFI_DEF_CFA_REGISTER	ignore
-#define CFI_DEF_CFA_OFFSET	ignore
-#define CFI_ADJUST_CFA_OFFSET	ignore
-#define CFI_OFFSET	ignore
-#define CFI_REL_OFFSET	ignore
-#define CFI_REGISTER	ignore
-#define CFI_RESTORE	ignore
-#define CFI_REMEMBER_STATE ignore
-#define CFI_RESTORE_STATE ignore
-#define CFI_UNDEFINED ignore
-#define CFI_SIGNAL_FRAME ignore
+#define CFI_STARTPROC	cfi_ignore
+#define CFI_ENDPROC	cfi_ignore
+#define CFI_DEF_CFA	cfi_ignore
+#define CFI_DEF_CFA_REGISTER	cfi_ignore
+#define CFI_DEF_CFA_OFFSET	cfi_ignore
+#define CFI_ADJUST_CFA_OFFSET	cfi_ignore
+#define CFI_OFFSET	cfi_ignore
+#define CFI_REL_OFFSET	cfi_ignore
+#define CFI_REGISTER	cfi_ignore
+#define CFI_RESTORE	cfi_ignore
+#define CFI_REMEMBER_STATE cfi_ignore
+#define CFI_RESTORE_STATE cfi_ignore
+#define CFI_UNDEFINED cfi_ignore
+#define CFI_SIGNAL_FRAME cfi_ignore
 
 #endif
 
