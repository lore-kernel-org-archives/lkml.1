Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbXJYJIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbXJYJIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 05:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbXJYJIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 05:08:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:57444 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbXJYJIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 05:08:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=OrEbE+3oTJOnQwOcIDNcIZTZlkbZcSe5ISEJWoJfJX51cYQ/4NBbCo4J4PvM8RAOtRdL5H/POfQttTwlg2iUyoO6e7YXe8SCDzcIxanb8Ayig9ySqAPykAyrk5MjmHm/gXFTv5g5j7nGPyF0UhEAckXMp4M9rSKHI0rCewHepjU=
Date: Thu, 25 Oct 2007 17:06:59 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, bbpetkov@yahoo.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename 'bInterfaceNumber'
Message-ID: <20071025090659.GA2847@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/07, Greg KH <greg@kroah.com> wrote:
>On Wed, Oct 17, 2007 at 10:48:52AM -0400, Alan Stern wrote:
>> On Tue, 16 Oct 2007, Matthew Dharm wrote:
>>
>> > On Tue, Oct 16, 2007 at 02:04:43PM -0400, Alan Stern wrote:
>> > > On Tue, 16 Oct 2007, Matthew Dharm wrote:
>> > >
>> > > > I haven't looked at this code at all, but neither approach feels
>> > > > right to
>> > > > me.
>> > > >
>> > > > How does this work at all?  Even if you load a driver later,
>> > > > wouldn't it
>> > > > call usb_set_interface(), which would call
>> > > > usb_create_sysfs_intf_files()
>> > > > and hit the same issue?
>> > >
>> > > usb_set_interface() is smart enough to remove the old interface
>> > > files
>> > > before creating new ones, since it expects them to exist already.
>> > > Hence there's no problem in that scenario.
>> > >
>> > > But usb_set_configuration doesn't expect there to be any
>> > > pre-existing
>> > > interface files, because there isn't even an interface until the
>> > > registration is performed.
>> >
>> > And I'm guessing that you can't call usb_create_sysfs_intf_files()
>> > until
>> > registration is performed, right?
>>
>> Right.
>>
>> > > The most important reason has to do with the endpoint
>> > > pseudo-devices.
>> > > Different altsettings can have different endpoints, so those have
>> > > to be
>> > > removed and re-created whenever the altsetting changes.
>> >
>> > Right, altsettings.  I forgot about those.  I only ever think in
>> > terms of
>> > multiple configurations.
>> >
>> > *grumble*
>> >
>> > If usb_set_interface() has to be smart enough to remove existing
>> > files
>> > first already, then I guess it's reasonably symmetric to have
>> > usb_set_configuration() have the same smarts.  Maybe they can share
>> > some
>> > common code, even.
>>
>> It's not a big deal to remove the files first.  In fact, here's a
>> patch
>> to do it.  Dave, see if this doesn't fix your problem.  I don't like
>> it
>> much because it does an unnecessary remove/create cycle, but that's
>> better than doing something wrong.
>>
>> It's slightly odd that the sysfs core logs an error when you try to
>> create the same file twice but it doesn't when you try to remove a
>> non-existent file (or try to remove an existing file twice).  Oh
>> well...
>
>I used to have the 'remove a non-existant file' warning, but that just
>triggered _way_ too many responses :)
>
>
>> Index: usb-2.6/drivers/usb/core/message.c
>> ===================================================================
>> --- usb-2.6.orig/drivers/usb/core/message.c
>> +++ usb-2.6/drivers/usb/core/message.c
>> @@ -1643,7 +1643,13 @@ free_interfaces:
>>                               intf->dev.bus_id, ret);
>>                       continue;
>>               }
>> -             usb_create_sysfs_intf_files (intf);
>> +
>> +             /* The driver's probe method can call
>> usb_set_interface(),
>> +              * which would mean the interface's sysfs files are
>> already
>> +              * created.  Just in case, we'll remove them first.
>> +              */
>> +             usb_remove_sysfs_intf_files(intf);
>> +             usb_create_sysfs_intf_files(intf);
>>       }
>
>If this fixes the problem, care to resend it with a signed-off-by:?
>
>Yeah, it's not the nicest solution, but I can't think of any other one
>either right now :(
Hi, greg

How about this patch (based on 2.6.24-rc1):

diff -upr linux/drivers/usb/core/message.c linux.new/drivers/usb/core/message.c
--- linux/drivers/usb/core/message.c	2007-10-25 16:41:32.000000000 +0800
+++ linux.new/drivers/usb/core/message.c	2007-10-25 16:39:38.000000000 +0800
@@ -1641,7 +1641,8 @@ free_interfaces:
 				intf->dev.bus_id, ret);
 			continue;
 		}
-		usb_create_sysfs_intf_files (intf);
+		if(!usb_sysfs_intf_exist(intf))
+			usb_create_sysfs_intf_files (intf);
 	}
 
 	usb_autosuspend_device(dev);
diff -upr linux/drivers/usb/core/sysfs.c linux.new/drivers/usb/core/sysfs.c
--- linux/drivers/usb/core/sysfs.c	2007-10-25 16:40:16.000000000 +0800
+++ linux.new/drivers/usb/core/sysfs.c	2007-10-25 16:39:32.000000000 +0800
@@ -728,6 +728,13 @@ static inline void usb_remove_intf_ep_fi
 		usb_remove_ep_files(&iface_desc->endpoint[i]);
 }
 
+int usb_sysfs_intf_exist(struct usb_interface *intf)
+{
+	struct device *dev = &intf->dev;
+	
+	return sysfs_dirent_exist(&dev->kobj, intf_attrs[0]->name);
+}
+
 int usb_create_sysfs_intf_files(struct usb_interface *intf)
 {
 	struct device *dev = &intf->dev;
diff -upr linux/drivers/usb/core/usb.h linux.new/drivers/usb/core/usb.h
--- linux/drivers/usb/core/usb.h	2007-10-25 16:41:02.000000000 +0800
+++ linux.new/drivers/usb/core/usb.h	2007-10-25 16:39:19.000000000 +0800
@@ -1,5 +1,6 @@
 /* Functions local to drivers/usb/core/ */
 
+extern int usb_sysfs_intf_exist(struct usb_interface *intf);
 extern int usb_create_sysfs_dev_files (struct usb_device *dev);
 extern void usb_remove_sysfs_dev_files (struct usb_device *dev);
 extern int usb_create_sysfs_intf_files (struct usb_interface *intf);
diff -upr linux/fs/sysfs/dir.c linux.new/fs/sysfs/dir.c
--- linux/fs/sysfs/dir.c	2007-10-25 16:40:43.000000000 +0800
+++ linux.new/fs/sysfs/dir.c	2007-10-25 16:39:00.000000000 +0800
@@ -583,6 +583,16 @@ struct sysfs_dirent *sysfs_find_dirent(s
 	return NULL;
 }
 
+int sysfs_dirent_exist(struct kobject *kobj, const unsigned char *name)
+{
+	struct sysfs_dirent *sd = kobj->sd;
+	
+	if (sysfs_find_dirent(sd, name))
+		return 1;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_dirent_exist);
+
 /**
  *	sysfs_get_dirent - find and get sysfs_dirent with the given name
  *	@parent_sd: sysfs_dirent to search under
diff -upr linux/inclue/linux/sysfs.h linux.new/inclue/linux/sysfs.h
--- linux/inclue/linux/sysfs.h	2007-10-25 16:40:02.000000000 +0800
+++ linux.new/inclue/linux/sysfs.h	2007-10-25 16:38:40.000000000 +0800
@@ -112,6 +112,8 @@ void sysfs_remove_file_from_group(struct
 
 void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
 
+int sysfs_dirent_exist(struct kobject *kobj, const unsigned char *name);
+
 extern int __must_check sysfs_init(void);
 
 #else /* CONFIG_SYSFS */
@@ -211,6 +213,11 @@ static inline void sysfs_notify(struct k
 {
 }
 
+static int sysfs_dirent_exist(struct kobject *kobj, const unsigned char *name)
+{
+	return 0;
+}
+
 static inline int __must_check sysfs_init(void)
 {
 	return 0;
