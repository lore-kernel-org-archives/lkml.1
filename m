Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbZIPWcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbZIPWcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:32:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757938AbZIPWcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:32:33 -0400
Received: from kroah.org ([198.145.64.141]:40901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962AbZIPWc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:26 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:00 2009
Message-Id: <20090916222900.766305892@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Kitt <steve@sk2.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 01/24] Input: joydev - decouple axis and button map ioctls from input constants
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=input-joydev-decouple-axis-and-button-map-ioctls-from-input-constants.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stephen Kitt <steve@sk2.org>

commit ec8b4b7085605e801a7740a2c3c33256aebe249c upstream.

The KEY_MAX change in 2.6.28 changed the values of the JSIOCSBTNMAP and
JSIOCGBTNMAP constants; software compiled with the old values no longer
works with kernels following 2.6.28, because the ioctl switch statement
no longer matches the values given by the software. This patch handles
these ioctls independently of the length of data specified, and applies the
same treatment to JSIOCSAXMAP and JSIOCGAXMAP which currently depend on
ABS_MAX.

Signed-off-by: Stephen Kitt <steve@sk2.org>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/joydev.c |   66 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 25 deletions(-)

--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -457,8 +457,11 @@ static int joydev_ioctl_common(struct jo
 				unsigned int cmd, void __user *argp)
 {
 	struct input_dev *dev = joydev->handle.dev;
+	size_t len;
 	int i, j;
+	const char *name;
 
+	/* Process fixed-sized commands. */
 	switch (cmd) {
 
 	case JS_SET_CAL:
@@ -500,9 +503,22 @@ static int joydev_ioctl_common(struct jo
 		return copy_to_user(argp, joydev->corr,
 			sizeof(joydev->corr[0]) * joydev->nabs) ? -EFAULT : 0;
 
-	case JSIOCSAXMAP:
-		if (copy_from_user(joydev->abspam, argp,
-				   sizeof(__u8) * (ABS_MAX + 1)))
+	}
+
+	/*
+	 * Process variable-sized commands (the axis and button map commands
+	 * are considered variable-sized to decouple them from the values of
+	 * ABS_MAX and KEY_MAX).
+	 */
+	switch (cmd & ~IOCSIZE_MASK) {
+
+	case (JSIOCSAXMAP & ~IOCSIZE_MASK):
+		len = min_t(size_t, _IOC_SIZE(cmd), sizeof(joydev->abspam));
+		/*
+		 * FIXME: we should not copy into our axis map before
+		 * validating the data.
+		 */
+		if (copy_from_user(joydev->abspam, argp, len))
 			return -EFAULT;
 
 		for (i = 0; i < joydev->nabs; i++) {
@@ -512,13 +528,17 @@ static int joydev_ioctl_common(struct jo
 		}
 		return 0;
 
-	case JSIOCGAXMAP:
-		return copy_to_user(argp, joydev->abspam,
-			sizeof(__u8) * (ABS_MAX + 1)) ? -EFAULT : 0;
-
-	case JSIOCSBTNMAP:
-		if (copy_from_user(joydev->keypam, argp,
-				   sizeof(__u16) * (KEY_MAX - BTN_MISC + 1)))
+	case (JSIOCGAXMAP & ~IOCSIZE_MASK):
+		len = min_t(size_t, _IOC_SIZE(cmd), sizeof(joydev->abspam));
+		return copy_to_user(argp, joydev->abspam, len) ? -EFAULT : 0;
+
+	case (JSIOCSBTNMAP & ~IOCSIZE_MASK):
+		len = min_t(size_t, _IOC_SIZE(cmd), sizeof(joydev->keypam));
+		/*
+		 * FIXME: we should not copy into our keymap before
+		 * validating the data.
+		 */
+		if (copy_from_user(joydev->keypam, argp, len))
 			return -EFAULT;
 
 		for (i = 0; i < joydev->nkey; i++) {
@@ -530,23 +550,19 @@ static int joydev_ioctl_common(struct jo
 
 		return 0;
 
-	case JSIOCGBTNMAP:
-		return copy_to_user(argp, joydev->keypam,
-			sizeof(__u16) * (KEY_MAX - BTN_MISC + 1)) ? -EFAULT : 0;
+	case (JSIOCGBTNMAP & ~IOCSIZE_MASK):
+		len = min_t(size_t, _IOC_SIZE(cmd), sizeof(joydev->keypam));
+		return copy_to_user(argp, joydev->keypam, len) ? -EFAULT : 0;
+
+	case JSIOCGNAME(0):
+		name = dev->name;
+		if (!name)
+			return 0;
 
-	default:
-		if ((cmd & ~IOCSIZE_MASK) == JSIOCGNAME(0)) {
-			int len;
-			if (!dev->name)
-				return 0;
-			len = strlen(dev->name) + 1;
-			if (len > _IOC_SIZE(cmd))
-				len = _IOC_SIZE(cmd);
-			if (copy_to_user(argp, dev->name, len))
-				return -EFAULT;
-			return len;
-		}
+		len = min_t(size_t, _IOC_SIZE(cmd), strlen(name) + 1);
+		return copy_to_user(argp, name, len) ? -EFAULT : len;
 	}
+
 	return -EINVAL;
 }
 


