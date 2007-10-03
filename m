Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbXJCQuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbXJCQuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 12:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbXJCQuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 12:50:44 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:32730 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbXJCQul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 12:50:41 -0400
X-IronPort-AV: i="4.21,225,1188792000"; 
   d="scan'208"; a="41022764:sNHT50269478"
Subject: [GIT PULL] Blackfin fixing for 2.6.23-rc9
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Thu, 04 Oct 2007 00:50:32 +0800
Message-Id: <1191430232.25751.8.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 03 Oct 2007 16:50:39.0258 (UTC) FILETIME=[8719B7A0:01C805DD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

In this fixing patch sets, including

 - fix binfmt_flat Blackfin arch break
 - kill compiling checksyscall.pl warning
 - fix bfin_mac driver compile failing bug by adding missing gpio pinmux
API which should 
   be merged at least 1 month ago

IMO, it should be merged in 2.6.23 stable release, so please pull from
'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git
for-linus

to receive the following updates:

 arch/blackfin/kernel/bfin_gpio.c                  |  285 ++++++++++++++++++---
 arch/blackfin/mach-common/entry.S                 |   23 ++-
 fs/binfmt_flat.c                                  |    6 +-
 include/asm-blackfin/mach-bf533/bfin_serial_5xx.h |   11 +-
 include/asm-blackfin/mach-bf537/bfin_serial_5xx.h |   23 +-
 include/asm-blackfin/mach-bf537/portmux.h         |   35 +++-
 include/asm-blackfin/mach-bf561/bfin_serial_5xx.h |   11 +-
 include/asm-blackfin/portmux.h                    |   55 ++++
 include/asm-blackfin/unistd.h                     |   56 ++++-
 include/asm-h8300/flat.h                          |    3 +-
 include/asm-m32r/flat.h                           |    3 +-
 include/asm-m68knommu/flat.h                      |    3 +-
 include/asm-sh/flat.h                             |    3 +-
 include/asm-v850/flat.h                           |    4 +-
 14 files changed, 456 insertions(+), 65 deletions(-)

Andrew Morton (1):
      binfmt_flat: checkpatch fixing minimum support for the blackfin relocations

Bernd Schmidt (1):
      Binfmt_flat: Add minimum support for the Blackfin relocations

Bryan Wu (1):
      Blackfin arch: add some missing syscall

Michael Hennerich (2):
      Blackfin arch: gpio pinmux and resource allocation API required by BF537 on chip ethernet mac driver
      Blackfin arch: fix PORT_J BUG for BF537/6 EMAC driver reported by Kalle Pokki <kalle.pokki@iki.fi>

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index bafcfa5..5d488ef 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -84,6 +84,7 @@
 #include <linux/err.h>
 #include <asm/blackfin.h>
 #include <asm/gpio.h>
+#include <asm/portmux.h>
 #include <linux/irq.h>
 
 #ifdef BF533_FAMILY
@@ -115,7 +116,11 @@ static struct gpio_port_t *gpio_bankb[gpio_bank(MAX_BLACKFIN_GPIOS)] = {
 };
 #endif
 
-static unsigned short reserved_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
+static unsigned short reserved_gpio_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
+static unsigned short reserved_peri_map[gpio_bank(MAX_BLACKFIN_GPIOS + 16)];
+char *str_ident = NULL;
+
+#define RESOURCE_LABEL_SIZE 16
 
 #ifdef CONFIG_PM
 static unsigned short wakeup_map[gpio_bank(MAX_BLACKFIN_GPIOS)];
@@ -143,22 +148,100 @@ inline int check_gpio(unsigned short gpio)
 	return 0;
 }
 
+static void set_label(unsigned short ident, const char *label)
+{
+
+	if (label && str_ident) {
+		strncpy(str_ident + ident * RESOURCE_LABEL_SIZE, label,
+			 RESOURCE_LABEL_SIZE);
+		str_ident[ident * RESOURCE_LABEL_SIZE +
+			 RESOURCE_LABEL_SIZE - 1] = 0;
+	}
+}
+
+static char *get_label(unsigned short ident)
+{
+	if (!str_ident)
+		return "UNKNOWN";
+
+	return (str_ident[ident * RESOURCE_LABEL_SIZE] ?
+		(str_ident + ident * RESOURCE_LABEL_SIZE) : "UNKNOWN");
+}
+
+static int cmp_label(unsigned short ident, const char *label)
+{
+	if (label && str_ident)
+		return strncmp(str_ident + ident * RESOURCE_LABEL_SIZE,
+				 label, strlen(label));
+	else
+		return -EINVAL;
+}
+
 #ifdef BF537_FAMILY
 static void port_setup(unsigned short gpio, unsigned short usage)
 {
-	if (usage == GPIO_USAGE) {
-		if (*port_fer[gpio_bank(gpio)] & gpio_bit(gpio))
-			printk(KERN_WARNING "bfin-gpio: Possible Conflict with Peripheral "
-			       "usage and GPIO %d detected!\n", gpio);
-		*port_fer[gpio_bank(gpio)] &= ~gpio_bit(gpio);
-	} else
-		*port_fer[gpio_bank(gpio)] |= gpio_bit(gpio);
-	SSYNC();
+	if (!check_gpio(gpio)) {
+		if (usage == GPIO_USAGE) {
+			*port_fer[gpio_bank(gpio)] &= ~gpio_bit(gpio);
+		} else
+			*port_fer[gpio_bank(gpio)] |= gpio_bit(gpio);
+		SSYNC();
+	}
 }
 #else
 # define port_setup(...)  do { } while (0)
 #endif
 
+#ifdef BF537_FAMILY
+
+#define PMUX_LUT_RES		0
+#define PMUX_LUT_OFFSET		1
+#define PMUX_LUT_ENTRIES	41
+#define PMUX_LUT_SIZE		2
+
+static unsigned short port_mux_lut[PMUX_LUT_ENTRIES][PMUX_LUT_SIZE] = {
+	{P_PPI0_D13, 11}, {P_PPI0_D14, 11}, {P_PPI0_D15, 11},
+	{P_SPORT1_TFS, 11}, {P_SPORT1_TSCLK, 11}, {P_SPORT1_DTPRI, 11},
+	{P_PPI0_D10, 10}, {P_PPI0_D11, 10}, {P_PPI0_D12, 10},
+	{P_SPORT1_RSCLK, 10}, {P_SPORT1_RFS, 10}, {P_SPORT1_DRPRI, 10},
+	{P_PPI0_D8, 9}, {P_PPI0_D9, 9}, {P_SPORT1_DRSEC, 9},
+	{P_SPORT1_DTSEC, 9}, {P_TMR2, 8}, {P_PPI0_FS3, 8}, {P_TMR3, 7},
+	{P_SPI0_SSEL4, 7}, {P_TMR4, 6}, {P_SPI0_SSEL5, 6}, {P_TMR5, 5},
+	{P_SPI0_SSEL6, 5}, {P_UART1_RX, 4}, {P_UART1_TX, 4}, {P_TMR6, 4},
+	{P_TMR7, 4}, {P_UART0_RX, 3}, {P_UART0_TX, 3}, {P_DMAR0, 3},
+	{P_DMAR1, 3}, {P_SPORT0_DTSEC, 1}, {P_SPORT0_DRSEC, 1},
+	{P_CAN0_RX, 1}, {P_CAN0_TX, 1}, {P_SPI0_SSEL7, 1},
+	{P_SPORT0_TFS, 0}, {P_SPORT0_DTPRI, 0}, {P_SPI0_SSEL2, 0},
+	{P_SPI0_SSEL3, 0}
+};
+
+static void portmux_setup(unsigned short per, unsigned short function)
+{
+	u16 y, muxreg, offset;
+
+	for (y = 0; y < PMUX_LUT_ENTRIES; y++) {
+		if (port_mux_lut[y][PMUX_LUT_RES] == per) {
+
+			/* SET PORTMUX REG */
+
+			offset = port_mux_lut[y][PMUX_LUT_OFFSET];
+			muxreg = bfin_read_PORT_MUX();
+
+			if (offset != 1) {
+				muxreg &= ~(1 << offset);
+			} else {
+				muxreg &= ~(3 << 1);
+			}
+
+			muxreg |= (function << offset);
+			bfin_write_PORT_MUX(muxreg);
+		}
+	}
+}
+
+#else
+# define portmux_setup(...)  do { } while (0)
+#endif
 
 static void default_gpio(unsigned short gpio)
 {
@@ -179,22 +262,15 @@ static void default_gpio(unsigned short gpio)
 
 static int __init bfin_gpio_init(void)
 {
-	int i;
-
-	printk(KERN_INFO "Blackfin GPIO Controller\n");
 
-	for (i = 0; i < MAX_BLACKFIN_GPIOS; i += GPIO_BANKSIZE)
-		reserved_map[gpio_bank(i)] = 0;
+	str_ident = kzalloc(RESOURCE_LABEL_SIZE * 256, GFP_KERNEL);
+	if (!str_ident)
+		return -ENOMEM;
 
-#if defined(BF537_FAMILY) && (defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE))
-# if defined(CONFIG_BFIN_MAC_RMII)
-	reserved_map[gpio_bank(PORT_H)] = 0xC373;
-# else
-	reserved_map[gpio_bank(PORT_H)] = 0xFFFF;
-# endif
-#endif
+	printk(KERN_INFO "Blackfin GPIO Controller\n");
 
 	return 0;
+
 }
 
 arch_initcall(bfin_gpio_init);
@@ -223,7 +299,7 @@ arch_initcall(bfin_gpio_init);
 void set_gpio_ ## name(unsigned short gpio, unsigned short arg) \
 { \
 	unsigned long flags; \
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
 	local_irq_save(flags); \
 	if (arg) \
 		gpio_bankb[gpio_bank(gpio)]->name |= gpio_bit(gpio); \
@@ -243,7 +319,7 @@ SET_GPIO(both)
 #define SET_GPIO_SC(name) \
 void set_gpio_ ## name(unsigned short gpio, unsigned short arg) \
 { \
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))); \
 	if (arg) \
 		gpio_bankb[gpio_bank(gpio)]->name ## _set = gpio_bit(gpio); \
 	else \
@@ -258,7 +334,7 @@ SET_GPIO_SC(maskb)
 void set_gpio_data(unsigned short gpio, unsigned short arg)
 {
 	unsigned long flags;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	if (arg)
 		gpio_bankb[gpio_bank(gpio)]->data_set = gpio_bit(gpio);
@@ -277,7 +353,7 @@ SET_GPIO_SC(data)
 void set_gpio_toggle(unsigned short gpio)
 {
 	unsigned long flags;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->toggle = gpio_bit(gpio);
 	bfin_read_CHIPID();
@@ -286,7 +362,7 @@ void set_gpio_toggle(unsigned short gpio)
 #else
 void set_gpio_toggle(unsigned short gpio)
 {
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	gpio_bankb[gpio_bank(gpio)]->toggle = gpio_bit(gpio);
 }
 #endif
@@ -350,7 +426,7 @@ unsigned short get_gpio_data(unsigned short gpio)
 {
 	unsigned long flags;
 	unsigned short ret;
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 	local_irq_save(flags);
 	ret = 0x01 & (gpio_bankb[gpio_bank(gpio)]->data >> gpio_sub_n(gpio));
 	bfin_read_CHIPID();
@@ -494,13 +570,14 @@ u32 gpio_pm_setup(void)
 			gpio_bank_saved[bank].dir   = gpio_bankb[bank]->dir;
 			gpio_bank_saved[bank].edge  = gpio_bankb[bank]->edge;
 			gpio_bank_saved[bank].both  = gpio_bankb[bank]->both;
-			gpio_bank_saved[bank].reserved = reserved_map[bank];
+			gpio_bank_saved[bank].reserved =
+						reserved_gpio_map[bank];
 
 			gpio = i;
 
 			while (mask) {
 				if (mask & 1) {
-					reserved_map[gpio_bank(gpio)] |=
+					reserved_gpio_map[gpio_bank(gpio)] |=
 							gpio_bit(gpio);
 					bfin_gpio_wakeup_type(gpio,
 						wakeup_flags_map[gpio]);
@@ -540,7 +617,8 @@ void gpio_pm_restore(void)
 			gpio_bankb[bank]->edge  = gpio_bank_saved[bank].edge;
 			gpio_bankb[bank]->both  = gpio_bank_saved[bank].both;
 
-			reserved_map[bank] = gpio_bank_saved[bank].reserved;
+			reserved_gpio_map[bank] =
+					gpio_bank_saved[bank].reserved;
 
 		}
 
@@ -550,6 +628,141 @@ void gpio_pm_restore(void)
 
 #endif
 
+
+
+
+int peripheral_request(unsigned short per, const char *label)
+{
+	unsigned long flags;
+	unsigned short ident = P_IDENT(per);
+
+	/*
+	 * Don't cares are pins with only one dedicated function
+	 */
+
+	if (per & P_DONTCARE)
+		return 0;
+
+	if (!(per & P_DEFINED))
+		return -ENODEV;
+
+	local_irq_save(flags);
+
+	if (!check_gpio(ident)) {
+
+	if (unlikely(reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
+		printk(KERN_ERR
+		       "%s: Peripheral %d is already reserved as GPIO by %s !\n",
+		       __FUNCTION__, ident, get_label(ident));
+		dump_stack();
+		local_irq_restore(flags);
+		return -EBUSY;
+	}
+
+	}
+
+	if (unlikely(reserved_peri_map[gpio_bank(ident)] & gpio_bit(ident))) {
+
+	/*
+	 * Pin functions like AMC address strobes my
+	 * be requested and used by several drivers
+	 */
+
+	if (!(per & P_MAYSHARE)) {
+
+	/*
+	 * Allow that the identical pin function can
+	 * be requested from the same driver twice
+	 */
+
+		if (cmp_label(ident, label) == 0)
+			goto anyway;
+
+			printk(KERN_ERR
+			       "%s: Peripheral %d function %d is already"
+			       "reserved by %s !\n",
+			       __FUNCTION__, ident, P_FUNCT2MUX(per),
+				get_label(ident));
+			dump_stack();
+			local_irq_restore(flags);
+			return -EBUSY;
+		}
+
+	}
+
+anyway:
+
+
+	portmux_setup(per, P_FUNCT2MUX(per));
+
+	port_setup(ident, PERIPHERAL_USAGE);
+
+	reserved_peri_map[gpio_bank(ident)] |= gpio_bit(ident);
+	local_irq_restore(flags);
+	set_label(ident, label);
+
+	return 0;
+}
+EXPORT_SYMBOL(peripheral_request);
+
+int peripheral_request_list(unsigned short per[], const char *label)
+{
+	u16 cnt;
+	int ret;
+
+	for (cnt = 0; per[cnt] != 0; cnt++) {
+		ret = peripheral_request(per[cnt], label);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(peripheral_request_list);
+
+void peripheral_free(unsigned short per)
+{
+	unsigned long flags;
+	unsigned short ident = P_IDENT(per);
+
+	if (per & P_DONTCARE)
+		return;
+
+	if (!(per & P_DEFINED))
+		return;
+
+	if (check_gpio(ident) < 0)
+		return;
+
+	local_irq_save(flags);
+
+	if (unlikely(!(reserved_peri_map[gpio_bank(ident)]
+			 & gpio_bit(ident)))) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	if (!(per & P_MAYSHARE)) {
+		port_setup(ident, GPIO_USAGE);
+	}
+
+	reserved_peri_map[gpio_bank(ident)] &= ~gpio_bit(ident);
+
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(peripheral_free);
+
+void peripheral_free_list(unsigned short per[])
+{
+	u16 cnt;
+
+	for (cnt = 0; per[cnt] != 0; cnt++) {
+		peripheral_free(per[cnt]);
+	}
+
+}
+EXPORT_SYMBOL(peripheral_free_list);
+
 /***********************************************************
 *
 * FUNCTIONS: Blackfin GPIO Driver
@@ -574,13 +787,13 @@ int gpio_request(unsigned short gpio, const char *label)
 
 	local_irq_save(flags);
 
-	if (unlikely(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
+	if (unlikely(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio))) {
 		printk(KERN_ERR "bfin-gpio: GPIO %d is already reserved!\n", gpio);
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
 	}
-	reserved_map[gpio_bank(gpio)] |= gpio_bit(gpio);
+	reserved_gpio_map[gpio_bank(gpio)] |= gpio_bit(gpio);
 
 	local_irq_restore(flags);
 
@@ -599,7 +812,7 @@ void gpio_free(unsigned short gpio)
 
 	local_irq_save(flags);
 
-	if (unlikely(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)))) {
+	if (unlikely(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)))) {
 		printk(KERN_ERR "bfin-gpio: GPIO %d wasn't reserved!\n", gpio);
 		dump_stack();
 		local_irq_restore(flags);
@@ -608,7 +821,7 @@ void gpio_free(unsigned short gpio)
 
 	default_gpio(gpio);
 
-	reserved_map[gpio_bank(gpio)] &= ~gpio_bit(gpio);
+	reserved_gpio_map[gpio_bank(gpio)] &= ~gpio_bit(gpio);
 
 	local_irq_restore(flags);
 }
@@ -618,7 +831,7 @@ void gpio_direction_input(unsigned short gpio)
 {
 	unsigned long flags;
 
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->dir &= ~gpio_bit(gpio);
@@ -631,7 +844,7 @@ void gpio_direction_output(unsigned short gpio)
 {
 	unsigned long flags;
 
-	BUG_ON(!(reserved_map[gpio_bank(gpio)] & gpio_bit(gpio)));
+	BUG_ON(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)));
 
 	local_irq_save(flags);
 	gpio_bankb[gpio_bank(gpio)]->inen &= ~gpio_bit(gpio);
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index d61bba9..9604588 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -815,7 +815,7 @@ _extable:
 
 ALIGN
 ENTRY(_sys_call_table)
-	.long _sys_ni_syscall	/* 0  -  old "setup()" system call*/
+	.long _sys_restart_syscall	/* 0 */
 	.long _sys_exit
 	.long _sys_fork
 	.long _sys_read
@@ -978,13 +978,13 @@ ENTRY(_sys_call_table)
 	.long _sys_sched_get_priority_min  /* 160 */
 	.long _sys_sched_rr_get_interval
 	.long _sys_nanosleep
-	.long _sys_ni_syscall	/* sys_mremap */
+	.long _sys_mremap
 	.long _sys_setresuid	/* setresuid16 */
 	.long _sys_getresuid	/* getresuid16 */	/* 165 */
 	.long _sys_ni_syscall	/* for vm86 */
 	.long _sys_ni_syscall	/* old "query_module" */
 	.long _sys_ni_syscall	/* sys_poll */
-	.long _sys_ni_syscall	/* sys_nfsservctl */
+	.long _sys_nfsservctl
 	.long _sys_setresgid	/* setresgid16 */	/* 170 */
 	.long _sys_getresgid	/* getresgid16 */
 	.long _sys_prctl
@@ -1040,7 +1040,7 @@ ENTRY(_sys_call_table)
 	.long _sys_ni_syscall	/* reserved for TUX */
 	.long _sys_ni_syscall
 	.long _sys_gettid
-	.long _sys_ni_syscall	/* 225 */ /* sys_readahead */
+	.long _sys_readahead	/* 225 */
 	.long _sys_setxattr
 	.long _sys_lsetxattr
 	.long _sys_fsetxattr
@@ -1157,6 +1157,21 @@ ENTRY(_sys_call_table)
 	.long _sys_shmctl
 	.long _sys_shmdt	/* 340 */
 	.long _sys_shmget
+	.long _sys_splice
+	.long _sys_sync_file_range
+	.long _sys_tee
+	.long _sys_vmsplice	/* 345 */
+	.long _sys_epoll_pwait
+	.long _sys_utimensat
+	.long _sys_signalfd
+	.long _sys_timerfd
+	.long _sys_eventfd	/* 350 */
+	.long _sys_pread64
+	.long _sys_pwrite64
+	.long _sys_fadvise64
+	.long _sys_set_robust_list
+	.long _sys_get_robust_list	/* 355 */
+	.long _sys_fallocate
 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
 	.endr
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 861141b..fcb3405 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -742,6 +742,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 	 * __start to address 4 so that is okay).
 	 */
 	if (rev > OLD_FLAT_VERSION) {
+		unsigned long persistent = 0;
 		for (i=0; i < relocs; i++) {
 			unsigned long addr, relval;
 
@@ -749,6 +750,8 @@ static int load_flat_file(struct linux_binprm * bprm,
 			   relocated (of course, the address has to be
 			   relocated first).  */
 			relval = ntohl(reloc[i]);
+			if (flat_set_persistent (relval, &persistent))
+				continue;
 			addr = flat_get_relocate_addr(relval);
 			rp = (unsigned long *) calc_reloc(addr, libinfo, id, 1);
 			if (rp == (unsigned long *)RELOC_FAILED) {
@@ -757,7 +760,8 @@ static int load_flat_file(struct linux_binprm * bprm,
 			}
 
 			/* Get the pointer's value.  */
-			addr = flat_get_addr_from_rp(rp, relval, flags);
+			addr = flat_get_addr_from_rp(rp, relval, flags,
+							&persistent);
 			if (addr != 0) {
 				/*
 				 * Do the relocation.  PIC relocs in the data section are
diff --git a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
index e043caf..69b9f8e 100644
--- a/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf533/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS                1
 
@@ -92,18 +93,24 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	}
 };
 
+#define DRIVER_NAME "bfin-uart"
 
 int nr_ports = NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
index 8f5d9c4..6fb328f 100644
--- a/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf537/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS		2
 
@@ -122,25 +123,29 @@ struct bfin_serial_res bfin_serial_resource[] = {
 
 int nr_ports = ARRAY_SIZE(bfin_serial_resource);
 
+#define DRIVER_NAME "bfin-uart"
+
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
-	unsigned short val;
-	val = bfin_read16(BFIN_PORT_MUX);
-	val &= ~(PFDE | PFTE);
-	bfin_write16(BFIN_PORT_MUX, val);
 
-	val = bfin_read16(PORTF_FER);
-	val |= 0xF;
-	bfin_write16(PORTF_FER, val);
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
+#ifdef CONFIG_SERIAL_BFIN_UART1
+	peripheral_request(P_UART1_TX, DRIVER_NAME);
+	peripheral_request(P_UART1_RX, DRIVER_NAME);
+#endif
 
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_output(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/mach-bf537/portmux.h b/include/asm-blackfin/mach-bf537/portmux.h
index 23e13c5..ae6c53b 100644
--- a/include/asm-blackfin/mach-bf537/portmux.h
+++ b/include/asm-blackfin/mach-bf537/portmux.h
@@ -106,4 +106,37 @@
 #define P_SPI0_SSEL2	(P_DEFINED | P_IDENT(PORT_PJ11) | P_FUNCT(1))
 #define P_SPI0_SSEL7	(P_DEFINED | P_IDENT(PORT_PJ5) | P_FUNCT(2))
 
-#endif /* _MACH_PORTMUX_H_ */
+#define P_MII0 {\
+	P_MII0_ETxD0, \
+	P_MII0_ETxD1, \
+	P_MII0_ETxD2, \
+	P_MII0_ETxD3, \
+	P_MII0_ETxEN, \
+	P_MII0_TxCLK, \
+	P_MII0_PHYINT, \
+	P_MII0_COL, \
+	P_MII0_ERxD0, \
+	P_MII0_ERxD1, \
+	P_MII0_ERxD2, \
+	P_MII0_ERxD3, \
+	P_MII0_ERxDV, \
+	P_MII0_ERxCLK, \
+	P_MII0_ERxER, \
+	P_MII0_CRS, \
+	P_MDC, \
+	P_MDIO, 0}
+
+
+#define P_RMII0 {\
+	P_MII0_ETxD0, \
+	P_MII0_ETxD1, \
+	P_MII0_ETxEN, \
+	P_MII0_ERxD0, \
+	P_MII0_ERxD1, \
+	P_MII0_ERxER, \
+	P_RMII0_REF_CLK, \
+	P_RMII0_MDINT, \
+	P_RMII0_CRS_DV, \
+	P_MDC, \
+	P_MDIO, 0}
+#endif			        	/* _MACH_PORTMUX_H_ */
diff --git a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
index e043caf..69b9f8e 100644
--- a/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
+++ b/include/asm-blackfin/mach-bf561/bfin_serial_5xx.h
@@ -1,5 +1,6 @@
 #include <linux/serial.h>
 #include <asm/dma.h>
+#include <asm/portmux.h>
 
 #define NR_PORTS                1
 
@@ -92,18 +93,24 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	}
 };
 
+#define DRIVER_NAME "bfin-uart"
 
 int nr_ports = NR_PORTS;
 static void bfin_serial_hw_init(struct bfin_serial_port *uart)
 {
 
+#ifdef CONFIG_SERIAL_BFIN_UART0
+	peripheral_request(P_UART0_TX, DRIVER_NAME);
+	peripheral_request(P_UART0_RX, DRIVER_NAME);
+#endif
+
 #ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	if (uart->cts_pin >= 0) {
-		gpio_request(uart->cts_pin, NULL);
+		gpio_request(uart->cts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->cts_pin);
 	}
 	if (uart->rts_pin >= 0) {
-		gpio_request(uart->rts_pin, NULL);
+		gpio_request(uart->rts_pin, DRIVER_NAME);
 		gpio_direction_input(uart->rts_pin);
 	}
 #endif
diff --git a/include/asm-blackfin/portmux.h b/include/asm-blackfin/portmux.h
index 9d3681e..0d3f650 100644
--- a/include/asm-blackfin/portmux.h
+++ b/include/asm-blackfin/portmux.h
@@ -14,6 +14,12 @@
 #define P_MAYSHARE	0x2000
 #define P_DONTCARE	0x1000
 
+
+int peripheral_request(unsigned short per, const char *label);
+void peripheral_free(unsigned short per);
+int peripheral_request_list(unsigned short per[], const char *label);
+void peripheral_free_list(unsigned short per[]);
+
 #include <asm/gpio.h>
 #include <asm/mach/portmux.h>
 
@@ -145,6 +151,22 @@
 #define P_SPI2_SSEL3 P_UNDEF
 #endif
 
+#ifndef P_SPI2_SSEL4
+#define P_SPI2_SSEL4 P_UNDEF
+#endif
+
+#ifndef P_SPI2_SSEL5
+#define P_SPI2_SSEL5 P_UNDEF
+#endif
+
+#ifndef P_SPI2_SSEL6
+#define P_SPI2_SSEL6 P_UNDEF
+#endif
+
+#ifndef P_SPI2_SSEL7
+#define P_SPI2_SSEL7 P_UNDEF
+#endif
+
 #ifndef P_SPI2_SCK
 #define P_SPI2_SCK P_UNDEF
 #endif
@@ -513,6 +535,22 @@
 #define P_SPI0_SSEL3 P_UNDEF
 #endif
 
+#ifndef P_SPI0_SSEL4
+#define P_SPI0_SSEL4 P_UNDEF
+#endif
+
+#ifndef P_SPI0_SSEL5
+#define P_SPI0_SSEL5 P_UNDEF
+#endif
+
+#ifndef P_SPI0_SSEL6
+#define P_SPI0_SSEL6 P_UNDEF
+#endif
+
+#ifndef P_SPI0_SSEL7
+#define P_SPI0_SSEL7 P_UNDEF
+#endif
+
 #ifndef P_UART0_TX
 #define P_UART0_TX P_UNDEF
 #endif
@@ -741,6 +779,23 @@
 #define P_SPI1_SSEL3 P_UNDEF
 #endif
 
+
+#ifndef P_SPI1_SSEL4
+#define P_SPI1_SSEL4 P_UNDEF
+#endif
+
+#ifndef P_SPI1_SSEL5
+#define P_SPI1_SSEL5 P_UNDEF
+#endif
+
+#ifndef P_SPI1_SSEL6
+#define P_SPI1_SSEL6 P_UNDEF
+#endif
+
+#ifndef P_SPI1_SSEL7
+#define P_SPI1_SSEL7 P_UNDEF
+#endif
+
 #ifndef P_SPI1_SCK
 #define P_SPI1_SCK P_UNDEF
 #endif
diff --git a/include/asm-blackfin/unistd.h b/include/asm-blackfin/unistd.h
index 0df9f2d..07ffe8b 100644
--- a/include/asm-blackfin/unistd.h
+++ b/include/asm-blackfin/unistd.h
@@ -3,6 +3,7 @@
 /*
  * This file contains the system call numbers.
  */
+#define __NR_restart_syscall	  0
 #define __NR_exit		  1
 #define __NR_fork		  2
 #define __NR_read		  3
@@ -165,13 +166,13 @@
 #define __NR_sched_get_priority_min	160
 #define __NR_sched_rr_get_interval	161
 #define __NR_nanosleep		162
-				/* 163 __NR_mremap */
+#define __NR_mremap		163
 #define __NR_setresuid		164
 #define __NR_getresuid		165
 				/* 166 __NR_vm86 */
 				/* 167 __NR_query_module */
 				/* 168 __NR_poll */
-				/* 169 __NR_nfsservctl */
+#define __NR_nfsservctl		169
 #define __NR_setresgid		170
 #define __NR_getresgid		171
 #define __NR_prctl		172
@@ -227,7 +228,7 @@
 				/* 222 reserved for TUX */
 				/* 223 reserved for TUX */
 #define __NR_gettid		224
-				/* 225 __NR_readahead */
+#define __NR_readahead		225
 #define __NR_setxattr		226
 #define __NR_lsetxattr		227
 #define __NR_fsetxattr		228
@@ -287,7 +288,7 @@
 #define __NR_mq_timedreceive	(__NR_mq_open+3)
 #define __NR_mq_notify		(__NR_mq_open+4)
 #define __NR_mq_getsetattr	(__NR_mq_open+5)
-				/* 284 __NR_sys_kexec_load */
+#define __NR_kexec_load		284
 #define __NR_waitid		285
 #define __NR_add_key		286
 #define __NR_request_key	287
@@ -352,9 +353,54 @@
 #define __NR_shmdt		340
 #define __NR_shmget		341
 
-#define __NR_syscall		342
+#define __NR_splice		342
+#define __NR_sync_file_range	343
+#define __NR_tee		344
+#define __NR_vmsplice		345
+
+#define __NR_epoll_pwait	346
+#define __NR_utimensat		347
+#define __NR_signalfd		348
+#define __NR_timerfd		349
+#define __NR_eventfd		350
+#define __NR_pread64		351
+#define __NR_pwrite64		352
+#define __NR_fadvise64		353
+#define __NR_set_robust_list	354
+#define __NR_get_robust_list	355
+#define __NR_fallocate		356
+
+#define __NR_syscall		357
 #define NR_syscalls		__NR_syscall
 
+/* Old optional stuff no one actually uses */
+#define __IGNORE_sysfs
+#define __IGNORE_uselib
+
+/* Implement the newer interfaces */
+#define __IGNORE_mmap
+#define __IGNORE_poll
+#define __IGNORE_select
+#define __IGNORE_utime
+
+/* Not relevant on no-mmu */
+#define __IGNORE_swapon
+#define __IGNORE_swapoff
+#define __IGNORE_msync
+#define __IGNORE_mlock
+#define __IGNORE_munlock
+#define __IGNORE_mlockall
+#define __IGNORE_munlockall
+#define __IGNORE_mincore
+#define __IGNORE_madvise
+#define __IGNORE_remap_file_pages
+#define __IGNORE_mbind
+#define __IGNORE_get_mempolicy
+#define __IGNORE_set_mempolicy
+#define __IGNORE_migrate_pages
+#define __IGNORE_move_pages
+#define __IGNORE_getcpu
+
 #ifdef __KERNEL__
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
diff --git a/include/asm-h8300/flat.h b/include/asm-h8300/flat.h
index c20eee7..2a87350 100644
--- a/include/asm-h8300/flat.h
+++ b/include/asm-h8300/flat.h
@@ -9,6 +9,7 @@
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		1
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
+#define	flat_set_persistent(relval, p)		0
 
 /*
  * on the H8 a couple of the relocations have an instruction in the
@@ -18,7 +19,7 @@
  */
 
 #define	flat_get_relocate_addr(rel)		(rel)
-#define flat_get_addr_from_rp(rp, relval, flags) \
+#define flat_get_addr_from_rp(rp, relval, flags, persistent) \
         (get_unaligned(rp) & ((flags & FLAT_FLAG_GOTPIC) ? 0xffffffff: 0x00ffffff))
 #define flat_put_addr_at_rp(rp, addr, rel) \
 	put_unaligned (((*(char *)(rp)) << 24) | ((addr) & 0x00ffffff), rp)
diff --git a/include/asm-m32r/flat.h b/include/asm-m32r/flat.h
index 1b285f6..d851cf0 100644
--- a/include/asm-m32r/flat.h
+++ b/include/asm-m32r/flat.h
@@ -15,9 +15,10 @@
 #define	flat_stack_align(sp)		(*sp += (*sp & 3 ? (4 - (*sp & 3)): 0))
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
+#define	flat_set_persistent(relval, p)		0
 #define	flat_reloc_valid(reloc, size)		\
 	(((reloc) - textlen_for_m32r_lo16_data) <= (size))
-#define flat_get_addr_from_rp(rp, relval, flags) \
+#define flat_get_addr_from_rp(rp, relval, flags, persistent) \
 	m32r_flat_get_addr_from_rp(rp, relval, (text_len) )
 
 #define flat_put_addr_at_rp(rp, addr, relval) \
diff --git a/include/asm-m68knommu/flat.h b/include/asm-m68knommu/flat.h
index 2d836ed..814b517 100644
--- a/include/asm-m68knommu/flat.h
+++ b/include/asm-m68knommu/flat.h
@@ -9,8 +9,9 @@
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
-#define	flat_get_addr_from_rp(rp, relval, flags)	get_unaligned(rp)
+#define	flat_get_addr_from_rp(rp, relval, flags, p)	get_unaligned(rp)
 #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
 #define	flat_get_relocate_addr(rel)		(rel)
+#define	flat_set_persistent(relval, p)		0
 
 #endif /* __M68KNOMMU_FLAT_H__ */
diff --git a/include/asm-sh/flat.h b/include/asm-sh/flat.h
index 0d5cc04..dc4f595 100644
--- a/include/asm-sh/flat.h
+++ b/include/asm-sh/flat.h
@@ -16,8 +16,9 @@
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
-#define	flat_get_addr_from_rp(rp, relval, flags)	get_unaligned(rp)
+#define	flat_get_addr_from_rp(rp, relval, flags, p)	get_unaligned(rp)
 #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
 #define	flat_get_relocate_addr(rel)		(rel)
+#define	flat_set_persistent(relval, p)		0
 
 #endif /* __ASM_SH_FLAT_H */
diff --git a/include/asm-v850/flat.h b/include/asm-v850/flat.h
index 3888f59..17f0ea5 100644
--- a/include/asm-v850/flat.h
+++ b/include/asm-v850/flat.h
@@ -25,6 +25,7 @@
 #define	flat_stack_align(sp)		/* nothing needed */
 #define	flat_argvp_envp_on_stack()	0
 #define	flat_old_ram_flag(flags)	(flags)
+#define	flat_set_persistent(relval, p)	0
 
 /* We store the type of relocation in the top 4 bits of the `relval.' */
 
@@ -46,7 +47,8 @@ flat_get_relocate_addr (unsigned long relval)
    For the v850, RP should always be half-word aligned.  */
 static inline unsigned long flat_get_addr_from_rp (unsigned long *rp,
 						   unsigned long relval,
-						   unsigned long flags)
+						   unsigned long flags,
+						   unsigned long *persistent)
 {
 	short *srp = (short *)rp;
 
