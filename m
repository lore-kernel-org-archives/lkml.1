Return-Path: <linux-kernel-owner+w=401wt.eu-S1759374AbYFMD0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374AbYFMD0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 23:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757375AbYFMD0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 23:26:37 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:39760 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbYFMD0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 23:26:36 -0400
X-Greylist: delayed 3144 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2008 23:26:36 EDT
Date: Thu, 12 Jun 2008 19:33:48 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, sam@ravnborg.org,
       shai@scalex86.org
Subject: [2.6.25 - stable] Fix Kconfig dependencies to prevent
	CONFIG_X86_VSMP from vanishing
Message-ID: <20080613023348.GA6071@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a Kconfig bug found sometime back which made CONFIG_X86_VSMP
disappear from the .config.  The bug description is as follows:

On a linux-2.6.25.6 source tree, x86_64 arch,

1. Use make menuconfig to select "Processor type and features" menu
2. Change  Subarchitecture type  from "PC-Compatible" to
   "Support for ScaleMP vSMP"
3. Exit and save configuration.  Make sure CONFIG_X86_VSMP is selected in
   .config
4. Build the kernel and recheck the .config for CONFIG_X86_VSMP --
   CONFIG_X86_VSMP disappeared!  However, vsmp bits get built and linked
   in.  On booting up the resulting  kernel on a ScaleMP vSMPowered machine,
   dmesg shows   printks that ought to happen if CONFIG_X86_VSMP is set, however,
   /proc/config.gz says CONFIG_X86_VSMP is unset!  The inter-node cacheline
   setting (CONFIG_X86_INTERNODE_CACHE_BYTE) which is dependent on
   CONFIG_X86_VSMP is not set correctly in /proc/config.gz either.  Hence,
   we can't be sure if INTERNODE_CACHE_BYTE is set correctly
5. Running 'make oldconfig' or 'make menuconfig' again after 3. causes
   CONFIG_X86_VSMP to vanish.

This bug was reported sometime back and fixed in x86 tree and eventually in
2.6.26-rc.
The original bug report can be found at:
	http://lkml.org/lkml/2008/2/26/318

The fixes were posted by Roman in the same thread:
	http://lkml.org/lkml/2008/2/28/575

The fixes consisted of 3 patches, but the first one is sufficient to fix the
problem in 2.6.25

The commits in mainline for the fix are:
	823c248e7cc75b4f22da914b01f8e5433cff197e
	48981178869bf7d9770f11fc361996ad11217a75
	5a1aa8a1aff6191ecc55f21d8b5f0e47108ed91b

Please consider a trimmed down version of the first patch --
823c248e7cc75b4f22da914b01f8e5433cff197e, which is sufficient to fix
the CONFIG_X86_VSMP disappearance for stable release.  CONFIG_X86_VSMP
has been well supported and working well since 2.6.16.  Not able to choose
CONFIG_X86_VSMP reliably is a major regression.  Users compiling
kernel.org 2.6.25 kernel for vSMP have been reporting problems which are
mainly due to CONFIG_X86_VSMP disappearing.  In addition /proc/config.gz
mismatch due to the bug is a major PITA.

I am including a trimmed down patch of
823c248e7cc75b4f22da914b01f8e5433cff197e to fix CONFIG_VSMP as per
stable policy.  This was tested and found to fix the problem mentioned
above.  Please apply.

Thanks,
Kiran

---

x86: fix recursive dependencies with CONFIG_VSMP

Trimmed down version of the commit
823c248e7cc75b4f22da914b01f8e5433cff197e

Originally-by: Roman Zippel <zippel@linux-m68k.org>

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux-2.6.25.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.25.6.orig/arch/x86/Kconfig	2008-06-12 18:09:37.000000000 -0700
+++ linux-2.6.25.6/arch/x86/Kconfig	2008-06-12 18:25:04.000000000 -0700
@@ -339,7 +339,7 @@ config X86_RDC321X
 
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
-	depends on X86_64 && PCI
+	depends on X86_64
 	 help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option
@@ -1391,7 +1391,7 @@ endmenu
 menu "Bus options (PCI etc.)"
 
 config PCI
-	bool "PCI support" if !X86_VISWS
+	bool "PCI support" if !X86_VISWS && !X86_VSMP
 	depends on !X86_VOYAGER
 	default y
 	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
