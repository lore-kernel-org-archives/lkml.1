Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbYFDMKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbYFDMKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbYFDMJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:09:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:42730 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759715AbYFDMJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=TtLJIhjc63AT0pA7d5ldbww4m5ph51ESFMq8/Lk8uEaf1lvtvF8bFlMUYfcCC+04pb
         +a9WCDTGlzhkf6XKRwkI2yNjsaOB37Q67/ZkamhOaDqbYHFDvczcpjWujqAOVeI3k12+
         naECWsSM3ArCNO3raJLbMizvtgn2/q0XNjdLY=
Message-Id: <20080604115711.088785233@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:35 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>,
       ocfs2-devel@oss.oracle.com
Subject: [patch -v3 02/22] ocfs2: use simple_read_from_buffer
Content-Disposition: inline; filename=ocfs2-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <joel.becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com 
---
 fs/ocfs2/stack_user.c |   19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

Index: 2.6-git/fs/ocfs2/stack_user.c
===================================================================
--- 2.6-git.orig/fs/ocfs2/stack_user.c
+++ 2.6-git/fs/ocfs2/stack_user.c
@@ -549,26 +549,17 @@ static ssize_t ocfs2_control_read(struct
 				  size_t count,
 				  loff_t *ppos)
 {
-	char *proto_string = OCFS2_CONTROL_PROTO;
-	size_t to_write = 0;
+	ssize_t ret;
 
-	if (*ppos >= OCFS2_CONTROL_PROTO_LEN)
-		return 0;
-
-	to_write = OCFS2_CONTROL_PROTO_LEN - *ppos;
-	if (to_write > count)
-		to_write = count;
-	if (copy_to_user(buf, proto_string + *ppos, to_write))
-		return -EFAULT;
-
-	*ppos += to_write;
+	ret = simple_read_from_buffer(buf, count, ppos,
+			OCFS2_CONTROL_PROTO, OCFS2_CONTROL_PROTO_LEN);
 
 	/* Have we read the whole protocol list? */
-	if (*ppos >= OCFS2_CONTROL_PROTO_LEN)
+	if (ret > 0 && *ppos >= OCFS2_CONTROL_PROTO_LEN)
 		ocfs2_control_set_handshake_state(file,
 						  OCFS2_CONTROL_HANDSHAKE_READ);
 
-	return to_write;
+	return ret;
 }
 
 static int ocfs2_control_release(struct inode *inode, struct file *file)

-- 
