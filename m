Return-Path: <linux-kernel-owner+w=401wt.eu-S967614AbXFHDLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967614AbXFHDLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966742AbXFHDLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:11:02 -0400
Received: from ozlabs.org ([203.10.76.45]:58346 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966393AbXFHDLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:11:00 -0400
Subject: [PATCH 1/7] lguest documentation: infrastructure and Chapter I
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain
Date: Fri, 08 Jun 2007 13:10:57 +1000
Message-Id: <1181272257.24958.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The netfilter code had very good documentation: the Netfilter Hacking
HOWTO.  Noone ever read it.

So this time I'm trying something different, using a bit of
Knuthiness.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 Documentation/lguest/extract          |   58 +++++++++++++++++++++++++++++++++
 Documentation/lguest/lguest.c         |    9 +++--
 drivers/lguest/Makefile               |   12 ++++++
 drivers/lguest/README                 |   47 ++++++++++++++++++++++++++
 drivers/lguest/core.c                 |    7 ++-
 drivers/lguest/hypercalls.c           |    9 +++--
 drivers/lguest/interrupts_and_traps.c |   13 +++++++
 drivers/lguest/io.c                   |    8 +++-
 drivers/lguest/lguest.c               |   31 ++++++++++++++++-
 drivers/lguest/lguest_bus.c           |    3 +
 drivers/lguest/lguest_user.c          |    7 +++
 drivers/lguest/page_tables.c          |   10 ++++-
 drivers/lguest/segments.c             |   11 ++++++
 drivers/lguest/switcher.S             |   13 +++----
 14 files changed, 219 insertions(+), 19 deletions(-)

===================================================================
--- /dev/null
+++ b/Documentation/lguest/extract
@@ -0,0 +1,58 @@
+#! /bin/sh
+
+set -e
+
+PREFIX=$1
+shift
+
+trap 'rm -r $TMPDIR' 0
+TMPDIR=`mktemp -d`
+
+exec 3>/dev/null
+for f; do
+    while IFS="
+" read -r LINE; do
+	case "$LINE" in
+	    *$PREFIX:[0-9]*:\**)
+		NUM=`echo "$LINE" | sed "s/.*$PREFIX:\([0-9]*\).*/\1/"`
+		if [ -f $TMPDIR/$NUM ]; then
+		    echo "$TMPDIR/$NUM already exits prior to $f"
+		    exit 1
+		fi
+		exec 3>>$TMPDIR/$NUM
+		echo $f | sed 's,\.\./,,g' > $TMPDIR/.$NUM
+		/bin/echo "$LINE" | sed -e "s/$PREFIX:[0-9]*//" -e "s/:\*/*/" >&3
+		;;
+	    *$PREFIX:[0-9]*)
+		NUM=`echo "$LINE" | sed "s/.*$PREFIX:\([0-9]*\).*/\1/"`
+		if [ -f $TMPDIR/$NUM ]; then
+		    echo "$TMPDIR/$NUM already exits prior to $f"
+		    exit 1
+		fi
+		exec 3>>$TMPDIR/$NUM
+		echo $f | sed 's,\.\./,,g' > $TMPDIR/.$NUM
+		/bin/echo "$LINE" | sed "s/$PREFIX:[0-9]*//" >&3
+		;;
+	    *:\**)
+		/bin/echo "$LINE" | sed -e "s/:\*/*/" -e "s,/\*\*/,," >&3
+		echo >&3
+		exec 3>/dev/null
+		;;
+	    *)
+		/bin/echo "$LINE" >&3
+		;;
+	esac
+    done < $f
+    echo >&3
+    exec 3>/dev/null
+done
+
+LASTFILE=""
+for f in $TMPDIR/*; do
+    if [ "$LASTFILE" != $(cat $TMPDIR/.$(basename $f) ) ]; then
+	LASTFILE=$(cat $TMPDIR/.$(basename $f) )
+	echo "[ $LASTFILE ]"
+    fi
+    cat $f
+done
+
===================================================================
--- a/Documentation/lguest/lguest.c
+++ b/Documentation/lguest/lguest.c
@@ -1,5 +1,10 @@
-/* Simple program to layout "physical" memory for new lguest guest.
- * Linked high to avoid likely physical memory.  */
+/*P:100 This is the Launcher code, a simple program which lays out the
+ * "physical" memory for the new Guest by mapping the kernel image and the
+ * virtual devices, then reads repeatedly from /dev/lguest to run the Guest.
+ *
+ * The only trick: the Makefile links it statically at a high address, so it
+ * will be clear of the guest memory region.  It means that each Guest cannot
+ * have more than 2.5G of memory on a normally configured Host. :*/
 #define _LARGEFILE64_SOURCE
 #define _GNU_SOURCE
 #include <stdio.h>
===================================================================
--- a/drivers/lguest/Makefile
+++ b/drivers/lguest/Makefile
@@ -5,3 +5,15 @@ obj-$(CONFIG_LGUEST)	+= lg.o
 obj-$(CONFIG_LGUEST)	+= lg.o
 lg-y := core.o hypercalls.o page_tables.o interrupts_and_traps.o \
 	segments.o io.o lguest_user.o switcher.o
+
+Preparation Preparation!: PREFIX=P
+Guest: PREFIX=G
+Drivers: PREFIX=D
+Launcher: PREFIX=L
+Host: PREFIX=H
+Switcher: PREFIX=S
+Mastery: PREFIX=M
+Beer:
+	@for f in Preparation Guest Drivers Launcher Host Switcher Mastery; do echo "{==- $$f -==}"; make -s $$f; done; echo "{==-==}"
+Preparation Preparation! Guest Drivers Launcher Host Switcher Mastery:
+	@sh ../../Documentation/lguest/extract $(PREFIX) `find ../../* -name '*.[chS]' -wholename '*lguest*'`
===================================================================
--- /dev/null
+++ b/drivers/lguest/README
@@ -0,0 +1,47 @@
+Welcome, friend reader, to lguest.
+
+Lguest is an adventure, with you, the reader, as Hero.  I can't think of many
+5000-line projects which offer both such capability and glimpses of future
+potential; it is an exciting time to be delving into the source!
+
+But be warned; this is an arduous journey of several hours or more!  And as we
+know, all true Heroes are driven by a Noble Goal.  Thus I offer a Beer (or
+equivalent) to anyone I meet who has completed this documentation.
+
+So get comfortable and keep your wits about you (both quick and humorous).
+Along your way to the Noble Goal, you will also gain masterly insight into
+lguest, and hypervisors and x86 virtualization in general.
+
+Our Quest is in seven parts: (best read with C highlighting turned on)
+
+I) Preparation
+	- In which our potential hero is flown quickly over the landscape for a
+	  taste of its scope.  Suitable for the armchair coders and other such
+	  persons of faint constitution.
+
+II) Guest
+	- Where we encounter the first tantalising wisps of code, and come to
+	  understand the details of the life of a Guest kernel.
+
+III) Drivers
+	- Whereby the Guest finds its voice and become useful, and our
+	  understanding of the Guest is completed.
+
+IV) Launcher
+	- Where we trace back to the creation of the Guest, and thus begin our
+	  understanding of the Host.
+
+V) Host
+	- Where we master the Host code, through a long and tortuous journey.
+	  Indeed, it is here that our hero is tested in the Bit of Despair.
+
+VI) Switcher
+	- Where our understanding of the intertwined nature of Guests and Hosts
+	  is completed.
+
+VII) Mastery
+	- Where our fully fledged hero grapples with the Great Question:
+	  "What next?"
+
+make Preparation!
+Rusty Russell.
===================================================================
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -1,5 +1,8 @@
-/* World's simplest hypervisor, to test paravirt_ops and show
- * unbelievers that virtualization is the future.  Plus, it's fun! */
+/*P:400 This contains run_guest() which actually calls into the Host<->Guest
+ * Switcher and analyzes the return, such as determining if the Guest wants the
+ * Host to do something.  This file also contains useful helper routines, and a
+ * couple of non-obvious setup and teardown pieces which were implemented after
+ * days of debugging pain. :*/
 #include <linux/module.h>
 #include <linux/stringify.h>
 #include <linux/stddef.h>
===================================================================
--- a/drivers/lguest/hypercalls.c
+++ b/drivers/lguest/hypercalls.c
@@ -1,5 +1,10 @@
-/*  Actual hypercalls, which allow guests to actually do something.
-    Copyright (C) 2006 Rusty Russell IBM Corporation
+/*P:500 Just as userspace programs request kernel operations through a system
+ * call, the Guest requests Host operations through a "hypercall".  You might
+ * notice this nomenclature doesn't really follow any logic, but the name has
+ * been around for long enough that we're stuck with it.  As you'd expect, this
+ * code is basically a one big switch statement. :*/
+
+/*  Copyright (C) 2006 Rusty Russell IBM Corporation
 
     This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU General Public License as published by
===================================================================
--- a/drivers/lguest/interrupts_and_traps.c
+++ b/drivers/lguest/interrupts_and_traps.c
@@ -1,3 +1,16 @@
+/*P:800 Interrupts (traps) are complicated enough to earn their own file.
+ * There are three classes of interrupts:
+ *
+ * 1) Real hardware interrupts which occur while we're running the Guest,
+ * 2) Interrupts for virtual devices attached to the Guest, and
+ * 3) Traps and faults from the Guest.
+ *
+ * Real hardware interrupts must be delivered to the Host, not the Guest.
+ * Virtual interrupts must be delivered to the Guest, but we make them look
+ * just like real hardware would deliver them.  Traps from the Guest can be set
+ * up to go directly back into the Guest, but sometimes the Host wants to see
+ * them first, so we also have a way of "reflecting" them into the Guest as if
+ * they had been delivered to it directly. :*/
 #include <linux/uaccess.h>
 #include "lg.h"
 
===================================================================
--- a/drivers/lguest/io.c
+++ b/drivers/lguest/io.c
@@ -1,5 +1,9 @@
-/* Simple I/O model for guests, based on shared memory.
- * Copyright (C) 2006 Rusty Russell IBM Corporation
+/*P:300 The I/O mechanism in lguest is simple yet flexible, allowing the Guest
+ * to talk to the Launcher or directly to another Guest.  It uses familiar
+ * concepts of DMA and interrupts, plus some neat code stolen from
+ * futexes... :*/
+
+/* Copyright (C) 2006 Rusty Russell IBM Corporation
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -1,6 +1,33 @@
+/*P:010
+ * A hypervisor allows multiple Operating Systems to run on a single machine.
+ * To quote David Wheeler: "Any problem in computer science can be solved with
+ * another layer of indirection."
+ *
+ * We keep things simple in two ways.  First, we start with a normal Linux
+ * kernel and insert a module (lg.ko) which allows us to run other Linux
+ * kernels the same way we'd run processes.  We call the first kernel the Host,
+ * and the others the Guests.  The program which sets up and configures Guests
+ * (such as the example in Documentation/lguest/lguest.c) is called the
+ * Launcher.
+ *
+ * Secondly, we only run specially modified Guests, not normal kernels.  When
+ * you set CONFIG_LGUEST to 'y' or 'm', this automatically sets
+ * CONFIG_LGUEST_GUEST=y, which compiles this file into the kernel so it knows
+ * how to be a Guest.  This means that you can use the same kernel you boot
+ * normally (ie. as a Host) as a Guest.
+ *
+ * These Guests know that they cannot do privileged operations, such as disable
+ * interrupts, and that they have to ask the Host to do such things explicitly.
+ * This file consists of all the replacements for such low-level native
+ * hardware operations: these special Guest versions call the Host.
+ *
+ * So how does the kernel know it's a Guest?  The very first instructions the
+ * 32-bit kernel runs are at startup_32 in arch/i386/kernel/head.S.  This tests
+ * if we're fully privileged: if we're not, we know we're under some kind of
+ * hypervisor.  We end up here, where we replace the native functions in
+ * "struct paravirt_ops" with our Guest versions. :*/
+
 /*
- * Lguest specific paravirt-ops implementation
- *
  * Copyright (C) 2006, Rusty Russell <rusty@rustcorp.com.au> IBM Corporation.
  *
  * This program is free software; you can redistribute it and/or modify
===================================================================
--- a/drivers/lguest/lguest_bus.c
+++ b/drivers/lguest/lguest_bus.c
@@ -1,3 +1,6 @@
+/*P:050 Lguest guests use a very simple bus for devices.  It's a simple array
+ * of device descriptors contained just above the top of normal memory.  The
+ * lguest bus is 80% tedious boilerplate code. :*/
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/lguest_bus.h>
===================================================================
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -1,4 +1,9 @@
-/* Userspace control of the guest, via /dev/lguest. */
+/*P:200 This contains all the /dev/lguest code, whereby the userspace launcher
+ * controls and communicates with the Guest.  For example, the first write will
+ * tell us the memory size, pagetable, entry point and kernel address offset.
+ * A read will run the Guest until a signal is pending (-EINTR), or the Guest
+ * does a DMA out to the Launcher.  Writes are also used to get a DMA buffer
+ * registered by the Guest and to send the Guest an interrupt. :*/
 #include <linux/uaccess.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
===================================================================
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -1,5 +1,11 @@
-/* Shadow page table operations.
- * Copyright (C) Rusty Russell IBM Corporation 2006.
+/*P:700 The pagetable code, on the other hand, still shows the scars of
+ * previous encounters.  It's functional, and as neat as it can be in the
+ * circumstances, but be wary, for these things are subtle and break easily.
+ * The Guest provides a virtual to physical mapping, but we can neither trust
+ * it nor use it: we verify and convert it here to point the hardware to the
+ * actual Guest pages when running the Guest. :*/
+
+/* Copyright (C) Rusty Russell IBM Corporation 2006.
  * GPL v2 and any later version */
 #include <linux/mm.h>
 #include <linux/types.h>
===================================================================
--- a/drivers/lguest/segments.c
+++ b/drivers/lguest/segments.c
@@ -1,3 +1,14 @@
+/*P:600 The x86 architecture has segments, which involve a table of descriptors
+ * which can be used to do funky things with virtual address interpretation.
+ * We originally used to use segments so the Guest couldn't alter the
+ * Guest<->Host Switcher, and then we had to trim Guest segments, and restore
+ * for userspace per-thread segments, but trim again for on userspace->kernel
+ * transitions...  This nightmarish creation was contained within this file,
+ * where we knew not to tread without heavy armament and a change of underwear.
+ *
+ * In these modern times, the segment handling code consists of simple sanity
+ * checks, and the worst you'll experience reading this code is butterfly-rash
+ * from frolicking through its parklike serenity. :*/
 #include "lg.h"
 
 static int desc_ok(const struct desc_struct *gdt)
===================================================================
--- a/drivers/lguest/switcher.S
+++ b/drivers/lguest/switcher.S
@@ -1,10 +1,11 @@
-/* This code sits at 0xFFC00000 to do the low-level guest<->host switch.
+/*P:900 This is the Switcher: code which sits at 0xFFC00000 to do the low-level
+ * Guest<->Host switch.  It is as simple as it can be made, but it's naturally
+ * very specific to x86.
+ *
+ * You have now completed Preparation.  If this has whet your appetite; if you
+ * are feeling invigorated and refreshed then the next, more challenging stage
+ * can be found in "make Guest". :*/
 
-   There is are two pages above us for this CPU (struct lguest_pages).
-   The second page (struct lguest_ro_state) becomes read-only after the
-   context switch.  The first page (the stack for traps) remains writable,
-   but while we're in here, the guest cannot be running.
-*/
 #include <linux/linkage.h>
 #include <asm/asm-offsets.h>
 #include "lg.h"


