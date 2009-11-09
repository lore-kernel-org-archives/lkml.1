Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbZKIUpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbZKIUpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 15:45:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbZKIUpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 15:45:03 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39096 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZKIUpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 15:45:02 -0500
Date: Mon, 9 Nov 2009 21:45:06 +0100
From: Andreas Mohr <andi@lisas.de>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael A. Griffith" <grif@acm.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] provide crucial explanations for the dreaded "No init
	found." boot failure.
Message-ID: <20091109204506.GA16453@rhlx01.hs-esslingen.de>
References: <20091108120008.GA21611@rhlx01.hs-esslingen.de> <20091108142506.GA6240@hack> <20091108144548.GA13429@rhlx01.hs-esslingen.de> <20091108151153.GC6240@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091108151153.GC6240@hack>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 11:11:53PM +0800, Américo Wang wrote:
> On Sun, Nov 08, 2009 at 03:45:50PM +0100, Andreas Mohr wrote:
> >Hi,
> >
> >On Sun, Nov 08, 2009 at 10:25:06PM +0800, Américo Wang wrote:
> >> On Sun, Nov 08, 2009 at 01:00:08PM +0100, Andreas Mohr wrote:
> >So, where to put it?
> >Documentation/initrd.txt is related, however I'd create something
> >like Documentation/initialization/...
> >Or perhaps Documentation/bootup/init.txt ?
> 
> Personally, I prefer Documentation/init.txt, but adding it to
> initrd.txt also makes sense for me. :)

Yup, chose Documentation/init.txt.

Patch against 2.6.32-rc6 attached, UNTESTED (checkpatch.pl is fine).

Please get something like this committed, half a million $$ in prior damage
ought to be enough for everybody.

Thanks,

Signed-off-by: Andreas Mohr <andi@lisas.de>


--- linux-2.6.32-rc6/init/main.c.orig	2009-11-08 11:09:51.000000000 +0100
+++ linux-2.6.32-rc6/init/main.c	2009-11-09 21:34:24.000000000 +0100
@@ -846,7 +846,8 @@
 	run_init_process("/bin/init");
 	run_init_process("/bin/sh");
 
-	panic("No init found.  Try passing init= option to kernel.");
+	panic("No init found.  Try passing init= option to kernel. "
+	      "See Linux Documentation/init.txt for guidance.");
 }
 
 static int __init kernel_init(void * unused)
--- /dev/null	2009-10-09 14:49:35.924999847 +0200
+++ linux-2.6.32-rc6/Documentation/init.txt	2009-11-09 21:27:39.000000000 +0100
@@ -0,0 +1,42 @@
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
+A) Please make sure you have the correct root FS type
+(and root= in bootloader or CONFIG_CMDLINE points to the correct partition),
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
