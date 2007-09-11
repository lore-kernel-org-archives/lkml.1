Return-Path: <linux-kernel-owner+w=401wt.eu-S965973AbXIKDyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965973AbXIKDyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 23:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965797AbXIKDyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 23:54:31 -0400
Received: from home.nigel.suspend2.net ([203.171.70.205]:54910 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965750AbXIKDya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 23:54:30 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rafael Wysocki <rjw@sisk.pl>
Subject: [PATCH] Fix failure to resume from initrds.
Date: Tue, 11 Sep 2007 13:54:24 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111354.25689.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.

Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make kernel threads
nonfreezable by default) breaks freezing when attempting to resume from an
initrd, because the init (which is freezeable) spins while waiting for another
thread to run /linuxrc, but doesn't check whether it has been told to enter
the refrigerator. The original patch replaced a call to try_to_freeze() with a
call to yield(). I believe a simple reversion is wrong because
if !CONFIG_PM_SLEEP, try_to_freeze() is a noop. It should still yield.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>

 do_mounts_initrd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
diff -ruNp 952-fix-initrd-resume.patch-old/init/do_mounts_initrd.c 952-fix-initrd-resume.patch-new/init/do_mounts_initrd.c
--- 952-fix-initrd-resume.patch-old/init/do_mounts_initrd.c	2007-09-11 13:43:31.000000000 +1000
+++ 952-fix-initrd-resume.patch-new/init/do_mounts_initrd.c	2007-09-11 13:19:50.000000000 +1000
@@ -58,8 +58,10 @@ static void __init handle_initrd(void)
 
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
 	if (pid > 0)
-		while (pid != sys_wait4(-1, NULL, 0, NULL))
+		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
 			yield();
+			try_to_freeze();
+		}
 
 	if (!resume_attempted)
 		printk(KERN_ERR "Suspend2: No attempt was made to resume from "

-- 
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.
