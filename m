Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZBOVU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZBOVU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZBOVUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:20:50 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:53021 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697AbZBOVUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:20:49 -0500
Date: Sun, 15 Feb 2009 22:20:45 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: linux-kernel@vger.kernel.org
Subject: unusual hw_sector_size 4096 and pagecache
Message-ID: <20090215212045.GA13938@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm fiddling with a custom nbd server and I wanted to use 4K (page
sized) 'hw sectors', so I added a new ioctl to nbd, which
calls blk_queue_hardsect_size() to change the hw_sector_size (see
patch at end of this mail).

I tested this with sector sizes 512, 1024, 2048 and 4096 and found
that all expect 4096 work just fine.

4096 mostly works except for one thing:

| mke2fs /dev/nbd0
| mount /dev/nbd0 /mnt/mnt
| cd /mnt/mnt
| tar xjf /root/linux-2.6.23.tar.bz2
| cd
| umount /mnt/mnt
| e2fsck -n -f /dev/nbd0

fails the e2fsck.
However inserting either
 'echo 3 > /proc/sys/vm/drop_caches'
or
 'blockdev --flushbufs /dev/nbd0'
before the e2fsck makes it find a clean filesystem image.

I assume no one ever tried 4096 bytes sized sectors before, but
I'll still ask:

Is this expected behaviour?

Also, I eventually got a got a BUG(), which might be related.

[12338.180010] nbd0: queue cleared
[12525.860006] ------------[ cut here ]------------
[12525.860006] kernel BUG at fs/buffer.c:2992!
[12525.860006] invalid opcode: 0000 [#1] 
[12525.860006] last sysfs file: /sys/block/nbd15/removable
[12525.860006] Modules linked in: nbd radeon pcmcia snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm libipw psmouse yenta_socket rsrc_nonstatic pcmcia_core snd_timer snd_page_alloc ehci_hcd tg3 libphy uhci_hcd parport_pc parport thinkpad_acpi [last unloaded: ipw2200]
[12525.860006] 
[12525.860006] Pid: 3613, comm: tar Tainted: G        W  (2.6.29-rc3 #28) 1847W62
[12525.860006] EIP: 0060:[<c017aa8e>] EFLAGS: 00010246 CPU: 0
[12525.860006] EIP is at submit_bh+0x18/0xe6
[12525.860006] EAX: 00000005 EBX: db144358 ECX: 00000015 EDX: db144358
[12525.860006] ESI: e0e00800 EDI: 00000009 EBP: c84fbb88 ESP: c84fbb7c
[12525.860006]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[12525.860006] Process tar (pid: 3613, ti=c84fb000 task=f71d43c0 task.ti=c84fb000)
[12525.860006] Stack:
[12525.860006]  db144358 e0e00800 d0d60000 c84fbb98 c017be01 efc3a400 e0e00800 c84fbba8
[12525.860006]  c01d6430 c3f420e0 e0e00800 c84fbbb8 c01d6b58 c3f420e0 0003807c c84fbbec
[12525.860006]  c01d19f1 e0e00800 c04182f4 c04a33f2 00000007 0003807c 00000007 e0e00800
[12525.860006] Call Trace:
[12525.860006]  [<c017be01>] ? sync_dirty_buffer+0x5b/0xac
[12525.860006]  [<c01d6430>] ? ext2_sync_super+0x3f/0x47
[12525.860006]  [<c01d6b58>] ? ext2_error+0x33/0x91
[12525.860006]  [<c01d19f1>] ? read_block_bitmap+0x113/0x121
[12525.860006]  [<c01d229e>] ? ext2_new_blocks+0x1bd/0x47f
[12525.860006]  [<c01d52ce>] ? ext2_get_block+0x294/0x5a2
[12525.860006]  [<c014b75b>] ? get_page_from_freelist+0xa5/0x375
[12525.860006]  [<c017ae5b>] ? alloc_page_buffers+0x67/0xb2
[12525.860006]  [<c017c43d>] ? __block_prepare_write+0x14a/0x329
[12525.860006]  [<c017c76b>] ? block_write_begin+0x75/0xcb
[12525.860006]  [<c01d503a>] ? ext2_get_block+0x0/0x5a2
[12525.860006]  [<c01d501d>] ? ext2_write_begin+0x26/0x28
[12525.860006]  [<c01d503a>] ? ext2_get_block+0x0/0x5a2
[12525.860006]  [<c014813e>] ? generic_file_buffered_write+0xc8/0x233
[12525.860006]  [<c01487e1>] ? __generic_file_aio_write_nolock+0x3a0/0x3d7
[12525.860006]  [<c0405dab>] ? mutex_lock+0xe/0x1d
[12525.860006]  [<c01693cb>] ? pipe_read+0x2ee/0x2fb
[12525.860006]  [<c0148faf>] ? generic_file_aio_write+0x57/0xb4
[12525.860006]  [<c0163a32>] ? do_sync_write+0xaa/0xe8
[12525.860006]  [<c0129fe5>] ? autoremove_wake_function+0x0/0x33
[12525.860006]  [<c0173ccf>] ? mntput_no_expire+0x19/0x95
[12525.860006]  [<c01698b3>] ? path_put+0x20/0x23
[12525.860006]  [<c0163988>] ? do_sync_write+0x0/0xe8
[12525.860006]  [<c01641d4>] ? vfs_write+0x86/0xf0
[12525.860006]  [<c01642d7>] ? sys_write+0x3b/0x60
[12525.860006]  [<c0102d2e>] ? syscall_call+0x7/0xb
[12525.860006] Code: e8 c1 fc ff ff 3b 5d f4 89 d8 eb ef 5b 89 f0 5b 5e 5d c3 55 89 e5 57 89 c7 56 53 89 d3 8b 02 a8 04 75 04 0f 0b eb fe a8 20 75 04 <0f> 0b eb fe 83 7a 20 00 75 04 0f 0b eb fe f6 c4 10 74 0e 89 f8 
[12525.860006] EIP: [<c017aa8e>] submit_bh+0x18/0xe6 SS:ESP 0068:c84fbb7c
[12525.860006] ---[ end trace daa0a64c01361146 ]---




Index: linux-2.6.29-rc3/drivers/block/nbd.c
===================================================================
--- linux-2.6.29-rc3.orig/drivers/block/nbd.c	2009-02-15 15:44:00.000000000 +0100
+++ linux-2.6.29-rc3/drivers/block/nbd.c	2009-02-15 15:47:44.000000000 +0100
@@ -76,6 +76,7 @@
 	switch (cmd) {
 	case NBD_SET_SOCK: return "set-sock";
 	case NBD_SET_BLKSIZE: return "set-blksize";
+	case NBD_SET_SECTSIZE: return "set-sectsize";
 	case NBD_SET_SIZE: return "set-size";
 	case NBD_DO_IT: return "do-it";
 	case NBD_CLEAR_SOCK: return "clear-sock";
@@ -627,6 +628,9 @@
 			}
 		}
 		return error;
+	case NBD_SET_SECTSIZE:
+		blk_queue_hardsect_size(lo->disk->queue, arg);
+		return 0;
 	case NBD_SET_BLKSIZE:
 		lo->blksize = arg;
 		lo->bytesize &= ~(lo->blksize-1);
Index: linux-2.6.29-rc3/include/linux/nbd.h
===================================================================
--- linux-2.6.29-rc3.orig/include/linux/nbd.h	2009-02-15 15:44:23.000000000 +0100
+++ linux-2.6.29-rc3/include/linux/nbd.h	2009-02-15 15:45:11.000000000 +0100
@@ -27,6 +27,7 @@
 #define NBD_SET_SIZE_BLOCKS	_IO( 0xab, 7 )
 #define NBD_DISCONNECT  _IO( 0xab, 8 )
 #define NBD_SET_TIMEOUT _IO( 0xab, 9 )
+#define NBD_SET_SECTSIZE _IO( 0xab, 10 )
 
 enum {
 	NBD_CMD_READ = 0,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
