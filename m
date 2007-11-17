Return-Path: <linux-kernel-owner+w=401wt.eu-S1761518AbXKQKwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761518AbXKQKwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 05:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbXKQKvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 05:51:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59704 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196AbXKQKvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 05:51:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Subject: Re: apm emulation driver broken ?
Date: Sat, 17 Nov 2007 12:09:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-pm@lists.linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
References: <cda58cb80711160706l2cfac2b1p81c7a1090f228f2e@mail.gmail.com> <473EAC1A.1000205@gmail.com> <200711171059.57462.rjw@sisk.pl>
In-Reply-To: <200711171059.57462.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711171209.09985.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 17 of November 2007, Rafael J. Wysocki wrote:
> On Saturday, 17 of November 2007, Franck Bui-Huu wrote:
> > Rafael J. Wysocki wrote:
> > > However, using PF_NOFREEZE to prevent this from happening doesn't seem to be
> > > a good idea.
> > > 
> > 
> > Indeed but...
> > 
> > > I'd probably use wait_event_freezable() (defined in
> > > include/linux/freezer.h) for that.
> > 
> > ...I would just revert this bits from now to make sure this driver
> > work again for v2.6.24.
> 
> I'd prefer not to.
> 
> The PF_NOFREEZE was not present in 2.6.23 already and I wouldn't like to
> reintroduce it now.
> 
> Why do you think that using wait_event_freezable() would not work, BTW?
> 
> > > It tries to send them fake signals and waits for them to freeze.  If
> > > they don't freeze within the timeout, it fails and clears their
> > > TIF_FREEZE bits.
> > 
> > But send_fake_signal() seems to wake up task in INTERRUPTIBLE state
> > only. Looking at signal_wake_up(), it basically do:
> > 
> > 	wake_up_state(t, TASK_INTERRUPTIBLE);
> > 
> > What am I missing ?
> 
> Nothing. :-)
> 
> I didn't remember the change that made the freezer use TASK_INTERRUPTIBLE
> explicitly in there (should have looked at the current code before replying).

Actually, not even that one.  You're right anyway.

Below is a patch that IMO should fix the issue with apm_ioctl().

Greetings,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

The code in apm_ioctl() allows user space tasks waiting for a suspend to
complete to be woken up prematurely as a result of the thawing of tasks carried
out by the freezer.  Fix it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/char/apm-emulation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/char/apm-emulation.c
===================================================================
--- linux-2.6.orig/drivers/char/apm-emulation.c
+++ linux-2.6/drivers/char/apm-emulation.c
@@ -364,7 +364,7 @@ apm_ioctl(struct inode * inode, struct f
 			 */
 			flags = current->flags;
 
-			wait_event_interruptible(apm_suspend_waitqueue,
+			wait_event_freezable(apm_suspend_waitqueue,
 					 as->suspend_state == SUSPEND_DONE);
 		}
 
