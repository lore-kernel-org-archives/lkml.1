Return-Path: <linux-kernel-owner+w=401wt.eu-S1765590AbYD1Gba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765590AbYD1Gba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYD1GbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:31:19 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35798 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbYD1GbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:31:18 -0400
X-Sasl-enc: TVImNDlxTkzJnuoF4N7QnHZ2qOZv2S+wsgzTEJfXufkF 1209364276
Date: Mon, 28 Apr 2008 14:30:29 +0800 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 2/2] autofs4 - fix incorect return from root.c:try_to_fill_dentry()
Message-ID: <Pine.LNX.4.64.0804281427050.10684@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

Jeff Moyer has identified a case where the autofs4 function
root.c:try_to_fill_dentry() can return -EBUSY when it should return
0.

Jeffs description of the way this happens is:

"automount starts an expire for directory d.
after the callout to the daemon, but before the rmdir, another
process tries to walk into the same directory.  It puts itself
onto the waitq, pending the expiration.

When the expire finishes, the second process is woken up.  In
try_to_fill_dentry, it does this check:

                status = d_invalidate(dentry);
                if (status != -EBUSY)
                        return -EAGAIN;

And status is EBUSY.  The dentry still has a non-zero d_inode, and the
flags do not contain LOOKUP_CONTINUE or LOOKUP_DIRECTORY

So, we fall through and return -EBUSY to the caller."

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Ian Kent <raven@themaw.net>

Ian

---
diff -up linux-2.6.25-mm1/fs/autofs4/root.c.correct-return-in-ttfd linux-2.6.25-mm1/fs/autofs4/root.c
--- linux-2.6.25-mm1/fs/autofs4/root.c.correct-return-in-ttfd	2008-04-28 11:47:20.000000000 +0800
+++ linux-2.6.25-mm1/fs/autofs4/root.c	2008-04-28 11:48:00.000000000 +0800
@@ -245,7 +245,7 @@ static int try_to_fill_dentry(struct den
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
 	struct dentry *new;
-	int status = 0;
+	int status;
 
 	/* Block on any pending expiry here; invalidate the dentry
            when expiration is done to trigger mount request with a new
@@ -342,7 +342,7 @@ static int try_to_fill_dentry(struct den
 		}
 	}
 
-	return status;
+	return 0;
 }
 
 /* For autofs direct mounts the follow link triggers the mount */
