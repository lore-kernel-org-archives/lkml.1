Return-Path: <linux-kernel-owner+w=401wt.eu-S1765350AbYBZUMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765350AbYBZUMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765057AbYBZUMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:12:07 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34164 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764958AbYBZUME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:12:04 -0500
Date: Tue, 26 Feb 2008 12:16:19 -0800
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PCI] duplicate sysfs symbols getting registered in current git
Message-ID: <20080226201619.GA10343@kroah.com>
References: <Pine.LNX.4.64.0802182142240.11540@axis700.grange> <20080220063834.GA22708@kroah.com> <Pine.LNX.4.64.0802251341160.4430@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802251341160.4430@axis700.grange>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 01:43:29PM +0100, Guennadi Liakhovetski wrote:
> On Tue, 19 Feb 2008, Greg KH wrote:
> 
> > On Mon, Feb 18, 2008 at 09:52:25PM +0100, Guennadi Liakhovetski wrote:
> > > Booting an x86 SMP PC with todays git-snapshot or just with 2.6.25-rc2 
> > > getting the following warnings (with a bit of context):
> > 
> > Can you try enabling CONFIG_DEBUG_KOBJECT and sending the output at boot
> > time from this?
> 
> dmesg output with CONFIG_LOG_BUF_SHIFT=19 sent privately to Greg as 
> unpacked, as it would have to be sent to the list, is 408K big. Will see 
> what Greg says.

Thanks for the log, it helped out a lot.  I'm thinking that you have
CONFIG_SYSFS_DEPRECATED set to Y, right?  If so, can you set it to N
(hopefully you have a new userspace to handle that)?

I think we're trying to add a file with the same name as the device
object for the pci bus, which is wierd, because the namespace issues
should keep this from happening.

That being said, this warning really scares me:

kobject (c7c35900): tried to init an initialized object, something is seriously wrong.
Pid: 1, comm: swapper Not tainted 2.6.25-rc2-testpm #30
 [<c01ea0e9>] kobject_init+0x89/0x90
 [<c025094e>] device_initialize+0x1e/0x90
 [<c025119b>] device_register+0xb/0x20
 [<c01f3fd8>] pci_bus_add_devices+0x98/0x140
 [<c030aff7>] ? pcibios_scan_root+0x27/0xa0
 [<c03f69d0>] pci_legacy_init+0x50/0xf0
 [<c03db5c2>] kernel_init+0x132/0x310
 [<c010303a>] ? ret_from_fork+0x6/0x1c
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c03db490>] ? kernel_init+0x0/0x310
 [<c0103d3f>] kernel_thread_helper+0x7/0x18
 =======================

We did just find a problem in the kobject core that might be causing
this to happen, can you try the patch below to see if this causes it to
go away as well?

thanks,

greg k-h

------------------
From: Greg Kroah-Hartman <gregkh@suse.de>
Subject: kobject: properly initialize ksets

kset_initialize was calling kobject_init_internal() which didn't
initialize the kobject as well as kobject_init() was.  So have
kobject_init() call kobject_init_internal() and move the logic to
initalize the kobject there.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/kobject.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -153,6 +153,10 @@ static void kobject_init_internal(struct
 		return;
 	kref_init(&kobj->kref);
 	INIT_LIST_HEAD(&kobj->entry);
+	kobj->state_in_sysfs = 0;
+	kobj->state_add_uevent_sent = 0;
+	kobj->state_remove_uevent_sent = 0;
+	kobj->state_initialized = 1;
 }
 
 
@@ -289,13 +293,8 @@ void kobject_init(struct kobject *kobj, 
 		dump_stack();
 	}
 
-	kref_init(&kobj->kref);
-	INIT_LIST_HEAD(&kobj->entry);
+	kobject_init_internal(kobj);
 	kobj->ktype = ktype;
-	kobj->state_in_sysfs = 0;
-	kobj->state_add_uevent_sent = 0;
-	kobj->state_remove_uevent_sent = 0;
-	kobj->state_initialized = 1;
 	return;
 
 error:
