Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbXINMKr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbXINMKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 08:10:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759055AbXINMK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 08:10:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46270 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbXINMK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 08:10:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix failure to resume from initrds
Date: Fri, 14 Sep 2007 14:22:18 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709141422.18788.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Please consider as 2.6.23 material]
---
From: Nigel Cunningham <nigel@nigel.suspend2.net>

Commit 831441862956fffa17b9801db37e6ea1650b0f69 (Freezer: make kernel threads
nonfreezable by default) breaks freezing when attempting to resume from an
initrd, because the init (which is freezeable) spins while waiting for another
thread to run /linuxrc, but doesn't check whether it has been told to enter
the refrigerator. The original patch replaced a call to try_to_freeze() with a
call to yield(). I believe a simple reversion is wrong because
if !CONFIG_PM_SLEEP, try_to_freeze() is a noop. It should still yield.

Signed-off-by: Nigel Cunningham <nigel@nigel.suspend2.net>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 init/do_mounts_initrd.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.23-rc6/init/do_mounts_initrd.c
===================================================================
--- linux-2.6.23-rc6.orig/init/do_mounts_initrd.c
+++ linux-2.6.23-rc6/init/do_mounts_initrd.c
@@ -57,8 +57,10 @@ static void __init handle_initrd(void)
 
 	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
 	if (pid > 0)
-		while (pid != sys_wait4(-1, NULL, 0, NULL))
+		while (pid != sys_wait4(-1, NULL, 0, NULL)) {
+			try_to_freeze();
 			yield();
+		}
 
 	/* move initrd to rootfs' /old */
 	sys_fchdir(old_fd);
