Return-Path: <linux-kernel-owner+w=401wt.eu-S1758754AbZJEJhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbZJEJhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 05:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758736AbZJEJhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 05:37:11 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:51377 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486AbZJEJhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 05:37:10 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 05:37:09 EDT
Date: Mon, 05 Oct 2009 18:28:56 +0900 (JST)
Message-Id: <20091005.182856.93261474275115473.mitake@dcl.info.waseda.ac.jp>
To: sfrench@us.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Fixing to avoid invalid kfree() in cifs_get_tcp_session()
 of fs/cifs/connect.c
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I found a trivial bug in fs/cifs/connect.c .
The bug is caused by fail of extract_hostname()
when mounting cifs file system.

This is the situation when I noticed this bug.

% sudo mount -t cifs //192.168.10.208 mountpoint -o options...

Then my kernel says,

[ 1461.807776] ------------[ cut here ]------------
[ 1461.807781] kernel BUG at mm/slab.c:521!
[ 1461.807784] invalid opcode: 0000 [#2] PREEMPT SMP
[ 1461.807790] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:09:02.0/resource
[ 1461.807793] CPU 0
[ 1461.807796] Modules linked in: nls_iso8859_1 usbhid sbp2 uhci_hcd ehci_hcd i2c_i801 ohci1394 ieee1394 psmouse serio_raw pcspkr sky2 usbcore evdev
[ 1461.807816] Pid: 3446, comm: mount Tainted: G      D    2.6.32-rc2-vanilla #1 System Product Name
[ 1461.807820] RIP: 0010:[<ffffffff810b888e>]  [<ffffffff810b888e>] kfree+0x63/0x156
[ 1461.807829] RSP: 0018:ffff8800b4f7fbb8  EFLAGS: 00010046
[ 1461.807832] RAX: ffffea00033fff98 RBX: ffff8800afbae7e2 RCX: 0000000000000000
[ 1461.807836] RDX: ffffea0000000000 RSI: 000000000000005c RDI: ffffffffffffffea
[ 1461.807839] RBP: ffff8800b4f7fbf8 R08: 0000000000000001 R09: 0000000000000000
[ 1461.807842] R10: 0000000000000000 R11: ffff8800b4f7fbf8 R12: 00000000ffffffea
[ 1461.807845] R13: ffff8800afb23000 R14: ffff8800b4f87bc0 R15: ffffffffffffffea
[ 1461.807849] FS:  00007f52b6f187c0(0000) GS:ffff880007600000(0000) knlGS:0000000000000000
[ 1461.807852] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1461.807855] CR2: 0000000000613000 CR3: 00000000af8f9000 CR4: 00000000000006f0
[ 1461.807858] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1461.807861] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1461.807865] Process mount (pid: 3446, threadinfo ffff8800b4f7e000, task ffff8800950e4380)
[ 1461.807867] Stack:
[ 1461.807869]  0000000000000202 0000000000000282 ffff8800b4f7fbf8 ffff8800afbae7e2
[ 1461.807876] <0> 00000000ffffffea ffff8800afb23000 ffff8800b4f87bc0 ffff8800b4f7fc28
[ 1461.807884] <0> ffff8800b4f7fcd8 ffffffff81159f6d ffffffff81147bc2 ffffffff816bfb48
[ 1461.807892] Call Trace:
[ 1461.807899]  [<ffffffff81159f6d>] cifs_get_tcp_session+0x440/0x44b
[ 1461.807904]  [<ffffffff81147bc2>] ? find_nls+0x1c/0xe9
[ 1461.807909]  [<ffffffff8115b889>] cifs_mount+0x16bc/0x2167
[ 1461.807917]  [<ffffffff814455bd>] ? _spin_unlock+0x30/0x4b
[ 1461.807923]  [<ffffffff81150da9>] cifs_get_sb+0xa5/0x1a8
[ 1461.807928]  [<ffffffff810c1b94>] vfs_kern_mount+0x56/0xc9
[ 1461.807933]  [<ffffffff810c1c64>] do_kern_mount+0x47/0xe7
[ 1461.807938]  [<ffffffff810d8632>] do_mount+0x712/0x775
[ 1461.807943]  [<ffffffff810d671f>] ? copy_mount_options+0xcf/0x132
[ 1461.807948]  [<ffffffff810d8714>] sys_mount+0x7f/0xbf
[ 1461.807953]  [<ffffffff8144509a>] ? lockdep_sys_exit_thunk+0x35/0x67
[ 1461.807960]  [<ffffffff81011cc2>] system_call_fastpath+0x16/0x1b
[ 1461.807963] Code: 00 00 00 00 ea ff ff 48 c1 e8 0c 48 6b c0 68 48 01 d0 66 83 38 00 79 04 48 8b 40 10 66 83 38 00 79 04 48 8b 40 10 80 38 00 78 04 <0f> 0b eb fe 4c 8b 70 58 4c 89 ff 41 8b 76 4c e8 b8 49 fb ff e8
[ 1461.808022] RIP  [<ffffffff810b888e>] kfree+0x63/0x156
[ 1461.808027]  RSP <ffff8800b4f7fbb8>
[ 1461.808031] ---[ end trace ffe26fcdc72c0ce4 ]---

The reason of this bug is that the error handling code of cifs_get_tcp_session()
calls kfree() when corresponding kmalloc() failed.
(The kmalloc() is called by extract_hostname().)

So I fixed a little. This is the patch. Please use.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 43003e0..b090980 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1577,7 +1577,8 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 
 out_err:
 	if (tcp_ses) {
-		kfree(tcp_ses->hostname);
+		if (!IS_ERR(tcp_ses->hostname))
+			kfree(tcp_ses->hostname);
 		if (tcp_ses->ssocket)
 			sock_release(tcp_ses->ssocket);
 		kfree(tcp_ses);
