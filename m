Return-Path: <linux-kernel-owner+w=401wt.eu-S965333AbXAYNVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965333AbXAYNVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 08:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965310AbXAYNVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 08:21:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:39741 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965333AbXAYNVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 08:21:53 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Scott Preece <sepreece@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Subject: [ANNOUNCE] System Inactivity Notifier v1.6
Date: Thu, 25 Jan 2007 14:21:48 +0100
Message-ID: <87k5zbfdhv.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


Hi all,

I've attached the final version of SIN, a user inactivity monitor posted few
days ago on this list.  Since then a couple of things have been improved. For
example, the acpi events have been substituted by _uevents_ (thanks Arjan for
the hint!), _sysfs_ has been preferred to procfs and the event triggering logic
has been optimized. Moreover, this version takes advantage from the PM
callbacks, in order to correctly preserve the state among several
suspend/resume cycles.  The patch also contains what is needed to test
conveniently the driver with udev-103. Thanks to all for the support.

Best,
Alessandro


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=SINv1.6.patch

diff -ur --new-file SIN/Makefile SIN-NEW/Makefile
--- SIN/Makefile	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/Makefile	2007-01-25 14:07:44.000000000 +0100
@@ -0,0 +1,43 @@
+MODLPATH = kernel/drivers/char
+
+#DEBUG="-D SIN_DEBUG"
+
+MODL = sinmod
+OBJS = sin.o sysfs.o table.o input_enumerator.o
+
+SRCS := $(patsubst %.o,%.c,$(OBJS))
+HDRS := $(patsubst %.o,%.h,$(OBJS))
+CMDS := $(patsubst %.o,.%.o.cmd,$(OBJS))
+
+ifneq ($(KERNELRELEASE),)
+	EXTRA_CFLAGS := $(DEBUG)
+	obj-m := $(MODL).o
+	$(MODL)-objs := $(OBJS)
+else
+	KDIR := /lib/modules/$(shell uname -r)/build
+	PWD := $(shell pwd)
+
+all:	$(MODL).ko
+
+$(MODL).ko:	$(SRCS) $(HDRS)
+	@$(MAKE) -C $(KDIR) M=$(PWD) modules
+
+im:	$(MODL).ko
+	@sudo insmod $(MODL).ko
+
+rm:
+	@sudo rmmod $(MODL)
+
+rmf:
+	@sudo rmmod -f $(MODL)
+
+install:
+	@sudo $(MAKE) INSTALL_MOD_DIR=$(MODLPATH) -C $(KDIR) M=$(PWD) modules_install
+
+modules_install:
+	@$(MAKE) INSTALL_MOD_DIR=$(MODLPATH) -C $(KDIR) M=$(PWD) modules_install
+
+clean:
+	@$(MAKE) -C $(KDIR) M=$(PWD) clean
+	@rm -f Module.symvers
+endif
diff -ur --new-file SIN/debug.h SIN-NEW/debug.h
--- SIN/debug.h	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/debug.h	2007-01-25 14:07:39.000000000 +0100
@@ -0,0 +1,36 @@
+/*
+ *  Copyright (C) 2007 Alessandro Di Marco
+ */
+
+/*
+ *  This file is part of SIN.
+ *
+ *  SIN is free software; you can redistribute it and/or modify it under the
+ *  terms of the GNU General Public License as published by the Free Software
+ *  Foundation; version 2 of the License.
+ *
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
+ *  details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#ifndef DEBUG_H
+#define DEBUG_H
+
+#ifdef SIN_DEBUG
+extern int debug;
+#define set_debug(val) debug = (val)
+#define printd(fmt...) if (unlikely(debug)) { printk("SIN: " fmt); }
+#else
+#define SORRY "SIN: debugging support was disabled at compile time, sorry!\n"
+
+#define set_debug(val) if (val) { printk(KERN_DEBUG SORRY); }
+#define printd(fmt...)
+#endif
+
+#endif /* DEBUG_H */
diff -ur --new-file SIN/etc/sin/rules.sh SIN-NEW/etc/sin/rules.sh
--- SIN/etc/sin/rules.sh	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/etc/sin/rules.sh	2007-01-25 14:16:30.000000000 +0100
@@ -0,0 +1,43 @@
+#!/bin/bash
+
+set $*
+
+case "${HINT}" in
+    resume)
+#	if [ -f /dev/shm/blanked ] ; then
+#	    XAUTHORITY=/home/`/bin/ps x | /bin/grep tty11 | /bin/grep auth | /usr/bin/cut -d / -f 3`/.Xauthority xset -display :0 dpms force on
+#	    /usr/bin/smartdimmer -f `cat /dev/shm/light` -e ${UNBLANK_SPEED}
+#	    rm -f /dev/shm/light
+#	    rm -f /dev/shm/blanked
+#	else
+#	    /usr/bin/smartdimmer -f `cat /dev/shm/light` -e ${FADING_SPEED}
+#	    rm -f /dev/shm/light
+#	fi
+
+	logger "resuming..."
+	;;
+
+    dim)
+#	/usr/bin/smartdimmer -g | /usr/bin/cut -d ':' -f 2 > /dev/shm/light
+#	/usr/bin/smartdimmer -f 1 -e ${FADING_SPEED}
+
+	logger "dimming..."
+	;;
+
+    blank)
+#	XAUTHORITY=/home/`/bin/ps x | /bin/grep tty11 | /bin/grep auth | /usr/bin/cut -d / -f 3`/.Xauthority xset -display :0 dpms force off
+#	touch /dev/shm/blanked
+
+	logger "blanking..."
+	;;
+
+    sleep)
+#	echo mem >/sys/power/state
+
+	logger "suspending..."
+	;;
+
+    *)
+	logger "SIN hint unhandled: ${HINT}"
+	;;
+esac
diff -ur --new-file SIN/etc/sin/setup.sh SIN-NEW/etc/sin/setup.sh
--- SIN/etc/sin/setup.sh	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/etc/sin/setup.sh	2007-01-25 14:13:59.000000000 +0100
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set $*
+
+STATE="`cat /proc/acpi/ac_adapter/ACAD/state | grep off-line`"
+
+if [ -n "${STATE}" ] ; then
+    cat /etc/sin/table.bat >/sys/class/misc/sin/table
+else
+    cat /etc/sin/table.ac >/sys/class/misc/sin/table
+fi
diff -ur --new-file SIN/etc/sin/table.ac SIN-NEW/etc/sin/table.ac
--- SIN/etc/sin/table.ac	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/etc/sin/table.ac	2007-01-25 14:14:15.000000000 +0100
@@ -0,0 +1,8 @@
+0
+2 3
+0 1
+0
+resume
+1200 dim
+3500 blank
+27000 sleep
diff -ur --new-file SIN/etc/sin/table.bat SIN-NEW/etc/sin/table.bat
--- SIN/etc/sin/table.bat	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/etc/sin/table.bat	2007-01-25 14:14:11.000000000 +0100
@@ -0,0 +1,8 @@
+0
+2 3
+0 1
+0
+resume
+500 dim
+900 blank
+3000 sleep
diff -ur --new-file SIN/etc/udev/rules.d/99-sin.rules SIN-NEW/etc/udev/rules.d/99-sin.rules
--- SIN/etc/udev/rules.d/99-sin.rules	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/etc/udev/rules.d/99-sin.rules	2007-01-25 14:13:32.000000000 +0100
@@ -0,0 +1,2 @@
+KERNEL=="sin", SUBSYSTEM=="misc", ACTION=="add", RUN+="/etc/sin/setup.sh"
+KERNEL=="sin", SUBSYSTEM=="misc", ACTION=="change", RUN+="/etc/sin/rules.sh"
diff -ur --new-file SIN/gentable.sh SIN-NEW/gentable.sh
--- SIN/gentable.sh	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/gentable.sh	2007-01-25 14:11:05.000000000 +0100
@@ -0,0 +1,146 @@
+#!/bin/bash
+
+# This file is part of SIN.
+#
+# SIN is free software; you can redistribute it and/or modify it under the
+# terms of the GNU General Public License as published by the Free Software
+# Foundation; version 2 of the License.
+#
+# SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
+# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License along with
+# SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin St,
+# Fifth Floor, Boston, MA 02110-1301 USA
+
+function input {
+    echo -n -e "$1 "
+    read -t 25 -r $2
+
+    if [ "$?" == "1" ]; then
+	echo -e "DEFAULT VALUE"
+    fi
+}
+
+if (( $# == 0 )); then
+   echo "$0 <table>"
+   exit
+fi
+
+if [ ! -d "/sys/class/misc/sin" ]; then
+    echo "/sys/class/misc/sin not found, has sinmod been loaded?"
+    exit
+fi
+
+cat <<EOF
+
+SIN constantly monitors the input devices watching for user activity. This
+option lets you choose which device have to be monitored. You must specify at
+least one device and must not specify duplicates.
+
+EOF
+
+echo -e "Specify the the input devices you want to monitor from the list below:\n"
+cat /sys/class/misc/sin/input
+
+echo
+input "Please digit the corresponding numbers separated by spaces" devs
+
+if [ -z "${devs}" ]; then
+    devs="0 1"
+fi
+
+devices=(${devs})
+
+cat <<EOF
+
+SIN produces events based on rules. Each rule is a pair composed by a <target>
+and a <hint> string. The <target> field is a timeout in tenth of seconds
+specifying the minimum period of user inactivity needed to trigger the
+rule. When a rule triggers, an uevent is generated with the string
+"HINT=<hint>" in its environment.
+
+For example, the rule "600 blank" produces the uevent "HINT=blank" when SIN
+recognizes one minute of user inactivity.
+
+Please specify each rule as a space-separated pair on a separate line; when
+finished, just press enter.
+
+EOF
+
+declare -i i
+
+for (( i = 0; ; i++ )); do
+    input "Rule ${i}?" rule
+
+    if [ -z "${rule}" ] ; then
+	break;
+    fi
+
+    rules[${i}]=${rule}
+done
+
+if (( ${i} == 0 )); then
+    rules[0]="600 dim"
+    rules[1]="1200 blank"
+    rules[2]="12000 sleep"
+    i=3
+fi
+
+cat <<EOF
+
+A special event has been provided to simplify using SIN as a screen-blanker. It
+will be generated as soon as some user activity is detected, but only after one
+or more rules have been triggered.
+
+EOF
+
+input "Special event hint?" resume
+
+if [ -z "${resume}" ]; then
+    resume="resume"
+fi
+
+declare -i j=${i}-1
+
+cat <<EOF
+
+Often an SIN event results in suspending or hibernating actions, requiring user
+interaction to wake-up the system. Unfortunately that interaction occurs when
+SIN, as well as the kernel, cannot capture it. As a consequence, no event will
+ever be generated and the system will remain in the state associated with the
+next-to-last rule (e.g. blanked screen, wireless powered off, etc.). The next
+option allows you to request a special event, restarting the rule-list
+evaluation from an arbitrary position.  Possible value ranges are described
+below:
+
+    [0, ${j}]	=> jump to the given rule
+    ${i}		=> sleep forever awaiting for user interaction
+
+EOF
+
+input "Wrap value?" wrap
+
+if [ -z "${wrap}" ]; then
+    wrap="0"
+fi
+
+echo -e "0\n${#devices[@]} ${#rules[@]}\n${devices[@]}\n${wrap}\n${resume}" > $1
+
+for (( i = 0; ${i}<${#rules[@]}; i++ )); do
+    echo "${rules[${i}]}" >> $1
+done
+
+cat <<EOF
+
+All done. Now you can try your newly generated table as follows:
+
+# modprobe sinmod
+# echo $1 >/sys/class/misc/sin/table
+
+An "Invalid argument" error indicates a mismatch in the table file, usually due
+to specifying an invalid input device. In that case, restart from scratch,
+double checking your inputs. Have fun!
+
+EOF
diff -ur --new-file SIN/input_enumerator.c SIN-NEW/input_enumerator.c
--- SIN/input_enumerator.c	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/input_enumerator.c	2007-01-25 14:07:39.000000000 +0100
@@ -0,0 +1,198 @@
+/*
+ *  Copyright (C) 2007 Alessandro Di Marco
+ */
+
+/*
+ *  This file is part of SIN.
+ *
+ *  SIN is free software; you can redistribute it and/or modify it under the
+ *  terms of the GNU General Public License as published by the Free Software
+ *  Foundation; version 2 of the License.
+ *
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
+ *  details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/input.h>
+
+#include "input_enumerator.h"
+
+static struct input_devices *id;
+static int idsize;
+
+static char *page;
+static size_t size;
+
+int get_devices(void)
+{
+	return idsize;
+}
+
+size_t get_devices_desc(char **buf)
+{
+	*buf = page;
+	return size;
+}
+
+void fill_input_device(struct input_device_id *idi, int device)
+{
+	idi->flags = MATCH_MODEL;
+
+	idi->bustype = id[device].bustype;
+	idi->vendor = id[device].vendor;
+	idi->product = id[device].product;
+	idi->version = id[device].version;
+}
+
+static struct input_handle *input_store(struct input_handler *handler,
+					struct input_dev *dev,
+					const struct input_device_id *idi)
+{
+	if (dev->name || dev->phys || dev->uniq) {
+		struct input_devices *idev = &id[idsize++];
+
+		idev->bustype = dev->id.bustype;
+		idev->vendor = dev->id.vendor;
+		idev->product = dev->id.product;
+		idev->version = dev->id.version;
+	}
+
+	return NULL;
+}
+
+static struct input_handle *input_show(struct input_handler *handler,
+				       struct input_dev *dev,
+				       const struct input_device_id *idi)
+{
+	const int left = PAGE_SIZE - size;
+
+	int flags = 0;
+	int err;
+
+	flags |= dev->name ? 1 : 0;
+	flags |= dev->phys ? 2 : 0;
+	flags |= dev->uniq ? 4 : 0;
+
+	switch (flags) {
+	case 7:
+		err = snprintf(&page[size], left,
+			       "%d: %s [%s #%s]\n",
+			       idsize, dev->name, dev->phys, dev->uniq);
+		break;
+
+	case 6:
+		err = snprintf(&page[size], left,
+			       "%d: [%s #%s]\n",
+			       idsize, dev->phys, dev->uniq);
+		break;
+
+	case 5:
+		err = snprintf(&page[size], left,
+			       "%d: %s [#%s]\n",
+			       idsize, dev->name, dev->uniq);
+		break;
+
+	case 4:
+		err = snprintf(&page[size], left,
+			       "%d: [#%s]\n",
+			       idsize, dev->uniq);
+		break;
+
+	case 3:
+		err = snprintf(&page[size], left,
+			       "%d: %s [%s]\n",
+			       idsize, dev->name, dev->phys);
+		break;
+
+	case 2:
+		err = snprintf(&page[size], left,
+			       "%d: [%s]\n",
+			       idsize, dev->phys);
+		break;
+
+	case 1:
+		err = snprintf(&page[size], left,
+			       "%d: %s\n",
+			       idsize, dev->name);
+		break;
+
+	default:
+		goto skip;
+	}
+
+	idsize++;
+
+	if (err >= left) {
+		err = left;
+	}
+
+	if (err > 0) {
+		size += err;
+	}
+
+skip:
+	return NULL;
+}
+
+int input_enum(void)
+{
+	int err = -ENOMEM;
+
+	const struct input_device_id idi[] = {
+		{ .driver_info = 1 },	/* matches all devices */
+		{ },
+	};
+
+	struct input_handler ih = {
+		.name =		"input enumerator",
+		.id_table =	idi,
+	};
+
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!page) {
+		goto out;
+	}
+
+	ih.connect = input_show;
+	(void) input_register_handler(&ih);
+
+	if (!idsize) {
+		printk(KERN_NOTICE "no input devices found\n");
+		err = -ENODEV;
+		goto cleanout;
+	}
+
+	id = kmalloc(idsize * sizeof (struct input_devices), GFP_KERNEL);
+
+	idsize = 0;
+
+	if (!id) {
+		goto cleanout;
+	}
+
+	ih.connect = input_store;
+	(void) input_register_handler(&ih);
+
+	return 0;
+
+cleanout:
+	kfree(page);
+out:
+	return err;
+}
+
+void free_input_enum(void)
+{
+	if (idsize) {
+		idsize = 0;
+		kfree(id);
+		kfree(page);
+	}
+}
diff -ur --new-file SIN/input_enumerator.h SIN-NEW/input_enumerator.h
--- SIN/input_enumerator.h	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/input_enumerator.h	2007-01-25 14:07:39.000000000 +0100
@@ -0,0 +1,47 @@
+/*
+ *  Copyright (C) 2007 Alessandro Di Marco
+ */
+
+/*
+ *  This file is part of SIN.
+ *
+ *  SIN is free software; you can redistribute it and/or modify it under the
+ *  terms of the GNU General Public License as published by the Free Software
+ *  Foundation; version 2 of the License.
+ *
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
+ *  details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#ifndef INPUT_ENUMERATOR_H
+#define INPUT_ENUMERATOR_H
+
+#include <linux/input.h>
+
+struct input_devices {
+	__u16 bustype;
+	__u16 vendor;
+	__u16 product;
+	__u16 version;
+};
+
+#define MATCH_MODEL (INPUT_DEVICE_ID_MATCH_BUS		\
+		     |INPUT_DEVICE_ID_MATCH_VENDOR	\
+		     |INPUT_DEVICE_ID_MATCH_PRODUCT	\
+		     |INPUT_DEVICE_ID_MATCH_VERSION)
+
+extern int get_devices(void);
+extern size_t get_devices_desc(char **buf);
+
+extern void fill_input_device(struct input_device_id *idi, int i);
+
+extern int input_enum(void);
+extern void free_input_enum(void);
+
+#endif /* INPUT_ENUMERATOR_H */
diff -ur --new-file SIN/sin.c SIN-NEW/sin.c
--- SIN/sin.c	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/sin.c	2007-01-25 14:07:39.000000000 +0100
@@ -0,0 +1,390 @@
+/*
+ *  Copyright (C) 2007 Alessandro Di Marco
+ */
+
+/*
+ *  This file is part of SIN.
+ *
+ *  SIN is free software; you can redistribute it and/or modify it under the
+ *  terms of the GNU General Public License as published by the Free Software
+ *  Foundation; version 2 of the License.
+ *
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
+ *  details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/mutex.h>
+#include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+
+#include "debug.h"
+
+#include "sin.h"
+#include "table.h"
+#include "sysfs.h"
+#include "input_enumerator.h"
+
+MODULE_AUTHOR("Alessandro Di Marco <dmr@gmx.it>");
+MODULE_DESCRIPTION("System Inactivity Notifier");
+MODULE_LICENSE("GPL v2");
+
+MODULE_VERSION("1.6");
+
+#ifdef SIN_DEBUG
+int debug;
+#endif
+
+static struct user_activity uact = {
+	.lock = SPIN_LOCK_UNLOCKED,
+};
+
+static unsigned long status;
+
+static struct timer_list timer;
+static int shutdown;
+
+static struct input_handler ih;
+
+static DEFINE_MUTEX(runlock);
+static int running;
+
+static struct kobject *kobj;
+
+inline unsigned long simulate_activity(void)
+{
+	return register_activity(&uact);
+}
+
+inline void signal_interaction(void)
+{
+	if (unlikely(test_bit(RULE_LOCK, &status))) {
+		set_bit(RULE_MARK, &status);
+	} else if (unlikely(test_and_clear_bit(RULE_TRIG, &status))) {
+		unsigned long next;
+
+		WARN_ON(test_bit(RULE_OVER, &status) && timer_pending(&timer));
+
+		next = occasionally_generate_event(kobj, last_activity(&uact));
+
+		if (!shutdown) {
+			printd("mod_timer() last = %lu, next = %lu\n",
+			       last_activity(&uact) / HZ, next / HZ);
+
+			if (likely(mod_timer(&timer, next))) {
+				WARN_ON(test_bit(RULE_OVER, &status));
+			}
+		}
+
+		clear_bit(RULE_WRAP, &status);
+		clear_bit(RULE_OVER, &status);
+	}
+}
+
+inline void simulate_event(void)
+{
+	(void) simulate_activity();
+	signal_interaction();
+}
+
+static void event(struct input_handle *handle,
+		  unsigned int type, unsigned int code, int value)
+{
+	printd("user interaction at %lu\n", jiffies / HZ);
+	simulate_event();
+}
+
+static struct input_handle *connect(struct input_handler *handler,
+				    struct input_dev *dev,
+				    const struct input_device_id *id)
+{
+	struct input_handle *handle;
+
+	if (!(handle = kzalloc(sizeof(struct input_handle), GFP_KERNEL))) {
+		return NULL;
+	}
+
+	handle->handler = handler;
+	handle->dev = dev;
+	handle->name = MODULE_NAME;
+
+	input_open_device(handle);
+
+	return handle;
+}
+
+static void disconnect(struct input_handle *handle)
+{
+	input_close_device(handle);
+	kfree(handle);
+}
+
+void timer_fn(unsigned long data)
+{
+	if (!shutdown) {
+		unsigned long next;
+
+		printd(">>>>>>>>>>>> timer_fn()\n");
+
+		set_bit(RULE_LOCK, &status);
+
+		next = timely_generate_event(kobj,
+					     last_activity(&uact), &status);
+
+		clear_bit(RULE_LOCK, &status);
+
+		if (unlikely(test_and_clear_bit(RULE_MARK, &status))) {
+			signal_interaction();
+		}
+
+		if (!test_bit(RULE_OVER, &status)) {
+			printd("add_timer() now %lu, timer set to %lu\n",
+			       jiffies / HZ, next / HZ);
+
+			timer.expires = next;
+			add_timer(&timer);
+		}
+
+		printd("timer_fn() >>>>>>>>>>>>\n");
+	}
+}
+
+int start_monitor(struct input_device_id *idi)
+{
+	int err;
+
+	mutex_lock(&runlock);
+
+	status = 0;
+
+	ih.event = event;
+	ih.connect = connect;
+	ih.disconnect =	disconnect;
+	ih.name = MODULE_NAME;
+	ih.id_table = idi;
+
+	err = input_register_handler(&ih);
+	if  (err < 0) {
+		return err;
+	}
+
+	setup_timer(&timer, timer_fn, 0);
+
+	timer.expires =
+		timely_generate_event(kobj, register_activity(&uact), &status);
+
+	shutdown = 0;
+	add_timer(&timer);
+
+	running = 1;
+
+	mutex_unlock(&runlock);
+
+	return 0;
+}
+
+void stop_monitor(void)
+{
+	mutex_lock(&runlock);
+
+	if (running) {
+		shutdown = 1;
+		del_timer_sync(&timer);
+
+		input_unregister_handler(&ih);
+		kfree(ih.id_table);
+
+		signal_interaction();
+		cleanup_table();
+
+		running = 0;
+	}
+
+	mutex_unlock(&runlock);
+}
+
+static const struct file_operations sin_miscfops = {
+	.owner		= THIS_MODULE,
+};
+
+static struct miscdevice sin_miscdev = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= MODULE_NAME,
+	.fops		= &sin_miscfops,
+};
+
+static int __devinit sin_probe(struct platform_device *dev)
+{
+	int err;
+
+	err = misc_register(&sin_miscdev);
+	if (err < 0) {
+		printk(KERN_ERR "SIN: miscdev initialization failed\n");
+		goto out;
+	}
+
+	err = input_enum();
+	if (err < 0) {
+		printk(KERN_ERR "SIN: input enumeration failed\n");
+		goto cleanout1;
+	}
+
+	err = start_sysfs(sin_miscdev.this_device);
+	if (err < 0) {
+		printk(KERN_ERR "SIN: sysfs initialization failed\n");
+		goto cleanout2;
+	}
+
+	kobj = &sin_miscdev.this_device->kobj;
+
+	printk(KERN_DEBUG "System Inactivity Notifier 1.6 - (c) Alessandro Di Marco <dmr@gmx.it>\n");
+
+	return 0;
+
+cleanout2:
+	free_input_enum();
+cleanout1:
+	misc_deregister(&sin_miscdev);
+out:
+	return err;
+}
+
+static int __devexit sin_remove(struct platform_device *dev)
+{
+	stop_sysfs();
+	free_input_enum();
+
+	(void) stop_monitor();
+
+	misc_deregister(&sin_miscdev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static unsigned long left, right, now;
+
+static int sin_suspend(struct platform_device *dev, pm_message_t state)
+{
+	printd("suspend() >>>>>>>>>>>>\n");
+
+	if (running) {
+		printd("stopping timer!\n");
+
+		shutdown = 1;
+		del_timer(&timer);
+
+		now = jiffies;
+
+		left = (long) now - (long) last_activity(&uact);
+		right = (long) timer.expires - (long) now;
+
+		printd("left %lu, now %lu, right %lu\n",
+		       left / HZ, now / HZ, right / HZ);
+	} else {
+		printd("not running!\n");
+	}
+
+	printd(">>>>>>>>>>>> suspend()\n");
+
+	return 0;
+}
+
+static int sin_resume(struct platform_device *dev)
+{
+	printd("resume() >>>>>>>>>>>>\n");
+
+	shutdown = 0;
+
+	if (running) {
+		if (!test_bit(RULE_OVER, &status)) {
+			printd("restarting timer!\n");
+
+			if (test_and_clear_bit(RULE_WRAP, &status)) {
+				printd("wrapped rule found\n");
+				special_event(kobj);
+			}
+
+			now = trim_activity(&uact, left);
+
+			timer.expires = now + right;
+
+			printd("last = %lu, now is %lu, timer set to %lu\n",
+			       last_activity(&uact) / HZ,
+			       now / HZ, timer.expires / HZ);
+
+			add_timer(&timer);
+		} else {
+			printd("rule over found\n");
+		}
+	} else {
+		printd("not running!\n");
+	}
+
+	printd(">>>>>>>>>>>> resume()\n");
+
+	return 0;
+}
+#else
+#define sin_suspend NULL
+#define sin_resume NULL
+#endif
+
+static struct platform_driver sin_driver = {
+	.driver		= {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= sin_probe,
+	.remove		= __devexit_p(sin_remove),
+	.suspend	= sin_suspend,
+	.resume		= sin_resume,
+};
+
+static struct platform_device *sin_platform_device;
+
+static int __init sih_init(void)
+{
+	int err;
+
+	err = platform_driver_register(&sin_driver);
+	if (err < 0) {
+		goto out;
+	}
+
+	sin_platform_device = platform_device_alloc(MODULE_NAME, -1);
+	if (!sin_platform_device) {
+		err = -ENOMEM;
+		goto cleanout1;
+	}
+
+	err = platform_device_add(sin_platform_device);
+	if (err < 0) {
+		goto cleanout2;
+	}
+
+	return 0;
+
+cleanout2:
+	platform_device_put(sin_platform_device);
+cleanout1:
+	platform_driver_unregister(&sin_driver);
+out:
+	return err;
+}
+
+static void __exit sih_exit(void)
+{
+	platform_device_unregister(sin_platform_device);
+	platform_driver_unregister(&sin_driver);
+}
+
+module_init(sih_init);
+module_exit(sih_exit);
diff -ur --new-file SIN/sin.h SIN-NEW/sin.h
--- SIN/sin.h	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/sin.h	2007-01-25 14:07:39.000000000 +0100
@@ -0,0 +1,82 @@
+/*
+ *  Copyright (C) 2007 Alessandro Di Marco
+ */
+
+/*
+ *  This file is part of SIN.
+ *
+ *  SIN is free software; you can redistribute it and/or modify it under the
+ *  terms of the GNU General Public License as published by the Free Software
+ *  Foundation; version 2 of the License.
+ *
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
+ *  details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#ifndef SIN_H
+#define SIN_H
+
+#include <linux/input.h>
+
+#define MODULE_NAME "sin"
+
+#define RULE_TRIG 0 /* a rule has been triggered */
+#define RULE_WRAP 1 /* rule-evaluation has been restarted */
+#define RULE_LOCK 2 /* evaluating rule-list, don't mess */
+#define RULE_MARK 3 /* event seen while evaluating rule-list */
+#define RULE_OVER 4 /* no more rules, please disconnect timer */
+
+struct user_activity {
+	spinlock_t lock;
+	unsigned long last;
+};
+
+static inline unsigned long register_activity(struct user_activity *uact)
+{
+	unsigned long last;
+
+	spin_lock(&uact->lock);
+	last = uact->last = jiffies;
+	spin_unlock(&uact->lock);
+
+	return last;
+}
+
+static inline unsigned long last_activity(struct user_activity *uact)
+{
+	unsigned long last;
+
+	spin_lock(&uact->lock);
+	last = uact->last;
+	spin_unlock(&uact->lock);
+
+	return last;
+}
+
+static inline unsigned long trim_activity(struct user_activity *uact,
+					  unsigned long offset)
+{
+	unsigned long last;
+
+	spin_lock(&uact->lock);
+	last = jiffies;
+	uact->last = (long) last - (long) offset;
+	spin_unlock(&uact->lock);
+
+	return last;
+}
+
+extern unsigned long simulate_activity(void);
+extern void signal_interaction(void);
+extern void simulate_event(void);
+
+extern int start_monitor(struct input_device_id *idi);
+extern void stop_monitor(void);
+
+#endif /* SIN_H */
diff -ur --new-file SIN/sysfs.c SIN-NEW/sysfs.c
--- SIN/sysfs.c	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/sysfs.c	2007-01-25 14:07:39.000000000 +0100
@@ -0,0 +1,122 @@
+/*
+ *  Copyright (C) 2007 Alessandro Di Marco
+ */
+
+/*
+ *  This file is part of SIN.
+ *
+ *  SIN is free software; you can redistribute it and/or modify it under the
+ *  terms of the GNU General Public License as published by the Free Software
+ *  Foundation; version 2 of the License.
+ *
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
+ *  details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/device.h>
+#include <linux/err.h>
+
+#include "sin.h"
+#include "table.h"
+#include "sysfs.h"
+#include "input_enumerator.h"
+
+static ssize_t show_input(struct device *dev,
+			  struct device_attribute *attr, char *pbuf)
+{
+	char *buf;
+	size_t size;
+
+	size = get_devices_desc(&buf);
+
+	memcpy(pbuf, buf, size);
+
+	return size;
+}
+
+static DEVICE_ATTR(input, 0444, show_input, NULL);
+
+static ssize_t show_table(struct device *dev,
+			  struct device_attribute *attr, char *pbuf)
+{
+	char *buf;
+	size_t size;
+
+	size = pull_table(&buf);
+	if (buf) {
+		if (size > PAGE_SIZE) {
+			size = PAGE_SIZE;
+		}
+
+		memcpy(pbuf, buf, size);
+		pbuf[size] = '\0';
+	}
+
+	return size;
+}
+
+static ssize_t store_table(struct device *dev, struct device_attribute *attr,
+			   const char *pbuf, size_t count)
+{
+	return push_table(pbuf, count);
+}
+
+static DEVICE_ATTR(table, 0644, show_table, store_table);
+
+static ssize_t store_interact(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *pbuf, size_t count)
+{
+	simulate_event();
+	return count;
+}
+
+static DEVICE_ATTR(interact, 0200, NULL, store_interact);
+
+static struct device *sindev;
+
+int start_sysfs(struct device *dev)
+{
+	int err;
+
+	sindev = dev;
+
+	err = device_create_file(sindev, &dev_attr_input);
+	if (err < 0) {
+		goto out;
+	}
+
+	err = device_create_file(sindev, &dev_attr_table);
+	if (err < 0) {
+		goto cleanout1;
+	}
+
+	err = device_create_file(sindev, &dev_attr_interact);
+	if (err < 0) {
+		goto cleanout2;
+	}
+
+	return 0;
+
+cleanout2:
+	device_remove_file(sindev, &dev_attr_table);
+cleanout1:
+	device_remove_file(sindev, &dev_attr_input);
+out:
+	return err;
+}
+
+void stop_sysfs(void)
+{
+	device_remove_file(sindev, &dev_attr_interact);
+	device_remove_file(sindev, &dev_attr_table);
+	device_remove_file(sindev, &dev_attr_input);
+}
diff -ur --new-file SIN/sysfs.h SIN-NEW/sysfs.h
--- SIN/sysfs.h	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/sysfs.h	2007-01-25 14:07:39.000000000 +0100
@@ -0,0 +1,28 @@
+/*
+ *  Copyright (C) 2007 Alessandro Di Marco
+ */
+
+/*
+ *  This file is part of SIN.
+ *
+ *  SIN is free software; you can redistribute it and/or modify it under the
+ *  terms of the GNU General Public License as published by the Free Software
+ *  Foundation; version 2 of the License.
+ *
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
+ *  details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#ifndef SYSFS_H
+#define SYSFS_H
+
+extern int start_sysfs(struct device *dev);
+extern void stop_sysfs(void);
+
+#endif /* SYSFS_H */
diff -ur --new-file SIN/table.c SIN-NEW/table.c
--- SIN/table.c	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/table.c	2007-01-25 14:07:39.000000000 +0100
@@ -0,0 +1,353 @@
+/*
+ *  Copyright (C) 2007 Alessandro Di Marco
+ */
+
+/*
+ *  This file is part of SIN.
+ *
+ *  SIN is free software; you can redistribute it and/or modify it under the
+ *  terms of the GNU General Public License as published by the Free Software
+ *  Foundation; version 2 of the License.
+ *
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
+ *  details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/sort.h>
+#include <linux/ctype.h>
+
+#include "debug.h"
+
+#include "sin.h"
+#include "uniq.h"
+#include "table.h"
+#include "input_enumerator.h"
+
+static struct table rt;
+static int next_rule;
+
+static inline void generate_event(struct kobject *kobj, int rnum)
+{
+	struct rule *rule = &rt.rules[rnum];
+
+	char *envp_ext[] = {
+		rule->hint,
+		NULL
+	};
+
+	printd("sending hint '%s'\n", rule->hint + sizeof HINT - 1);
+
+	if (kobject_uevent_env(kobj, KOBJ_CHANGE, envp_ext) < 0) {
+		printk(KERN_ERR "SIN: hint '%s' failed\n",
+		       rule->hint + sizeof HINT - 1);
+	}
+}
+
+inline void special_event(struct kobject *kobj)
+{
+	generate_event(kobj, rt.rnum);
+}
+
+unsigned long occasionally_generate_event(struct kobject *kobj,
+					  unsigned long last)
+{
+	special_event(kobj);
+	return last + rt.rules[next_rule = 0].target;
+}
+
+unsigned long timely_generate_event(struct kobject *kobj,
+				    unsigned long last, unsigned long *status)
+{
+	printd("last %lu [status %lu], now %lu -> next target is %lu (%d)\n",
+	       last / HZ, *status, jiffies / HZ,
+	       (last + rt.rules[next_rule].target) / HZ, next_rule);
+
+	for (; next_rule < rt.rnum &&
+		     time_after_eq(jiffies, last + rt.rules[next_rule].target);
+	     next_rule++) {
+		if (unlikely(test_and_clear_bit(RULE_WRAP, status))) {
+			printd("passive wrap, user forgot to interact!\n");
+			special_event(kobj);
+		}
+
+		generate_event(kobj, next_rule);
+		set_bit(RULE_TRIG, status);
+	}
+
+	if (next_rule == rt.rnum) {
+		if (rt.rwrap < rt.rnum) {
+			printd("last rule, restarting from %d\n", rt.rwrap);
+
+			next_rule = rt.rwrap;
+			set_bit(RULE_WRAP, status);
+
+			last = simulate_activity();
+		} else {
+			printd("last rule, disconnecting the timer\n");
+			set_bit(RULE_OVER, status);
+		}
+	}
+
+	return last + rt.rules[next_rule].target;
+}
+
+#define parse_num(endp) ({						\
+			const char *cp = (endp);			\
+									\
+			while (*cp && isspace(*cp)) {			\
+				++cp;					\
+			}						\
+									\
+			simple_strtol(cp, (char **) &(endp), 10);	\
+		})
+
+#define hint_value(key, hint) ((hint) + sizeof (key) - 1)
+
+#define parse_hint(key, endp) ({					\
+			const char *l, *r;				\
+			char *h;					\
+									\
+			l = endp;					\
+									\
+			while (*l && isspace(*l)) {			\
+				++l;					\
+			}						\
+									\
+			r = l;						\
+									\
+			while (isalnum(*r)) {				\
+				++r;					\
+			}						\
+									\
+			(endp) = r;					\
+									\
+			h = kmalloc(hint_value(key, r - l + 1),		\
+				    GFP_KERNEL);			\
+			if (h) {					\
+				memcpy(h, (key), hint_value(key, 0));	\
+				memcpy(hint_value(key, h), l, r - l);	\
+									\
+				h[hint_value(key, r - l)] = '\0';	\
+			}						\
+									\
+			h;						\
+		})
+
+static int cmp(const void *l, const void *r)
+{
+	long lt = ((struct rule *) l)->target;
+	long rt = ((struct rule *) r)->target;
+	long dd = lt - rt;
+
+	return dd < 0 ? -1 : dd > 0 ? 1 : 0;
+}
+
+static void swap(void *l, void *r, int size)
+{
+	struct rule t = *((struct rule *) l);
+
+	*((struct rule *) l) = *((struct rule *) r);
+	*((struct rule *) r) = t;
+}
+
+static char *table;
+static size_t size;
+
+static int regen_table(void)
+{
+	char *t;
+	int i;
+
+	kfree(table);
+
+	table = t = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!table) {
+		return -EFAULT;
+	}
+
+	t += sprintf(t, "%d\n%d %d\n", rt.debug, rt.dnum, rt.rnum);
+
+	for (i = 0; i < rt.dnum; i++) {
+		t += sprintf(t, "%d ", rt.devices[i]);
+	}
+
+	t--;
+
+	t += sprintf(t, "\n%d\n%s\n",
+		     rt.rwrap,
+		     hint_value(HINT, rt.rules[rt.rnum].hint));
+
+	for (i = 0; i < rt.rnum; i++) {
+		t += sprintf(t, "%d %s\n",
+			     jiffies_to_msecs(rt.rules[i].target) / 100,
+			     hint_value(HINT, rt.rules[i].hint));
+	}
+
+	size = t - table;
+
+	return 0;
+}
+
+int push_table(const char *buf, unsigned long count)
+{
+	struct table nrt;
+	struct input_device_id *idi;
+	struct uniq uniq;
+
+	int devices;
+
+	int i, err = -ENOMEM;
+
+	devices = get_devices();
+
+	nrt.debug = parse_num(buf);
+
+	nrt.dnum = parse_num(buf);
+	nrt.rnum = parse_num(buf);
+
+	if (out_of_range(0, nrt.dnum, devices)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (nrt.rnum <= 0) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	nrt.devices = kmalloc(nrt.dnum * sizeof (int), GFP_KERNEL);
+	if (!nrt.devices) {
+		goto out;
+	}
+
+	nrt.rules = kmalloc((nrt.rnum + 1) * sizeof (struct rule), GFP_KERNEL);
+	if (!nrt.rules) {
+		goto cleanout1;
+	}
+
+	if (uniq_alloc(&uniq, devices) < 0) {
+		goto cleanout2;
+	}
+
+	for (i = 0; i < nrt.dnum; i++) {
+		nrt.devices[i] = parse_num(buf);
+		if (uniq_check(&uniq, nrt.devices[i])) {
+			break;
+		}
+	}
+
+	uniq_free(&uniq);
+
+	if (i < nrt.dnum) {
+		err = -EINVAL;
+		goto cleanout2;
+	}
+
+	nrt.rwrap = parse_num(buf);
+	if (out_of_range(0, nrt.rwrap, nrt.rnum + 1)) {
+		err = -EINVAL;
+		goto cleanout2;
+	}
+
+	nrt.rules[nrt.rnum].target = MAX_JIFFY_OFFSET;
+	nrt.rules[nrt.rnum].hint = parse_hint(HINT, buf);
+
+	for (i = 0; i < nrt.rnum; i++) {
+		unsigned int msecs;
+
+		msecs = 100 * parse_num(buf);
+		if (out_of_range(0, msecs, 172800000 /* 48 hrs */)) {
+			err = -EINVAL;
+			goto cleanout2;
+		}
+
+		nrt.rules[i].target = msecs_to_jiffies(msecs);
+		nrt.rules[i].hint = parse_hint(HINT, buf);
+	}
+
+	sort(nrt.rules, nrt.rnum, sizeof (struct rule), cmp, swap);
+
+	if (!tablecmp(&rt, &nrt)) {
+		err = count;
+		goto cleanout2;
+	}
+
+	stop_monitor();
+
+	idi = kzalloc((nrt.dnum + 1) *
+		      sizeof (struct input_device_id), GFP_KERNEL);
+	if (!idi) {
+		goto cleanout2;
+	}
+
+	for (i = 0; i < nrt.dnum; i++) {
+		fill_input_device(&idi[i], nrt.devices[i]);
+	}
+
+	memcpy(&rt, &nrt, sizeof (struct table));
+
+	err = regen_table();
+	if (err < 0) {
+		goto cleanout3;
+	}
+
+	set_debug(rt.debug);
+
+	err = start_monitor(idi);
+	if (err < 0) {
+		goto cleanout3;
+	}
+
+	return count;
+
+cleanout3:
+	kfree(idi);
+	cleanup_table();
+	goto out;
+
+cleanout2:
+	kfree(nrt.rules);
+cleanout1:
+	kfree(nrt.devices);
+out:
+	return err;
+}
+
+size_t pull_table(char **buf)
+{
+	if (!table) {
+		size = sizeof TABLE_HELP;
+
+		table = kmalloc(size, GFP_KERNEL);
+		if (table) {
+			memcpy(table, TABLE_HELP, size);
+		} else {
+			size = 0;
+		}
+	}
+
+	*buf = table;
+
+	return size;
+}
+
+void cleanup_table(void)
+{
+	kfree(rt.devices);
+	kfree(rt.rules);
+
+	memset(&rt, 0, sizeof (struct table));
+
+	next_rule = 0;
+
+	kfree(table);
+	table = NULL;
+}
diff -ur --new-file SIN/table.h SIN-NEW/table.h
--- SIN/table.h	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/table.h	2007-01-25 14:07:39.000000000 +0100
@@ -0,0 +1,79 @@
+/*
+ *  Copyright (C) 2007 Alessandro Di Marco
+ */
+
+/*
+ *  This file is part of SIN.
+ *
+ *  SIN is free software; you can redistribute it and/or modify it under the
+ *  terms of the GNU General Public License as published by the Free Software
+ *  Foundation; version 2 of the License.
+ *
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
+ *  details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#ifndef TABLE_H
+#define TABLE_H
+
+#define HINT "HINT="
+
+struct rule {
+	unsigned long target; /* jiffies */
+	char *hint;
+};
+
+struct table {
+	int debug;
+	int dnum, rnum;
+	int *devices;
+	int rwrap;
+	struct rule *rules;
+};
+
+static inline int tablecmp(struct table *l, struct table *r)
+{
+	int i, err = 0;
+
+	if (l->debug != r->debug ||
+	    l->dnum != r->dnum ||
+	    l->rnum != r->rnum ||
+	    l->rwrap != r->rwrap) {
+		err = 1;
+		goto out;
+	}
+
+	if (memcmp(l->devices, r->devices, l->dnum * sizeof (int))) {
+		err = 1;
+		goto out;
+	}
+
+	for (i = 0; i < l->rnum; i++) {
+		if (l->rules[i].target != r->rules[i].target
+		    || strcmp(l->rules[i].hint, r->rules[i].hint)) {
+			err = 1;
+			goto out;
+		}
+	}
+
+out:
+	return err;
+}
+
+#define TABLE_HELP "<debug>\n<N> <M>\n<input1> ... <inputN>\n<wrap>\n<special hint>\n<trigger1> <hint1>\n...\n<triggerM> <hintM>\n"
+
+extern void special_event(struct kobject *kobj);
+extern unsigned long occasionally_generate_event(struct kobject *kobj, unsigned long last);
+extern unsigned long timely_generate_event(struct kobject *kobj, unsigned long last, unsigned long *notify);
+
+extern int push_table(const char *buf, unsigned long count);
+extern size_t pull_table(char **buf);
+extern void cleanup_table(void);
+
+#endif /* TABLE_H */
diff -ur --new-file SIN/uniq.h SIN-NEW/uniq.h
--- SIN/uniq.h	1970-01-01 01:00:00.000000000 +0100
+++ SIN-NEW/uniq.h	2007-01-25 14:07:39.000000000 +0100
@@ -0,0 +1,59 @@
+/*
+ *  Copyright (C) 2007 Alessandro Di Marco
+ */
+
+/*
+ *  This file is part of SIN.
+ *
+ *  SIN is free software; you can redistribute it and/or modify it under the
+ *  terms of the GNU General Public License as published by the Free Software
+ *  Foundation; version 2 of the License.
+ *
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
+ *  details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
+ */
+
+#ifndef UNIQ_H
+#define UNIQ_H
+
+#include <linux/bitops.h>
+
+#define out_of_range(l, x, u) ((x) < (l) || (x) >= (u))
+
+struct uniq {
+	int elements;
+	unsigned long *bitmap;
+};
+
+static inline int uniq_alloc(struct uniq *ci, int elm)
+{
+	int size = (1 + elm / sizeof (unsigned long)) * sizeof (unsigned long);
+
+	ci->elements = elm;
+
+	ci->bitmap = kzalloc(size, GFP_KERNEL);
+	if (!ci->bitmap) {
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static inline void uniq_free(struct uniq *ci)
+{
+	kfree(ci->bitmap);
+}
+
+static inline int uniq_check(struct uniq *ci, int index)
+{
+	return out_of_range(0, index, ci->elements)
+		|| test_and_set_bit(index, ci->bitmap);
+}
+
+#endif /* UNIQ_H */

--=-=-=


--
Tradition is what you resort to when you don't have the time or the money to do
it right. - Kurt Herbert Alder

--=-=-=--
