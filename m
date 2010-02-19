Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab0BSTri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:47:38 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49065 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab0BSTrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:47:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=coFTaAFRlmj55z+4pqe3jU8dAKv9Pr9f5H+XJxBDuGxGkjYDhWaxM29m7a8ymm+f7r
         fOye/IWZLJqkMUl+UCTHCtqBMzXGTS6UNI1vpZ1ovNbHczb7HHypRjCvaa882XUu6+FE
         OdvWZl9Byt7ASdOXJHkOWhzIry5mLydlpia/o=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/7] vfs: notify_changes() error handling
Date: Fri, 19 Feb 2010 22:47:18 +0300
Message-Id: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current inode attr setting path looks like follows

 ret = inode_change_ok()
 if(ret)
     goto out;
 /*
  perform private-fs specific logic here
  */
 if(ia_valid & ATTR_UID || ...)
    ret = vfs_dq_transfer()

 /*
   more private-fs specific logic
   for example update on_disk data structures.
   */

  ret = inode_setattr()

In fact inode_setattr() call vmtruncate() which may fail in number
of reasons IS_SWAPFILE, RLIMIT_FSIZE. After this many filesystem is
unable to rollback changes. And just live inode in inconsistent
state. We may check IS_SWAPFILE at the very beginning(currently it
is not checked), but RLIMIT_FSIZE may changed under our feet.
In order make things straight. Let's divide vmtruncate() in to
two parts which perform all checks, and second which can not fail.
After this notify_change() perform all necessary checks inside
inode_change_ok() and simply call nofail version of vmtruncate().

##TEST_CASE_BEGIN:
# dd if=/dev/zero of=/mnt/file bs=1M count=10
# mkswap /mnt/file
# swapon /mnt/file
# ./truncate /mnt/file 0
# sync
# echo "stat file" | debugfs /dev/sda9
debugfs 1.41.9 (22-Aug-2009)
Inode: 2746   Type: regular    Mode:  0644   Flags: 0x80000
Generation: 571328532    Version: 0x00000000:00000001
User:     0   Group:     0   Size: 0
##### ON_DISK_SIZE IS ZERO ^^^^^^^^^^^^
File ACL: 0    Directory ACL: 0
Links: 1   Blockcount: 20480
Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x4b7ee6cc:d4bbee04 -- Fri Feb 19 22:30:20 2010
 atime: 0x4b7ee6d3:91fb9b9c -- Fri Feb 19 22:30:27 2010
 mtime: 0x4b7ee6cc:d4bbee04 -- Fri Feb 19 22:30:20 2010
crtime: 0x4b7eb3c4:01f8d494 -- Fri Feb 19 18:52:36 2010
dtime: 0x00000aba -- Thu Jan  1 03:45:46 1970
Size of extra inode fields: 28
EXTENTS:
(0-2559): 112640-115199
##TEST_CASE_END
