Return-Path: <linux-kernel-owner+w=401wt.eu-S934193AbZFLVzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934193AbZFLVzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbZFLVyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:54:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:6699 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbZFLVyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:54:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KAIYmbksosJxZrlgxfciRmOKLOjoyppbpXyCBRZ1KWRyiPfGwwODI0Kk+PjYHpHAPD
         RuAYUDw6FhNJlblk4RpE92NmBoDZAlq7o/BJZVBLNjFqxA0kYINQ1pSBZ6cJsfrazp16
         a3r3bOvdvcyG8Wt7iBosictxQPIFk7m9+5QfY=
Subject: Re: linux-next: input tree build warnings
From: Tero Saarni <tero.saarni@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090612170536.109df1d8.sfr@canb.auug.org.au>
References: <20090612170536.109df1d8.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 00:54:50 +0300
Message-Id: <1244843690.3224.10.camel@hp>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 17:05 +1000, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> Today's linux-next build (x86_64 allmodconfig) produced these warnings:
> 
> drivers/input/evdev.c: In function 'evdev_do_ioctl':
> drivers/input/evdev.c:632: warning: comparison of distinct pointer types lacks a cast
> drivers/input/evdev.c:660: warning: comparison of distinct pointer types lacks a cast
> 
> Introduced by commit 61c7bfcdf5acee06f58b246d6615989134719d19 ("Input:
> synaptics - add support for reporting x/y resolution").

My mistake, thanks for the heads up!


Input: fix warning: comparison of distinct pointer types

Signed-off-by: Tero Saarni <tero.saarni@gmail.com>
---
 drivers/input/evdev.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 7e46b96..7e8d218 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -628,8 +628,9 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
                                abs.flat = dev->absflat[t];
                                abs.resolution = dev->absres[t];
 
-                               if (copy_to_user(p, &abs,
-                                               min(_IOC_SIZE(cmd), sizeof(struct input_absinfo))))
+                               if (copy_to_user(p, &abs, min_t(size_t,
+                                                               _IOC_SIZE(cmd),
+                                                               sizeof(struct input_absinfo))))
                                        return -EFAULT;
 
                                return 0;
@@ -656,8 +657,9 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
                                t = _IOC_NR(cmd) & ABS_MAX;
 
-                               if (copy_from_user(&abs, p,
-                                               min(_IOC_SIZE(cmd), sizeof(struct input_absinfo))))
+                               if (copy_from_user(&abs, p, min_t(size_t,
+                                                               _IOC_SIZE(cmd),
+                                                               sizeof(struct input_absinfo))))
                                        return -EFAULT;
 
                                /*
-- 
1.6.0.4


