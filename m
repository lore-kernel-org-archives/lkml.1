Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbZIKFTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbZIKFTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 01:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZIKFTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 01:19:41 -0400
Received: from mail-yx0-f176.google.com ([209.85.210.176]:36914 "EHLO
	mail-yx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZIKFTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 01:19:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KQXOXb+0tSoH9ckOLtq1t0WOCILyaYUCH2y2Q8wNBmkMnu3/sfZQd0pzRuP19Gv29S
         p8hdC1/R5HB3PNSvMiOh2iHh1MVledqR3/z8v/FxJCyniOs/mSiNHrx5EaTwIAHS/lg5
         VKfTJbSctoDfhLgXYtCgTLSppQ6RmEV/Pp49o=
Date: Thu, 10 Sep 2009 22:19:39 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/22] 2.6.30.7-stable review
Message-ID: <20090911051939.GE23210@core.coreip.homeip.net>
References: <20090911002616.GA12087@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911002616.GA12087@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 05:26:16PM -0700, Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.30.7 release.
> There are 22 patches in this series, all will be posted as a response to
> this one.  If anyone has any issues with these being applied, please let
> us know.  If anyone is a maintainer of the proper subsystem, and wants
> to add a Signed-off-by: line to the patch, please respond with it.
> 

Please consider adding the following commit to the stable:

	ec8b4b7085605e801a7740a2c3c33256aebe249c

Thanks!

-- 
Dmitry


commit ec8b4b7085605e801a7740a2c3c33256aebe249c
Author: Stephen Kitt <steve@sk2.org>
Date:   Wed Aug 12 01:12:08 2009 -0700

    Input: joydev - decouple axis and button map ioctls from input constants
    
    The KEY_MAX change in 2.6.28 changed the values of the JSIOCSBTNMAP and
    JSIOCGBTNMAP constants; software compiled with the old values no longer
    works with kernels following 2.6.28, because the ioctl switch statement
    no longer matches the values given by the software. This patch handles
    these ioctls independently of the length of data specified, and applies the
    same treatment to JSIOCSAXMAP and JSIOCGAXMAP which currently depend on
    ABS_MAX.
    
    Signed-off-by: Stephen Kitt <steve@sk2.org>
    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index 4cfd084..9a1d55b 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -456,8 +456,11 @@ static int joydev_ioctl_common(struct joydev *joydev,
 				unsigned int cmd, void __user *argp)
 {
 	struct input_dev *dev = joydev->handle.dev;
+	size_t len;
 	int i, j;
+	const char *name;
 
+	/* Process fixed-sized commands. */
 	switch (cmd) {
 
 	case JS_SET_CAL:
@@ -499,9 +502,22 @@ static int joydev_ioctl_common(struct joydev *joydev,
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
@@ -511,13 +527,17 @@ static int joydev_ioctl_common(struct joydev *joydev,
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
@@ -529,25 +549,19 @@ static int joydev_ioctl_common(struct joydev *joydev,
 
 		return 0;
 
-	case JSIOCGBTNMAP:
-		return copy_to_user(argp, joydev->keypam,
-			sizeof(__u16) * (KEY_MAX - BTN_MISC + 1)) ? -EFAULT : 0;
+	case (JSIOCGBTNMAP & ~IOCSIZE_MASK):
+		len = min_t(size_t, _IOC_SIZE(cmd), sizeof(joydev->keypam));
+		return copy_to_user(argp, joydev->keypam, len) ? -EFAULT : 0;
 
-	default:
-		if ((cmd & ~IOCSIZE_MASK) == JSIOCGNAME(0)) {
-			int len;
-			const char *name = dev->name;
-
-			if (!name)
-				return 0;
-			len = strlen(name) + 1;
-			if (len > _IOC_SIZE(cmd))
-				len = _IOC_SIZE(cmd);
-			if (copy_to_user(argp, name, len))
-				return -EFAULT;
-			return len;
-		}
+	case JSIOCGNAME(0):
+		name = dev->name;
+		if (!name)
+			return 0;
+
+		len = min_t(size_t, _IOC_SIZE(cmd), strlen(name) + 1);
+		return copy_to_user(argp, name, len) ? -EFAULT : len;
 	}
+
 	return -EINVAL;
 }
 
