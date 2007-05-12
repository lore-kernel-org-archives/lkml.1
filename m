Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbXELGAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbXELGAB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 02:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754288AbXELF7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 01:59:53 -0400
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:47291 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbXELF7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 01:59:51 -0400
Date: Sat, 12 May 2007 07:59:35 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070512055935.GD979@enneenne.com>
References: <20070321074121.GA13843@enneenne.com> <20070502193314.GA23367@enneenne.com> <20070510002740.c4350813.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="H+4ONPRPur6+Ovig"
Content-Disposition: inline
In-Reply-To: <20070510002740.c4350813.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--H+4ONPRPur6+Ovig
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

here my new patch with a lot of fixes.

The only issue not still fixed is the one related with:

        #define NETLINK_PPSAPI          20

I need time to resolve it.

Follows my comments and then the patch, hope now I can came back into
-mm tree again! :)

On Thu, May 10, 2007 at 12:27:52AM -0700, akpm@linux-foundation.org wrote:
>
> Review comments:
>
> - Running a timer once per second will make the super-low-power people upset.

The ktimer modules is just for debugging pourpose and it's not needed
into real working system.

> - This uses netlink?  Is that interface documented anywhere?
>
>   Please check with Dave Miller that this:
>
>       #define NETLINK_PPSAPI          20
>
>   reservation is OK.

Is not ok. To be fixed.

> - This:
>
>       if ((nlpps->tsformat != PPS_TSFMT_TSPEC) != 0 ) {
>
>   is weird.  I changed it to
>
>       if (nlpps->tsformat != PPS_TSFMT_TSPEC) {

Fixed.

> - This:
>
>       timeout += nlpps->timeout.tv_nsec/(1000000000/HZ);
>
>   probably won't work on i386.  We use do_div() for 64/32 divides.  I'll
>   find out when I compile it.
>
>   It's nice to use NSEC_PER_SEC rather than having to count all those
>   zeroes.

Fixed.

> - The code uses interruptible_sleep_on_timeout().  That API is deprecated
>   and is racy.  Please convert to wait_event_interruptible_timeout().
>
>   Ditto interruptible_sleep_on()

Fixed.

> - This:
>
>         memset(pps_source, 0, sizeof(struct pps_s) * PPS_MAX_SOURCES);
>
>   was unneeded.  The C startup code already did that.

Fixed.

> - All these separators:
>
> +/* --- Input function ------------------------------------------------------
+*/
>
>   aren't typical for kernel code.  I left them in, but please consider
>   removing them all.

Fixed.

> - This:
>
>       static void pps_class_release(struct class_device *cdev)
>       {
>               /* Nop??? */
>       }
>   
>   is a bug and it earns you a nastygram from Greg.  These objects must be
>   dynamically allocated - this is not optional.

It could be acceptable defining this function as void?

> - What's this doing in 8250.c?
>
> +     if (up->port.flags & UPF_HARDPPS_CD)
> +             up->ier |= UART_IER_MSI;        /* enable interrupts */
>       
>   Please fully describe the reasons for this change in the changelog, and in
>   a code comment and then get the change reviewed by Russell King
>   <rmk@arm.linux.org.uk>.

If user specify a serial port as PPS source we enable IRQ on that
port.

> - Please document within the changelog the other changes to the serial code
>   and we'll ask Russell to take a look at those as well.

OK. I'll do it.

> - The Kconfig purports to support CONFIG_PPS=m.  Does that actually work?

Yes. It works...

>   We have a bunch of code in random other drivers which is dependent upon
>   CONFIG_PPS_CLIENT_foo.  The problem is that if a kernel was compiled with
>   CONFIG_PPS_CLIENT_foo=n and then the pps driver is later built for that
>   kernel, it won't actually work because lp, serial etc weren't correctly
>   configured when _they_ were built.
>
>   This sort of cross-module coupling is considered to be a bad thing, but
>   I'm not really sure it's all that important.
>
> - Please split the patch up into a series of patches: one for pps core and
>   one for each of the clients (servers?): one for lp, one for serial, etc.
>
>   Try to arrange for that series of patches to build and run at each stage
>   of application.
>   
>   Please don't lose my changes when you do so ;)
>
>   Please review the changes I made and a) stick to the same style and b) fix
>   up any sites which I missed.
>
> - Please remove all the typedefs:
>
> +typedef struct ntp_fp {
> +typedef union pps_timeu {
> +typedef struct pps_info {
> +typedef struct pps_params {
>
>   and just use `struct ntp_fp' everywhere.

Those typedefs are defined in PPS specifications (please, see RFC 2783).

> - The above four structures are communicated with userspace, yes?
> 
>   I believe that they will not work correctly when 32-bit userspace is
>   communicating with a 64-bit kernel.  Alignments change and sizeof(long)
>   changes.
>   
>   You don't want to have to write compat code.  I suggest that you redo
>   those structures in terms of __u32, __u64, etc.  You probably need to use
>   attribute((packed)) too, not sure.
> 
>   Then let's get that part carefully reviewed (Arnd Bergmann <arnd@arndb.de>
>   is my go-to guru on this) and please test it carefully.
> 
>   Yeah, you just haven't got a chance that something as huge and as complex
>   as struct pps_netlink_msg will survive the 32->64 transition.

The same as above. These structure are fixed by RFC 2783.

> - Please ensure that `make headers_check' passes OK (you'll hear from me if
>   it doesn't ;))

Done.

> - Can we get rid of the private dbg, err and info macros?  Surely there are
>   generic ones somewhere.

They are very useful to LinuxPPS users who can enable/disable them by
configuration menu.

Also I'm planning to add a dinamic enable/disable mechanism...

> - struct pps_s has volatiles in it.  Please remove them.  There's lots of
>   discussion on this topic on linux-kernel just today.

Fixed.

> - Why did the
>   
>       port->icount.dcd++;
> 
>   get moved in uart_handle_dcd_change()?

That's why we have to register the PPS interrupt as soon as possible!
Even few CPU instructions dalay may result in a bad time settings.

> - In lots of places you do:
>
> +#ifdef CONFIG_PPS_CLIENT_UART
> +#include <linux/pps.h>
> +#endif
> 
>   Please remove the ifdefs at all these sites and make the header file
>   handle it.

Fixed.

> - It no longer compiles, because netlink_kernel_create now requires a
>   `struct mutex *'.  I stuck a NULL in there, which is permitted.  But I don't>   know if that was a good thing - please check this.
>
>   Please also chase the net guys with a pointy stick for failing to document
>   their damned APIs.

This should vanish when new netlink layer will be used.

> - Generally: code looks OK and is probably useful.  Please keep going ;)

Hope I forgot nothing!

Ciao,

Rodolfo

----

--H+4ONPRPur6+Ovig
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ntp-pps-2.6.21-bis.diff"

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
index 0000000..54297e8
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
index 0000000..a87cd37
--- /dev/null
+++ b/drivers/pps/clients/Kconfig
@@ -0,0 +1,38 @@
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
+	depends on ! (SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y))
+
+config PPS_CLIENT_UART
+	bool "UART serial support"
+	depends on SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y)
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the CD (Carrier Detect) pin of your serial port.
+
+comment "Parallel printer support (forced off)"
+	depends on !( PRINTER != n && !(PPS = m && PRINTER = y))
+
+config PPS_CLIENT_LP
+	bool "Parallel printer support"
+	depends on PRINTER != n && !(PPS = m && PRINTER = y)
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
index 0000000..033b308
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
+	/* Allocate the PPS source */
+	memset(&pps_source[i], 0, sizeof(struct pps_s));
+	pps_source[i].info = info;
+	pps_source[i].params.api_version = PPS_API_VERS;
+	pps_source[i].params.mode = default_params;
+	init_waitqueue_head(&pps_source[i].queue);
+
+	return i;
+}
+
+int pps_register_source(struct pps_source_info_s *info, int default_params,
+			int try_id)
+{
+	unsigned long flags;
+	int i, ret;
+
+	spin_lock_irqsave(&pps_lock, flags);
+	ret = __pps_register_source(info, default_params, try_id);
+	spin_unlock_irqrestore(&pps_lock, flags);
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
+	pps_source[i].info = NULL; 
+} 
+
+void pps_unregister_source(struct pps_source_info_s *info)
+{
+	unsigned long flags;
+
+	pps_sysfs_remove_source_entry(info);
+
+	spin_lock_irqsave(&pps_lock, flags);
+	__pps_unregister_source(info);
+	spin_unlock_irqrestore(&pps_lock, flags);
+}
+EXPORT_SYMBOL(pps_unregister_source);
+
+void pps_event(int source, int event, void *data)
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
+	if (!pps_is_allocated(source)) {
+		pps_err("unknow source for event!");
+		return;
+	}
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
index 0000000..30d6a26
--- /dev/null
+++ b/drivers/pps/pps.c
@@ -0,0 +1,371 @@
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
+#include <linux/skbuff.h>
+
+#include <linux/pps.h>
+
+/*
+ * Global variables
+ */
+
+struct pps_s pps_source[PPS_MAX_SOURCES];
+DEFINE_SPINLOCK(pps_lock);
+
+/*
+ * Local variables
+ */
+
+static struct sock *nl_sk = NULL;
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
+ * Input function
+ */
+
+static void pps_nl_data_ready(struct sock *sk, int len)
+{
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct pps_netlink_msg *nlpps;
+	int cmd, source, id;
+	unsigned long timeout;
+	int ret;
+
+	while ((skb = skb_dequeue(&sk->sk_receive_queue)) != NULL) {
+		nlh = (struct nlmsghdr *) skb->data;
+		pps_dbg("New message from PID %d (flags %x)",
+			nlh->nlmsg_pid, nlh->nlmsg_flags);
+
+		/* Decode the userland command */
+		nlpps = (struct pps_netlink_msg*) NLMSG_DATA(nlh);
+		cmd = nlpps->cmd;
+		source = nlpps->source;
+
+		switch (cmd) {
+		case PPS_CREATE:
+			pps_dbg("PPS_CREATE: source %d", source);
+
+			/* Check if the requested source is allocated */
+			ret = pps_find_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+
+			nlpps->source = ret;
+			nlpps->ret = 0;
+			break;
+
+		case PPS_DESTROY:
+			pps_dbg("PPS_DESTROY: source %d", source);
+
+			/* Nothing to do here! Just answer ok... */
+			nlpps->ret = 0;
+			break;
+
+		case PPS_SETPARMS:
+			pps_dbg("PPS_SETPARMS: source %d", source);
+
+			/* Check the capabilities */
+			if (!capable(CAP_SYS_TIME)) {
+				nlpps->ret = -EPERM;
+				break;
+		 	}
+
+			/* Sanity checks */
+			ret = pps_check_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+			if ((nlpps->params.mode & ~pps_source[source].info->mode) != 0) {
+				pps_dbg("unsupported capabilities");
+				nlpps->ret = -EINVAL;
+				break;
+		 	}
+			if ((nlpps->params.mode & (PPS_CAPTUREASSERT|PPS_CAPTURECLEAR)) == 0) {
+				pps_dbg("capture mode unspecified");
+				nlpps->ret = -EINVAL;
+				break;
+			}
+			if ((nlpps->params.mode & (PPS_TSFMT_TSPEC|PPS_TSFMT_NTPFP)) == 0) {
+				/* section 3.3 of RFC 2783 interpreted */
+				pps_dbg("time format unspecified");
+				nlpps->params.mode |= PPS_TSFMT_TSPEC;
+			}
+
+			/* Save the new parameters */
+			pps_source[source].params = nlpps->params;
+
+			/* Restore the read only parameters */
+			if (pps_source[source].info->mode&PPS_CANWAIT)
+				pps_source[source].params.mode |= PPS_CANWAIT;
+			pps_source[source].params.api_version = PPS_API_VERS;
+
+			nlpps->ret = 0;
+			break;
+
+		case PPS_GETPARMS:
+			pps_dbg("PPS_GETPARMS: source %d", source);
+
+			/* Sanity checks */
+			ret = pps_check_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+
+			nlpps->params = pps_source[source].params;
+			nlpps->ret = 0;
+			break;
+
+	 	case PPS_GETCAP:
+			pps_dbg("PPS_GETCAP: source %d", source);
+
+			/* Sanity checks */
+			ret = pps_check_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+
+			nlpps->mode = pps_source[source].info->mode;
+			nlpps->ret = 0;
+			break;
+
+	 	case PPS_FETCH:
+			pps_dbg("PPS_FETCH: source %d", source);
+
+			/* Sanity checks */
+			ret = pps_check_source(source);
+			if (ret < 0) {
+				nlpps->ret = ret;
+				break;
+			}
+			if (nlpps->tsformat != PPS_TSFMT_TSPEC) {
+				pps_dbg("unsupported time format");
+				nlpps->ret = -EINVAL;
+				break;
+		 	}
+
+			pps_source[source].go = 0;
+
+		 	/* Manage the timeout */
+			if (nlpps->timeout.tv_sec != -1) {
+				timeout = nlpps->timeout.tv_sec * HZ;
+				timeout += nlpps->timeout.tv_nsec/
+						(NSEC_PER_SEC/HZ);
+
+				if (timeout != 0) {
+					ret = wait_event_interruptible_timeout(
+						pps_source[source].queue,
+						pps_source[source].go, timeout);
+		  			if (ret == 0) {
+						pps_dbg("timeout expired");
+						nlpps->ret = -ETIMEDOUT;
+						break;
+					}
+				}
+		 	} else
+				ret = wait_event_interruptible(
+						pps_source[source].queue,
+						pps_source[source].go);
+
+			/* Check for pending signals */
+			if (ret == -ERESTARTSYS) {
+				pps_dbg("pending signal caught");
+				nlpps->ret = -EINTR;
+				break;
+			}
+
+			/* Return the fetched timestamp */
+			nlpps->info.assert_sequence = pps_source[source].assert_sequence;
+			nlpps->info.clear_sequence = pps_source[source].clear_sequence;
+			nlpps->info.assert_tu = pps_source[source].assert_tu;
+			nlpps->info.clear_tu = pps_source[source].clear_tu;
+			nlpps->info.current_mode = pps_source[source].current_mode;
+
+			nlpps->ret = 0;
+			break;
+
+	 	case PPS_KC_BIND:
+			pps_dbg("PPS_KC_BIND: source %d", source);
+			/* Feature currently not supported */
+			nlpps->ret = -EOPNOTSUPP;
+			break;
+
+		case PPS_FIND_SRC:
+			pps_dbg("PPS_FIND_SRC: source %d", source);
+			source = pps_find_source(source);
+			if (source < 0) {
+				pps_dbg("no PPS devices found");
+				nlpps->ret = -ENODEV;
+				break;
+		 	}
+
+			/* Found! So copy the info */
+			nlpps->source = source;
+			strncpy(nlpps->name, pps_source[source].info->name,
+				PPS_MAX_NAME_LEN);
+			strncpy(nlpps->path, pps_source[source].info->path,
+				PPS_MAX_NAME_LEN);
+			nlpps->ret = 0;
+			break;
+
+		case PPS_FIND_PATH:
+			pps_dbg("PPS_FIND_PATH: source %s", nlpps->path);
+			source = pps_find_path(nlpps->path);
+			if (source < 0) {
+				pps_dbg("no PPS devices found");
+				nlpps->ret = -ENODEV;
+				break;
+		 	}
+
+			/* Found! So copy the info */
+			nlpps->source = source;
+			strncpy(nlpps->name, pps_source[source].info->name,
+				PPS_MAX_NAME_LEN);
+			strncpy(nlpps->path, pps_source[source].info->path,
+				PPS_MAX_NAME_LEN);
+			nlpps->ret = 0;
+			break;
+
+		default:
+			/* Unknow command */
+			pps_dbg("unknow command %d", nlpps->cmd);
+
+			nlpps->ret = -EINVAL;
+		}
+
+		/* Send an answer to the userland */
+		id = NETLINK_CB(skb).pid;
+		pps_dbg("start sending reply to ID %d...", id);
+		NETLINK_CB(skb).pid = 0;	/* from the kernel */
+		NETLINK_CB(skb).dst_group = 0;	/* not in mcast groups */
+
+		ret = netlink_unicast(nl_sk, skb, id, MSG_DONTWAIT);
+		pps_dbg("... reply sent (%d)", ret);
+	}
+}
+
+/*
+ * Module staff
+ */
+
+static void __exit pps_exit(void)
+{
+	pps_sysfs_unregister();
+	sock_release(nl_sk->sk_socket);
+
+	pps_info("LinuxPPS API ver. %d removed", PPS_API_VERS);
+}
+
+static int __init pps_init(void)
+{
+	int ret;
+
+	nl_sk = netlink_kernel_create(NETLINK_PPSAPI, 0,
+					pps_nl_data_ready, NULL, THIS_MODULE);
+	if (nl_sk == NULL) {
+		pps_err("unable to create netlink kernel socket");
+		return -EBUSY;
+	}
+	pps_dbg("netlink protocol %d created", NETLINK_PPSAPI);
+
+	/* Register to sysfs */
+	ret = pps_sysfs_register();
+	if (ret < 0) {
+		pps_err("unable to register sysfs");
+		goto pps_sysfs_register_error;
+	}
+
+	pps_info("LinuxPPS API ver. %d registered", PPS_API_VERS);
+	pps_info("Software ver. %s - Copyright 2005-2007 Rodolfo Giometti "
+		"<giometti@linux.it>", PPS_VERSION);
+
+	return 0;
+
+pps_sysfs_register_error:
+
+	sock_release(nl_sk->sk_socket);
+
+	return ret;
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
diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 2e23353..9d55343 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -24,6 +24,7 @@
 /* leave room for NETLINK_DM (DM Events) */
 #define NETLINK_SCSITRANSPORT	18	/* SCSI Transports */
 #define NETLINK_ECRYPTFS	19
+#define NETLINK_PPSAPI          20	/* linuxPPS support */
 
 #define MAX_LINKS 32		
 
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
index 0000000..e40ac70
--- /dev/null
+++ b/include/linux/pps.h
@@ -0,0 +1,229 @@
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
+#include <sys/socket.h>
+#include <sys/time.h>
+#endif
+#include <linux/netlink.h>
+
+#define PPS_API_VERS_2          2       /* LinuxPPS proposal, dated 2006-05 */
+#define PPS_API_VERS            PPS_API_VERS_2
+#define LINUXPSS_API            1       /* mark LinuxPPS API */
+
+#define PPS_MAX_NAME_LEN	32
+
+typedef unsigned long pps_seq_t;        /* sequence number */
+
+typedef struct ntp_fp {
+	unsigned int integral;
+	unsigned int fractional;
+} ntp_fp_t;				/* NTP-compatible time stamp */
+
+typedef union pps_timeu {
+	struct timespec tspec;
+	ntp_fp_t ntpfp;
+	unsigned long longpad[3];
+} pps_timeu_t;			/* generic data type to represent time stamps */
+
+typedef struct pps_info {
+	pps_seq_t assert_sequence;	/* seq. num. of assert event */
+	pps_seq_t clear_sequence; 	/* seq. num. of clear event */
+	pps_timeu_t assert_tu;		/* time of assert event */
+	pps_timeu_t clear_tu;		/* time of clear event */
+	int current_mode;		/* current mode bits */
+} pps_info_t;
+
+typedef struct pps_params {
+	int api_version;		/* API version # */
+	int mode;			/* mode bits */
+	pps_timeu_t assert_off_tu;	/* offset compensation for assert */
+	pps_timeu_t clear_off_tu;	/* offset compensation for clear */
+} pps_params_t;
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
+struct pps_netlink_msg {
+	int cmd;			/* the command to execute */
+	int source;
+	char name[PPS_MAX_NAME_LEN];	/* symbolic name */
+	char path[PPS_MAX_NAME_LEN];	/* path of the connected device */
+	int consumer;			/* selected kernel consumer */
+	pps_params_t params;
+	int mode;			/* edge */
+	int tsformat;			/* format of time stamps */
+	pps_info_t info;
+	struct timespec timeout;
+	int ret;
+};
+#define PPSAPI_MAX_PAYLOAD	sizeof(struct pps_netlink_msg)
+
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
+
+/*
+ * Misc macros
+ */
+
+#define PPS_VERSION	"3.2.0"
+
+#ifdef CONFIG_PPS_DEBUG
+#define pps_dbg(format, arg...) printk(KERN_DEBUG "%s: " format "\n" , \
+	KBUILD_MODNAME , ## arg)
+#else
+#define dbg(format, arg...) do {} while (0)
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
+	pps_params_t params;			/* PPS's current params */
+
+	volatile pps_seq_t assert_sequence;	/* PPS' assert event seq # */
+	volatile pps_seq_t clear_sequence;	/* PPS' clear event seq # */
+	volatile pps_timeu_t assert_tu;
+	volatile pps_timeu_t clear_tu;
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
+extern spinlock_t pps_lock;
+
+/*
+ * Global functions
+ */
+
+static inline int pps_is_allocated(int source)
+{
+	return pps_source[source].info != NULL;
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

--H+4ONPRPur6+Ovig--
