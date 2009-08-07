Return-Path: <linux-kernel-owner+w=401wt.eu-S1755060AbZHGS6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbZHGS6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbZHGS6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:58:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56744 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbZHGS6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:58:02 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk, hannes@cmpxchg.org
Subject: [PATCH 2/4] vfs: explicitly cast s_maxbytes in fiemap_check_ranges
Date: Fri,  7 Aug 2009 14:57:39 -0400
Message-Id: <1249671461-9071-3-git-send-email-jlayton@redhat.com>
In-Reply-To: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
References: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If fiemap_check_ranges is passed a large enough value, then it's
possible that the value would be cast to a signed value for comparison
against s_maxbytes when we change it to loff_t. Make sure that doesn't
happen by explicitly casting s_maxbytes to an unsigned value for the
purposes of comparison.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/ioctl.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 5612880..7b17a14 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -162,20 +162,21 @@ EXPORT_SYMBOL(fiemap_check_flags);
 static int fiemap_check_ranges(struct super_block *sb,
 			       u64 start, u64 len, u64 *new_len)
 {
+	u64 maxbytes = (u64) sb->s_maxbytes;
+
 	*new_len = len;
 
 	if (len == 0)
 		return -EINVAL;
 
-	if (start > sb->s_maxbytes)
+	if (start > maxbytes)
 		return -EFBIG;
 
 	/*
 	 * Shrink request scope to what the fs can actually handle.
 	 */
-	if ((len > sb->s_maxbytes) ||
-	    (sb->s_maxbytes - len) < start)
-		*new_len = sb->s_maxbytes - start;
+	if (len > maxbytes || (maxbytes - len) < start)
+		*new_len = maxbytes - start;
 
 	return 0;
 }
-- 
1.6.0.6

