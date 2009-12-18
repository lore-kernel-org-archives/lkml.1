Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbZLRFqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbZLRFqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 00:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbZLRFqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 00:46:13 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:2245 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbZLRFqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 00:46:12 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAOalKkurR7Ht/2dsb2JhbAC+OpclhC0E
X-IronPort-AV: E=Sophos;i="4.47,417,1257120000"; 
   d="scan'208";a="451907869"
From: Roland Dreier <rdreier@cisco.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] anonfd: Make file read-only if fops->write is not set
X-Message-Flag: Warning: May contain useful information
Date: Thu, 17 Dec 2009 21:46:11 -0800
Message-ID: <adaws0k3kd8.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Dec 2009 05:46:11.0650 (UTC) FILETIME=[6783C220:01CA7FA5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems a couple places such as arch/ia64/kernel/perfmon.c and
drivers/infiniband/core/uverbs_main.c could use anon_inode_getfile()
instead of a private pseudo-fs + alloc_file(), if only there were a way
to get a read-only file.  So provide this by having anon_inode_getfile()
create a read-only file if the fops->write passed in is NULL.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
Hi Davide,

Would you consider a patch like this?  I'm not sure if this is the most
elegant way to handle this -- perhaps extending the flags parameter to
say whether we want writable or not would be better.  Let me know if you
would prefer that.

Thanks,
  Roland

 fs/anon_inodes.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 2c99459..097f91f 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -121,13 +121,13 @@ struct file *anon_inode_getfile(const char *name,
 	d_instantiate(path.dentry, anon_inode_inode);
 
 	error = -ENFILE;
-	file = alloc_file(&path, FMODE_READ | FMODE_WRITE, fops);
+	file = alloc_file(&path, FMODE_READ | (fops->write ? FMODE_WRITE : 0), fops);
 	if (!file)
 		goto err_dput;
 	file->f_mapping = anon_inode_inode->i_mapping;
 
 	file->f_pos = 0;
-	file->f_flags = O_RDWR | (flags & O_NONBLOCK);
+	file->f_flags = (fops->write ? O_RDWR : O_RDONLY) | (flags & O_NONBLOCK);
 	file->f_version = 0;
 	file->private_data = priv;
 
