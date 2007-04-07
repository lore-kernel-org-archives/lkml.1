Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbXDGQLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbXDGQLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbXDGQK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:10:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48654 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933580AbXDGQK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:10:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] freezer: Remove PF_NOFREEZE from handle_initrd
Date: Sat, 7 Apr 2007 18:14:24 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <ncunningham@linuxmail.org>,
       Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704071814.25588.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make handle_initrd() call try_to_freeze() in a suitable place instead of setting
PF_NOFREEZE for the current task.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 init/do_mounts_initrd.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc6/init/do_mounts_initrd.c
===================================================================
--- linux-2.6.21-rc6.orig/init/do_mounts_initrd.c
+++ linux-2.6.21-rc6/init/do_mounts_initrd.c
@@ -55,11 +55,12 @@ static void __init handle_initrd(void)
 	sys_mount(".", "/", NULL, MS_MOVE, NULL);
 	sys_chroot(".");
 
-	current->flags |= PF_NOFREEZE;
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
 	if (pid > 0) {
-		while (pid != sys_wait4(-1, NULL, 0, NULL))
+		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
+			try_to_freeze();
 			yield();
+		}
 	}
 
 	/* move initrd to rootfs' /old */
