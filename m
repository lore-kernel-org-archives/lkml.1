Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbYH3Ja0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbYH3Ja0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 05:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYH3JaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 05:30:16 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:64851 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbYH3JaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 05:30:11 -0400
Message-ID: <48B912B7.9030806@hypersurf.com>
Date: Sat, 30 Aug 2008 02:28:23 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] Add low level PLL config register interface module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a small module to handle the low level details of dealing with the
PLL config register (HID1) found in the IBM 750GX. It provides 2 possible
interfaces, both selectable via kernel config options. One is a sysfs attribute
and the other is a normal function API. It is called pll_if.

The determination of the bus frequency is what worked on a PowerMac 8600. Any
suggestions on a more general solution are welcome.

After receiving comments, I added an argument for the data item to the
notifier register functions exported for the cpufreq API.

I also fixed a deadlock if the module is unloaded before _modify_PLL() is ever
called.

My name is Kevin Diggs and I approve this patch.

Signed-off-by: Kevin Diggs <kevdig@hypersurf.com>


Index: arch/powerpc/kernel/cpu/pll_if.c
===================================================================
--- /dev/null	2004-08-10 18:55:00.000000000 -0700
+++ arch/powerpc/kernel/cpu/pll_if.c	2008-08-29 13:42:35.000000000 -0700
@@ -0,0 +1,807 @@
+/*
+ * pll_if.c - low level interface to HID1 (PLL config) in the PowerPC 750GX
+ *
+ *  Copyright (C) 2008       kevin Diggs
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+#include "linux/init.h"
+#include "linux/module.h"
+#include <linux/autoconf.h>
+#include "linux/kernel.h"
+#include <linux/errno.h>
+#include <linux/cpu.h>
+#include "linux/of.h"
+#include "linux/notifier.h"
+#include "linux/delay.h"
+#include "linux/completion.h"
+
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_SYSFS
+#include "linux/sysdev.h"
+#endif
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_HRTIMER
+#include "linux/hrtimer.h"
+#endif
+
+#include "asm/time.h"
+#include <asm/mmu.h>
+#include <asm/processor.h>
+#include <asm/pgtable.h>
+#include <asm/cputable.h>
+#include <asm/system.h>
+#include <asm/pll_if.h>
+#include <asm/pll.h>
+#include <asm/smp.h>
+
+MODULE_LICENSE("GPL");
+
+static DECLARE_COMPLETION(pllif_exit_completion);
+
+static unsigned int boot_ratio;
+
+static unsigned int busclock = 0;
+module_param(busclock, uint, 0);
+MODULE_PARM_DESC(busclock,
+	"Bus clock frequency in KHz used to compute core clock frequency from"
+	" bus ratios.");
+
+static unsigned int pllif_bus_clock;
+
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_HRTIMER
+static enum hrtimer_restart pllif_i_timer_f(struct hrtimer *hrt);
+static struct hrtimer pll_timer;
+static unsigned long hrtimers_got_no_freakin_callback_data;
+#ifdef DEBUG
+cycles_t pll_time_stamp;
+#endif
+#else
+static void pllif_i_timer_f(unsigned long newPLL);
+static struct timer_list pll_timer;
+cycles_t pll_time_stamp;
+#endif
+
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_SYSFS
+
+unsigned long boot_loops;
+static struct sys_device *sysdev_cpu;
+
+static ssize_t show_ppc750gxpll(struct sys_device *dev, char *buf)
+{
+	return sprintf(buf, "%x\n", get_PLL());
+}
+
+static ssize_t __used store_ppc750gxpll(struct sys_device *dev,
+	const char *buf, size_t count)
+{
+	unsigned long pll_ul;
+	int ret;
+
+	pr_debug(__FILE__">%s()-%d:  buf=%s, count=%d\n", __func__, __LINE__,
+		buf, count);
+
+	ret = strict_strtoul(buf, 16, &pll_ul);
+
+	pr_debug(__FILE__">%s()-%d:  strict_strtoul() returns %d\n", __func__,
+		__LINE__, ret);
+	pr_debug(__FILE__">%s()-%d:  %lx (%lu)\n", __func__, __LINE__, pll_ul,
+		pll_ul);
+
+	if (!ret) {
+		ret = count;
+
+	/*	pllif_modify_PLL((unsigned int)pll_ul,!0); */
+		pllif_modify_PLL((unsigned int)pll_ul, 0);
+	}
+
+	return ret;
+}
+
+static SYSDEV_ATTR(ppc750gxpll, 0600, show_ppc750gxpll, store_ppc750gxpll);
+#endif
+
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_CPU_FREQ
+struct pllif_call_data_t {
+	void *data;
+	int scalar;
+};
+
+static struct pllif_call_data_t pllif_switch_call_data;
+static struct pllif_call_data_t pllif_lock_call_data;
+static RAW_NOTIFIER_HEAD(pllif_pll_switch_chain);
+static RAW_NOTIFIER_HEAD(pllif_pll_lock_chain);
+#endif
+
+/*
+ * This initializes the code for the PLL control:
+ * boot_ratio is used to scale the loops_per_jiffy value from its boot value
+ * boot_loops is the boot value of loops_per_jiffy and is used to compute new
+ * values
+ */
+static int __init init_PLL(void)
+{
+	unsigned int temp;
+#ifdef CONFIG_PPC_OF
+	const u32 *clk;
+	struct device_node *tree_root;
+#endif
+
+	if (!cpu_has_feature(CPU_FTR_DUAL_PLL_750FX))
+		return -ENODEV;
+
+	boot_ratio = 0;
+
+	/*
+	 * See if bus clock override was specified
+	 */
+	if (busclock)
+		pllif_bus_clock = busclock*1000;
+
+#ifdef CONFIG_PPC_OF
+	/*
+	 * If bus clock is not specified, try to get it via OF
+	 */
+	if (!pllif_bus_clock) {
+		/*
+		 * Get root node (aka MacRISC bus)
+		 */
+		tree_root = of_find_node_by_name(NULL, "");
+
+
+		if (tree_root) {
+			clk = of_get_property(tree_root, "clock-frequency",
+				NULL);
+
+			if (clk && *clk)
+				pllif_bus_clock = (unsigned int) *clk;
+
+			of_node_put(tree_root);
+
+			pr_debug(__FILE__">%s()-%d:  Bus clock from OF is %u\n",
+				__func__, __LINE__, pllif_bus_clock);
+		}
+	}
+#endif /* CONFIG_PPC_OF */
+
+	if (!pllif_bus_clock) {
+		pr_err(__FILE__">%s()-%d:  Can't determine bus clock.\n",
+			__func__, __LINE__);
+
+		return -EINVAL;
+	}
+
+	/*
+	 * Make sure the clock frequency is correct
+	 */
+	temp = get_PLL();
+	temp = get_PLL_ratio(get_active_PLL(temp), temp);
+
+	ppc_proc_freq = pllif_cfg_to_freq(temp);
+
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_SYSFS
+	/*
+	 * Units for boot ratio is halves, i.e. 20 is a ratio of 10.
+	 * From 21 on the returned value needs to be converted to halves.
+	 */
+	if (temp > 20)
+		temp = (temp-10)<<1;
+
+	boot_ratio = temp;
+	boot_loops = loops_per_jiffy;
+
+	/*
+	 * Try to get the cpu sysdev
+	 */
+	sysdev_cpu = get_cpu_sysdev(boot_cpuid);
+
+	if (sysdev_cpu != NULL)
+		sysdev_create_file(sysdev_cpu, &attr_ppc750gxpll);
+#endif
+
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_HRTIMER
+	hrtimer_init(&pll_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+#else
+	init_timer(&pll_timer);
+#endif
+
+	pll_timer.function = pllif_i_timer_f;
+
+	return 0;
+}
+
+/*__initcall(init_PLL); */
+
+static void exit_PLL(void)
+{
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_SYSFS
+	if (sysdev_cpu != NULL)
+		sysdev_remove_file(sysdev_cpu, &attr_ppc750gxpll);
+#endif
+
+	/*
+	 * Make sure there are no timers pending by making sure we are not
+	 * doing anything. The test_bit() condition is to catch the case where
+	 * we exit with the pllif_modify_PLL() routine never having been called.
+	 */
+	if (test_bit(PLL_LOCK_BIT, (unsigned long *)&boot_ratio))
+		wait_for_completion(&pllif_exit_completion);
+}
+
+module_init(init_PLL);
+module_exit(exit_PLL);
+
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_SYSFS
+static unsigned long pllif_i_new_LPJ(unsigned int oldRatio, unsigned int
+	newRatio, unsigned long LPJ)
+{
+	if (LPJ > 200000000)
+		return LPJ/oldRatio*newRatio;
+	else
+		return LPJ*newRatio/oldRatio;
+}
+
+static inline void pllif_i_update_LPJ(unsigned int oldRatio, unsigned int
+	newRatio, unsigned long LPJ)
+{
+	loops_per_jiffy = pllif_i_new_LPJ(oldRatio, newRatio, LPJ);
+}
+#else
+#define pllif_i_update_LPJ(a, b, c)
+#endif
+
+static void pllif_i_switch_PLLs(unsigned int newPLL)
+{
+#if 0
+	unsigned long flags;
+#endif
+	unsigned int new_ratio;
+	unsigned int new_ratio_cp;
+	unsigned int old_ratio;
+	unsigned int current_pll;
+	unsigned int masked_boot_ratio;
+
+	pr_debug(__FILE__">%s()-%d:  newPLL=0x%08x\n", __func__, __LINE__,
+		newPLL);
+
+	/*
+	 * Compute new loops_per_jiffy
+	 */
+	current_pll = get_PLL();
+	new_ratio = get_PLL_ratio(get_next_PLL(newPLL), current_pll);
+	old_ratio = get_PLL_ratio(get_active_PLL(current_pll), current_pll);
+	masked_boot_ratio = boot_ratio&0xff;
+	new_ratio_cp = new_ratio;
+
+	pr_debug(__FILE__">%s()-%d:  current_pll=0x%08x, new=%d, old=%d\n",
+		__func__, __LINE__, current_pll, new_ratio, old_ratio);
+
+	current_pll = (current_pll&~PLL_SEL_MASK)|(newPLL&PLL_SEL_MASK);
+
+	pr_debug(__FILE__">%s()-%d:  current_pll=0x%08x, new=%d, old=%d\n",
+		__func__, __LINE__, current_pll, new_ratio, old_ratio);
+
+	/*
+	 * Convert to halves
+	 */
+	if (new_ratio > 20)
+		new_ratio = (new_ratio-10)<<1;
+	if (old_ratio > 20)
+		old_ratio = (old_ratio-10)<<1;
+
+	/*
+	 * Make sure that we never shorten the sleep values
+	 */
+	if (new_ratio > old_ratio) {
+		if (newPLL&PLL_DO_LPJ)
+			pllif_i_update_LPJ(masked_boot_ratio, new_ratio,
+				boot_loops);
+
+		pr_debug(__FILE__">%s()-%d:  masked_boot_ratio=%d, new_ratio="
+		"%d, boot_loops=%ld, loops_per_jiffy=%ld\n", __func__, __LINE__,
+		masked_boot_ratio, new_ratio, boot_loops, loops_per_jiffy);
+
+		set_PLL(current_pll);
+	} else {
+		pr_debug(__FILE__">%s()-%d:  masked_boot_ratio=%d, new_"
+			"ratio=%d, boot_loops=%ld, loops_per_jiffy=%ld\n",
+			__func__, __LINE__, masked_boot_ratio, new_ratio,
+			boot_loops, loops_per_jiffy);
+
+		set_PLL(current_pll);
+
+		if (newPLL&PLL_DO_LPJ)
+			pllif_i_update_LPJ(masked_boot_ratio, new_ratio,
+				boot_loops);
+
+		pr_debug(__FILE__">%s()-%d:  masked_boot_ratio=%d, new_"
+			"ratio=%d, boot_loops=%ld, loops_per_jiffy=%ld\n",
+			__func__, __LINE__, masked_boot_ratio, new_ratio,
+			boot_loops, loops_per_jiffy);
+	}
+
+	raw_notifier_call_chain(&pllif_pll_switch_chain, pllifmPllSwitch,
+		pllif_switch_call_data.data);
+
+	/*
+	 * This is used to print the clock frequency in /proc/cpuinfo
+	 */
+	ppc_proc_freq = pllif_cfg_to_freq(new_ratio_cp);
+	pr_debug(__FILE__">%s()-%d:  pllif_cfg_to_freq(%u)=%lu\n", __func__,
+		__LINE__, new_ratio_cp, ppc_proc_freq);
+
+#if 0
+	save_flags(flags);
+	cli();
+
+	loops_per_jiffy = pllif_i_new_LPJ(masked_boot_ratio, new_ratio,
+		boot_loops);
+
+	set_PLL(current_pll);
+
+	restore_flags(flags);
+#endif
+}
+
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_HRTIMER
+static enum hrtimer_restart pllif_i_timer_f(struct hrtimer *hrt)
+{
+#ifdef DEBUG
+	cycles_t now;
+	cycles_t usec, tmp, cntlz, cnttz;
+
+	now = get_cycles();
+
+	now = now-pll_time_stamp;
+
+	/*
+	 * Aw cmon, I'm just havin' a little fun with PPC assembly.
+	 * Just wish I could find a way to use an rlwinm ... (or the equally
+	 * fun rlwnm). This gets the leading zeros (for the dividend) and the
+	 * trailing zeros (for the divisor) to try to preserve some precision
+	 * after the big divide.
+	 */
+	cnttz = tb_ticks_per_sec; /* needed to get the assembly to ...
+				 * look right ... ??? */
+	tmp = now*15625;
+
+	asm (
+		"addi %0,%3,-1\n\t"
+		"andc %1,%3,%0\n\t"
+		"cntlzw %1,%1\n\t"
+		"subfic %1,%1,31\n\t"
+		"cntlzw %0,%2\n\t":
+		"=r"(cntlz), "=r"(cnttz):
+		"r"(tmp), "b"(cnttz)
+	);
+
+	/*
+	 * 1,000,000 usec per sec and 1,000,000 is 15625<<6
+	 */
+	usec = ((tmp<<cntlz)/(tb_ticks_per_sec>>cnttz))<<6;
+	usec = (usec+(1UL<<(cntlz+cnttz-1)))>>(cntlz+cnttz);
+
+	pr_debug(__FILE__">%s()-%d:  Time delta is %lu cycles, "
+		"%lu uS (cntlz=%lu, cnttz=%lu)\n", __func__, __LINE__, now,
+		usec, cntlz, cnttz);
+#endif
+	raw_notifier_call_chain(&pllif_pll_lock_chain, pllifmPllLock,
+		pllif_lock_call_data.data);
+
+	/*
+	 * Clear all lock bits
+	 */
+	boot_ratio &= ~(PLL_TIMER|PLL0_LOCK|PLL1_LOCK);
+
+	if ((unsigned int) hrtimers_got_no_freakin_callback_data)
+		pllif_i_switch_PLLs((unsigned int)
+			hrtimers_got_no_freakin_callback_data);
+
+	complete(&pllif_exit_completion);
+
+	return HRTIMER_NORESTART;
+}
+#else
+static void pllif_i_timer_f(unsigned long newPLL)
+{
+	cycles_t now;
+
+	now = get_cycles();
+	now = now-pll_time_stamp;
+
+#ifdef DEBUG
+	{
+		cycles_t usec, tmp, cntlz, cnttz;
+
+		/*
+		 * Aw cmon, I'm just havin' a little fun with PPC assembly.
+		 * Just wish I could find a way to use an rlwinm ... (or the
+		 * equally fun rlwnm). This gets the leading zeros (for the
+		 * dividend) and the trailing zeros (for the divisor) to try to
+		 * preserve some precision after the big divide.
+		 */
+		cnttz = tb_ticks_per_sec; /* needed to get the assembly to ...
+					 * look right ... ??? */
+#define MULFIRST
+#ifdef MULFIRST
+		tmp = now*15625;
+#else
+		tmp = now;
+#endif
+
+		asm (
+			"addi %0,%3,-1\n\t"
+			"andc %1,%3,%0\n\t"
+			"cntlzw %1,%1\n\t"
+			"subfic %1,%1,31\n\t"
+			"cntlzw %0,%2\n\t":
+			"=r"(cntlz), "=r"(cnttz):
+			"r"(tmp), "b"(cnttz)
+		);
+
+		/*
+		 * 1,000,000 usec per sec and 1,000,000 is 15625<<6
+		 */
+/*		usec = (((now<<cntlz)/(tb_ticks_per_sec>>cnttz)*15625)+(1UL<<
+			(cntlz+cnttz-1-6)))>>(cntlz+cnttz-6); */
+#ifdef MULFIRST
+		usec = ((tmp<<cntlz)/(tb_ticks_per_sec>>cnttz))<<6;
+		usec = (usec+(1UL<<(cntlz+cnttz-1)))>>(cntlz+cnttz);
+#else
+		usec = ((tmp<<cntlz)/(tb_ticks_per_sec>>cnttz)*15625)<<6;
+		usec = (usec+(1UL<<(cntlz+cnttz-1)))>>(cntlz+cnttz);
+#endif
+
+		pr_debug(__FILE__">%s()-%d:  Time delta is %lu cycles, "
+			"%lu uS (cntlz=%lu, cnttz=%lu)\n", __func__, __LINE__,
+			now, usec, cntlz, cnttz);
+	}
+#endif
+	/*
+	 * Make sure it has been at least 100 usec. 100 usec is 100 *
+	 * tb_ticks_per_sec / 1,000,000 cycles, so:
+	 *	if(now<100*tb_ticks_per_sec/1000000
+	 * 1,000,000 is 15625<<6, so:
+	 *	if((now<<6)<100*tb_ticks_per_sec/15625)
+	 * 100 is 25<<2, so:
+	 *	if((now<<4)<25*tb_ticks_per_sec/15625)
+	 * 15625 is 3125*5, so:
+	 *	if((now<<4)*5<25*tb_ticks_per_sec/3125)
+	 * obviously 25/3125 -> 1/125:
+	 *	if((now<<4)*5<tb_ticks_per_sec/125)
+	 */
+	if ((now<<4)*5 < tb_ticks_per_sec/125)
+		udelay(100-now*1000000/tb_ticks_per_sec);
+
+	raw_notifier_call_chain(&pllif_pll_lock_chain, pllifmPllLock,
+		pllif_lock_call_data.data);
+
+	/*
+	 * Clear all lock bits
+	 */
+	boot_ratio &= ~(PLL_TIMER|PLL0_LOCK|PLL1_LOCK);
+
+	if ((unsigned int)newPLL)
+		pllif_i_switch_PLLs((unsigned int)newPLL);
+
+	complete(&pllif_exit_completion);
+}
+#endif
+
+/*
+ * Handle accesses to the pll register. Examples for write:
+ *	  value		CFGx/RNGx/res	   effect
+ *	0x08010000			switch to PLL1
+ *	0x08000000			switch to PLL0
+ *	0xc000fa00	1111 1/01/0	PLL0 off (CFG/RNG 31/1)
+ *	0xc000f200	1111 0/01/0	PLL0 to 20x (CFG/RNG 30/1)
+ *	0x30000004	0000 0/10/0	PLL1 off (CFG/RNG 0/2)
+ *	0x30000054	0101 0/10/0	PLL1 to 5x (CFG/RNG a/2)
+ */
+/**
+ * modifyPLL: - Takes steps to modify PLL as requested
+ * @pll: Specifies the new value and desired operation to be performed
+ * @scaleLPJ: flag to indicate whether to scale the loops_per_jiffy value
+ *
+ * Based on the value passed in the pll argument, this takes the steps necessary
+ * to change the PLL as requested. The upper 7 or 8 bits of the PLL are read
+ * only. These bit positions in the pll argument are used to specify flags that
+ * indicate the validity of the other fields in the pll argument. See the
+ * pll_if.h header for detail and actual values.
+ */
+int pllif_modify_PLL(unsigned int pll, int scaleLPJ)
+{
+	unsigned int current_pll, work_mask, pll_x;
+	int rval = 0;
+
+	pr_debug(__FILE__">%s()-%d:\n", __func__, __LINE__);
+	pr_debug(__FILE__">%s()-%d:  pll=0x%08x\n", __func__, __LINE__, pll);
+
+	/*
+	 * This is not reentrant
+	 */
+	if (test_and_set_bit(PLL_LOCK_BIT, (unsigned long *)&boot_ratio)) {
+		pr_debug(__FILE__">%s()-%d:  Busy!\n", __func__, __LINE__);
+		return -EAGAIN;
+	}
+
+	/*
+	 * Don't allow any changes if a timer is pending
+	 */
+	if (test_bit(PLL_TIMER_BIT, (unsigned long *)&boot_ratio))
+		goto checkPLLBusy;
+
+	INIT_COMPLETION(pllif_exit_completion);
+
+	current_pll = get_PLL();
+	work_mask = pll>>24;
+
+	/*
+	 * Check to see if the currently selected PLL is being modified
+	 */
+	pll_x = get_active_PLL(current_pll);
+
+	if ((pll_x == 0 && work_mask&(PLL0_DO_CFG|PLL0_DO_RNG|PLL0_DO_CONTROL))
+		|| (pll_x == 1 && work_mask&(PLL1_DO_CFG|PLL1_DO_RNG)))
+		goto checkPLLInVal;
+
+	/*
+	 * Can't change to a PLL that is off. Also can't immediately change to
+	 * one that is not locked. Catch that supposedly impossible condition.
+	 */
+	if (work_mask&PLL_DO_SEL) {
+		int next_ratio;
+		unsigned int which_config;
+
+		pll_x = get_next_PLL(pll);
+
+		/*
+		 * Figure out where the next ratio comes from. It will be from
+		 * pll if we are changing the next pll and current_pll if not.
+		 */
+		which_config = pll_x?((work_mask&PLL1_DO_CFG)?pll:current_pll):
+			((work_mask&PLL0_DO_CFG)?pll:current_pll);
+		next_ratio = get_PLL_ratio(pll_x, which_config);
+		if (next_ratio < 4 || next_ratio > 30)
+			goto checkPLLInVal;
+
+		pll_x = ((pll_x == 0 && boot_ratio&PLL0_LOCK) || (pll_x == 1 &&
+			boot_ratio&PLL1_LOCK))?1:0;
+
+	}
+	/*
+	 * To avoid complications, don't allow both plls to be half ratios
+	 */
+	if (work_mask&PLL0_DO_CFG) {
+		int old_ratio1, new_ratio0;
+
+		old_ratio1 = get_PLL_ratio(1, current_pll);
+		new_ratio0 = get_PLL_ratio(0, pll);
+
+		if (old_ratio1 > 4 && old_ratio1 < 20 && new_ratio0 > 4 &&
+			new_ratio0 < 20 && (old_ratio1&0x1) & (new_ratio0&0x1))
+			goto checkPLLInVal;
+	} else if (work_mask&PLL1_DO_CFG) {
+		int old_ratio0, new_ratio1;
+
+		old_ratio0 = get_PLL_ratio(0, current_pll);
+		new_ratio1 = get_PLL_ratio(1, pll);
+
+		if (old_ratio0 > 4 && old_ratio0 < 20 && new_ratio1 > 4 &&
+			new_ratio1 < 20 && (old_ratio0&0x1) & (new_ratio1&0x1))
+			goto checkPLLInVal;
+	}
+
+	/*
+	 * Determine if we will need to schedule a timer for a PLL relock. If
+	 * any PLL config is being changed then a timer will be needed. Also
+	 * need one if changing to a PLL that is not locked, though that should
+	 * not happen.
+	 */
+	if ((work_mask&(PLL0_DO_CFG|PLL0_DO_RNG|PLL1_DO_CFG|PLL1_DO_RNG|
+		PLL0_DO_CONTROL)) || (work_mask&PLL_DO_SEL && pll_x)) {
+		unsigned int pll_mask, temp;
+
+		pll_mask = 0;
+
+		if (work_mask&PLL0_DO_CFG) {
+			pll_mask |= PLL0_CFG_MASK;
+
+			/*
+			 * Flag that PLL0 needs to relock
+			 */
+			boot_ratio |= PLL0_LOCK;
+		}
+
+		if (work_mask&PLL0_DO_RNG)
+			pll_mask |= PLL0_RNG_MASK;
+
+		if (work_mask&PLL1_DO_CFG) {
+			pll_mask |= PLL1_CFG_MASK;
+
+			/*
+			 * Flag that PLL1 needs to relock
+			 */
+			boot_ratio |= PLL1_LOCK;
+		}
+
+		if (work_mask&PLL1_DO_RNG)
+			pll_mask |= PLL1_RNG_MASK;
+
+		temp = (current_pll&~pll_mask)|(pll&pll_mask);
+
+		if (pll_mask)
+			set_PLL(temp);
+
+		/*
+		 * Flag that a timer is pending
+		 */
+		boot_ratio |= PLL_TIMER;
+
+		/*
+		 * Schedule a timer to clear the PLL lock bits (and signal that
+		 * it is ok to select the PLL)
+		 */
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_HRTIMER
+		/*
+		 * Oh please, someone tell me I'm just to stupid to know how
+		 * to pass this to the timer function!
+		 */
+		hrtimers_got_no_freakin_callback_data = (work_mask&PLL_DO_SEL)?
+			(PLL_DO_SEL<<24)|(scaleLPJ?PLL_DO_LPJ:0)|(pll&
+			PLL_SEL_MASK):0;
+
+		pll_timer.expires = ktime_set(0, 100000);
+
+		hrtimer_start(&pll_timer, pll_timer.expires, HRTIMER_MODE_REL);
+#ifdef DEBUG
+		pll_time_stamp = get_cycles();
+#endif
+#else
+		/*
+		 * We might want to pass three pieces of data to the timer
+		 *   i)	that we want to switch PLLs (PLL_DO_SEL)
+		 *  ii)	which PLL to switch to (PLL_SEL_MASK)
+		 * iii) flag to control whether loops_per_jiffy is updated
+		 *      (PLL_DO_LPJ)
+		 */
+		pll_timer.data = (work_mask&PLL_DO_SEL)?(PLL_DO_SEL<<24)|(
+			scaleLPJ?PLL_DO_LPJ:0)|(pll&PLL_SEL_MASK):0;
+
+		/*
+		 * Relock takes 100 us. See how many jiffies will take care of
+		 * it.
+		 */
+		pll_timer.expires = (100*HZ/1000000);
+		if (pll_timer.expires == 0)
+			pll_timer.expires = 1;
+
+		pll_timer.expires = jiffies+pll_timer.expires;
+		add_timer(&pll_timer);
+
+		pll_time_stamp = get_cycles();
+#endif
+	} else if (work_mask&PLL_DO_SEL) {
+		pllif_i_switch_PLLs(pll|(scaleLPJ?PLL_DO_LPJ:0));
+		complete(&pllif_exit_completion);
+	}
+
+checkPLLOut:
+	clear_bit(PLL_LOCK_BIT, (unsigned long *)&boot_ratio);
+
+	return rval;
+checkPLLBusy:
+	rval = -EBUSY;
+	goto checkPLLOut;
+checkPLLInVal:
+	rval = -EINVAL;
+	complete(&pllif_exit_completion);
+	goto checkPLLOut;
+}
+EXPORT_SYMBOL(pllif_modify_PLL);
+
+/**
+ * pllif_cFg_to_freq: - Takes a ratio and returns the frequency
+ * @cfg: The PLL ratio field value
+ *
+ * This takes a PLL ratio field value and uses it along with the bus frequency
+ * to compute the processor frequency.
+ */
+unsigned int pllif_cfg_to_freq(unsigned int cfg)
+{
+	return (cfg < 21?cfg>>1:cfg-10)*pllif_bus_clock;
+}
+EXPORT_SYMBOL(pllif_cfg_to_freq);
+
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_CPU_FREQ
+/**
+ * pllif_get_bus_clock: - Returns the bus frequency
+ *
+ * This returns the determined bus frequency in Hz.
+ */
+unsigned int pllif_get_bus_clock()
+{
+	return pllif_bus_clock;
+}
+EXPORT_SYMBOL(pllif_get_bus_clock);
+
+/**
+ * pllif_register_pll_switch_cb: - Registers a pll switch call back
+ * @nb: structure describing the call back to register
+ * @data: data to be passed to the callback function
+ *
+ * This registers a call back function that will be called when the clock is
+ * switched from one PLL to the other. The call back routine should be set in
+ * the notifier_call member of @nb.
+ */
+int pllif_register_pll_switch_cb(struct notifier_block *nb, void *data)
+{
+	int ret;
+
+	pllif_switch_call_data.data = data;
+
+	ret = raw_notifier_chain_register(&pllif_pll_switch_chain, nb);
+
+	return ret;
+}
+EXPORT_SYMBOL(pllif_register_pll_switch_cb);
+
+/**
+ * pllif_unregister_pll_switch_cb: - Cancels a previously registered call back
+ * @nb: structure describing the call back to cancel
+ *
+ * This cancels a previously registered switch call back
+ */
+void pllif_unregister_pll_switch_cb(struct notifier_block *nb)
+{
+	raw_notifier_chain_unregister(&pllif_pll_switch_chain, nb);
+}
+EXPORT_SYMBOL(pllif_unregister_pll_switch_cb);
+
+/**
+ * pllif_register_pll_lock_cb: - Registers a pll lock call back
+ * @nb: structure describing the call back to register
+ * @data: data to be passed to the callback function
+ *
+ * This registers a call back function that will be called when a PLL has
+ * locked to a new frequency. The call back routine should be set in the
+ * notifier_call member of @nb.
+ */
+int pllif_register_pll_lock_cb(struct notifier_block *nb, void *data)
+{
+	int ret;
+
+	pllif_lock_call_data.data = data;
+
+	ret = raw_notifier_chain_register(&pllif_pll_lock_chain, nb);
+
+	return ret;
+}
+EXPORT_SYMBOL(pllif_register_pll_lock_cb);
+
+/**
+ * pllif_unregister_pll_lock_cb: - Cancels a previously registered call back
+ * @nb: structure describing the call back to cancel
+ *
+ * This cancels a previously registered PLL lock call back
+ */
+void pllif_unregister_pll_lock_cb(struct notifier_block *nb)
+{
+	raw_notifier_chain_unregister(&pllif_pll_lock_chain, nb);
+}
+EXPORT_SYMBOL(pllif_unregister_pll_lock_cb);
+#endif
Index: include/asm-powerpc/pll.h
===================================================================
--- /dev/null	2004-08-10 18:55:00.000000000 -0700
+++ include/asm-powerpc/pll.h	2008-08-23 02:05:14.000000000 -0700
@@ -0,0 +1,209 @@
+#ifndef __PLL_H
+#define __PLL_H
+/*
+	Dual PLL functions, for 750FX & 750GX
+	Copyright (C) 2005 by Kevin Diggs
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+/*
+	Tue, June 14, 2005.
+	- First public release, contributed by Kevin Diggs.
+	***********
+	***********
+
+	Author:	Kevin Diggs ()
+*/
+
+#include <asm/processor.h>
+
+/*
+	The layout of the PLL register (HID1) is:
+
+	0  4|5 6|7|8| 9 11|12 13|14| 15 |16 20|21 22|23|24 28|29 30| 31
+	PCE |PRE|v|v| Res | Res |v | PS | PC0 | PR0 |v | PC1 | PR1 |Res
+	         | |             |                   |
+	 PSTAT1 -| |             |                   |
+	 ECLK -----|             |                   |
+	 PI0 --------------------|                   |
+	 Res ----------------------------------------|
+
+	PCE	PLL0 read-only external config
+	PRE	PLL0 read-only external range
+	PSTAT1	PLL status (0 -> PLL0, 1 -> PLL1)
+	ECLK	1 -> enable clkout pin
+	PI0	PLL0 control:  0 -> external
+	PS	PLL select:  0 -> PLL0, 1 -> PLL1
+	PC0	PLL0 configuration
+	PR0	PLL0 range
+	PC1	PLL1 configuration
+	PR1	PLL1 range
+
+	PLL_CFG		bus ratio	PLL_CFG		bus ratio
+	 00000		   off		 10000		    8
+	 00001		   off		 10001		   8.5
+	 00010		 bypass		 10010		    9
+	 00011		 bypass		 10011		   9.5
+	 00100		    2		 10100		   10
+	 00101		   2.5		 10101		   11
+	 00110		    3		 10110		   12
+	 00111		   3.5		 10111		   13
+	 01000		    4		 11000		   14
+	 01001		   4.5		 11001		   15
+	 01010		    5		 11010		   16
+	 01011		   5.5		 11011		   17
+	 01100		    6		 11100		   18
+	 01101		   6.5		 11101		   19
+	 01110		    7		 11110		   20
+	 01111		   7.5		 11111		   off
+
+	PLL_RNG		  range
+	  00		600 -  900
+	  01		900 - 1000
+	  10		500 -  600
+ */
+
+/**
+ * get_PLL: - return current value of PLL register (HID1)
+ *
+ * This returns the current value of the PLL configuration register (HID1).
+ */
+static inline volatile unsigned int get_PLL(void)
+{
+unsigned int ret;
+
+	__asm__ __volatile__ ("mfspr %0,%1":
+		"=r"(ret):
+		"i"(SPRN_HID1)
+	);
+
+	return ret;
+}
+
+/**
+ * get_active_PLL: - Returns the active PLL (0 or 1)
+ * @config: The PLL register value to return the active PLL from
+ *
+ * This returns the value of the PSTAT1 bit (bit 7, IBM numbering) , right
+ * justified, which indicates which of the PLLs is currently clocking the CPU.
+ */
+static inline unsigned int get_active_PLL(unsigned int config)
+{
+unsigned int ret;
+
+	/*
+	 * PSTAT1 to LSBit and mask
+	 */
+	__asm__ __volatile__ ("rlwinm %0,%0,8,31,31":
+		"=r"(ret):
+		"0"(config)
+	);
+
+	return ret;
+}
+
+/**
+ * get_next_PLL: - Returns the PLL that is to become active
+ * @config: The PLL register value to return the next PLL from
+ *
+ * This returns the value of the PS bit (bit 15, IBM numbering), right
+ * justified, which indicates which of the PLLs is going to be clocking the CPU.
+ */
+static inline unsigned int get_next_PLL(unsigned int config)
+{
+unsigned int ret;
+
+	/*
+	 * PS to LSBit and mask
+	 */
+	__asm__ __volatile__ ("rlwinm %0,%0,16,31,31":
+		"=r"(ret):
+		"0"(config)
+	);
+
+	return ret;
+}
+
+/**
+ * get_PLL_ratio: - Returns the selected PLL ratio
+ * @ratio: The ratio that is to be returned (0 or 1)
+ * @config: The PLL register value to return the next PLL from
+ *
+ * This returns the value of the selected PLL ratio field (PC0 for 0, PC1 for
+ * 1), right justified. It indicates the frequency of the selected PLL.
+ */
+static inline unsigned int get_PLL_ratio(unsigned int ratio, unsigned int
+	config)
+{
+unsigned int ret;
+
+	/*
+	 * Turn r3 (ratio) into a rotate count for the selected ratio.
+	 * 0 -> 21, 1 -> 29
+	 */
+	__asm__ __volatile__ (
+		"slwi %0,%0,3\n"
+		"addi %0,%0,21\n"
+		"rlwnm %0,%1,%0,27,31\n":
+		"=b"(ret):
+		"r"(config), "0"(ratio)
+	);
+
+	return ret;
+}
+
+/**
+ * get_PLL_range: - Returns the selected PLL range
+ * @range: The range that is to be returned (0 or 1)
+ * @config: The PLL register value to return the next PLL from
+ *
+ * This returns the value of the selected PLL range field (PR0 for 0, PR1 for
+ * 1), right justified.
+ */
+static inline unsigned int get_PLL_range(unsigned int range, unsigned int
+	config)
+{
+unsigned int ret;
+
+	/*
+	 * Turn r3 (range) into a rotate count for the selected range.
+	 * 0 -> 23, 1 -> 31
+	 */
+	__asm__ __volatile__ (
+		"slwi %0,%0,3\n"
+		"addi %0,%0,23\n"
+		"rlwnm %0,%1,%0,30,31\n":
+		"=b"(ret):
+		"r"(config), "0"(range)
+	);
+
+	return ret;
+}
+
+/**
+ * get_PLL: - sets a new value in the PLL register
+ * @config: The new value for the PLL register (HID1)
+ *
+ * This stores a new value in the PLL configuration register. It is possible to
+ * freeze the system by storing certain illegal values.
+ */
+static inline volatile void set_PLL(unsigned int config)
+{
+	__asm__ __volatile__ ("mtspr %1,%0":
+		:
+		"r"(config), "i"(SPRN_HID1)
+	);
+}
+#endif
Index: include/asm-powerpc/pll_if.h
===================================================================
--- /dev/null	2004-08-10 18:55:00.000000000 -0700
+++ include/asm-powerpc/pll_if.h	2008-08-27 02:24:49.000000000 -0700
@@ -0,0 +1,117 @@
+#ifndef __PLL_IF_H
+#define __PLL_IF_H
+/*
+	High Level wrapper functions for Dual PLL in 750FX & 750GX
+	Copyright (C) 2008 by Kevin Diggs
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+/*
+	Fri, April 18, 2008.
+	- First public release, contributed by Kevin Diggs.
+	***********
+	***********
+
+	Author:	Kevin Diggs ()
+*/
+
+/*
+ * Update the value of the PLL configuration register based on the crap passed
+ * in. The upper 8 bits (0 - 7) are read only and will be used as flags to con-
+ * trol what we are doing:
+ *	0x80	PLL0 configuration is valid
+ *	0x40	PLL0 range is valid
+ *	0x20	PLL1 configuration is valid
+ *	0x10	PLL1 range is valid
+ *	0x08	PLL select is valid
+ *	0x04	PLL0 control is valid
+ *	0x02	Update loops_per_jiffy value
+ *
+ * Make sure that sufficient time (100 us) is given for a PLL that is changed
+ * to relock before selecting it.
+ */
+#define PLL0_DO_CFG	(0x80)
+#define PLL0_DO_RNG	(0x40)
+#define PLL1_DO_CFG	(0x20)
+#define PLL1_DO_RNG	(0x10)
+#define PLL_DO_SEL	(0x08)
+#define PLL0_DO_CONTROL	(0x04)
+#define PLL_DO_LPJ	(0x02)
+
+#define PLL0_CONTROL_MASK	(0x20000)
+#define PLL_SEL_MASK		(0x10000)
+#define PLL0_CFG_MASK		(0x0f800)
+#define PLL0_CFG_SHIFT		(11)
+#define PLL0_RNG_MASK		(0x00600)
+#define PLL0_RNG_SHIFT		(9)
+#define PLL1_CFG_MASK		(0x000f8)
+#define PLL1_CFG_SHIFT		(3)
+#define PLL1_RNG_MASK		(0x00006)
+#define PLL1_RNG_SHIFT		(1)
+
+#define PLL_LOCK	(0x80000000)		/* Code lock bit */
+#define PLL_LOCK_BIT (31)
+#define PLL_TIMER	(0x40000000)		/* Timer is scheduled */
+#define PLL_TIMER_BIT (30)
+#define PLL0_LOCK	(0x20000000)		/* PLL 0 locking */
+#define PLL0_LOCK_BIT (29)
+#define PLL1_LOCK	(0x10000000)		/* PLL 1 locking */
+#define PLL1_LOCK_BIT (28)
+
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_CPU_FREQ
+#define pllifmPllSwitch		(0x80000000)
+#define pllifmPllLock		(0x40000000)
+
+extern int pllif_modify_PLL(unsigned int newPLL, int scaleLPJ);
+extern unsigned int pllif_get_bus_clock(void);
+extern unsigned int pllif_cfg_to_freq(unsigned int ratio);
+extern int pllif_register_pll_switch_cb(struct notifier_block *nb, void *data);
+extern void pllif_unregister_pll_switch_cb(struct notifier_block *nb);
+extern int pllif_register_pll_lock_cb(struct notifier_block *nb, void *data);
+extern void pllif_unregister_pll_lock_cb(struct notifier_block *nb);
+
+/**
+ * pllif_get_latency: - Return processor frequency switch latency
+ *
+ * This returns the latency that a processor frequency switch takes. It is in
+ * nano seconds. The value will depend on whether HRTIMERS are being used.
+ */
+static inline int pllif_get_latency(void)
+{
+#ifdef CONFIG_PPC_750GX_DUAL_PLL_IF_HRTIMER
+	return 100000;
+#else
+	return 1000000000/HZ;
+#endif
+}
+
+/**
+ * pllif_pack_state: - Returns the arguments packed together
+ * @cfg: The ratio that is to be used
+ * @rng: The range that is to be used
+ *
+ * This takes a ratio and range and packs them together in the right positions
+ * relative to each other for creating a new PLL value. The value is positioned
+ * correctly for PLL 1. To reposition for PLL 0 do a left shift of
+ * (PLL0_CFG_SHIFT - PLL1_CFG_SHIFT).
+ */
+static inline unsigned int pllif_pack_state(unsigned int cfg, unsigned int
+	rng)
+{
+	return (cfg<<PLL1_CFG_SHIFT)|(rng<<PLL1_RNG_SHIFT);
+}
+#endif
+
+#endif
