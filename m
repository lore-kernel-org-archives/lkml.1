Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYHaWyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYHaWyQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 18:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYHaWx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 18:53:59 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:49263 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752601AbYHaWx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 18:53:59 -0400
Message-ID: <48BB2116.1060904@lwfinger.net>
Date: Sun, 31 Aug 2008 17:54:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <akataria@vmware.com>
CC: Michael Buesch <mb@bu3sch.de>
Subject: Regression in 2.6.27 caused by commit bfc0f59
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An ancient laptop of mine started throwing errors from b43legacy when 
I started using 2.6.27 on it. This has been bisected to commit bfc0f59 
"x86: merge tsc calibration". Incidentally, I was appalled at the 
number of build errors that were found while bisecting in this region. 
Every commit from 2.6.26-rc9-00715 to at least -00719 had include 
errors that had to be fixed before it would compile. Those fixes are 
the only reason that the builds below are "dirty".

The CPU in this computer is an AMD-K6 at stepping 0c and running at 
450 MHz.

The critical differences in the dmesg output between the "good" and 
"bad" results indicate a factor of 2 difference in the clock speed, 
and are shown below:

============================================================
finger@larrylap:/ide1/mtech/wireless-testing> diff -u /ide1/dmesg.good 
/ide1/dmesg.bad
--- /ide1/dmesg.good    2008-08-31 16:23:32.000000000 -0500
+++ /ide1/dmesg.bad     2008-08-31 16:26:25.000000000 -0500
@@ -1,4 +1,4 @@
-Linux version 2.6.26-rc9-test-00715-g0ef9553-dirty (finger@larrylap) 
(gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 
135036] (SUSE Linux) ) #29 Sun Aug 31 15:37:05 ACT 2008
+Linux version 2.6.26-rc9-test-00716-gbfc0f59-dirty (finger@larrylap) 
(gcc version 4.3.1 20080507 (prerelease) [gcc-4_3-branch revision 
135036] (SUSE Linux) ) #31 Sun Aug 31 16:52:23 ACT 2008
  BIOS-provided physical RAM map:
   BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
   BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
@@ -54,7 +54,8 @@
  Kernel command line: root=/dev/sda3 vga=0x314 resume=/dev/sda2 
splash=silent
  Initializing CPU#0
  PID hash table entries: 1024 (order: 10, 4096 bytes)
-Detected 428.846 MHz processor.
+TSC calibrated against PM_TIMER
+Detected 214.401 MHz processor.
  Console: colour dummy device 80x25
  console [tty0] enabled
  Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
@@ -69,7 +70,7 @@
        .text : 0xc0100000 - 0xc02638ac   (1422 kB)
  Checking if this processor honours the WP bit even in supervisor 
mode...Ok.
  CPA: page pool initialized 1 of 1 pages preallocated
-Calibrating delay loop (skipped), value calculated using timer 
frequency.. <6>857.69 BogoMIPS (lpj=1715384)
+Calibrating delay loop (skipped), value calculated using timer 
frequency.. <6>428.80 BogoMIPS (lpj=857604)
  Security Framework initialized
  Capability LSM initialized
  Mount-cache hash table entries: 512
@@ -140,6 +141,7 @@
  TCP reno registered
  NET: Registered protocol family 1
  checking if image is initramfs... it is
+Clocksource tsc unstable (delta = 500037272 ns)
  Freeing initrd memory: 4071k freed
  ACPI: EC: non-query interrupt received, switching to interrupt mode
  ACPI: EC: GPE storm detected, disabling EC GPE
@@ -174,11 +176,10 @@
  TCP cubic registered
  Using IPI Shortcut mode
  Freeing unused kernel memory: 184k freed
-Clocksource tsc unstable (delta = 83950402 ns)
  ACPI: ACPI0007:00 is registered as cooling_device0
  ACPI: Processor [CPU0] (supports 8 throttling states)
  ACPI: LNXTHERM:01 is registered as thermal_zone0
-ACPI: Thermal Zone [THRM] (50 C)
+ACPI: Thermal Zone [THRM] (51 C)
  No dock devices found.
  SCSI subsystem initialized
  libata version 3.00 loaded.
@@ -306,7 +307,10 @@
  b43legacy-phy0: Loading firmware version 0x127, patch level 14 
(2005-04-18 02:36:27)
  b43legacy-phy0 debug: Chip initialized
  b43legacy-phy0 debug: 30-bit DMA initialized
+b43legacy-phy0 ERROR: PHY transmission error
  b43legacy-phy0 debug: Wireless interface started
+b43legacy-phy0 ERROR: PHY transmission error
+b43legacy-phy0 ERROR: PHY transmission error
  b43legacy-phy0 debug: Adding Interface type 2
  NET: Registered protocol family 17
  eth1: Initial auth_alg=0
=======================================================

I am eager to test trial patches.

Thanks,

Larry

