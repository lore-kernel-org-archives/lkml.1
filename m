Return-Path: <linux-kernel-owner+w=401wt.eu-S932574AbXKUBYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932574AbXKUBYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763666AbXKUBOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:14:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46744 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765614AbXKUBOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:14:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Subject: Re: apm emulation driver broken ?
Date: Wed, 21 Nov 2007 02:32:30 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
References: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com> <200711182322.41354.rjw@sisk.pl> <47418A00.1000704@gmail.com>
In-Reply-To: <47418A00.1000704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711210232.30575.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 of November 2007, Franck Bui-Huu wrote:
> Rafael J. Wysocki wrote:
> > On Sunday, 18 of November 2007, Franck Bui-Huu wrote:
> >> Rafael J. Wysocki wrote:
> >> See the call to wait_even() made by apm_ioctl(). If any processes
> >> run this, it will prevent the system to suspend...
> > 
> > True, but does it actually happen in practice?
> > 
> 
> when several processes are waiting for a suspend event.
> 
> > 
> > At this point the second branch of the "if (as->suspend_state == SUSPEND_READ)"
> > can be fixed by replacing wait_event_interruptible() with
> > wait_event_freezable(), 
> 
> yes
> 
> > but the fix for the first branch depends on whether or
> > not the wait_event() is really necessary.
> 
> As I said I don't know. It's probably time to put some people
> on CC but don't know who though.

OK, never mind.  I think the patch below is the right fix.


---
From: Rafael J. Wysocki <rjw@sisk.pl>

The APM emulation is currently broken as a result of commit
831441862956fffa17b9801db37e6ea1650b0f69
"Freezer: make kernel threads nonfreezable by default"
that removed the PF_NOFREEZE annotations from apm_ioctl() without adding
the appropriate freezer hooks.  Fix it and remove the unnecessary variable flags
from apm_ioctl().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/char/apm-emulation.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/char/apm-emulation.c
===================================================================
--- linux-2.6.orig/drivers/char/apm-emulation.c
+++ linux-2.6/drivers/char/apm-emulation.c
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
