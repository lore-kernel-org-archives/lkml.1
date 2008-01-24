Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbYAXXas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbYAXXas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 18:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbYAXXah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 18:30:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41576 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYAXXah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 18:30:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Vde6Xl3C761x/C+L6+mCha7PqotrR5hMeYyrPVUGV6nwQujwExys8PmgL+EhyKAT0xYH2T4LPbCt45bcQYGhpBF0xXOpX26BWHQQNvVHHX7Bh8LDg3u/mRBayA2f03o7rIgeO1Ck26Gh3bKPwwO5U95lg46mQQILU+WGpjo4hi0=
Message-ID: <47991F94.3050001@gmail.com>
Date: Fri, 25 Jan 2008 02:30:28 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
CC: Heikki Orsila <shdl@zakalwe.fi>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 5/9] bfs: move function prototype to the proper header
 file
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com> <1201213928-18183-6-git-send-email-dmitri.vorobiev@gmail.com> <20080124225031.GC12172@zakalwe.fi> <47991B7C.6000208@gmail.com> <Pine.LNX.4.61.0801242318560.8513@ginsburg.homenet>
In-Reply-To: <Pine.LNX.4.61.0801242318560.8513@ginsburg.homenet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tigran Aivazian пишет:
> On Fri, 25 Jan 2008, Dmitri Vorobiev wrote:
> 
>> Heikki Orsila пишет:
>>>> +extern void dump_imap(const char *, struct super_block *);
>>>> +
>>>
>>> Functions should not be externed, remove extern keyword.
>>>
>>
>> Care to explain why?
> 
> because dump_imap() is just a BFS' internal helper (for debugging
> purposes only btw) to dump the inode map via printk. Why should it be
> moved into the header, i.e. where one expects to see things potentially
> visible by the rest of the kernel?
>

Thanks, Tigran.

Please find below the corrected version. Compilation test passed successfully.

Dmitri
 
======

The dump_imap() routine is defined in bs/bfs/inode.c and used both in
the same file and in fs/bfs/dir.c. This patch adds an extern function
declaration to the private bfs.h header file.

The effect is that one warning issued by checkpatch.pl is gone.

Before the patch:

$ ./scripts/checkpatch.pl --file  fs/bfs/dir.c | grep total
total: 0 errors, 1 warnings, 370 lines checked

After the patch:

$ ./scripts/checkpatch.pl --file  fs/bfs/dir.c | grep total
total: 0 errors, 0 warnings, 368 lines checked

This patch was compile-tested by building the BFS driver both
as a module and as a part of the kernel proper.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index 090b96e..352804f 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -54,4 +54,7 @@ extern const struct address_space_operations bfs_aops;
 extern const struct inode_operations bfs_dir_inops;
 extern const struct file_operations bfs_dir_operations;
 
+/* inode.c */
+void dump_imap(const char *, struct super_block *);
+
 #endif /* _FS_BFS_BFS_H */
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 5462a5b..2964505 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -81,8 +81,6 @@ const struct file_operations bfs_dir_operations = {
 	.fsync		= file_fsync,
 };
 
-extern void dump_imap(const char *, struct super_block *);
-
 static int bfs_create(struct inode *dir, struct dentry *dentry, int mode,
 						struct nameidata *nd)
 {
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 5191990..91d5686 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -30,8 +30,6 @@ MODULE_LICENSE("GPL");
 #define dprintf(x...)
 #endif
 
-void dump_imap(const char *prefix, struct super_block *s);
-
 static void bfs_read_inode(struct inode *inode)
 {
 	unsigned long ino = inode->i_ino;

