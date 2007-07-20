Return-Path: <linux-kernel-owner+w=401wt.eu-S935397AbXGTIBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935397AbXGTIBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760468AbXGTIBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:01:36 -0400
Received: from mail.suse.de ([195.135.220.2]:45573 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490AbXGTIBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:01:36 -0400
Date: Fri, 20 Jul 2007 01:00:59 -0700
From: Greg KH <gregkh@suse.de>
To: Gabriel C <nix.or.die@googlemail.com>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kay.sievers@vrfy.org
Subject: Re: kobject link failure
Message-ID: <20070720080059.GA29639@suse.de>
References: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr> <469FA94E.20002@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469FA94E.20002@googlemail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 08:11:26PM +0200, Gabriel C wrote:
> Jan Engelhardt wrote:
> > Hi,
> >
> >
> > top is 275afcac9953ece0828972edeab9684cfe1a5ef3, error is:
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `store_uevent':
> > core.c:(.text+0x20ebb): undefined reference to `kobject_actions'
> > core.c:(.text+0x20edd): undefined reference to `kobject_actions'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> > make: *** [_all] Error 2
> >
> > .config attached. Is it because of CONFIG_HOTPLUG=n?
> >   

Can any of you try the following patch and let me know if it fixes the
issue or not?

Kay, it's an ugly fix, any better thoughts?

thanks,

greg k-h

From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: fix build error when CONFIG_HOTPLUG is disabled for kobject_actions

---
 drivers/base/core.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -250,6 +250,7 @@ static struct kset_uevent_ops device_uev
 	.uevent =	dev_uevent,
 };
 
+#ifdef CONFIG_HOTPLUG
 static ssize_t show_uevent(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
@@ -330,6 +331,23 @@ out:
 static struct device_attribute uevent_attr =
 	__ATTR(uevent, S_IRUGO | S_IWUSR, show_uevent, store_uevent);
 
+static int device_add_uevent_attr(struct device *dev)
+{
+	return device_create_file(dev, &uevent_attr);
+}
+
+static void device_remove_uevent_attr(struct device *dev)
+{
+	device_remove_file(dev, &uevent_attr);
+}
+
+#else	/* CONFIG_HOTPLUG */
+
+static inline int device_add_uevent_attr(struct device *dev) { return 0; }
+static inline void device_remove_uevent_attr(struct device *dev) { }
+
+#endif	/* CONFIG_HOTPLUG */
+
 static int device_add_attributes(struct device *dev,
 				 struct device_attribute *attrs)
 {
@@ -787,7 +805,7 @@ int device_add(struct device *dev)
 		blocking_notifier_call_chain(&dev->bus->bus_notifier,
 					     BUS_NOTIFY_ADD_DEVICE, dev);
 
-	error = device_create_file(dev, &uevent_attr);
+	error = device_add_uevent_attr(dev);
 	if (error)
 		goto attrError;
 
@@ -861,7 +879,7 @@ int device_add(struct device *dev)
 		}
 	}
  ueventattrError:
-	device_remove_file(dev, &uevent_attr);
+	device_remove_uevent_attr(dev);
  attrError:
 	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	kobject_del(&dev->kobj);
@@ -994,7 +1012,7 @@ void device_del(struct device * dev)
 			up(&dev->class->sem);
 		}
 	}
-	device_remove_file(dev, &uevent_attr);
+	device_remove_uevent_attr(dev);
 	device_remove_attrs(dev);
 	bus_remove_device(dev);
 
