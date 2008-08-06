Return-Path: <linux-kernel-owner+w=401wt.eu-S1760830AbYHFUkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760830AbYHFUkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbYHFUkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:40:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53867 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753303AbYHFUkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:40:03 -0400
Date: Wed, 6 Aug 2008 16:40:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
cc: Antonio Ospite <ospite@studenti.unina.it>
Subject: BUG in VFS or block layer
Message-ID: <Pine.LNX.4.44L0.0808061628280.2145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug is certainly present in 2.6.27-rc2, and it may be present in
several earlier kernel versions too, perhaps as far back as 2.6.25.
What happens is that in the presence of certain I/O errors, user
processes can hang.  Here is a procedure for recreating the bug:

Make sure that CONFIG_USB_GADGET and CONFIG_USB_GADGET_DUMMY_HCD are
enabled as modules, as well as CONFIG_USB_FILE_STORAGE.  Apply the
patch below and build the drivers.  Then create a blank image file with
1 MB of zeros and load the drivers:

	dd if=/dev/zero of=image bs=1M count=1
	modprobe dummy-hcd
	modprobe g-file-storage file=image

The patch causes a number of sector-read errors to occur, replicating 
those in the log attached to 

	http://marc.info/?l=linux-usb&m=121802760208717&w=2

On my system this leads hald-probe-storage to hang during exit with the
following stack trace:

[   85.330010] hald-probe-st D e6d17cac     0  2031   1658
[   85.330174]        e6d17cd0 00000046 00000000 e6d17cac ee78d160 e6d83a20 e6d83b74 00000000 
[   85.330600]        efb76940 e6d17cb8 c04c447b c17e2024 e6d17cc0 c04c2f0b e6d17cc8 c19d1180 
[   85.331066]        c17e2024 c19c8210 e6d17cdc c059c67d e707da48 e6d17cec c0447f64 e6d17d10 
[   85.331534] Call Trace:
[   85.331693]  [<c04c447b>] ? generic_unplug_device+0x16/0x3a
[   85.331860]  [<c04c2f0b>] ? blk_unplug+0xc/0xe
[   85.332023]  [<c059c67d>] io_schedule+0x1e/0x28
[   85.332149]  [<c0447f64>] sync_page+0x46/0x4c
[   85.332276]  [<c059c8c1>] __wait_on_bit_lock+0x30/0x59
[   85.332403]  [<c0447f1e>] ? sync_page+0x0/0x4c
[   85.332566]  [<c0447ee0>] __lock_page+0x4e/0x56
[   85.332692]  [<c042d957>] ? wake_bit_function+0x0/0x43
[   85.332858]  [<c044f0b9>] lock_page+0x27/0x2a
[   85.332985]  [<c044f6b4>] truncate_inode_pages_range+0x218/0x27a
[   85.333117]  [<c0438485>] ? trace_hardirqs_on_caller+0xe1/0x102
[   85.333283]  [<c04384b1>] ? trace_hardirqs_on+0xb/0xd
[   85.333448]  [<c044f722>] truncate_inode_pages+0xc/0x12
[   85.333576]  [<c048590b>] kill_bdev+0x2c/0x2f
[   85.333704]  [<c0485e51>] __blkdev_put+0x4c/0x12b
[   85.333830]  [<c0473747>] ? d_free+0x25/0x37
[   85.333992]  [<c0485f3a>] blkdev_put+0xa/0xc
[   85.334117]  [<c04865a7>] blkdev_close+0x25/0x28
[   85.334243]  [<c04667a3>] __fput+0xae/0x13c
[   85.334368]  [<c0466848>] fput+0x17/0x19
[   85.334492]  [<c04644b8>] filp_close+0x50/0x5a
[   85.334618]  [<c041ee6d>] put_files_struct+0x68/0xaa
[   85.334746]  [<c041eedd>] exit_files+0x2e/0x32
[   85.334871]  [<c041fe4e>] do_exit+0x1df/0x64a
[   85.334997]  [<c04257a4>] ? set_tsk_thread_flag+0xb/0xd
[   85.335162]  [<c04384b1>] ? trace_hardirqs_on+0xb/0xd
[   85.335326]  [<c042033a>] sys_exit_group+0x0/0x11
[   85.335453]  [<c04276e9>] get_signal_to_deliver+0x2ee/0x32d
[   85.335582]  [<c040260e>] do_notify_resume+0x6b/0x5ff
[   85.335711]  [<c04384b1>] ? trace_hardirqs_on+0xb/0xd
[   85.335875]  [<c059cf5c>] ? __mutex_unlock_slowpath+0xf4/0x103
[   85.336042]  [<c059cf73>] ? mutex_unlock+0x8/0xa
[   85.336204]  [<c04858d1>] ? block_llseek+0x94/0xa2
[   85.336368]  [<c0466220>] ? vfs_read+0x78/0xa8
[   85.336531]  [<c0465aa1>] ? do_sync_read+0x0/0xe9
[   85.336694]  [<c0466479>] ? sys_read+0x53/0x5d
[   85.336857]  [<c04030f6>] work_notifysig+0x13/0x19
[   85.336984]  =======================

I don't know enough about the VFS or block layers to track this down 
any further.

Alan Stern


Index: usb-2.6/drivers/usb/gadget/file_storage.c
===================================================================
--- usb-2.6.orig/drivers/usb/gadget/file_storage.c
+++ usb-2.6/drivers/usb/gadget/file_storage.c
@@ -1569,6 +1569,11 @@ static int do_read(struct fsg_dev *fsg)
 	}
 	file_offset = ((loff_t) lba) << 9;
 
+	if (lba >= 100) {
+		curlun->sense_data = 0x030000;
+		return -EINVAL;
+	}
+
 	/* Carry out the file reads */
 	amount_left = fsg->data_size_from_cmnd;
 	if (unlikely(amount_left == 0))

