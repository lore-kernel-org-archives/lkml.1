Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbZI0P7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbZI0P7a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 11:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZI0P73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 11:59:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60396 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbZI0P73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 11:59:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>
Subject: [PATCH, fix] Re: [Regression] 2.6.31-git: tty change broke resume from hibernation on MSI Wind U100
Date: Sun, 27 Sep 2009 18:00:42 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Dave Young <hidave.darkstar@gmail.com>
References: <200909260038.22079.rjw@sisk.pl> <20090927124716.2fd8a1de@lxorguk.ukuu.org.uk> <200909271700.38541.rjw@sisk.pl>
In-Reply-To: <200909271700.38541.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909271800.43066.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 September 2009, Rafael J. Wysocki wrote:
> On Sunday 27 September 2009, Alan Cox wrote:
> > On Sat, 26 Sep 2009 00:38:21 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > Hi Alan,
> > > 
> > > As stated at http://bugzilla.kernel.org/show_bug.cgi?id=14229, your commit
> > > b50989dc444599c8b21edc23536fc305f4e9b7d5
> > > (tty: make the kref destructor occur asynchronously) appears to have broken
> > > resume from hibernation on MSI Wind U100.
> > > 
> > > I verified that hibernation works correctly with this commit reverted.
> > > 
> > > I'm still not sure what the root cause of the problem is, though.
> > 
> > The root cause is that the patch to fix the console async/sync behaviour
> > went into Andrews tree, back out of it and vanished.
> > 
> > It's a known bug, with a known confirmed fix. You may want to pick it up
> > and submit it as there is no tty maintainer currently.
> 
> Thanks, I guess it's this one:
> tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch ?

Tested, works.

Greg, could you please consider taking the patch below?  It fixes a recent
hibernation regression for me, so if not this one, another fix is necessary.

Best,
Rafael

---
From: Dave Young <hidave.darkstar@gmail.com>
Subject: tty: Fix regressions caused by commit b50989dc

The following commit made console open fails while booting:

	commit b50989dc444599c8b21edc23536fc305f4e9b7d5
	Author: Alan Cox <alan@linux.intel.com>
	Date:   Sat Sep 19 13:13:22 2009 -0700

	tty: make the kref destructor occur asynchronously

Due to tty release routines run in a workqueue now, error like the
following will be reported while booting:

INIT open /dev/console Input/output error

It also causes hibernation regression to appear as reported at
http://bugzilla.kernel.org/show_bug.cgi?id=14229

The reason is that now there's latency issue with closing, but when
we open a "closing not finished" tty, -EIO will be returned.

Fix it as per the following Alan's suggestion:

Fun but it's actually not a bug and the fix is wrong in itself as
the port may be closing but not yet being destructed, in which case
it seems to do the wrong thing.  Opening a tty that is closing (and
could be closing for long periods) is supposed to return -EIO.

I suspect a better way to deal with this and keep the old console
timing is to split tty->shutdown into two functions.

tty->shutdown() - called synchronously just before we dump the tty
onto the waitqueue for destruction

tty->cleanup() - called when the destructor runs.

We would then do the shutdown part which can occur in IRQ context
fine, before queueing the rest of the release (from tty->magic = 0
...  the end) to occur asynchronously

The USB update in -next would then need a call like

       if (tty->cleanup)
               tty->cleanup(tty);

at the top of the async function and the USB shutdown to be split
between shutdown and cleanup as the USB resource cleanup and final
tidy cannot occur synchronously as it needs to sleep.

In other words the logic becomes

       final kref put
               make object unfindable

       async
               clean it up

[rjw: Rebased on top of 2.6.31-git, reworked the changelog.]

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: "Rafael J. Wysocki" <rjw@sisk.pl>
---

 drivers/char/tty_io.c           |   15 ++++++++++-----
 drivers/usb/serial/usb-serial.c |    2 +-
 include/linux/tty_driver.h      |   13 +++++++++++--
 3 files changed, 22 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/char/tty_io.c
===================================================================
--- linux-2.6.orig/drivers/char/tty_io.c
+++ linux-2.6/drivers/char/tty_io.c
@@ -1389,7 +1389,7 @@ EXPORT_SYMBOL(tty_shutdown);
  *	of ttys that the driver keeps.
  *
  *	This method gets called from a work queue so that the driver private
- *	shutdown ops can sleep (needed for USB at least)
+ *	cleanup ops can sleep (needed for USB at least)
  */
 static void release_one_tty(struct work_struct *work)
 {
@@ -1397,10 +1397,9 @@ static void release_one_tty(struct work_
 		container_of(work, struct tty_struct, hangup_work);
 	struct tty_driver *driver = tty->driver;
 
-	if (tty->ops->shutdown)
-		tty->ops->shutdown(tty);
-	else
-		tty_shutdown(tty);
+	if (tty->ops->cleanup)
+		tty->ops->cleanup(tty);
+
 	tty->magic = 0;
 	tty_driver_kref_put(driver);
 	module_put(driver->owner);
@@ -1415,6 +1414,12 @@ static void release_one_tty(struct work_
 static void queue_release_one_tty(struct kref *kref)
 {
 	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
+
+	if (tty->ops->shutdown)
+		tty->ops->shutdown(tty);
+	else
+		tty_shutdown(tty);
+
 	/* The hangup queue is now free so we can reuse it rather than
 	   waste a chunk of memory for each port */
 	INIT_WORK(&tty->hangup_work, release_one_tty);
Index: linux-2.6/drivers/usb/serial/usb-serial.c
===================================================================
--- linux-2.6.orig/drivers/usb/serial/usb-serial.c
+++ linux-2.6/drivers/usb/serial/usb-serial.c
@@ -1210,7 +1210,7 @@ static const struct tty_operations seria
 	.chars_in_buffer =	serial_chars_in_buffer,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
-	.shutdown = 		serial_release,
+	.cleanup = 		serial_release,
 	.install = 		serial_install,
 	.proc_fops =		&serial_proc_fops,
 };
Index: linux-2.6/include/linux/tty_driver.h
===================================================================
--- linux-2.6.orig/include/linux/tty_driver.h
+++ linux-2.6/include/linux/tty_driver.h
@@ -45,8 +45,16 @@
  *
  * void (*shutdown)(struct tty_struct * tty);
  *
- * 	This routine is called when a particular tty device is closed for
- *	the last time freeing up the resources.
+ * 	This routine is called synchronously when a particular tty device
+ *	is closed for the last time freeing up the resources.
+ *
+ *
+ * void (*cleanup)(struct tty_struct * tty);
+ *
+ *	This routine is called asynchronously when a particular tty device
+ *	is closed for the last time freeing up the resources. This is
+ *	actually the second part of shutdown for routines that might sleep.
+ *
  *
  * int (*write)(struct tty_struct * tty,
  * 		 const unsigned char *buf, int count);
@@ -233,6 +241,7 @@ struct tty_operations {
 	int  (*open)(struct tty_struct * tty, struct file * filp);
 	void (*close)(struct tty_struct * tty, struct file * filp);
 	void (*shutdown)(struct tty_struct *tty);
+	void (*cleanup)(struct tty_struct *tty);
 	int  (*write)(struct tty_struct * tty,
 		      const unsigned char *buf, int count);
 	int  (*put_char)(struct tty_struct *tty, unsigned char ch);

