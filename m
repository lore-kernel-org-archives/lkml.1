Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbYA0SB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbYA0SB0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 13:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYA0SBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 13:01:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:42931 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbYA0SBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:01:17 -0500
Message-ID: <479CC6E7.4000103@windriver.com>
Date: Sun, 27 Jan 2008 12:01:11 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] KGDB: refactor kconfig menu
References: <479CA7CE.8040407@web.de>
In-Reply-To: <479CA7CE.8040407@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2008 18:00:58.0117 (UTC) FILETIME=[91A78350:01C8610E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> This is an attempt to improve the so far, well, unfortunate Kconfig menu
> organization of KGDB. Most notably, it pushes all sub-entries into their
> own menuconfig, removes the (IMHO) unneeded "Method for KGDB
> communication" choice, and ensures everything is indented properly. This
> should keep the original semantic while reducing the number of knobs the
> user is confronted with.
>
>   

While it is probably reasonable to put the kgdb options into a sub
entry,  you cannot get rid of the "Method for KGDB communication"
choice, unless you re-implement it another way.

It is designed to implement the following:
1) You can chose to build 1 and only 1 KGDB I/O module into the kernel
2) Or you select modules only and can you can build as many additional
    KGDB I/O modules as you like.
3) Additional I/O modules can be built and you can load one at run time
    if you want to use another I/O method vs #1

KGDB's Kconfig options are designed to allow you to have alternate ways
to select static or run time configuration of the I/O connection to the
KGDB core, IE: over serial, over ethernet, over USB or what ever module
you would like to implement.

Jason.



> Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
>
> ---
>  lib/Kconfig.kgdb |   91 +++++++++++++++----------------------------------------
>  1 file changed, 25 insertions(+), 66 deletions(-)
>
> Index: b/lib/Kconfig.kgdb
> ===================================================================
> --- a/lib/Kconfig.kgdb
> +++ b/lib/Kconfig.kgdb
> @@ -1,19 +1,9 @@
>  
> -config WANT_EXTRA_DEBUG_INFORMATION
> -	bool
> -	select DEBUG_INFO
> -	select UNWIND_INFO
> -	select FRAME_POINTER if X86
> -	default n
> -
> -config UNWIND_INFO
> -	bool
> -	default n
> -
> -config KGDB
> +menuconfig KGDB
>  	bool "KGDB: kernel debugging with remote gdb"
> -	select WANT_EXTRA_DEBUG_INFORMATION
>  	select KGDB_ARCH_HAS_SHADOW_INFO if X86_64
> +	select DEBUG_INFO
> +	select FRAME_POINTER
>  	depends on DEBUG_KERNEL && (X86)
>  	help
>  	  If you say Y here, it will be possible to remotely debug the
> @@ -23,62 +13,20 @@ config KGDB
>  
>  config KGDB_ARCH_HAS_SHADOW_INFO
>  	bool
> -
> -config KGDB_CONSOLE
> -	bool "KGDB: Console messages through gdb"
> -	depends on KGDB
> -	help
> -	  If you say Y here, console messages will appear through gdb.
> -	  Other consoles such as tty or ttyS will continue to work as usual.
> -	  Note that if you use this in conjunction with KGDBOE, if the
> -	  ethernet driver runs into an error condition during use with KGDB,
> -	  it is possible to hit an infinite recursion, causing the kernel
> -	  to crash, and typically reboot.  For this reason, it is preferable
> -	  to use NETCONSOLE in conjunction with KGDBOE instead of
> -	  KGDB_CONSOLE.
> -
> -choice
> -	prompt "Method for KGDB communication"
>  	depends on KGDB
> -	default KGDB_8250_NOMODULE
> -	help
> -	  There are a number of different ways in which you can communicate
> -	  with KGDB.  The most common is via serial, with the 8250 driver
> -	  (should your hardware have an 8250, or ns1655x style uart).
> -	  Another option is to use the NETPOLL framework and UDP, should
> -	  your ethernet card support this.  Other options may exist.
> -	  You can elect to have one core I/O driver that is built into the
> -	  kernel for debugging as the kernel is booting, or using only
> -	  kernel modules.
> -
> -config KGDB_ONLY_MODULES
> -	bool "KGDB: Use only kernel modules for I/O"
> -	depends on MODULES
> -	help
> -	  Use only kernel modules to configure KGDB I/O after the
> -	  kernel is booted.
> -
> -config KGDB_8250_NOMODULE
> -	bool "KGDB: On generic serial port (8250)"
> -	select KGDB_8250
> -	select SERIAL_8250
> -	help
> -	  Uses generic serial port (8250) to communicate with the host
> -	  GDB.  This is independent of the normal (SERIAL_8250) driver
> -	  for this chipset.
> -endchoice
>  
>  config KGDB_8250
> -	tristate "KGDB: On generic serial port (8250)" if !KGDB_8250_NOMODULE
> -	depends on m && KGDB_ONLY_MODULES
> +	tristate "KGDB: On generic serial port (8250)"
> +	depends on KGDB
> +	default y
>  	help
>  	  Uses generic serial port (8250) to communicate with the host
>  	  GDB.  This is independent of the normal (SERIAL_8250) driver
>  	  for this chipset.
>  
>  config KGDB_SIMPLE_SERIAL
> -	bool "Simple selection of KGDB serial port"
> -	depends on KGDB_8250_NOMODULE
> +	bool "Simple configuration of KGDB serial port"
> +	depends on (KGDB_8250 = y)
>  	default y
>  	help
>  	  If you say Y here, you will only have to pick the baud rate
> @@ -90,7 +38,7 @@ config KGDB_SIMPLE_SERIAL
>  
>  config KGDB_BAUDRATE
>  	int "Debug serial port baud rate"
> -	depends on (KGDB_8250 && KGDB_SIMPLE_SERIAL)
> +	depends on KGDB_SIMPLE_SERIAL
>  	default "115200"
>  	help
>  	  gdb and the kernel stub need to agree on the baud rate to be
> @@ -99,16 +47,15 @@ config KGDB_BAUDRATE
>  
>  config KGDB_PORT_NUM
>  	int "Serial port number for KGDB"
> -	range 0 1 if KGDB_MPSC
>  	range 0 3
> -	depends on (KGDB_8250 && KGDB_SIMPLE_SERIAL) || KGDB_MPSC
> +	depends on KGDB_SIMPLE_SERIAL
>  	default "1"
>  	help
>  	  Pick the port number (0 based) for KGDB to use.
>  
>  config KGDB_8250_CONF_STRING
>  	string "Configuration string for KGDB"
> -	depends on KGDB_8250_NOMODULE && !KGDB_SIMPLE_SERIAL
> +	depends on KGDB_8250 && !KGDB_SIMPLE_SERIAL
>  	default "io,2f8,115200,3" if X86
>  	help
>  	  The format of this string should be <io or mmio>,
> @@ -119,11 +66,23 @@ config KGDB_8250_CONF_STRING
>  config KGDB_ATTACH_WAIT
>  	bool "KGDB: Wait for debugger to attach on an unknown exception"
>  	depends on KGDB
> -	default y if KGDB_8250_NOMODULE
> -	default n if !KGDB_8250_NOMODULE
> +	default (KGDB_8250 = y)
>  	help
>  	  If a panic occurs, or any kind of exception, the kgdb will
>  	  stop and wait for a debugger to attach.  This sets the
>  	  default behavior for waiting for the debugger to attach.  This
>  	  value can also be changed at runtime through
>  	  /sys/module/kgdb/parameters/attachwait
> +
> +config KGDB_CONSOLE
> +	bool "KGDB: Console messages through gdb"
> +	depends on KGDB
> +	help
> +	  If you say Y here, console messages will appear through gdb.
> +	  Other consoles such as tty or ttyS will continue to work as usual.
> +	  Note that if you use this in conjunction with KGDBOE, if the
> +	  ethernet driver runs into an error condition during use with KGDB,
> +	  it is possible to hit an infinite recursion, causing the kernel
> +	  to crash, and typically reboot.  For this reason, it is preferable
> +	  to use NETCONSOLE in conjunction with KGDBOE instead of
> +	  KGDB_CONSOLE.
>   

