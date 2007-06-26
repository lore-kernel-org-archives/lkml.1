Return-Path: <linux-kernel-owner+w=401wt.eu-S1755903AbXFZKFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903AbXFZKFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbXFZKFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:05:13 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39896 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbXFZKFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:05:08 -0400
Date: Tue, 26 Jun 2007 12:06:29 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070626100628.GO24183@enneenne.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AoBLyXwWXtFbU0pZ"
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] LinuxPPS (with new syscalls API)
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--AoBLyXwWXtFbU0pZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

here my new version of LinuxPPS with a new syscalls API.

Please take a look at this new patch and report any
suggestions/modifications so I can prepare a proper patch for kernel
inclusion.

Thanks in advance,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127

--AoBLyXwWXtFbU0pZ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ntp-pps-2.6.21-new_API.diff"

diff --git a/Documentation/pps.txt b/Documentation/pps.txt
new file mode 100644
index 0000000..f07b098
--- /dev/null
+++ b/Documentation/pps.txt
@@ -0,0 +1,183 @@
+
+			PPS - Pulse Per Second
+			----------------------
+
+(C) Copyright 2007 Rodolfo Giometti <giometti@enneenne.com>
+
+This program is free software; you can redistribute it and/or modify
+it under the terms of the GNU General Public License as published by
+the Free Software Foundation; either version 2 of the License, or
+(at your option) any later version.
+
+This program is distributed in the hope that it will be useful,
+but WITHOUT ANY WARRANTY; without even the implied warranty of
+MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+GNU General Public License for more details.
+
+
+
+Overview
+--------
+
+LinuxPPS provides a programming interface (API) to define into the
+system several PPS sources.
+
+PPS means "pulse per second" and a PPS source is just a device which
+provides a high precision signal each second so that an application
+can use it to adjust system clock time.
+
+A PPS source can be connected to a serial port (usually to the Data
+Carrier Detect pin) or to a parallel port (ACK-pin) or to a special
+CPU's GPIOs (this is the common case in embedded systems) but in each
+case when a new pulse comes the system must apply to it a timestamp
+and record it for the userland.
+
+Common use is the combination of the NTPD as userland program with a
+GPS receiver as PPS source to obtain a wallclock-time with
+sub-millisecond synchronisation to UTC.
+
+
+RFC considerations
+------------------
+
+While implementing a PPS API as RFC 2783 defines and using an embedded
+CPU GPIO-Pin as physical link to the signal, I encountered a deeper
+problem:
+
+   At startup it needs a file descriptor as argument for the function
+   time_pps_create().
+
+This implies that the source has a /dev/... entry. This assumption is
+ok for the serial and parallel port, where you can do something
+useful besides(!) the gathering of timestamps as it is the central
+task for a PPS-API. But this assumption does not work for a single
+purpose GPIO line. In this case even basic file-related functionality
+(like read() and write()) makes no sense at all and should not be a
+precondition for the use of a PPS-API.
+
+The problem can be simply solved if you change the original RFC 2783:
+
+    pps_handle_t type is an opaque __scalar type__ used to represent a
+    PPS source within the API
+
+into a modified:
+
+   pps_handle_t type is an opaque __variable__ used to represent a PPS
+   source within the API and programs should not access it directly to
+   it due to its opacity.
+
+This change seems to be neglibile because even the original RFC 2783
+does not encourage programs to check (read: use) the pps_handle_t
+variable before calling the time_pps_*() functions, since each
+function should do this job internally.
+
+If I intentionally separate the concept of "file descriptor" from the
+concept of the "PPS source" I'm obliged to provide a solution to find
+and register a PPS-source without using a file descriptor: it's done
+by the functions time_pps_findsource() and time_pps_findpath() now.
+
+According to this current NTPD drivers' code should be modified as
+follows:
+
++#ifdef PPS_HAVE_FINDPATH
++      /* Get the PPS source's real name */
++      fd = readlink(link, path, STRING_LEN-1);
++      if (fd <= 0)
++              strncpy(path, link, STRING_LEN);
++      else
++              path[fd] = '\0';
++
++      /* Try to find the source */
++      fd = time_pps_findpath(path, STRING_LEN, id, STRING_LEN);
++      if (fd < 0) {
++              msyslog(LOG_ERR, "refclock: cannot find PPS source \"%s\" in the system", path);
++              return 1;
++      }
++      msyslog(LOG_INFO, "refclock: found PPS source #%d \"%s\" on \"%s\"", fd, path, id);
++#endif   /* PPS_HAVE_FINDPATH */
++
++
+       if (time_pps_create(fd, &pps_handle) < 0) {
+-              pps_handle = 0;
+               msyslog(LOG_ERR, "refclock: time_pps_create failed: %m");
+       }
+
+
+Coding example
+--------------
+
+To register a PPS source into the kernel you should define a struct
+pps_source_info_s as follow:
+
+    static struct pps_source_info_s pps_ktimer_info = {
+            name         : "ktimer",
+            path         : "",
+            mode         : PPS_CAPTUREASSERT|PPS_OFFSETASSERT|PPS_ECHOASSERT| \
+                           PPS_CANWAIT|PPS_TSFMT_TSPEC,
+            echo         : pps_ktimer_echo,
+    };
+
+and then calling the function pps_register_source() in your
+intialization routine as follow:
+
+    source = pps_register_source(&pps_ktimer_info,
+			PPS_CAPTUREASSERT|PPS_OFFSETASSERT,
+			-1 /* is up to the system */);
+
+The pps_register_source() prototype is:
+
+  int pps_register_source(struct pps_source_info_s *info, int default_params, int try_id)
+
+where "info" is a pointer to a structure that describes a particular
+PPS source, "default_params" tells the system what the initial default
+parameters for the device should be (is obvious that these parameters
+must be a subset of ones defined into the struct
+pps_source_info_s which describe the capabilities of the driver)
+and "try_id" can be used to force a particular ID for your device into
+the system (just use -1 if you wish the system chooses one for you).
+
+Once you have registered a new PPS source into the system you can
+signal an assert event (for example in the interrupt handler routine)
+just using:
+
+    pps_event(source, PPS_CAPTUREASSERT, ptr);
+
+The same function may also run the defined echo function
+(pps_ktimer_echo(), passing to it the "ptr" pointer) if the user
+asked for that... etc..
+
+Please see the file drivers/pps/clients/ktimer.c for an example code.
+
+
+SYSFS support
+-------------
+
+The SYSFS support is enabled by default if the SYSFS filesystem is
+enabled in the kernel and it provides a new class:
+
+   $ ls /sys/class/pps/
+   00/  01/  02/
+
+Every directory is the ID of a PPS sources defined into the system and
+inside you find several files:
+
+    $ ls /sys/class/pps/00/
+    assert	clear  echo  mode  name  path  subsystem@  uevent
+
+Inside each "assert" and "clear" file you can find the timestamp and a
+sequence number:
+
+    $ cat /sys/class/pps/00/assert
+    1170026870.983207967#8
+
+Where before the "#" is the timestamp in seconds and after it is the
+sequence number. Other files are:
+
+* echo: reports if the PPS source has an echo function or not;
+
+* mode: reports available PPS functioning modes;
+
+* name: reports the PPS source's name;
+
+* path: reports the PPS source's device path, that is the device the
+  PPS source is connected to (if it exists).
diff --git a/MAINTAINERS b/MAINTAINERS
index cfd26dd..dd6784d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2860,6 +2860,13 @@ P:	Michal Ostrowski
 M:	mostrows@speakeasy.net
 S:	Maintained
 
+PPS SUPPORT
+P:	Rodolfo Giometti
+M:	giometti@enneenne.com
+W:	http://wiki.enneenne.com/index.php/LinuxPPS_support
+L:	linuxpps@ml.enneenne.com
+S:	Maintained
+
 PREEMPTIBLE KERNEL
 P:	Robert Love
 M:	rml@tech9.net
diff --git a/arch/i386/kernel/syscall_table.S b/arch/i386/kernel/syscall_table.S
index 0772678..ae1df31 100644
--- a/arch/i386/kernel/syscall_table.S
+++ b/arch/i386/kernel/syscall_table.S
@@ -320,3 +320,8 @@ ENTRY(sys_call_table)
 	.long sys_getcpu
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
+	.long sys_time_pps_cmd
+	.long sys_time_pps_getparams
+	.long sys_time_pps_setparams
+	.long sys_time_pps_getcap
+	.long sys_time_pps_fetch	/* 325 */
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 050323f..bb54cab 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/pps/Kconfig"
+
 source "drivers/w1/Kconfig"
 
 source "drivers/hwmon/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 26ca903..97dc041 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_INPUT)		+= input/
 obj-$(CONFIG_I2O)		+= message/
 obj-$(CONFIG_RTC_LIB)		+= rtc/
 obj-y				+= i2c/
+obj-$(CONFIG_PPS)		+= pps/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_HWMON)		+= hwmon/
 obj-$(CONFIG_PHONE)		+= telephony/
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 62051f8..a50b336 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -746,6 +746,27 @@ static struct console lpcons = {
 
 #endif /* console on line printer */
 
+/* Support for PPS signal on the line printer */
+
+#ifdef CONFIG_PPS_CLIENT_LP
+
+static void lp_pps_echo(int source, int event, void *data)
+{
+	struct parport *port = data;
+	unsigned char status = parport_read_status(port);
+
+	/* echo event via SEL bit */
+	parport_write_control(port,
+		parport_read_control(port) | PARPORT_CONTROL_SELECT);
+
+	/* signal no event */
+	if ((status & PARPORT_STATUS_ACK) != 0)
+		parport_write_control(port,
+			parport_read_control(port) & ~PARPORT_CONTROL_SELECT); 
+}
+
+#endif
+
 /* --- initialisation code ------------------------------------- */
 
 static int parport_nr[LP_NO] = { [0 ... LP_NO-1] = LP_PARPORT_UNSPEC };
@@ -817,6 +838,35 @@ static int lp_register(int nr, struct parport *port)
 	}
 #endif
 
+#ifdef CONFIG_PPS_CLIENT_LP
+	snprintf(port->pps_info.path, PPS_MAX_NAME_LEN, "/dev/lp%d", nr);
+
+	/* No PPS support if lp port has no IRQ line */
+	if (port->irq != PARPORT_IRQ_NONE) {
+		strncpy(port->pps_info.name, port->name, PPS_MAX_NAME_LEN);
+
+		port->pps_info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
+				PPS_ECHOASSERT | \
+				PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+		port->pps_info.echo = lp_pps_echo;
+
+		port->pps_source = pps_register_source(&(port->pps_info),
+				PPS_CAPTUREASSERT | PPS_OFFSETASSERT,
+				-1 /* is up to the system */);
+		if (port->pps_source < 0) 
+			pps_err("cannot register PPS source \"%s\"",
+					port->pps_info.path);	
+		else
+			pps_info("PPS source #%d \"%s\" added to the system",
+					port->pps_source, port->pps_info.path);
+	} else {
+		port->pps_source = -1;
+		pps_err("PPS support disabled due port \"%s\" is in polling mode",
+			port->pps_info.path);
+	}
+#endif
+
 	return 0;
 }
 
@@ -860,6 +910,14 @@ static void lp_detach (struct parport *port)
 		console_registered = NULL;
 	}
 #endif /* CONFIG_LP_CONSOLE */
+
+#ifdef CONFIG_PPS_CLIENT_LP
+	if (port->pps_source >= 0) {
+		pps_unregister_source(&(port->pps_info));
+		pps_dbg("PPS source #%d \"%s\" removed from the system",
+			port->pps_source, port->pps_info.path);
+	}
+#endif
 }
 
 static struct parport_driver lp_driver = {
diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
new file mode 100644
index 0000000..0f5c784
--- /dev/null
+++ b/drivers/pps/Kconfig
@@ -0,0 +1,34 @@
+#
+# Character device configuration
+#
+
+menu "PPS support"
+
+config PPS
+	bool "PPS support"
+	depends on EXPERIMENTAL
+	---help---
+	  PPS (Pulse Per Second) is a special pulse provided by some GPS
+	  antennas. Userland can use it to get an high time reference.
+
+	  Some antennas' PPS signals are connected with the CD (Carrier
+	  Detect) pin of the serial line they use to communicate with the
+	  host. In this case use the SERIAL_LINE client support.
+
+	  Some antennas' PPS signals are connected with some special host
+	  inputs so you have to enable the corresponding client support.
+
+	  This PPS support can also be built as a module.  If so, the module
+	  will be called pps-core.
+
+config PPS_DEBUG
+	bool "PPS debugging messages"
+	depends on PPS 
+	help
+	  Say Y here if you want the PPS support to produce a bunch of debug
+	  messages to the system log.  Select this if you are having a
+	  problem with PPS support and want to see more of what is going on.
+
+source drivers/pps/clients/Kconfig
+
+endmenu
diff --git a/drivers/pps/Makefile b/drivers/pps/Makefile
new file mode 100644
index 0000000..76101cd
--- /dev/null
+++ b/drivers/pps/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the PPS core.
+#
+
+pps_core-objs			+= pps.o kapi.o sysfs.o
+obj-$(CONFIG_PPS)		+= pps_core.o
+obj-y				+= clients/
diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
new file mode 100644
index 0000000..867df3a
--- /dev/null
+++ b/drivers/pps/clients/Kconfig
@@ -0,0 +1,30 @@
+#
+# LinuxPPS clients configuration
+#
+
+if PPS
+
+comment "PPS clients support"
+
+config PPS_CLIENT_KTIMER
+	tristate "Kernel timer client (Testing client, use for debug)"
+	help
+	  If you say yes here you get support for a PPS debugging client
+	  which uses a kernel timer to generate the PPS signal.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called ktimer.o.
+
+config PPS_CLIENT_UART
+	bool "UART serial support"
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the CD (Carrier Detect) pin of your serial port.
+
+config PPS_CLIENT_LP
+	bool "Parallel printer support"
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the interrupt pin of your parallel port.
+
+endif
diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
new file mode 100644
index 0000000..3ecca41
--- /dev/null
+++ b/drivers/pps/clients/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for miscellaneous I2C chip drivers.
+#
+
+obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= ktimer.o
+
diff --git a/drivers/pps/clients/ktimer.c b/drivers/pps/clients/ktimer.c
new file mode 100644
index 0000000..e9e5c47
--- /dev/null
+++ b/drivers/pps/clients/ktimer.c
@@ -0,0 +1,113 @@
+/*
+ * ktimer.c -- kernel timer test client
+ *
+ *
+ * Copyright (C) 2005-2006   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+
+#include <linux/pps.h>
+
+/*
+ * Global variables
+ */
+
+static int source;
+static struct timer_list ktimer;
+
+/*
+ * The kernel timer
+ */
+
+static void pps_ktimer_event(unsigned long ptr)
+{
+	pps_info("PPS event at %lu", jiffies);
+
+	pps_event(source, PPS_CAPTUREASSERT, NULL);
+
+	mod_timer(&ktimer, jiffies + HZ);
+}
+
+/*
+ * The echo function
+ */
+
+static void pps_ktimer_echo(int source, int event, void *data)
+{
+	pps_info("echo %s %s for source %d",
+		event & PPS_CAPTUREASSERT ? "assert" : "",
+		event & PPS_CAPTURECLEAR ? "clear" : "",
+		source);
+}
+
+/*
+ * The PPS info struct
+ */
+
+static struct pps_source_info_s pps_ktimer_info = {
+	name		: "ktimer",
+	path		: "",
+	mode		: PPS_CAPTUREASSERT|PPS_OFFSETASSERT|PPS_ECHOASSERT| \
+			  PPS_CANWAIT|PPS_TSFMT_TSPEC,
+	echo 		: pps_ktimer_echo,
+};
+
+/*
+ * Module staff
+ */
+
+static void __exit pps_ktimer_exit(void)
+{
+	del_timer_sync(&ktimer);
+	pps_unregister_source(&pps_ktimer_info);
+
+	pps_info("ktimer PPS source unregistered");
+}
+
+static int __init pps_ktimer_init(void)
+{
+	int ret;
+
+	ret = pps_register_source(&pps_ktimer_info,
+				PPS_CAPTUREASSERT|PPS_OFFSETASSERT,
+				-1 /* is up to the system */);
+	if (ret < 0) {
+		pps_err("cannot register ktimer source");
+		return ret;
+	}
+	source = ret;
+
+	setup_timer(&ktimer, pps_ktimer_event, 0);
+	mod_timer(&ktimer, jiffies + HZ);
+
+	pps_info("ktimer PPS source registered at %d", source);
+
+	return  0;
+}
+
+module_init(pps_ktimer_init);
+module_exit(pps_ktimer_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("testing PPS source by using a kernel timer (just for debug)");
+MODULE_LICENSE("GPL");
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
new file mode 100644
index 0000000..dd24c31
--- /dev/null
+++ b/drivers/pps/kapi.c
@@ -0,0 +1,202 @@
+/*
+ * kapi.c -- kernel API
+ *
+ *
+ * Copyright (C) 2005-2007   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/time.h>
+#include <linux/pps.h>
+
+/* 
+ * Local functions
+ */
+
+static void pps_add_offset(struct timespec *ts, struct timespec *offset)
+{
+	ts->tv_nsec += offset->tv_nsec;
+	if (ts->tv_nsec >= NSEC_PER_SEC) {
+		ts->tv_nsec -= NSEC_PER_SEC;
+		ts->tv_sec++;
+	} else if (ts->tv_nsec < 0) {
+		ts->tv_nsec += NSEC_PER_SEC;
+		ts->tv_sec--;
+	}
+	ts->tv_sec += offset->tv_sec;
+}
+
+/*
+ * Exported functions
+ */
+
+static int __pps_register_source(struct pps_source_info_s *info,
+				int default_params, int try_id)
+{
+	int i;
+
+	if (try_id >= 0) {
+		if (pps_is_allocated(try_id)) {
+			pps_err("source id %d busy", try_id);
+			return -EBUSY;
+		}
+		i = try_id;
+	} else {
+		for (i = 0; i < PPS_MAX_SOURCES; i++)
+			if (!pps_is_allocated(i))
+				break;
+		if (i >= PPS_MAX_SOURCES) {
+			pps_err("no free source ids");
+			return -ENOMEM;
+		}
+	}
+
+	/* Sanity checks */
+	if ((info->mode & default_params) != default_params) {
+		pps_err("unsupported default parameters");
+		return -EINVAL;
+	}
+	if ((info->mode & (PPS_ECHOASSERT|PPS_ECHOCLEAR)) != 0 &&
+			info->echo == NULL) {
+		pps_err("echo function is not defined");
+		return -EINVAL;
+	}
+	if ((info->mode & (PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
+		pps_err("unspecified time format");
+		return -EINVAL;
+	}
+
+	/* Allocate the PPS source.
+	 *
+	 * Note that we should reset all fields BUT "info" one! */
+	memset(&(pps_source[i].params), 0, sizeof(struct pps_params));
+	pps_source[i].params.api_version = PPS_API_VERS;
+	pps_source[i].params.mode = default_params;
+	pps_source[i].assert_sequence = 0;
+	pps_source[i].clear_sequence = 0;
+	pps_source[i].current_mode = 0;
+	pps_source[i].go = 0;
+	init_waitqueue_head(&pps_source[i].queue);
+
+	/* Allocate the PPS source */
+	pps_source[i].info = info;
+
+	return i;
+}
+
+int pps_register_source(struct pps_source_info_s *info, int default_params,
+			int try_id)
+{
+	int i, ret;
+
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __pps_register_source(info, default_params, try_id);
+	mutex_unlock(&pps_mutex);
+
+	if (ret < 0)
+		return ret;
+	i = ret;
+
+	ret = pps_sysfs_create_source_entry(info, i);
+	if (ret < 0)
+		pps_err("unable to create sysfs entry for source %d", i);
+
+	return i;
+}
+EXPORT_SYMBOL(pps_register_source);
+
+static void __pps_unregister_source(struct pps_source_info_s *info)
+{  
+	int i;
+
+	for (i = 0; i < PPS_MAX_SOURCES; i++)
+		if (pps_is_allocated(i) && pps_source[i].info == info)
+			break;
+
+	if (i >= PPS_MAX_SOURCES) {
+		pps_err("warning! Try to unregister an unknow PPS source");
+		return;
+	}
+
+	/* Deallocate the PPS source */
+	pps_source[i].info = &dummy_info; 
+} 
+
+void pps_unregister_source(struct pps_source_info_s *info)
+{
+
+	pps_sysfs_remove_source_entry(info);
+
+	if (mutex_lock_interruptible(&pps_mutex))
+		return;
+	__pps_unregister_source(info);
+	mutex_unlock(&pps_mutex);
+}
+EXPORT_SYMBOL(pps_unregister_source);
+
+void pps_event(int source, int event, void *data)
+{
+	struct timespec ts;
+
+	/* First of all we get the time stamp... */
+	getnstimeofday(&ts);
+
+	if ((event & (PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0 ) {
+		pps_err("unknow event (%x) for source %d", event, source);
+		return;
+	}
+
+	/* Must call the echo function? */
+	if ((pps_source[source].params.mode & (PPS_ECHOASSERT|PPS_ECHOCLEAR)) != 0)
+		pps_source[source].info->echo(source, event, data);
+
+	/* Check the event */
+	pps_source[source].current_mode = pps_source[source].params.mode;
+	if (event & PPS_CAPTUREASSERT) {
+		/* We have to add an offset? */
+		if (pps_source[source].params.mode&PPS_OFFSETASSERT)
+			pps_add_offset(&ts,
+				&pps_source[source].params.assert_off_tu.tspec);
+
+		/* Save the time stamp */
+		pps_source[source].assert_tu.tspec = ts;
+		pps_source[source].assert_sequence++;
+		pps_dbg("capture assert seq #%lu for source %d", 
+			pps_source[source].assert_sequence, source);
+	}
+	if (event & PPS_CAPTURECLEAR) {
+		/* We have to add an offset? */
+		if (pps_source[source].params.mode&PPS_OFFSETCLEAR)
+			pps_add_offset(&ts,
+				&pps_source[source].params.clear_off_tu.tspec);
+
+		/* Save the time stamp */
+		pps_source[source].clear_tu.tspec = ts;
+		pps_source[source].clear_sequence++;
+		pps_dbg("capture clear seq #%lu for source %d", 
+			pps_source[source].clear_sequence, source);
+	}
+
+	pps_source[source].go = ~0;
+	wake_up_interruptible(&pps_source[source].queue);
+}
+EXPORT_SYMBOL(pps_event);
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
new file mode 100644
index 0000000..a350a45
--- /dev/null
+++ b/drivers/pps/pps.c
@@ -0,0 +1,406 @@
+/*
+ * pps.c -- Main PPS support file
+ *
+ *
+ * Copyright (C) 2005-2007   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#include <linux/kernel.h>
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/linkage.h>
+#include <linux/sched.h>
+#include <linux/pps.h>
+#include <asm/uaccess.h>
+
+/*
+ * Global variables
+ */
+
+struct pps_s pps_source[PPS_MAX_SOURCES];
+DEFINE_MUTEX(pps_mutex);
+
+void dummy_echo(int source, int event, void *data) { }
+struct pps_source_info_s dummy_info;	/* Dummy PPS info for unallocated
+					   PPS sources */
+
+/*
+ * Misc functions
+ */
+
+static inline int pps_check_source(int source)
+{
+	return (source < 0 || !pps_is_allocated(source)) ? -EINVAL : 0;
+}
+
+static int pps_find_source(int source)
+{
+	int i;
+
+	if (source >= 0) {
+		if (source >= PPS_MAX_SOURCES || !pps_is_allocated(source))
+			return -EINVAL;
+		else
+			return source;
+	}
+
+	for (i = 0; i < PPS_MAX_SOURCES; i++)
+		if (pps_is_allocated(i))
+			break;
+
+	if (i >= PPS_MAX_SOURCES)
+		return -EINVAL;
+
+	return i;
+}
+
+static int pps_find_path(char *path)
+{
+	int i;
+
+	for (i = 0; i < PPS_MAX_SOURCES; i++)
+		if (pps_is_allocated(i) &&
+		    (strncmp(pps_source[i].info->path, path,
+			     	PPS_MAX_NAME_LEN) == 0 ||
+		     strncmp(pps_source[i].info->name, path,
+			     	PPS_MAX_NAME_LEN) == 0))
+			break;
+
+	if (i >= PPS_MAX_SOURCES)
+		return -EINVAL;
+
+	return i;
+}
+
+/*
+ * PPS System Calls
+ */
+
+static long __sys_time_pps_cmd(int cmd, void __user *arg)
+{
+	struct pps_source_data_s *data = arg;
+
+	switch (cmd) {
+	case PPS_CMD_FIND_SRC :
+		pps_dbg("PPS_CMD_FIND_SRC: source %d", data->source);
+
+		data->source = pps_find_source(data->source);
+		if (data->source < 0) {
+			pps_dbg("no PPS devices found");
+			return -ENODEV;
+			break;
+	 	}
+
+		break;
+
+	case PPS_CMD_FIND_PATH :
+		pps_dbg("PPS_CMD_FIND_PATH: path %s", data->path);
+
+		data->source = pps_find_path(data->path);
+		if (data->source < 0) {
+			pps_dbg("no PPS devices found");
+			return -ENODEV;
+			break;
+	 	}
+
+		break;
+
+	default :
+		pps_err("invalid sys_time_pps_cmd %d", cmd);
+		return -EOPNOTSUPP;
+	}
+
+	/* Found! So copy the info */
+	strncpy(data->name, pps_source[data->source].info->name,
+				PPS_MAX_NAME_LEN);
+	strncpy(data->path, pps_source[data->source].info->path,
+				PPS_MAX_NAME_LEN);
+
+	return 0;
+}
+
+asmlinkage long sys_time_pps_cmd(int cmd, void __user *arg)
+{
+	int ret = -1;
+
+	pps_dbg("%s: cmd %d", __FUNCTION__, cmd);
+
+	/* Sanity checks */
+	if (_IOC_TYPE(cmd) != 'P')
+		return -EOPNOTSUPP;
+	if (_IOC_DIR(cmd) & _IOC_READ)
+		ret = !access_ok(VERIFY_WRITE, arg, _IOC_SIZE(cmd));
+	else if (_IOC_DIR(cmd) & _IOC_WRITE)
+		ret = !access_ok(VERIFY_READ, arg, _IOC_SIZE(cmd));
+	if (ret)
+		return -EFAULT;
+
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __sys_time_pps_cmd(cmd, arg);
+	mutex_unlock(&pps_mutex);
+
+	return ret;
+}
+
+static long __sys_time_pps_getparams(int source,
+					struct pps_params __user *params)
+{
+	int ret;
+
+	ret = pps_check_source(source);
+	if (ret < 0)
+		return -ENODEV;
+
+	*params = pps_source[source].params;
+
+	return 0;
+}
+
+asmlinkage long sys_time_pps_getparams(int source,
+					struct pps_params __user *params)
+{
+	int ret;
+
+	pps_dbg("%s: source %d", __FUNCTION__, source);
+
+	/* Sanity checks */
+	if (!params)
+		return -EINVAL;
+	if (!access_ok(VERIFY_WRITE, params, sizeof(struct pps_params)))
+		return -EFAULT;
+
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __sys_time_pps_getparams(source, params);
+	mutex_unlock(&pps_mutex);
+
+	return ret;
+}
+
+static long __sys_time_pps_setparams(int source,
+					const struct pps_params __user *params)
+{
+	int ret;
+
+	ret = pps_check_source(source);
+	if (ret < 0)
+		return -ENODEV;
+
+	/* Save the new parameters */
+	pps_source[source].params = *params;
+
+	/* Restore the read only parameters */
+	if ((params->mode & (PPS_TSFMT_TSPEC | PPS_TSFMT_NTPFP)) == 0) {
+		/* section 3.3 of RFC 2783 interpreted */
+		pps_dbg("time format unspecified");
+		pps_source[source].params.mode |= PPS_TSFMT_TSPEC;
+	}
+	if (pps_source[source].info->mode & PPS_CANWAIT)
+		pps_source[source].params.mode |= PPS_CANWAIT;
+	pps_source[source].params.api_version = PPS_API_VERS;
+
+	return 0;
+}
+
+asmlinkage long sys_time_pps_setparams(int source,
+					const struct pps_params __user *params)
+{
+	int ret;
+
+	pps_dbg("%s: source %d", __FUNCTION__, source);
+
+	/* Check the capabilities */
+	if (!capable(CAP_SYS_TIME))
+		return -EPERM;
+
+	/* Sanity checks */
+	if (!params)
+		return -EINVAL;
+	if (!access_ok(VERIFY_READ, params, sizeof(struct pps_params)))
+		return -EFAULT;
+	if ((params->mode & ~pps_source[source].info->mode) != 0) {
+		pps_dbg("unsupported capabilities");
+		return -EINVAL;
+ 	}
+	if ((params->mode & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
+		pps_dbg("capture mode unspecified");
+		return -EINVAL;
+	}
+
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __sys_time_pps_setparams(source, params);
+	mutex_unlock(&pps_mutex);
+
+	return ret;
+}
+
+static long __sys_time_pps_getcap(int source, int __user *mode)
+{
+	int ret;
+
+	ret = pps_check_source(source);
+	if (ret < 0)
+		return -ENODEV;
+
+	*mode = pps_source[source].info->mode;
+
+	return 0;
+}
+
+asmlinkage long sys_time_pps_getcap(int source, int __user *mode)
+{
+	int ret;
+
+	pps_dbg("%s: source %d", __FUNCTION__, source);
+
+	/* Sanity checks */
+	if (!mode)
+		return -EINVAL;
+	if (!access_ok(VERIFY_WRITE, mode, sizeof(int)))
+		return -EFAULT;
+
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __sys_time_pps_getcap(source, mode);
+	mutex_unlock(&pps_mutex);
+
+	return ret;
+}
+
+static long __sys_time_pps_fetch(int source, const int tsformat,
+					struct pps_info __user *info, 
+					const struct timespec __user *timeout)
+{
+	unsigned long ticks;
+	int ret;
+
+	ret = pps_check_source(source);
+	if (ret < 0)
+		return -ENODEV;
+
+	pps_source[source].go = 0;
+
+ 	/* Manage the timeout */
+	if (timeout || timeout->tv_sec != -1) {
+		if (!access_ok(VERIFY_READ, timeout, sizeof(struct timespec)))
+			return -EFAULT;
+
+		pps_dbg("timeout %ld.%09ld", timeout->tv_sec, timeout->tv_nsec);
+		ticks = timeout->tv_sec * HZ;
+		ticks += timeout->tv_nsec/ (NSEC_PER_SEC / HZ);
+
+		if (ticks != 0) {
+			ret = wait_event_interruptible_timeout(
+				pps_source[source].queue,
+				pps_source[source].go, ticks);
+  			if (ret == 0) {
+				pps_dbg("timeout expired");
+				return -ETIMEDOUT;
+			}
+		}
+ 	} else
+		ret = wait_event_interruptible( pps_source[source].queue,
+				pps_source[source].go);
+
+	/* Check for pending signals */
+	if (ret == -ERESTARTSYS) {
+		pps_dbg("pending signal caught");
+		return -EINTR;
+	}
+
+	/* Return the fetched timestamp */
+	info->assert_sequence = pps_source[source].assert_sequence;
+	info->clear_sequence = pps_source[source].clear_sequence;
+	info->assert_tu = pps_source[source].assert_tu;
+	info->clear_tu = pps_source[source].clear_tu;
+	info->current_mode = pps_source[source].current_mode;
+
+	return 0;
+}
+
+asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
+					struct pps_info __user *info, 
+					const struct timespec __user *timeout)
+{
+	int ret;
+
+	pps_dbg("%s: source %d", __FUNCTION__, source);
+
+	/* Sanity checks */
+	if (tsformat != PPS_TSFMT_TSPEC) {
+		pps_dbg("unsupported time format");
+		return -EINVAL;
+ 	}
+	if (!info)
+		return -EINVAL;
+	if (!access_ok(VERIFY_WRITE, info, sizeof(struct pps_info)))
+		return -EFAULT;
+
+	if (mutex_lock_interruptible(&pps_mutex))
+		return -EINTR;
+	ret = __sys_time_pps_fetch(source, tsformat, info, timeout);
+	mutex_unlock(&pps_mutex);
+
+	return ret;
+}
+
+/*
+ * Module staff
+ */
+
+static void __exit pps_exit(void)
+{
+	pps_sysfs_unregister();
+
+	pps_info("LinuxPPS API ver. %d removed", PPS_API_VERS);
+}
+
+static int __init pps_init(void)
+{
+	int i, ret;
+
+	/* Init pps_source info */
+	dummy_info.echo = dummy_echo;
+	for (i = 0; i < PPS_MAX_SOURCES; i++) {
+		pps_source[i].info = &dummy_info;
+		init_waitqueue_head(&pps_source[i].queue);
+	}
+
+	/* Register to sysfs */
+	ret = pps_sysfs_register();
+	if (ret < 0) {
+		pps_err("unable to register sysfs");
+		return ret;
+	}
+
+	pps_info("LinuxPPS API ver. %d registered", PPS_API_VERS);
+	pps_info("Software ver. %s - Copyright 2005-2007 Rodolfo Giometti "
+		"<giometti@linux.it>", PPS_VERSION);
+
+	return 0;
+}
+
+subsys_initcall(pps_init);
+module_exit(pps_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("LinuxPPS support (RFC 2783) - ver. " PPS_VERSION);
+MODULE_LICENSE("GPL");
diff --git a/drivers/pps/sysfs.c b/drivers/pps/sysfs.c
new file mode 100644
index 0000000..0dae24b
--- /dev/null
+++ b/drivers/pps/sysfs.c
@@ -0,0 +1,219 @@
+/*
+ * sysfs.c -- sysfs support
+ *
+ *
+ * Copyright (C) 2007   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#include <linux/pps.h>
+
+/*
+ * Private functions
+ */
+
+static ssize_t pps_show_assert(struct class_device *cdev, char *buf)
+{
+	struct pps_s *dev = class_get_devdata(cdev);
+
+	return sprintf(buf, "%ld.%09ld#%ld\n",
+			dev->assert_tu.tspec.tv_sec,
+			dev->assert_tu.tspec.tv_nsec,
+			dev->assert_sequence);
+}
+
+static ssize_t pps_show_clear(struct class_device *cdev, char *buf)
+{
+	struct pps_s *dev = class_get_devdata(cdev);
+
+	return sprintf(buf, "%ld.%09ld#%ld\n",
+			dev->clear_tu.tspec.tv_sec,
+			dev->clear_tu.tspec.tv_nsec,
+			dev->clear_sequence);
+}
+
+static ssize_t pps_show_mode(struct class_device *cdev, char *buf)
+{
+	struct pps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%4x\n", info->mode);
+}
+
+static ssize_t pps_show_echo(struct class_device *cdev, char *buf)
+{
+	struct pps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%d\n", !!info->echo);
+}
+
+static ssize_t pps_show_name(struct class_device *cdev, char *buf)
+{
+	struct pps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%s\n", info->name);
+}
+
+static ssize_t pps_show_path(struct class_device *cdev, char *buf)
+{
+	struct pps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%s\n", info->path);
+}
+
+/*
+ * Files definitions
+ */
+
+#define DECLARE_INFO_ATTR(_name, _mode, _show, _store)			\
+{									\
+	.attr   = {							\
+		.name = __stringify(_name),				\
+		.mode = _mode, 						\
+		.owner = THIS_MODULE,					\
+	},								\
+	.show   = _show,						\
+	.store  = _store,						\
+}
+
+static struct class_device_attribute pps_class_device_attributes[] = {
+	DECLARE_INFO_ATTR(assert, 0444, pps_show_assert, NULL),
+	DECLARE_INFO_ATTR(clear, 0444, pps_show_clear, NULL),
+	DECLARE_INFO_ATTR(mode, 0444, pps_show_mode, NULL),
+	DECLARE_INFO_ATTR(echo, 0444, pps_show_echo, NULL),
+	DECLARE_INFO_ATTR(name, 0444, pps_show_name, NULL),
+	DECLARE_INFO_ATTR(path, 0444, pps_show_path, NULL),
+};
+
+/*
+ * Class definitions
+ */
+
+static void pps_class_release(struct class_device *cdev)
+{
+	/* Nop??? */
+}
+
+static struct class pps_class = {
+	.name = "pps",
+	.release = pps_class_release,
+};
+
+/*
+ * Public functions
+ */
+
+void pps_sysfs_remove_source_entry(struct pps_source_info_s *info)
+{
+	int i;
+
+	/* Sanity checks */
+	if (info == NULL)
+		return;
+
+	/* Delete info files */
+	if (info->mode&PPS_CAPTUREASSERT)
+		class_device_remove_file(&info->class_dev,
+					&pps_class_device_attributes[0]);
+
+	if (info->mode&PPS_CAPTURECLEAR)
+		class_device_remove_file(&info->class_dev,
+					&pps_class_device_attributes[1]);
+
+	for (i = 2; i < ARRAY_SIZE(pps_class_device_attributes); i++)
+		class_device_remove_file(&info->class_dev,
+					&pps_class_device_attributes[i]);
+
+	/* Deregister the pps class */
+	class_device_unregister(&info->class_dev);
+}
+
+int pps_sysfs_create_source_entry(struct pps_source_info_s *info, int id)
+{
+	char buf[32];
+	int i, ret;
+
+	/* Sanity checks */
+	if (info == NULL || id >= PPS_MAX_SOURCES)
+		return -EINVAL;
+
+	/* Create dir class device name */
+	sprintf(buf, "%.02d", id);
+
+	/* Setup the class struct */
+	memset(&info->class_dev, 0, sizeof(struct class_device));
+	info->class_dev.class = &pps_class;
+	strlcpy(info->class_dev.class_id, buf, KOBJ_NAME_LEN);
+	class_set_devdata(&info->class_dev, &pps_source[id]);
+
+	/* Register the new class */
+	ret = class_device_register(&info->class_dev);
+	if (unlikely(ret))
+		goto error_class_device_register;
+
+	/* Create info files */
+
+	/* Create file "assert" and "clear" according to source capability */
+	if (info->mode & PPS_CAPTUREASSERT) {
+		ret = class_device_create_file(&info->class_dev,
+					&pps_class_device_attributes[0]);
+		i = 0;
+		if (unlikely(ret))
+			goto error_class_device_create_file;
+	}
+	if (info->mode & PPS_CAPTURECLEAR) {
+		ret = class_device_create_file(&info->class_dev,
+					&pps_class_device_attributes[1]);
+		i = 1;
+		if (unlikely(ret))
+			goto error_class_device_create_file;
+	}
+
+	for (i = 2; i < ARRAY_SIZE(pps_class_device_attributes); i++) {
+		ret = class_device_create_file(&info->class_dev,
+					&pps_class_device_attributes[i]);
+		if (unlikely(ret))
+			goto error_class_device_create_file;
+	}
+
+	return 0;
+
+error_class_device_create_file:
+	while (--i >= 0)
+		class_device_remove_file(&info->class_dev,
+					&pps_class_device_attributes[i]);
+
+	class_device_unregister(&info->class_dev);
+	/* Here the  release() method was already called */
+
+error_class_device_register:
+
+	return ret;
+}
+
+void pps_sysfs_unregister(void)
+{
+	class_unregister(&pps_class);
+}
+
+int pps_sysfs_register(void)
+{
+	return class_register(&pps_class);
+}
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 48e259a..3e6ed91 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2101,6 +2101,8 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 		up->ier |= UART_IER_MSI;
 	if (up->capabilities & UART_CAP_UUE)
 		up->ier |= UART_IER_UUE | UART_IER_RTOIE;
+	if (up->port.flags & UPF_HARDPPS_CD)
+		up->ier |= UART_IER_MSI;	/* enable interrupts */
 
 	serial_out(up, UART_IER, up->ier);
 
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 326020f..4a9906f 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -33,6 +33,7 @@
 #include <linux/serial.h> /* for serial_state and serial_icounter_struct */
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/pps.h>
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -633,6 +634,52 @@ static int uart_get_info(struct uart_state *state,
 	return 0;
 }
 
+#ifdef CONFIG_PPS_CLIENT_UART
+
+static int
+uart_register_pps_port(struct uart_state *state, struct uart_port *port)
+{
+	struct tty_driver *drv = port->info->tty->driver;
+	int ret;
+
+	snprintf(state->pps_info.name, PPS_MAX_NAME_LEN, "%s%d",
+		drv->driver_name, port->line);
+	snprintf(state->pps_info.path, PPS_MAX_NAME_LEN, "/dev/%s%d",
+		drv->name, port->line);
+
+	state->pps_info.mode = PPS_CAPTUREBOTH | \
+			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
+			PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+	ret = pps_register_source(&state->pps_info, PPS_CAPTUREBOTH | \
+				PPS_OFFSETASSERT | PPS_OFFSETCLEAR,
+				-1 /* PPS ID is up to the system */);
+	if (ret < 0) {
+		pps_err("cannot register PPS source \"%s\"", state->pps_info.path);
+		return ret;
+	}
+	port->pps_source = ret;
+	pps_info("PPS source #%d \"%s\" added to the system ",
+		port->pps_source, state->pps_info.path);
+
+	return 0;
+}
+
+static void
+uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
+{
+	pps_unregister_source(&state->pps_info);
+	pps_dbg("PPS source #%d \"%s\" removed from the system",
+	port->pps_source, state->pps_info.path);
+}
+
+#else
+
+#define uart_register_pps_port(state, port)	do { } while (0)
+#define uart_unregister_pps_port(state, port)	do { } while (0)
+
+#endif /* CONFIG_PPS_CLIENT_UART */
+
 static int uart_set_info(struct uart_state *state,
 			 struct serial_struct __user *newinfo)
 {
@@ -807,11 +854,19 @@ static int uart_set_info(struct uart_state *state,
 			(port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 
  check_and_exit:
+	/* PPS support enabled/disabled? */
+	if ((old_flags & UPF_HARDPPS_CD) != (new_flags & UPF_HARDPPS_CD)) {
+		if (new_flags & UPF_HARDPPS_CD)
+			uart_register_pps_port(state, port);
+		else	
+			uart_unregister_pps_port(state, port);
+	}
+
 	retval = 0;
 	if (port->type == PORT_UNKNOWN)
 		goto exit;
 	if (state->info->flags & UIF_INITIALIZED) {
-		if (((old_flags ^ port->flags) & UPF_SPD_MASK) ||
+		if (((old_flags ^ port->flags) & (UPF_SPD_MASK|UPF_HARDPPS_CD)) ||
 		    old_custom_divisor != port->custom_divisor) {
 			/*
 			 * If they're setting up a custom divisor or speed,
@@ -2100,6 +2155,12 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		port->ops->config_port(port, flags);
 	}
 
+	/*
+ 	 * Add the PPS support for the current port.
+ 	 */
+	if (port->flags & UPF_HARDPPS_CD)
+		uart_register_pps_port(state, port);
+
 	if (port->type != PORT_UNKNOWN) {
 		unsigned long flags;
 
@@ -2349,6 +2410,12 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *port)
 	mutex_unlock(&state->mutex);
 
 	/*
+ 	 * Remove PPS support from the current port.
+	 */
+	if (port->flags & UPF_HARDPPS_CD)
+		uart_unregister_pps_port(state, port);
+
+	/*
 	 * Remove the devices from the tty layer
 	 */
 	tty_unregister_device(drv->tty_driver, port->line);
diff --git a/include/asm-i386/unistd.h b/include/asm-i386/unistd.h
index bd21e79..b3e7a31 100644
--- a/include/asm-i386/unistd.h
+++ b/include/asm-i386/unistd.h
@@ -326,10 +326,15 @@
 #define __NR_getcpu		318
 #define __NR_epoll_pwait	319
 #define __NR_utimensat		320
+#define __NR_time_pps_cmd	321
+#define __NR_time_pps_getparams	322
+#define __NR_time_pps_setparams	323
+#define __NR_time_pps_getcap	324
+#define __NR_time_pps_fetch	325
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 321
+#define NR_syscalls 326
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/linux/parport.h b/include/linux/parport.h
index 9cdd694..f53d9f4 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -100,6 +100,7 @@ typedef enum {
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
+#include <linux/pps.h>
 #include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/semaphore.h>
@@ -327,6 +328,11 @@ struct parport {
 
 	struct list_head full_list;
 	struct parport *slaves[3];
+
+#ifdef CONFIG_PPS_CLIENT_LP
+	struct pps_source_info_s pps_info;
+	int pps_source;		/* PPS source ID */
+#endif
 };
 
 #define DEFAULT_SPIN_TIME 500 /* us */
@@ -517,6 +523,12 @@ extern int parport_daisy_select (struct parport *port, int daisy, int mode);
 /* Lowlevel drivers _can_ call this support function to handle irqs.  */
 static __inline__ void parport_generic_irq(int irq, struct parport *port)
 {
+#ifdef CONFIG_PPS_CLIENT_LP
+	pps_event(port->pps_source, PPS_CAPTUREASSERT, port);
+	pps_dbg("parport_pc: PPS assert event at %lu on source #%d",
+		jiffies, port->pps_source);
+#endif
+
 	parport_ieee1284_interrupt (irq, port);
 	read_lock(&port->cad_lock);
 	if (port->cad && port->cad->irq_func)
diff --git a/include/linux/pps.h b/include/linux/pps.h
new file mode 100644
index 0000000..231dbe9
--- /dev/null
+++ b/include/linux/pps.h
@@ -0,0 +1,211 @@
+/*
+ * pps.h -- PPS API kernel header.
+ *
+ *
+ * Copyright (C) 2005-2007   Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+
+#ifndef _PPS_H_
+#define _PPS_H_
+
+/* Implementation note: the logical states ``assert'' and ``clear''
+ * are implemented in terms of the chip register, i.e. ``assert''
+ * means the bit is set.  */
+
+/*
+ * 3.2 New data structures
+ */
+
+#ifndef __KERNEL__
+#include <asm/types.h>
+#include <sys/time.h>
+#endif
+
+#define PPS_API_VERS_2          2       /* LinuxPPS proposal, dated 2006-05 */
+#define PPS_API_VERS            PPS_API_VERS_2
+#define LINUXPSS_API            1       /* mark LinuxPPS API */
+
+#define PPS_MAX_NAME_LEN	32
+
+struct ntp_fp {
+	unsigned int integral;
+	unsigned int fractional;
+};
+
+union pps_timeu {
+	struct timespec tspec;
+	struct ntp_fp ntpfp;
+	unsigned long longpad[3];
+};
+
+struct pps_info {
+	unsigned long assert_sequence;	/* seq. num. of assert event */
+	unsigned long clear_sequence; 	/* seq. num. of clear event */
+	union pps_timeu assert_tu;	/* time of assert event */
+	union pps_timeu clear_tu;	/* time of clear event */
+	int current_mode;		/* current mode bits */
+};
+
+struct pps_params {
+	int api_version;		/* API version # */
+	int mode;			/* mode bits */
+	union pps_timeu assert_off_tu;	/* offset compensation for assert */
+	union pps_timeu clear_off_tu;	/* offset compensation for clear */
+};
+
+/*
+ * 3.3 Mode bit definitions
+ */
+
+/* Device/implementation parameters */
+#define PPS_CAPTUREASSERT	0x01	/* capture assert events */
+#define PPS_CAPTURECLEAR	0x02	/* capture clear events */
+#define PPS_CAPTUREBOTH		0x03	/* capture assert and clear events */
+
+#define PPS_OFFSETASSERT	0x10	/* apply compensation for assert ev. */
+#define PPS_OFFSETCLEAR		0x20	/* apply compensation for clear ev. */
+
+#define PPS_CANWAIT		0x100	/* can we wait for an event? */
+#define PPS_CANPOLL		0x200	/* bit reserved for future use */
+
+/* Kernel actions */
+#define PPS_ECHOASSERT		0x40	/* feed back assert event to output */
+#define PPS_ECHOCLEAR		0x80	/* feed back clear event to output */
+
+/* Timestamp formats */
+#define PPS_TSFMT_TSPEC		0x1000	/* select timespec format */
+#define PPS_TSFMT_NTPFP		0x2000	/* select NTP format */
+
+/*
+ * 3.4.4 New functions: disciplining the kernel timebase
+ */
+
+/* Kernel consumers */
+#define PPS_KC_HARDPPS		0	/* hardpps() (or equivalent) */
+#define PPS_KC_HARDPPS_PLL	1	/* hardpps() constrained to
+					   use a phase-locked loop */
+#define PPS_KC_HARDPPS_FLL	2	/* hardpps() constrained to
+					use a frequency-locked loop */
+/*
+ * Here begins the implementation-specific part!
+ */
+
+#include <linux/ioctl.h>
+
+struct pps_source_data_s {
+	int source;
+	char name[PPS_MAX_NAME_LEN];
+	char path[PPS_MAX_NAME_LEN];
+};
+
+#define PPS_CMD_FIND_SRC	_IOWR('P',  1, struct pps_source_data *)
+#define PPS_CMD_FIND_PATH	_IOWR('P',  2, struct pps_source_data *)
+
+#ifdef __KERNEL__
+
+#include <linux/device.h>
+
+/*
+ * Misc macros
+ */
+
+#define PPS_VERSION	"4.0.0-rc1"
+
+#ifdef CONFIG_PPS_DEBUG
+#define pps_dbg(format, arg...) printk(KERN_DEBUG "%s: " format "\n" , \
+	KBUILD_MODNAME , ## arg)
+#else
+#define pps_dbg(format, arg...) do {} while (0)
+#endif
+
+#define pps_err(format, arg...) printk(KERN_ERR "%s: " format "\n" , \
+	KBUILD_MODNAME , ## arg)
+#define pps_info(format, arg...) printk(KERN_INFO "%s: " format "\n" , \
+	KBUILD_MODNAME , ## arg)
+
+/*
+ * Global defines
+ */
+
+#define PPS_MAX_SOURCES		16
+
+/* The specific PPS source info */
+struct pps_source_info_s {
+	char name[PPS_MAX_NAME_LEN];		/* simbolic name */
+	char path[PPS_MAX_NAME_LEN];		/* path of connected device */
+	int mode;				/* PPS's allowed mode */
+
+	void (*echo)(int source, int event, void *data);/* the PPS echo function */
+
+	/* sysfs section */
+	struct class_device class_dev;
+};
+
+/* The main struct */
+struct pps_s {
+	struct pps_source_info_s *info;		/* PSS source info */
+
+	struct pps_params params;		/* PPS's current params */
+
+	volatile unsigned long assert_sequence;	/* PPS' assert event seq # */
+	volatile unsigned long clear_sequence;	/* PPS' clear event seq # */
+	volatile union pps_timeu assert_tu;
+	volatile union pps_timeu clear_tu;
+	int current_mode;			/* PPS mode at event time */
+
+	int go;					/* PPS event is arrived? */
+	wait_queue_head_t queue;		/* PPS event queue */
+};
+
+/*
+ * Global variables
+ */
+
+extern struct pps_s pps_source[PPS_MAX_SOURCES];
+extern struct mutex pps_mutex;
+extern struct pps_source_info_s dummy_info;
+
+/*
+ * Global functions
+ */
+
+static inline int pps_is_allocated(int source)
+{
+	return pps_source[source].info != &dummy_info;
+}
+
+#define to_pps_info(obj) container_of((obj), struct pps_source_info_s, class_dev)
+
+/*
+ * Exported functions
+ */
+
+extern int pps_register_source(struct pps_source_info_s *info,
+				int default_params, int try_id);
+extern void pps_unregister_source(struct pps_source_info_s *info);
+extern void pps_event(int source, int event, void *data);
+
+extern int pps_sysfs_create_source_entry(struct pps_source_info_s *info,
+				int id);
+extern void pps_sysfs_remove_source_entry(struct pps_source_info_s *info);
+extern int pps_sysfs_register(void);
+extern void pps_sysfs_unregister(void);
+
+#endif /* __KERNEL__ */
+
+#endif /* _PPS_H_ */
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index aa2653a..01a6547 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -148,6 +148,7 @@
 #include <linux/sched.h>
 #include <linux/tty.h>
 #include <linux/mutex.h>
+#include <linux/pps.h>
 
 struct uart_port;
 struct uart_info;
@@ -227,6 +228,9 @@ struct uart_port {
 	unsigned char		regshift;		/* reg offset shift */
 	unsigned char		iotype;			/* io access style */
 	unsigned char		unused1;
+#ifdef CONFIG_PPS_CLIENT_UART
+	int			pps_source;		/* PPS source ID */
+#endif
 
 #define UPIO_PORT		(0)
 #define UPIO_HUB6		(1)
@@ -271,7 +275,8 @@ struct uart_port {
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
 
 #define UPF_CHANGE_MASK		((__force upf_t) (0x17fff))
-#define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY))
+#define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY\
+							|UPF_HARDPPS_CD))
 
 	unsigned int		mctrl;			/* current modem ctrl settings */
 	unsigned int		timeout;		/* character-based timeout */
@@ -303,6 +308,10 @@ struct uart_state {
 	struct uart_info	*info;
 	struct uart_port	*port;
 
+#ifdef CONFIG_PPS_CLIENT_UART
+        struct pps_source_info_s pps_info;
+#endif
+
 	struct mutex		mutex;
 };
 
@@ -467,13 +476,23 @@ uart_handle_dcd_change(struct uart_port *port, unsigned int status)
 {
 	struct uart_info *info = port->info;
 
-	port->icount.dcd++;
-
-#ifdef CONFIG_HARD_PPS
-	if ((port->flags & UPF_HARDPPS_CD) && status)
-		hardpps();
+#ifdef CONFIG_PPS_CLIENT_UART
+	if (port->flags & UPF_HARDPPS_CD) {
+		if (status) {
+			pps_event(port->pps_source, PPS_CAPTUREASSERT, port);
+			pps_dbg("serial8250: PPS assert event at %lu on source #%d",
+				jiffies, port->pps_source);
+		}
+		else {
+			pps_event(port->pps_source, PPS_CAPTURECLEAR, port);
+			pps_dbg("serial8250: PPS clear event at %lu on source #%d",
+				jiffies, port->pps_source);
+		}
+	}
 #endif
 
+	port->icount.dcd++;
+
 	if (info->flags & UIF_CHECK_CD) {
 		if (status)
 			wake_up_interruptible(&info->open_wait);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3139f44..ab89db0 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -65,6 +65,7 @@ struct getcpu_cache;
 #include <asm/signal.h>
 #include <linux/quota.h>
 #include <linux/key.h>
+#include <linux/pps.h>
 
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
@@ -605,6 +606,16 @@ asmlinkage long sys_set_robust_list(struct robust_list_head __user *head,
 				    size_t len);
 asmlinkage long sys_getcpu(unsigned __user *cpu, unsigned __user *node, struct getcpu_cache __user *cache);
 
+asmlinkage long sys_time_pps_cmd(int cmd, void __user *arg);
+asmlinkage long sys_time_pps_getparams(int source,
+					struct pps_params __user *params);
+asmlinkage long sys_time_pps_setparams(int source,
+					const struct pps_params __user *params);
+asmlinkage long sys_time_pps_getcap(int source, int __user *mode);
+asmlinkage long sys_time_pps_fetch(int source, const int tsformat,
+					struct pps_info __user *info,
+					const struct timespec __user *timeout);
+
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
 #endif
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index d7306d0..2bbd244 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -141,3 +141,10 @@ cond_syscall(compat_sys_migrate_pages);
 cond_syscall(sys_bdflush);
 cond_syscall(sys_ioprio_set);
 cond_syscall(sys_ioprio_get);
+
+/* PPS dependent */
+cond_syscall(sys_time_pps_find);
+cond_syscall(sys_time_pps_getparams);
+cond_syscall(sys_time_pps_setparams);
+cond_syscall(sys_time_pps_getcap);
+cond_syscall(sys_time_pps_fetch);

--AoBLyXwWXtFbU0pZ--
