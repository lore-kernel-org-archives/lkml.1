Return-Path: <linux-kernel-owner+w=401wt.eu-S1760529AbYG1Svg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760529AbYG1Svg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759581AbYG1SvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:51:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:39147 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756058AbYG1SvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:51:08 -0400
Message-ID: <488E150F.9050508@windriver.com>
Date: Mon, 28 Jul 2008 13:50:55 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 2/3] kgdb, mips: add arch support for the kernel's kgdb
 core
References: <20080725.012748.108121457.anemo@mba.ocn.ne.jp><488941C5.9060908@windriver.com><20080725.235233.130241768.anemo@mba.ocn.ne.jp> <20080728.230512.132304415.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080728.230512.132304415.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Jul 2008 18:50:56.0308 (UTC) FILETIME=[DE4F6740:01C8F0E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Atsushi Nemoto wrote:
> On Fri, 25 Jul 2008 23:52:33 +0900 (JST), Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
>>> It seem ok to me to try it.  Here is version 3 of the patch, which I was going to send to Ralf.
>> Thanks, it works for me with serial_txx9 kgdboc module.
> 
> BTW, is FRAME_POINTER mandatory for kgdb?  I agree that FRAME_POINTER
> (ie. -fno-omit-frame-pointer -fno-optimize-sibling-calls) helps source
> level debugging, but I think transparency is more important.
> 
> Now kgdboc can be loaded/activated at run-time, so I want to enable
> CONFIG_KGDB usually.  But CONFIG_FRAME_POINTER introduces runtime
> overhead on overall kernel, which is too bad (at least on MIPS).
> 
> Also, selecting FRAME_POINTER (which is not selectable on MIPS)
> unconditionally looks somewhat inconsistent.
> 
> So ... Is this patch reasonable?
> 

Sure the patch is reasonable for MIPS, but I think it is worth going a
step further.

There is no technical reason that frame pointers are required for KGDB
in the present mainline sources.  This does allow for further
traceability but it is certainly not a requirement for the use of kgdb.
If all you want to do is look at frame 0 and inspect memory or set a
breakpoint and look at some structures kgdb will certainly serve your
purpose.

I'll consider this a defect to the kgdb core and update the
documentation to reflect that it is advised to use frame pointers, but
not a requirement.

Jason.



>From 329f5bb0071eb2a56f2bcf79838ba91784c8b54d Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Mon, 28 Jul 2008 13:48:31 -0500
Subject: [PATCH] kgdb: remove the requirement for CONFIG_FRAME_POINTER

There is no technical reason that the kgdb core requires frame
pointers.  It is up to the end user of KGDB to decide if they need
them or not.

[ anemo@mba.ocn.ne.jp: removed frame pointers on mips ]

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/DocBook/kgdb.tmpl |    8 ++++++++
 lib/Kconfig.kgdb                |   11 +++++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index e8acd1f..54d3b15 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -98,6 +98,14 @@
     "Kernel debugging" select "KGDB: kernel debugging with remote gdb".
     </para>
     <para>
+    It is advised, but not required that you turn on the
+    CONFIG_FRAME_POINTER kernel option.  This option inserts code to
+    into the compiled executable which saves the frame information in
+    registers or on the stack at different points which will allow a
+    debugger such as gdb to more accurately construct stack back traces
+    while debugging the kernel.
+    </para>
+    <para>
     Next you should choose one of more I/O drivers to interconnect debugging
     host and debugged target.  Early boot debugging requires a KGDB
     I/O driver that supports early debugging and the driver must be
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 2cfd272..9b5d1d7 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -4,14 +4,17 @@ config HAVE_ARCH_KGDB
 
 menuconfig KGDB
 	bool "KGDB: kernel debugging with remote gdb"
-	select FRAME_POINTER
 	depends on HAVE_ARCH_KGDB
 	depends on DEBUG_KERNEL && EXPERIMENTAL
 	help
 	  If you say Y here, it will be possible to remotely debug the
-	  kernel using gdb.  Documentation of kernel debugger is available
-	  at http://kgdb.sourceforge.net as well as in DocBook form
-	  in Documentation/DocBook/.  If unsure, say N.
+	  kernel using gdb.  It is recommended but not required, that
+	  you also turn on the kernel config option
+	  CONFIG_FRAME_POINTER to aid in producing more reliable stack
+	  backtraces in the external debugger.  Documentation of
+	  kernel debugger is available at http://kgdb.sourceforge.net
+	  as well as in DocBook form in Documentation/DocBook/.  If
+	  unsure, say N.
 
 if KGDB
 
-- 
1.5.5.1

