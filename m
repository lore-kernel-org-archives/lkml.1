Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab0BYMqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 07:46:07 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60559 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab0BYMqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 07:46:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:cc:date:message-id:user-agent:mime-version
         :content-type;
        b=Q7TshT4HBzC1uaY8WiY+SPIfKr3xxILphKkxGd6E7A6fzrDnnp3eXXadsMUHAUjnNR
         kJm6gMvWBQsyOs8Y7Jy8CUvkmwZ0kvyltIfLdzyLmz+TCjDImML4r0tzwzBnseCPL038
         gIHa9CRhdQOmlvNGcd+kfqb+bb+8ny90k+TIU=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Subject: [patch] RFC directio: partial writes support
CC: linux-fsdevel@vger.kernel.org
Date: Thu, 25 Feb 2010 15:45:58 +0300
Message-ID: <87iq9lxz3t.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Can someone please describe me why directio deny partial writes.
For example if someone try to write 100Mb but file system has less
data it return ENOSPC in the middle of block allocation.
All allocated blocks will be truncated (it may be 100Mb -4k) end
ENOSPC will be returned. As far as i remember direct_io always act
like this, but i never asked why?
Why do we have to give up all the progress we made?
In fact partial writes are possible in case of holes, when we 
fall back to buffered write. XFS implemented partial writes.

I've done trivial changes and it works like charm. 
Let's enable partial writes support and allow caller to define
this behavior.


--=-=-=
Content-Disposition: inline;
 filename=0001-direct_io-Allow-partial-writes.patch

>From 4a72c4a61e133140750d05853b8dafecd8ef5d87 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Thu, 25 Feb 2010 15:14:48 +0300
Subject: [PATCH] direct_io: Allow partial writes

Current direct io allocation behavior is inconvenient. Partial writes
are not supported. If we try to issue 10Mb chunk, but only 5Mb is
available then we will allocate thees 5Mb until ENOSPC, and then
drop such space and return ENOSPC.
But in fact partial writes are possible in case of holes.
Seems that there is no enough reason to deny partial writes.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/direct-io.c     |    4 ++++
 fs/ext4/inode.c    |   11 +++++++----
 include/linux/fs.h |    2 ++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index e82adc2..250a041 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -229,6 +229,10 @@ static int dio_complete(struct dio *dio, loff_t offset, int ret)
 		ret = 0;
 
 	if (dio->result) {
+		/* Ignore error if we have written some data */
+		if (dio->flags & DIO_PARTIAL_WRITE)
+			ret = 0;
+
 		transferred = dio->result;
 
 		/* Check for short read case */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 218ea0b..8c00127 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3447,10 +3447,13 @@ retry:
 				 offset, nr_segs,
 				 ext4_get_block, NULL);
 	else
-		ret = blockdev_direct_IO(rw, iocb, inode,
-				 inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
-				 ext4_get_block, NULL);
+		ret = __blockdev_direct_IO(rw, iocb, inode,
+					inode->i_sb->s_bdev, iov,
+					offset, nr_segs,
+					ext4_get_block, NULL,
+					DIO_LOCKING | DIO_SKIP_HOLES |
+					DIO_PARTIAL_WRITE);
+
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9147ca8..d887685 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2259,6 +2259,8 @@ enum {
 
 	/* filesystem does not support filling holes */
 	DIO_SKIP_HOLES	= 0x02,
+	/* allow partial writes */
+	DIO_PARTIAL_WRITE = 0x04,
 };
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-- 
1.6.6


--=-=-=--
