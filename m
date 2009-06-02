Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbZFBOXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbZFBOXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbZFBOWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:22:55 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:44952 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbZFBOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FU1LiEVOwqkQG+nqTdYta8WAGkrAIFg0Wd1x2XjGxXY9MFoUemMIeW02lRybBAdBgI
         9QYmp7a+uTzth16abfpyRhL4o8Aa/BBun/HXXr6klX/tbl7wQ477qkjhSoN7vdybG7y0
         0OLsB24AyOUDtkeMIk8gDlwVk3bjQLFFvtRS8=
Date: Tue, 2 Jun 2009 18:22:41 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, slapin@ossfans.org,
       maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
       oliver.fendt@siemens.com
Subject: Re: [PATCH 08/10] tty_io: export tty_class
Message-ID: <20090602142241.GA18656@doriath.ww600.siemens.net>
References: <1243868091-5315-3-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-5-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-6-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-7-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-8-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-9-git-send-email-dbaryshkov@gmail.com> <20090601160721.7b262469@lxorguk.ukuu.org.uk> <bc64b4640906010810l8ace77byfbd650b549f9b5c3@mail.gmail.com> <20090601163418.465be751@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601163418.465be751@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 04:34:18PM +0100, Alan Cox wrote:
> > I used class_find_device finding the device with matching minor. Will it be
> > acceptable, if I just move this code into tty_* file and export it as
> > to modules?
> 
> Yes - create a proper tty helper function for doing the job and document
> what it does. That way if the tty layer is changed it is obvious that
> this code also needs considering.

Is this suitable:

>From bea1f7dd279119a1aa60556ff0441e31c92876aa Mon Sep 17 00:00:00 2001
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Tue, 2 Jun 2009 06:31:35 +0400
Subject: [PATCH] tty_io: add an API to get device corresponding to tty_struct

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
---
 drivers/char/tty_io.c |   13 +++++++++++++
 include/linux/tty.h   |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 66b99a2..04d6c9a 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3026,6 +3026,19 @@ dev_t tty_devnum(struct tty_struct *tty)
 }
 EXPORT_SYMBOL(tty_devnum);
 
+static int dev_match_devt(struct device *dev, void *data)
+{
+	dev_t *devt = data;
+	return dev->devt == *devt;
+}
+
+struct device *tty_get_device(struct tty_struct *tty)
+{
+	dev_t devt = tty_devnum(tty);
+	return class_find_device(tty_class, NULL, &devt, dev_match_devt);
+}
+EXPORT_SYMBOL(tty_get_device);
+
 void proc_clear_tty(struct task_struct *p)
 {
 	unsigned long flags;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index fc39db9..d17ba1e 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -413,6 +413,7 @@ extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
 extern dev_t tty_devnum(struct tty_struct *tty);
+struct device *tty_get_device(struct tty_struct *tty);
 extern void proc_clear_tty(struct task_struct *p);
 extern struct tty_struct *get_current_tty(void);
 extern void tty_default_fops(struct file_operations *fops);
-- 
1.6.3.1

-- 
With best wishes
Dmitry

