Return-Path: <linux-kernel-owner+w=401wt.eu-S1753713AbZKPTkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbZKPTkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 14:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZKPTkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 14:40:11 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35919 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZKPTkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 14:40:10 -0500
Date: Mon, 16 Nov 2009 20:40:15 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] FIX IT
Message-ID: <20091116194015.GA13820@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog: Partially fix B0RKEN kernel usability

checkpatch.pl'd, tested, applies cleanly to 2.6.32-rc7.
Seemingly best to go via trusted mmotm.

Thanks as always,

Signed-off-by: Andreas Mohr <andi@lisas.de>


--- linux-2.6/init/main.c.orig	2009-11-16 20:13:08.000000000 +0100
+++ linux-2.6/init/main.c	2009-11-16 20:14:51.000000000 +0100
@@ -846,7 +846,8 @@ static noinline int init_post(void)
 	run_init_process("/bin/init");
 	run_init_process("/bin/sh");
 
-	panic("No init found.  Try passing init= option to kernel.");
+	panic("No init found.  Try passing init= option to kernel. "
+	      "See Linux Documentation/init.txt for guidance.");
 }
 
 static int __init kernel_init(void * unused)
--- /dev/null	2009-11-10 08:07:33.390012116 +0100
+++ linux-2.6/Documentation/init.txt	2009-11-16 20:17:57.000000000 +0100
@@ -0,0 +1,44 @@
+Explaining the dreaded "No init found." boot hang message
+=========================================================
+
+OK, so you've got this pretty unintuitive message (currently located
+in init/main.c) and are wondering what the H*** went wrong.
+Some high-level reasons for failure (listed roughly in order of execution)
+to load the init binary are:
+A) Unable to mount root FS
+B) init binary doesn't exist on rootfs
+C) other requirements not met
+D) binary exists but dependencies not available
+E) binary cannot be loaded
+
+Detailed explanations:
+0) Set "debug" kernel parameter (in bootloader or CONFIG_CMDLINE)
+to get more detailed kernel messages.
+A) Please make sure you have the correct root FS type
+(and root= kernel parameter points to the correct partition),
+required drivers such as storage hardware (such as SCSI or USB!)
+and filesystem (ext3, jffs2 etc.) are builtin (alternatively as modules by
+using initrd)
+C) Possibly a conflict in console= setup --> initial console unavailable.
+E.g. some serial consoles are unreliable due to serial IRQ issues (e.g. missing
+interrupt-based configuration).
+Try using a different console= device or e.g. netconsole=.
+D) e.g. crucial library dependencies of the init binary such as
+/lib/ld-linux.so.2 missing or broken. Use readelf -d <INIT>|grep NEEDED
+to find out which libraries are required.
+E) make sure the binary's architecture matches your hardware.
+E.g. i386 vs. x86_64 mismatch, or trying to load x86 on ARM hardware.
+Or did you try loading a non-binary file here!?! (shell script?)
+To find out more, add code patch to display kernel_execve()s return values.
+
+Please extend this explanation whenever you find new failure causes
+(after all loading the init binary is a CRITICAL and hard transition step
+which needs to be made as painless as possible), then submit patch to LKML.
+Further TODOs:
+- Implement the various run_init_process() invocations via a struct array
+  which can then store the kernel_execve() result value and on failure
+  log it all by iterating over _all_ results (very important usability fix).
+- try to make the implementation itself more helpful in general,
+  e.g. by providing additional error messages at affected places.
+
+Andreas Mohr <andi at lisas period de>
