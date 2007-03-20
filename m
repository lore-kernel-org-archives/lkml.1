Return-Path: <linux-kernel-owner+w=401wt.eu-S932889AbXCTN22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbXCTN22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 09:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbXCTN21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 09:28:27 -0400
Received: from server077.de-nserver.de ([62.27.12.245]:56570 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889AbXCTN20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 09:28:26 -0400
Message-ID: <45FFE163.2050107@prie.be>
Date: Tue, 20 Mar 2007 14:28:03 +0100
From: Stefan Priebe <stefan@prie.be>
Reply-To: stefan@prie.be
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Olaf Kirch <olaf.kirch@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Kernel 2.6.20 does not work anymore with SCSI or SATA on old
 Opteron / Xeon servers
References: <45FDA626.9000404@prie.be> <20070319232732.854d7120.akpm@linux-foundation.org> <45FFB867.3060500@prie.be> <200703201154.58234.olaf.kirch@oracle.com>
In-Reply-To: <200703201154.58234.olaf.kirch@oracle.com>
Content-Type: multipart/mixed;
 boundary="------------080100010505030700070003"
X-User-Auth: Auth by hostmaster@profihost.com through 84.134.42.121
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080100010505030700070003
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello!

With the sysrq i've found the function with is the problem:
inode.c => nfs_getattr => nfs_sync_mapping_range

I've also found the attached patch - which is not included in any stable 
release nor in 2.6.21.X but is public since 20.02.07

I think this is very important.

Stefan Priebe

--------------080100010505030700070003
Content-Type: text/plain;
 name="linux-2.6.20-001-fix_block_device_getattr.dif"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.20-001-fix_block_device_getattr.dif"

commit 090ad38f8ceea3cc048981e9fe9cc62ed43fee58
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Tue Feb 20 19:28:07 2007 -0500

    NFS: nfs_getattr() can't call nfs_sync_mapping_range() for non-regular files
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index af53c02..93d046c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -429,7 +429,8 @@ int nfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
 	int err;
 
 	/* Flush out writes to the server in order to update c/mtime */
-	nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
+	if (S_ISREG(inode->i_mode))
+		nfs_sync_mapping_range(inode->i_mapping, 0, 0, FLUSH_NOCOMMIT);
 
 	/*
 	 * We may force a getattr if the user cares about atime.

--------------080100010505030700070003--
