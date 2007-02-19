Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbXBSP5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbXBSP5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 10:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932377AbXBSP5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 10:57:19 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:5486 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbXBSP5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 10:57:18 -0500
To: linux-kernel@vger.kernel.org
CC: devel@openvz.org
Subject: [PATCH] ecryptfs ecryptfs_read_super path_lookup errh fix 
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Mon, 19 Feb 2007 18:57:42 +0300
Message-ID: <87bqjqp2bt.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

if path_lookup() return non zero code we don't have to worry about 'nd' 
parameter, but ecryptfs_read_super does path_release(&nd) after path_lookup
has failed, and dentry counter becomes negative :) , this result in folowing BUG

ecryptfs_read_super: path_lookup() failed
BUG: Dentry f3f074c4{i=0,n=enc_dir} still in use (-1) [unmount of ext3 dm-5]
<<<<<<<<<<<<<<<<<<<<<counter is negative here   ^^^^^^
------------[ cut here ]------------
kernel BUG at fs/dcache.c:654!
invalid opcode: 0000 [#1]
SMP 
last sysfs file: /fs/ecryptfs/version
Modules linked in: ecb ecryptfs bluetooth video e1000
CPU:    1
EIP:    0060:[<c01831a7>]    Not tainted VLI
EFLAGS: 00210292   (2.6.20-mm2-g0cb8e157-dirty #10)
EIP is at shrink_dcache_for_umount_subtree+0x159/0x1fb
eax: 0000004b   ebx: f3f074c4   ecx: c0122e78   edx: f7612070
esi: ffffffff   edi: f3f0753c   ebp: f4269cac   esp: f4269c7c
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process mount.ecryptfs (pid: 4236, ti=f4268000 task=f7612070 task.ti=f4268000)
Stack: c04f9dee f3f074c4 00000000 f3f0753c ffffffff c04fd617 f5161e30 00000000 
       00000000 f5161c00 c043b780 f4269d98 f4269cb8 c0183f5f f5161c00 f4269cd0 
       c0176166 f4269cc8 c022cb90 f705fcc0 f5161c00 f4269ce0 c017622c f5161c00 
Call Trace:
 [<c0105f70>] show_trace_log_lvl+0x1a/0x2f
 [<c0106020>] show_stack_log_lvl+0x9b/0xaa
 [<c01061e7>] show_registers+0x1b8/0x289
 [<c01063d6>] die+0x11e/0x233
 [<c042ed50>] do_trap+0x8a/0xa3
 [<c0106979>] do_invalid_op+0x97/0xa1
 [<c042eb14>] error_code+0x7c/0x84
 [<c0183f5f>] shrink_dcache_for_umount+0x2d/0x3a
 [<c0176166>] generic_shutdown_super+0x18/0xbe
 [<c017622c>] kill_block_super+0x20/0x32
 [<c01762ce>] deactivate_super+0x3f/0x51
 [<c018724d>] mntput_no_expire+0x42/0x6b
 [<c017a719>] path_release+0x20/0x23
 [<f886387d>] ecryptfs_get_sb+0x45a/0x4ad [ecryptfs]
 [<c0176361>] vfs_kern_mount+0x81/0xf1
 [<c0176419>] do_kern_mount+0x30/0x42
 [<c018847b>] do_mount+0x601/0x678
 [<c0188561>] sys_mount+0x6f/0xa9
 [<c0104f2c>] sysenter_past_esp+0x5d/0x99
 =======================
Code: 30 02 00 00 89 44 24 18 8b 45 ec 89 4c 24 14 89 74 24 10 89 7c 24 0c 89 5c 24 04 89 44 24 08 c7 04 24 ee 9d 4f c0 e8 b7 74 fa ff <0f> 0b eb fe 8b 73 30 39 de 75 04 31 f6 eb 03 f0 ff 0e 8d 43 48 
EIP: [<c01831a7>] shrink_dcache_for_umount_subtree+0x159/0x1fb SS:ESP 0068:f4269c7c

This is easy to reproduce just try to mount ecryptfs to nonexisting lower path
# mount -tecryptfs private/this_dir_not_exist root -ocipher=aes

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
-------------

--=-=-=
Content-Disposition: inline; filename=diff-mm-ecryptfs-path_lookup-fix

diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 80044d1..812427e 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -487,7 +487,7 @@ static int ecryptfs_read_super(struct super_block *sb, const char *dev_name)
 	rc = path_lookup(dev_name, LOOKUP_FOLLOW, &nd);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "path_lookup() failed\n");
-		goto out_free;
+		goto out;
 	}
 	lower_root = nd.dentry;
 	if (!lower_root->d_inode) {

--=-=-=--

