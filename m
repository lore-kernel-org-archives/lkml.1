Return-Path: <linux-kernel-owner+w=401wt.eu-S1765602AbYD1GUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765602AbYD1GUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYD1GT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:19:56 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:48112 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbYD1GTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:19:55 -0400
X-Sasl-enc: +fcv5cEbt67GyMXsGrJiXOo9nvdH4Edaj/gUzaynsGI6 1209363593
Date: Mon, 28 Apr 2008 14:19:06 +0800 (WST)
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] autofs4 - fix compile warning in waitq.c:autofs4_expire_indirect()
Message-ID: <Pine.LNX.4.64.0804281417080.10684@raven.themaw.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

This patch re-orders some code in expire.c:autofs4_expire_indirect()
to avoid compile warning, reported by Harvey Harrison:

 CHECK   fs/autofs4/expire.c
fs/autofs4/expire.c:383:2: warning: context imbalance in
'autofs4_expire_indirect' - unexpected unlock

Signed-off-by: Ian Kent <raven@themaw.net>

---
diff -up linux-2.6.25-mm1/fs/autofs4/expire.c.cleanup-expire-indirect linux-2.6.25-mm1/fs/autofs4/expire.c
--- linux-2.6.25-mm1/fs/autofs4/expire.c.cleanup-expire-indirect	2008-04-28 11:38:55.000000000 +0800
+++ linux-2.6.25-mm1/fs/autofs4/expire.c	2008-04-28 11:39:17.000000000 +0800
@@ -333,7 +333,7 @@ static struct dentry *autofs4_expire_ind
 			/* Can we expire this guy */
 			if (autofs4_can_expire(dentry, timeout, do_now)) {
 				expired = dentry;
-				break;
+				goto found;
 			}
 			goto next;
 		}
@@ -352,7 +352,7 @@ static struct dentry *autofs4_expire_ind
 				inf->flags |= AUTOFS_INF_EXPIRING;
 				spin_unlock(&sbi->fs_lock);
 				expired = dentry;
-				break;
+				goto found;
 			}
 			spin_unlock(&sbi->fs_lock);
 		/*
@@ -363,7 +363,7 @@ static struct dentry *autofs4_expire_ind
 			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
 			if (expired) {
 				dput(dentry);
-				break;
+				goto found;
 			}
 		}
 next:
@@ -371,18 +371,16 @@ next:
 		spin_lock(&dcache_lock);
 		next = next->next;
 	}
-
-	if (expired) {
-		DPRINTK("returning %p %.*s",
-			expired, (int)expired->d_name.len, expired->d_name.name);
-		spin_lock(&dcache_lock);
-		list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
-		spin_unlock(&dcache_lock);
-		return expired;
-	}
 	spin_unlock(&dcache_lock);
-
 	return NULL;
+
+found:
+	DPRINTK("returning %p %.*s",
+		expired, (int)expired->d_name.len, expired->d_name.name);
+	spin_lock(&dcache_lock);
+	list_move(&expired->d_parent->d_subdirs, &expired->d_u.d_child);
+	spin_unlock(&dcache_lock);
+	return expired;
 }
 
 /* Perform an expiry operation */
