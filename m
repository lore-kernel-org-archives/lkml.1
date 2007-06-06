Return-Path: <linux-kernel-owner+w=401wt.eu-S1762309AbXFFO07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762309AbXFFO07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 10:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151AbXFFO0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 10:26:51 -0400
Received: from mail.suse.de ([195.135.220.2]:53225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbXFFO0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 10:26:50 -0400
Subject: Documentation - How to debug ACPI Problems
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-acpi <linux-acpi@vger.kernel.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 06 Jun 2007 16:26:48 +0200
Message-Id: <1181140008.28514.259.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I made up a little How-To for what I find out is nice to debug ACPI
problems.

Any enhancements, corrections, etc. are very much appreciated.

I'd like to have a final version in the Documentation section.

IMO the size and complexity of ACPI justifies to start an own
Documentation/acpi directory.
Not sure whether thinkpad-acpi.txt (are there other related How-Tos?)
should be added there as it got split out of drivers/acpi recently.

Not sure whether it's necessary to send a patch at all for a new
Documentation file, for now the plain file is easier to read and comment
on.

Thanks,

     Thomas


How to debug ACPI Problems
==========================

Thomas Renninger <trenn@suse.de>, 2007
Copyright (C) 2007 SUSE Linux GmbH


1. Introduction
---------------

1.1. General Info
- - - - - - - -

Please refer to the latest ACPI spec for general ACPI information:
http://www.acpi.info/spec.htm

ACPI is required by most recent x86, x86_64 and IA64 architecture based
machines.

In general ACPI tables provide information from the BIOS to the OS.
There are ACPI tables (DSDT and SSDTs), written in the ACPI Source
Language (ASL) which include byte code (similar to Java byte code) that gets
interpreted by the OS. The kernel makes use of provided BIOS functions
declared and described there by interpreting them to setup and access
different hardware.

There exist two compilers/interpreters for ASL code, one from Microsoft and
one from Intel. The Intel code has an Open Source license. The software package
is called ACPICA. It includes the code for disassembling DSDT tables,
(re-)compiling them, parsing several ACPI tables and interpreting ACPI Machine
Language (AML, the compiled ASL..). The code is used to provide several
userspace tools, but large parts are also contributed to the linux kernel and
other OSs.
drivers/acpi/*.c currently is Linux code implementing most parts of the ACPI
spec, everything in the directories below, gets synced with the ACPICA Intel
package.


1.2. Useful Userspace Tools for Table Playing
- - - - - - - - - - - - - - - - - - - - - - -

The ACPI tables of your system can be extracted with the acpidump tool:
in the latest pmutils package from here:
ftp://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/utils

acpixtract, iasl, acpiexec can be found in the ACPICA sources:
http://developer.intel.com/technology/iapc/acpi/downloads.htm

You can now:
acpidump >acpidump       # cp your ACPI tables from memory to disk
acpixtract -a acpidump   # extract them into raw, single tables
iasl -d TABLE.dat        # disassemble/parse a specific table
iasl -sa DSDT.dsl        # e.g. recompile a modified, disassembled DSDT for
                           initramfs inclusion (see later)
acpiexec DSDT.dat        # parse, interpret and load a DSDT in userspace

The latter can sometimes be very useful to debug buggy DSDTs in userspace.
It provides a debug shell which e.g. offers execution of specific ACPI
functions, increase of debug output and more.


2. Overriding DSDT
------------------

The DSDT (there is a patch also for SSDTs) can be overridden by the user.
The tables get copied to RAM when booting and the kernel can override them with
alternative tables at early boot time.

In history people used to override their DSDT to workaround BIOS or even kernel
bugs. This is a bad idea, the override functionality is for short
term workarounds and mainly for debugging! Please always report such bugs to
bugzilla.kernel.org or post to linux-acpi@vger.kernel.org if unsure.

There are two possibilities to override the DSDT:

  - via CONFIG_ACPI_CUSTOM_DSDT (and _FILE) compile option(s)
  - via adding a customized DSDT into initramfs

The second approach does not need kernel recompilation and some distributions
provide the patch, which is not included in mainline, in their kernels.

The patch and more information can be found here (many thanks to Markus
Gaugusch and Eric Piel):
http://gaugusch.at/kernel.shtml


3. Problem Analysis and Solving
-------------------------------

3.1. I see Warnings or Errors when disassembling or compiling my DSDT
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Some might be sever ACPICA or BIOS bugs, some might just be incompatibilities
with the Microsoft compiler. We want to fix both, therefore a bug should be
filed at bugzilla.kernel.org
In general you should watch your system, if you don't miss any functionality
there is no reason to panic (e.g. modify the DSDT and override your original
one, you really should not do that if you do not see any big advantage and even
then, better try to get a real fix or at least a kernel workaround like a
boot or module parameter).

You should be able to debug this with userspace tools (See:
"1.2. Useful Userspace Tools for Table Playing")


3.2) Hardware accessed by ACPI is not working correctly - Using ACPI_DEBUG
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

If you expect the bug in a module in drivers/acpi/*.c code you might have luck
and be able to find or narrow down the culprit by simple printks.

On more complicated bugs you should make use of the ACPI_DEBUG=y facility.
This allows you to fine grain enable specific output in the ACPI interpreter.


   3.2.1 Using ACPI_DEBUG Boot Parameters acpi.debug_level and acpi.debug_layer

         Note: In kernel versions before 2.6.22 the boot parameters are:
	       acpi_dbg_level and acpi_dbg_layer

         ACPI can produce tons of debug output if these debug masks are
         switched to full on.
	 include/acpi/acoutput.h shows which flags can be enabled for level and
         layer (cat /proc/acpi/debug_{level,layer} also shows you the flags,
	 but that interface will move to sysfs, not sure whether there still
	 will be such a help).

         Therefore, switch on debug flags carefully. You also might want to
	 increase the kernel ring buffer by passing:
	 log_buf_len=XY in bytes and later use dmesg -s XY to get more than
	 16k kernel log output.
	 Instead of serial console logging you might want to use the netconsole
	 interface (Documentation/networking/netconsole.txt) to write away
         syslog messages over network or firescope (patches already exist in
         2.6.22-rcX-mm?) to send syslog messages over firewire.
	 The latter might be the only way to debug early hangs on laptops
	 without serial console anyway.

   3.2.2 Using ACPI_DEBUG Boot Parameters via /sysfs and /proc

	 The same as 3.2.1., you can also pass the parameters at runtime e.g.
	 via:
	 echo 0x1F >/proc/acpi/debug_level    # before 2.6.22 or
         echo ?!?  >/sys/?/!/?                # Rui?
	 Wrapping such statements around loading and unloading a bug affected
	 ACPI module might give you the possibility to increase debug_level,
	 but still only give you a managable amount of debug output.

   3.2.3 Using ACPI_DEBUG ASL debug object

	 You can also add a kind of printk to DSDT code(see 2. Overriding DSDT)
	 Store (XY, debug), will print the value of the ACPI XY variable into
	 syslog. Be aware that you need to have the
	 #define ACPI_LV_DEBUG_OBJECT        0x00000008
	 value defined in the debug_level mask to see any output.
	 This may only be useful if you get too much output with 3.2.[12] and
	 you think it is convenient to debug a very specific part of the ACPI
	 code.

   3.2.4 Using ACPI_DEBUG acpi_dbg_layer and acpi_dbg_level kernel variables

	 Similar, but more powerful than 3.2.3 is to modify the global kernel
	 variables for level and layer conditionally in the kernel code for
	 your needs.
	 E.g.
	 acpi_debug_level=0xFFFFFFFF /* increase debug output to max */
	 status = acpi_ut_evaluate_object(...) /* by kernel invoked ACPI method
						  that should get debugged with
						  very high debug output*/
 	 acpi_debug_level=0x3        /* lower debug output again */




"It seems unfortunate if we do this work and get our
partners to do the work and the result is that Linux works great without
having to do the work" (Bill Gates on Making ACPI Not Work with Linux,
http://www.osnews.com/story.php/17689/Bill-Gates-on-Making-ACPI-Not-Work-with-Linux)


