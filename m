Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550Ab0ANTiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550Ab0ANTiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 14:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521Ab0ANTiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 14:38:22 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:30624 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756591Ab0ANTiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 14:38:21 -0500
Date: Thu, 14 Jan 2010 14:37:08 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [btrfs] kernel BUG at include/linux/spinlock.h:376!
Message-ID: <20100114193708.GD23810@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001072229.33976.johannes.hirte@fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001072229.33976.johannes.hirte@fem.tu-ilmenau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B4F72A6.01B1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 10:29:32PM +0100, Johannes Hirte wrote:
> One of my btrfs filesystems gives the following bug message on access:
> 
> Jan  6 23:08:12 datengrab kernel: ------------[ cut here ]------------
> Jan  6 23:08:12 datengrab kernel: kernel BUG at include/linux/spinlock.h:376!
> Jan  6 23:08:12 datengrab kernel: invalid opcode: 0000 [#1] SMP
> Jan  6 23:08:12 datengrab kernel: last sysfs file: 
> /sys/devices/pci0000:00/0000:00:18.3/temp1_input
> Jan  6 23:08:12 datengrab kernel: CPU 1
> Jan  6 23:08:12 datengrab kernel: Pid: 2837, comm: btrfs-endio-wri Not tainted 
> 2.6.33-rc3-00033-g03b7675 #12 TYAN Tiger K8W Dual AMD Opteron, S2875/To Be 
> Filled
> By O.E.M.
> Jan  6 23:08:12 datengrab kernel: RIP: 0010:[<ffffffff8118f7ea>]  [<ffffffff8118f7ea>] 
> btrfs_assert_tree_locked+0x16/0x1c

Well, we really should have this tree block locked, but
btrfs_mark_extent_written is doing some special things.  Is the trace
always the same?

If so, please try this patch:

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3bfe9f0..1148aa0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -572,6 +572,7 @@ again:
 	key.objectid = inode->i_ino;
 	key.type = BTRFS_EXTENT_DATA_KEY;
 	key.offset = split;
+	path->keep_locks = 1;
 
 	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
 	if (ret > 0 && path->slots[0] > 0)
