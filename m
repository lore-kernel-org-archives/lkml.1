Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYH3JmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYH3JmQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 05:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYH3Jl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 05:41:59 -0400
Received: from smtpauth.hypersurf.com ([209.237.0.8]:50059 "EHLO
	smtpauth.hypersurf.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYH3Jl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 05:41:57 -0400
Message-ID: <48B91582.5060008@hypersurf.com>
Date: Sat, 30 Aug 2008 02:40:18 -0700
From: Kevin Diggs <kevdig@hypersurf.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i486; en-US; rv:1.8b2) Gecko/20050724
MIME-Version: 1.0
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] Add cpufreq driver for the IBM PowerPC 750GX
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the actual cpufreq driver for the 750GX. It supports all integer
ratios that are valid for the processor model and bus frequency. It is called
cf750gx.

It has two modes of operation. Normal mode uses all valid frequencies. In
minmaxmode, only the minimum and maximum are used. This provides the ability
for very low latency frequency switches.

There is also a sysfs attribute to have it switch off the unused PLL for
additional power savings.

This does NOT support SMP.

I fixed a deadlock if the module is unloaded before _target() is ever
called.

My name is Kevin Diggs and I approve this patch.

Signed-off-by: Kevin Diggs <kevdig@hypersurf.com>


Index: Documentation/DocBook/cf750gx.tmpl
===================================================================
--- /dev/null	2004-08-10 18:55:00.000000000 -0700
+++ Documentation/DocBook/cf750gx.tmpl	2008-08-27 13:59:45.000000000 -0700
@@ -0,0 +1,441 @@
+<?xml version="1.0" encoding="UTF-8"?>
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.1.2//EN"
+	"http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd" []>
+
+<book id="ppc750gx-cpufreq-guide">
+ <bookinfo>
+  <title>PowerPC 750GX (and FX?) cpufreq driver guide</title>
+
+  <authorgroup>
+   <author>
+    <firstname>Kevin</firstname>
+    <surname>Diggs</surname>
+   </author>
+  </authorgroup>
+
+    <revhistory>
+      <revision>
+	<revnumber>1.0&nbsp;</revnumber>
+	<date>August 12, 2008</date>
+	<revremark>Initial revision posted to linuxppc-dev</revremark>
+      </revision>
+    </revhistory>
+
+  <copyright>
+   <year>2008</year>
+   <holder>Kevin Diggs</holder>
+  </copyright>
+
+  <legalnotice>
+   <para>
+    This documentation is free software; you can redistribute
+    it and/or modify it under the terms of the GNU General Public
+    License as published by the Free Software Foundation; either
+    version 2 of the License, or (at your option) any later
+    version.
+   </para>
+
+   <para>
+    This program is distributed in the hope that it will be
+    useful, but WITHOUT ANY WARRANTY; without even the implied
+    warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+    See the GNU General Public License for more details.
+   </para>
+
+   <para>
+    You should have received a copy of the GNU General Public
+    License along with this program; if not, write to the Free
+    Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+    MA 02111-1307 USA
+   </para>
+
+   <para>
+    For more details see the file COPYING in the source
+    distribution of Linux.
+   </para>
+  </legalnotice>
+
+  <releaseinfo>
+   This is the first release of this document coincident with submission of the
+   driver for inclusion in the kernel.
+  </releaseinfo>
+
+ </bookinfo>
+
+ <toc></toc>
+
+ <chapter id="introduction">
+  <title>Introduction</title>
+  <para>
+   This guide documents the cpufreq driver for the IBM PowerPC 750GX processor.
+   It "should" also work with the 750FX but has not been tested.
+  </para>
+  <para>
+   The driver is split into two main parts. The first provides the low level
+   interface to the PLL configuration register (HID1 - SPR 1009). It is called
+   pll_if. The second is the actual cpufreq driver, called cf750gx. The pll_if
+   component handles the details of dealing with the PLL like PLL lock delay
+   requirements and preventing illegal operations. The cf750gx driver provides
+   the interface to the cpufreq subsystem. Under control of the specified
+   governor it will generate the required commands to switch the processor
+   frequency as requested and send them to pll_if to carry them out.
+  </para>
+ </chapter>
+
+ <chapter id="MajorComponents">
+  <title>Major Components</title>
+
+  <para>
+   The IBM 750GX (and FX) processor has a pair of PLLs that can be programmed to
+   operate at a number of different frequencies. The frequencies are specified
+   as ratios to the system bus and range from 2 to 20. From 2 to 10 it also
+   supports half ratios (i.e. 2.5, 3.5) though they are not supported in the
+   cpufreq driver due to a limitation of not being able to switch from one half
+   ratio directly to another. It takes 100 usec for a PLL to relock to a
+   new frequency before it can be used [750GX_ds2-17-05.pdf, Table 3-7,
+   page 18]. It takes 3 bus clocks for the cpu to switch from one PLL to
+   another [750GX_ds2-17-05.pdf, paragraph 3, page 44].
+  </para>
+
+  <para>
+   The cpufreq driver consists of two main parts:
+  </para>
+
+  <itemizedlist>
+   <listitem>
+    <para>
+     cf750gx - the cpufreq driver module
+    </para>
+   </listitem>
+
+   <listitem>
+    <para>
+     pll_if - a low level interface that encapsulates the details of dealing
+     with the PLL register
+    </para>
+   </listitem>
+  </itemizedlist>
+
+  <sect1 id="cf750gx">
+   <title>cf750gx - The CPUFreq 750GX driver</title>
+
+   <para>
+    cf750gx provides the standard entry points required of a cpufreq driver. They
+    are:
+
+   <itemizedlist>
+    <listitem>
+     <para>
+      cf750gx_verify - verify
+     </para>
+    </listitem>
+
+    <listitem>
+     <para>
+      cf750gx_target - target
+     </para>
+    </listitem>
+
+    <listitem>
+     <para>
+      cf750gx_cpu_init - cpu init
+     </para>
+    </listitem>
+
+    <listitem>
+     <para>
+      cf750gx_cpu_exit - cpu exit
+     </para>
+    </listitem>
+   </itemizedlist>
+
+    These routines perform functions as required by the cpufreq subsystem.
+   </para>
+
+   <para>
+    The driver functions in one of 2 modes:  normal and minmax. In normal mode
+    it switches between the available frequencies as requested by the current
+    cpufreq subsystem governor. In minmax mode, it switches between the minimum
+    and maximum frequencies only.
+   </para>
+
+   <sect2 id="cf750gxModesNormal"><title>Normal Mode</title>
+    <para>
+     In normal mode the driver switches between all valid frequencies under
+     control of the selected governor. The list of valid frequencies is
+     determined at startup based on the cpu model (FX or GX) and the determined
+     bus frequency. The cpu model determines the minimum and maximum core
+     frequencies, though these can be overriden at start up via module
+     parameters. See Module Parameters. The bus frequency is obtained from
+     pll_if.
+    </para>
+   </sect2>
+
+   <sect2 id="cf750gxModesMinMax"><title>MinMax Mode</title>
+    <para>
+     In minmax mode the driver switches between the minimum and maximum core
+     frequencies only. This provides the capability for very low latency
+     frequency switches. See Module Parameters and sysfs Attributes.
+    </para>
+   </sect2>
+
+   <sect2 id="cf750gxModuleParameters"><title>Module Parameters</title>
+    <para>
+     cf750gx has 3 module parameters:
+    </para>
+
+    <itemizedlist>
+     <listitem>
+      <para>
+       maxcore
+      </para>
+     </listitem>
+     <listitem>
+      <para>
+       mincore
+      </para>
+     </listitem>
+     <listitem>
+      <para>
+       minmax
+      </para>
+     </listitem>
+    </itemizedlist>
+
+    <sect3 id="cf750gxParamOverrideMaxCore"><title>maxcore</title>
+     <para>
+      Normally the maximum frequency the cpu can be clocked is defined by the
+      cpu model. For the FX it is 800 MHz and 1,000 MHz for the GX. This
+      parameter allows you to override this maximum. It is specified in KHz.
+     </para>
+    </sect3>
+
+    <sect3 id="cf750gxParamOverrideMinCore"><title>mincore</title>
+     <para>
+      Likewise for cpu minimum frequency.
+     </para>
+
+     <note>
+      <para>
+       The 750GX on my PowerForce 750GX cpu upgrade seems stable at 250 MHz.
+       The spec says the minimum for the GX is 500 MHz.
+      </para>
+     </note>
+    </sect3>
+
+    <sect3 id="cf750gxParamMinMaxMode"><title>minmax</title>
+     <para>
+      This boolean parameter allows one to enable minmax mode on startup.
+     </para>
+    </sect3>
+   </sect2>
+
+   <sect2 id="cf750gxsysfsAttributes"><title>sysfs Attributes</title>
+    <para>
+     cf750gx has 2 sysfs attributes that can be used to modify its operation.
+     They are:
+
+     <itemizedlist>
+      <listitem>
+       <para>
+	idle_pll_off
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        minmax
+       </para>
+      </listitem>
+     </itemizedlist>
+
+     Both are booleans.
+    </para>
+
+    <sect3 id="IdlePllOffAttr"><title>idle_pll_off</title>
+     <para>
+      This boolean tells the driver to switch the idle PLL (the one NOT
+      currently used to drive the cpu core clock) off. Turning the unused PLL
+      off results in a modest power savings [750GX_ds2-17-05.pdf,
+      section 5.2.1, page 44].
+     </para>
+    </sect3>
+
+    <sect3 id="MinMaxModeAttr"><title>minmax</title>
+     <para>
+      This attribute controls the same feature as the similarly named module
+      parameter.
+     </para>
+
+     <note>
+      <para>
+       In order to get this to work with the conservative governor, the
+       "freq_step" attribute must be set to a value that will pick the max
+       frequency from the 2 element frequency table. A good value is 80 (which
+       says to jump in frequency by 80% of the maximum on each change).
+      </para>
+     </note>
+    </sect3>
+   </sect2>
+  </sect1>
+
+  <sect1 id="pll_if">
+   <title>pll_if - The Low Level PLL Interface Module</title>
+   <para>
+    pll_if provides the choice of two interfaces to control the PLL register.
+    One is via a sysfs attribute. The other is through an exported, public
+    routine. At least one interface must be selected during kernel
+    configuration.
+   </para>
+
+   <sect2 id="sysfsInterface"><title>sysfs Interface - ppc750gxpll</title>
+    <para>
+     This interface provides a sysfs attribute that can be written to to
+     directly control the PLL configuration register. The upper 8 or so bits of
+     the PLL configuration register are read only. This interface takes
+     advantage of this by using these bits to define which of the writeable
+     bits contain valid data. The header file
+     <filename class="headerfile">include/asm-powerpc/pll_if.h</filename>
+     defines the following macros:
+
+     <itemizedlist>
+      <listitem>
+       <para>
+        PLL0_DO_CFG - PLL 0 config (ratio) valid
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        PLL0_DO_RNG - PLL 0 range valid
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        PLL1_DO_CFG - PLL 1 config (ratio) valid
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        PLL1_DO_RNG - PLL 1 range valid
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        PLL_DO_SEL - PLL selection bit valid
+       </para>
+      </listitem>
+     </itemizedlist>
+
+     See the PERL script pll.pl for an example of using the sysfs attribute.
+    </para>
+   </sect2>
+
+   <sect2 id="PublicAPI"><title>Exported, Public Functions Interface</title>
+    <para>
+     This interface provides a public API that other code can use. The list of
+     functions is:
+
+     <itemizedlist>
+      <listitem>
+       <para>
+        pllif_pack_state
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        pllif_get_latency
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        pllif_modify_PLL
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        pllif_get_bus_clock
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        pllif_cfg_to_freq
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        pllif_register_pll_switch_cb
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        pllif_unregister_pll_switch_cb
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        pllif_register_pll_lock_cb
+       </para>
+      </listitem>
+
+      <listitem>
+       <para>
+        pllif_unregister_pll_lock_cb
+       </para>
+      </listitem>
+     </itemizedlist>
+
+
+     The embedded documentation from
+     <filename class="headerfile">include/asm-powerpc/pll_if.h</filename>
+     and
+     <filename class="headerfile">arch/powerpc/kernel/cpu/pll_if.c</filename>
+     is included in the appendix.
+
+    </para>
+   </sect2>
+
+   <sect2 id="pllifModuleParameters"><title>Module Parameters</title>
+    <para>
+     pll_if has one tunable parameter. busclock allows you to specify
+     the bus frequency. This is useful if the code can not determine the value
+     or gets it wrong. It is in KHz.
+    </para>
+
+    <note>
+     <para>
+      This code was developed on a PowerMac 8600 with a PowerLogix 750GX
+      upgrade card in it. The method used in the code to get the bus frequency
+      is what worked on this system.
+     </para>
+    </note>
+   </sect2>
+  </sect1>
+ </chapter>
+
+ <chapter id="Misc"><title>Misc</title>
+  <sect1 id="pll.pl"><title>pll.pl - A User Friendly pll_if sysfs utility</title>
+   <para>
+    pll.pl is a PERL script that provides a user friendly interface to the
+    pll_if sysfs attribute, cf750gxpll. It provides options to query the
+    current PLL state, change the configuration of either PLL (when inactive),
+    and to switch the PLL in use. See the embedded documentation in pll.pl
+    for details.
+   </para>
+  </sect1>
+ </chapter>
+ <chapter id="Appendix"><title>Appendix</title>
+!Finclude/asm-powerpc/pll_if.h pllifGetLatency pllifPackState
+!Earch/powerpc/kernel/cpu/pll_if.c
+ </chapter>
+</book>
Index: Documentation/DocBook/Makefile
===================================================================
--- Documentation/DocBook/Makefile.orig	2008-08-13 02:18:51.000000000 -0700
+++ Documentation/DocBook/Makefile	2008-08-14 02:47:33.000000000 -0700
@@ -12,7 +12,7 @@ DOCBOOKS := wanbook.xml z8530book.xml mc
  	    kernel-api.xml filesystems.xml lsm.xml usb.xml kgdb.xml \
  	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
  	    genericirq.xml s390-drivers.xml uio-howto.xml scsi.xml \
-	    mac80211.xml debugobjects.xml
+	    mac80211.xml debugobjects.xml cf750gx.xml

  ###
  # The build process is as follows (targets):
Index: arch/powerpc/kernel/cpu/cpufreq/Kconfig
===================================================================
--- /dev/null	2004-08-10 18:55:00.000000000 -0700
+++ arch/powerpc/kernel/cpu/cpufreq/Kconfig	2008-08-19 00:24:15.000000000 -0700
@@ -0,0 +1,33 @@
+#
+# CPU Frequency scaling
+#
+
+menu "CPU Frequency scaling"
+
+source "drivers/cpufreq/Kconfig"
+
+if CPU_FREQ
+
+comment "CPUFreq processor drivers"
+
+config CPU_FREQ_PPC_750GX_DUAL_PLL
+	tristate "PowerPC 750 FX/GX Dual PLL driver"
+	depends on !SMP
+	select PPC_750GX_DUAL_PLL_IF
+	select CPU_FREQ_TABLE
+	help
+	  This driver adds a CPUFreq driver which utilizes the dual
+	  PLLs found in the IBM 750 FX & GX cpus. This will automatically
+	  select the pll_if module. It does NOT support SMP.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cf750gx.
+
+	  For details, take a look at <file:Documentation/cpu-freq/> and also
+	  see the cf750gx DocBook.
+
+	  If in doubt, say N.
+
+endif	# CPU_FREQ
+
+endmenu
Index: arch/powerpc/kernel/cpu/cpufreq/Makefile
===================================================================
--- /dev/null	2004-08-10 18:55:00.000000000 -0700
+++ arch/powerpc/kernel/cpu/cpufreq/Makefile	2008-08-14 02:44:30.000000000 -0700
@@ -0,0 +1 @@
+obj-$(CONFIG_CPU_FREQ_PPC_750GX_DUAL_PLL)	+= cf750gx.o
Index: arch/powerpc/kernel/cpu/cpufreq/cf750gx.c
===================================================================
--- /dev/null	2004-08-10 18:55:00.000000000 -0700
+++ arch/powerpc/kernel/cpu/cpufreq/cf750gx.c	2008-08-29 03:05:33.000000000 -0700
@@ -0,0 +1,741 @@
+/*
+ * cf750gx.c - cpufreq driver for the dual PLLs in the 750gx
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
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/cpufreq.h>
+#include <linux/compiler.h>
+#include <linux/dmi.h>
+#include <linux/delay.h>
+#include "linux/completion.h"
+
+#include <asm/processor.h>
+#include "asm/pll.h"
+#include "asm/pll_if.h"
+#include "asm/time.h"
+
+#define cf750gxmChangingPll		(0x80000000)
+#define cf750gxmChangingPllBit		(31)
+#define cf750gxmTurningIdlePllOff	(0x40000000)
+#define cf750gxmTurningIdlePllOffBit	(30)
+#if 0
+#define cf750gxm_CHANGING_PLL			(0X80000000)
+#define cf750gxm_CHANGING_PLL_BIT_POS		(31)
+#define cf750gxm_TURNING_IDLE_PLL_OFF		(0X40000000)
+#define cf750gxm_TURNING_IDLE_PLL_OFF_BIT_POS	(30)
+#endif
+struct pll_750fgx {
+	unsigned short min_ratio;	/* min bus ratio */
+	unsigned short max_ratio;	/* max bus ratio */
+	unsigned int min_core;		/* min core frequency per spec (KHz) */
+	unsigned int max_core;		/* max core frequency per spec (KHz) */
+};
+
+#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, \
+	"ppc-750gx-cpufreq", msg)
+
+struct cf750gx_call_data {
+	struct cpufreq_freqs freqs;
+	unsigned long current_pll;
+	int idle_pll_off;
+};
+
+static const struct pll_750fgx __initdata pll_750fx = {
+	.min_ratio = 2,
+	.max_ratio = 20,
+	.min_core = 400000,
+	.max_core = 800000,
+};
+
+static const struct pll_750fgx __initdata pll_750gx = {
+	.min_ratio = 2,
+	.max_ratio = 20,
+	.min_core = 500000,
+	.max_core = 1000000,
+};
+
+static DECLARE_COMPLETION(cf750gx_exit_completion);
+
+/*
+ * mincore and maxcore are module params. 0 means unset.
+ * minmax is a boolean param. 0 means disabled.
+ */
+static unsigned int mincore = 0;
+static unsigned int maxcore = 0;
+static int minmax;
+
+module_param(maxcore, uint, 0);
+MODULE_PARM_DESC(maxcore,
+	"clock frequency in KHz.");
+
+module_param(mincore, uint, 0);
+MODULE_PARM_DESC(mincore,
+	"clock frequency in KHz.");
+
+module_param(minmax, bool, 0);
+MODULE_PARM_DESC(minmax,
+	"Use only the minimum and maximum frequencies.");
+
+/*
+ * ..._idle_pll_off is a boolean for a sysfs attribute. 0 means disabled.
+ * ..._minmax is a boolean for the current state of minmax.
+ * ..._state_bits maintains global state information.
+ */
+static int cf750gx_idle_pll_off;
+static int cf750gx_minmax;
+static unsigned long cf750gx_state_bits;
+
+static struct cpufreq_frequency_table *cf750gx_f_table;
+static struct cpufreq_frequency_table *cf750gx_freq_table;
+static struct cpufreq_frequency_table *cf750gx_min_max_freq_table;
+
+static struct cf750gx_call_data cf750gx_switch_call_data;
+static struct cf750gx_call_data cf750gx_lock_call_data;
+static struct notifier_block cf750gx_pll_switch_nb;
+static struct notifier_block cf750gx_pll_lock_nb;
+
+static int cf750gx_pll_switch_cb(struct notifier_block *nb, unsigned long
+	action, void *data)
+{
+	struct cf750gx_call_data *cd;
+	unsigned int idle_pll;
+	unsigned int pll_off_cmd;
+	unsigned int new_pll;
+
+	cd = data;
+
+	dprintk("%s():  cd->idle_pll_off is %d, new PLL is 0x%x"
+		", Switched to  %d KHz\n", __func__, cd->idle_pll_off,
+		cd->current_pll, cd->freqs.new);
+
+	cpufreq_notify_transition(&cd->freqs, CPUFREQ_POSTCHANGE);
+
+	if (cd->idle_pll_off) {
+		/*
+		 * Assemble call to turn idle PLL off. Use the value of
+		 * current_pll in the call data thing.
+		 */
+		idle_pll = get_next_PLL(cd->current_pll)^0x1;
+
+		pll_off_cmd = pllif_pack_state(0, 2);
+
+		/*
+		 * Put in correct spot
+		 */
+		if (idle_pll) {
+			/*
+			 * Use PLL 1
+			 */
+			new_pll = ((PLL1_DO_CFG|PLL1_DO_RNG)<<24);
+		} else {
+			/*
+			 * Since active PLL is 1, switch off PLL 0
+			 */
+			pll_off_cmd = pll_off_cmd<<(PLL0_CFG_SHIFT-
+				PLL1_CFG_SHIFT);
+
+			new_pll = (PLL0_DO_CFG|PLL0_DO_RNG)<<24;
+		}
+
+		new_pll = new_pll|pll_off_cmd;
+
+		set_bit(cf750gxmTurningIdlePllOffBit, &cf750gx_state_bits);
+
+		(void) pllif_modify_PLL(new_pll, 0);
+	} else {
+		clear_bit(cf750gxmChangingPllBit, &cf750gx_state_bits);
+
+		complete(&cf750gx_exit_completion);
+	}
+
+	return NOTIFY_OK;
+}
+
+static int cf750gx_pll_lock_cb(struct notifier_block *nb, unsigned long action,
+	void *data)
+{
+	struct cf750gx_call_data *cd;
+
+	cd = data;
+
+	dprintk("%s():  cd->idle_pll_off is %d, new PLL is 0x%x"
+		", Switched to  %d KHz\n", __func__, cd->idle_pll_off,
+		cd->current_pll, cd->freqs.new);
+
+	if (cd->idle_pll_off) {
+		/*
+		 * We want to turn off the inactive (idle) pll. Use the state
+		 * bits global to figure out whether this call back is for the
+		 * original, cpufreq ordered frequency change or our turning
+		 * off of the idle PLL.
+		 */
+		if (test_bit(cf750gxmTurningIdlePllOffBit,
+			&cf750gx_state_bits)) {
+			clear_bit(cf750gxmTurningIdlePllOffBit,
+				&cf750gx_state_bits);
+			clear_bit(cf750gxmChangingPllBit,
+				&cf750gx_state_bits);
+			complete(&cf750gx_exit_completion);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static inline const char *cf750gx_i_relation_str(unsigned int relation)
+{
+	switch (relation) {
+	case CPUFREQ_RELATION_L:	return "CPUFREQ_RELATION_L";
+	case CPUFREQ_RELATION_H:	return "CPUFREQ_RELATION_H";
+	default:			return "relation ??";
+	}
+}
+
+static int cf750gx_target(struct cpufreq_policy *policy,
+			       unsigned int target_freq, unsigned int relation)
+{
+	unsigned int next_index;	/* Index into freq_table */
+	unsigned int next_freq;		/* next frequency from perf table */
+	unsigned int next_perf_state;	/* Index from perf table */
+	int result;
+	unsigned int pll;
+	unsigned int new_pll;
+	unsigned int active_pll;
+	struct cpufreq_freqs freqs;
+	struct cpufreq_frequency_table *ft;
+
+	dprintk(__FILE__">%s(, %u KHz, relation %u)-%d:  on cpu %d\n",
+		__func__, target_freq, relation, __LINE__, policy->cpu);
+
+	if (test_and_set_bit(cf750gxmChangingPllBit, &cf750gx_state_bits))
+		return -EAGAIN;
+
+	ft = cf750gx_f_table;
+	next_index = 0;
+	next_freq = 0;
+	next_perf_state = 0;
+	result = 0;
+
+	INIT_COMPLETION(cf750gx_exit_completion);
+
+	result = cpufreq_frequency_table_target(policy,
+						ft,
+						target_freq,
+						relation, &next_index);
+
+	if (unlikely(result)) {
+		result = -ENODEV;
+		goto cf750gxTargetUnlock;
+	}
+
+	next_perf_state = ft[next_index].index;
+	next_freq = ft[next_index].frequency;
+	dprintk(__FILE__">%s()-%d:  %d KHz (state=%x) selected from table "
+		"(%s)\n", __func__, __LINE__, next_freq, next_perf_state,
+		cf750gx_i_relation_str(relation));
+
+	pll = get_PLL();
+	active_pll = get_active_PLL(pll);
+
+#if 0
+#ifdef CONFIG_HOTPLUG_CPU
+	/* cpufreq holds the hotplug lock, so we are safe from here on */
+	cpus_and(online_policy_cpus, cpu_online_map, policy->cpus);
+#else
+	online_policy_cpus = policy->cpus;
+#endif
+#endif
+
+	result = 0;
+	if (pllif_pack_state(get_PLL_ratio(active_pll, pll), get_PLL_range(
+		active_pll, pll)) == next_perf_state) {
+		dprintk("Already at target state (%x)\n",
+			next_perf_state);
+		goto cf750gxTargetUnlock;
+	}
+
+/*	cpus_clear(cmd.mask); */
+
+	dprintk(__FILE__">%s()-%d:  Current PLL:  0x%x\n", __func__, __LINE__,
+		pll);
+
+	if (active_pll) {
+		unsigned int current_state;
+
+		/*
+		 * Since active PLL is 1, modify PLL 0. First see if it is
+		 * already where we want it.
+		 */
+		current_state = pllif_pack_state(get_PLL_ratio(0, pll),
+			get_PLL_range(0, pll));
+
+		dprintk(__FILE__">%s()-%d:  pll 0 current state:  0x%x\n",
+			__func__, __LINE__, current_state);
+
+		if (current_state == next_perf_state) {
+			new_pll = PLL_DO_SEL<<24;
+			next_perf_state = 0;
+		} else {
+			next_perf_state = next_perf_state<<(PLL0_CFG_SHIFT-
+				PLL1_CFG_SHIFT);
+
+			new_pll = (PLL0_DO_CFG|PLL0_DO_RNG|PLL_DO_SEL)<<24;
+		}
+	} else {
+		unsigned int current_state;
+
+		/*
+		 * Use PLL 1. Again, see if it is already at the desired
+		 * configuration.
+		 */
+		current_state = pllif_pack_state(get_PLL_ratio(1, pll),
+			get_PLL_range(1, pll));
+
+		dprintk(__FILE__">%s()-%d:  pll 1 current state:  0x%x\n",
+			__func__, __LINE__, current_state);
+
+		if (current_state == next_perf_state) {
+			new_pll = (PLL_DO_SEL<<24)|PLL_SEL_MASK;
+			next_perf_state = 0;
+		} else {
+			new_pll = ((PLL1_DO_CFG|PLL1_DO_RNG|PLL_DO_SEL)<<24)|
+				PLL_SEL_MASK;
+		}
+	}
+
+	new_pll = new_pll|next_perf_state;
+
+	dprintk(__FILE__">%s()-%d:  Modifying PLL:  0x%x\n", __func__, __LINE__,
+		new_pll);
+
+	freqs.old = pllif_cfg_to_freq(get_PLL_ratio(active_pll, pll))/1000;
+	freqs.new = ft[next_index].frequency;
+	freqs.cpu = 0;
+
+	cf750gx_switch_call_data.freqs = freqs;
+	cf750gx_switch_call_data.current_pll = new_pll;
+	cf750gx_switch_call_data.idle_pll_off = cf750gx_idle_pll_off;
+
+	cf750gx_lock_call_data.freqs = freqs;
+	cf750gx_lock_call_data.current_pll = new_pll;
+	cf750gx_lock_call_data.idle_pll_off = cf750gx_switch_call_data.
+		idle_pll_off;
+
+	dprintk(__FILE__">%s()-%d:  freqs.old=%d, freqs.new=%d\n", __func__,
+		__LINE__, freqs.old, freqs.new);
+
+	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
+
+	result = pllif_modify_PLL(new_pll, 0);
+
+	if (result < 0)
+		goto cf750gxTargetUnlock;
+
+	return 0;
+
+cf750gxTargetUnlock:
+	clear_bit(cf750gxmChangingPllBit, &cf750gx_state_bits);
+	complete(&cf750gx_exit_completion);
+
+	return result;
+}
+
+static int cf750gx_verify(struct cpufreq_policy *policy)
+{
+	dprintk("%s()\n", __func__);
+
+	return cpufreq_frequency_table_verify(policy, cf750gx_f_table);
+}
+
+static int cf750gx_cpu_init(struct cpufreq_policy *policy)
+{
+	unsigned int pll;
+	unsigned int result = 0;
+
+	dprintk("%s()\n", __func__);
+
+	cf750gx_state_bits = 0;
+	cf750gx_minmax = minmax;
+	cf750gx_idle_pll_off = 0;
+
+	pll = get_PLL();
+
+	policy->cur = pllif_cfg_to_freq(get_PLL_ratio(get_active_PLL(pll),
+		pll))/1000;
+
+	policy->cpuinfo.transition_latency = pllif_get_latency();
+
+	result = cpufreq_frequency_table_cpuinfo(policy, cf750gx_f_table);
+	if (result)
+		goto err_freqfree;
+
+	cpufreq_frequency_table_get_attr(cf750gx_f_table, policy->cpu);
+
+	cf750gx_pll_switch_nb.notifier_call = cf750gx_pll_switch_cb;
+
+	result = pllif_register_pll_switch_cb(&cf750gx_pll_switch_nb,
+		&cf750gx_switch_call_data);
+
+	cf750gx_pll_lock_nb.notifier_call = cf750gx_pll_lock_cb;
+
+	result = pllif_register_pll_lock_cb(&cf750gx_pll_lock_nb,
+		&cf750gx_lock_call_data);
+
+err_freqfree:
+	return result;
+}
+
+static int cf750gx_cpu_exit(struct cpufreq_policy *policy)
+{
+	dprintk("%s()\n", __func__);
+
+	/*
+	 * Wait for any active requests to ripple through before exiting. The
+	 * test_bit() condition is to catch the case where we exit with the
+	 * cf750gx_target() routine never having been called.
+	 */
+	if (test_bit(cf750gxmChangingPllBit,
+		&cf750gx_state_bits))
+		wait_for_completion(
+			&cf750gx_exit_completion);
+
+	cpufreq_frequency_table_put_attr(policy->cpu);
+
+	pllif_unregister_pll_switch_cb(&cf750gx_pll_switch_nb);
+
+	pllif_unregister_pll_lock_cb(&cf750gx_pll_lock_nb);
+
+	cf750gx_pll_switch_nb.notifier_call = NULL;
+	cf750gx_pll_switch_nb.next = NULL;
+
+	cf750gx_pll_lock_nb.notifier_call = NULL;
+	cf750gx_pll_lock_nb.next = NULL;
+
+	return 0;
+}
+
+static int cf750gx_resume(struct cpufreq_policy *policy)
+{
+	return 0;
+}
+
+/*
+ * cf750gx_i_show_idle_pll_off - Show state of idle pll off boolean
+ */
+static ssize_t cf750gx_i_show_idle_pll_off(struct cpufreq_policy *policy,
+	char *buf)
+{
+	return sprintf(buf, "%d\n", cf750gx_idle_pll_off);
+}
+
+static ssize_t cf750gx_i_store_pll_off(struct cpufreq_policy *policy,
+	const char *buf, size_t count)
+{
+	if (buf[0] == '0')
+		cf750gx_idle_pll_off = 0;
+	else if (buf[0] == '1')
+		cf750gx_idle_pll_off = !0;
+
+	return 1;
+}
+
+static struct freq_attr idle_pll_off_attr = {
+	.attr = { .name = "idle_pll_off",
+		  .mode = 0644,
+		},
+	.show = cf750gx_i_show_idle_pll_off,
+	.store = cf750gx_i_store_pll_off,
+};
+
+/*
+ * cf750gx_i_show_minmax - Show state of min max mode boolean
+ */
+static ssize_t cf750gx_i_show_minmax(struct cpufreq_policy *policy,
+	char *buf)
+{
+	return sprintf(buf, "%d\n", cf750gx_minmax);
+}
+
+static ssize_t cf750gx_i_store_minmax(struct cpufreq_policy *policy,
+	const char *buf, size_t count)
+{
+	int result;
+
+	if (buf[0] == '0') {
+		cf750gx_minmax = 0;
+
+		cf750gx_f_table = cf750gx_freq_table;
+
+		cpufreq_frequency_table_put_attr(policy->cpu);
+
+		cpufreq_frequency_table_get_attr(cf750gx_freq_table,
+			policy->cpu);
+
+		result = cpufreq_frequency_table_cpuinfo(policy,
+			cf750gx_freq_table);
+	} else if (buf[0] == '1') {
+		cf750gx_minmax = !0;
+
+		cf750gx_f_table = cf750gx_min_max_freq_table;
+
+		cpufreq_frequency_table_put_attr(policy->cpu);
+
+		cpufreq_frequency_table_get_attr(cf750gx_min_max_freq_table,
+			policy->cpu);
+
+		result = cpufreq_frequency_table_cpuinfo(policy,
+			cf750gx_min_max_freq_table);
+	}
+
+	return 1;
+}
+
+static struct freq_attr minmax_attr = {
+	.attr = { .name = "minmax",
+		  .mode = 0644,
+		},
+	.show = cf750gx_i_show_minmax,
+	.store = cf750gx_i_store_minmax,
+};
+
+
+static struct freq_attr *cf750gxvAttr[] = {
+	&cpufreq_freq_attr_scaling_available_freqs,
+	&idle_pll_off_attr,
+	&minmax_attr,
+	NULL,
+};
+
+static struct cpufreq_driver cf750gx_drv = {
+	.verify = cf750gx_verify,
+	.target = cf750gx_target,
+	.init = cf750gx_cpu_init,
+	.exit = cf750gx_cpu_exit,
+	.resume = cf750gx_resume,
+	.name = "ppc750gx-cpufreq",
+	.owner = THIS_MODULE,
+	.attr = cf750gxvAttr,
+};
+
+static int __init cf750gx_init(void)
+{
+	int ret;
+	unsigned int freq, i, j, rng, bus_clock;
+	unsigned short min_ratio, max_ratio;
+	struct cpufreq_frequency_table *tbp;
+	const struct pll_750fgx *pll_defaults;
+	unsigned int cf750gx_min_core;
+	unsigned int cf750gx_max_core;
+
+	dprintk("%s()\n", __func__);
+
+	if (!cpu_has_feature(CPU_FTR_DUAL_PLL_750FX))
+		return 0;
+
+	/*
+	 * Get processor min and max core frequencies. If they have not been
+	 * overriden, then get them from version defaults.
+	 */
+	if ((cur_cpu_spec->pvr_value>>16) == 0x7000)
+		pll_defaults = &pll_750fx;
+	else
+		pll_defaults = &pll_750gx;
+
+	cf750gx_min_core = mincore?mincore:pll_defaults->
+			min_core;
+	cf750gx_max_core = maxcore?maxcore:pll_defaults->
+			max_core;
+
+	dprintk(__FILE__">%s()-%d:  cf750gx_min_core is %u, "
+		"cf750gx_max_core is %u\n", __func__, __LINE__,
+		cf750gx_min_core, cf750gx_max_core);
+	dprintk(__FILE__">%s()-%d:  pll_defaults:  min_ratio %d, max_ratio "
+		"%d\n", __func__, __LINE__, pll_defaults->min_ratio,
+		pll_defaults->max_ratio);
+
+	ret = -EINVAL;
+	if (!cf750gx_min_core) {
+		dprintk("Can't determine minimum core frequency\n");
+		goto err_simple;
+	}
+
+	if (!cf750gx_max_core) {
+		dprintk("Can't determine maximum core frequency\n");
+		goto err_simple;
+	}
+
+	bus_clock = pllif_get_bus_clock()/1000;
+
+	/*
+	 * Build maximum freq table. This will depend on the bus freq, the core
+	 * frequency limits, and the ratios.
+	 */
+	min_ratio = pll_defaults->min_ratio;
+	freq = min_ratio*bus_clock;
+
+	if (freq < cf750gx_min_core) {
+		/*
+		 * Core min is above min ratio and bus speed clock. Find min
+		 * ratio such that min ratio * bus speed >= core min.
+		 */
+		min_ratio = cf750gx_min_core/bus_clock;
+		j = cf750gx_min_core%bus_clock;
+
+		if (j)
+			min_ratio++;
+	} else {
+		/*
+		 * Core min is below min ratio and speed clock. Reset core min.
+		 */
+		cf750gx_min_core = freq;
+	}
+
+	max_ratio = pll_defaults->max_ratio;
+	freq = max_ratio*bus_clock;
+
+	if (freq > cf750gx_max_core) {
+		/*
+		 * Core max is below max ratio and bus speed. Find max ratio
+		 * such that max ratio * bus speed <= core max.
+		 */
+		max_ratio = cf750gx_max_core/bus_clock;
+	} else {
+		/*
+		 * Core max is above max ratio and bus speed clock. Reset core
+		 * max.
+		 */
+		cf750gx_max_core = freq;
+	}
+
+	dprintk(__FILE__">%s()-%d:  min_ratio is %d, max_ratio is %d\n",
+		__func__, __LINE__, min_ratio, max_ratio);
+
+	/*
+	 * Bus ratios for the GX range from 2-20 for 19 INTEGER frequencies.
+	 * The above checks may have changed this. There are max_ratio -
+	 * min_ratio + 1 different frequencies.
+	 */
+	j = max_ratio-min_ratio+1;
+	cf750gx_freq_table = kmalloc(sizeof(struct cpufreq_frequency_table)*
+		(j+5), GFP_KERNEL);
+
+	ret = -ENOMEM;
+	if (cf750gx_freq_table == NULL)
+		goto err_simple;
+
+
+	/*
+	 * Use index of first entry to keep track of the count (one extra
+	 * entry)
+	 */
+	cf750gx_freq_table[0].frequency = CPUFREQ_ENTRY_INVALID;
+	cf750gx_freq_table[0].index = j;
+
+	/*
+	 * Populate the table
+	 */
+	for (tbp = cf750gx_freq_table+1, i = min_ratio; i <= max_ratio;
+		tbp++, i++) {
+		tbp->frequency = i*bus_clock;
+
+		/*
+		 * I really don't know what the proper range values for 600 MHz
+		 * and 900 MHz are? (The processor may also get pretty mad if
+		 * you muck these up!)
+		 */
+		if (tbp->frequency < 600000)
+			rng = 2;
+		else if (tbp->frequency < 900000)
+			rng = 0;
+		else
+			rng = 1;
+
+		/*
+		 * The computation in the first argument converts the bus
+		 * ratio value to the PLL configuration value needed for the
+		 * given ratio
+		 */
+		tbp->index = pllif_pack_state(i > 10?i+10:(i<<1), rng);
+
+		dprintk(__FILE__">%s()-%d:  p->index=%x, ratio=%u, rng=%u\n",
+			__func__, __LINE__, tbp->index, i, rng);
+	}
+
+	/*
+	 * 2nd extra array member
+	 */
+	tbp->frequency = CPUFREQ_TABLE_END;
+
+	/*
+	 * The other 3 extra array members are for the min max table.
+	 */
+	cf750gx_min_max_freq_table = cf750gx_freq_table+
+		cf750gx_freq_table[0].index + 2;
+
+	cf750gx_min_max_freq_table[0] = cf750gx_freq_table[1];
+	cf750gx_min_max_freq_table[1] = cf750gx_freq_table[
+		cf750gx_freq_table[0].index];
+	cf750gx_min_max_freq_table[2].frequency = CPUFREQ_TABLE_END;
+
+	cf750gx_f_table = minmax?cf750gx_min_max_freq_table:
+		cf750gx_freq_table;
+
+	ret = cpufreq_register_driver(&cf750gx_drv);
+
+	if (ret)
+		goto err_freq_table;
+
+	return 0;
+
+err_freq_table:
+	kfree(cf750gx_freq_table);
+err_simple:
+	return ret;
+}
+
+static void __exit cf750gx_exit(void)
+{
+	dprintk("%s()\n", __func__);
+
+	cpufreq_unregister_driver(&cf750gx_drv);
+
+	if (cf750gx_freq_table)
+		kfree(cf750gx_freq_table);
+
+	cf750gx_freq_table = cf750gx_min_max_freq_table =
+		cf750gx_f_table = NULL;
+
+	return;
+}
+
+late_initcall(cf750gx_init);
+module_exit(cf750gx_exit);
+
+MODULE_ALIAS("dual-pll");
+
+MODULE_AUTHOR("Kevin Diggs");
+MODULE_DESCRIPTION("750GX Dual PLL cpufreq driver");
+MODULE_LICENSE("GPL");
Index: arch/powerpc/kernel/cpu/Makefile
===================================================================
--- /dev/null	2004-08-10 18:55:00.000000000 -0700
+++ arch/powerpc/kernel/cpu/Makefile	2008-08-14 02:44:30.000000000 -0700
@@ -0,0 +1,6 @@
+#
+# Makefile for ppc CPU details and quirks
+#
+
+obj-$(CONFIG_CPU_FREQ)	+= cpufreq/
+obj-$(CONFIG_PPC_750GX_DUAL_PLL_IF)	+= pll_if.o
