Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbYELCFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbYELCFW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 22:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbYELCFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 22:05:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:4326 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbYELCFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 22:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mois2kC0SXq+7FLb4idQufyMJrKGAAMakfPZCBuZ+b9KTPCojGdIulrBIhW3ak2W7fJoCxT6XYZVcsJn9MtPrA1BXjM9u7T6mG5BlhyH4aswN32Fx1wrnobCKdZ5rovJMRIeW7WEl/zlkQ4w3lhbhUchQIqDA+cMHvCQsBB6zSA=
Message-ID: <a8e1da0805111905y49239cb7ja13f8e1c685bf6a9@mail.gmail.com>
Date: Mon, 12 May 2008 10:05:00 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: 2.6.26-rc1: warnings from sysfs, bluetooth related
Cc: "kernel list" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       marcel@holtmann.org, linux-bluetooth@vger.kernel.org
In-Reply-To: <20080511161930.GA2179@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080511161930.GA2179@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 12:19 AM, Pavel Machek <pavel@suse.cz> wrote:
>
> Hi!
>
> I'm getting these from rfcomm...


Are you sure it's a regression?

Dont know if it's same bug as BUG 10341.  I just describe the problem
in bug 10341:

While a rfcomm device is opened more than once, the BUG 10341 can be triggered.

rfcomm dev reference will be held for every rfcomm_tty_open, but release_dev
 will hangup the tty and release the dev number for free use without
judge the dev->opened.

rfcomm_dev_state_change and rfcomm_tty_hangup could del the rfcomm dev
as well,  the problem is similar as above.

If the create_dev called before the last tty_close,  sysfs will
warning and create will fail.

I have a patch which don't hold the dev reference in rfcomm_tty_open,
but it need some review and test.

please see:
http://bugzilla.kernel.org/attachment.cgi?id=15746

Marcel, do you have idea about this? or other solution?

>
>                                                                Pavel
>
>  host4: resumed
> scsi 4:0:0:0: Direct-Access     OLYMPUS  C765UZ           1.00 PQ: 0 ANSI: 2
> sd 4:0:0:0: [sdb] 32000 512-byte hardware sectors (16 MB)
> sd 4:0:0:0: [sdb] Write Protect is off
> sd 4:0:0:0: [sdb] Mode Sense: 18 00 00 08
> sd 4:0:0:0: [sdb] Assuming drive cache: write through
> sd 4:0:0:0: [sdb] 32000 512-byte hardware sectors (16 MB)
> sd 4:0:0:0: [sdb] Write Protect is off
> sd 4:0:0:0: [sdb] Mode Sense: 18 00 00 08
> sd 4:0:0:0: [sdb] Assuming drive cache: write through
>  sdb: sdb1
> sd 4:0:0:0: [sdb] Attached SCSI removable disk
> sd 4:0:0:0: Attached scsi generic sg1 type 0
> usb-storage: device scan complete
> hci_cmd_task: hci0 command tx timeout
> usb 5-1: USB disconnect, address 2
> btusb_bulk_complete: hci0 urb f6191550 failed to resubmit (19)
> btusb_bulk_complete: hci0 urb f6879090 failed to resubmit (19)
> btusb_send_frame: hci0 urb f6879090 submission failed
> hub 1-0:1.0: unable to enumerate USB device on port 7
> usb 5-1: new full speed USB device using uhci_hcd and address 4
> usb 5-1: configuration #1 chosen from 1 choice
> usb 5-1: New USB device found, idVendor=0a5c, idProduct=2110
> usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 5-1: Product: BCM2045B
> usb 5-1: Manufacturer: Broadcom Corp
> sysfs: duplicate filename 'rfcomm0' can not be created
> ------------[ cut here ]------------
> WARNING: at /data/l/linux/fs/sysfs/dir.c:425 sysfs_add_one+0x85/0xa0()
> Modules linked in:
> Pid: 2011, comm: rfcomm Tainted: G        W 2.6.26-rc1 #289
>  [<c022a2af>] warn_on_slowpath+0x5f/0x90
>  [<c021c9e8>] __wake_up_common+0x48/0x70
>  [<c02203e8>] __wake_up+0x38/0x50
>  [<c022aa8b>] wake_up_klogd+0x3b/0x40
>  [<c038510b>] ida_get_new_above+0x7b/0x180
>  [<c02bd400>] sysfs_ilookup_test+0x0/0x10
>  [<c0751214>] _spin_unlock+0x14/0x20
>  [<c029037f>] ifind+0x8f/0xa0
>  [<c022b23b>] printk+0x1b/0x20
>  [<c02bd775>] sysfs_add_one+0x85/0xa0
>  [<c02bdcc8>] create_dir+0x48/0x90
>  [<c02bdd39>] sysfs_create_dir+0x29/0x50
>  [<c0751214>] _spin_unlock+0x14/0x20
>  [<c0385d66>] kobject_add_internal+0xb6/0x190
>  [<c0385eb9>] kobject_set_name_vargs+0x29/0x50
>  [<c0386201>] kobject_add+0x31/0x60
>  [<c0385c2f>] kobject_get+0xf/0x20
>  [<c04235ef>] device_add+0x9f/0x500
>  [<c042326e>] device_initialize+0xce/0xf0
>  [<c0423aeb>] device_create+0x8b/0xc0
>  [<c03e6219>] tty_register_device+0x69/0xf0
>  [<c038a2a4>] vsnprintf+0x544/0x600
>  [<c038e982>] __spin_lock_init+0x32/0x60
>  [<c07512d9>] _spin_lock+0x29/0x40
>  [<c06e20ea>] rfcomm_dev_ioctl+0x53a/0x690
>  [<c06e01be>] rfcomm_sock_ioctl+0x1e/0x50
>  [<c06e01c9>] rfcomm_sock_ioctl+0x29/0x50
>  [<c0625e16>] sock_ioctl+0xb6/0x1d0
>  [<c0625d60>] sock_ioctl+0x0/0x1d0
>  [<c0288e8b>] vfs_ioctl+0x2b/0x90
>  [<c0288f4c>] do_vfs_ioctl+0x5c/0x2a0
>  [<c02891cd>] sys_ioctl+0x3d/0x70
>  [<c0203c2a>] syscall_call+0x7/0xb
>  =======================
> ---[ end trace a0614c8bfea95988 ]---
> kobject_add_internal failed for rfcomm0 with -EEXIST, don't try to register things with the same name in the same directory.
> Pid: 2011, comm: rfcomm Tainted: G        W 2.6.26-rc1 #289
>  [<c0385de7>] kobject_add_internal+0x137/0x190
>  [<c0386201>] kobject_add+0x31/0x60
>  [<c0385c2f>] kobject_get+0xf/0x20
>  [<c04235ef>] device_add+0x9f/0x500
>  [<c042326e>] device_initialize+0xce/0xf0
>  [<c0423aeb>] device_create+0x8b/0xc0
>  [<c03e6219>] tty_register_device+0x69/0xf0
>  [<c038a2a4>] vsnprintf+0x544/0x600
>  [<c038e982>] __spin_lock_init+0x32/0x60
>  [<c07512d9>] _spin_lock+0x29/0x40
>  [<c06e20ea>] rfcomm_dev_ioctl+0x53a/0x690
>  [<c06e01be>] rfcomm_sock_ioctl+0x1e/0x50
>  [<c06e01c9>] rfcomm_sock_ioctl+0x29/0x50
>  [<c0625e16>] sock_ioctl+0xb6/0x1d0
>  [<c0625d60>] sock_ioctl+0x0/0x1d0
>  [<c0288e8b>] vfs_ioctl+0x2b/0x90
>  [<c0288f4c>] do_vfs_ioctl+0x5c/0x2a0
>  [<c02891cd>] sys_ioctl+0x3d/0x70
>  [<c0203c2a>] syscall_call+0x7/0xb
>  =======================
> sysfs: duplicate filename 'rfcomm0' can not be created
> ------------[ cut here ]------------
> WARNING: at /data/l/linux/fs/sysfs/dir.c:425 sysfs_add_one+0x85/0xa0()
> Modules linked in:
> Pid: 2104, comm: rfcomm Tainted: G        W 2.6.26-rc1 #289
>  [<c022a2af>] warn_on_slowpath+0x5f/0x90
>  [<c021c9e8>] __wake_up_common+0x48/0x70
>  [<c02203e8>] __wake_up+0x38/0x50
>  [<c022aa8b>] wake_up_klogd+0x3b/0x40
>  [<c038510b>] ida_get_new_above+0x7b/0x180
>  [<c02bd400>] sysfs_ilookup_test+0x0/0x10
>  [<c0751214>] _spin_unlock+0x14/0x20
>  [<c029037f>] ifind+0x8f/0xa0
>  [<c022b23b>] printk+0x1b/0x20
>  [<c02bd775>] sysfs_add_one+0x85/0xa0
>  [<c02bdcc8>] create_dir+0x48/0x90
>  [<c02bdd39>] sysfs_create_dir+0x29/0x50
>  [<c0751214>] _spin_unlock+0x14/0x20
>  [<c0385d66>] kobject_add_internal+0xb6/0x190
>  [<c0385eb9>] kobject_set_name_vargs+0x29/0x50
>  [<c0386201>] kobject_add+0x31/0x60
>  [<c0385c2f>] kobject_get+0xf/0x20
>  [<c04235ef>] device_add+0x9f/0x500
>  [<c042326e>] device_initialize+0xce/0xf0
>  [<c0423aeb>] device_create+0x8b/0xc0
>  [<c03e6219>] tty_register_device+0x69/0xf0
>  [<c038a2a4>] vsnprintf+0x544/0x600
>  [<c038e982>] __spin_lock_init+0x32/0x60
>  [<c07512d9>] _spin_lock+0x29/0x40
>  [<c06e20ea>] rfcomm_dev_ioctl+0x53a/0x690
>  [<c06e01be>] rfcomm_sock_ioctl+0x1e/0x50
>  [<c06e01c9>] rfcomm_sock_ioctl+0x29/0x50
>  [<c0625e16>] sock_ioctl+0xb6/0x1d0
>  [<c0625d60>] sock_ioctl+0x0/0x1d0
>  [<c0288e8b>] vfs_ioctl+0x2b/0x90
>  [<c0288f4c>] do_vfs_ioctl+0x5c/0x2a0
>  [<c02891cd>] sys_ioctl+0x3d/0x70
>  [<c0203c2a>] syscall_call+0x7/0xb
>  =======================
> ---[ end trace a0614c8bfea95988 ]---
> kobject_add_internal failed for rfcomm0 with -EEXIST, don't try to register things with the same name in the same directory.
> Pid: 2104, comm: rfcomm Tainted: G        W 2.6.26-rc1 #289
>  [<c0385de7>] kobject_add_internal+0x137/0x190
>  [<c0386201>] kobject_add+0x31/0x60
>  [<c0385c2f>] kobject_get+0xf/0x20
>  [<c04235ef>] device_add+0x9f/0x500
>  [<c042326e>] device_initialize+0xce/0xf0
>  [<c0423aeb>] device_create+0x8b/0xc0
>  [<c03e6219>] tty_register_device+0x69/0xf0
>  [<c038a2a4>] vsnprintf+0x544/0x600
>  [<c038e982>] __spin_lock_init+0x32/0x60
>  [<c07512d9>] _spin_lock+0x29/0x40
>  [<c06e20ea>] rfcomm_dev_ioctl+0x53a/0x690
>  [<c06e01be>] rfcomm_sock_ioctl+0x1e/0x50
>  [<c06e01c9>] rfcomm_sock_ioctl+0x29/0x50
>  [<c0625e16>] sock_ioctl+0xb6/0x1d0
>  [<c0625d60>] sock_ioctl+0x0/0x1d0
>  [<c0288e8b>] vfs_ioctl+0x2b/0x90
>  [<c0288f4c>] do_vfs_ioctl+0x5c/0x2a0
>  [<c02891cd>] sys_ioctl+0x3d/0x70
>  [<c0203c2a>] syscall_call+0x7/0xb
>  =======================
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-bluetooth" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
