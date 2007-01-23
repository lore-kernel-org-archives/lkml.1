Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbXAWOOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbXAWOOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932899AbXAWOOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:14:44 -0500
Received: from mail.gmx.net ([213.165.64.20]:43814 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932180AbXAWOOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:14:41 -0500
X-Authenticated: #14842415
From: Alessandro Di Marco <dmr@gmx.it>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz>
	<877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz>
Date: Tue, 23 Jan 2007 15:14:37 +0100
In-Reply-To: <20070123094114.GE6033@ucw.cz> (Pavel Machek's message of "Tue\, 23 Jan 2007 09\:41\:15 +0000")
Message-ID: <87wt3dhlte.fsf@gmx.it>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Pavel Machek <pavel@ucw.cz> writes:

   Hi!

   >    > +if [ ! -d "/proc/sin" ]; then
   >    > +    echo "/proc/sin not found, has sinmod been loaded?"
   >    > +    exit
   >    > +fi
   >
   >    No new /proc files, please.
   >
   > This was merely a prototype realized in a hurry, not a production
   > driver. Really, I did't think it could be interesting for anybody.
   >
   > Would be /sys ok?

   If it has to be in kernel, /sys/power is probably ok.

Doh! The attached patch introduces /sys/class/misc (along with some bug-fixes.)
In case I'll change it again.

Ah, there is still a time-warp bug pending. In practice I have to turn off the
timer just before suspending, hibernating, etc or it will give you hell on the
next system resume...

   But I still believe it can be out.

Do you believe it could be a user-space daemon or what?

Best,


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=sysfs.patch

>From f97e411d29d5771e3ac3d9c8e8aa4ad3ae0a27e2 Mon Sep 17 00:00:00 2001
From: Alessandro Di Marco <dmr@c0nc3pt.com>
Date: Tue, 23 Jan 2007 02:21:07 +0100
Subject: [PATCH] Added sysfs support; various timer bugfix, but time warp bug is still with us.

---
 Makefile           |    2 +-
 acpi_enumerator.c  |   27 +++++++--
 acpi_enumerator.h  |    5 +-
 gentable           |   17 +++---
 input_enumerator.c |   28 ++++++++--
 input_enumerator.h |    4 +-
 procfs.c           |  157 ++++++++++++++++++++--------------------------------
 procfs.h           |   12 ++--
 sin.c              |   86 ++++++++++++++++++++++++++--
 sin.h              |    9 ++-
 sysfs.c            |  146 ++++++++++++++++++++++++++++++++++++++++++++++++
 sysfs.h            |   28 +++++++++
 table.c            |  128 ++++++++++++++++++++++++++++--------------
 table.h            |    8 ++-
 14 files changed, 476 insertions(+), 181 deletions(-)

diff --git a/Makefile b/Makefile
index a72fb3c..d45fa58 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 MODLPATH = kernel/drivers/char
 
 MODL = sinmod
-OBJS = sin.o procfs.o table.o input_enumerator.o acpi_enumerator.o
+OBJS = sin.o procfs.o sysfs.o table.o input_enumerator.o acpi_enumerator.o
 
 SRCS := $(patsubst %.o,%.c,$(OBJS))
 HDRS := $(patsubst %.o,%.h,$(OBJS))
diff --git a/acpi_enumerator.c b/acpi_enumerator.c
index c9033e5..c25a268 100644
--- a/acpi_enumerator.c
+++ b/acpi_enumerator.c
@@ -35,6 +35,12 @@ int get_handlers(void)
 	return ahsize;
 }
 
+size_t get_handlers_desc(char **buf)
+{
+	*buf = page;
+	return size;
+}
+
 char *get_hardware_id(int handle)
 {
 	return ah[handle].hardware_id;
@@ -75,11 +81,15 @@ static int acpi_show(struct acpi_device *device, struct acpi_driver *driver)
 	return -ENOENT;
 }
 
-int acpi_enum(char *buf)
+int acpi_enum(void)
 {
 	struct acpi_driver ad;
+	int err = -ENOMEM;
 
-	page = buf;
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!page) {
+		goto out;
+	}
 
 	ad.ops.match = acpi_show;
 	(void) acpi_bus_register_driver(&ad);
@@ -87,7 +97,8 @@ int acpi_enum(char *buf)
 
 	if (!ahsize) {
 		printk(KERN_NOTICE "no acpi handlers found\n");
-		return -ENODEV;
+		err = -ENODEV;
+		goto cleanout;
 	}
 
 	ah = kmalloc(ahsize * sizeof (struct acpi_handlers), GFP_KERNEL);
@@ -95,14 +106,19 @@ int acpi_enum(char *buf)
 	ahsize = 0;
 
 	if (!ah) {
-		return -ENOMEM;
+		goto cleanout;
 	}
 
 	ad.ops.match = acpi_store;
 	(void) acpi_bus_register_driver(&ad);
 	acpi_bus_unregister_driver(&ad);
 
-	return size;
+	return 0;
+
+cleanout:
+	kfree(page);
+out:
+	return err;
 }
 
 void free_acpi_enum(void)
@@ -110,5 +126,6 @@ void free_acpi_enum(void)
 	if (ahsize) {
 		ahsize = 0;
 		kfree(ah);
+		kfree(page);
 	}
 }
diff --git a/acpi_enumerator.h b/acpi_enumerator.h
index 998db65..0b75a09 100644
--- a/acpi_enumerator.h
+++ b/acpi_enumerator.h
@@ -29,8 +29,11 @@ struct acpi_handlers {
 };
 
 extern int get_handlers(void);
+extern size_t get_handlers_desc(char **buf);
+
 extern char *get_hardware_id(int handle);
-extern int acpi_enum(char *page);
+
+extern int acpi_enum(void);
 extern void free_acpi_enum(void);
 
 #endif /* ACPI_ENUMERATOR_H */
diff --git a/gentable b/gentable
index 3a322df..49af1f4 100755
--- a/gentable
+++ b/gentable
@@ -119,22 +119,21 @@ interaction occurs when SIN, as well as the kernel, cannot capture it. As a
 consequence, no event will ever be generated and the system will remain in the
 state associated with the next-to-last rule (e.g. blanked screen, wireless
 powered off, etc.). The next option allows you to request a special event,
-resetting the global counter to an arbitrary value, so to restart the rule-list
-evaluation.  Possible value ranges are described below, where N is the maximum
-counter in the current rule list:
+restarting the rule-list evaluation from an arbitrary position.  Possible value
+ranges are described below, where N is the rule-list size:
 
-    [0, N]    => reset the global counter to the specified value
-    otherwise => do nothing, the global counter goes on and on and on...
+    [0, N - 1]	=> jump to the given rule
+    N		=> go to sleep and wait for user interaction
 
 EOF
 
-input "Reset value?" reset
+input "Wrap value?" wrap
 
-if [ -z "${reset}" ]; then
-    reset="-1"
+if [ -z "${wrap}" ]; then
+    wrap="-1"
 fi
 
-echo -e "0\n${#devices[@]} ${#rules[@]}\n${devices[@]}\n${handle}\n${reset}\n${resume}" > $1
+echo -e "0\n${#devices[@]} ${#rules[@]}\n${devices[@]}\n${handle}\n${wrap}\n${resume}" > $1
 
 for (( i = 0; ${i}<${#rules[@]}; i++ )); do
     echo "${rules[${i}]}" >> $1
diff --git a/input_enumerator.c b/input_enumerator.c
index b046cb4..6fd7827 100644
--- a/input_enumerator.c
+++ b/input_enumerator.c
@@ -35,6 +35,12 @@ int get_devices(void)
 	return idsize;
 }
 
+size_t get_devices_desc(char **buf)
+{
+	*buf = page;
+	return size;
+}
+
 void fill_input_device(struct input_device_id *idi, int device)
 {
 	idi->flags = MATCH_MODEL;
@@ -135,8 +141,10 @@ skip:
 	return NULL;
 }
 
-int input_enum(char *buf)
+int input_enum(void)
 {
+	int err = -ENOMEM;
+
 	const struct input_device_id idi[] = {
 		{ .driver_info = 1 },	/* matches all devices */
 		{ },
@@ -147,14 +155,18 @@ int input_enum(char *buf)
 		.id_table =	idi,
 	};
 
-	page = buf;
+	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!page) {
+		goto out;
+	}
 
 	ih.connect = input_show;
 	(void) input_register_handler(&ih);
 
 	if (!idsize) {
 		printk(KERN_NOTICE "no input devices found\n");
-		return -ENODEV;
+		err = -ENODEV;
+		goto cleanout;
 	}
 
 	id = kmalloc(idsize * sizeof (struct input_devices), GFP_KERNEL);
@@ -162,13 +174,18 @@ int input_enum(char *buf)
 	idsize = 0;
 
 	if (!id) {
-		return -ENOMEM;
+		goto cleanout;
 	}
 
 	ih.connect = input_store;
 	(void) input_register_handler(&ih);
 
-	return size;
+	return 0;
+
+cleanout:
+	kfree(page);
+out:
+	return err;
 }
 
 void free_input_enum(void)
@@ -176,5 +193,6 @@ void free_input_enum(void)
 	if (idsize) {
 		idsize = 0;
 		kfree(id);
+		kfree(page);
 	}
 }
diff --git a/input_enumerator.h b/input_enumerator.h
index 0e87207..45ffe93 100644
--- a/input_enumerator.h
+++ b/input_enumerator.h
@@ -37,9 +37,11 @@ struct input_devices {
 		     |INPUT_DEVICE_ID_MATCH_VERSION)
 
 extern int get_devices(void);
+extern size_t get_devices_desc(char **buf);
+
 extern void fill_input_device(struct input_device_id *idi, int i);
 
-extern int input_enum(char *page);
+extern int input_enum(void);
 extern void free_input_enum(void);
 
 #endif /* INPUT_ENUMERATOR_H */
diff --git a/procfs.c b/procfs.c
index 5929f90..7f42dde 100644
--- a/procfs.c
+++ b/procfs.c
@@ -29,7 +29,7 @@
 #include "acpi_enumerator.h"
 #include "input_enumerator.h"
 
-static struct procfs_bs ibs, abs, tbs;
+static struct procfs_bs ibs, abs;
 static struct proc_dir_entry *rootdir;
 
 static int read_proc(char *page, char **start,
@@ -44,21 +44,61 @@ static int read_proc(char *page, char **start,
 
 	memcpy(page + off, bs->page, count);
 
-	if (!count) {
+	if (count == left) {
 		*eof = 1;
 	}
 
 	return off + count;
 }
 
-static int write_proc(struct file *file, const __user char *ubuf,
-		      unsigned long count, void *data)
+static int read_table_proc(char *page, char **start,
+			   off_t off, int count, int *eof, void *data)
+{
+	char *buf;
+	size_t size;
+
+	int left;
+	int err = -ENOMEM;
+
+	size = pull_table(&buf);
+	if (!buf) {
+		goto out;
+	}
+
+	if (size > PAGE_SIZE) {
+		size = PAGE_SIZE;
+	}
+
+	left = size - off;
+	if (left < 0) {
+		err = -ESPIPE;
+		goto out;
+	}
+
+	if (count > left) {
+		count = left;
+	}
+
+	memcpy(page + off, buf, count);
+
+	if (count == left) {
+		page[size] = '\0';
+		*eof = 1;
+	}
+
+	return off + count;
+
+out:
+	return err;
+}
+
+static int write_table_proc(struct file *file, const __user char *ubuf,
+			    unsigned long count, void *data)
 {
-	struct procfs_bs *bs = data;
 	char *buf;
 	int err;
 
-	buf = kmalloc(count * sizeof (char), GFP_KERNEL);
+	buf = kmalloc(count, GFP_KERNEL);
 	if (!buf) {
 		err = -ENOMEM;
 		goto out;
@@ -72,16 +112,6 @@ static int write_proc(struct file *file, const __user char *ubuf,
 	buf[count] = '\0';
 
 	err = push_table(buf, count);
-	if (err < 0) {
-		goto cleanout;
-	}
-
-	kfree(bs->page);
-
-	bs->size = pull_table(&bs->page);
-	if (bs->size < 0) {
-		err = bs->size;
-	}
 
 cleanout:
 	kfree(buf);
@@ -100,45 +130,15 @@ static int fake_write_proc(struct file *file, const __user char *ubuf,
 
 int start_procfs(void)
 {
-	struct proc_dir_entry *inputd, *acpid,
-		*table, *interact, *ilink, *alink;
-
+	struct proc_dir_entry *inputd, *acpid, *table, *interact;
 	int err = -ENOMEM;
 
-	ibs.page = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!ibs.page) {
-		goto out;
-	}
-
-	ibs.size = input_enum(ibs.page);
-	if (ibs.size < 0) {
-		err = ibs.size;
-		goto cleanout1;
-	}
-
-	abs.page = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!abs.page) {
-		goto cleanout2;
-	}
-
-	abs.size = acpi_enum(abs.page);
-	if (abs.size < 0) {
-		err = abs.size;
-		goto cleanout3;
-	}
-
-	tbs.size = sizeof RT_HELP;
-
-	tbs.page = kmalloc(tbs.size, GFP_KERNEL);
-	if (!tbs.page) {
-		goto cleanout4;
-	}
-
-	memcpy(tbs.page, RT_HELP, tbs.size);
+	ibs.size = get_devices_desc(&ibs.page);
+	abs.size = get_handlers_desc(&abs.page);
 
 	rootdir = proc_mkdir(MODULE_NAME, NULL);
 	if (!rootdir) {
-		goto cleanout5;
+		goto out;
 	}
 
 	rootdir->owner = THIS_MODULE;
@@ -146,7 +146,7 @@ int start_procfs(void)
 	inputd = create_proc_read_entry("input", 0444,
 					rootdir, read_proc, &ibs);
 	if (!inputd) {
-		goto cleanout6;
+		goto cleanout1;
 	}
 
 	inputd->owner = THIS_MODULE;
@@ -154,84 +154,49 @@ int start_procfs(void)
 	acpid = create_proc_read_entry("acpi", 0444,
 				       rootdir, read_proc, &abs);
 	if (!acpid) {
-		goto cleanout7;
+		goto cleanout2;
 	}
 
 	acpid->owner = THIS_MODULE;
 
 	table = create_proc_entry("table", 0644, rootdir);
 	if (!table) {
-		goto cleanout8;
+		goto cleanout3;
 	}
 
-	table->data = &tbs;
-	table->read_proc = read_proc;
-	table->write_proc = write_proc;
+	table->data = NULL;
+	table->read_proc = read_table_proc;
+	table->write_proc = write_table_proc;
 	table->owner = THIS_MODULE;
 
 	interact = create_proc_entry("interact", 0200, rootdir);
 	if (!interact) {
-		goto cleanout9;
+		goto cleanout4;
 	}
 
 	interact->data = (void *) simulate_event;
 	interact->write_proc = fake_write_proc;
 	interact->owner = THIS_MODULE;
 
-	ilink = proc_symlink("sources", rootdir, "input");
-	if (!ilink) {
-		goto cleanout10;
-	}
-
-	ilink->owner = THIS_MODULE;
-
-	alink = proc_symlink("destinations", rootdir, "acpi");
-	if (!alink) {
-		goto cleanout11;
-	}
-
-	alink->owner = THIS_MODULE;
-
 	return 0;
 
-cleanout11:
-	remove_proc_entry("sources", rootdir);
-cleanout10:
-	remove_proc_entry("interact", rootdir);
-cleanout9:
-	remove_proc_entry("table", rootdir);
-cleanout8:
-	remove_proc_entry("acpi", rootdir);
-cleanout7:
-	remove_proc_entry("input", rootdir);
-cleanout6:
-	remove_proc_entry(MODULE_NAME, NULL);
-cleanout5:
-	kfree(tbs.page);
 cleanout4:
-	free_acpi_enum();
+	remove_proc_entry("table", rootdir);
 cleanout3:
-	kfree(abs.page);
+	remove_proc_entry("acpi", rootdir);
 cleanout2:
-	free_input_enum();
+	remove_proc_entry("input", rootdir);
 cleanout1:
-	kfree(ibs.page);
+	remove_proc_entry(MODULE_NAME, NULL);
 out:
 	return err;
 }
 
 void stop_procfs(void)
 {
-	remove_proc_entry("destinations", rootdir);
-	remove_proc_entry("sources", rootdir);
 	remove_proc_entry("interact", rootdir);
 	remove_proc_entry("table", rootdir);
 	remove_proc_entry("acpi", rootdir);
 	remove_proc_entry("input", rootdir);
 	remove_proc_entry(MODULE_NAME, NULL);
-	kfree(tbs.page);
-	free_acpi_enum();
-	kfree(abs.page);
-	free_input_enum();
-	kfree(ibs.page);
 }
diff --git a/procfs.h b/procfs.h
index 890d1ce..ea164be 100644
--- a/procfs.h
+++ b/procfs.h
@@ -3,27 +3,25 @@
  */
 
 /*
- *  This file is part of Procfs.
+ *  This file is part of SIN.
  *
- *  Procfs is free software; you can redistribute it and/or modify it under the
+ *  SIN is free software; you can redistribute it and/or modify it under the
  *  terms of the GNU General Public License as published by the Free Software
  *  Foundation; version 2 of the License.
  *
- *  Procfs is distributed in the hope that it will be useful, but WITHOUT ANY
+ *  SIN is distributed in the hope that it will be useful, but WITHOUT ANY
  *  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  *  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  *  details.
  *
  *  You should have received a copy of the GNU General Public License along
- *  with Procfs; if not, write to the Free Software Foundation, Inc., 51
- *  Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *  with SIN; if not, write to the Free Software Foundation, Inc., 51 Franklin
+ *  St, Fifth Floor, Boston, MA 02110-1301 USA
  */
 
 #ifndef PROCFS_H
 #define PROCFS_H
 
-#define RT_HELP "<debug>\n<pace>\n<N> <M>\n<input1> ... <inputN>\n<acpi>\n<reset>\n<special type> <special data>\n<counter1> <type1> <data1>\n...\n<counterM> <typeM> <dataM>\n"
-
 struct procfs_bs {
 	char *page;
 	int size;
diff --git a/sin.c b/sin.c
index 0d9b9c4..c3633ff 100644
--- a/sin.c
+++ b/sin.c
@@ -23,16 +23,20 @@
 #include <linux/input.h>
 #include <linux/acpi.h>
 #include <linux/mutex.h>
+#include <linux/miscdevice.h>
 
 #include "sin.h"
 #include "table.h"
 #include "procfs.h"
+#include "sysfs.h"
+#include "acpi_enumerator.h"
+#include "input_enumerator.h"
 
 MODULE_AUTHOR("Alessandro Di Marco <dmr@gmx.it>");
 MODULE_DESCRIPTION("System Inactivity Notifier");
 MODULE_LICENSE("GPL v2");
 
-MODULE_VERSION("1.3");
+MODULE_VERSION("1.4");
 
 static struct acpi_device *acpi_device;
 
@@ -60,8 +64,19 @@ inline void signal_interaction(void)
 	if (unlikely(test_bit(RULE_LOCK, &status))) {
 		set_bit(RULE_MARK, &status);
 	} else if (unlikely(test_and_clear_bit(RULE_TRIG, &status))) {
+		unsigned long next;
+
+		WARN_ON(test_bit(RULE_OVER, &status) && timer_pending(&timer));
+
 		clear_bit(RULE_WRAP, &status);
-		occasionally_generate_event(acpi_device);
+		clear_bit(RULE_OVER, &status);
+
+		next = occasionally_generate_event(acpi_device,
+						   last_activity(&uact));
+
+		if (!shutdown) {
+			(void) mod_timer(&timer, next);
+		}
 	}
 }
 
@@ -118,8 +133,10 @@ void timer_fn(unsigned long data)
 			signal_interaction();
 		}
 
-		timer.expires = next;
-		add_timer(&timer);
+		if (!test_and_clear_bit(RULE_OVER, &status)) {
+			timer.expires = next;
+			add_timer(&timer);
+		}
 	}
 }
 
@@ -200,16 +217,73 @@ void stop_monitor(void)
 	mutex_unlock(&runlock);
 }
 
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
 static int __init sih_init(void)
 {
-	printk("System Inactivity Notifier 1.3 - (c) Alessandro Di Marco <dmr@c0nc3pt.com>\n");
-	return start_procfs();
+	int err;
+
+	err = misc_register(&sin_miscdev);
+	if (err < 0) {
+		goto out;
+	}
+
+	err = input_enum();
+	if (err < 0) {
+		goto cleanout1;
+	}
+
+	err = acpi_enum();
+	if (err < 0) {
+		goto cleanout2;
+	}
+
+	err = start_sysfs(sin_miscdev.this_device);
+	if (err < 0) {
+		printk(KERN_ERR "sin: sysfs initialization failed\n");
+		goto cleanout3;
+	}
+
+	err = start_procfs();
+	if (err < 0) {
+		printk(KERN_ERR "sin: procfs initialization failed\n");
+		goto cleanout4;
+	}
+
+	printk("System Inactivity Notifier 1.4 - (c) Alessandro Di Marco <dmr@gmx.it>\n");
+
+	return 0;
+
+cleanout4:
+	stop_sysfs();
+cleanout3:
+	free_acpi_enum();
+cleanout2:
+	free_input_enum();
+cleanout1:
+	misc_deregister(&sin_miscdev);
+out:
+	return err;
 }
 
 static void __exit sih_exit(void)
 {
 	stop_procfs();
+	stop_sysfs();
+	free_acpi_enum();
+	free_input_enum();
+
 	(void) stop_monitor();
+
+	misc_deregister(&sin_miscdev);
 }
 
 module_init(sih_init);
diff --git a/sin.h b/sin.h
index 95161b2..1ef52d2 100644
--- a/sin.h
+++ b/sin.h
@@ -26,10 +26,11 @@
 
 #define MODULE_NAME "sin"
 
-#define RULE_TRIG 0
-#define RULE_WRAP 1
-#define RULE_LOCK 2
-#define RULE_MARK 3
+#define RULE_TRIG 0 /* a rule has been triggered */
+#define RULE_WRAP 1 /* rule-evaluation has been restarted */
+#define RULE_LOCK 2 /* evaluating rule-list, don't mess */
+#define RULE_MARK 3 /* event seen while evaluating rule-list */
+#define RULE_OVER 4 /* no more rules, please disconnect timer */
 
 struct user_activity {
 	spinlock_t lock;
diff --git a/sysfs.c b/sysfs.c
new file mode 100644
index 0000000..28004a4
--- /dev/null
+++ b/sysfs.c
@@ -0,0 +1,146 @@
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
+#include "acpi_enumerator.h"
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
+static ssize_t show_acpi(struct device *dev,
+			 struct device_attribute *attr, char *pbuf)
+{
+	char *buf;
+	size_t size;
+
+	size = get_handlers_desc(&buf);
+
+	memcpy(pbuf, buf, size);
+
+	return size;
+}
+
+static DEVICE_ATTR(acpi, 0444, show_acpi, NULL);
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
+	err = device_create_file(sindev, &dev_attr_acpi);
+	if (err < 0) {
+		goto cleanout1;
+	}
+
+	err = device_create_file(sindev, &dev_attr_table);
+	if (err < 0) {
+		goto cleanout2;
+	}
+
+	err = device_create_file(sindev, &dev_attr_interact);
+	if (err < 0) {
+		goto cleanout3;
+	}
+
+	return 0;
+
+cleanout3:
+	device_remove_file(sindev, &dev_attr_table);
+cleanout2:
+	device_remove_file(sindev, &dev_attr_acpi);
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
+	device_remove_file(sindev, &dev_attr_acpi);
+	device_remove_file(sindev, &dev_attr_input);
+}
diff --git a/sysfs.h b/sysfs.h
new file mode 100644
index 0000000..465258a
--- /dev/null
+++ b/sysfs.h
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
diff --git a/table.c b/table.c
index 658636f..b51e905 100644
--- a/table.c
+++ b/table.c
@@ -27,7 +27,6 @@
 #include "sin.h"
 #include "uniq.h"
 #include "table.h"
-
 #include "input_enumerator.h"
 #include "acpi_enumerator.h"
 
@@ -40,7 +39,8 @@ static int next_rule;
  * event service routines (e.g. /etc/acpid/default.sh).
  */
 
-void occasionally_generate_event(struct acpi_device *acpi_device)
+unsigned long occasionally_generate_event(struct acpi_device *acpi_device,
+					  unsigned long last)
 {
 	printd("generating special event [%d, %d]\n",
 	       rt.rules[rt.rnum].type, rt.rules[rt.rnum].data);
@@ -48,7 +48,7 @@ void occasionally_generate_event(struct acpi_device *acpi_device)
 	(void) acpi_bus_generate_event(acpi_device, rt.rules[rt.rnum].type,
 				       rt.rules[rt.rnum].data);
 
-	next_rule = 0;
+	return last + rt.rules[next_rule = 0].target;
 }
 
 unsigned long timely_generate_event(struct acpi_device *acpi_device,
@@ -78,26 +78,31 @@ unsigned long timely_generate_event(struct acpi_device *acpi_device,
 		set_bit(RULE_TRIG, status);
 	}
 
-	if (rt.rwrap >= 0 && next_rule == rt.rnum) {
-		printd("last rule reached, restarting from %d\n", rt.rwrap);
+	if (next_rule == rt.rnum) {
+		if (rt.rwrap < rt.rnum) {
+			printd("last rule, restarting from %d\n", rt.rwrap);
 
-		next_rule = rt.rwrap;
-		set_bit(RULE_WRAP, status);
+			next_rule = rt.rwrap;
+			set_bit(RULE_WRAP, status);
 
-		last = simulate_activity();
+			last = simulate_activity();
+		} else {
+			printd("reached the last rule, disconnecting timer\n");
+			set_bit(RULE_OVER, status);
+		}
 	}
 
 	return last + rt.rules[next_rule].target;
 }
 
-#define parse_num(endp) ({				\
-			char *cp = endp;		\
-							\
-			while (*cp && isspace(*cp)) {	\
-				++cp;			\
-			}				\
-							\
-			simple_strtol(cp, &endp, 10);	\
+#define parse_num(endp) ({					\
+			const char *cp = endp;			\
+								\
+			while (*cp && isspace(*cp)) {		\
+				++cp;				\
+			}					\
+								\
+			simple_strtol(cp, (char **) &endp, 10);	\
 		})
 
 static int cmp(const void *l, const void *r)
@@ -117,7 +122,45 @@ static void swap(void *l, void *r, int size)
 	*((struct rule *) r) = t;
 }
 
-int push_table(char *buf, unsigned long count)
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
+	table = t = kmalloc(TABLE_BUFFER_SIZE, GFP_KERNEL);
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
+	t += sprintf(t, "\n%d\n%d\n%d %d\n",
+		     rt.handle, rt.rwrap,
+		     rt.rules[rt.rnum].type, rt.rules[rt.rnum].data);
+
+	for (i = 0; i < rt.rnum; i++) {
+		t += sprintf(t, "%d %d %d\n",
+			     jiffies_to_msecs(rt.rules[i].target) / 100,
+			     rt.rules[i].type, rt.rules[i].data);
+	}
+
+	size = t - table;
+
+	return 0;
+}
+
+int push_table(const char *buf, unsigned long count)
 {
 	struct table nrt;
 	struct input_device_id *idi;
@@ -179,7 +222,7 @@ int push_table(char *buf, unsigned long count)
 	}
 
 	nrt.rwrap = parse_num(buf);
-	if (out_of_range(0, nrt.rwrap, nrt.rnum)) {
+	if (out_of_range(0, nrt.rwrap, nrt.rnum + 1)) {
 		err = -EINVAL;
 		goto cleanout2;
 	}
@@ -223,6 +266,11 @@ int push_table(char *buf, unsigned long count)
 
 	memcpy(&rt, &nrt, sizeof (struct table));
 
+	err = regen_table();
+	if (err < 0) {
+		goto cleanout3;
+	}
+
 	err = start_monitor(get_hardware_id(rt.handle), idi);
 	if (err < 0) {
 		goto cleanout3;
@@ -232,6 +280,9 @@ int push_table(char *buf, unsigned long count)
 
 cleanout3:
 	kfree(idi);
+	cleanup_table();
+	goto out;
+
 cleanout2:
 	kfree(nrt.rules);
 cleanout1:
@@ -240,42 +291,33 @@ out:
 	return err;
 }
 
-int pull_table(char **buf)
+size_t pull_table(char **buf)
 {
-	char *b;
-	int i;
-
-	*buf = b = kmalloc(TABLE_BUFFER_SIZE, GFP_KERNEL);
-	if (!b) {
-		return -EFAULT;
-	}
-
-	b += sprintf(b, "%d\n%d %d\n", rt.debug, rt.dnum, rt.rnum);
-
-	for (i = 0; i < rt.dnum; i++) {
-		b += sprintf(b, "%d ", rt.devices[i]);
+	if (!table) {
+		size = sizeof TABLE_HELP;
+
+		table = kmalloc(size, GFP_KERNEL);
+		if (table) {
+			memcpy(table, TABLE_HELP, size);
+		} else {
+			size = 0;
+		}
 	}
 
-	b--;
-
-	b += sprintf(b, "\n%d\n%d\n%d %d\n",
-		     rt.handle, rt.rwrap,
-		     rt.rules[rt.rnum].type, rt.rules[rt.rnum].data);
-
-	for (i = 0; i < rt.rnum; i++) {
-		b += sprintf(b, "%d %d %d\n",
-			     jiffies_to_msecs(rt.rules[i].target) / 100,
-			     rt.rules[i].type, rt.rules[i].data);
-	}
+	*buf = table;
 
-	return b - *buf;
+	return size;
 }
 
 void cleanup_table(void)
 {
 	kfree(rt.devices);
 	kfree(rt.rules);
+
 	memset(&rt, 0, sizeof (struct table));
 
 	next_rule = 0;
+
+	kfree(table);
+	table = NULL;
 }
diff --git a/table.h b/table.h
index 71b19d2..fd6b91f 100644
--- a/table.h
+++ b/table.h
@@ -65,17 +65,19 @@ static inline int tablecmp(struct table *l, struct table *r)
 	return 0;
 }
 
+#define TABLE_HELP "<debug>\n<N> <M>\n<input1> ... <inputN>\n<acpi>\n<wrap>\n<special type> <special data>\n<trigger1> <type1> <data1>\n...\n<triggerM> <typeM> <dataM>\n"
+
 #define TABLE_SIZE (sizeof (struct table) - 2 * sizeof (void *)	  \
 		    + rt.dnum * sizeof (int)			  \
 		    + rt.rnum * sizeof (struct rule))
 
 #define TABLE_BUFFER_SIZE (8 + rt.dnum + rt.rnum * 3 + (TABLE_SIZE << 3) / 3)
 
-extern void occasionally_generate_event(struct acpi_device *acpi_device);
+extern unsigned long occasionally_generate_event(struct acpi_device *acpi_device, unsigned long last);
 extern unsigned long timely_generate_event(struct acpi_device *acpi_device, unsigned long last, unsigned long *notify);
 
-extern int push_table(char *buf, unsigned long count);
-extern int pull_table(char **buf);
+extern int push_table(const char *buf, unsigned long count);
+extern size_t pull_table(char **buf);
 extern void cleanup_table(void);
 
 #endif /* TABLE_H */
-- 
1.4.4.4


--=-=-=


--
As you grow older, you'll find the only things you regret are the things you
didn't do. - Zachary Scott

--=-=-=--
