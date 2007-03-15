Return-Path: <linux-kernel-owner+w=401wt.eu-S1422857AbXCOOlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422857AbXCOOlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 10:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422861AbXCOOlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 10:41:37 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:51408 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422857AbXCOOlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 10:41:36 -0400
X-Greylist: delayed 1871 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 10:41:36 EDT
Date: Thu, 15 Mar 2007 15:10:23 +0100
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] vt: fix a potential race in the VT_WAITACTIVE handler
Message-ID: <20070315141023.GA9757@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a multiprocessor machine the VT_WAITACTIVE ioctl call may return 0
if fg_console has already been updated in redraw_screen(), but the 
console switch itself hasn't been completed. Fix this by checking
fg_console in vt_waitactive() with the console sem held.

Signed-off-by: Michal Januszewski <spock@gentoo.org>

---
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 3a5d301..00b5b34 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1041,8 +1041,12 @@ int vt_waitactive(int vt)
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		retval = 0;
-		if (vt == fg_console)
+		acquire_console_sem();
+		if (vt == fg_console) {
+			release_console_sem();
 			break;
+		}
+		release_console_sem();
 		retval = -EINTR;
 		if (signal_pending(current))
 			break;

