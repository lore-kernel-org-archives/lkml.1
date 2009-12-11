Return-Path: <linux-kernel-owner+w=401wt.eu-S1762445AbZLKEvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762445AbZLKEvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 23:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760753AbZLKEgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 23:36:12 -0500
Received: from kroah.org ([198.145.64.141]:52901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759434AbZLKEfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 23:35:43 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 20:27:32 2009
Message-Id: <20091211042731.668869144@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 20:24:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Tso" <tytso@mit.edu>
Subject: [12/90] ext4: Add missing unlock_new_inode() call in extent migration code
References: <20091211042438.970725457@linux.site>
Content-Disposition: inline; filename=0012-ext4-Add-missing-unlock_new_inode-call-in-extent-mig.patch
In-Reply-To: <20091211043502.GA17916@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
(cherry picked from commit a8526e84ac758ac6da45cf273aa1538a6a7aa3de)

We need to unlock the new inode before iput.  This patch fixes the
following warning when calling chattr +e to migrate a file to use
extents.  It also fixes problems in when e4defrag attempts to
defragment an inode.

[  470.400044] ------------[ cut here ]------------
[  470.400065] WARNING: at fs/inode.c:1210 generic_delete_inode+0x65/0x16a()
[  470.400072] Hardware name: N/A
.....
...
[  470.400353] Pid: 4451, comm: chattr Not tainted 2.6.31-rc7-red-debug #4
[  470.400359] Call Trace:
[  470.400372]  [<ffffffff81037771>] warn_slowpath_common+0x77/0x8f
[  470.400385]  [<ffffffff81037798>] warn_slowpath_null+0xf/0x11
[  470.400395]  [<ffffffff810b7f28>] generic_delete_inode+0x65/0x16a
[  470.400405]  [<ffffffff810b8044>] generic_drop_inode+0x17/0x1bd
[  470.400413]  [<ffffffff810b7083>] iput+0x61/0x65
[  470.400455]  [<ffffffffa003b229>] ext4_ext_migrate+0x5eb/0x66a [ext4]
[  470.400492]  [<ffffffffa002b1f8>] ext4_ioctl+0x340/0x756 [ext4]
[  470.400507]  [<ffffffff810b1a91>] vfs_ioctl+0x1d/0x82
[  470.400517]  [<ffffffff810b1ff0>] do_vfs_ioctl+0x483/0x4c9
[  470.400527]  [<ffffffff81059c30>] ? trace_hardirqs_on+0xd/0xf
[  470.400537]  [<ffffffff810b2087>] sys_ioctl+0x51/0x74
[  470.400549]  [<ffffffff8100ba6b>] system_call_fastpath+0x16/0x1b
[  470.400557] ---[ end trace ab85723542352dac ]---

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -618,7 +618,7 @@ err_out:
 	tmp_inode->i_nlink = 0;
 
 	ext4_journal_stop(handle);
-
+	unlock_new_inode(tmp_inode);
 	iput(tmp_inode);
 
 	return retval;


