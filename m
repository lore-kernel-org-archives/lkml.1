Return-Path: <linux-kernel-owner+w=401wt.eu-S1754821AbYGRDS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbYGRDS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 23:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbYGRDSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 23:18:50 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:43260
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994AbYGRDSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 23:18:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAAyof0jLO9AP/2dsb2JhbACvbA
X-IronPort-AV: E=Sophos;i="4.31,207,1215360000"; 
   d="scan'208";a="343565796"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH] autofs4 - fix direct mount pending expire race - correction
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 18 Jul 2008 11:14:54 +0800
Message-ID: <20080718031453.12148.79135.stgit@raven.themaw.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Appologies, somehow I seem to have sent an out dated version of this
patch. Here is an additional patch that brings the patch up to date.

Signed-off-by: Ian Kent <raven@themaw.net>

---

 fs/autofs4/root.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)


diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index b1536c1..7a7ed94 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -190,13 +190,7 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 			/* Follow down to our covering mount. */
 			if (!follow_down(&nd->path.mnt, &nd->path.dentry))
 				goto done;
-			/*
-			 * We shouldn't need to do this but we have no way
-			 * of knowing what may have been done so try a follow
-			 * just in case.
-			 */
-			autofs4_follow_mount(&nd->path.mnt, &nd->path.dentry);
-			goto done;
+			goto follow;
 		}
 		spin_unlock(&sbi->fs_lock);
 		goto done;
@@ -208,7 +202,7 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 	/* We trigger a mount for almost all flags */
 	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
 	if (!(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
-		goto done;
+		goto follow;
 
 	/*
 	 * If the dentry contains directories then it is an autofs
