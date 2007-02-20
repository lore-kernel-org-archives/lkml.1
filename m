Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbXBTGco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbXBTGco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 01:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932844AbXBTGco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 01:32:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:51258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbXBTGcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 01:32:43 -0500
Date: Mon, 19 Feb 2007 22:31:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-mm2
Message-Id: <20070219223151.b3fbe18e.akpm@linux-foundation.org>
In-Reply-To: <200702200220.22721.rjw@sisk.pl>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
	<200702181344.54959.rjw@sisk.pl>
	<20070218114326.35d7645b.akpm@linux-foundation.org>
	<200702200220.22721.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 02:20:21 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, 18 February 2007 20:43, Andrew Morton wrote:
> > On Sun, 18 Feb 2007 13:44:54 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Sunday, 18 February 2007 06:51, Andrew Morton wrote:
> > > > 
> > > > Temporarily at
> > > > 
> > > >   http://userweb.kernel.org/~akpm/2.6.20-mm2/
> > > > 
> > > > Will appear later at
> > > > 
> > > >  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/
> > > 
> > > Two problems:
> > > 
> > > 1) A showstopper with the root partition on RAID1:
> > > 
> > > md: raid1 personality registered for level 1
> > > [--snip--]
> > > md: multipath personality registered for level -4
> > > register_blkdev: failed to get major for mdp
> > > [--snip--]
> > > VFS: Cannot open root device "md1" or unknown-block(0,0)
> > 
> > Someone else reported that against mainline.  Can you please debug it a bit?
> 
> For now I can only say 2.6.20 + origin.patch breaks.
> 
> However, it's a SUSE 10.1 system with gcc 4.1.0 and this may be the reason.
> I'll check that tomorrow.

Yes, Rolf says this goes away when you stop using gcc-4.1.0.

I'm hoping that churning the code around like below makes things work
right.



From: Andrew Morton <akpm@linux-foundation.org>

Several people have reported failures in dynamic major device number handling
due to the recent changes in there to avoid handing out the local/experimental
majors.

Rolf reports that this is due to a gcc-4.1.0 bug.

The patch refactors that code a lot in an attempt to provoke the compiler into
behaving.

Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/genhd.c          |    9 ++-------
 drivers/base/core.c    |   14 ++++++++++++++
 fs/char_dev.c          |    8 ++------
 include/linux/kdev_t.h |    1 +
 4 files changed, 19 insertions(+), 13 deletions(-)

diff -puN block/genhd.c~rework-reserved-major-handling block/genhd.c
--- a/block/genhd.c~rework-reserved-major-handling
+++ a/block/genhd.c
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
+#include <linux/kdev_t.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
 #include <linux/init.h>
@@ -61,13 +62,7 @@ int register_blkdev(unsigned int major, 
 	/* temporary */
 	if (major == 0) {
 		for (index = ARRAY_SIZE(major_names)-1; index > 0; index--) {
-			/*
-			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
-			 * majors
-			 */
-			if ((60 <= index && index <= 63) ||
-					(120 <= index && index <= 127) ||
-					(240 <= index && index <= 254))
+			if (is_lanana_major(index))
 				continue;
 			if (major_names[index] == NULL)
 				break;
diff -puN fs/char_dev.c~rework-reserved-major-handling fs/char_dev.c
--- a/fs/char_dev.c~rework-reserved-major-handling
+++ a/fs/char_dev.c
@@ -6,6 +6,7 @@
 
 #include <linux/init.h>
 #include <linux/fs.h>
+#include <linux/kdev_t.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -108,12 +109,7 @@ __register_chrdev_region(unsigned int ma
 	/* temporary */
 	if (major == 0) {
 		for (i = ARRAY_SIZE(chrdevs)-1; i > 0; i--) {
-			/*
-			 * Disallow the LANANA-assigned LOCAL/EXPERIMENTAL
-			 * majors
-			 */
-			if ((60 <= i && i <= 63) || (120 <= i && i <= 127) ||
-					(240 <= i && i <= 254))
+			if (is_lanana_major(i))
 				continue;
 			if (chrdevs[i] == NULL)
 				break;
diff -puN drivers/base/core.c~rework-reserved-major-handling drivers/base/core.c
--- a/drivers/base/core.c~rework-reserved-major-handling
+++ a/drivers/base/core.c
@@ -28,6 +28,20 @@ int (*platform_notify)(struct device * d
 int (*platform_notify_remove)(struct device * dev) = NULL;
 
 /*
+ * Detect the LANANA-assigned LOCAL/EXPERIMENTAL majors
+ */
+bool is_lanana_major(unsigned int major)
+{
+	if (major >= 60 && major <= 63)
+		return 1;
+	if (major >= 120 && major <= 127)
+		return 1;
+	if (major >= 240 && major <= 254)
+		return 1;
+	return 0;
+}
+
+/*
  * sysfs bindings for devices.
  */
 
diff -puN include/linux/kdev_t.h~rework-reserved-major-handling include/linux/kdev_t.h
--- a/include/linux/kdev_t.h~rework-reserved-major-handling
+++ a/include/linux/kdev_t.h
@@ -87,6 +87,7 @@ static inline unsigned sysv_minor(u32 de
 	return dev & 0x3ffff;
 }
 
+bool is_lanana_major(unsigned int major);
 
 #else /* __KERNEL__ */
 
_

