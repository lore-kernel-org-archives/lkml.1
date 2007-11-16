Return-Path: <linux-kernel-owner+w=401wt.eu-S934862AbXKPWN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934862AbXKPWN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 17:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760437AbXKPWNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 17:13:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39709 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672AbXKPWNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 17:13:51 -0500
Date: Fri, 16 Nov 2007 22:13:24 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: nfs failure causes bad page state
Message-ID: <20071116221324.GA30209@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While testing a kernel based upon ecd744eec3aa8bbc949ec04ed3fbf7ecb2958a0e
(with wrong boot arguments), I got the following bad page state entry while
NFS was trying to mount it's rootfs:

IP-Config: Complete:
      device=eth0, addr=192.168.1.101, mask=255.255.255.0, gw=255.255.255.255,
     host=192.168.1.101, domain=, nis-domain=(none),
     bootserver=192.168.1.100, rootserver=192.168.1.100, rootpath=
Looking up port of RPC 100003/2 on 192.168.1.100
rpcbind: server 192.168.1.100 not responding, timed out
Root-NFS: Unable to get nfsd port number from server, using default
Looking up port of RPC 100005/1 on 192.168.1.100
rpcbind: server 192.168.1.100 not responding, timed out
Root-NFS: Unable to get mountd port number from server, using default
mount: server 192.168.1.100 not responding, timed out
Root-NFS: Server returned error -5 while mounting /nfs/rootfs/
VFS: Unable to mount root fs via NFS, trying floppy.
Bad page state in process 'swapper'
page:c02b1260 flags:0x00000400 mapping:00000000 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
[<c0023e34>] (dump_stack+0x0/0x14) from [<c0062570>] (bad_page+0x70/0xac)
[<c0062500>] (bad_page+0x0/0xac) from [<c0064914>] (free_hot_cold_page+0x80/0x178)
[<c0064894>] (free_hot_cold_page+0x0/0x178) from [<c0064a74>] (free_hot_page+0x14/0x18)
[<c0064a60>] (free_hot_page+0x0/0x18) from [<c0067078>] (put_page+0xf8/0x154)
[<c0066f80>] (put_page+0x0/0x154) from [<c007dbc8>] (kfree+0xc8/0xd0)
[<c007db00>] (kfree+0x0/0xd0) from [<c00cbb54>] (nfs_get_sb+0x230/0x710)
[<c00cb924>] (nfs_get_sb+0x0/0x710) from [<c0084334>] (vfs_kern_mount+0x58/0xac)[<c00842dc>] (vfs_kern_mount+0x0/0xac) from [<c00843c0>] (do_kern_mount+0x38/0xf4)
[<c0084388>] (do_kern_mount+0x0/0xf4) from [<c0099c7c>] (do_mount+0x1e8/0x614)
...

This seems to be caused by use of an uninitialised structure due to NULL
options being passed to nfs_validate_mount_data().  Ensure that the
parsed mount data is always initialised.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index fa517ae..0b1080c 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1054,10 +1054,11 @@ static int nfs_validate_mount_data(void *options,
 {
 	struct nfs_mount_data *data = (struct nfs_mount_data *)options;
 
+	memset(args, 0, sizeof(*args));
+
 	if (data == NULL)
 		goto out_no_data;
 
-	memset(args, 0, sizeof(*args));
 	args->flags		= (NFS_MOUNT_VER3 | NFS_MOUNT_TCP);
 	args->rsize		= NFS_MAX_FILE_IO_SIZE;
 	args->wsize		= NFS_MAX_FILE_IO_SIZE;


-- 
Russell King
