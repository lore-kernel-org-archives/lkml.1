Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXDAMn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXDAMn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 08:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbXDAMn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 08:43:26 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:42989 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953AbXDAMn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 08:43:26 -0400
Date: Sun, 1 Apr 2007 14:43:23 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH resend] vt: fix potential race in VT_WAITACTIVE handler
Message-ID: <20070401124323.GA4040@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Januszewski <spock@gentoo.org>

On a multiprocessor machine the VT_WAITACTIVE ioctl call may return 0
if fg_console has already been updated in redraw_screen() but the
console switch itself hasn't been completed. Fix this by checking
fg_console in vt_waitactive() with the console sem held.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
This is the 2nd version of this patch. It incorporates Andrew's
suggestions, ie. calls set_current_state() after down() and adds
a comment explaining why acquiring the console sem is necessary.

 drivers/char/vt_ioctl.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 1fa2da8..0508293 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1039,10 +1039,20 @@ int vt_waitactive(int vt)
 
 	add_wait_queue(&vt_activate_queue, &wait);
 	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		retval = 0;
-		if (vt == fg_console)
+
+		/* Synchronize with redraw_screen(). By acquiring the console
+		 * semaphore we make sure that the console switch is completed
+		 * before we return. If we didn't wait for the semaphore, we
+		 * could return at a point where fg_console has already been
+		 * updated, but the console switch hasn't been completed. */
+		acquire_console_sem();
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (vt == fg_console) {
+			release_console_sem();
 			break;
+		}
+		release_console_sem();
 		retval = -EINTR;
 		if (signal_pending(current))
 			break;

