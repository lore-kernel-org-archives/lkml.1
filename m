Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbZIXIWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbZIXIWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbZIXIWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:22:22 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:36167
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752234AbZIXIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:22:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMvIukrLO0En/2dsb2JhbADWL4QbBYFYZQ
X-IronPort-AV: E=Sophos;i="4.44,444,1249228800"; 
   d="scan'208";a="505927144"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 04/11] autofs4 - use macro for need mount check
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 24 Sep 2009 16:21:45 +0800
Message-ID: <20090924082145.22151.45599.stgit@zeus.themaw.net>
In-Reply-To: <20090924082036.22151.85151.stgit@zeus.themaw.net>
References: <20090924082036.22151.85151.stgit@zeus.themaw.net>
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
 

