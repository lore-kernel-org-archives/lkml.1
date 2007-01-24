Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbXAXSIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbXAXSIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 13:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbXAXSIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 13:08:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:53397 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752101AbXAXSIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 13:08:36 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz>
	<877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz>
	<87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz>
	<87lkjthdmd.fsf@gmx.it> <20070123184432.GE18662@elf.ucw.cz>
Date: Wed, 24 Jan 2007 19:08:25 +0100
In-Reply-To: <20070123184432.GE18662@elf.ucw.cz> (Pavel Machek's message of "Tue\, 23 Jan 2007 19\:44\:32 +0100")
Message-ID: <874pqgti06.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Pavel Machek <pavel@ucw.cz> writes:

   > For example, the subsystem provides at kernel-level handy
   > hiberante/suspend/resume callbacks that I use to turn on/off the timer,
   > avoiding the time-warp problem. Doing that at user-level would be far more
   > messy...

   Imagine for a moment that we solve time-warp somehow. Any other
   problems? [I'd really like to get "is user idle" solved, but it really
   should not be in kernel unless it _has_ to. And time-warp probably
   causes problems not only for your daemon.]

Hi, 
the two patches in attachment fix the time-warp problem and remove the procfs
support. Feel free to contact me when you'll find a better way, maybe I could
help.

Best,


--=-=-=
Content-Disposition: inline; filename=0001-warp.txt

>From 602a3340fa5b11e6cfff91719f85668980bb338b Mon Sep 17 00:00:00 2001
From: Alessandro Di Marco <dmr@c0nc3pt.com>
Date: Wed, 24 Jan 2007 18:28:47 +0100
Subject: [PATCH] Time-warp bug fixed

---
 Makefile |    2 +
 debug.h  |   36 +++++++++++++
 sin.c    |  174 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 sin.h    |   13 +++++
 table.c  |   45 +++++++++-------
 table.h  |    6 +--
 6 files changed, 239 insertions(+), 37 deletions(-)

diff --git a/Makefile b/Makefile
index d45fa58..8b80de6 100644
--- a/Makefile
+++ b/Makefile
@@ -1,5 +1,7 @@
 MODLPATH = kernel/drivers/char
 
+#DEBUG="-D SIN_DEBUG"
+
 MODL = sinmod
 OBJS = sin.o procfs.o sysfs.o table.o input_enumerator.o acpi_enumerator.o
 
diff --git a/debug.h b/debug.h
new file mode 100644
index 0000000..e1c4bcc
--- /dev/null
+++ b/debug.h
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
diff --git a/sin.c b/sin.c
index c3633ff..bf06999 100644
--- a/sin.c
+++ b/sin.c
@@ -24,6 +24,9 @@
 #include <linux/acpi.h>
 #include <linux/mutex.h>
 #include <linux/miscdevice.h>
+#include <linux/platform_device.h>
+
+#include "debug.h"
 
 #include "sin.h"
 #include "table.h"
@@ -36,7 +39,11 @@ MODULE_AUTHOR("Alessandro Di Marco <dmr@gmx.it>");
 MODULE_DESCRIPTION("System Inactivity Notifier");
 MODULE_LICENSE("GPL v2");
 
-MODULE_VERSION("1.4");
+MODULE_VERSION("1.5");
+
+#ifdef SIN_DEBUG
+int debug;
+#endif
 
 static struct acpi_device *acpi_device;
 
@@ -68,27 +75,33 @@ inline void signal_interaction(void)
 
 		WARN_ON(test_bit(RULE_OVER, &status) && timer_pending(&timer));
 
-		clear_bit(RULE_WRAP, &status);
-		clear_bit(RULE_OVER, &status);
-
 		next = occasionally_generate_event(acpi_device,
 						   last_activity(&uact));
 
 		if (!shutdown) {
-			(void) mod_timer(&timer, next);
+			printd("mod_timer() last = %lu, next = %lu\n",
+			       last_activity(&uact) / HZ, next / HZ);
+
+			if (likely(mod_timer(&timer, next))) {
+				WARN_ON(test_bit(RULE_OVER, &status));
+			}
 		}
+
+		clear_bit(RULE_WRAP, &status);
+		clear_bit(RULE_OVER, &status);
 	}
 }
 
 inline void simulate_event(void)
 {
-	signal_interaction();
 	(void) simulate_activity();
+	signal_interaction();
 }
 
 static void event(struct input_handle *handle,
 		  unsigned int type, unsigned int code, int value)
 {
+	printd("user interaction at %lu\n", jiffies / HZ);
 	simulate_event();
 }
 
@@ -122,6 +135,8 @@ void timer_fn(unsigned long data)
 	if (!shutdown) {
 		unsigned long next;
 
+		printd(">>>>>>>>>>>> timer_fn()\n");
+
 		set_bit(RULE_LOCK, &status);
 
 		next = timely_generate_event(acpi_device,
@@ -133,10 +148,15 @@ void timer_fn(unsigned long data)
 			signal_interaction();
 		}
 
-		if (!test_and_clear_bit(RULE_OVER, &status)) {
+		if (!test_bit(RULE_OVER, &status)) {
+			printd("add_timer() now %lu, timer set to %lu\n",
+			       jiffies / HZ, next / HZ);
+
 			timer.expires = next;
 			add_timer(&timer);
 		}
+
+		printd("timer_fn() >>>>>>>>>>>>\n");
 	}
 }
 
@@ -227,38 +247,41 @@ static struct miscdevice sin_miscdev = {
 	.fops		= &sin_miscfops,
 };
 
-static int __init sih_init(void)
+static int __devinit sin_probe(struct platform_device *dev)
 {
 	int err;
 
 	err = misc_register(&sin_miscdev);
 	if (err < 0) {
+		printk(KERN_ERR "SIN: miscdev initialization failed\n");
 		goto out;
 	}
 
 	err = input_enum();
 	if (err < 0) {
+		printk(KERN_ERR "SIN: input enumeration failed\n");
 		goto cleanout1;
 	}
 
 	err = acpi_enum();
 	if (err < 0) {
+		printk(KERN_ERR "SIN: acpi enumeration failed\n");
 		goto cleanout2;
 	}
 
 	err = start_sysfs(sin_miscdev.this_device);
 	if (err < 0) {
-		printk(KERN_ERR "sin: sysfs initialization failed\n");
+		printk(KERN_ERR "SIN: sysfs initialization failed\n");
 		goto cleanout3;
 	}
 
 	err = start_procfs();
 	if (err < 0) {
-		printk(KERN_ERR "sin: procfs initialization failed\n");
+		printk(KERN_ERR "SIN: procfs initialization failed\n");
 		goto cleanout4;
 	}
 
-	printk("System Inactivity Notifier 1.4 - (c) Alessandro Di Marco <dmr@gmx.it>\n");
+	printk(KERN_DEBUG "System Inactivity Notifier 1.5 - (c) Alessandro Di Marco <dmr@gmx.it>\n");
 
 	return 0;
 
@@ -274,7 +297,7 @@ out:
 	return err;
 }
 
-static void __exit sih_exit(void)
+static int __devexit sin_remove(struct platform_device *dev)
 {
 	stop_procfs();
 	stop_sysfs();
@@ -284,6 +307,133 @@ static void __exit sih_exit(void)
 	(void) stop_monitor();
 
 	misc_deregister(&sin_miscdev);
+
+	return 0;
+}
+
+static void sin_shutdown(struct platform_device *dev)
+{
+	printd("shutdown() >>>>>>>>>>>>\n");
+	printd(">>>>>>>>>>>> shutdown()\n");
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
+				special_event(acpi_device);
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
+	.shutdown	= sin_shutdown,
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
 }
 
 module_init(sih_init);
diff --git a/sin.h b/sin.h
index 1ef52d2..929b1e5 100644
--- a/sin.h
+++ b/sin.h
@@ -59,6 +59,19 @@ static inline unsigned long last_activity(struct user_activity *uact)
 	return last;
 }
 
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
 extern unsigned long simulate_activity(void);
 extern void signal_interaction(void);
 extern void simulate_event(void);
diff --git a/table.c b/table.c
index b51e905..c55f230 100644
--- a/table.c
+++ b/table.c
@@ -24,6 +24,8 @@
 #include <linux/acpi.h>
 #include <linux/sort.h>
 
+#include "debug.h"
+
 #include "sin.h"
 #include "uniq.h"
 #include "table.h"
@@ -39,15 +41,24 @@ static int next_rule;
  * event service routines (e.g. /etc/acpid/default.sh).
  */
 
-unsigned long occasionally_generate_event(struct acpi_device *acpi_device,
-					  unsigned long last)
+static inline void generate_event(struct acpi_device *acpi_device, int rnum)
 {
-	printd("generating special event [%d, %d]\n",
-	       rt.rules[rt.rnum].type, rt.rules[rt.rnum].data);
+	struct rule *rule = &rt.rules[rnum];
+
+	printd("generating event [%d, %d]\n", rule->type, rule->data);
 
-	(void) acpi_bus_generate_event(acpi_device, rt.rules[rt.rnum].type,
-				       rt.rules[rt.rnum].data);
+	(void) acpi_bus_generate_event(acpi_device, rule->type, rule->data);
+}
+
+inline void special_event(struct acpi_device *acpi_device)
+{
+	generate_event(acpi_device, rt.rnum);
+}
 
+unsigned long occasionally_generate_event(struct acpi_device *acpi_device,
+					  unsigned long last)
+{
+	special_event(acpi_device);
 	return last + rt.rules[next_rule = 0].target;
 }
 
@@ -55,26 +66,18 @@ unsigned long timely_generate_event(struct acpi_device *acpi_device,
 				    unsigned long last, unsigned long *status)
 {
 	printd("last %lu [status %lu], now %lu -> next target is %lu (%d)\n",
-	       last, *status, jiffies,
-	       last + rt.rules[next_rule].target, next_rule);
+	       last / HZ, *status, jiffies / HZ,
+	       (last + rt.rules[next_rule].target) / HZ, next_rule);
 
 	for (; next_rule < rt.rnum &&
 		     time_after_eq(jiffies, last + rt.rules[next_rule].target);
 	     next_rule++) {
 		if (unlikely(test_and_clear_bit(RULE_WRAP, status))) {
-			printd("passive wrap, generating special event\n");
-
-			(void) acpi_bus_generate_event(acpi_device,
-						       rt.rules[rt.rnum].type,
-						       rt.rules[rt.rnum].data);
+			printd("passive wrap, user forgot to interact!\n");
+			special_event(acpi_device);
 		}
 
-		printd("generating event [%d, %d]\n",
-		       rt.rules[next_rule].type, rt.rules[next_rule].data);
-
-		(void) acpi_bus_generate_event(acpi_device,
-					       rt.rules[next_rule].type,
-					       rt.rules[next_rule].data);
+		generate_event(acpi_device, next_rule);
 		set_bit(RULE_TRIG, status);
 	}
 
@@ -87,7 +90,7 @@ unsigned long timely_generate_event(struct acpi_device *acpi_device,
 
 			last = simulate_activity();
 		} else {
-			printd("reached the last rule, disconnecting timer\n");
+			printd("last rule, disconnecting the timer\n");
 			set_bit(RULE_OVER, status);
 		}
 	}
@@ -271,6 +274,8 @@ int push_table(const char *buf, unsigned long count)
 		goto cleanout3;
 	}
 
+	set_debug(rt.debug);
+
 	err = start_monitor(get_hardware_id(rt.handle), idi);
 	if (err < 0) {
 		goto cleanout3;
diff --git a/table.h b/table.h
index fd6b91f..d2a86ae 100644
--- a/table.h
+++ b/table.h
@@ -39,11 +39,6 @@ struct table {
 	struct rule *rules;
 };
 
-#define printd(fmt...)				\
-	if (unlikely(rt.debug)) {		\
-		printk(fmt);			\
-	}
-
 static inline int tablecmp(struct table *l, struct table *r)
 {
 	if (l->debug != r->debug ||
@@ -73,6 +68,7 @@ static inline int tablecmp(struct table *l, struct table *r)
 
 #define TABLE_BUFFER_SIZE (8 + rt.dnum + rt.rnum * 3 + (TABLE_SIZE << 3) / 3)
 
+extern void special_event(struct acpi_device *acpi_device);
 extern unsigned long occasionally_generate_event(struct acpi_device *acpi_device, unsigned long last);
 extern unsigned long timely_generate_event(struct acpi_device *acpi_device, unsigned long last, unsigned long *notify);
 
-- 
1.4.4.4


--=-=-=
Content-Disposition: inline; filename=0002-procfs.txt

>From 3769b408303337db46b7e7621d5749b98ad9b198 Mon Sep 17 00:00:00 2001
From: Alessandro Di Marco <dmr@c0nc3pt.com>
Date: Wed, 24 Jan 2007 18:45:40 +0100
Subject: [PATCH] Removed procfs support

---
 Makefile |    2 +-
 gentable |   21 ++++---
 procfs.c |  202 --------------------------------------------------------------
 procfs.h |   33 ----------
 sin.c    |   10 ---
 5 files changed, 14 insertions(+), 254 deletions(-)

diff --git a/Makefile b/Makefile
index 8b80de6..62b1c43 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@ MODLPATH = kernel/drivers/char
 #DEBUG="-D SIN_DEBUG"
 
 MODL = sinmod
-OBJS = sin.o procfs.o sysfs.o table.o input_enumerator.o acpi_enumerator.o
+OBJS = sin.o sysfs.o table.o input_enumerator.o acpi_enumerator.o
 
 SRCS := $(patsubst %.o,%.c,$(OBJS))
 HDRS := $(patsubst %.o,%.h,$(OBJS))
diff --git a/gentable b/gentable
index 49af1f4..a8fe292 100755
--- a/gentable
+++ b/gentable
@@ -24,8 +24,8 @@ if (( $# == 0 )); then
    exit
 fi
 
-if [ ! -d "/proc/sin" ]; then
-    echo "/proc/sin not found, has sinmod been loaded?"
+if [ ! -d "/sys/class/misc/sin" ]; then
+    echo "/sys/class/misc/sin not found, has sinmod been loaded?"
     exit
 fi
 
@@ -38,7 +38,7 @@ least one device and must not specify duplicates.
 EOF
 
 echo -e "Specify the the input devices you want to monitor from the list below:\n"
-cat /proc/sin/input
+cat /sys/class/misc/sin/input
 
 echo
 input "Please digit the corresponding numbers separated by spaces" devs
@@ -57,7 +57,7 @@ suitable handler that will be used as originator.
 EOF
 
 echo -e "Specify the acpi handler you want to use from the list below:\n"
-cat /proc/sin/acpi
+cat /sys/class/misc/sin/acpi
 
 echo
 input "Please enter the number corresponding to the handler" handle
@@ -83,6 +83,8 @@ finished, just press enter.
 
 EOF
 
+declare -i i
+
 for (( i = 0; ; i++ )); do
     input "Rule ${i}?" rule
 
@@ -95,6 +97,7 @@ done
 
 if (( ${i} == 0 )); then
     rules[0]="60 1 2"
+    i=${i}+1
 fi
 
 cat <<EOF
@@ -111,6 +114,8 @@ if [ -z "${resume}" ]; then
     resume="2 1"
 fi
 
+declare -i j=${i}-1
+
 cat <<EOF
 
 Often an SIN event results in suspending or hibernating the system, hibernate,
@@ -120,10 +125,10 @@ consequence, no event will ever be generated and the system will remain in the
 state associated with the next-to-last rule (e.g. blanked screen, wireless
 powered off, etc.). The next option allows you to request a special event,
 restarting the rule-list evaluation from an arbitrary position.  Possible value
-ranges are described below, where N is the rule-list size:
+ranges are described below:
 
-    [0, N - 1]	=> jump to the given rule
-    N		=> go to sleep and wait for user interaction
+    [0, ${j}]	=> jump to the given rule
+    ${i}		=> go to sleep and wait for user interaction
 
 EOF
 
@@ -144,7 +149,7 @@ cat <<EOF
 All done. Now you can try your newly generated table as follows:
 
 # modprobe sinmod
-# echo $1 >/proc/sin/table
+# echo $1 >/sys/class/misc/sin/table
 
 An "Invalid argument" error indicates a mismatch in the table file, usually due
 to specifying an invalid acpi or input device. In that case, restart from
diff --git a/procfs.c b/procfs.c
deleted file mode 100644
index 7f42dde..0000000
--- a/procfs.c
+++ /dev/null
@@ -1,202 +0,0 @@
-/*
- *  Copyright (C) 2007 Alessandro Di Marco
- */
-
-/*
- *  This file is part of SIN.
- *
- *  SIN is free software; you can redistribute it and/or modify it under the
- *  terms of the GNU General Public License as published by the Free Software
- *  Foundation; version 2 of the License.
- *
- *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
- *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
- *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
- *  details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
- *  St, Fifth Floor, Boston, MA 02110-1301 USA
- */
-
-#include <linux/module.h>
-#include <linux/proc_fs.h>
-#include <linux/uaccess.h>
-
-#include "sin.h"
-#include "table.h"
-#include "procfs.h"
-#include "acpi_enumerator.h"
-#include "input_enumerator.h"
-
-static struct procfs_bs ibs, abs;
-static struct proc_dir_entry *rootdir;
-
-static int read_proc(char *page, char **start,
-		     off_t off, int count, int *eof, void *data)
-{
-	struct procfs_bs *bs = data;
-	int left = bs->size - off;
-
-	if (count > left) {
-		count = left;
-	}
-
-	memcpy(page + off, bs->page, count);
-
-	if (count == left) {
-		*eof = 1;
-	}
-
-	return off + count;
-}
-
-static int read_table_proc(char *page, char **start,
-			   off_t off, int count, int *eof, void *data)
-{
-	char *buf;
-	size_t size;
-
-	int left;
-	int err = -ENOMEM;
-
-	size = pull_table(&buf);
-	if (!buf) {
-		goto out;
-	}
-
-	if (size > PAGE_SIZE) {
-		size = PAGE_SIZE;
-	}
-
-	left = size - off;
-	if (left < 0) {
-		err = -ESPIPE;
-		goto out;
-	}
-
-	if (count > left) {
-		count = left;
-	}
-
-	memcpy(page + off, buf, count);
-
-	if (count == left) {
-		page[size] = '\0';
-		*eof = 1;
-	}
-
-	return off + count;
-
-out:
-	return err;
-}
-
-static int write_table_proc(struct file *file, const __user char *ubuf,
-			    unsigned long count, void *data)
-{
-	char *buf;
-	int err;
-
-	buf = kmalloc(count, GFP_KERNEL);
-	if (!buf) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	if (copy_from_user(buf, ubuf, count + 1)) {
-		err = -EFAULT;
-		goto cleanout;
-	}
-
-	buf[count] = '\0';
-
-	err = push_table(buf, count);
-
-cleanout:
-	kfree(buf);
-out:
-	return err;
-}
-
-static int fake_write_proc(struct file *file, const __user char *ubuf,
-			   unsigned long count, void *data)
-{
-	void (*func)(void) = data;
-
-	func();
-	return count;
-}
-
-int start_procfs(void)
-{
-	struct proc_dir_entry *inputd, *acpid, *table, *interact;
-	int err = -ENOMEM;
-
-	ibs.size = get_devices_desc(&ibs.page);
-	abs.size = get_handlers_desc(&abs.page);
-
-	rootdir = proc_mkdir(MODULE_NAME, NULL);
-	if (!rootdir) {
-		goto out;
-	}
-
-	rootdir->owner = THIS_MODULE;
-
-	inputd = create_proc_read_entry("input", 0444,
-					rootdir, read_proc, &ibs);
-	if (!inputd) {
-		goto cleanout1;
-	}
-
-	inputd->owner = THIS_MODULE;
-
-	acpid = create_proc_read_entry("acpi", 0444,
-				       rootdir, read_proc, &abs);
-	if (!acpid) {
-		goto cleanout2;
-	}
-
-	acpid->owner = THIS_MODULE;
-
-	table = create_proc_entry("table", 0644, rootdir);
-	if (!table) {
-		goto cleanout3;
-	}
-
-	table->data = NULL;
-	table->read_proc = read_table_proc;
-	table->write_proc = write_table_proc;
-	table->owner = THIS_MODULE;
-
-	interact = create_proc_entry("interact", 0200, rootdir);
-	if (!interact) {
-		goto cleanout4;
-	}
-
-	interact->data = (void *) simulate_event;
-	interact->write_proc = fake_write_proc;
-	interact->owner = THIS_MODULE;
-
-	return 0;
-
-cleanout4:
-	remove_proc_entry("table", rootdir);
-cleanout3:
-	remove_proc_entry("acpi", rootdir);
-cleanout2:
-	remove_proc_entry("input", rootdir);
-cleanout1:
-	remove_proc_entry(MODULE_NAME, NULL);
-out:
-	return err;
-}
-
-void stop_procfs(void)
-{
-	remove_proc_entry("interact", rootdir);
-	remove_proc_entry("table", rootdir);
-	remove_proc_entry("acpi", rootdir);
-	remove_proc_entry("input", rootdir);
-	remove_proc_entry(MODULE_NAME, NULL);
-}
diff --git a/procfs.h b/procfs.h
deleted file mode 100644
index ea164be..0000000
--- a/procfs.h
+++ /dev/null
@@ -1,33 +0,0 @@
-/*
- *  Copyright (C) 2007 Alessandro Di Marco
- */
-
-/*
- *  This file is part of SIN.
- *
- *  SIN is free software; you can redistribute it and/or modify it under the
- *  terms of the GNU General Public License as published by the Free Software
- *  Foundation; version 2 of the License.
- *
- *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
- *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
- *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
- *  details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
- *  St, Fifth Floor, Boston, MA 02110-1301 USA
- */
-
-#ifndef PROCFS_H
-#define PROCFS_H
-
-struct procfs_bs {
-	char *page;
-	int size;
-};
-
-extern int start_procfs(void);
-extern void stop_procfs(void);
-
-#endif /* PROCFS_H */
diff --git a/sin.c b/sin.c
index bf06999..7b96c61 100644
--- a/sin.c
+++ b/sin.c
@@ -30,7 +30,6 @@
 
 #include "sin.h"
 #include "table.h"
-#include "procfs.h"
 #include "sysfs.h"
 #include "acpi_enumerator.h"
 #include "input_enumerator.h"
@@ -275,18 +274,10 @@ static int __devinit sin_probe(struct platform_device *dev)
 		goto cleanout3;
 	}
 
-	err = start_procfs();
-	if (err < 0) {
-		printk(KERN_ERR "SIN: procfs initialization failed\n");
-		goto cleanout4;
-	}
-
 	printk(KERN_DEBUG "System Inactivity Notifier 1.5 - (c) Alessandro Di Marco <dmr@gmx.it>\n");
 
 	return 0;
 
-cleanout4:
-	stop_sysfs();
 cleanout3:
 	free_acpi_enum();
 cleanout2:
@@ -299,7 +290,6 @@ out:
 
 static int __devexit sin_remove(struct platform_device *dev)
 {
-	stop_procfs();
 	stop_sysfs();
 	free_acpi_enum();
 	free_input_enum();
-- 
1.4.4.4


--=-=-=


-- 
Advertising is a valuable economic factor because it is the cheapest way of
selling goods, particularly if the goods are worthless. - Sinclair Lewis

--=-=-=--
