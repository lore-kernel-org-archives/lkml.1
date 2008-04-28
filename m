Return-Path: <linux-kernel-owner+w=401wt.eu-S937683AbYD1X5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937683AbYD1X5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 19:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937050AbYD1X4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 19:56:16 -0400
Received: from mail.suse.de ([195.135.220.2]:51130 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937033AbYD1X4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 19:56:15 -0400
Subject: patch sysfs-disallow-truncation-of-files-in-sysfs.patch added to gregkh-2.6 tree
To: bhutchings@solarflare.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Mon, 28 Apr 2008 16:51:45 -0700
In-Reply-To: <20080428145957.GD8986@solarflare.com>
Message-ID: <1209426705637@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: sysfs: Disallow truncation of files in sysfs

to my gregkh-2.6 tree.  Its filename is

     sysfs-disallow-truncation-of-files-in-sysfs.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From bwh@level5networks.com Mon Apr 28 08:00:07 2008
From: Ben Hutchings <bhutchings@solarflare.com>
Date: Mon, 28 Apr 2008 15:59:58 +0100
Subject: sysfs: Disallow truncation of files in sysfs
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Message-ID: <20080428145957.GD8986@solarflare.com>
Content-Disposition: inline


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
 1 file changed, 2 insertions(+)

--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -59,6 +59,8 @@ int sysfs_setattr(struct dentry * dentry
 	if (error)
 		return error;
 
+	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
+
 	error = inode_setattr(inode, iattr);
 	if (error)
 		return error;


Patches currently in gregkh-2.6 which might be from bhutchings@solarflare.com are

driver-core/sysfs-disallow-truncation-of-files-in-sysfs.patch
