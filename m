Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZLSUtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZLSUtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 15:49:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbZLSUtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 15:49:15 -0500
Received: from us-mx4.synaptics.com ([12.178.49.178]:12491 "EHLO
	us-mx4.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbZLSUtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 15:49:13 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Dec 2009 15:49:12 EST
X-PGP-Universal: processed;
	by securemail.synaptics.com on Sat, 19 Dec 2009 11:56:52 -0800
Message-ID: <4B2D3C53.8060908@synaptics.com>
Date: Sat, 19 Dec 2009 12:49:23 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Allie Xiong <axiong@synaptics.com>, William Manson <WManson@synaptics.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC] [PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver
References: <4B2D3B3A.2010308@synaptics.com>
In-Reply-To: <4B2D3B3A.2010308@synaptics.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Manson <WManson@synaptics.com>

Initial driver for Synaptics touchscreens using RMI4 protocol.

Signed-off-by: William Manson <WManson@synaptics.com>
Signed-off-by: Allie Xiong <axiong@synaptics.com>
Signed-off-by: Christopher Heiny <cheiny@synaptics.com>


index 32fc8ba..2b950f7 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -295,6 +295,19 @@ config TOUCHSCREEN_MIGOR
  	  To compile this driver as a module, choose M here: the
  	  module will be called migor_ts.

+config TOUCHSCREEN_SYNAPTICS_RMI4_I2C
+	tristate "Synaptics RMI4 I2C touchscreens"
+	depends on I2C
+	help
+	  Say Y here if you have a Synaptics RMI4 I2C touchscreen connected to
+   	  your system. This enables support for Synaptics RMI4 over I2C based
+          touchscreens.
+
+	  If unsure, say N.
+
+	  To compile this driver as a set of modules, choose M here: the
+	  modules will be called rmi, rmi_app_touchpad, rmi_phys_i2c.
+
  config TOUCHSCREEN_TOUCHRIGHT
  	tristate "Touchright serial touchscreen"
  	select SERIO
diff --git a/drivers/input/touchscreen/Makefile 
b/drivers/input/touchscreen/Makefile
index f1f59c9..81f938a 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -12,7 +12,6 @@ obj-$(CONFIG_TOUCHSCREEN_ADS7846)	+= ads7846.o
  obj-$(CONFIG_TOUCHSCREEN_ATMEL_TSADCC)	+= atmel_tsadcc.o
  obj-$(CONFIG_TOUCHSCREEN_BITSY)		+= h3600_ts_input.o
  obj-$(CONFIG_TOUCHSCREEN_CORGI)		+= corgi_ts.o
-obj-$(CONFIG_TOUCHSCREEN_DYNAPRO)	+= dynapro.o
  obj-$(CONFIG_TOUCHSCREEN_GUNZE)		+= gunze.o
  obj-$(CONFIG_TOUCHSCREEN_EETI)		+= eeti_ts.o
  obj-$(CONFIG_TOUCHSCREEN_ELO)		+= elo.o
@@ -26,9 +25,8 @@ obj-$(CONFIG_TOUCHSCREEN_HP600)		+= hp680_ts_input.o
  obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+= jornada720_ts.o
  obj-$(CONFIG_TOUCHSCREEN_HTCPEN)	+= htcpen.o
  obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
-obj-$(CONFIG_TOUCHSCREEN_PCAP)		+= pcap_ts.o
  obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
-obj-$(CONFIG_TOUCHSCREEN_S3C2410)	+= s3c2410_ts.o
+obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_RMI4_I2C)	+= rmi_core.o 
rmi_app_touchpad.o rmi_function_11.o rmi_phys_i2c.o rmi_i2c_gta01.o
  obj-$(CONFIG_TOUCHSCREEN_TOUCHIT213)	+= touchit213.o
  obj-$(CONFIG_TOUCHSCREEN_TOUCHRIGHT)	+= touchright.o
  obj-$(CONFIG_TOUCHSCREEN_TOUCHWIN)	+= touchwin.o
@@ -44,3 +42,4 @@ obj-$(CONFIG_TOUCHSCREEN_WM97XX_ATMEL)	+= atmel-wm97xx.o
  obj-$(CONFIG_TOUCHSCREEN_WM97XX_MAINSTONE)	+= mainstone-wm97xx.o
  obj-$(CONFIG_TOUCHSCREEN_WM97XX_ZYLONITE)	+= zylonite-wm97xx.o
  obj-$(CONFIG_TOUCHSCREEN_W90X900)	+= w90p910_ts.o
+obj-$(CONFIG_TOUCHSCREEN_PCAP)		+= pcap_ts.o
diff --git a/drivers/input/touchscreen/rmi.h 
b/drivers/input/touchscreen/rmi.h
new file mode 100755
index 0000000..6caa66f
--- /dev/null
+++ b/drivers/input/touchscreen/rmi.h
@@ -0,0 +1,286 @@
+/**
+ * \file
+ * Synaptics Register Mapped Interface (RMI4) Header File.
+ * Copyright (c) 2007-2009 Synaptics Incorporated
+ *
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ 
*#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ 
*#############################################################################
+ */
+
+/** RMI4 Protocol Support
+ */
+
+/** For each function present on the RMI device, we need to get the 
RMI4 Function
+ *  Descriptor info from the Page Descriptor Table. This will give us the
+ *  addresses for Query, Command, Control, Data and the Source Count 
(number
+ *  of sources for this function) and the function id.
+ */
+struct rmi_function_descriptor {
+  unsigned char queryBaseAddr;
+  unsigned char commandBaseAddr;
+  unsigned char controlBaseAddr;
+  unsigned char dataBaseAddr;
+  unsigned char interruptSrcCnt;
+  unsigned char functionNum;
+};
+
+/** For each function present on the RMI device, there will be a 
corresponding
+ * entry in the functions list of the rmi_module_info structure.  This 
entry
+ * gives information about the number of data sources and the number of 
data
+ * registers associated with the function.
+ * \see rmi_module_info
+ */
+struct rmi_function_info {
+  unsigned char functionNum;
+
+  /** This is the number of data sources associated with the function.
+   * \note This is not the total number of data registers associated with
+   * this function!
+   * \see data_regs
+   */
+  unsigned char numSources;
+
+  /** This is the number of data points supported - for example, for
+   *  function $11 (2D sensor) the number of data points is equal to 
the number
+   *  of fingers - for function $19 (buttons)it is the number of buttons.
+   */
+  unsigned char numDataPoints;
+
+  /** This is the number of data registers to read.
+   */
+  unsigned char dataRegBlockSize;
+
+  /** This is the interrupt register and mask - needed for enabling the 
interrupts
+   *  and for checking what source had caused the attention line interrupt.
+   */
+  unsigned char interruptRegister;
+  unsigned char interruptMask;
+
+  /** This is the RMI function descriptor associated with this function.
+   *  It contains the Base addresses for the functions query, command,
+   *  control, and data registers.
+   */
+  struct rmi_function_descriptor funcDescriptor;
+
+  /** Standard kernel linked list implementation.
+   * Documentation on how to use it can be found at
+   * http://isis.poly.edu/kulesh/stuff/src/klist/.
+   */
+  struct list_head link;
+};
+
+/* This struct is for creating a list of RMI4 functions that have data 
sources
+   associated with them. This is to facilitate adding new support for other
+   data sources besides 2D sensors.
+
+   To add a new data source support, the developer will create a new file
+   and add these 4 functions below with FN$## in front of the names - where
+   ## is the hex number for the function taken from the RMI4 specification.
+
+   The function number will be associated with this and later will be 
used to
+   match the RMI4 function to the 4 functions for that RMI4 function 
number.
+
+   The user will also have to add code that adds the new rmi_functions item
+   to the global list of RMI4 functions and stores the pointers to the 
4 functions
+   in the function pointers.
+*/
+struct rmi_functions {
+  unsigned char functionNum;
+
+  struct input_dev *input;
+
+  /* ptrs to function specific functions for report, config, init and 
detect. */
+  /* These ptrs. need to be filled in for every RMI4 function that has data
+     source(s) associated with it - like fn $11 (2D sensors), fn $19 
(buttons),
+     etc. Each RMI4 function that has data sources will be added into a 
list
+     that is used to match the function number against the number 
stored here.
+  */
+  int  (*report)(struct rmi_application *app, struct rmi_function_info 
*rfi, struct input_dev *input);
+  void (*config)(struct rmi_application *app, struct rmi_function_info 
*rfi);
+  void (*init)(struct input_dev *input);
+  void (*detect)(struct rmi_application *app, struct rmi_function_info 
*rfi, struct rmi_function_descriptor *fd, unsigned int interruptCount);
+
+  /** Standard kernel linked list implementation.
+   * Documentation on how to use it can be found at
+   * http://isis.poly.edu/kulesh/stuff/src/klist/.
+   */
+  struct list_head link;
+};
+
+
+/* Each time a new RMI4 function support is added the developer needs 
to bump the number of
+   supported data src functions and add the info for that RMI4 function 
to the array along
+   with pointers to the report, config, init and detect functions that 
they coded in rmi_function_xx.c
+   and rmi_function_xx.h - where xx is the RMI4 function number for the 
new RMI4 data source function.
+   The information for the RMI4 functions is obtained from the RMI4 
specification document.
+*/
+#define rmi4_num_supported_data_src_fns 1
+
+/* add hdr files for all prototypes for RMI4 data source functions 
being supported */
+#include "rmi_function_11.h"
+/* #include "rmi_function_19.h" */
+
+typedef int(*reportFuncPtr)(struct rmi_application *, struct 
rmi_function_info *, struct input_dev *);
+typedef void(*configFuncPtr)(struct rmi_application *app, struct 
rmi_function_info *rfi);
+typedef void(*initFuncPtr)(struct input_dev *);
+typedef void(*detectFuncPtr)(struct rmi_application *, struct 
rmi_function_info *, struct rmi_function_descriptor *, unsigned int);
+
+struct rmi_functions_data {
+  int functionNumber;
+  reportFuncPtr reportFn;
+  configFuncPtr configFn;
+  initFuncPtr initFn;
+  detectFuncPtr detectFn;
+};
+/* NOTE:
+   Developer - add in any new RMI4 fn data info - function number and 
ptrs to report, config, init and detect functions.
+   This data is used to point to the functions that need to be called 
to config, init, detect and report data for the
+   new RMI4 function. These only need to be added for RMI4 functions 
that support data source - like 2D sensors, buttons,
+   LEDs, GPIOs, etc. Refer to the RMI4 specification for information on 
these RMI4 functions and what data they report.
+*/
+
+struct rmi_functions_data 
rmi4_supported_data_src_functions[rmi4_num_supported_data_src_fns] =
+{
+  /* Fn $11 */
+  {0x11, FN_11_report, FN_11_config, FN_11_init, FN_11_detect},
+  /* Fn $19 */
+  /* {0x19, FN_19_report, FN_19_config, FN_19_init, FN_19_detect), */
+
+};
+
+
+/** This encapsulates the information found using the RMI4 Function $01
+ *  query registers. There is only one Function $01 per device.
+ *
+ *  Assuming appropriate endian-ness, you can populate most of this
+ *  structure by reading query registers starting at the query base address
+ *  that was obtained from RMI4 function 0x01 function descriptor info read
+ *  from the Page Descriptor Table.
+ *
+ *  Specific register information is provided in the comments for each 
field.
+ *  For further reference, please see the <i>Synaptics RMI4 Interfacing
+ *  Guide</i> document.
+ */
+struct rmi_module_info {
+  /** The Protocol Major Version number.
+   */
+  unsigned rmi_maj_ver;
+
+  /** The Protocol Minor Version number.
+   */
+  unsigned rmi_min_ver;
+
+  /** The manufacturer identification byte.
+   */
+  unsigned char mfgid;
+
+  /** The Product Properties information.
+   */
+  unsigned char properties;
+
+  /** The product info bytes.
+   * You can build a product info string using the following printf
+   * format and args:
+   * \code printf("%i %02i", productInfo[0], productInfo[1]); \endcode
+   */
+  unsigned char prod_info[2];
+
+   /** Date Code - Year, Month, Day.
+    */
+  unsigned char date_code[3];
+
+  /** Tester ID (14 bits).
+   */
+  unsigned short tester_id;
+
+  /** Serial Number (14 bits).
+   */
+  unsigned short serial_num;
+
+  /** A null-terminated string that identifies this particular product.
+   */
+  char prod_id[10];
+
+  /** A list of the function presence queries.
+   * This list uses the standard kernel linked list implementation.
+   * Documentation on on how to use it can be found at
+   * http://isis.poly.edu/kulesh/stuff/src/klist/.
+   * \see rmi_function_info
+   */
+  struct list_head functions;
+};
+
+struct rmi_phys_driver {
+  char *name;
+  int  (*write)(struct rmi_phys_driver *pd, unsigned short address, 
char data);
+  int  (*read)(struct rmi_phys_driver *pd, unsigned short address, char 
*buffer);
+  int  (*write_multiple)(struct rmi_phys_driver *pd, unsigned short 
address, char *buffer, int length);
+  int  (*read_multiple)(struct rmi_phys_driver *pd, unsigned short 
address, char *buffer, int length);
+  void (*attention)(struct rmi_phys_driver *pd, int instance);
+  int  (*get_attention)(struct rmi_phys_driver *pd);
+  int  polling_required;
+  /* Private elements of the structure */
+  /** Standard kernel linked list implementation.
+   * Documentation on how to use it can be found at
+   * http://isis.poly.edu/kulesh/stuff/src/klist/.
+   */
+  struct list_head drivers;
+  struct rmi_application *app;
+  struct rmi_module_info rmi;
+  struct module *module;
+};
+
+int rmi_read(struct rmi_application *app, unsigned short address, char 
*dest);
+int rmi_write(struct rmi_application *app, unsigned short address, 
unsigned char data);
+int rmi_read_multiple(struct rmi_application *app, unsigned short 
address, char *dest, int length);
+int rmi_write_multiple(struct rmi_application *app, unsigned short 
address, unsigned char *data, int length);
+int rmi_register_phys_driver(struct rmi_phys_driver *rpd);
+int rmi_unregister_phys_driver(struct rmi_phys_driver *rpd);
+
+struct rmi_application *rmi_register_application(const char *name,
+  void (*attention)(struct rmi_phys_driver *pd, int instance),
+  int (*probe)(struct rmi_application *app, const struct 
rmi_module_info *rmi),
+  void (*config)(struct rmi_application *app));
+
+void rmi_unregister_application(struct rmi_application *app);
+int  rmi_polling_required(struct rmi_application *app);
+int  rmi_get_attn(struct rmi_application *app);
+
+/** Set this to 1 to turn on code used in detecting buffer leaks. */
+#define RMI_ALLOC_STATS 1
+
+#if RMI_ALLOC_STATS
+extern int appallocsrmi;
+extern int rfiallocsrmi;
+extern int fnallocsrmi;
+
+#   define INC_ALLOC_STAT(X)   X##allocsrmi++
+#   define DEC_ALLOC_STAT(X)   \
+	do { if(X##allocsrmi) X##allocsrmi--; \
+	     else printk("Too many " #X " frees\n"); } while(0)
+#   define CHECK_ALLOC_STAT(X) \
+	do { if(X##allocsrmi) printk("Left over " #X " buffers: %d\n", \
+		X##allocsrmi); } while(0)
+#else
+#   define INC_ALLOC_STAT(X)   do { } while(0)
+#   define DEC_ALLOC_STAT(X)   do { } while(0)
+#   define CHECK_ALLOC_STAT(X) do { } while(0)
+#endif
+
+/* vim600: set noexpandtab sw=8 ts=8 :*/
diff --git a/drivers/input/touchscreen/rmi.mod.c 
b/drivers/input/touchscreen/rmi.mod.c
new file mode 100755
index 0000000..e11b023
--- /dev/null
+++ b/drivers/input/touchscreen/rmi.mod.c
@@ -0,0 +1,20 @@
+#include <linux/module.h>
+#include <linux/vermagic.h>
+#include <linux/compiler.h>
+
+MODULE_INFO(vermagic, VERMAGIC_STRING);
+
+struct module __this_module
+__attribute__((section(".gnu.linkonce.this_module"))) = {
+ .name = KBUILD_MODNAME,
+ .init = init_module,
+#ifdef CONFIG_MODULE_UNLOAD
+ .exit = cleanup_module,
+#endif
+};
+
+static const char __module_depends[]
+__attribute_used__
+__attribute__((section(".modinfo"))) =
+"depends=";
+
diff --git a/drivers/input/touchscreen/rmi_app_touchpad.c 
b/drivers/input/touchscreen/rmi_app_touchpad.c
new file mode 100755
index 0000000..bc4d17f
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_app_touchpad.c
@@ -0,0 +1,458 @@
+/**
+ * \file
+ * Synaptics Register Mapped Interface (RMI4) TouchPad Application 
Layer Driver.
+ * Copyright (c) 2007-2009 Synaptics Incorporated
+ *
+ *
+ * This code implements a polling mechanism with backoff as well as
+ * interrupt-driven sampling.  For polling, the module has two parameters:
+ * polljif (Poll Jiffies) and hspolljif (High Speed Poll Jiffies).  The 
driver
+ * polls at polljif until it sees a press, and then it polls at hspolljif.
+ * When there is no longer a touch, it reverts to the polljif period.
+ *
+ * The polljif parameter can be changed during run time like this:\code
+ *   echo 100 > /sys/module/rmi_app_touchpad/parameters/polljif
+ * \endcode
+ *
+ * That will change the pollrate to 1 per second (assuming HZ == 100).  The
+ * same is true for hspolljif.
+ *
+ * The parameters have no effect for the interrupt-driven case.
+ *
+ * Note that it is the lower-level drivers that determine whether this 
driver
+ * has to do polling or interrupt-driven.  Polling can always be done, 
but if
+ * we have an interrupt connected to the attention (ATTN) line, then it is
+ * better to be interrupt driven.
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ 
*#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ 
*#############################################################################
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+
+#include "rmi_core.h"
+#include "rmi.h"
+
+#if RMI_ALLOC_STATS
+  static int pollallocsrmi = 0;
+#endif
+
+#define RMI_REPORT_RATE_40 (1 << 6)
+
+/** The number of jiffies between polls without touches */
+static int polljif = HZ/20;
+/** The number of jiffies between polls with touches */
+static int hspolljif = HZ/40;
+module_param(polljif, int, 0644);
+module_param(hspolljif, int, 0644);
+MODULE_PARM_DESC(polljif,   "How many jiffies between low speed polls.");
+MODULE_PARM_DESC(hspolljif, "How many jiffies between high speed polls.");
+
+static struct rmi_application *app = NULL;
+static struct completion touch_completion;
+static struct completion thread_comp;
+struct task_struct *kthread = NULL;
+static int time_to_quit = 0;
+static struct input_dev *input = NULL;
+
+extern unsigned short fn01ControlBaseAddr;    /* RMI4 device control == 
function 0x01 */
+extern unsigned int interruptRegisterCount;   /* number of total 
interrupt registers to read */
+
+extern LIST_HEAD(fns_list);
+
+/**
+ * This is the function we pass to the RMI4 subsystem so we can be notified
+ * when attention is required.  It may be called in interrupt context.
+ */
+static void attention(struct rmi_phys_driver *rpd, int instance)
+{
+  /* All we have to do is wake up the kernel sampling thread. */
+  complete(&touch_completion);
+}
+
+/**
+ * This is the meat of the driver.  It reads in all data sources and 
reports them to
+ * the input subsystem.  It is used for both polling and interrupt 
driven operation.
+ */
+int report_sensor_data(struct rmi_application *app)
+{
+  unsigned char interruptStatus[4] = {0,0,0,0};
+  int touch = 0; /* number of touch points - fingers or buttons */
+
+  /* Get the interrupt status from the function $01 control register+1 
to find
+     which source(s) were interrupting so we can read the data from the
+     source(s) (2D sensor, buttons, etc.). */
+  if(rmi_read_multiple(app, fn01ControlBaseAddr + 1, interruptStatus, 
interruptRegisterCount)) {
+    printk(KERN_ERR "Could not read interrupt status registers 0x%x\n", 
fn01ControlBaseAddr + 1);
+    return 0;
+  }
+
+  /* check each function that has data sources and if the interrupt for 
that triggered
+     then call that RMI4 functions report() function to gather data and 
report it to the input
+     subsystem
+  */
+  struct rmi_functions *fn;
+  struct rmi_function_info *rfi;
+  struct rmi_phys_driver *rpd  = app->rpd; /* get ptr to 
rmi_physical_driver from app */
+  struct rmi_module_info *rmi  = &(rpd->rmi); /* get ptr to 
rmi_module_info from physical driver */
+
+  list_for_each_entry(rfi, &rmi->functions, link) {
+    if (rfi->numSources) {
+      if (interruptStatus[rfi->interruptRegister] & rfi->interruptMask) {
+        bool found = false;
+        list_for_each_entry(fn, &fns_list, link) {
+          if (rfi->functionNum == fn->functionNum) {
+            found = true;
+            if (fn->report) {
+              touch = fn->report(app, rfi, fn->input);
+            } else {
+              /* the developer did not add in the pointer to the report 
function into rmi4_supported_data_src_functions */
+              printk(KERN_ERR "rmi_app_touchpad.report_sensor_data: no 
find report function for function 0x%x\n", fn->functionNum);
+              break;
+            }
+          }
+        }
+
+        if (!found) {
+          /* if no support found for this RMI4 function it means the 
developer did not add the appropriate function
+             pointer list into the rmi4_supported_data_src_functions 
array and/or did not bump up the number of
+             supported RMI4 functions in rmi.h as required */
+          printk(KERN_ERR "rmi_app_touchpad.report_sensor_data: could 
not any support for function 0x%x\n", fn->functionNum);
+        }
+      }
+    }
+  }
+
+  /* return the number of touch points - fingers down and/or buttons 
pressed, etc. */
+  return touch;
+}
+
+
+/**
+ * This is a kernel thread that processes packets when we receive them. 
  It is
+ * only used for the interrupt-driven case.  Polling may also be done 
in this
+ * driver and doesn't use this thread (although I suppose it could be 
modified
+ * to do polling, too, instead of using timers).
+ */
+int rmitouchd(void *param)
+{
+  struct rmi_application *app = (struct rmi_application *)param;
+
+  daemonize("rmitouchd");
+	
+  while (!kthread_should_stop()) {
+    if(time_to_quit) break;
+		
+    /* wait for interrupt from ATTN line */
+    wait_for_completion_interruptible(&touch_completion);
+		
+    if (time_to_quit) break;
+	
+    try_to_freeze();
+		
+    do {
+      report_sensor_data(app);
+      if(time_to_quit) break;  /* check if time to quit so we don't 
loop when we are in mod_exit(). */
+	  } while(rmi_get_attn(app));
+  }
+	
+  complete_and_exit(&thread_comp, 0);
+}
+
+/* Head of the list to keep track of who is polling.  This is so we can
+ * properly shut down the timers on exit. */
+static struct list_head pollers;
+
+/* Simple structure to keep track of things */
+struct poll_instance {
+  struct delayed_work dw;
+  struct rmi_application *app;
+  struct list_head link;
+};
+
+/* The main routine for the polling case. */
+static void poll_work_callback(struct work_struct *data)
+{
+  struct delayed_work *dw = container_of(data, struct delayed_work, work);
+  struct poll_instance *pi = container_of(dw, struct poll_instance, dw);
+  static int calls_with_no_data = 0;
+  int touch = 0;
+
+  if(time_to_quit) return;
+
+  touch = report_sensor_data(pi->app);
+
+  /* This code implements a backoff.  If we have a call with data being
+   * received, we decrease the time between polls to hspolljif.  If
+   * there are several calls at that faster rate that do not have data,
+   * we go back to slower polling.
+   */
+  if(touch) calls_with_no_data = 0;
+  if(!time_to_quit) {	/* Don't schedule if it's time to quit. */
+    if(calls_with_no_data > 5) {
+      schedule_delayed_work(dw, polljif);
+    } else {
+      if(!touch) calls_with_no_data++;
+      schedule_delayed_work(dw, hspolljif);
+    }
+  }
+}
+
+/**
+ * This is the probe function passed to the RMI4 subsystem that gives us a
+ * chance to recognize an RMI4 device.  In this case, we're looking for
+ * Synaptics devices that have data sources - such as touch screens, 
buttons, etc.
+ */
+static int probe(struct rmi_application *app, const struct 
rmi_module_info *rmi)
+{
+  struct rmi_function_info *rfi;
+  int data_sources = 0;
+  int retval = 0;
+
+  if(!rmi) {
+    printk(KERN_ERR "rmi_app_touchpad.probe: "
+      "Invalid module info: %p\n", rmi);
+    return 0;
+  }
+
+  /* Make sure this is a Synaptics device */
+  if(rmi->mfgid != 1) { /* Synaptics */
+    printk(KERN_ERR "rmi_app_touchpad.probe: "
+      "Invalid mfg id: %p\n", rmi->mfgid);
+    return 0;
+  }
+
+  /* for each function entry in the list accumulate it's number of data 
sources */
+  list_for_each_entry(rfi, &rmi->functions, link) {
+      data_sources += rfi->numSources;
+  }
+
+  if (data_sources) {
+    retval = 1;
+    /* We have detected one or more data sources such as a 2D Sensors, 
buttons, etc. */
+    printk(KERN_ERR "rmi_app_touchpad.probe: "
+      "Found %d data sources for : %p\n",data_sources, rmi);
+  } else {
+    /* we don't have any data sources for this sensor - oops! - either 
an un-flashed sensor or bad!! */
+    printk(KERN_ERR "rmi_app_touchpad.probe: "
+      "No data sources found for : %p\n", rmi);
+  }
+
+  return retval;
+}
+
+static void config(struct rmi_application *app)
+{
+  /* For each data source we had detected print info and set up 
interrupts or polling. */
+  unsigned char data[14];
+  struct rmi_function_info *rfi;
+  struct rmi_phys_driver *rpd;;
+  struct rmi_module_info *rmi; /* module info has list of functions */
+
+  rpd = app->rpd; /* get ptr to rmi_physical_driver from app */
+  rmi = &(rpd->rmi); /* get ptr to rmi_module_info from physical driver */
+
+  list_for_each_entry(rfi, &rmi->functions, link) {
+    if(rfi->numSources) /* if this function has data sources associated 
with it...*/
+    {
+      /* Get and print some info about the data sources... */ 

+      struct rmi_functions *fn;
+      bool found = false;
+
+      list_for_each_entry(fn, &fns_list, link) {
+        /* check if function number matches - if so call that config 
function */
+        if(fn->functionNum == rfi->functionNum) {
+          found = true;
+          if (fn->config) {
+            fn->config(app, rfi);
+          } else {
+            /* the developer did not add in the pointer to the config 
function into rmi4_supported_data_src_functions */
+            printk(KERN_ERR "rmi_app_touchpad.config - no config 
function for function 0x%x\n", rfi->functionNum);
+            break;
+          }
+        }
+      }
+
+      if (!found) {
+        /* if no support found for this RMI4 function it means the 
developer did not add the appropriate function
+           pointer list into the rmi4_supported_data_src_functions 
array and/or did not bump up the number of
+           supported RMI4 functions in rmi.h as required */
+        printk(KERN_ERR "rmi_app_touchpad.config - could not find 
support for function 0x%x\n", rfi->functionNum);
+      }
+
+      /* if we are not doing polling then enable the interrupts for the 
data sources for this function */
+      if (!rmi_polling_required(app)) {
+        /* Turn on interrupts for this functions data sources. */
+        rmi_write(app, fn01ControlBaseAddr + 1 + 
rfi->interruptRegister, rfi->interruptMask);
+        printk(KERN_INFO "rmi_app_touchpad.config -  Interrupt Driven - 
turning on interrupts for function 0x%x\n", rfi->functionNum);
+      }
+    }
+  }
+
+  /* if we are not polling we need to set up the interrupt thread - 
otherwise we need to
+     set up the polling callback and worker thread. */
+  if(!rmi_polling_required(app)) {
+    /* We're interrupt driven, so turn on the thread. */
+    kthread = kthread_run(&rmitouchd, app, "rmitouchd");
+
+    if(HZ < 500) {
+      /* The default polling frequency of 80 times per
+       * second is too fast (the Linux time slice for
+       * sub-GHz processors is only 100 times per second).
+       * So program it to 40.
+       */
+      rmi_write(app, fn01ControlBaseAddr, RMI_REPORT_RATE_40);
+    }
+  } else {
+    /* We're polling driven, so set up the polling callback and worker 
thread */
+    struct poll_instance *pi;
+    pi = kmalloc(sizeof(*pi), GFP_KERNEL);
+
+    if(!pi) {
+      printk(KERN_ERR "rmi_app_touchpad.config: "
+        "Out of memory claiming %s\n",
+        rmi->prod_id);
+      continue;
+    }
+
+    INC_ALLOC_STAT(poll);
+    INIT_DELAYED_WORK(&pi->dw, poll_work_callback);
+
+    pi->app     = app;
+    list_add_tail(&pi->link, &pollers);
+    schedule_delayed_work(&pi->dw, polljif);
+  }
+}
+
+/**
+ * The module initialization function in which we register as a RMI4
+ * application driver.  We also register with the input subsystem so we can
+ * pass coordinates to it.
+ */
+static int __init mod_init(void)
+{
+  printk(KERN_INFO "rmi_app_touchpad.mod_init: RMI4 TouchPad Driver\n");
+
+  INIT_LIST_HEAD(&pollers);
+
+  time_to_quit = 0;
+  init_completion(&touch_completion);
+  init_completion(&thread_comp);
+
+  /* NOTE: we are creating only one input dev file for this but 
theoretically
+     you could create a separate one for each data source and store it 
below.
+     This will let you put 2D sensor events into one dev file, button 
events into
+     a separate dev file, other data source event like GPIOs, etc. into 
yet a
+     third dev file. As this is being coded it will dump all events 
into the
+     one dev file.
+   */
+  input = input_allocate_device();
+  if (input == NULL) {
+    printk(KERN_ERR "rmi_app_touchpad.mod_init:  Failed to allocate 
memory for a new input device.\n");
+    return -ENOMEM;
+  }
+
+  input->name = "RMI4 Touchpad";
+  input->phys = "rmi_app_touchpad";
+
+  /* Set input device specific params for each data source...*/ 

+  struct rmi_functions *fn;
+  list_for_each_entry(fn, &fns_list, link) {
+    if (fn->init) {
+      fn->input = input; /* store the input_dev ptr for use later */
+      fn->init(fn->input);
+    } else {
+      /* the developer did not add in the pointer to the init function 
into rmi4_supported_data_src_functions */
+      printk(KERN_ERR "rmi_app_touchpad.mod_init: no init function for 
function 0x%x\n", fn->functionNum);
+    }
+  }
+
+  input_register_device(input);
+
+  app = rmi_register_application("rmi4_touchpad", attention, probe, 
config);
+
+  if(!app) {
+    printk(KERN_ERR "rmi_app_touchpad.mod_init:  Failed to register 
app.\n");
+    input_unregister_device(input);
+    return -ENODEV;
+  }
+
+  return 0;
+}
+
+/**
+ * The module exit function.
+ */
+static void __exit mod_exit(void)
+{
+  struct poll_instance *pi, *pi_tmp;
+
+  printk(KERN_INFO "rmi_app_touchpad.mod_exit: RMI4 TouchPad Driver\n");
+
+  time_to_quit = 1;
+
+  complete(&touch_completion); /* Kick the thread awake */
+  list_for_each_entry(pi, &pollers, link) {
+    cancel_delayed_work(&pi->dw);	/* Cancel any pending polls */
+  }
+  flush_scheduled_work();	/* Make sure all pollers are stopped */
+  if(kthread) wait_for_completion(&thread_comp);
+
+  /* Unregister everything */
+  printk(KERN_WARNING "rmi_app_touchpad.mod_exit: Unregistering app - 
%s\n", app->name);
+  rmi_unregister_application(app);
+  input_unregister_device(input);
+
+  /* Free up the structures */
+  list_for_each_entry_safe(pi, pi_tmp, &pollers, link) {
+    list_del(&pi->link);
+    kfree(pi);
+    DEC_ALLOC_STAT(poll);
+  }
+
+  CHECK_ALLOC_STAT(poll);
+}
+
+/** Standard driver module information - the author of the module.
+ */
+MODULE_AUTHOR("Synaptics, Inc.");
+/** Standard driver module information - a summary description of this 
module.
+ */
+MODULE_DESCRIPTION("RMI4 Driver");
+/** Standard driver module information - the license under which this 
module
+ * is included in the kernel.
+ */
+MODULE_LICENSE("GPL");
+
+/** Specifies to the kernel that the mod_init() function should be 
called when
+ * the module is loaded.
+ * \see mod_init()
+ */
+module_init(mod_init);
+/** Specifies to the kernel that the mod_exit() function should be 
called when
+ * the module is unloaded.
+ * \see mod_exit()
+ */
+module_exit(mod_exit);
+
+/* vim600: set noexpandtab sw=8 ts=8 :*/
diff --git a/drivers/input/touchscreen/rmi_app_touchpad.mod.c 
b/drivers/input/touchscreen/rmi_app_touchpad.mod.c
new file mode 100755
index 0000000..22ed454
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_app_touchpad.mod.c
@@ -0,0 +1,20 @@
+#include <linux/module.h>
+#include <linux/vermagic.h>
+#include <linux/compiler.h>
+
+MODULE_INFO(vermagic, VERMAGIC_STRING);
+
+struct module __this_module
+__attribute__((section(".gnu.linkonce.this_module"))) = {
+ .name = KBUILD_MODNAME,
+ .init = init_module,
+#ifdef CONFIG_MODULE_UNLOAD
+ .exit = cleanup_module,
+#endif
+};
+
+static const char __module_depends[]
+__attribute_used__
+__attribute__((section(".modinfo"))) =
+"depends=rmi";
+
diff --git a/drivers/input/touchscreen/rmi_core.c 
b/drivers/input/touchscreen/rmi_core.c
new file mode 100755
index 0000000..ed2127e
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_core.c
@@ -0,0 +1,627 @@
+/**
+ * \file
+ * Synaptics Register Mapped Interface (RMI4) Data Layer Driver.
+ * Copyright (C) 2007 - 2009, Synaptics Incorporated
+ *
+ *
+ * This protocol is layered as follows.
+ *
+ * <pre>
+ *  +----------------------------------------+
+ *  |                                        |
+ *  |              Application               |
+ *  |                                        |
+ *  +----------------------------------------+
+ *  |                                        |
+ *  |               RMI4 Driver              | Data Layer (THIS DRIVER)
+ *  |              (this file)               |
+ *  +-----+-----+-------+----------+---------+
+ *  | I2C | SPI | SMBus |        etc.        | Physical Layer
+ *  +-----+-----+-------+----------+---------+
+ *</pre>
+ *  Each of the physical layer drivers is contained in a file called
+ *  rmi_phys_xxx.c.  Someone compiling the kernel enables CONFIG_RMI 
and then
+ *  one or more CONFIG_RMI_xxx options in the .config file.  For 
example, when
+ *  CONFIG_RMI_I2C=m is enabled, a rmi.ko and a rmi_phys_i2c.ko will be
+ *  compiled.  rmi_phys_i2c.ko will depend on rmi.ko, so when 
rmi_phys_i2c.ko
+ *  is loaded, rmi.ko will automatically be loaded.  Each of the physical
+ *  layer drivers is a platform_driver that may handle suspend/resume, 
etc.,
+ *  so this driver does not do so.
+ *
+ *  The register paradigm of RMI is a "pull" rather than "push" data flow.
+ *  As such, it is the application driver that needs to implement either
+ *  polling or interrupt driven, and the physical driver merely handles
+ *  the register accesses.  For interrupt driven, the application registers
+ *  an "attention" function that may be called in interrupt context by the
+ *  physical driver if an attention interrupt is available.  The physical
+ *  driver notifies the application through the polling_required variable,
+ *  and the application driver must do one or the other based on this 
variable.
+ *
+ *  At this point in time, there can only be one application driver per
+ *  physical driver.
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ 
*#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ 
*#############################################################################
+ */
+
+static const char drvname[] = "rmi4";
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/miscdevice.h>
+#include <linux/fs.h>
+#include <linux/delay.h>
+#include <asm/uaccess.h>
+
+#include "rmi.h"
+#include "rmi_core.h"
+
+
+/* we need these to control and query interrupts */
+unsigned short fn01QueryBaseAddr = 0;     /* RMI4 device control */
+EXPORT_SYMBOL(fn01QueryBaseAddr);
+unsigned short fn01ControlBaseAddr = 0;
+EXPORT_SYMBOL(fn01ControlBaseAddr);
+unsigned int interruptRegisterCount = 0;
+EXPORT_SYMBOL(interruptRegisterCount);
+
+#define PDT_START_SCAN_LOCATION 0x00E9
+#define PDT_END_SCAN_LOCATION 0x000A
+#define PDT_ENTRY_SIZE 0x0006
+
+static LIST_HEAD(phys_drivers);
+static DEFINE_MUTEX(phys_drivers_mutex);
+static LIST_HEAD(app_drivers);
+static DEFINE_MUTEX(app_drivers_mutex);
+static LIST_HEAD(fns_list);
+EXPORT_SYMBOL(fns_list);
+static DEFINE_MUTEX(fns_mutex);
+EXPORT_SYMBOL(fns_mutex);
+static DEFINE_MUTEX(rfi_mutex);
+EXPORT_SYMBOL(rfi_mutex);
+
+
+#if RMI_ALLOC_STATS
+  int appallocsrmi = 0;
+  EXPORT_SYMBOL(appallocsrmi);
+  int rfiallocsrmi = 0;
+  EXPORT_SYMBOL(rfiallocsrmi);
+  int fnallocsrmi = 0;
+  EXPORT_SYMBOL(fnallocsrmi);
+#endif
+
+int rmi_read(struct rmi_application *app, unsigned short address, char 
*dest)
+{
+  struct rmi_phys_driver *rpd = app->rpd;
+  if(!app->rpd) return -ENODEV;
+  return rpd->read(rpd, address, dest);
+}
+EXPORT_SYMBOL(rmi_read);
+
+int rmi_write(struct rmi_application *app, unsigned short address, 
unsigned char data)
+{
+  struct rmi_phys_driver *rpd = app->rpd;
+  if(!app->rpd) return -ENODEV;
+  return rpd->write(rpd, address, data);
+}
+EXPORT_SYMBOL(rmi_write);
+
+int rmi_read_multiple(struct rmi_application *app, unsigned short 
address, char *dest, int length)
+{
+  struct rmi_phys_driver *rpd = app->rpd;
+  if(!app->rpd) return -ENODEV;
+  return rpd->read_multiple(rpd, address, dest, length);
+}
+EXPORT_SYMBOL(rmi_read_multiple);
+
+int rmi_write_multiple(struct rmi_application *app, unsigned short 
address, unsigned char *data, int length)
+{
+  struct rmi_phys_driver *rpd = app->rpd;
+  if(!app->rpd) return -ENODEV;
+  return rpd->write_multiple(rpd, address, data, length);
+}
+EXPORT_SYMBOL(rmi_write_multiple);
+
+int rmi_polling_required(struct rmi_application *app)
+{
+  return app->polling_required;
+}
+EXPORT_SYMBOL(rmi_polling_required);
+
+int rmi_get_attn(struct rmi_application *app)
+{
+  if(!app->rpd) return -ENODEV;
+  return app->rpd->get_attention(app->rpd);
+}
+EXPORT_SYMBOL(rmi_get_attn);
+
+/*
+   This function searches for a match between an app driver and physical
+   driver and binds them together.
+*/
+static void match_and_bind(struct rmi_application *app, struct 
rmi_phys_driver *rpd)
+{
+  app->polling_required = rpd->polling_required;
+  if(app->probe(app, &rpd->rmi)) {
+    /* Found a match, bind them together. */
+    /** The try_module_get() makes sure that the physical
+     * driver cannot be unloaded while a app driver is
+     * using it.
+     */
+    if(try_module_get(rpd->module)) {
+      app->rpd = rpd;
+      rpd->app = app;
+      printk(KERN_INFO "%s: %s bound to %s\n", drvname, app->name, 
rpd->name);
+      rpd->attention = app->attention;
+      app->config(app);
+    }
+  } else {
+    app->polling_required = 0;
+  }
+}
+
+int rmi_register_phys_driver(struct rmi_phys_driver *rpd)
+{
+  struct rmi_application *app;
+  int retval;
+
+  if(!rpd->name) {
+    printk(KERN_ERR "%s: Physical driver must specify a name\n", drvname);
+    return -EINVAL;
+  }
+  if(!rpd->write) {
+    printk(KERN_ERR "%s: Physical driver %s must specify a writer.\n", 
  drvname, rpd->name);
+    return -EINVAL;
+  }
+  if(!rpd->read) {
+    printk(KERN_ERR "%s: Physical driver %s must specify a reader.\n", 
drvname, rpd->name);
+    return -EINVAL;
+  }
+  if(!rpd->write_multiple) {
+    printk(KERN_ERR "%s: Physical driver %s must specify a multiple 
writer.\n",  drvname, rpd->name);
+    return -EINVAL;
+  }
+  if(!rpd->read_multiple) {
+    printk(KERN_ERR "%s: Physical driver %s must specify a multiple 
reader.\n", drvname, rpd->name);
+    return -EINVAL;
+  }
+  if(!rpd->module) {
+    printk(KERN_ERR "%s: Physical driver %s must specify a module.\n", 
  drvname, rpd->name);
+    return -EINVAL;
+  }
+
+  pr_debug("%s: Registering phys driver %s\n", drvname, rpd->name);
+
+  rpd->attention = 0;
+
+  /* Get some information from the device */
+  {
+    int i;
+    unsigned char std_queries[21];
+    unsigned char interruptCount = 0;
+    struct rmi_function_info *rfi = NULL;
+
+
+    printk(KERN_INFO "%s: Functions:\n", drvname);
+
+    struct rmi_function_descriptor rmi_fd;
+
+    /* init the physical drivers RMI module info list of functions */
+    INIT_LIST_HEAD(&rpd->rmi.functions);
+
+    /* Read the Page Descriptor Table to determine what functions are 
present */
+    for(i = PDT_START_SCAN_LOCATION; i > PDT_END_SCAN_LOCATION; i -= 
PDT_ENTRY_SIZE )
+    {
+      if (!(retval = rpd->read_multiple(rpd, i, &rmi_fd, sizeof(rmi_fd))))
+      {
+        rfi = NULL;
+
+        if(rmi_fd.functionNum)
+        {
+          switch(rmi_fd.functionNum & 0xff)
+          {
+            case 0x01:
+              printk(KERN_INFO "%s:   Fn $01 Found - RMI Device 
Control\n", drvname);
+              /* Save Fn $01 query and control base addresses since
+                 we'll need them later to get/set properties and check 
interrupts.
+                 There is only one Fn $01 for the device that is used 
to control
+                 and query device specific info so we only need to save 
it globally here
+                 for later use. */
+              fn01QueryBaseAddr = rmi_fd.queryBaseAddr;
+              fn01ControlBaseAddr = rmi_fd.controlBaseAddr;
+              break;
+
+            default:
+              if (rmi_fd.interruptSrcCnt) {
+                rfi = kmalloc(sizeof(*rfi), GFP_KERNEL);
+
+                if(!rfi) {
+                  printk(KERN_ERR "%s: could not allocate memory for 
function 0x%x\n",
+			              drvname, rmi_fd.functionNum);
+                  retval = -ENOMEM;
+                  goto exit_fail;
+                } else {
+                  INC_ALLOC_STAT(rfi);
+
+                  /* Get the ptr to the detect function based on the 
function number */
+                  struct rmi_functions *fn;
+                  bool found = false;
+
+                  list_for_each_entry(fn, &fns_list, link) {
+                    /* check if function number matches - if so call 
that detect function */
+                    if(fn->functionNum == rmi_fd.functionNum) {
+                      found = true;
+                      fn->detect(rpd, rfi, &rmi_fd, interruptCount);
+                    }
+                  }
+
+                  if (!found) {
+                    printk(KERN_ERR "%s: could not find support for 
function 0x%x\n",
+			                drvname, rmi_fd.functionNum);
+                  }
+                }
+              } else {
+                printk(KERN_INFO "%s:   Found Function %02x - 
Ignored.\n", drvname, rmi_fd.functionNum & 0xff);
+              }
+              break;
+          }
+
+          /* bump interrupt count for next iteration */
+          interruptCount += (rmi_fd.interruptSrcCnt & 0x7);
+
+          /* We only want to add functions to the list that have data 
associated with them. */
+          if (rfi && rmi_fd.interruptSrcCnt)
+          {
+            printk(KERN_INFO "%s: Adding function 0x%x with %d sources. 
\n", drvname, rfi->functionNum, rfi->numSources);
+
+            /* link this function info to the RMI module infos list of 
functions */
+            mutex_lock(&rfi_mutex);
+            list_add_tail(&rfi->link, &rpd->rmi.functions);
+            mutex_lock(&rfi_mutex);
+          }
+        } else {
+          /* A zero in the function number signals the end of the PDT */
+          printk(KERN_INFO "%s:   Found End of PDT\n", drvname);
+          break;
+        }
+      } else {
+        /* failed to read next PDT entry - end PDT scan - this may 
result in an incomplete
+           set of recognized functions - should probably return an 
error but the driver
+           may still be viable for diagnostics and debugging so let's 
let it continue. */
+        printk(KERN_ERR "%s:   Read Error 0x%x when reading next PDT 
entry - ending PDT scan.\n", drvname, retval);
+        break;
+      }
+    }
+
+    /* calculate the interrupt register count - used in the ISR to read 
the correct number of interrupt registers */
+    interruptRegisterCount = (interruptCount + 7) / 8;
+
+    /* Function $01 will be used to query the product properties, and 
product ID
+     * so we had to read the PDT above first to get the Fn $01 query 
address and
+     * prior to filling in the product info. NOTE: Even an unflashed
+     * device will still have FN $01.
+     */
+
+    /* Load up the standard queries and get the RMI4 module info */
+    if((retval = rpd->read_multiple(rpd, fn01QueryBaseAddr, 
std_queries, sizeof(std_queries)))) {
+      printk(KERN_ERR "%s: Fail reading queries\n", drvname);
+      retval = -EIO;
+      goto exit_fail;
+    }
+
+    rpd->rmi.rmi_maj_ver  = 4; /* Currently supported RMI version is 4.0 */
+    rpd->rmi.rmi_min_ver  = 0;
+
+    /* get manufacturer id, properties, product info, date code, tester 
id, serial num and product id (name) */
+    rpd->rmi.mfgid        = std_queries[0];
+
+    rpd->rmi.properties   = std_queries[1];
+	
+    rpd->rmi.prod_info[0] = std_queries[2];
+    rpd->rmi.prod_info[1] = std_queries[3];
+
+    rpd->rmi.date_code[0] = std_queries[4] & 0x1f; /* year - 2001-2032 */
+    rpd->rmi.date_code[1] = std_queries[5] & 0x0f; /* month - 1-12 */
+    rpd->rmi.date_code[2] = std_queries[6] & 0x1f; /* day - 1-31 */
+
+    rpd->rmi.tester_id    = ((std_queries[7] & 0x7f) << 8) | 
(std_queries[8] & 0x7f);
+
+    rpd->rmi.serial_num   = ((std_queries[9] & 0x7f) << 8) | 
(std_queries[10] & 0x7f);
+
+    for (i = 0; i < 10; i++)
+    {
+      rpd->rmi.prod_id[i] = std_queries[11+i];
+    }
+		
+    rpd->rmi.prod_id[10] = 0;
+
+    printk(KERN_INFO "%s: RMI Protocol: %d.%d\n",
+      drvname, rpd->rmi.rmi_maj_ver, rpd->rmi.rmi_min_ver);
+    printk(KERN_INFO "%s: Manufacturer: %d", drvname,
+      rpd->rmi.mfgid);
+	
+    if(rpd->rmi.mfgid == 1) {
+      printk(KERN_INFO " (Synaptics)");
+    }
+    printk(KERN_INFO "\n");
+
+    printk(KERN_INFO "%s: Properties: 0x%x \n", drvname, 
rpd->rmi.properties);
+
+    printk(KERN_INFO "%s: Product Info: 0x%x 0x%x \n", drvname, 
rpd->rmi.prod_info[0], rpd->rmi.prod_info[1]);
+
+    printk(KERN_INFO "%s: Date Code: Year : %d Month: %d Day: %d\n", 
drvname, rpd->rmi.date_code[0],
+      rpd->rmi.date_code[1], rpd->rmi.date_code[2]);
+
+    printk(KERN_INFO "%s: Tester ID: %d \n", drvname, rpd->rmi.tester_id);
+
+    printk(KERN_INFO "%s: Serial Number: 0x%x \n", drvname, 
rpd->rmi.serial_num);
+
+    printk(KERN_INFO "%s: Product ID: %s\n", drvname, rpd->rmi.prod_id);
+  }
+
+  /* Add physical driver struct to list */
+  mutex_lock(&phys_drivers_mutex);
+  list_add_tail(&rpd->drivers, &phys_drivers);
+  mutex_unlock(&phys_drivers_mutex);
+
+  /* Do a probe for any applications that are registered and bind this 
physical driver to them */
+  list_for_each_entry(app, &app_drivers, apps) {
+    /* Only check apps that are not already bound */
+    if(!app->rpd) {
+      match_and_bind(app, rpd);
+    }
+  }
+
+  pr_debug("Registered phys driver %s\n", rpd->name);	
+  return 0;
+
+exit_fail:
+  return retval;
+}
+EXPORT_SYMBOL(rmi_register_phys_driver);
+
+int rmi_unregister_phys_driver(struct rmi_phys_driver *rpd)
+{
+  if(rpd->app) {
+    printk(KERN_WARNING "%s: WARNING: unregister of %s while %s still 
attached\n",
+      drvname, rpd->name, rpd->app->name);
+  }
+	
+  pr_debug("Unregistering phys driver %s\n", rpd->name);
+  mutex_lock(&phys_drivers_mutex);
+  list_del(&rpd->drivers);
+  mutex_unlock(&phys_drivers_mutex);
+	
+  return 0;
+}
+EXPORT_SYMBOL(rmi_unregister_phys_driver);
+
+struct rmi_application * rmi_register_application(const char *name,
+  void (*attention)(struct rmi_phys_driver *pd, int instance),
+  int (*probe)(struct rmi_application *app,
+  const struct rmi_module_info *rmi),
+  void (*config)(struct rmi_application *app))
+{
+  struct rmi_application *app;
+  struct rmi_phys_driver *rpd;
+
+  if(!name) {
+    printk(KERN_ERR "%s: Application driver must specify a name\n", 
drvname);
+    return 0;
+  }
+
+  if(!attention) {
+    printk(KERN_ERR "%s: Application driver %s must specify attention 
notifier.\n",
+      drvname, name);
+    return 0;
+  }
+	
+  if(!probe) {
+    printk(KERN_ERR "%s: Application driver %s must specify a probe 
function.\n",
+      drvname, name);
+    return 0;
+  }
+
+  if(!config) {
+    printk(KERN_ERR "%s: Application driver %s must specify a config 
function.\n",
+      drvname, name);
+    return 0;
+  }
+
+  pr_debug("Registering app driver %s\n", name);
+
+  app = kmalloc(sizeof(*app), GFP_KERNEL);
+  if(!app) {
+    printk(KERN_ERR "%s: Out of memory\n", drvname);
+    return 0;
+  }
+  INC_ALLOC_STAT(app);
+
+  app->name      = name;
+  app->attention = attention;
+  app->probe     = probe;
+  app->config    = config;
+  app->rpd       = 0;
+
+  mutex_lock(&app_drivers_mutex);
+  list_add_tail(&app->apps, &app_drivers);
+  mutex_unlock(&app_drivers_mutex);
+
+  /* Probe for any matches with physical drivers and bind them. */
+  list_for_each_entry(rpd, &phys_drivers, drivers) {
+    if(!rpd->app) {
+      match_and_bind(app, rpd);
+    }
+  }
+
+  pr_debug("Registered app driver %s (%p)\n", name, app);
+
+  return app;
+}
+EXPORT_SYMBOL(rmi_register_application);
+
+void rmi_unregister_application(struct rmi_application *app)
+{
+  struct rmi_application *tmp;
+  int found = 0;
+
+  if(!app) {
+    return;
+  }
+
+  pr_debug("Unregistering app driver %s (%p)\n", app->name, app);
+
+  list_for_each_entry(tmp, &app_drivers, apps) {
+    if(tmp == app) {
+      found = 1;
+      break;
+    }
+  }
+	
+  if(!found) {
+    printk(KERN_ERR "%s: Removing rmi application %s: not found\n",
+      drvname, app->name);
+    return;
+  }
+	
+  if(app->rpd) {
+    /* Release the phys driver so it can be unloaded. */
+    module_put(app->rpd->module);
+    app->rpd->app = 0;
+  }
+	
+  list_del(&app->apps);
+  kfree(app);
+  DEC_ALLOC_STAT(app);
+
+  pr_debug("Unregistered app driver %p\n", app);
+}
+EXPORT_SYMBOL(rmi_unregister_application);
+
+static int __init mod_init(void)
+{
+  printk(KERN_INFO "Register Mapped Interface Data Layer Driver\n");
+
+  /* Initialize global list of RMI4 Functions that have data sources.
+     We need to add all new functions to this list so that we will have 
pointers
+     to their associated functions for init, config, report and detect. 
See rmi.h
+     for more details. The developer will add a new RMI4 function 
number in the
+     array in rmi.h and then add a new file to the build (called 
rmi_function_XX.c
+     where XX is the hex number for the added RMI4 function). The rest 
should be
+     automatic.
+  */
+
+  /* for each function number defined in rmi.h creat a new rmi_function 
struct and
+     initialize the pointers to the servicing functions and then add it 
into the
+     global list for function support.
+  */
+  for (i = 0; i < rmi4_num_supported_data_src_fns; i++) {
+    /* Add new rmi4 function struct to list */
+    struct rmi_functions *fn = kmalloc(sizeof(*fn), GFP_KERNEL);
+    if(!fn) {
+      printk(KERN_ERR "%s mod_init: could not allocate memory for 
rmi_function struct for function 0x%x\n",			
+        drvname, rmi4_supported_data_src_functions[i]);
+      return -ENOMEM;
+    } else {
+
+      INC_ALLOC_STAT(fn);
+
+      struct rmi_functions_data * rmi4_fn = 
&rmi4_suported_data_src_functions[i];
+      fn->functionNum = rmi4_fn->functionNumber;
+      /* Fill in ptrs to functions. The functions are linked in from a 
file
+         called rmi_function_xx.c where xx is the hex number of the 
RMI4 function
+         from the RMI4 spec. Also, the function prototypes need to be 
added to
+         rmi_function_xx.h - also where xx is the hex number of the 
RMI4 function.
+         So that you don't get compile errors and that new header needs 
to be
+         included in the rmi.h header file.
+      */
+      fn->report = rmi4_fn->reportFn;
+      fn->config = rmi4_fn->configFn;
+      fn->init =   rmi4_fn->initFn;
+      fn->detect = rmi4_fn->detectFn;
+
+      /* Add the new fn to the global list */
+      mutex_lock(&fns_mutex);
+      list_add_tail(&fn->link, &fns_list);
+      mutex_unlock(&fns_mutex);
+    }
+  }
+
+  return 0;
+}
+
+static void __exit mod_exit(void)
+{
+  struct rmi_application *app, *apptmp;
+  struct rmi_function *fn, *fntmp;
+  struct rmi_function_info *rfi, *rfitmp;
+
+  /* These lists should be empty, but just in case . . . */
+  mutex_lock(&app_drivers_mutex);
+  list_for_each_entry_safe(app, apptmp, &app_drivers, apps) {
+    list_del(&app->apps);
+    kfree(app);
+    DEC_ALLOC_STAT(app);
+  }
+  mutex_unlock(&app_drivers_mutex);
+
+  mutex_lock(&fns_mutex);
+  list_for_each_entry_safe(fn, fntmp, &fns_list, link) {
+    list_del(&fn->link);
+    kfree(fn);
+    DEC_ALLOC_STAT(fn);
+  }
+  mutex_unlock(&fns_mutex);
+
+  mutex_lock(&rfi_mutex);
+  list_for_each_entry_safe(rfi, rfitmp, &rpd->rmi.functions, link) {
+    list_del(&fn->link);
+    kfree(fn);
+    DEC_ALLOC_STAT(rfi);
+  }
+  mutex_unlock(&rfi_mutex);
+
+
+  CHECK_ALLOC_STAT(rfi);
+  CHECK_ALLOC_STAT(fn);
+  CHECK_ALLOC_STAT(app);
+}
+
+/** Specifies to the kernel that the mod_init() function should be 
called when
+ * the module is loaded.
+ * \see mod_init()
+ */
+module_init(mod_init);
+/** Specifies to the kernel that the mod_exit() function should be 
called when
+ * the module is unloaded.
+ * \see mod_exit()
+ */
+module_exit(mod_exit);
+
+/** Standard driver module information - the author of the module.
+ */
+MODULE_AUTHOR("Synaptics, Inc.");
+/** Standard driver module information - a summary description of this 
module.
+ */
+MODULE_DESCRIPTION("RMI4 Driver");
+/** Standard driver module information - the license under which this 
module
+ * is included in the kernel.
+ */
+MODULE_LICENSE("GPL");
+
+/* vim600: set noexpandtab sw=8 ts=8 : */
diff --git a/drivers/input/touchscreen/rmi_core.h 
b/drivers/input/touchscreen/rmi_core.h
new file mode 100755
index 0000000..3e38f5c
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_core.h
@@ -0,0 +1,54 @@
+/**
+ * \file
+ * Synaptics Register Mapped Interface (RMI4) Data Layer Core Header.
+ * Copyright (c) 2007-2009 Synaptics Incorporated.
+ *
+ * \note YOU SHOULD NOT NEED TO INCLUDE THIS FILE FOR PHYSICAL OR 
APPLICATION
+ * LAYERS.
+ *
+ */
+/*
+ *
+ * This file is licensed under the GPL2 license.
+ *
+ 
*#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ 
*#############################################################################
+ */
+
+struct rmi_application {
+  const char *name;
+  void (*attention)(struct rmi_phys_driver *pd, int instance);
+  /** Probe Function
+   *  This function is called to give the application layer an
+   *  opportunity to claim an RMI device.  The application layer cannot
+   *  read RMI registers at this point.  Defer that to the config
+   *  function call which occurs immediately after a successful probe.
+   */
+  int (*probe)(struct rmi_application *app, const struct 
rmi_module_info *rmi);
+  /** Config Function
+   *  This function is called after a successful probe.  It gives the
+   *  application driver an opportunity to query and/or configure an RMI
+   *  device before data starts flowing.
+   */
+  void (*config)(struct rmi_application *app);
+  /** Standard kernel linked list implementation.
+   *  Documentation on how to use it can be found at
+   *  http://isis.poly.edu/kulesh/stuff/src/klist/.
+   */
+  struct list_head apps;
+  struct rmi_phys_driver *rpd;
+  int    polling_required;
+};
+
+/* vim600: set noexpandtab sw=8 ts=8 : */
diff --git a/drivers/input/touchscreen/rmi_function_11.c 
b/drivers/input/touchscreen/rmi_function_11.c
new file mode 100755
index 0000000..c5ebf98
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_function_11.c
@@ -0,0 +1,313 @@
+/**
+ * \file
+ * Synaptics Register Mapped Interface (RMI4) Function $11 support for 2D.
+ * Copyright (c) 2009 Synaptics Incorporated
+ *
+ * For every RMI4 function that has a data source - like 2D sensors, 
buttons, LEDs,
+ * GPIOs, etc. - the user will create a new rmi_function_xx.c file and 
add these
+ * functions to perform the config(), init(), report() and detect() 
functionality.
+ * The function pointers are then srored under the RMI function info 
and these
+ * functions will automatically be called by the global config(), 
init(), report()
+ * and detect() functions that will loop through all data sources and 
call the
+ * data sources functions using these functions pointed to by the 
function ptrs.
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ 
*#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ 
*#############################################################################
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+#include <linux/input.h>
+
+#include "rmi_core.h"
+#include "rmi.h"
+
+static int sensorMaxX = 0;
+static int sensorMaxY = 0;
+
+/**
+ * This reads in a sample and reports the function $11 source data to 
the input subsystem.
+ * It is used for both polling and interrupt driven operation. This is 
called a lot
+ * so don't put in any informational printks since they will slow 
things way down!
+ */
+int FN_11_report(struct rmi_application *app, struct rmi_function_info 
*rfi, struct input_dev *input)
+{
+  unsigned char values[2] = {0,0};
+  unsigned char data[12] = {0,0,0,0,0,0,0,0,0,0,0,0};
+  int touch = 0; /* number of touch points - fingers in this case */
+
+  int X = 0;
+  int Y = 0;
+  int Z = 0;
+  int W = 0;
+
+  /* get 2D sensor finger data */
+  /* First get the finger status field - the size of the finger status 
field is
+     determined by the number of finger supporte - 2 bits per finger, 
so the number
+     of registers to read is : registerCount = ciel(numberOfFingers/4).
+     Read the required number of registers and check each 2 bit field 
to determine
+     if a finger is down (00 = finger not present, 01 = finger present 
and data accurate,
+     10 = finger present but data may not be accurate, 11 = reserved 
for product use).
+  */
+  int fn11FingersSupported = rfi->numDataPoints;
+  int fn11FingerRegisters = (fn11FingersSupported + 3)/4;
+
+  unsigned short fn11DataBaseAddr = rfi->funcDescriptor.dataBaseAddr;
+
+  if (rmi_read_multiple(app, fn11DataBaseAddr, values, 
fn11FingerRegisters)) {
+    printk(KERN_ERR "RMI4 function $11 report: Could not read finger 
status registers 0x%x\n", fn11DataBaseAddr);
+    return 0;
+  }
+
+  /* For each finger present, read the proper number of registers to 
get absolute data. */
+  unsigned char fn11DataRegBlockSize = rfi->dataRegBlockSize;
+  int finger;
+  for (finger = 0; finger < fn11FingersSupported; finger++)
+  {
+    int reg = finger/4; /* determine which data byte the finger status 
is in */
+    int fingerShift = (finger %4) * 2; /* determine bit shift to get 
that fingers status */
+    int fingerStatus = (values[reg] >> fingerShift) & 3;
+
+    /* if finger status indicates a finger is present then read the 
finger data and report it */
+    if (fingerStatus == 1 || fingerStatus == 2)
+    {
+      touch++; /* number of active touch points not same as number of 
supported fingers */
+
+      /* Read the finger data */
+      if(rmi_read_multiple(app, fn11DataBaseAddr +
+        ((finger  * fn11DataRegBlockSize) + fn11FingerRegisters), data, 
fn11DataRegBlockSize))
+      {
+        printk(KERN_ERR "RMI4 function $11 report: Could not read 
finger data registers 0x%x\n",
+          fn11DataBaseAddr + ((finger  * fn11DataRegBlockSize) + 
fn11FingerRegisters));
+        return 0;
+      } else {
+        X = (data[0] & 0x1f) << 4;
+        X |= data[2] & 0xf;
+        Y = (data[1] & 0x1f) << 4;
+        Y |= (data[2] >> 4) & 0xf;
+        W = data[3];
+
+        /* upper 4 bits of W are Wy, lower 4 of W are Wx */
+        int Wy = (W >> 4) & 0x0f;
+        int Wx = W & 0x0f;
+
+        Z = data[4];
+
+        /* if this is the first finger report normal ABS_X, ABS_Y, 
PRESSURE, TOOL_WIDTH events for non-MT apps.
+           Apps that support Multi-touch will ignore these events and 
use the MT events. Apps that don't support
+           Multi-touch will still function.
+        */
+        if (touch == 1)
+        {
+          input_report_abs(input, ABS_X, X);
+          input_report_abs(input, ABS_Y, Y);
+          input_report_abs(input, ABS_PRESSURE, Z);
+          input_report_abs(input, ABS_TOOL_WIDTH, max(Wx, Wy));
+        }
+
+        /* Report Multi-Touch events for each finger */
+        input_report_abs(input, ABS_MT_TOUCH_MAJOR, max(Wx, Wy)); /* 
major axis of touch area ellipse */
+        input_report_abs(input, ABS_MT_TOUCH_MINOR, min(Wx, Wy)); /* 
minor axis of touch area ellipse */
+        input_report_abs(input, ABS_MT_TOUCH_ORIENTATION, (Wx > Wy ? 1 
: 0)); /* Currently only 2 supported - 1 or 0 */
+        input_report_abs(input, ABS_MT_POSITION_X, X);
+        input_report_abs(input, ABS_MT_POSITION_Y, Y);
+        input_report_abs(input, ABS_MT_TRACKING_ID, finger+1); /* 
Tracking ID reported but not used yet */
+        input_mt_sync(input); /* MT sync between fingers */
+      }
+    }
+  }
+
+  if (touch) /* touch will be non-zero if we had any reported events */
+    input_sync(input); /* sync after groups of events */
+
+  /* return the number of touch points - fingers down or buttons pressed */
+  return touch;
+}
+
+static void FN_11_config(struct rmi_application *app, struct 
rmi_function_info *rfi)
+{
+  /* For the data source - print info and do any source specific 
configuration. */
+  unsigned char data[14];
+
+  printk(KERN_INFO "RMI4 function $11 config\n");
+
+  /* Get and print some info about the data source... */
+
+  /*
+   * To Query 2D devices we need to read from the address obtained
+   * from the function descriptor stored in the RMI function info.
+   */
+  if(rmi_read_multiple(app, rfi->funcDescriptor.queryBaseAddr, data, 9)) {
+    printk(KERN_ERR "RMI4 function $11 config: Could not read function 
query registers 0x%x\n", rfi->funcDescriptor.queryBaseAddr);
+    return;
+  } else {
+    printk(KERN_INFO "  Number of Fingers:   %d\n", data[1] & 7);
+    printk(KERN_INFO "  Is Configurable:     %d\n", data[1] & (1 << 7) 
? 1 : 0);
+    printk(KERN_INFO "  Has Gestures:        %d\n", data[1] & (1 << 5) 
? 1 : 0);
+    printk(KERN_INFO "  Has Absolute:        %d\n", data[1] & (1 << 4) 
? 1 : 0);
+    printk(KERN_INFO "  Has Relative:        %d\n", data[1] & (1 << 3) 
? 1 : 0);
+
+    printk(KERN_INFO "  Number X Electrodes: %d\n", data[2] & 0x1f);
+    printk(KERN_INFO "  Number Y Electrodes: %d\n", data[3] & 0x1f);
+    printk(KERN_INFO "  Maximum Electrodes:  %d\n", data[4] & 0x1f);
+
+    printk(KERN_INFO "  Absolute Data Size:  %d\n", data[5] & 3);
+
+    printk(KERN_INFO "  Has XY Dist:         %d\n", data[7] & (1 << 7) 
? 1 : 0);
+    printk(KERN_INFO "  Has Pinch:           %d\n", data[7] & (1 << 6) 
? 1 : 0);
+    printk(KERN_INFO "  Has Press:           %d\n", data[7] & (1 << 5) 
? 1 : 0);
+    printk(KERN_INFO "  Has Flick:           %d\n", data[7] & (1 << 4) 
? 1 : 0);
+    printk(KERN_INFO "  Has Early Tap:       %d\n", data[7] & (1 << 3) 
? 1 : 0);
+    printk(KERN_INFO "  Has Double Tap:      %d\n", data[7] & (1 << 2) 
? 1 : 0);
+    printk(KERN_INFO "  Has Tap and Hold:    %d\n", data[7] & (1 << 1) 
? 1 : 0);
+    printk(KERN_INFO "  Has Tap:             %d\n", data[7] & 1 ? 1 : 0);
+    printk(KERN_INFO "  Has Palm Detect:     %d\n", data[8] & 1 ? 1 : 0);
+    printk(KERN_INFO "  Has Rotate:          %d\n", data[8] & (1 << 1) 
? 1 : 0);
+
+    if(rmi_read_multiple(app, rfi->funcDescriptor.controlBaseAddr, 
data, 14)) {
+      printk(KERN_ERR "RMI4 function $11 config: Could not read 
function control registers 0x%x\n", rfi->funcDescriptor.controlBaseAddr);
+      return;
+    }
+
+    /* Store these for use later...*/
+    sensorMaxX = ((data[6] & 0x1f) << 8) | ((data[7] & 0xff) << 0);
+    sensorMaxY = ((data[8] & 0x1f) << 8) | ((data[9] & 0xff) << 0);
+
+    printk(KERN_INFO "  Sensor Max X:  %d\n", sensorMaxX);
+    printk(KERN_INFO "  Sensor Max Y:  %d\n", sensorMaxY);
+  }
+}
+
+/**
+ * Initialize any function $11 specific params and settings - input 
settings, device settings, etc. */
+ */
+static void FN_11_init(struct input_dev *input)
+{
+  printk(KERN_INFO "RMI4 function $11 init\n");
+
+  /* need to init the input abs params for the 2D */
+  input->evbit[0] = BIT(EV_ABS);
+
+  /* Use the max X and max Y read from the device...*/
+  input_set_abs_params(input, ABS_X, 0, sensorMaxX, 0, 0);
+  input_set_abs_params(input, ABS_Y, 0, sensorMaxY, 0, 0);
+  input_set_abs_params(input, ABS_MT_POSITION_X, 0, sensorMaxX, 0, 0);
+  input_set_abs_params(input, ABS_MT_POSITION_Y, 0, sensorMaxY, 0, 0);
+
+  input_set_abs_params(input, ABS_PRESSURE, 0, 255, 0, 0);
+  input_set_abs_params(input, ABS_TOOL_WIDTH, 0, 15, 0, 0);
+
+  input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0, 15, 0, 0);
+  input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0, 15, 0, 0);
+  input_set_abs_params(input, ABS_MT_ORIENTATION, 0, 1, 0, 0);
+  input_set_abs_params(input, ABS_MT_TRACKING_ID, 1, 10, 0, 0);
+}
+
+static void FN_11_detect(struct rmi_application *app, struct 
rmi_function_info *rfi,
+  struct rmi_function_descriptor *fd, unsigned int interruptCount)
+{
+  unsigned char fn11Queries[9];
+
+  printk(KERN_INFO "RMI4 function $11 detect\n");
+
+  /* Store addresses - used elsewhere to read data, control, query, 
etc. */
+  rfi->funcDescriptor.queryBaseAddr = fd->queryBaseAddr;
+  rfi->funcDescriptor.commandBaseAddr = fd->commandBaseAddr;
+  rfi->funcDescriptor.controlBaseAddr = fd->controlBaseAddr;
+  rfi->funcDescriptor.dataBaseAddr = fd->dataBaseAddr;
+  rfi->funcDescriptor.interruptSrcCnt = fd->interruptSrcCnt;
+  rfi->funcDescriptor.functionNum = fd->functionNum;
+
+  rfi->numSources = fd->interruptSrcCnt;
+
+  /* need to get number of fingers supported, data size, etc. -
+     to be used when getting data since the number of registers to
+     read depends on the number of fingers supported and data size. */
+  if (rpd->read_multiple(app, fd->queryBaseAddr, &fn11Queries, 
sizeof(fn11Queries))) {
+    printk(KERN_ERR "RMI4 function $11 detect: Could not read function 
query registers 0x%x\n", rfi->funcDescriptor.queryBaseAddr);
+    return;
+  }
+
+  /* 2D data sources have only 3 bits for the number of fingers 
supported - so the encoding is a bit wierd. */
+  rfi->numDataPoints = 2; /* default number of fingers supported */
+  if ((fn11Queries[1] & 0x7) <= 4)
+   rfi->numDataPoints = (fn11Queries[1] & 0x7) + 1; /* add one since 
zero based */
+  else {
+    if ((fn11Queries[1] & 0x7) == 5) /* a value of 5 is up to 10 
fingers - 6 and 7 are reserved (shouldn't get these in a normal 2D 
source). */
+      rfi->numDataPoints = 10;
+  }
+
+  /* Need to get interrupt info to be used later when handling 
interrupts. */
+  rfi->interruptRegister = (interruptCount + 7)/8;
+
+  /* loop through interrupts for each source in fn $11 and or in a bit 
to the interrupt mask for each. */
+  unsigned short fn11InterruptOffset = interruptCount % 8;
+  int i;
+  for (i = fn11InterruptOffset; i < ((fd->interruptSrcCnt & 0x7) + 
fn11InterruptOffset); i++)
+  {
+    rfi->interruptMask |= 1 << i;
+  }
+
+  /* Size of just the absolute data for one finger */
+  unsigned char fn11AbsDataSize = fn11Queries[5] & 0x03;
+  unsigned char fn11AbsDataBlockSize = 3 + (2 * (fn11AbsDataSize == 0 ? 
1 : 0)); /* One each for X and Y, one for LSB for X & Y, one for W, one 
for Z */
+  rfi->dataRegBlockSize = fn11AbsDataBlockSize;
+
+  /* need to determine the size of data to read - this depends on 
conditions such as
+     whether Relative data is reported and if Gesture data is reported. 
*/
+  unsigned char f11_egr_0 = fn11Queries[7];
+  unsigned char f11_egr_1 = fn11Queries[8];
+  int fn11HasPinch = f11_egr_0 & 0x40;
+  int fn11HasFlick = f11_egr_0 & 0x10;
+  int fn11HasTap = f11_egr_0 & 0x01;
+  int fn11HasTapAndHold = f11_egr_0 & 0x02;
+  int fn11HasDoubleTap = f11_egr_0 & 0x04;
+  int fn11HasEarlyTap = f11_egr_0 & 0x08;
+  int fn11HasPress = f11_egr_0 & 0x20;
+  int fn11HasPalmDetect = f11_egr_1 & 0x01;
+  int fn11HasRotate = f11_egr_1 & 0x02;
+  int fn11HasRel = fn11Queries[1] & 0x08;
+
+  /* Size of all data including finger status, absolute data for each 
finger, relative data and EGR data */
+  unsigned int fn11AllDataBlockSize =			
+    /* finger status, four fingers per register */
+    ((fn11FingersSupported + 3) / 4) +
+	  /* absolute data, per finger times number of fingers */
+	  fn11AbsDataBlockSize * fn11FingersSupported +
+	  /* two relative registers (if relative is being reported) */
+		2 * fn11HasRel +
+	  /* F11_2D_Data8 is only present if the egr_0 register is non-zero. */
+		!!(f11_egr_0) +
+	  /* F11_2D_Data9 is only present if either egr_0 or egr_1 registers 
are non-zero. */
+	  (f11_egr_0 || f11_egr_1) +
+		/* F11_2D_Data10 is only present if EGR_PINCH or EGR_FLICK of egr_0 
reports as 1. */
+		!!(f11HasPinch | f11HasFlick)) +
+		/* F11_2D_Data11 and F11_2D_Data12 are only present if EGR_FLICK of 
egr_0 reports as 1. */
+		2 * !!(f11HasFlick);
+
+    /* Disable Interrupts. It is up to the Application Driver to
+     * turn them on when it's ready for them. */
+    if(!(retval = rpd->write(rpd, fn01ControlBaseAddr + 1 + 
rfi->interruptRegister, 0))) {
+      printk(KERN_ERR "Function $11 Interrupt Disable Fail: %d\n", retval);
+    }
+
+}
+
+/* vim600: set noexpandtab sw=8 ts=8 :*/
diff --git a/drivers/input/touchscreen/rmi_function_11.h 
b/drivers/input/touchscreen/rmi_function_11.h
new file mode 100755
index 0000000..19eadbe
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_function_11.h
@@ -0,0 +1,37 @@
+/**
+ * \file
+ * Synaptics Register Mapped Interface (RMI4) Function $11 support for 2D.
+ * Copyright (c) 2009 Synaptics Incorporated
+ *
+ * For every RMI4 function that has a data source - like 2D sensors, 
buttons, LEDs,
+ * GPIOs, etc. - the user will create a new rmi_function_xx.c file and 
add these
+ * functions to perform the config(), init(), report() and detect() 
functionality.
+ * The function pointers are then stored under the RMI function info 
and these
+ * functions will automatically be called by the global config(), 
init(), report()
+ * and detect() functions that will loop through all data sources and 
call the
+ * data sources functions using these functions pointed to by the 
function ptrs.
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ 
*#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ 
*#############################################################################
+ */
+
+int  FN_11_report(struct rmi_application *app, struct rmi_function_info 
*rfi, struct input_dev *input);
+void FN_11_config(struct rmi_application *app, struct rmi_function_info 
*rfi);
+void FN_11_init(struct input_dev *input);
+void FN_11_detect(struct rmi_application *app, struct rmi_function_info 
*rfi, struct rmi_function_descriptor *fd, unsigned int interruptCount);
+
+/* vim600: set noexpandtab sw=8 ts=8 :*/
diff --git a/drivers/input/touchscreen/rmi_i2c.h 
b/drivers/input/touchscreen/rmi_i2c.h
new file mode 100755
index 0000000..20c267b
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_i2c.h
@@ -0,0 +1,52 @@
+/**
+ * \file
+ * Synaptics RMI over I2C Physical Layer Driver Header File.
+ * Copyright (c) 2007-2009 Synaptics Incorporated
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ 
*#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ 
*#############################################################################
+ */
+
+/** Platform-specific configuration data.
+ * This structure is used by the platform-specific driver to designate
+ * specific information about the hardware.  A platform client may supply
+ * an array of these to the rmi_phys_i2c driver.
+ */
+struct rmi_i2c_clientdata {
+	/** The seven-bit i2c address of the device. */
+	int i2c_address;
+	/** The number of the irq.  Set to zero if polling is required. */
+	int irq;
+	/** The type of the irq (e.g., IRQF_TRIGGER_FALLING).  Only valid if
+	 * irq != 0 */
+	int irq_type;
+	/** Function used to query the state of the attention line.  It always
+	 * returns 1 for "active" regardless of the polarity of the attention
+	 * line. */
+	int (*get_attention)(void);
+};
+
+/** Descriptor structure.
+ * Describes the number of i2c devices on the bus that speak RMI.
+ */
+struct rmi_i2c_data {
+	int num_clients;
+	struct rmi_i2c_clientdata *clientdata;
+};
+
+/* vim600: set noexpandtab sw=8 ts=8 :*/
diff --git a/drivers/input/touchscreen/rmi_i2c_gta01.c 
b/drivers/input/touchscreen/rmi_i2c_gta01.c
new file mode 100755
index 0000000..c9a34b9
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_i2c_gta01.c
@@ -0,0 +1,117 @@
+/**
+ * \file
+ * Synaptics RMI4 Support for I2C the OpenMoko phone (GTA01) hardware 
platform.
+ * Copyright (c) 2007-2009 Synaptics, Inc.
+ *
+ * To support a different device - for example if the GPIOs are 
different or
+ * different hardware is being used - make a copy of this file and 
change the
+ * name to reflect the new hardware platform then modify it to support 
the new
+ * platforms hardware (interrupts, IC chip, etc.).
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ 
*#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ 
*#############################################################################
+ */
+
+#include <linux/module.h>
+#include <linux/jiffies.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <asm/gpio.h>
+#include "rmi_i2c.h"
+
+/* Set this to either 1 or 0 depending on your clearpad hardware. */
+#define ATTENTION_ACTIVE_LOW 1
+
+#if ATTENTION_ACTIVE_LOW
+#   define IRQ_TRIGGER IRQF_TRIGGER_FALLING
+#else
+#   define IRQ_TRIGGER IRQF_TRIGGER_RISING
+#endif
+
+static int
+get_attention(void)
+{
+#if ATTENTION_ACTIVE_LOW
+	return gpio_get_value(S3C2410_GPF3)?0:1;
+#else
+	return gpio_get_value(S3C2410_GPF3)?1:0;
+#endif
+}
+
+static struct rmi_i2c_clientdata rmi_test_clientdata[] = {
+  [0] = {
+    .i2c_address   = 0x20,
+    .irq           = IRQ_EINT3,
+    .irq_type      = IRQ_TRIGGER,
+    .get_attention = get_attention,
+  },
+};
+
+static struct rmi_i2c_data rmi_client_data = {
+  .num_clients = ARRAY_SIZE(rmi_test_clientdata),
+  .clientdata  = rmi_test_clientdata,
+};
+
+static void
+rmi_i2c_release(struct device *dev)
+{
+  struct platform_device *pd = container_of(dev, struct 
platform_device, dev);
+	kfree(pd);
+}
+
+static struct platform_device *gta01_rmi_device;
+
+/*
+ * These are the module insert and remove functions.
+ */
+static int __init
+mod_init(void)
+{
+	struct platform_device *pd;
+
+	printk(KERN_INFO "GTA01 RMI4 Platform Driver Init.\n");
+
+	gta01_rmi_device = pd = kmalloc(sizeof(*pd), GFP_KERNEL);
+	if(!pd) return -ENOMEM;
+	memset(pd, 0, sizeof(*pd));
+
+	/* Set up the GPIO for interrupts */
+	s3c2410_gpio_cfgpin(S3C2410_GPF3, S3C2410_GPF3_EINT3);
+
+	pd->name              = "rmi4-i2c";
+	pd->id                = -1;
+	pd->dev.platform_data = &rmi_client_data;
+	pd->dev.release       = rmi_i2c_release;
+
+	return platform_device_register(pd);
+}
+
+static void __exit
+mod_exit(void)
+{
+	return platform_device_unregister(gta01_rmi_device);
+}
+
+MODULE_AUTHOR("Synaptics, Inc.");
+MODULE_DESCRIPTION("GTA01 (OpenMoko Phone) RMI4 over I2C Device 
Configuration");
+MODULE_LICENSE("GPL");
+
+module_init(mod_init);
+module_exit(mod_exit);
+
+/* vim600: set noexpandtab sw=8 ts=8 : */
diff --git a/drivers/input/touchscreen/rmi_i2c_gta01.mod.c 
b/drivers/input/touchscreen/rmi_i2c_gta01.mod.c
new file mode 100755
index 0000000..e11b023
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_i2c_gta01.mod.c
@@ -0,0 +1,20 @@
+#include <linux/module.h>
+#include <linux/vermagic.h>
+#include <linux/compiler.h>
+
+MODULE_INFO(vermagic, VERMAGIC_STRING);
+
+struct module __this_module
+__attribute__((section(".gnu.linkonce.this_module"))) = {
+ .name = KBUILD_MODNAME,
+ .init = init_module,
+#ifdef CONFIG_MODULE_UNLOAD
+ .exit = cleanup_module,
+#endif
+};
+
+static const char __module_depends[]
+__attribute_used__
+__attribute__((section(".modinfo"))) =
+"depends=";
+
diff --git a/drivers/input/touchscreen/rmi_phys_i2c.c 
b/drivers/input/touchscreen/rmi_phys_i2c.c
new file mode 100755
index 0000000..caf68c4
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_phys_i2c.c
@@ -0,0 +1,633 @@
+/**
+ * \file
+ * Synaptics Register Mapped Interface (RMI4) I2C Physical Layer Driver.
+ * Copyright (c) 2007-2009, Synaptics Incorporated
+ *
+ */
+/*
+ * This file is licensed under the GPL2 license.
+ *
+ 
*#############################################################################
+ * GPL
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ 
*#############################################################################
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include "rmi_i2c.h"
+#include "rmi.h"
+
+/** Used to lock access to the page address.
+ * \see rmi_set_page()
+ */
+static DEFINE_MUTEX(page_mutex);
+
+/** This is a count of how many clients are accessing this driver.
+ */
+static int num_clients = 0;
+static struct rmi_i2c_clientdata *clientdata = NULL;
+
+/** This list is used in definition of the I2C bus scanning parameters.
+ * There is nothing on our "normal" i2c list.
+ */
+static unsigned short normal_i2c[] = { I2C_CLIENT_END,
+	I2C_CLIENT_END, I2C_CLIENT_END, I2C_CLIENT_END, I2C_CLIENT_END,
+	I2C_CLIENT_END, I2C_CLIENT_END, I2C_CLIENT_END, I2C_CLIENT_END,
+};
+/** This list is used in definition of the I2C bus scanning parameters.
+ * There is nothing on our "force" i2c list.
+ */
+static unsigned short force[] = { I2C_CLIENT_END, I2C_CLIENT_END };
+/** This list is used in definition of the I2C bus scanning parameters.
+ * The only thing on our "forces" list is a single empty list.
+ */
+static unsigned short *forces[] = { force, 0 };
+/** Call to a kernel macro to set up our I2C bus scanning parameters.
+ * This relies on the forces and normal_i2c data structures.
+ */
+I2C_CLIENT_INSMOD_COMMON;
+
+static struct i2c_driver rmi_i2c_driver;
+
+/**
+ * This is the data kept on a per instance (client) basis.  This data is
+ * always accessible by using the container_of() macro of the various 
elements
+ * inside.
+ */
+struct instance_data {
+	int instance_no;
+	int irq;
+	struct rmi_phys_driver rpd;
+	struct i2c_client i2cclient;
+	int page;
+	int (*get_attention)(void);
+};
+
+/**
+ * RMI devices have 16-bit addressing, but some of the physical
+ * implementations (like SMBus) only have 8-bit addressing.  So RMI 
implements
+ * a page address at 0xff of every page so we can reliable page addresses
+ * every 256 registers.  This function sets the page.
+ * \pre The page_mutex lock must be held when this function is entered.
+ * \param[in] id TBD
+ * \param[in] page The new page address.
+ * \return zero on success, non-zero on failure.
+ */
+int
+rmi_set_page(struct instance_data *id, unsigned int page)
+{
+	char txbuf[2];
+	int retval;
+	txbuf[0] = 0xff;
+	txbuf[1] = page;
+	retval = i2c_master_send(&id->i2cclient, txbuf, 2);
+	if(retval != 2) {
+		printk(KERN_ERR "rmi_i2c: Set page fail: %d\n", retval);
+	} else {
+		retval = 0;
+		id->page = page;
+	}
+	return retval;
+}
+
+/**
+ * Read a single register through i2c.
+ * \param[in] pd TBD
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be stored.
+ * \return xero upon success (with the byte read in valp), non-zero 
upon error.
+ */
+static int
+rmi_i2c_read(struct rmi_phys_driver *pd, unsigned short address, char 
*valp)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	char txbuf[2];
+	int retval = 0;
+	int retry_count = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if(((address >> 8) & 0xff) != id->page) {
+		/* Switch pages */
+		retval = rmi_set_page(id, ((address >> 8) & 0xff));
+		if(retval) {
+			goto exit;
+		}
+	}
+
+retry:
+	txbuf[0] = address & 0xff;
+	retval = i2c_master_send(&id->i2cclient, txbuf, 1);
+
+	if(retval != 1) {
+		printk(KERN_ERR "rmi_i2c.rmi_i2c_read: Write fail: %d\n",
+			retval);
+		goto exit;
+	}
+	retval = i2c_master_recv(&id->i2cclient, txbuf, 1);
+
+	if(retval != 1) {
+		if(++retry_count == 5) {
+			printk(KERN_ERR "rmi_i2c.rmi_i2c_read: "
+				"Read of 0x%04x fail: %d\n", address, retval);
+		} else {
+			mdelay(10);
+			rmi_set_page(id, ((address >> 8) & 0xff));
+			goto retry;
+		}
+	} else {
+		retval = 0;
+		*valp = txbuf[0];
+	}
+exit:
+	mutex_unlock(&page_mutex);
+	return retval;
+}
+
+/**
+ * Same as rmi_i2c_read, except that multiple bytes are allowed to be read.
+ * \param[in] pd TBD
+ * \param[in] address The address at which to start the data read.
+ * \param[out] valp Pointer to the buffer where the data will be 
stored.  This
+ * buffer must be at least size bytes long.
+ * \param[in] size The number of bytes to be read.
+ * \return zero upon success (with the byte read in valp), non-zero 
upon error.
+ * \see rmi_i2c_read()
+ */
+static int
+rmi_i2c_read_multiple(struct rmi_phys_driver *pd, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	char txbuf[2];
+	int retval = 0;
+	int retry_count = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if(((address >> 8) & 0xff) != id->page) {
+		/* Switch pages */
+		retval = rmi_set_page(id, ((address >> 8) & 0xff));
+		if(retval) {
+			goto exit;
+		}
+	}
+
+retry:
+	txbuf[0] = address & 0xff;
+	retval = i2c_master_send(&id->i2cclient, txbuf, 1);
+
+	if(retval != 1) {
+		printk(KERN_ERR "rmi_i2c.rmi_i2c_read: Write fail: %d\n",
+			retval);
+		goto exit;
+	}
+	retval = i2c_master_recv(&id->i2cclient, valp, size);
+
+	if(retval != size) {
+		if(++retry_count == 5) {
+			printk(KERN_ERR "rmi_2ic.rmi_i2c_read_multiple: "
+				"Read of 0x%04x size %d fail: %d\n",
+				address, size, retval);
+		} else {
+			mdelay(10);
+			rmi_set_page(id, ((address >> 8) & 0xff));
+			goto retry;
+		}
+	} else {
+		retval = 0;
+	}
+exit:
+	mutex_unlock(&page_mutex);
+	return retval;
+}
+
+
+/**
+ * Write a single register through i2c.
+ * You can write multiple registers at once, but I made the functions 
for that
+ * seperate for performance reasons.  Writing multiple requires 
allocation and
+ * freeing.
+ * \param[in] pd TBD
+ * \param[in] address The address at which to start the write.
+ * \param[in] data The data to be written.
+ * \return one upon success, something else upon error.
+ */
+static int
+rmi_i2c_write(struct rmi_phys_driver *pd, unsigned short address, char 
data)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	unsigned char txbuf[2];
+	int retval = 0;
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if(((address >> 8) & 0xff) != id->page) {
+		/* Switch pages */
+		retval = rmi_set_page(id, ((address >> 8) & 0xff));
+		if(retval) {
+			goto exit;
+		}
+	}
+
+	txbuf[0] = address & 0xff;
+	txbuf[1] = data;
+	retval = i2c_master_send(&id->i2cclient, txbuf, 2);
+
+	if(retval != 2) {
+		printk(KERN_ERR "rmi_i2c.rmi_i2c_write: Write fail: %d\n",
+			retval);
+		goto exit; /* Leave this in case we add code below */
+	}
+exit:
+	mutex_unlock(&page_mutex);
+	return retval;
+}
+
+/**
+ * Write multiple registers.
+ * \param[in] pd TBD
+ * \param[in] address The address at which to start the write.
+ * \param[in] valp A pointer to a buffer containing the data to be written.
+ * \param[in] size The number of bytes to write.
+ * \return one upon success, something else upon error.
+ */
+static int
+rmi_i2c_write_multiple(struct rmi_phys_driver *pd, unsigned short address,
+	char *valp, int size)
+{
+	struct instance_data *id = container_of(pd, struct instance_data, rpd);
+	unsigned char *txbuf;
+	unsigned char txbuf_most[16];
+	int retval = 0;
+
+	if(size < 15) {
+		/* Avoid an allocation if we can help it. */
+		txbuf = txbuf_most;
+	} else {
+		txbuf = kmalloc(size + 1, GFP_KERNEL);
+		if(!txbuf) return -ENOMEM;
+	}
+
+	/* Yes, it stinks here that we have to copy the buffer */
+	{
+		int i;
+		for(i = 0; i < size; i++) {
+			txbuf[i + 1] = valp[i];
+		}
+	}
+
+	/* Can't have anyone else changing the page behind our backs */
+	mutex_lock(&page_mutex);
+
+	if(((address >> 8) & 0xff) != id->page) {
+		/* Switch pages */
+		retval = rmi_set_page(id, ((address >> 8) & 0xff));
+		if(retval) {
+			goto exit;
+		}
+	}
+
+	txbuf[0] = address & 0xff;
+	retval = i2c_master_send(&id->i2cclient, txbuf, size + 1);
+
+	if(retval != 1) {
+		printk(KERN_ERR "rmi_i2c.rmi_i2c_read: Write fail: %d\n", retval);
+		goto exit;
+	}
+exit:
+	mutex_unlock(&page_mutex);
+	if(txbuf != txbuf_most) kfree(txbuf);
+	return retval;
+}
+
+/** Get the state of the attention line.
+ * This function returns 1 for an active attention regardless of the
+ * polarity of the ATTN signal.  If the get_attention function of the 
instance
+ * is not available (probably because ATTN is not implemented), then it 
always
+ * returns inactive.
+ */
+static int
+rmi_i2c_get_attention(struct rmi_phys_driver *rpd)
+{
+	struct instance_data *id = container_of(rpd, struct instance_data, rpd);
+	if(id->get_attention) {
+		return id->get_attention();
+	} else {
+		return 0; /* return inactive */
+	}
+}
+
+/**
+ * This is the Interrupt Service Routine.  It just notifies the application
+ * layer that attention is required.
+ *
+ * This is a work in progress.  It has yet to be figured out how the 
interrupt
+ * should be disabled/enabled for interrupt-driven platforms.
+ */
+static irqreturn_t
+i2c_attn_isr(int irq, void *info)
+{
+	struct instance_data *id = info;
+	if(id->rpd.attention) {
+		id->rpd.attention(&id->rpd, id->instance_no);
+	}
+	return IRQ_HANDLED;
+}
+
+
+/**
+ * This function detects each device on the i2c bus and sets up the 
structures
+ * for it.
+ */
+static int
+detect(struct i2c_adapter *adapter, int address, int kind)
+{
+	struct instance_data *id;
+	int retval;
+	int i;
+
+	pr_debug("rmi_i2c: Detect: %08x, %08x\n", address, kind);
+
+	id = kmalloc(sizeof(*id) * 2, GFP_KERNEL);
+	if(!id) {
+		printk(KERN_ERR "rmi_i2c: Out of memory\n");
+		return -ENOMEM;
+	}
+
+	memset(id, 0, sizeof(*id));
+
+	id->rpd.name           = "rmi_i2c";
+	id->rpd.write          = rmi_i2c_write;
+	id->rpd.read           = rmi_i2c_read;
+	id->rpd.write_multiple = rmi_i2c_write_multiple;
+	id->rpd.read_multiple  = rmi_i2c_read_multiple;
+	id->rpd.get_attention  = rmi_i2c_get_attention;
+	id->rpd.module         = THIS_MODULE;
+	id->page               = 0xffff;    /* So we set the page correctly 
the first time */
+
+	/* "Attach" the i2c client to the i2c adapter */
+	id->i2cclient.addr    = address;
+	id->i2cclient.adapter = adapter;
+	id->i2cclient.driver  = &rmi_i2c_driver;
+	strlcpy(id->i2cclient.name, "rmi_i2c", I2C_NAME_SIZE);
+	i2c_set_clientdata(&id->i2cclient, id);
+	if ((retval = i2c_attach_client(&id->i2cclient))) {
+		pr_debug("rmi_i2c: detect: Failed to attach client\n");
+		kfree(id);
+		return retval;
+	}
+
+	/* Loop through the client data and locate the one that was found. */
+	for(i = 0; i < num_clients; i++) {
+		if(address == clientdata[i].i2c_address) {
+			id->instance_no = i;
+			id->get_attention = clientdata[i].get_attention;
+			/*
+			 * Determine if we need to poll (inefficient) or use
+			 * interrupts.
+			 */
+			if(clientdata[i].irq) {
+				int irqtype;
+
+				id->irq = clientdata[i].irq;
+				switch(clientdata[i].irq_type) {
+				case IORESOURCE_IRQ_HIGHEDGE:
+					irqtype = IRQF_TRIGGER_RISING;
+					break;
+				case IORESOURCE_IRQ_LOWEDGE:
+					irqtype = IRQF_TRIGGER_FALLING;
+					break;
+				case IORESOURCE_IRQ_HIGHLEVEL:
+					irqtype = IRQF_TRIGGER_HIGH;
+					break;
+				case IORESOURCE_IRQ_LOWLEVEL:
+					irqtype = IRQF_TRIGGER_LOW;
+					break;
+				default:
+					printk(KERN_WARNING "rmi_i2c: Invalid IRQ flags in "
+						"platform data\n");
+					i2c_detach_client(&id->i2cclient);
+					kfree(id);
+					return -ENXIO;
+				}
+
+				if((retval = request_irq(id->irq, i2c_attn_isr,
+				    IRQF_DISABLED | irqtype, "rmi_i2c", id))) {
+					printk(KERN_WARNING "rmi_i2c: Unable to get attn "
+					  "irq %d.  Reverting to polling.\n",
+					  id->irq);
+					goto do_polling;
+				}
+				pr_debug("rmi_i2c: got irq\n");
+				id->rpd.polling_required = 0;
+			} else {
+do_polling:
+				id->rpd.polling_required = 1;
+				printk(KERN_INFO "rmi_i2c: No IRQ info given. "
+					"Polling required.\n");
+			}
+
+			/* We found it, so exit the loop */
+			break;
+		}
+	}
+
+	if((retval = rmi_register_phys_driver(&id->rpd))) {
+    printk(KERN_ERR "rmi_i2c : Failed to Register %s phys driver\n", 
id->rpd.name);
+
+		if(id->irq) {
+			free_irq(id->irq, id);
+		}
+		i2c_detach_client(&id->i2cclient);
+		kfree(id);
+		return retval;
+	}
+
+  printk(KERN_INFO "rmi_i2c : Successfully Registered %s phys 
driver\n", id->rpd.name);
+
+	rmi_set_page(id, 0x04);
+
+	return 0;
+}
+
+/**
+ * This function tears down the structures for each instance.
+ */
+static int
+detach_client(struct i2c_client *client)
+{
+	struct instance_data *id =
+		container_of(client, struct instance_data, i2cclient);
+	int err;
+
+	/* flush_scheduled_work(); */
+
+	pr_debug("Unregistering phys driver %s\n", id->rpd.name);
+
+	rmi_unregister_phys_driver(&id->rpd);
+
+	pr_debug("Unregistered phys driver %s\n", id->rpd.name);
+
+	if ((err = i2c_detach_client(client))) {
+		pr_debug("i2c_detach_client failed: %d\n", err);
+		return err;
+	}
+
+	if(id->irq) {
+		free_irq(id->irq, id);
+	}
+
+	kfree(id);
+	pr_debug("detach_client successful\n");
+	return 0;
+}
+
+/**
+ * This is a i2c service function which is used to detect i2c devices 
on the
+ * bus.
+ */
+static int
+attach_adapter(struct i2c_adapter *adapter)
+{
+	int retval = 0;
+
+	pr_debug("i2c_rmi: Attaching Adapter\n");
+	retval = i2c_probe(adapter, &addr_data, detect);
+	return retval;
+}
+
+/**
+ * This structure tells the i2c subsystem about us.
+ */
+static struct i2c_driver rmi_i2c_driver = {
+	.driver = {
+		.name = "rmi_i2c",
+	},
+	.id 		= 0xfefe,	/* This ID is apparently unused. */
+	.attach_adapter = attach_adapter,
+	.detach_client 	= detach_client,
+};
+
+/**
+ * The Platform Driver probe function.  We just tell the i2c subsystem 
about
+ * ourselves in this call.
+ */
+static int
+rmi_i2c_probe(struct platform_device *dev)
+{
+	struct rmi_i2c_data *mid = dev->dev.platform_data;
+	int i;
+
+	pr_debug("Probing i2c RMI device\n");
+
+	if(!mid) {
+		printk(KERN_WARNING "A platform_device for \"rmi_i2c\" must contain "
+			"rmi_i2c_data\n");
+		return -ENXIO;
+	}
+
+	num_clients = mid->num_clients;
+	if(num_clients > ARRAY_SIZE(normal_i2c) - 1) {
+		num_clients = ARRAY_SIZE(normal_i2c) - 1;
+		printk(KERN_WARNING "Too many clients defined for %s. "
+			"Limiting to %d\n", dev->name, num_clients);
+	}
+	clientdata  = mid->clientdata;
+
+	for(i = 0; i < ARRAY_SIZE(normal_i2c); i++) {
+		normal_i2c[i] = I2C_CLIENT_END;
+	}
+	for(i = 0; i < num_clients; i++) {
+		normal_i2c[i] = clientdata[i].i2c_address;
+	}
+
+	pr_debug("Calling i2c_add_driver\n");
+	return i2c_add_driver(&rmi_i2c_driver);
+}
+
+/**
+ * Tell the i2c subsystem that we're done.
+ * \param[in] dev TBD
+ * \return Always returns 0.
+ */
+static int
+rmi_i2c_remove(struct platform_device *dev)
+{
+	i2c_del_driver(&rmi_i2c_driver);
+	return 0;
+}
+
+/**
+ * Structure used to tell the Platform Driver subsystem about us.
+ */
+static struct platform_driver rmi_i2c_platform_driver = {
+  .driver = {
+  .name = "rmi-i2c",
+  },
+  .probe  = rmi_i2c_probe,
+  .remove = rmi_i2c_remove,
+};
+
+/** Print an informational message to the kernel
+ * log and register ourselves with the Platform Driver Subsystem.
+ * This will be called when the module is inserted.
+ * \return the result of our call to platform_driver_register()
+ */
+static int __init mod_init(void)
+{
+	printk(KERN_INFO "RMI I2C Driver\n");
+	if(RMI_ALLOC_STATS) {
+		printk(KERN_INFO "    Allocation Stats Enabled\n");
+	}
+
+	return platform_driver_register(&rmi_i2c_platform_driver);
+}
+
+/** Un-register ourselves from the Platform Driver Subsystem.
+ * This will be called when the module is removed.
+ */
+static void __exit mod_exit(void)
+{
+	platform_driver_unregister(&rmi_i2c_platform_driver);
+}
+
+/** Standard driver module information - the author of the module.
+ */
+MODULE_AUTHOR("Synaptics, Inc.");
+/** Standard driver module information - a summary description of this 
module.
+ */
+MODULE_DESCRIPTION("RMI4 Driver I2C Physical Layer");
+/** Standard driver module information - the license under which this 
module
+ * is included in the kernel.
+ */
+MODULE_LICENSE("GPL");
+
+/** Specifies to the kernel that the mod_init() function should be 
called when
+ * the module is loaded.
+ * \see mod_init()
+ */
+module_init(mod_init);
+/** Specifies to the kernel that the mod_exit() function should be 
called when
+ * the module is unloaded.
+ * \see mod_exit()
+ */
+module_exit(mod_exit);
+
+/* vim600: set noexpandtab sw=8 ts=8 :*/
diff --git a/drivers/input/touchscreen/rmi_phys_i2c.mod.c 
b/drivers/input/touchscreen/rmi_phys_i2c.mod.c
new file mode 100755
index 0000000..22ed454
--- /dev/null
+++ b/drivers/input/touchscreen/rmi_phys_i2c.mod.c
@@ -0,0 +1,20 @@
+#include <linux/module.h>
+#include <linux/vermagic.h>
+#include <linux/compiler.h>
+
+MODULE_INFO(vermagic, VERMAGIC_STRING);
+
+struct module __this_module
+__attribute__((section(".gnu.linkonce.this_module"))) = {
+ .name = KBUILD_MODNAME,
+ .init = init_module,
+#ifdef CONFIG_MODULE_UNLOAD
+ .exit = cleanup_module,
+#endif
+};
+
+static const char __module_depends[]
+__attribute_used__
+__attribute__((section(".modinfo"))) =
+"depends=rmi";
+

