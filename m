Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbXKEEwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbXKEEwz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 23:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXKEEwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 23:52:47 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:5705 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbXKEEwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 23:52:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=Kn9xUPm58W9erOTZYaVm0qQzAOXZU4qwSHO1XtrBAF9q1Pj0IUkydpm39vsE1rNGCGMCBM3KyjjV3hfdCckiGFV07vTDD4/le4W3lsOuvmYlHThJ6Mvv48/h1/E+Tvm6Y+n74IE/SMd5VQvGn/SUXt2zWBtOJqEGDaRWh8yMdHU=
Date: Mon, 5 Nov 2007 12:59:22 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-kernel@vger.kernel.org, bluez-devel@lists.sourceforge.net
Subject: [PATCH]bluetooth rfcomm_dev refcount bug fix
Message-ID: <20071105045921.GA3556@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In the rfcomm_tty_hangup the rfcomm_dev refcnt should be dropped later.

If rfcomm_dev is destructed in tty_hangup function, then the later tty_close function will oops.

BUG: unable to handle kernel NULL pointer dereference at virtual address 00000008
printing eip: c01c0884 *pde = 00000000 
Oops: 0000 [#1] PREEMPT SMP 
Modules linked in: bnep rfcomm l2cap snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss e100 psmouse btusb bluetooth evdev sg thermal snd_hda_intel snd_pcm serio_raw snd_timer snd processor button rtc_cmos pcspkr rtc_core rtc_lib intel_agp agpgart soundcore snd_page_alloc i2c_i801

Pid: 2621, comm: rfcomm Not tainted (2.6.24-rc1 #3)
EIP: 0060:[<c01c0884>] EFLAGS: 00010246 CPU: 1
EIP is at sysfs_move_dir+0x24/0x1d0
EAX: c04e4028 EBX: c1c3314c ECX: 00000000 EDX: c1c3314c
ESI: c1c3314c EDI: 00000000 EBP: 00000000 ESP: c2e7be1c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process rfcomm (pid: 2621, ti=c2e7a000 task=c2764590 task.ti=c2e7a000)
Stack: ffffffff 0000000a 3d92326f c26dcd90 c048ff2b 00000000 00000000 c278dda8 
       c1c3314c c2780690 c26dcd90 c0249d22 c26dcd90 c048ff1d c2780690 fffffff4 
       c26dcd90 00000000 c278dd20 00000000 00000000 c1c3314c c02b43bb c278dda8 
Call Trace:
 [<c0249d22>] kobject_move+0xa2/0x120
 [<c02b43bb>] device_move+0x5b/0x120
 [<f88cbcee>] rfcomm_tty_close+0x8e/0xd0 [rfcomm]
 [<c029753a>] release_dev+0x58a/0x6b0
 [<c02a7050>] con_put_char+0x30/0x40
 [<c013fe7a>] remove_wait_queue+0x1a/0x50
 [<c0125500>] default_wake_function+0x0/0x10
 [<c029b759>] write_chan+0x1b9/0x200
 [<c01255be>] __wake_up+0x3e/0x60
 [<c02954d3>] tty_ldisc_deref+0x63/0x80
 [<c0297aef>] tty_release+0xf/0x20
 [<c017e79e>] __fput+0x14e/0x180
 [<c017cb6c>] filp_close+0x3c/0x80
 [<c017cc19>] sys_close+0x69/0xd0
 [<c01043ca>] syscall_call+0x7/0xb
 [<c0400000>] wait_for_common+0x60/0x160
 =======================
Code: 6c 24 28 83 c4 2c c3 55 57 31 ff 56 53 83 ec 1c 89 d3 8b 68 1c 31 c0 89 44 24 18 31 c0 89 44 24 14 b8 28 40 4e c0 e8 0c fe 23 00 <8b> 55 08 85 d2 0f 84 65 01 00 00 8b 73 1c b8 a0 40 4e c0 85 f6 
EIP: [<c01c0884>] sysfs_move_dir+0x24/0x1d0 SS:ESP 0068:c2e7be1c

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
net/bluetooth/rfcomm/tty.c |    7 -------
1 file changed, 7 deletions(-)

diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
--- linux/net/bluetooth/rfcomm/tty.c	2007-11-05 11:28:49.000000000 +0800
+++ linux.new/net/bluetooth/rfcomm/tty.c	2007-11-05 11:30:59.000000000 +0800
@@ -1018,13 +1018,6 @@ static void rfcomm_tty_hangup(struct tty
 		return;
 
 	rfcomm_tty_flush_buffer(tty);
-
-	if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags)) {
-		if (rfcomm_dev_get(dev->id) == NULL)
-			return;
-		rfcomm_dev_del(dev);
-		rfcomm_dev_put(dev);
-	}
 }
 
 static int rfcomm_tty_read_proc(char *buf, char **start, off_t offset, int len, int *eof, void *unused)

