Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbXDZRHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbXDZRHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXDZRBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:01:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39627 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbXDZRA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:00:29 -0400
Date: Thu, 26 Apr 2007 09:56:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Antonino Daplas <adaplas@pol.net>,
       Michal Januszewski <spock@gentoo.org>
Subject: [patch 21/33] vt: fix potential race in VT_WAITACTIVE handler
Message-ID: <20070426165635.GV1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vt-fix-potential-race-in-vt_waitactive-handler.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michal Januszewski <spock@gentoo.org>

[PATCH] vt: fix potential race in VT_WAITACTIVE handler

On a multiprocessor machine the VT_WAITACTIVE ioctl call may return 0 if
fg_console has already been updated in redraw_screen() but the console
switch itself hasn't been completed.  Fix this by checking fg_console in
vt_waitactive() with the console sem held.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Acked-by: Antonino Daplas <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/vt_ioctl.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -1038,10 +1038,22 @@ int vt_waitactive(int vt)
 
 	add_wait_queue(&vt_activate_queue, &wait);
 	for (;;) {
-		set_current_state(TASK_INTERRUPTIBLE);
 		retval = 0;
-		if (vt == fg_console)
+
+		/*
+		 * Synchronize with redraw_screen(). By acquiring the console
+		 * semaphore we make sure that the console switch is completed
+		 * before we return. If we didn't wait for the semaphore, we
+		 * could return at a point where fg_console has already been
+		 * updated, but the console switch hasn't been completed.
+		 */
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

-- 
