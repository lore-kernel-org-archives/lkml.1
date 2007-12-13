Return-Path: <linux-kernel-owner+w=401wt.eu-S1763761AbXLMHId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763761AbXLMHId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:08:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761748AbXLMG5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:57:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55354 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761694AbXLMG5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:57:05 -0500
Date: Wed, 12 Dec 2007 22:52:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Franck Bui-Huu <vagabon.xyz@gmail.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Len Brown <len.brown@intel.com>
Subject: [patch 30/60] Freezer: Fix APM emulation breakage
Message-ID: <20071213065227.GE6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="freezer-fix-apm-emulation-breakage.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

patch cb43c54ca05c01533c45e4d3abfe8f99b7acf624 in mainline.

The APM emulation is currently broken as a result of commit
831441862956fffa17b9801db37e6ea1650b0f69
"Freezer: make kernel threads nonfreezable by default"
that removed the PF_NOFREEZE annotations from apm_ioctl() without adding
the appropriate freezer hooks.  Fix it and remove the unnecessary variable flags
from apm_ioctl().

Special thanks to Franck Bui-Huu <vagabon.xyz@gmail.com> for pointing out the
problem.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/apm-emulation.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -295,7 +295,6 @@ static int
 apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
 {
 	struct apm_user *as = filp->private_data;
-	unsigned long flags;
 	int err = -EINVAL;
 
 	if (!as->suser || !as->writer)
@@ -331,10 +330,16 @@ apm_ioctl(struct inode * inode, struct f
 			 * Wait for the suspend/resume to complete.  If there
 			 * are pending acknowledges, we wait here for them.
 			 */
-			flags = current->flags;
+			freezer_do_not_count();
 
 			wait_event(apm_suspend_waitqueue,
 				   as->suspend_state == SUSPEND_DONE);
+
+			/*
+			 * Since we are waiting until the suspend is done, the
+			 * try_to_freeze() in freezer_count() will not trigger
+			 */
+			freezer_count();
 		} else {
 			as->suspend_state = SUSPEND_WAIT;
 			mutex_unlock(&state_lock);
@@ -362,14 +367,10 @@ apm_ioctl(struct inode * inode, struct f
 			 * Wait for the suspend/resume to complete.  If there
 			 * are pending acknowledges, we wait here for them.
 			 */
-			flags = current->flags;
-
-			wait_event_interruptible(apm_suspend_waitqueue,
+			wait_event_freezable(apm_suspend_waitqueue,
 					 as->suspend_state == SUSPEND_DONE);
 		}
 
-		current->flags = flags;
-
 		mutex_lock(&state_lock);
 		err = as->suspend_result;
 		as->suspend_state = SUSPEND_NONE;

-- 
