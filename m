Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYLFTc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYLFTc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 14:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbYLFTcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 14:32:22 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:30413 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbYLFTcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 14:32:21 -0500
Subject: Re: Runaway loop with the current git.
From: Kay Sievers <kay.sievers@vrfy.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com>
References: <20081205181610.518ecd13@lxorguk.ukuu.org.uk>
	 <20081205192755.GA27712@ioremap.net>
	 <20081205193432.290a6f1a@lxorguk.ukuu.org.uk>
	 <20081205211223.GA8075@ioremap.net>
	 <ac3eb2510812051317q79ca88e9ya876ffb94162eeca@mail.gmail.com>
	 <20081205212428.GB8075@ioremap.net>
	 <ac3eb2510812051810x8cf4256lf9fd31b15b9e0552@mail.gmail.com>
	 <20081206160927.GA498@ioremap.net>
	 <ac3eb2510812060816h4401c78bj6d656d0d5721024@mail.gmail.com>
	 <20081206165634.GA2516@ioremap.net>
	 <ac3eb2510812061011u7a7f0fbdtc46b95a9c642f9c7@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 06 Dec 2008 20:32:06 +0100
Message-Id: <1228591926.3808.6.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-12-06 at 19:11 +0100, Kay Sievers wrote:
> On Sat, Dec 6, 2008 at 17:56, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> > On Sat, Dec 06, 2008 at 05:16:06PM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
> >> So the loop is probably a modprobe itself that tries to access
> >> /dev/console. Is there a different argument for the very first
> >> modprobe which is called? Which may be the one that triggers the loop.
> >
> > Hard to tell, I did not see anything but modprobe before and after
> > runaway loop message, but it could be missed though, I will tell
> > for sure only this Monday.
> 
> Sounds good.
> 
> It seems the /dev/console driver is registered only after all the pci,
> video, acpi, ... drivers, so it's not surprising, that if any of these
> driver in these subsystems calls request_module(), or a process in
> initramfs tries to access the "dead" /dev/console node, things will go
> wrong.

I don't know if it may have any bad side-effects. It moves the tty
registration earlier, before we do pci, framebuffer, video, acpi
registration.

It boots fine here with and without initramfs.

Maybe it makes the "dead" /dev/console in your initramfs working, then
we at least know the problem.

Thanks,
Kay



diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 1412a8d..72bc98f 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -3115,26 +3115,14 @@ void __init console_init(void)
 	}
 }
 
-static int __init tty_class_init(void)
+static struct cdev tty_cdev, console_cdev;
+
+static int __init tty_init(void)
 {
 	tty_class = class_create(THIS_MODULE, "tty");
 	if (IS_ERR(tty_class))
 		return PTR_ERR(tty_class);
-	return 0;
-}
-
-postcore_initcall(tty_class_init);
-
-/* 3/2004 jmc: why do these devices exist? */
 
-static struct cdev tty_cdev, console_cdev;
-
-/*
- * Ok, now we can initialize the rest of the tty devices and can count
- * on memory allocations, interrupts etc..
- */
-static int __init tty_init(void)
-{
 	cdev_init(&tty_cdev, &tty_fops);
 	if (cdev_add(&tty_cdev, MKDEV(TTYAUX_MAJOR, 0), 1) ||
 	    register_chrdev_region(MKDEV(TTYAUX_MAJOR, 0), 1, "/dev/tty") < 0)
@@ -3154,4 +3142,4 @@ static int __init tty_init(void)
 #endif
 	return 0;
 }
-module_init(tty_init);
+postcore_initcall(tty_init);


