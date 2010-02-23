Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0BXHNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:13:16 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:42102 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab0BXHNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:13:13 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Feb 2010 02:13:13 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=uZPM8DmsoxjuOBXmckqnk1775yKrk9NnoJZV5gsFAo28tvTL6QcOc0x5qewAWxV9io
         tyIBHLWgfAjRLi3FWATl4FXJJKZ4xAbJb9GAjJ/NxYx1h9LyKkTMI9M7/g6YocuSbJ5B
         zVW4n4hX8Qja7tG7CqW7CWk/IjjoMadJt9fnU=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 1/6] mqueue: remove unneeded info->messages initialization
Date: Tue, 23 Feb 2010 04:04:23 -0300
Message-Id: <260259a07dc6f2f93f450b2ec17315d1bb82138a.1266907496.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <cover.1266907495.git.andre.goddard@gmail.com>
References: <cover.1266907495.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and abort earlier if we couldn't allocate the message pointers array,
avoiding the u->mq_bytes accounting logic.

It reduces code size:
   text    data     bss     dec     hex filename
   9949      72      16   10037    2735 ipc/mqueue-BEFORE.o
   9941      72      16   10029    272d ipc/mqueue-AFTER.o

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 ipc/mqueue.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index c79bd57..2d76647 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -134,7 +134,6 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 			init_waitqueue_head(&info->wait_q);
 			INIT_LIST_HEAD(&info->e_wait_q[0].list);
 			INIT_LIST_HEAD(&info->e_wait_q[1].list);
-			info->messages = NULL;
 			info->notify_owner = NULL;
 			info->qsize = 0;
 			info->user = NULL;	/* set when all is ok */
@@ -146,6 +145,10 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 				info->attr.mq_msgsize = attr->mq_msgsize;
 			}
 			mq_msg_tblsz = info->attr.mq_maxmsg * sizeof(struct msg_msg *);
+			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
+			if (!info->messages)
+				goto out_inode;
+
 			mq_bytes = (mq_msg_tblsz +
 				(info->attr.mq_maxmsg * info->attr.mq_msgsize));
 
@@ -154,18 +157,12 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 		 	    u->mq_bytes + mq_bytes >
 			    p->signal->rlim[RLIMIT_MSGQUEUE].rlim_cur) {
 				spin_unlock(&mq_lock);
+				kfree(info->messages);
 				goto out_inode;
 			}
 			u->mq_bytes += mq_bytes;
 			spin_unlock(&mq_lock);
 
-			info->messages = kmalloc(mq_msg_tblsz, GFP_KERNEL);
-			if (!info->messages) {
-				spin_lock(&mq_lock);
-				u->mq_bytes -= mq_bytes;
-				spin_unlock(&mq_lock);
-				goto out_inode;
-			}
 			/* all is ok */
 			info->user = get_uid(u);
 		} else if (S_ISDIR(mode)) {
-- 
1.7.0.87.g0901d

