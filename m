Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYIIHMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYIIHMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 03:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbYIIHMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 03:12:41 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:20158 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbYIIHMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 03:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fndLMsrrG+KH2QuUUa51kVNC5o1GWpQKQPk3RwLLfzWkTiVghAJKq6cPHusfg39B8z
         g7ToL6Ub5rWu2iJpbBUZNYkxbKqtzs1zu8kMruKNKg094jKXSykJCYy3Bwu3aBxeBcob
         Hn/Z49ukJbUxIuBB2v5ZFpIYBSJqYOOLwFtN0=
Message-ID: <4a5ff6bc0809090012j7121108cpc4cf108a4c323c52@mail.gmail.com>
Date: Tue, 9 Sep 2008 00:12:37 -0700
From: "Steve Calfee" <stevecalfee@gmail.com>
To: "Matthew Wilcox" <matthew@wil.cx>
Subject: Re: USBIP protocol
Cc: "Alan Stern" <stern@rowland.harvard.edu>, "Greg KH" <greg@kroah.com>,
       "USB list" <linux-usb@vger.kernel.org>, bgmerrell@novell.com,
       hirofuchi@users.sourceforge.net,
       "Kernel development list" <linux-kernel@vger.kernel.org>,
       usbip-devel@lists.sourceforge.net
In-Reply-To: <20080909005353.GR2772@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080904214802.GO2772@parisc-linux.org>
	 <Pine.LNX.4.44L0.0809051017280.2493-100000@iolanthe.rowland.org>
	 <20080909005353.GR2772@parisc-linux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have been looking at the USBIP stuff and don't understand the
generic probe issues.

In your second patch:
static struct usb_device_id stub_table[] = {
+#if 0
+	/* just an example */
+	{ USB_DEVICE(0x05ac, 0x0301) },   /* Mac 1 button mouse */
+	{ USB_DEVICE(0x0430, 0x0009) },   /* Plat Home Keyboard */
+	{ USB_DEVICE(0x059b, 0x0001) },   /* Iomega USB Zip 100 */
+	{ USB_DEVICE(0x04b3, 0x4427) },   /* IBM USB CD-ROM */
+	{ USB_DEVICE(0x05a9, 0xa511) },   /* LifeView USB cam */
+	{ USB_DEVICE(0x55aa, 0x0201) },   /* Imation card reader */
+	{ USB_DEVICE(0x046d, 0x0870) },   /* Qcam Express(QV-30) */
+	{ USB_DEVICE(0x04bb, 0x0101) },   /* IO-DATA HD 120GB */
+	{ USB_DEVICE(0x04bb, 0x0904) },   /* IO-DATA USB-ET/TX */
+	{ USB_DEVICE(0x04bb, 0x0201) },   /* IO-DATA USB-ET/TX */
+	{ USB_DEVICE(0x08bb, 0x2702) },   /* ONKYO USB Speaker */
+	{ USB_DEVICE(0x046d, 0x08b2) },   /* Logicool Qcam 4000 Pro */
+#endif
+	/* magic for wild card */
+	{ .driver_info = 1 },
+	{ 0, }                                     /* Terminating entry */
+};

You have changed your driver to a wild card for everything. Fine, it
makes sense, your probe routine should check if it wants a new device
and fail if it does not want it.

My problem is I am using the latest Suse enterprise linux which uses
kernel 2.6.18..... In that kernel the probes are done by the device
system and if a modprobe definition says the module is for this device
it gets loaded (by udev I think) and probed. fine. If the module is
already loaded the kernel probes the modules in the order they were
insmoded (if they say they want the particular VID/PID/CLASS/wildcard
etc.)

The problem is the probing is done by the kernel driver stuff and the
insmoding and user space intelligence is done by udev. Once a kernel
module is installed it must take all devices that match it's device ID
table.  Remember USBIP matches everything! That is because (at least
in the 2.6.18 kernel) the kernel driver stuff stops probing after a
probe fails. This is completely counter-intuitive to me, I would have
assumed that if a probe routine fails, the driver system would keep
going through the list looking for a driver that wants it.

Is this rule still true in the current kernels (I will care if and
when Novel/Suse updates its next enterprise addition).

So, at least in the latest Suse enterprise linux, these are the rules:
1) Any current driver will be probed in the order of insmod. If it
fails, the device will not have a driver
2) If there is no driver, udev will modprobe one and that process will
attach it to the device because all un-probed devices will be
reprobed.

I have not found a way to reprobe unclaimed drivers (and don't know
what order a reprobe would use - if USBIP rejects a device again
because it (USBIP_ is insmoded first it would still be unclaimed).

So to be more descriptive, say you want to do a remote USBIP flash
drive for drive "B", out of three drives, "A", "B","C". How can I
(from user space) enable this sequence? I can control the order of
module loading, (sort of).  I need usb_storage active twice and USBIP
active once for "B". This cannot not work with 2.6.18 - does it work
now?

Regards, Steve
