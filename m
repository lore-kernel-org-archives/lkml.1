Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbYJQMjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbYJQMjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYJQMiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:38:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:3906 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbYJQMiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=aoWPT1ouLa7civXNxeXAbtonHVSp/dSNkMSWY5EEiIiyRjO3sP7HpmHxJXwnXOgNw0
         kaF3/VoWKoAKFJhbzLp+q8g2WnL2lxp8KsoY+jPnl+96dO3OtRxZBIuF+v+szTSHPX0A
         61vQdrxtj79Q/1SnbHVtR8+RRaulY8QQa1sYk=
Date: Fri, 17 Oct 2008 16:41:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: geert@linux-m68k.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org
Subject: [PATCH 05/31] proc: move /proc/hardware to m68k-specific code
Message-ID: <20081017124152.GF22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 97861c940961a4106e7312627e421967c79d240f Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 3 Oct 2008 22:42:36 +0400
Subject: [PATCH 05/31] proc: move /proc/hardware to m68k-specific code

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 arch/m68k/amiga/config.c    |   21 +++++++++------------
 arch/m68k/atari/config.c    |   15 +++++++--------
 arch/m68k/bvme6000/config.c |   11 -----------
 arch/m68k/kernel/setup.c    |   35 ++++++++++++++++++++++++++++-------
 arch/m68k/mvme147/config.c  |   10 ----------
 arch/m68k/mvme16x/config.c  |   15 +++++----------
 arch/m68k/q40/config.c      |   10 ----------
 arch/m68k/sun3/config.c     |   12 +++---------
 arch/m68k/sun3x/config.c    |   12 +++---------
 fs/proc/proc_misc.c         |   13 -------------
 include/asm-m68k/machdep.h  |    2 +-
 11 files changed, 56 insertions(+), 100 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 0a3f9e8..ab9862c 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/tty.h>
 #include <linux/console.h>
 #include <linux/rtc.h>
@@ -93,7 +94,7 @@ static char amiga_model_name[13] = "Amiga ";
 
 static void amiga_sched_init(irq_handler_t handler);
 static void amiga_get_model(char *model);
-static int amiga_get_hardware_list(char *buffer);
+static void amiga_get_hardware_list(struct seq_file *m);
 /* amiga specific timer functions */
 static unsigned long amiga_gettimeoffset(void);
 static int a3000_hwclk(int, struct rtc_time *);
@@ -911,13 +912,11 @@ static void amiga_get_model(char *model)
 }
 
 
-static int amiga_get_hardware_list(char *buffer)
+static void amiga_get_hardware_list(struct seq_file *m)
 {
-	int len = 0;
-
 	if (AMIGAHW_PRESENT(CHIP_RAM))
-		len += sprintf(buffer+len, "Chip RAM:\t%ldK\n", amiga_chip_size>>10);
-	len += sprintf(buffer+len, "PS Freq:\t%dHz\nEClock Freq:\t%ldHz\n",
+		seq_printf(m, "Chip RAM:\t%ldK\n", amiga_chip_size>>10);
+	seq_printf(m, "PS Freq:\t%dHz\nEClock Freq:\t%ldHz\n",
 			amiga_psfreq, amiga_eclock);
 	if (AMIGAHW_PRESENT(AMI_VIDEO)) {
 		char *type;
@@ -935,14 +934,14 @@ static int amiga_get_hardware_list(char *buffer)
 			type = "Old or Unknown";
 			break;
 		}
-		len += sprintf(buffer+len, "Graphics:\t%s\n", type);
+		seq_printf(m, "Graphics:\t%s\n", type);
 	}
 
 #define AMIGAHW_ANNOUNCE(name, str)			\
 	if (AMIGAHW_PRESENT(name))			\
-		len += sprintf (buffer+len, "\t%s\n", str)
+		seq_printf (m, "\t%s\n", str)
 
-	len += sprintf (buffer + len, "Detected hardware:\n");
+	seq_printf (m, "Detected hardware:\n");
 
 	AMIGAHW_ANNOUNCE(AMI_VIDEO, "Amiga Video");
 	AMIGAHW_ANNOUNCE(AMI_BLITTER, "Blitter");
@@ -975,15 +974,13 @@ static int amiga_get_hardware_list(char *buffer)
 	AMIGAHW_ANNOUNCE(PCMCIA, "PCMCIA Slot");
 #ifdef CONFIG_ZORRO
 	if (AMIGAHW_PRESENT(ZORRO))
-		len += sprintf(buffer+len, "\tZorro II%s AutoConfig: %d Expansion "
+		seq_printf(m, "\tZorro II%s AutoConfig: %d Expansion "
 				"Device%s\n",
 				AMIGAHW_PRESENT(ZORRO3) ? "I" : "",
 				zorro_num_autocon, zorro_num_autocon == 1 ? "" : "s");
 #endif /* CONFIG_ZORRO */
 
 #undef AMIGAHW_ANNOUNCE
-
-	return len;
 }
 
 /*
diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
index af03185..49c28cd 100644
--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -26,6 +26,7 @@
 
 #include <linux/types.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/console.h>
 #include <linux/init.h>
 #include <linux/delay.h>
@@ -63,7 +64,7 @@ int atari_rtc_year_offset;
 /* local function prototypes */
 static void atari_reset(void);
 static void atari_get_model(char *model);
-static int atari_get_hardware_list(char *buffer);
+static void atari_get_hardware_list(struct seq_file *m);
 
 /* atari specific irq functions */
 extern void atari_init_IRQ (void);
@@ -611,21 +612,21 @@ static void atari_get_model(char *model)
 }
 
 
-static int atari_get_hardware_list(char *buffer)
+static void atari_get_hardware_list(struct seq_file *m)
 {
-	int len = 0, i;
+	int i;
 
 	for (i = 0; i < m68k_num_memory; i++)
-		len += sprintf(buffer+len, "\t%3ld MB at 0x%08lx (%s)\n",
+		seq_printf(m, "\t%3ld MB at 0x%08lx (%s)\n",
 				m68k_memory[i].size >> 20, m68k_memory[i].addr,
 				(m68k_memory[i].addr & 0xff000000 ?
 				 "alternate RAM" : "ST-RAM"));
 
 #define ATARIHW_ANNOUNCE(name, str)			\
 	if (ATARIHW_PRESENT(name))			\
-		len += sprintf(buffer + len, "\t%s\n", str)
+		seq_printf(m, "\t%s\n", str)
 
-	len += sprintf(buffer + len, "Detected hardware:\n");
+	seq_printf(m, "Detected hardware:\n");
 	ATARIHW_ANNOUNCE(STND_SHIFTER, "ST Shifter");
 	ATARIHW_ANNOUNCE(EXTD_SHIFTER, "STe Shifter");
 	ATARIHW_ANNOUNCE(TT_SHIFTER, "TT Shifter");
@@ -654,6 +655,4 @@ static int atari_get_hardware_list(char *buffer)
 	ATARIHW_ANNOUNCE(BLITTER, "Blitter");
 	ATARIHW_ANNOUNCE(VME, "VME Bus");
 	ATARIHW_ANNOUNCE(DSP56K, "DSP56001 processor");
-
-	return len;
 }
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 65c9204..c072595 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -38,7 +38,6 @@
 #include <asm/bvme6000hw.h>
 
 static void bvme6000_get_model(char *model);
-static int  bvme6000_get_hardware_list(char *buffer);
 extern void bvme6000_sched_init(irq_handler_t handler);
 extern unsigned long bvme6000_gettimeoffset (void);
 extern int bvme6000_hwclk (int, struct rtc_time *);
@@ -82,15 +81,6 @@ static void bvme6000_get_model(char *model)
     sprintf(model, "BVME%d000", m68k_cputype == CPU_68060 ? 6 : 4);
 }
 
-
-/* No hardware options on BVME6000? */
-
-static int bvme6000_get_hardware_list(char *buffer)
-{
-    *buffer = '\0';
-    return 0;
-}
-
 /*
  * This function is called during kernel startup to initialize
  * the bvme6000 IRQ handling routines.
@@ -127,7 +117,6 @@ void __init config_bvme6000(void)
     mach_set_clock_mmss	 = bvme6000_set_clock_mmss;
     mach_reset		 = bvme6000_reset;
     mach_get_model       = bvme6000_get_model;
-    mach_get_hardware_list = bvme6000_get_hardware_list;
 
     printk ("Board is %sconfigured as a System Controller\n",
 		*config_reg_ptr & BVME_CONFIG_SW1 ? "" : "not ");
diff --git a/arch/m68k/kernel/setup.c b/arch/m68k/kernel/setup.c
index ea1e44d..4d97bd2 100644
--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/initrd.h>
@@ -80,7 +81,7 @@ void (*mach_sched_init) (irq_handler_t handler) __initdata = NULL;
 /* machine dependent irq functions */
 void (*mach_init_IRQ) (void) __initdata = NULL;
 void (*mach_get_model) (char *model);
-int (*mach_get_hardware_list) (char *buffer);
+void (*mach_get_hardware_list) (struct seq_file *m);
 /* machine dependent timer functions */
 unsigned long (*mach_gettimeoffset) (void);
 int (*mach_hwclk) (int, struct rtc_time*);
@@ -467,9 +468,9 @@ const struct seq_operations cpuinfo_op = {
 	.show	= show_cpuinfo,
 };
 
-int get_hardware_list(char *buffer)
+#ifdef CONFIG_PROC_HARDWARE
+static int hardware_proc_show(struct seq_file *m, void *v)
 {
-	int len = 0;
 	char model[80];
 	unsigned long mem;
 	int i;
@@ -479,17 +480,37 @@ int get_hardware_list(char *buffer)
 	else
 		strcpy(model, "Unknown m68k");
 
-	len += sprintf(buffer + len, "Model:\t\t%s\n", model);
+	seq_printf(m, "Model:\t\t%s\n", model);
 	for (mem = 0, i = 0; i < m68k_num_memory; i++)
 		mem += m68k_memory[i].size;
-	len += sprintf(buffer + len, "System Memory:\t%ldK\n", mem >> 10);
+	seq_printf(m, "System Memory:\t%ldK\n", mem >> 10);
 
 	if (mach_get_hardware_list)
-		len += mach_get_hardware_list(buffer + len);
+		mach_get_hardware_list(m);
 
-	return len;
+	return 0;
+}
+
+static int hardware_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, hardware_proc_show, NULL);
 }
 
+static const struct file_operations hardware_proc_fops = {
+	.open		= hardware_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init proc_hardware_init(void)
+{
+	proc_create("hardware", 0, NULL, &hardware_proc_fops);
+	return 0;
+}
+module_init(proc_hardware_init);
+#endif
+
 void check_bugs(void)
 {
 #ifndef CONFIG_M68KFPU_EMU
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 92fe507..43cdf47 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -37,7 +37,6 @@
 
 
 static void mvme147_get_model(char *model);
-static int  mvme147_get_hardware_list(char *buffer);
 extern void mvme147_sched_init(irq_handler_t handler);
 extern unsigned long mvme147_gettimeoffset (void);
 extern int mvme147_hwclk (int, struct rtc_time *);
@@ -76,14 +75,6 @@ static void mvme147_get_model(char *model)
 	sprintf(model, "Motorola MVME147");
 }
 
-
-static int mvme147_get_hardware_list(char *buffer)
-{
-	*buffer = '\0';
-
-	return 0;
-}
-
 /*
  * This function is called during kernel startup to initialize
  * the mvme147 IRQ handling routines.
@@ -104,7 +95,6 @@ void __init config_mvme147(void)
 	mach_set_clock_mmss	= mvme147_set_clock_mmss;
 	mach_reset		= mvme147_reset;
 	mach_get_model		= mvme147_get_model;
-	mach_get_hardware_list	= mvme147_get_hardware_list;
 
 	/* Board type is only set by newer versions of vmelilo/tftplilo */
 	if (!vme_brdtype)
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index 24cbc30..1521826 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -17,6 +17,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/tty.h>
 #include <linux/console.h>
 #include <linux/linkage.h>
@@ -42,7 +43,6 @@ extern t_bdid mvme_bdid;
 static MK48T08ptr_t volatile rtc = (MK48T08ptr_t)MVME_RTC_BASE;
 
 static void mvme16x_get_model(char *model);
-static int  mvme16x_get_hardware_list(char *buffer);
 extern void mvme16x_sched_init(irq_handler_t handler);
 extern unsigned long mvme16x_gettimeoffset (void);
 extern int mvme16x_hwclk (int, struct rtc_time *);
@@ -93,26 +93,21 @@ static void mvme16x_get_model(char *model)
 }
 
 
-static int mvme16x_get_hardware_list(char *buffer)
+static void mvme16x_get_hardware_list(struct seq_file *m)
 {
     p_bdid p = &mvme_bdid;
-    int len = 0;
 
     if (p->brdno == 0x0162 || p->brdno == 0x0172)
     {
 	unsigned char rev = *(unsigned char *)MVME162_VERSION_REG;
 
-	len += sprintf (buffer+len, "VMEchip2        %spresent\n",
+	seq_printf (m, "VMEchip2        %spresent\n",
 			rev & MVME16x_CONFIG_NO_VMECHIP2 ? "NOT " : "");
-	len += sprintf (buffer+len, "SCSI interface  %spresent\n",
+	seq_printf (m, "SCSI interface  %spresent\n",
 			rev & MVME16x_CONFIG_NO_SCSICHIP ? "NOT " : "");
-	len += sprintf (buffer+len, "Ethernet i/f    %spresent\n",
+	seq_printf (m, "Ethernet i/f    %spresent\n",
 			rev & MVME16x_CONFIG_NO_ETHERNET ? "NOT " : "");
     }
-    else
-	*buffer = '\0';
-
-    return (len);
 }
 
 /*
diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
index 9c7eefa..7110546 100644
--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -39,7 +39,6 @@
 extern irqreturn_t q40_process_int(int level, struct pt_regs *regs);
 extern void q40_init_IRQ(void);
 static void q40_get_model(char *model);
-static int  q40_get_hardware_list(char *buffer);
 extern void q40_sched_init(irq_handler_t handler);
 
 static unsigned long q40_gettimeoffset(void);
@@ -153,14 +152,6 @@ static void q40_get_model(char *model)
 	sprintf(model, "Q40");
 }
 
-/* No hardware options on Q40? */
-
-static int q40_get_hardware_list(char *buffer)
-{
-	*buffer = '\0';
-	return 0;
-}
-
 static unsigned int serports[] =
 {
 	0x3f8,0x2f8,0x3e8,0x2e8,0
@@ -191,7 +182,6 @@ void __init config_q40(void)
 
 	mach_reset = q40_reset;
 	mach_get_model = q40_get_model;
-	mach_get_hardware_list = q40_get_hardware_list;
 
 #if defined(CONFIG_INPUT_M68K_BEEP) || defined(CONFIG_INPUT_M68K_BEEP_MODULE)
 	mach_beep = q40_mksound;
diff --git a/arch/m68k/sun3/config.c b/arch/m68k/sun3/config.c
index 732087d..8dfaa20 100644
--- a/arch/m68k/sun3/config.c
+++ b/arch/m68k/sun3/config.c
@@ -11,6 +11,7 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/tty.h>
 #include <linux/console.h>
 #include <linux/init.h>
@@ -46,16 +47,9 @@ extern volatile unsigned char* sun3_intreg;
 extern unsigned long availmem;
 unsigned long num_pages;
 
-static int sun3_get_hardware_list(char *buffer)
+static void sun3_get_hardware_list(struct seq_file *m)
 {
-
-	int len = 0;
-
-	len += sprintf(buffer + len, "PROM Revision:\t%s\n",
-		       romvec->pv_monid);
-
-	return len;
-
+	seq_printf(m, "PROM Revision:\t%s\n", romvec->pv_monid);
 }
 
 void __init sun3_init(void)
diff --git a/arch/m68k/sun3x/config.c b/arch/m68k/sun3x/config.c
index 9878917..2b1ca2d 100644
--- a/arch/m68k/sun3x/config.c
+++ b/arch/m68k/sun3x/config.c
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/mm.h>
+#include <linux/seq_file.h>
 #include <linux/console.h>
 #include <linux/init.h>
 
@@ -31,16 +32,9 @@ void sun3_leds(unsigned int i)
 
 }
 
-static int sun3x_get_hardware_list(char *buffer)
+static void sun3x_get_hardware_list(struct seq_file *m)
 {
-
-	int len = 0;
-
-	len += sprintf(buffer + len, "PROM Revision:\t%s\n",
-		       romvec->pv_monid);
-
-	return len;
-
+	seq_printf(m, "PROM Revision:\t%s\n", romvec->pv_monid);
 }
 
 /*
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 49815af..8a9fc90 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -62,7 +62,6 @@
  * have a way to deal with that gracefully. Right now I used straightforward
  * wrappers, but this needs further analysis wrt potential overflows.
  */
-extern int get_hardware_list(char *);
 extern int get_stram_list(char *);
 extern int get_exec_domain_list(char *);
 
@@ -197,15 +196,6 @@ static const struct file_operations proc_vmstat_file_operations = {
 	.release	= seq_release,
 };
 
-#ifdef CONFIG_PROC_HARDWARE
-static int hardware_read_proc(char *page, char **start, off_t off,
-				 int count, int *eof, void *data)
-{
-	int len = get_hardware_list(page);
-	return proc_calc_metrics(page, start, off, count, eof, len);
-}
-#endif
-
 #ifdef CONFIG_STRAM_PROC
 static int stram_read_proc(char *page, char **start, off_t off,
 				 int count, int *eof, void *data)
@@ -670,9 +660,6 @@ void __init proc_misc_init(void)
 		char *name;
 		int (*read_proc)(char*,char**,off_t,int,int*,void*);
 	} *p, simple_ones[] = {
-#ifdef CONFIG_PROC_HARDWARE
-		{"hardware",	hardware_read_proc},
-#endif
 #ifdef CONFIG_STRAM_PROC
 		{"stram",	stram_read_proc},
 #endif
diff --git a/include/asm-m68k/machdep.h b/include/asm-m68k/machdep.h
index 26d2b91..5637dce 100644
--- a/include/asm-m68k/machdep.h
+++ b/include/asm-m68k/machdep.h
@@ -14,7 +14,7 @@ extern void (*mach_sched_init) (irq_handler_t handler);
 /* machine dependent irq functions */
 extern void (*mach_init_IRQ) (void);
 extern void (*mach_get_model) (char *model);
-extern int (*mach_get_hardware_list) (char *buffer);
+extern void (*mach_get_hardware_list) (struct seq_file *m);
 /* machine dependent timer functions */
 extern unsigned long (*mach_gettimeoffset)(void);
 extern int (*mach_hwclk)(int, struct rtc_time*);
-- 
1.5.6.5

