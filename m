Return-Path: <linux-kernel-owner+w=401wt.eu-S933384AbYD3X6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384AbYD3X6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760780AbYD3X6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:58:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760358AbYD3X6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:58:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ben Hutchings <bhutchings@solarflare.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/11] sysfs: Disallow truncation of files in sysfs
Date: Wed, 30 Apr 2008 16:57:40 -0700
Message-Id: <1209599870-22919-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <20080430235701.GA20981@suse.de>
References: <20080430235701.GA20981@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

sysfs allows attribute files to be truncated, e.g. using ftruncate(), with the
expected effect on their inode.   For most attributes, this doesn't change the
"real" size of the file i.e. how much can be read from it.  However, the
parameter validation for reading and writing binary attribute files is based
on the inode size and not the size specified in the file's bin_attribute, so it
can be broken by this. For example, if we try using dd to write to such a file:

# pwd
/sys/bus/pci/devices/0000:08:00.0
# ls -l config
-rw-r--r--  1 root root 4096 Feb  1 17:35 config
# dd if=/dev/zero of=config bs=4 count=1
1+0 records in
1+0 records out
# ls -l config
-rw-r--r--  1 root root 0 Feb  1 17:50 config
# dd if=/dev/zero of=config bs=4 count=1 seek=128
dd: writing `config': No space left on device
1+0 records in
0+0 records out

Also, after truncation to 0, parameter validation for read and write is
disabled.  Most bin_attribute read and write methods also validate the size and
offset, but for some this will allow out-of-range access.  This may be a
security issue, though access to such files is often limited to root.  In any
case, the validation should remain for safety's sake!)

This was previously reported in Bugzilla as bug 9867.

sysfs should ignore size changes or else refuse them (by returning -EINVAL).
This patch makes it ignore them.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index f8b82e7..eb53c63 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -59,6 +59,8 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	if (error)
 		return error;
 
+	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
+
 	error = inode_setattr(inode, iattr);
 	if (error)
 		return error;
-- 
1.5.5.1

