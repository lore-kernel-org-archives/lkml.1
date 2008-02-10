Return-Path: <linux-kernel-owner+w=401wt.eu-S1751387AbYBJNZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbYBJNZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750722AbYBJNZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:25:23 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:49156 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYBJNZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:25:22 -0500
Message-ID: <47AEFB40.5070208@web.de>
Date: Sun, 10 Feb 2008 14:25:20 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [0/6] kgdb light
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org>
In-Reply-To: <20080210104709.GB10790@uranus.ravnborg.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+cki4B4/2z1BhHifHG6rIUmYNwtiU3nF3zlCKh
	K7+XfjGfZF6B6/fiqQWcX7pJ4RWV6vC3iFmBsrk2rKLTD6GP+T
	uDGdoeJoE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> ...
> +extern int kgdb_may_fault;
> I searched but I could not find any places this
> variable were set to anuthing else than 0 neither where it was tested.

This is a leftover from the old jmp-on-fault logic that was missed by
this tree. I have a patch under test that kills this (and further 150
LOC) from the core.

> 
> diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
> new file mode 100644
> index 0000000..00263c0
> --- /dev/null
> +++ b/lib/Kconfig.kgdb
> @@ -0,0 +1,37 @@
> +
> +menuconfig KGDB
> +	bool "KGDB: kernel debugging with remote gdb"
> +	select FRAME_POINTER
> +	depends on HAVE_ARCH_KGDB
> +	depends on DEBUG_KERNEL && EXPERIMENTAL
> +	help
> +	  If you say Y here, it will be possible to remotely debug the
> +	  kernel using gdb.  Documentation of kernel debugger is available
> +	  at http://kgdb.sourceforge.net as well as in DocBook form
> +	  in Documentation/DocBook/.  If unsure, say N.
> +
> +config HAVE_ARCH_KGDB_SHADOW_INFO
> +	bool
> +
> 
> Please add:
> config HAVE_ARCH_KGDB
> 	bool
> 
> So we later in x86/Kconfig can do:
> config X86
> 	select HAVE_ARCH_KGDB
> 
> And we can get rid of (from x86/Kconfig):
> +config HAVE_ARCH_KGDB
> +	def_bool y
> 
> 
> Back to Kconfig.kgdb:
> 
> +config KGDBOC
> +	tristate "KGDB: use kgdb over the serial console"
> +	depends on KGDB
> 
> Can we have a more descriptive name here.
> For example:
> config KGDB_SERIAL_CONSOLE
> It is only used in one place so there is no
> specific need for such a magic short name.
> 

Is the patch below OK? I also added an "if KGB" to unbreak kgdb's
kconfig menu again and included two minor cleanups I posted yesterday.

Jan

PS: Ingo, kgdboc runtime re-configuration is broken as you dropped the
__init removal from uart_parse_options and uart_set_option (probably
due to the ifdef'ery). Better remove it unconditionally?

--------------

Refactor KGDB kbuild menu.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 arch/x86/Kconfig        |    4 +---
 drivers/serial/Makefile |    2 +-
 lib/Kconfig.kgdb        |   15 ++++++++++-----
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 85bcc23..5e0fab5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -22,6 +22,7 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_ARCH_KGDB
 
 config GENERIC_LOCKBREAK
 	def_bool n
@@ -144,9 +145,6 @@ config AUDIT_ARCH
 config ARCH_SUPPORTS_AOUT
 	def_bool y
 
-config HAVE_ARCH_KGDB
-	def_bool y
-
 # Use the generic interrupt handling code in kernel/irq/:
 config GENERIC_HARDIRQS
 	bool
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index 1d8ee05..dfd8e72 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -66,5 +66,5 @@ obj-$(CONFIG_SERIAL_UARTLITE) += uartlite.o
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
 obj-$(CONFIG_SERIAL_KS8695) += serial_ks8695.o
-obj-$(CONFIG_KGDBOC) += kgdboc.o
+obj-$(CONFIG_KGDB_IO_SERIAL_CONSOLE) += kgdboc.o
 obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 00263c0..947c7f1 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -10,12 +10,16 @@ menuconfig KGDB
 	  at http://kgdb.sourceforge.net as well as in DocBook form
 	  in Documentation/DocBook/.  If unsure, say N.
 
+if KGDB
+
+config HAVE_ARCH_KGDB
+	bool
+
 config HAVE_ARCH_KGDB_SHADOW_INFO
 	bool
 
 config KGDB_CONSOLE_OUTPUT
-	bool "KGDB: Console messages through gdb"
-	depends on KGDB
+	bool "Console messages through gdb"
 	help
 	  If you say Y here, console messages will appear through gdb.
 	  Other consoles such as tty or ttyS will continue to work as usual.
@@ -26,12 +30,13 @@ config KGDB_CONSOLE_OUTPUT
 	  to use NETCONSOLE in conjunction with KGDBOE instead of
 	  KGDB_CONSOLE.
 
-config KGDBOC
-	tristate "KGDB: use kgdb over the serial console"
-	depends on KGDB
+config KGDB_IO_SERIAL_CONSOLE
+	tristate "Use kgdb over the serial console"
 	select CONSOLE_POLL
 	select MAGIC_SYSRQ
 	default y
 	help
 	  Share a serial console with kgdb. Sysrq-g must be used
 	  to break in initially.
+
+endif
