Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0BXHOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:14:54 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:65317 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab0BXHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:14:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=XRoY9nynHLe4FwmOZiX/6Fx1D2ekEWS9HXH/AomPJ2SD6n08byxqjEjW3XYLQZ/jJl
         7HH0YwU+zzQx5qC3lpeTJnAPcvV8/EQHpvTfCn0U7punqBgoTEAIUfaEtKnEfU1LtUzc
         3LnemNe7Y1MDJOzCFvjKd3AVvhiKmWsgslCHo=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E . Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 2/6] mqueue: apply mathematics distributivity on mq_bytes calculation
Date: Tue, 23 Feb 2010 04:04:24 -0300
Message-Id: <48820fc21af54fc7c3225ce7a1116126453237c5.1266907496.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.7.0.87.g0901d
In-Reply-To: <cover.1266907495.git.andre.goddard@gmail.com>
References: <cover.1266907495.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code size reduction:
   text    data     bss     dec     hex filename
   9941      72      16   10029    272d ipc/mqueue-BEFORE.o
   9925      72      16   10013    271d ipc/mqueue-AFTER.o

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
---
 ipc/mqueue.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 2d76647..04403fd 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -261,8 +261,9 @@ static void mqueue_delete_inode(struct inode *inode)
 
 	clear_inode(inode);
 
-	mq_bytes = (info->attr.mq_maxmsg * sizeof(struct msg_msg *) +
-		   (info->attr.mq_maxmsg * info->attr.mq_msgsize));
+	/* Total amount of bytes accounted for the mqueue */
+	mq_bytes = info->attr.mq_maxmsg * (sizeof(struct msg_msg *)
+	    + info->attr.mq_msgsize);
 	user = info->user;
 	if (user) {
 		spin_lock(&mq_lock);
@@ -601,8 +602,8 @@ static int mq_attr_ok(struct ipc_namespace *ipc_ns, struct mq_attr *attr)
 	/* check for overflow */
 	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
 		return 0;
-	if ((unsigned long)(attr->mq_maxmsg * attr->mq_msgsize) +
-	    (attr->mq_maxmsg * sizeof (struct msg_msg *)) <
+	if ((unsigned long)(attr->mq_maxmsg * (attr->mq_msgsize
+	    + sizeof (struct msg_msg *))) <
 	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
 		return 0;
 	return 1;
-- 
1.7.0.87.g0901d

