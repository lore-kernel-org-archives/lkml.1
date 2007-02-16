Return-Path: <linux-kernel-owner+w=401wt.eu-S1946046AbXBPSwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946046AbXBPSwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946210AbXBPSwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:52:20 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:50467 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946046AbXBPSwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:52:16 -0500
Date: Fri, 16 Feb 2007 19:52:30 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: linux-kernel@vger.kernel.org
Cc: linuxpps@ml.enneenne.com
Message-ID: <20070216185230.GO8882@enneenne.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TKYYegg/GYAC5JIZ"
Content-Disposition: inline
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--TKYYegg/GYAC5JIZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Pulse per Second (PPS) support for Linux.

Signed-off-by: Rodolfo Giometti <giometti@enneenne.com>

---

Please, note that this PPS implementation is not RFC 2783 fully
compatible since, IMHO, the RFC simply doesn't consider PPS devices
connected with special GPIOs or other ports different from serial
ports and parallele ports.

Please read the following consideratios before sending to /dev/null!
:)

RFC considerations
------------------

While implementing a PPS API as RFC 2783 defines and using an embedded
CPU GPIO-Pin as physical link to the signal, I encountered a deeper
problem:

   At startup it needs a file descriptor as argument for the function
   time_pps_create().

This implies that the source has a /dev/... entry. This assumption is
ok for the serial and parallel port, where you can do something
usefull beside(!) the gathering of timestamps as it is the central
task for a PPS-API. But this assumption does not work for a single
purpose GPIO line. In this case even basic file-related functionality
(like read() and write()) makes no sense at all and should not be a
precondition for the use of a PPS-API.

The problem can be simply solved if you change the original RFC 2783:

    pps_handle_t type is an opaque __scalar type__ used to represent a
    PPS source within the API

into a modified:

   pps_handle_t type is an opaque __variable__ used to represent a PPS
   source within the API and programs should not access it directly to
   it due to its opacity.

This change seems to be neglibile because even the original RFC 2783
does not encourage programs to check (read: use) the pps_handle_t
variable before calling the time_pps_*() functions, since each
function should do this job internally.

If I intentionally separate the concept of "file descriptor" from the
concept of the "PPS source" I'm obliged to provide a solution to find
and register a PPS-source without using a file descriptor: it's done
by the functions time_pps_findsource() and time_pps_findpath() now.

According to this current NTPD drivers' code should be modified as
follows:

+#ifdef PPS_HAVE_FINDPATH
+      /* Get the PPS source's real name */
+      fd = readlink(link, path, STRING_LEN-1);
+      if (fd <= 0)
+              strncpy(path, link, STRING_LEN);
+      else
+              path[fd] = '\0';
+
+      /* Try to find the source */
+      fd = time_pps_findpath(path, STRING_LEN, id, STRING_LEN);
+      if (fd < 0) {
+              msyslog(LOG_ERR, "refclock: cannot find PPS source \"%s\" in the system", path);
+              return 1;
+      }
+      msyslog(LOG_INFO, "refclock: found PPS source #%d \"%s\" on \"%s\"", fd, path, id);
+#endif   /* PPS_HAVE_FINDPATH */
+
+
       if (time_pps_create(fd, &pps_handle) < 0) {
-              pps_handle = 0;
               msyslog(LOG_ERR, "refclock: time_pps_create failed: %m");
       }

--TKYYegg/GYAC5JIZ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ntp-pps-2.6.20.diff"

diff --git a/Documentation/pps.txt b/Documentation/pps.txt
new file mode 100644
index 0000000..a00b9d0
--- /dev/null
+++ b/Documentation/pps.txt
@@ -0,0 +1,206 @@
+
+			PPS - Pulse Per Second
+			----------------------
+
+(C) Copyright 2007 Rodolfo Giometti <giometti@enneenne.com>
+
+
+Overview
+--------
+
+LinuxPPS provides a programming interface (API) to define into the
+system several PPS sources.
+
+PPS means "pulse per second" and a PPS source is just a device who
+provides an high and precise signal each second so that an application
+can use it to adjust time clock.
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
+usefull beside(!) the gathering of timestamps as it is the central
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
+linuxpps_source_info_s as follow:
+
+    static struct linuxpps_source_info_s linuxpps_ktimer_info = {
+            name         : "ktimer",
+            path         : "",
+            mode         : PPS_CAPTUREASSERT|PPS_OFFSETASSERT|PPS_ECHOASSERT| \
+                           PPS_CANWAIT|PPS_TSFMT_TSPEC,
+            echo         : linuxpps_ktimer_echo,
+    };
+
+and then calling the function linuxpps_register_source() in your
+intialization routine as follow:
+
+    source = linuxpps_register_source(&linuxpps_ktimer_info,
+			PPS_CAPTUREASSERT|PPS_OFFSETASSERT,
+			-1 /* is up to the system */);
+
+The linuxpps_register_source() prototype is:
+
+  int linuxpps_register_source(struct linuxpps_source_info_s *info, int default_params, int try_id)
+
+where "info" is a pointer to a structure that describes a particular
+PPS source, "default_params" tells the system what the initial default
+parameters for the device should be (is obvious that these parameters
+must be a subset of ones defined into the struct
+linuxpps_source_info_s which describe the capabilities of the driver)
+and "try_id" can be used to force a particular ID for your device into
+the system (just use -1 if you wish the system chooses one for you).
+
+Once you have registered a new PPS source into the system you can
+signal an assert event (for example in the interrupt handler routine)
+just using:
+
+    linuxpps_event(source, PPS_CAPTUREASSERT, ptr);
+
+The same function may also run the defined echo function
+(linuxpps_ktimer_echo(), passing to it the "ptr" pointer) if the user
+asked for that... etc..
+
+Please see the file drivers/pps/clients/ktimer.c for an example code.
+
+
+PROCFS support
+--------------
+
+If PROCFS support is enabled a new directory "/proc/pps" is created:
+
+    $ ls /proc/pps/
+    00       01       sources
+
+The file "sources" holds a brief description of all PPS sources
+defined in the system:
+
+    $ cat /proc/pps/sources 
+    id    mode		echo	name			path
+    ----  ------	----	----------------	----------------
+    00    1133		no	serial0			/dev/ttyS0
+    01    1133		no	serial1			/dev/ttyS1
+
+The other entries are directories that hold one or two files according
+to the ability of the associated source to provide "assert" and
+"clear" timestamps:
+
+    $ ls /proc/pps/00 
+    assert		  clear
+
+Inside each "assert" and "clear" file you can find the timestamp and a
+sequence number:
+
+    $ cat /proc/pps/00/assert 
+    1170026870.983207967 #8
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
+Files "assert" and "clear" have the same functionality as their PROCFS
+counterparts but with different syntax due to the one-value-per-file
+sysfs pragma. Other files are:
+
+* echo: reports if the PPS source has an echo function or not;
+
+* mode: reports available PPS functioning modes (in the same form as
+  PROCFS does);
+
+* name: reports the PPS source's name;
+
+* path: reports the PPS source's device path, that is the device the
+  PPS source is connected to (if it exists).
+
+
+Resources
+---------
+
+Wiki: http://wiki.enneenne.com/index.php/LinuxPPS_support and the LinuxPPS
+ML:   http://ml.enneenne.com/cgi-bin/mailman/listinfo/linuxpps.
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
index 3a718f5..d0007f7 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_INPUT)		+= input/
 obj-$(CONFIG_I2O)		+= message/
 obj-$(CONFIG_RTC_LIB)		+= rtc/
 obj-$(CONFIG_I2C)		+= i2c/
+obj-$(CONFIG_PPS)		+= pps/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_HWMON)		+= hwmon/
 obj-$(CONFIG_PHONE)		+= telephony/
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index b51d08b..6185679 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -750,6 +750,27 @@ static struct console lpcons = {
 
 #endif /* console on line printer */
 
+/* --- support for PPS signal on the line printer -------------- */
+
+#ifdef CONFIG_PPS_CLIENT_LP
+
+static inline void lp_pps_echo(int source, int event, void *data)
+{
+	struct parport *port = (struct parport *) data;
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
@@ -821,6 +842,36 @@ static int lp_register(int nr, struct parport *port)
 	}
 #endif
 
+#ifdef CONFIG_PPS_CLIENT_LP
+	snprintf(port->pps_info.path, LINUXPPS_MAX_NAME_LEN, "/dev/lp%d", nr);
+
+	/* No PPS support if lp port has no IRQ line */
+	if (port->irq != PARPORT_IRQ_NONE) {
+		strncpy(port->pps_info.name, port->name, LINUXPPS_MAX_NAME_LEN);
+
+		port->pps_info.mode = PPS_CAPTUREASSERT | PPS_OFFSETASSERT | \
+				PPS_ECHOASSERT | \
+				PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+		port->pps_info.echo = lp_pps_echo;
+
+		port->pps_source = linuxpps_register_source(&(port->pps_info),
+				PPS_CAPTUREASSERT | PPS_OFFSETASSERT,
+				-1 /* is up to the system */);
+		if (port->pps_source < 0) 
+			err("cannot register PPS source \"%s\"",
+					port->pps_info.path);	
+		else
+			info("PPS source #%d \"%s\" added to the system",
+					port->pps_source, port->pps_info.path);
+	}
+	else {
+		port->pps_source = -1;
+		err("PPS support disabled due port \"%s\" is in polling mode",
+			port->pps_info.path);
+	}
+#endif
+
 	return 0;
 }
 
@@ -864,6 +915,14 @@ static void lp_detach (struct parport *port)
 		console_registered = NULL;
 	}
 #endif /* CONFIG_LP_CONSOLE */
+
+#ifdef CONFIG_PPS_CLIENT_LP
+	if (port->pps_source >= 0) {
+		linuxpps_unregister_source(&(port->pps_info));
+		dbg("PPS source #%d \"%s\" removed from the system",
+			port->pps_source, port->pps_info.path);
+	}
+#endif
 }
 
 static struct parport_driver lp_driver = {
diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index b61c17b..426b0ac 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -272,6 +272,14 @@ static int clear_epp_timeout(struct parport *pb)
 
 static irqreturn_t parport_pc_interrupt(int irq, void *dev_id)
 {
+#ifdef CONFIG_PPS_CLIENT_LP_PARPORT_PC
+	struct parport *p = (struct parport *) dev_id;
+
+	linuxpps_event(p->pps_source, PPS_CAPTUREASSERT, p);
+	dbg("parport_pc: PPS assert event at %lu on source #%d",
+		jiffies, p->pps_source);
+#endif
+
 	parport_generic_irq(irq, (struct parport *) dev_id);
 	/* FIXME! Was it really ours? */
 	return IRQ_HANDLED;
diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
new file mode 100644
index 0000000..20aa5f0
--- /dev/null
+++ b/drivers/pps/Kconfig
@@ -0,0 +1,43 @@
+#
+# Character device configuration
+#
+
+menu "PPS support"
+
+config PPS
+	tristate "PPS support"
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
+config PPS_PROCFS
+	bool "PPS procfs support"
+	depends on PPS 
+	default y
+	help
+	  Say Y here if you want the PPS support to produce a new file into
+	  the "/proc" directory which holds useful information regarding
+	  registered PPS clients into the system.
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
index 0000000..cc51203
--- /dev/null
+++ b/drivers/pps/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the PPS core.
+#
+
+pps_core-objs			+= pps.o kapi.o sysfs.o procfs.o
+obj-$(CONFIG_PPS)		+= pps_core.o
+obj-y				+= clients/
diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
new file mode 100644
index 0000000..4214b52
--- /dev/null
+++ b/drivers/pps/clients/Kconfig
@@ -0,0 +1,56 @@
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
+comment "UART serial support (forced off)"
+	depends on SERIAL_CORE && ( PPS = m && SERIAL_CORE = y )
+
+config PPS_CLIENT_UART
+	bool "UART serial support"
+	depends on SERIAL_CORE && ! ( PPS = m && SERIAL_CORE = y )
+
+comment "8250 serial support (forced off)"
+	depends on PPS_CLIENT_UART && SERIAL_8250 && \
+			( PPS = m && SERIAL_8250 = y )
+
+config PPS_CLIENT_UART_8250
+	bool "8250 serial support"
+	depends on PPS_CLIENT_UART && SERIAL_8250 && \
+			! ( PPS = m && SERIAL_8250 = y )
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the CD (Carrier Detect) pin of your 8250 serial line chip.
+
+comment "Parallel printer support (forced off)"
+	depends on PRINTER && ( PPS = m && PRINTER = y )
+
+config PPS_CLIENT_LP
+	bool "Parallel printer support"
+	depends on PRINTER && ! ( PPS = m && PRINTER = y )
+
+comment "Parport PC support (forced off)"
+	depends on PPS_CLIENT_LP && PARPORT_PC && \
+			( PPS = m && PARPORT_PC = y )
+
+config PPS_CLIENT_LP_PARPORT_PC
+	bool "Parport PC support"
+	depends on PPS_CLIENT_LP && PARPORT_PC && \
+                       ! ( PPS = m && PARPORT_PC = y )
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the interrupt pin of your PC parallel port.
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
index 0000000..e0f6989
--- /dev/null
+++ b/drivers/pps/clients/ktimer.c
@@ -0,0 +1,107 @@
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
+#include <linux/timepps.h>
+#include <linux/pps.h>
+
+/* --- Global variables ----------------------------------------------------- */
+
+static int source;
+static struct timer_list ktimer;
+
+/* --- The kernel timer ----------------------------------------------------- */
+
+static void linuxpps_ktimer_event(unsigned long ptr) {
+	info("PPS event at %lu", jiffies);
+
+	linuxpps_event(source, PPS_CAPTUREASSERT, NULL);
+
+	/* Rescheduling */
+	ktimer.expires = jiffies+HZ;   /* 1 second */
+	add_timer(&ktimer);
+}
+
+/* --- The echo function ---------------------------------------------------- */
+
+static void linuxpps_ktimer_echo(int source, int event, void *data)
+{
+	info("echo %s %s for source %d",
+	 event&PPS_CAPTUREASSERT ? "assert" : "",
+	 event&PPS_CAPTURECLEAR ? "clear" : "",
+	 source);
+}
+
+/* --- The PPS info struct -------------------------------------------------- */
+
+static struct linuxpps_source_info_s linuxpps_ktimer_info = {
+	name		: "ktimer",
+	path		: "",
+	mode		: PPS_CAPTUREASSERT|PPS_OFFSETASSERT|PPS_ECHOASSERT| \
+			  PPS_CANWAIT|PPS_TSFMT_TSPEC,
+	echo 	: linuxpps_ktimer_echo,
+};
+
+/* --- Module staff -------------------------------------------------------- */
+
+static void __exit linuxpps_ktimer_exit(void)
+{
+	del_timer_sync(&ktimer);
+	linuxpps_unregister_source(&linuxpps_ktimer_info);
+
+	info("ktimer PPS source unregistered");
+}
+
+static int __init linuxpps_ktimer_init(void)
+{
+	int ret;
+
+	ret = linuxpps_register_source(&linuxpps_ktimer_info,
+				PPS_CAPTUREASSERT|PPS_OFFSETASSERT,
+				-1 /* is up to the system */);
+	if (ret < 0) {
+		err("cannot register ktimer source");
+		return ret;
+	}
+	source = ret;
+
+	init_timer(&ktimer);
+	ktimer.function = linuxpps_ktimer_event;
+	ktimer.expires = jiffies+HZ;   /* 1 second */
+	add_timer(&ktimer);
+
+	info("ktimer PPS source registered at %d", source);
+
+	return  0;
+}
+
+module_init(linuxpps_ktimer_init);
+module_exit(linuxpps_ktimer_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("testing PPS source by using a kernel timer (just for debug)");
+MODULE_LICENSE("GPL");
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
new file mode 100644
index 0000000..f4b0b6e
--- /dev/null
+++ b/drivers/pps/kapi.c
@@ -0,0 +1,213 @@
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
+#include <linux/time.h>
+
+#include <linux/timepps.h>
+#include <linux/pps.h>
+
+/* --- Local functions ----------------------------------------------------- */
+
+#ifndef NSEC_PER_SEC
+#define	NSEC_PER_SEC		1000000000
+#endif
+static void linuxpps_add_offset(struct timespec *ts, struct timespec *offset)
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
+/* --- Exported functions -------------------------------------------------- */
+
+static inline int __linuxpps_register_source(struct linuxpps_source_info_s *info, int default_params, int try_id)
+{
+	int i;
+
+	if (try_id >= 0) {
+		if (__linuxpps_is_allocated(try_id)) {
+			err("source id %d busy", try_id);
+			return -EBUSY;
+		}
+		i = try_id;
+	}
+	else {
+		for (i = 0; i < LINUXPPS_MAX_SOURCES; i++)
+			if (!__linuxpps_is_allocated(i))
+				break;
+		if (i >= LINUXPPS_MAX_SOURCES) {
+			err("no free source ids");
+			return -ENOMEM;
+		}
+	}
+
+	/* Sanity checks */
+	if ((info->mode&default_params) != default_params) {
+		err("unsupported default parameters");
+		return -EINVAL;
+	}
+	if ((info->mode&(PPS_ECHOASSERT|PPS_ECHOCLEAR)) != 0 && info->echo == NULL) {
+		err("echo function is not defined");
+		return -EINVAL;
+	}
+	if ((info->mode&(PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
+		err("unspecified time format");
+		return -EINVAL;
+	}
+
+	/* Allocate the PPS source */
+	memset(&linuxpps_source[i], 0, sizeof(struct linuxpps_s));
+	linuxpps_source[i].info = info;
+	linuxpps_source[i].params.api_version = PPS_API_VERS;
+	linuxpps_source[i].params.mode = default_params;
+	init_waitqueue_head(&linuxpps_source[i].queue);
+
+	return i;
+}
+
+int linuxpps_register_source(struct linuxpps_source_info_s *info, int default_params, int try_id)
+{
+	unsigned long flags;
+	int i, ret;
+
+	spin_lock_irqsave(&linuxpps_lock, flags);
+	ret = __linuxpps_register_source(info, default_params, try_id);
+	spin_unlock_irqrestore(&linuxpps_lock, flags);
+
+	if (ret < 0)
+		return ret;
+	i = ret;
+
+	ret = linuxpps_sysfs_create_source_entry(info, i);
+	if (ret < 0)
+		err("unable to create sysfs entry for source %d", i);
+
+	ret = linuxpps_procfs_create_source_entry(info, i);
+	if (ret < 0)
+		err("unable to create procfs entry for source %d", i);
+
+	return i;
+}
+
+static inline int __linuxpps_unregister_source(struct linuxpps_source_info_s *info)
+{  
+	int i;
+
+	for (i = 0; i < LINUXPPS_MAX_SOURCES; i++)
+		if (__linuxpps_is_allocated(i) && linuxpps_source[i].info == info)
+			break;
+
+	if (i >= LINUXPPS_MAX_SOURCES) {
+		err("warning! Try to unregister an unknow PPS source");
+		return -EINVAL;
+	}
+
+	/* Deallocate the PPS source */
+	linuxpps_source[i].info = NULL; 
+
+	return i;
+} 
+
+void linuxpps_unregister_source(struct linuxpps_source_info_s *info)
+{
+	unsigned long flags;
+	int i, ret;
+
+	spin_lock_irqsave(&linuxpps_lock, flags);
+	ret = __linuxpps_unregister_source(info);
+	spin_unlock_irqrestore(&linuxpps_lock, flags);
+
+	if (ret < 0)
+		return;
+	i = ret;
+
+	linuxpps_sysfs_remove_source_entry(info, i);
+	linuxpps_procfs_remove_source_entry(info, i);
+}
+
+void linuxpps_event(int source, int event, void *data)
+{
+	struct timespec ts;
+
+	/* In this function we shouldn't need locking at all since each PPS
+	 * source arrives once per second and due the per-PPS source data
+	 * array... */
+
+	/* First of all we get the time stamp... */
+	getnstimeofday(&ts);
+
+	/* ... then we can do some sanity checks */
+	if (!linuxpps_is_allocated(source)) {
+		err("unknow source for event!");
+		return;
+	}
+	if ((event&(PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0 ) {
+		err("unknow event (%x) for source %d", event, source);
+		return;
+	}
+
+	/* Must call the echo function? */
+	if ((linuxpps_source[source].params.mode&(PPS_ECHOASSERT|PPS_ECHOCLEAR)) != 0)
+		linuxpps_source[source].info->echo(source, event, data);
+
+	/* Check the event */
+	linuxpps_source[source].current_mode = linuxpps_source[source].params.mode;
+	if (event&PPS_CAPTUREASSERT) {
+		/* We have to add an offset? */
+		if (linuxpps_source[source].params.mode&PPS_OFFSETASSERT)
+			linuxpps_add_offset(&ts, &linuxpps_source[source].params.assert_off_tu.tspec);
+
+		/* Save the time stamp */
+		linuxpps_source[source].assert_tu.tspec = ts;
+		linuxpps_source[source].assert_sequence++;
+		dbg("capture assert seq #%lu for source %d", 
+			linuxpps_source[source].assert_sequence, source);
+	}
+	if (event&PPS_CAPTURECLEAR) {
+		/* We have to add an offset? */
+		if (linuxpps_source[source].params.mode&PPS_OFFSETCLEAR)
+			linuxpps_add_offset(&ts, &linuxpps_source[source].params.clear_off_tu.tspec);
+
+		/* Save the time stamp */
+		linuxpps_source[source].clear_tu.tspec = ts;
+		linuxpps_source[source].clear_sequence++;
+		dbg("capture clear seq #%lu for source %d", 
+			linuxpps_source[source].clear_sequence, source);
+	}
+
+	wake_up_interruptible(&linuxpps_source[source].queue);
+}
+
+/* --- Exported functions -------------------------------------------------- */
+
+EXPORT_SYMBOL(linuxpps_register_source);
+EXPORT_SYMBOL(linuxpps_unregister_source);
+EXPORT_SYMBOL(linuxpps_event);
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
new file mode 100644
index 0000000..b3c677f
--- /dev/null
+++ b/drivers/pps/pps.c
@@ -0,0 +1,377 @@
+/*
+ * main.c -- Main driver file
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
+#include <linux/skbuff.h>
+
+#include <linux/timepps.h>
+#include <linux/pps.h>
+
+/* --- Global variables ---------------------------------------------------- */
+
+struct linuxpps_s linuxpps_source[LINUXPPS_MAX_SOURCES];
+spinlock_t linuxpps_lock = SPIN_LOCK_UNLOCKED;
+
+/* --- Local variables ----------------------------------------------------- */
+
+static struct sock *nl_sk = NULL;
+
+/* --- Misc functions ------------------------------------------------------ */
+
+static inline int linuxpps_find_source(int source)
+{
+	int i;
+
+	if (source >= 0) {
+		if (source >= LINUXPPS_MAX_SOURCES || !linuxpps_is_allocated(source))
+			return -EINVAL;
+		else
+			return source;
+	}
+
+	for (i = 0; i < LINUXPPS_MAX_SOURCES; i++)
+		if (linuxpps_is_allocated(i))
+			break;
+
+	if (i >= LINUXPPS_MAX_SOURCES)
+		return -EINVAL;
+
+	return i;
+}
+
+static inline int linuxpps_find_path(char *path)
+{
+	int i;
+
+	for (i = 0; i < LINUXPPS_MAX_SOURCES; i++)
+		if (linuxpps_is_allocated(i) &&
+		    (strncmp(linuxpps_source[i].info->path, path,
+			     	LINUXPPS_MAX_NAME_LEN) == 0 ||
+		     strncmp(linuxpps_source[i].info->name, path,
+			     	LINUXPPS_MAX_NAME_LEN) == 0))
+			break;
+
+	if (i >= LINUXPPS_MAX_SOURCES)
+		return -EINVAL;
+
+	return i;
+}
+
+/* --- Input function ------------------------------------------------------ */
+
+static void linuxpps_nl_data_ready(struct sock *sk, int len)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct pps_netlink_msg *nlpps;
+
+	int cmd, source, id;
+	wait_queue_head_t *queue;
+	unsigned long timeout;
+
+	int ret;
+
+	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
+		nlh = (struct nlmsghdr *) skb->data;
+		dbg("New message from PID %d (flags %x)",
+			nlh->nlmsg_pid, nlh->nlmsg_flags);
+
+		/* Decode the userland command */
+		nlpps = (struct pps_netlink_msg*) NLMSG_DATA(nlh);
+		cmd = nlpps->cmd;
+		source = nlpps->source;
+
+		switch (cmd) {
+		case PPS_CREATE : {
+			dbg("PPS_CREATE: source %d", source);
+
+			/* Check if the requested source is allocated */
+			ret = linuxpps_find_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+
+			nlpps->source = ret;
+			nlpps->ret = 0;
+
+			break;
+		}
+
+		case PPS_DESTROY : {
+			dbg("PPS_DESTROY: source %d", source);
+
+			/* Nothing to do here! Just answer ok... */
+			nlpps->ret = 0;
+
+			break;
+		}
+
+		case PPS_SETPARMS : {
+			dbg("PPS_SETPARMS: source %d", source);
+
+			/* Check the capabilities */
+			if (!capable(CAP_SYS_TIME)) {
+				nlpps->ret = -EPERM;
+				break;
+		 	}
+
+			/* Sanity checks */
+			if (nlpps->source < 0 || !linuxpps_is_allocated(source)) {
+				nlpps->ret = -EINVAL;
+				break;
+			}
+			if ((nlpps->params.mode&~linuxpps_source[source].info->mode) != 0) {
+				dbg("unsupported capabilities");
+				nlpps->ret = -EINVAL;
+				break;
+		 	}
+			if ((nlpps->params.mode&(PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0) {
+				dbg("capture mode unspecified");
+				nlpps->ret = -EINVAL;
+				break;
+			}
+			if ((nlpps->params.mode&(PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
+				/* section 3.3 of RFC 2783 interpreted */
+				dbg("time format unspecified");
+				nlpps->params.mode |= PPS_TSFMT_TSPEC;
+			}
+
+			/* Save the new parameters */
+			linuxpps_source[source].params = nlpps->params;
+
+			/* Restore the read only parameters */
+			if (linuxpps_source[source].info->mode&PPS_CANWAIT)
+				linuxpps_source[source].params.mode |= PPS_CANWAIT;
+			linuxpps_source[source].params.api_version = PPS_API_VERS;
+
+			nlpps->ret = 0;
+
+			break;
+		}
+
+		case PPS_GETPARMS : {
+			dbg("PPS_GETPARMS: source %d", source);
+
+			/* Sanity checks */
+			if (nlpps->source < 0 || !linuxpps_is_allocated(source)) {
+				nlpps->ret = -EINVAL;
+				break;
+		 	}
+
+			nlpps->params = linuxpps_source[source].params;
+			nlpps->ret = 0;
+
+			break;
+	 	}
+
+	 	case PPS_GETCAP : {
+			dbg("PPS_GETCAP: source %d", source);
+
+			/* Sanity checks */
+			if (nlpps->source < 0 || !linuxpps_is_allocated(source)) {
+				nlpps->ret = -EINVAL;
+				break;
+		 	}
+
+			nlpps->mode = linuxpps_source[source].info->mode;
+			nlpps->ret = 0;
+
+			break;
+	 	}
+
+	 	case PPS_FETCH : {
+			dbg("PPS_FETCH: source %d", source);
+			queue = &linuxpps_source[source].queue;
+
+			/* Sanity checks */
+			if (nlpps->source < 0 || !linuxpps_is_allocated(source)) {
+				nlpps->ret = -EINVAL;
+				break;
+		 	}
+			if ((nlpps->tsformat != PPS_TSFMT_TSPEC) != 0 ) {
+				dbg("unsupported time format");
+				nlpps->ret = -EINVAL;
+				break;
+		 	}
+
+		 	/* Manage the timeout */
+			if (nlpps->timeout.tv_sec != -1) {
+				timeout = nlpps->timeout.tv_sec*HZ;
+				timeout += nlpps->timeout.tv_nsec/(1000000000/HZ);
+
+				if (timeout != 0) {
+					timeout = interruptible_sleep_on_timeout(queue, timeout);
+		  			if (timeout <= 0) {
+						dbg("timeout expired");
+						nlpps->ret = -ETIMEDOUT;
+						break;
+					}
+				}
+		 	}
+			else
+				interruptible_sleep_on(queue);
+
+			/* Return the fetched timestamp */
+			nlpps->info.assert_sequence = linuxpps_source[source].assert_sequence;
+			nlpps->info.clear_sequence = linuxpps_source[source].clear_sequence;
+			nlpps->info.assert_tu = linuxpps_source[source].assert_tu;
+			nlpps->info.clear_tu = linuxpps_source[source].clear_tu;
+			nlpps->info.current_mode = linuxpps_source[source].current_mode;
+
+			nlpps->ret = 0;
+
+			break;
+	 	}
+
+	 	case PPS_KC_BIND : {
+			dbg("PPS_KC_BIND: source %d", source);
+			/* Feature currently not supported */
+			nlpps->ret = -EOPNOTSUPP;
+
+			break;
+	 	}
+
+		case PPS_FIND_SRC : {
+			dbg("PPS_FIND_SRC: source %d", source);
+			source = linuxpps_find_source(source);
+			if (source < 0) {
+				dbg("no PPS devices found");
+				nlpps->ret = -ENODEV;
+				break;
+		 	}
+
+			/* Found! So copy the info */
+			nlpps->source = source;
+			strncpy(nlpps->name, linuxpps_source[source].info->name,
+				LINUXPPS_MAX_NAME_LEN);
+			strncpy(nlpps->path, linuxpps_source[source].info->path,
+				LINUXPPS_MAX_NAME_LEN);
+			nlpps->ret = 0;
+
+			break;
+	 	}
+
+		case PPS_FIND_PATH : {
+			dbg("PPS_FIND_PATH: source %s", nlpps->path);
+			source = linuxpps_find_path(nlpps->path);
+			if (source < 0) {
+				dbg("no PPS devices found");
+				nlpps->ret = -ENODEV;
+				break;
+		 	}
+
+			/* Found! So copy the info */
+			nlpps->source = source;
+			strncpy(nlpps->name, linuxpps_source[source].info->name,
+				LINUXPPS_MAX_NAME_LEN);
+			strncpy(nlpps->path, linuxpps_source[source].info->path,
+				LINUXPPS_MAX_NAME_LEN);
+			nlpps->ret = 0;
+
+			break;
+	 	}
+
+		default : {
+			/* Unknow command */
+			dbg("unknow command %d", nlpps->cmd);
+
+			nlpps->ret = -EINVAL;
+		}
+		}
+
+		/* Send an answer to the userland */
+		id = NETLINK_CB(skb).pid;
+		dbg("start sending reply to ID %d...", id);
+		NETLINK_CB(skb).pid = 0;	/* from the kernel */
+		NETLINK_CB(skb).dst_group = 0;	/* not in mcast groups */
+
+		ret = netlink_unicast(nl_sk, skb, id, MSG_DONTWAIT);
+		dbg("... reply sent (%d)", ret);
+	}
+}
+
+/* --- Module staff -------------------------------------------------------- */
+
+static void __exit linuxpps_exit(void)
+{
+	linuxpps_sysfs_unregister();
+	linuxpps_procfs_unregister();
+	sock_release(nl_sk->sk_socket);
+
+	info("LinuxPPS API ver. %d removed", PPS_API_VERS);
+}
+
+static int __init linuxpps_init(void)
+{
+	int ret;
+
+	nl_sk = netlink_kernel_create(NETLINK_PPSAPI, 0,
+					linuxpps_nl_data_ready, THIS_MODULE);
+	if (nl_sk == NULL) {
+		err("unable to create netlink kernel socket");
+		return -EBUSY;
+	}
+	dbg("netlink protocol %d created", NETLINK_PPSAPI);
+
+	/* Init the main struct */
+	memset(linuxpps_source, 0, sizeof(struct linuxpps_s)*LINUXPPS_MAX_SOURCES);
+
+	/* Register to sysfs */
+	ret = linuxpps_sysfs_register();
+	if (ret < 0) {
+		err("unable to register sysfs");
+		goto linuxpps_sysfs_register_error;
+	}
+
+	/* Register to procfs */
+	ret = linuxpps_procfs_register();
+	if (ret < 0) {
+		err("unable to register procfs");
+		goto linuxpps_procfs_register_error;
+	}
+
+	info("LinuxPPS API ver. %d registered", PPS_API_VERS);
+	info("Software ver. %s - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>", PPS_VERSION);
+
+	return  0;
+
+linuxpps_procfs_register_error :
+
+	linuxpps_sysfs_unregister();
+
+linuxpps_sysfs_register_error :
+
+	sock_release(nl_sk->sk_socket);
+
+	return ret;
+}
+
+subsys_initcall(linuxpps_init);
+module_exit(linuxpps_exit);
+
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("LinuxPPS support (RFC 2783) - ver. " PPS_VERSION);
+MODULE_LICENSE("GPL");
diff --git a/drivers/pps/procfs.c b/drivers/pps/procfs.c
new file mode 100644
index 0000000..929d9d7
--- /dev/null
+++ b/drivers/pps/procfs.c
@@ -0,0 +1,179 @@
+/*
+ * procfs.c -- procfs support
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
+#include <linux/proc_fs.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+#include <linux/timepps.h>
+#include <linux/pps.h>
+
+#ifdef CONFIG_PPS_PROCFS
+
+static struct proc_dir_entry *procfs_root_dir;
+
+/* ----- Private functions -------------------------------------------- */
+
+static int linuxpps_procfs_assert_read(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	int len = 0;
+	int id = (int) data;
+	len += sprintf(page+len, "%ld.%09ld #%ld\n",
+			linuxpps_source[id].assert_tu.tspec.tv_sec,
+			linuxpps_source[id].assert_tu.tspec.tv_nsec,
+			linuxpps_source[id].assert_sequence);
+
+	*eof = 1;
+	return len;
+}
+
+static int linuxpps_procfs_clear_read(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	int len = 0;
+	int id = (int) data;
+	len += sprintf(page+len, "%ld.%09ld #%ld\n",
+			linuxpps_source[id].clear_tu.tspec.tv_sec,
+			linuxpps_source[id].clear_tu.tspec.tv_nsec,
+			linuxpps_source[id].clear_sequence);
+
+	*eof = 1;
+	return len;
+}
+
+static int linuxpps_sources_read(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	int i;
+	int len = 0;
+
+	len += sprintf(page+len, "id\tmode\techo\tname\t\t\tpath\n");
+	len += sprintf(page+len, "----\t------\t----\t----------------\t----------------\n");
+	for (i = 0; i < LINUXPPS_MAX_SOURCES; i++)
+		if (linuxpps_is_allocated(i))
+			len += sprintf(page+len, "%.02d\t%4x\t%s\t%s\t\t%s\n",
+					i,
+					linuxpps_source[i].info->mode,
+					linuxpps_source[i].info->echo ? "yes" : "no",
+				 	linuxpps_source[i].info->name,
+				 	linuxpps_source[i].info->path);
+	
+	*eof = 1;
+	return len;
+}
+
+/* ----- Public functions --------------------------------------------- */
+
+void linuxpps_procfs_remove_source_entry(struct linuxpps_source_info_s *info, int id) {
+	char buf[32];
+
+	/* Sanity checks */
+	if (info == NULL || info->dir == NULL || id >= LINUXPPS_MAX_SOURCES)
+		return;
+
+	remove_proc_entry("clear", info->dir);	
+	remove_proc_entry("assert", info->dir);	
+	sprintf(buf, "%.02d", id);
+	remove_proc_entry(buf, procfs_root_dir);	
+}
+
+int linuxpps_procfs_create_source_entry(struct linuxpps_source_info_s *info, int id) {
+	struct proc_dir_entry *procfs_file;
+	char buf[32];
+
+	/* Sanity checks */
+	if (info == NULL || id >= LINUXPPS_MAX_SOURCES)
+		return -EINVAL;
+
+	/* Create dir "/proc/pps/<id>" */
+	sprintf(buf, "%.02d", id);
+	info->dir = proc_mkdir(buf, procfs_root_dir);
+	if (info->dir == NULL)
+		return -ENOMEM;
+
+	/* Create file "assert" and "clear" according to source capability */
+	if (info->mode&PPS_CAPTUREASSERT) {
+		procfs_file = create_proc_entry("assert", S_IRUGO|S_IWUSR, info->dir);
+		if (procfs_file == NULL)
+			goto exit;
+		procfs_file->read_proc = linuxpps_procfs_assert_read;
+		procfs_file->data = (void *) id;
+	}
+	if (info->mode&PPS_CAPTURECLEAR) {
+		procfs_file = create_proc_entry("clear", S_IRUGO|S_IWUSR, info->dir);
+		if (procfs_file == NULL)
+			goto exit;
+		procfs_file->read_proc = linuxpps_procfs_clear_read;
+		procfs_file->data = (void *) id;
+	}
+
+	return 0;
+
+exit :
+	linuxpps_procfs_remove_source_entry(info, id);
+
+	return -ENOMEM;
+}
+
+void linuxpps_procfs_unregister(void)
+{
+	remove_proc_entry("pps/sources", NULL);
+
+	/* The root dir in /proc/pps */
+	remove_proc_entry("pps", NULL);
+}
+
+int linuxpps_procfs_register(void)
+{
+	struct proc_dir_entry *procfs_file;
+
+	/* The root dir in /proc */
+	procfs_root_dir = proc_mkdir("pps", NULL);
+	if (procfs_root_dir == NULL)
+		return -ENOMEM;
+
+	/* The file "sources" */
+	procfs_file = create_proc_entry("sources", S_IRUGO|S_IWUSR, procfs_root_dir);
+	if (procfs_file == NULL) {
+		linuxpps_procfs_unregister();
+		return -ENOMEM;
+	}
+	procfs_file->owner = THIS_MODULE;
+	procfs_file->read_proc = linuxpps_sources_read;
+	procfs_file->write_proc = NULL;	/* no write method */
+
+	info("procfs enabled");
+	return 0;
+}
+
+#else	/* CONFIG_PPS_PROCFS */
+
+void linuxpps_procfs_unregister(void)
+{
+	/* Nothing to do here... */
+	return;
+}
+
+int linuxpps_procfs_register(void)
+{
+	info("procfs not enabled");
+	return 0;
+}
+#endif	/* CONFIG_PPS_PROCFS */
diff --git a/drivers/pps/sysfs.c b/drivers/pps/sysfs.c
new file mode 100644
index 0000000..6cd01f5
--- /dev/null
+++ b/drivers/pps/sysfs.c
@@ -0,0 +1,200 @@
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
+#include <linux/timepps.h>
+#include <linux/pps.h>
+
+/* ----- Private functions -------------------------------------------- */
+
+static ssize_t linuxpps_show_assert(struct class_device *cdev, char *buf)
+{
+	struct linuxpps_s *dev = class_get_devdata(cdev);
+
+	return sprintf(buf, "%ld.%09ld#%ld\n",
+			dev->assert_tu.tspec.tv_sec,
+			dev->assert_tu.tspec.tv_nsec,
+			dev->assert_sequence);
+}
+
+static ssize_t linuxpps_show_clear(struct class_device *cdev, char *buf)
+{
+	struct linuxpps_s *dev = class_get_devdata(cdev);
+
+	return sprintf(buf, "%ld.%09ld#%ld\n",
+			dev->clear_tu.tspec.tv_sec,
+			dev->clear_tu.tspec.tv_nsec,
+			dev->clear_sequence);
+}
+
+static ssize_t linuxpps_show_mode(struct class_device *cdev, char *buf)
+{
+	struct linuxpps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%4x\n", info->mode);
+}
+
+static ssize_t linuxpps_show_echo(struct class_device *cdev, char *buf)
+{
+	struct linuxpps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%d\n", !!info->echo);
+}
+
+static ssize_t linuxpps_show_name(struct class_device *cdev, char *buf)
+{
+	struct linuxpps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%s\n", info->name);
+}
+
+static ssize_t linuxpps_show_path(struct class_device *cdev, char *buf)
+{
+	struct linuxpps_source_info_s *info = to_pps_info(cdev);
+
+	return sprintf(buf, "%s\n", info->path);
+}
+
+/* ----- Files definitions -------------------------------------------- */
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
+static struct class_device_attribute linuxpps_class_device_attributes[] = {
+	DECLARE_INFO_ATTR(assert, 0644, linuxpps_show_assert, NULL),
+	DECLARE_INFO_ATTR(clear, 0644, linuxpps_show_clear, NULL),
+	DECLARE_INFO_ATTR(mode, 0644, linuxpps_show_mode, NULL),
+	DECLARE_INFO_ATTR(echo, 0644, linuxpps_show_echo, NULL),
+	DECLARE_INFO_ATTR(name, 0644, linuxpps_show_name, NULL),
+	DECLARE_INFO_ATTR(path, 0644, linuxpps_show_path, NULL),
+};
+
+/* ----- Class definitions -------------------------------------------- */
+
+static void linuxpps_class_release(struct class_device *cdev)
+{
+	/* Nop??? */
+}
+
+static struct class linuxpps_class = {
+	.name = "pps",
+	.release = linuxpps_class_release,
+};
+
+/* ----- Public functions --------------------------------------------- */
+
+void linuxpps_sysfs_remove_source_entry(struct linuxpps_source_info_s *info, int id) {
+	int i;
+
+	/* Sanity checks */
+	if (info == NULL || info->dir == NULL || id >= LINUXPPS_MAX_SOURCES)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(linuxpps_class_device_attributes); i++)
+		class_device_remove_file(&info->class_dev,
+					&linuxpps_class_device_attributes[i]);
+
+	class_device_unregister(&info->class_dev);
+}
+
+int linuxpps_sysfs_create_source_entry(struct linuxpps_source_info_s *info, int id) {
+	char buf[32];
+	int i, ret;
+
+	/* Sanity checks */
+	if (info == NULL || id >= LINUXPPS_MAX_SOURCES)
+		return -EINVAL;
+
+	/* Create dir class device name */
+	sprintf(buf, "%.02d", id);
+
+	/* Setup the class struct */
+	memset(&info->class_dev, 0, sizeof(struct class_device));
+	info->class_dev.class = &linuxpps_class;
+	strlcpy(info->class_dev.class_id, buf, KOBJ_NAME_LEN);
+	class_set_devdata(&info->class_dev, &linuxpps_source[id]);
+
+	/* Register the new class */
+	ret = class_device_register(&info->class_dev);
+	if (unlikely(ret))
+		goto error_class_device_register;
+
+	/* Create info files */
+
+	/* Create file "assert" and "clear" according to source capability */
+	if (info->mode&PPS_CAPTUREASSERT) {
+		ret = class_device_create_file(&info->class_dev,
+					&linuxpps_class_device_attributes[0]);
+		i = 0;
+		if (unlikely(ret))
+			goto error_class_device_create_file;
+	}
+	if (info->mode&PPS_CAPTURECLEAR) {
+		ret = class_device_create_file(&info->class_dev,
+					&linuxpps_class_device_attributes[1]);
+		i = 1;
+		if (unlikely(ret))
+			goto error_class_device_create_file;
+	}
+
+	for (i = 2; i < ARRAY_SIZE(linuxpps_class_device_attributes); i++) {
+		ret = class_device_create_file(&info->class_dev,
+					&linuxpps_class_device_attributes[i]);
+		if (unlikely(ret))
+			goto error_class_device_create_file;
+	}
+
+	return 0;
+
+error_class_device_create_file :
+	while (--i >= 0)
+		class_device_remove_file(&info->class_dev,
+					&linuxpps_class_device_attributes[i]);
+
+	class_device_unregister(&info->class_dev);
+	/* Here the  release() method was already called */
+
+error_class_device_register :
+
+	return ret;
+}
+
+void linuxpps_sysfs_unregister(void)
+{
+	class_unregister(&linuxpps_class);
+}
+
+int linuxpps_sysfs_register(void)
+{
+	return class_register(&linuxpps_class);
+}
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 98ec861..cd9a003 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1315,8 +1315,25 @@ static unsigned int check_modem_status(struct uart_8250_port *up)
 			up->port.icount.rng++;
 		if (status & UART_MSR_DDSR)
 			up->port.icount.dsr++;
-		if (status & UART_MSR_DDCD)
+		if (status & UART_MSR_DDCD) {
+#ifdef CONFIG_PPS_CLIENT_UART_8250
+			if (status & UART_MSR_DCD) {
+				linuxpps_event(up->port.pps_source,
+						PPS_CAPTUREASSERT, up);
+				dbg("serial8250: PPS assert event at %lu "
+				    "on source #%d",
+					jiffies, up->port.pps_source);
+			}
+			else {
+				linuxpps_event(up->port.pps_source,
+						PPS_CAPTURECLEAR, up);
+				dbg("serial8250: PPS clear event at %lu "
+				    "on source #%d",
+					jiffies, up->port.pps_source);
+			}
+#endif
 			uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
+		}
 		if (status & UART_MSR_DCTS)
 			uart_handle_cts_change(&up->port, status & UART_MSR_CTS);
 
@@ -2004,6 +2021,9 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 		up->ier |= UART_IER_MSI;
 	if (up->capabilities & UART_CAP_UUE)
 		up->ier |= UART_IER_UUE | UART_IER_RTOIE;
+#ifdef CONFIG_PPS_CLIENT_UART_8250
+	up->ier |= UART_IER_MSI;	/* enable interrupts */
+#endif
 
 	serial_out(up, UART_IER, up->ier);
 
@@ -2718,6 +2738,7 @@ void serial8250_unregister_port(int line)
 	struct uart_8250_port *uart = &serial8250_ports[line];
 
 	mutex_lock(&serial_mutex);
+
 	uart_remove_one_port(&serial8250_reg, &uart->port);
 	if (serial8250_isa_devs) {
 		uart->port.flags &= ~UPF_BOOT_AUTOCONF;
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 0422c0f..a11faa0 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -37,6 +37,11 @@
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_PPS_CLIENT_UART
+#include <linux/timepps.h>
+#include <linux/pps.h>
+#endif
+
 #undef	DEBUG
 #ifdef DEBUG
 #define DPRINTK(x...)	printk(x)
@@ -2083,6 +2088,7 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		    struct uart_port *port)
 {
 	unsigned int flags;
+	int retval;
 
 	/*
 	 * If there isn't a port here, don't do anything further.
@@ -2124,6 +2130,33 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		 */
 		if (!uart_console(port))
 			uart_change_pm(state, 3);
+
+#ifdef CONFIG_PPS_CLIENT_UART
+		/*
+		 * Add the PPS support for the probed port.
+		 */
+                snprintf(state->pps_info.name, LINUXPPS_MAX_NAME_LEN,
+				"%s%d", drv->driver_name, port->line);
+		snprintf(state->pps_info.path, LINUXPPS_MAX_NAME_LEN,
+				"/dev/%s%d", drv->dev_name, port->line);
+
+		state->pps_info.mode = PPS_CAPTUREBOTH | \
+				PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
+				PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+		retval = linuxpps_register_source(&state->pps_info,
+					PPS_CAPTUREBOTH | \
+					PPS_OFFSETASSERT | PPS_OFFSETCLEAR,
+					-1 /* PPS ID is up to the system */);
+		if (retval < 0) {
+			err("cannot register PPS source \"%s\"",
+				state->pps_info.path);
+			return;
+		}
+		port->pps_source = retval;
+		info("PPS source #%d \"%s\" added to the system ",
+			port->pps_source, state->pps_info.path);
+#endif
 	}
 }
 
@@ -2350,6 +2383,16 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *port)
 	port->flags |= UPF_DEAD;
 	mutex_unlock(&state->mutex);
 
+#ifdef CONFIG_PPS_CLIENT_UART
+	/*
+	 * Remove the PPS support.
+	 */
+	if (port->type != PORT_UNKNOWN) {
+		linuxpps_unregister_source(&state->pps_info);
+		dbg("PPS source #%d \"%s\" removed from the system",
+		port->pps_source, state->pps_info.path);
+	}
+#endif
 	/*
 	 * Remove the devices from the tty layer
 	 */
diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 2a20f48..32eee60 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -21,7 +21,7 @@
 #define NETLINK_DNRTMSG		14	/* DECnet routing messages */
 #define NETLINK_KOBJECT_UEVENT	15	/* Kernel messages to userspace */
 #define NETLINK_GENERIC		16
-/* leave room for NETLINK_DM (DM Events) */
+#define NETLINK_PPSAPI          17      /* linuxPPS support */
 #define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
 #define NETLINK_ECRYPTFS	19
 
diff --git a/include/linux/parport.h b/include/linux/parport.h
index 80682aa..d225362 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -104,6 +104,11 @@ typedef enum {
 #include <asm/ptrace.h>
 #include <asm/semaphore.h>
 
+#ifdef CONFIG_PPS_CLIENT_LP_PARPORT_PC
+#include <linux/timepps.h>
+#include <linux/pps.h>
+#endif
+
 /* Define this later. */
 struct parport;
 struct pardevice;
@@ -323,6 +328,11 @@ struct parport {
 
 	struct list_head full_list;
 	struct parport *slaves[3];
+
+#ifdef CONFIG_PPS_CLIENT_LP_PARPORT_PC
+	struct linuxpps_source_info_s pps_info;
+	int pps_source;		/* PPS source ID */
+#endif
 };
 
 #define DEFAULT_SPIN_TIME 500 /* us */
diff --git a/include/linux/pps.h b/include/linux/pps.h
new file mode 100644
index 0000000..52f67ce
--- /dev/null
+++ b/include/linux/pps.h
@@ -0,0 +1,119 @@
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
+/* ----- Misc macros -------------------------------------------------- */
+
+#define PPS_VERSION	"2.4.3"
+
+#ifdef CONFIG_PPS_DEBUG
+#define dbg(format, arg...) printk(KERN_DEBUG "%s: " format "\n" , \
+	KBUILD_MODNAME , ## arg)
+#else
+#define dbg(format, arg...) do {} while (0)
+#endif
+
+#define err(format, arg...) printk(KERN_ERR "%s: " format "\n" , \
+	KBUILD_MODNAME , ## arg)
+#define info(format, arg...) printk(KERN_INFO "%s: " format "\n" , \
+	KBUILD_MODNAME , ## arg)
+
+/* --- Global defines ------------------------------------------------------ */
+
+#define LINUXPPS_MAX_SOURCES		16
+
+/* --- Global variables ---------------------------------------------------- */
+
+/* The specific PPS source info */
+struct linuxpps_source_info_s {
+	char name[LINUXPPS_MAX_NAME_LEN];		/* simbolic name */
+	char path[LINUXPPS_MAX_NAME_LEN];		/* path of connected device */
+	int mode;					/* PPS's allowed mode */
+
+	void (*echo)(int source, int event, void *data);/* the PPS echo function */
+
+	/* sysfs section */
+	struct class_device class_dev;
+
+	/* procfs section */
+	struct proc_dir_entry *dir;
+};
+
+/* The main struct */
+struct linuxpps_s {
+	struct linuxpps_source_info_s *info;		/* PSS source info */
+
+	pps_params_t params;				/* PPS's current params */
+
+	volatile pps_seq_t assert_sequence;		/* PPS' assert event seq # */
+	volatile pps_seq_t clear_sequence;		/* PPS' clear event seq # */
+	volatile pps_timeu_t assert_tu;
+	volatile pps_timeu_t clear_tu;
+	int current_mode;				/* PPS mode at event time */
+
+	wait_queue_head_t queue;			/* PPS event queue */
+};
+
+/* --- Global variables ---------------------------------------------------- */
+
+extern struct linuxpps_s linuxpps_source[LINUXPPS_MAX_SOURCES];
+extern spinlock_t linuxpps_lock;
+
+/* --- Global functions ---------------------------------------------------- */
+
+static inline int __linuxpps_is_allocated(int source) {
+	return linuxpps_source[source].info != NULL;
+}
+
+static inline int linuxpps_is_allocated(int source) {
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&linuxpps_lock, flags);
+	ret = __linuxpps_is_allocated(source);
+	spin_unlock_irqrestore(&linuxpps_lock, flags);
+
+	return ret;
+}
+
+#define to_class_dev(obj) container_of((obj), struct class_device, kobj)
+#define to_pps_info(obj) container_of((obj), struct linuxpps_source_info_s, class_dev)
+
+/* --- Exported functions -------------------------------------------------- */
+
+extern int linuxpps_register_source(struct linuxpps_source_info_s *info, int default_params, int try_id);
+extern void linuxpps_unregister_source(struct linuxpps_source_info_s *info);
+extern void linuxpps_event(int source, int event, void *data);
+
+extern int linuxpps_procfs_create_source_entry(struct linuxpps_source_info_s *info, int id);
+extern void linuxpps_procfs_remove_source_entry(struct linuxpps_source_info_s *info, int id);
+extern int linuxpps_procfs_register(void);
+extern void linuxpps_procfs_unregister(void);
+
+extern int linuxpps_sysfs_create_source_entry(struct linuxpps_source_info_s *info, int id);
+extern void linuxpps_sysfs_remove_source_entry(struct linuxpps_source_info_s *info, int id);
+extern int linuxpps_sysfs_register(void);
+extern void linuxpps_sysfs_unregister(void);
+
+#endif /* _PPS_H_ */
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 586aaba..645f8e1 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -145,6 +145,11 @@
 #include <linux/tty.h>
 #include <linux/mutex.h>
 
+#ifdef CONFIG_PPS_CLIENT_UART
+#include <linux/timepps.h>
+#include <linux/pps.h>
+#endif
+
 struct uart_port;
 struct uart_info;
 struct serial_struct;
@@ -223,6 +228,9 @@ struct uart_port {
 	unsigned char		regshift;		/* reg offset shift */
 	unsigned char		iotype;			/* io access style */
 	unsigned char		unused1;
+#ifdef CONFIG_PPS_CLIENT_UART
+	int			pps_source;		/* PPS source ID */
+#endif
 
 #define UPIO_PORT		(0)
 #define UPIO_HUB6		(1)
@@ -295,6 +303,10 @@ struct uart_state {
 	struct uart_info	*info;
 	struct uart_port	*port;
 
+#ifdef CONFIG_PPS_CLIENT_UART
+        struct linuxpps_source_info_s pps_info;
+#endif
+
 	struct mutex		mutex;
 };
 
diff --git a/include/linux/timepps.h b/include/linux/timepps.h
new file mode 100644
index 0000000..5bf400a
--- /dev/null
+++ b/include/linux/timepps.h
@@ -0,0 +1,514 @@
+/*
+ * timepps.h -- PPS API main header
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
+ *
+ * NOTE: this file is *strongly* based on a previous job by Ulrich Windl.
+ *       The original copyright note follows:
+ *
+ *    Interface to the PPS API described in RFC 2783 (March 2000)
+ *
+ *    Copyright (c) 1999, 2001, 2004 by Ulrich Windl,
+ * 	   based on code by Reg Clemens <reg@dwf.com>
+ *	   based on code by Poul-Henning Kamp <phk@FreeBSD.org>
+ *
+ *    ----------------------------------------------------------------------
+ *    "THE BEER-WARE LICENSE" (Revision 42):
+ *    <phk@FreeBSD.org> wrote this file.  As long as you retain this notice
+ *    you can do whatever you want with this stuff. If we meet some day, and
+ *    you think this stuff is worth it, you can buy me a beer in return.
+ *       Poul-Henning Kamp
+ *    ----------------------------------------------------------------------
+ */
+
+#ifndef _SYS_TIMEPPS_H_
+#define _SYS_TIMEPPS_H_
+
+/* Implementation note: the logical states ``assert'' and ``clear''
+ * are implemented in terms of the chip register, i.e. ``assert''
+ * means the bit is set.  */
+
+/* --- 3.2 New data structures --------------------------------------------- */
+
+#define PPS_API_VERS_2		2	/* LinuxPPS proposal, dated 2006-05 */
+#define PPS_API_VERS		PPS_API_VERS_2
+#define LINUXPSS_API		1	/* mark LinuxPPS API */
+#define NETLINK_PPSAPI		17	/* we use just one free number... */
+
+typedef struct pps_handle_s {
+	int source;
+	int socket;
+} pps_handle_t;				/* represents a PPS source */
+
+typedef unsigned long pps_seq_t;	/* sequence number */
+
+typedef struct ntp_fp {
+	unsigned int	integral;
+	unsigned int	fractional;
+} ntp_fp_t;				/* NTP-compatible time stamp */
+
+typedef union pps_timeu {
+	struct timespec tspec;
+	ntp_fp_t ntpfp;
+	unsigned long longpad[3];
+} pps_timeu_t;				/* generic data type to represent time stamps */
+
+typedef struct pps_info {
+	pps_seq_t	assert_sequence;	/* seq. num. of assert event */
+	pps_seq_t	clear_sequence;		/* seq. num. of clear event */
+	pps_timeu_t	assert_tu;		/* time of assert event */
+	pps_timeu_t	clear_tu;		/* time of clear event */
+	int		current_mode;		/* current mode bits */
+} pps_info_t;
+
+#define assert_timestamp        assert_tu.tspec
+#define clear_timestamp         clear_tu.tspec
+
+#define assert_timestamp_ntpfp  assert_tu.ntpfp
+#define clear_timestamp_ntpfp   clear_tu.ntpfp
+
+typedef struct pps_params {
+	int		api_version;	/* API version # */
+	int		mode;		/* mode bits */
+	pps_timeu_t assert_off_tu;	/* offset compensation for assert */
+	pps_timeu_t clear_off_tu;	/* offset compensation for clear */
+} pps_params_t;
+
+#define assert_offset   assert_off_tu.tspec
+#define clear_offset    clear_off_tu.tspec
+
+#define assert_offset_ntpfp     assert_off_tu.ntpfp
+#define clear_offset_ntpfp      clear_off_tu.ntpfp
+
+/* --- 3.3 Mode bit definitions -------------------------------------------- */
+
+/* Device/implementation parameters */
+#define PPS_CAPTUREASSERT	0x01	/* capture assert events */
+#define PPS_CAPTURECLEAR	0x02	/* capture clear events */
+#define PPS_CAPTUREBOTH		0x03	/* capture assert and clear events */
+
+#define PPS_OFFSETASSERT	0x10	/* apply compensation for assert ev. */
+#define PPS_OFFSETCLEAR		0x20	/* apply compensation for clear ev. */
+
+#define PPS_CANWAIT		0x100	/* Can we wait for an event? */
+#define PPS_CANPOLL		0x200	/* "This bit is reserved for
+                                           future use." */
+
+/* Kernel actions */
+#define PPS_ECHOASSERT		0x40	/* feed back assert event to output */
+#define PPS_ECHOCLEAR		0x80	/* feed back clear event to output */
+
+/* Timestamp formats */
+#define PPS_TSFMT_TSPEC		0x1000	/* select timespec format */
+#define PPS_TSFMT_NTPFP		0x2000	/* select NTP format */
+
+/* --- 3.4.4 New functions: disciplining the kernel timebase --------------- */
+
+/* Kernel consumers */
+#define PPS_KC_HARDPPS		0	/* hardpps() (or equivalent) */
+#define PPS_KC_HARDPPS_PLL	1	/* hardpps() constrained to
+					   use a phase-locked loop */
+#define PPS_KC_HARDPPS_FLL	2	/* hardpps() constrained to
+					   use a frequency-locked loop */
+
+/* --- Here begins the implementation-specific part! ----------------------- */
+
+#define LINUXPPS_MAX_NAME_LEN           32
+struct pps_netlink_msg {
+	int cmd;			  /* the command to execute */
+	int source;
+	char name[LINUXPPS_MAX_NAME_LEN]; /* symbolic name */
+	char path[LINUXPPS_MAX_NAME_LEN]; /* path of the connected device */
+	int consumer;			  /* selected kernel consumer */
+	pps_params_t params;
+	int mode;			  /* edge */
+	int tsformat;			  /* format of time stamps */
+	pps_info_t info;
+	struct timespec timeout;
+	int ret;
+};
+#define PPSAPI_MAX_PAYLOAD	sizeof(struct pps_netlink_msg)
+
+/* check Documentation/ioctl-number.txt! */
+#define PPS_CREATE		1
+#define PPS_DESTROY		2
+#define PPS_SETPARMS		3
+#define PPS_GETPARMS		4
+#define PPS_GETCAP		5
+#define PPS_FETCH		6
+#define PPS_KC_BIND		7
+#define PPS_FIND_SRC		8
+#define PPS_FIND_PATH		9
+
+#ifdef __KERNEL__
+
+#include <linux/socket.h>
+#include <net/sock.h>
+#include <linux/netlink.h>
+
+struct pps_state {
+	pps_params_t	parm;		  /* PPS parameters */
+	pps_info_t info;		  /* PPS information */
+	int cap;			  /* PPS capabilities */
+	long ecount;			  /* interpolation offset of event */
+	struct timespec etime;		  /* kernel time of event */
+	wait_queue_head_t ewait;	  /* wait queue for event */
+};
+
+/* State variables to bind kernel consumer */
+/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
+extern const struct pps *pps_kc_hardpps_dev; /* some unique pointer to device */
+extern int pps_kc_hardpps_mode;		     /* mode bits for kernel consumer */
+
+/* Return allowed mode bits for given pps struct, file's mode, and user.
+ * Bits set in `*obligatory' must be set.  Returned bits may be set. */
+extern int pps_allowed_mode(const struct pps *pps, mode_t fmode, int *obligatory);
+
+#else /* !__KERNEL__ */
+
+/* --- 3.4 Functions ------------------------------------------------------- */
+
+#include <unistd.h>
+#include <errno.h>
+#include <asm/types.h>
+#include <sys/socket.h>
+#include <linux/netlink.h>
+
+/* Private functions */
+
+static int netlink_msg(int socket, struct pps_netlink_msg *nlpps)
+{
+	struct sockaddr_nl dest_addr;
+	struct nlmsghdr *nlh;
+	struct iovec iov;
+	struct msghdr msg;
+
+	int ret;
+
+	memset(&msg, 0, sizeof(msg));
+
+	/* Create the destination address */
+	memset(&dest_addr, 0, sizeof(dest_addr));
+	dest_addr.nl_family = AF_NETLINK;
+	dest_addr.nl_pid = 0;          /* for the kernel */
+	dest_addr.nl_groups = 0;       /* not in mcast groups */
+
+	nlh = (struct nlmsghdr *) alloca(NLMSG_SPACE(PPSAPI_MAX_PAYLOAD));
+	if (nlh == NULL)
+		return -1;
+
+	/* Fill the netlink message header */
+	nlh->nlmsg_len = NLMSG_SPACE(PPSAPI_MAX_PAYLOAD);
+	nlh->nlmsg_pid = getpid();
+	nlh->nlmsg_flags = 0;
+	memcpy(NLMSG_DATA(nlh), nlpps, sizeof(struct pps_netlink_msg));
+
+	iov.iov_base = (void *) nlh;
+	iov.iov_len = nlh->nlmsg_len;
+	msg.msg_name = (void *) &dest_addr;
+	msg.msg_namelen = sizeof(dest_addr);
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	/* Send the message */
+	ret = sendmsg(socket, &msg, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Wait for the answer */
+	memset(nlh, 0, NLMSG_SPACE(PPSAPI_MAX_PAYLOAD));
+	ret = recvmsg(socket, &msg, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Check the return value */
+	memcpy(nlpps, NLMSG_DATA(nlh), sizeof(struct pps_netlink_msg));
+	if (nlpps->ret < 0) {
+		errno = -nlpps->ret;
+		return -1;
+	}
+
+	return 0;
+}
+
+/* The PPSAPI functions */
+
+/* Create PPS handle from source number */
+static __inline int time_pps_create(int source, pps_handle_t *handle)
+{
+	struct sockaddr_nl src_addr, dest_addr;
+	struct pps_netlink_msg nlpps;
+
+	int ret;
+
+	/* Create the netlink socket */
+	ret = socket(PF_NETLINK, SOCK_RAW, NETLINK_PPSAPI);
+	if (ret < 0)
+		return ret;
+	handle->socket = ret;
+
+	/* Bind the socket with the source address */
+	memset(&src_addr, 0, sizeof(src_addr));
+	src_addr.nl_family = AF_NETLINK;
+	src_addr.nl_pid = 0;		/* ask kernel to choose an unique ID */
+	src_addr.nl_groups = 0;		/* not in mcast groups */
+	ret = bind(handle->socket, (struct sockaddr *) &src_addr, sizeof(src_addr));
+	if (ret < 0) {
+		close(handle->socket);
+		return ret;
+	}
+
+	/* Now ask the kernel to create the PPS source */
+	nlpps.cmd = PPS_CREATE;
+	nlpps.source = source;
+	ret = netlink_msg(handle->socket, &nlpps);
+	if (ret < 0)
+		return ret;
+
+	/* Save the PPS source returned by the kernel */
+	handle->source = nlpps.source;
+
+	return 0;
+}
+
+/* Release PPS handle */
+static __inline int time_pps_destroy(pps_handle_t handle)
+{
+	struct pps_netlink_msg nlpps;
+
+	int ret;
+
+	/* Ask the kernel to destroy the PPS source */
+	nlpps.cmd = PPS_DESTROY;
+	nlpps.source = handle.source;
+	ret = netlink_msg(handle.socket, &nlpps);
+	if (ret < 0)
+		return ret;
+
+	/* Now we can destroy the netlink socket */
+	close(handle.socket);
+
+	return 0;
+}
+
+/* Set parameters for handle */
+static __inline int time_pps_setparams(pps_handle_t handle, const pps_params_t *ppsparams)
+{
+	struct pps_netlink_msg nlpps;
+
+	int ret;
+
+	/* Ask the kernel to set the new PPS source's parameters */
+	nlpps.cmd = PPS_SETPARMS;
+	nlpps.source = handle.source;
+	nlpps.params = *ppsparams;
+	ret = netlink_msg(handle.socket, &nlpps);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static __inline int time_pps_getparams(pps_handle_t handle, pps_params_t *ppsparams)
+{
+	struct pps_netlink_msg nlpps;
+
+	int ret;
+
+	/* Ask the kernel to return the PPS source's parameters */
+	nlpps.cmd = PPS_GETPARMS;
+	nlpps.source = handle.source;
+	ret = netlink_msg(handle.socket, &nlpps);
+	if (ret < 0)
+		return ret;
+
+	/* Return the parameters */
+	*ppsparams = nlpps.params; 
+
+	return 0;
+}
+
+/* Get capabilities for handle */
+static __inline int time_pps_getcap(pps_handle_t handle, int *mode)
+{
+	struct pps_netlink_msg nlpps;
+
+	int ret;
+
+	/* Ask the kernel to return the PPS source's capabilities */
+	nlpps.cmd = PPS_GETCAP;
+	nlpps.source = handle.source;
+	ret = netlink_msg(handle.socket, &nlpps);
+	if (ret < 0)
+		return ret;
+
+	/* Return the capabilities */
+	*mode = nlpps.mode; 
+
+	return 0;
+}
+
+/* current event for handle */
+static __inline int time_pps_fetch(pps_handle_t handle, const int tsformat, pps_info_t *ppsinfobuf, const struct timespec *timeout)
+{
+	struct pps_netlink_msg nlpps;
+
+	int ret;
+
+	/* Ask the kernel to return the PPS source's capabilities */
+	nlpps.cmd = PPS_FETCH;
+	nlpps.source = handle.source;
+	nlpps.tsformat = tsformat;
+	if (timeout)
+		nlpps.timeout = *timeout;
+	else	 /* wait forever */
+		nlpps.timeout.tv_sec = nlpps.timeout.tv_nsec = -1;
+
+	ret = netlink_msg(handle.socket, &nlpps);
+	if (ret < 0)
+		return ret;
+
+	/* Return the timestamps */
+	*ppsinfobuf = nlpps.info; 
+
+	return 0;
+}
+
+/* Specify kernel consumer */
+static __inline int time_pps_kcbind(pps_handle_t handle, const int kernel_consumer, const int edge, const int tsformat)
+{
+	struct pps_netlink_msg nlpps;
+
+	int ret;
+
+	/* Ask the kernel to destroy the PPS source */
+	nlpps.cmd = PPS_KC_BIND;
+	nlpps.source = handle.source;
+	nlpps.consumer = kernel_consumer;
+	nlpps.mode = edge;
+	nlpps.tsformat = tsformat;
+	ret = netlink_msg(handle.socket, &nlpps);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* Find a PPS source */
+#define PPS_HAVE_FINDSOURCE	1
+static __inline int time_pps_findsource(int index, char *path, int pathlen, char *idstring, int idlen)
+{
+	int sock;
+	struct sockaddr_nl src_addr, dest_addr;
+	struct pps_netlink_msg nlpps;
+
+	int ret;
+
+	/* Create the netlink socket */
+	ret = socket(PF_NETLINK, SOCK_RAW, NETLINK_PPSAPI);
+	if (ret < 0)
+		return ret;
+	sock = ret;
+
+	/* Bind the socket with the source address */
+	memset(&src_addr, 0, sizeof(src_addr));
+	src_addr.nl_family = AF_NETLINK;
+	src_addr.nl_pid = 0;		/* ask kernel to choose an unique ID */
+	src_addr.nl_groups = 0;		/* not in mcast groups */
+	ret = bind(sock, (struct sockaddr *) &src_addr, sizeof(src_addr));
+	if (ret < 0) {
+		close(sock);
+		return ret;
+	}
+
+	/* Ask the kernel to destroy the PPS source */
+	nlpps.cmd = PPS_FIND_SRC;
+	nlpps.source = index;
+	ret = netlink_msg(sock, &nlpps);
+	if (ret < 0) {
+		close(sock);
+		return ret;
+	}
+
+	strncpy(path, nlpps.path, pathlen);
+	strncpy(idstring, nlpps.name, idlen);
+
+	close(sock);
+	return nlpps.source;
+}
+
+#define PPS_HAVE_FINDPATH	1
+static __inline void time_pps_readlink(char *link, int linklen, char *path, int pathlen)
+{
+	int i;
+
+	i = readlink(link, path, pathlen-1);
+	if (i <= 0) {
+		/* "link" is not a valid symbolic so we directly use it */
+		strncpy(path, link, linklen <= pathlen ? linklen : pathlen);
+		return;
+	}
+
+	/* Return the file name where "link" points to */
+	path[i] = '\0';
+	return;
+}
+
+static __inline int time_pps_findpath(char *path, int pathlen, char *idstring, int idlen)
+{
+	int sock;
+	struct sockaddr_nl src_addr, dest_addr;
+	struct pps_netlink_msg nlpps;
+
+	int ret;
+
+	/* Create the netlink socket */
+	ret = socket(PF_NETLINK, SOCK_RAW, NETLINK_PPSAPI);
+	if (ret < 0)
+		return ret;
+	sock = ret;
+
+	/* Bind the socket with the source address */
+	memset(&src_addr, 0, sizeof(src_addr));
+	src_addr.nl_family = AF_NETLINK;
+	src_addr.nl_pid = 0;		/* ask kernel to choose an unique ID */
+	src_addr.nl_groups = 0;		/* not in mcast groups */
+	ret = bind(sock, (struct sockaddr *) &src_addr, sizeof(src_addr));
+	if (ret < 0) {
+		close(sock);
+		return ret;
+	}
+
+	/* Ask the kernel to destroy the PPS source */
+	nlpps.cmd = PPS_FIND_PATH;
+	strncpy(nlpps.path, path, pathlen);
+	ret = netlink_msg(sock, &nlpps);
+	if (ret < 0) {
+		close(sock);
+		return ret;
+	}
+
+	strncpy(path, nlpps.path, pathlen);
+	strncpy(idstring, nlpps.name, idlen);
+
+	close(sock);
+	return nlpps.source;
+}
+
+#endif   /* !__KERNEL__ */
+#endif   /* _SYS_TIMEPPS_H_ */

--TKYYegg/GYAC5JIZ--
