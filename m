Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbYIYLlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbYIYLlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYIYLlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:41:11 -0400
Received: from mail.transmode.se ([83.241.175.147]:19774 "EHLO
	mail.transmode.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099AbYIYLlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:41:10 -0400
Subject: Re: UIO device name
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: Ben Nizette <bn@niasdigital.com>
Cc: Paul Mundt <lethal@linux-sh.org>, "Hans J. Koch" <hjk@linutronix.de>,
       gregkh@suse.de, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1222339729.3938.15.camel@moss.renham>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se>
	 <20080924093551.GB7591@linux-sh.org>
	 <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
	 <20080924102230.GB2973@local>
	 <1222255981.12624.215.camel@gentoo-jocke.transmode.se>
	 <20080924114743.GA9694@linux-sh.org>
	 <1222259894.12624.247.camel@gentoo-jocke.transmode.se>
	 <1222297057.4037.12.camel@moss.renham>
	 <1222337151.12624.293.camel@gentoo-jocke.transmode.se>
	 <1222339729.3938.15.camel@moss.renham>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Thu, 25 Sep 2008 13:41:08 +0200
Message-Id: <1222342868.12624.304.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-25 at 20:48 +1000, Ben Nizette wrote:
> On Thu, 2008-09-25 at 12:05 +0200, Joakim Tjernlund wrote:
> > On Thu, 2008-09-25 at 08:57 +1000, Ben Nizette wrote:
> > > 
> > > My software just walks /sys/class/uio/uioX/name, finds the one which
> > > matches then opens the corresponding device.  No scripts needed, no
> > > in-kernel hackery or policy making, just the interface used as the maker
> > > intended.  What's your problem with this approach?
> > 
> > My problem is this, uio is a generic container for any user space device
> > and by itself it doesn't mean much. You put some protocol driver on top
> > of uio, such as uio_smx, to make it mean something. 
> > 
> > Comparing uio with hdX is wrong as hdX means something, it is a block
> > device for a disk. 
> > A better comparison would be if all kernel devices were named kio%d and
> > you had to scan /sys to find the name hdX.
> 
> UIO drivers certainly aren't first class citizens like kernel mode
> drivers.  They just aren't.
> 
> > 
> > Look at the spi subsystem, the protocol drivers name them self.
> 
> UIO is an interface type, not a bus type.  UIO isn't a subsystem as
> such, it's a user interface.  If the interface is consistent (even if
> the backing device is different) I don't see the problem with consistent
> naming.

Do you see a problem with letting the protocol driver choose another
one? Why not offer the user the chance to let the name mean something?

> 
> Anyway, I don't really see the point arguing here - the interface is
> what it is, it does everything it needs to to allow you to identify the
> device nodes.  The kernel boys have spent a lot of effort over time
> letting userspace identify and name device nodes and I don't really see
> the difference here :-)

The changes needed to make it possible to select a different name are
really minimal(include below for 2.6.25). So I ask again, why not let
the driver choose?

>From e58037d887c0432fa16bbb1e9e02b390b11cc758 Mon Sep 17 00:00:00 2001
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Date: Thu, 25 Sep 2008 13:22:53 +0200
Subject: [PATCH] [UIO] Let UIO protocol drivers name them self.

Currently all UIO based drivers will be named "uio%d"
in user space. Make it possible for protocol drivers
to use a different name.
---
 drivers/uio/uio.c          |    4 +++-
 include/linux/uio_driver.h |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 1175908..950233f 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -642,10 +642,12 @@ int __uio_register_device(struct module *owner,
 	ret = uio_get_minor(idev);
 	if (ret)
 		goto err_get_minor;
+	if (!info->bus_name)
+		info->bus_name = "uio%d";
 
 	idev->dev = device_create(uio_class->class, parent,
 				  MKDEV(uio_major, idev->minor),
-				  "uio%d", idev->minor);
+				  info->bus_name, idev->minor);
 	if (IS_ERR(idev->dev)) {
 		printk(KERN_ERR "UIO: device register failed\n");
 		ret = PTR_ERR(idev->dev);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 973386d..c55146a 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -44,6 +44,7 @@ struct uio_device;
  * struct uio_info - UIO device capabilities
  * @uio_dev:		the UIO device this info belongs to
  * @name:		device name
+ * @bus_name:		bus name
  * @version:		device driver version
  * @mem:		list of mappable memory regions, size==0 for end of list
  * @irq:		interrupt number or UIO_IRQ_CUSTOM
@@ -57,6 +58,7 @@ struct uio_device;
 struct uio_info {
 	struct uio_device	*uio_dev;
 	char			*name;
+	char			*bus_name;
 	char			*version;
 	struct uio_mem		mem[MAX_UIO_MAPS];
 	long			irq;
-- 
1.5.6.5


