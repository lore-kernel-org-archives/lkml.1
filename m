Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZJABBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZJABBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 21:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZJABBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 21:01:16 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:43843
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755341AbZJABBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 21:01:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKScw0rLO7dJ/2dsb2JhbADXX4QnBIFNVg
X-IronPort-AV: E=Sophos;i="4.44,483,1249228800"; 
   d="scan'208";a="469718237"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 03/10] autofs4 - use macro for need mount check
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Sage Weil <sage@newdream.net>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andreas Dilger <adilger@sun.com>, Christoph Hellwig <hch@infradead.org>,
       Yehuda Saheh <yehuda@newdream.net>
Date: Thu, 01 Oct 2009 09:01:14 +0800
Message-ID: <20091001010114.7675.89191.stgit@zeus.themaw.net>
In-Reply-To: <20091001010054.7675.77673.stgit@zeus.themaw.net>
References: <20091001010054.7675.77673.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define simple macro function for checking if we need to trigger
a mount.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/root.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 2954ac5..f6e8ca9 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -104,6 +104,14 @@ static void autofs4_del_active(struct dentry *dentry)
 	return;
 }
 
+static unsigned int autofs4_need_mount(unsigned int flags)
+{
+	unsigned int res = 0;
+	if (flags & (TRIGGER_FLAGS | TRIGGER_INTENTS))
+		res = 1;
+	return res;
+}
+
 static int autofs4_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
@@ -168,7 +176,7 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
 		}
 	/* Trigger mount for path component or follow link */
 	} else if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
-			flags & (TRIGGER_FLAGS | TRIGGER_INTENTS) ||
+			autofs4_need_mount(flags) ||
 			current->link_count) {
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
@@ -234,7 +242,7 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 	autofs4_expire_wait(dentry);
 
 	/* We trigger a mount for almost all flags */
-	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
+	lookup_type = autofs4_need_mount(nd->flags);
 	if (!(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
 		goto follow;
 

