Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZIXIbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZIXIbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbZIXIbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:31:45 -0400
Received: from outbound.icp-qv1-irony-out5.iinet.net.au ([203.59.1.108]:8927
	"EHLO outbound.icp-qv1-irony-out5.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425AbZIXIbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:31:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAIPJukrLO0En/2dsb2JhbADWMIQbBYFYZQ
X-IronPort-AV: E=Sophos;i="4.44,444,1249228800"; 
   d="scan'208";a="39449309"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 10/11] autofs4 - rename dentry to expiring in
	autofs4_lookup_expiring()
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 24 Sep 2009 16:22:26 +0800
Message-ID: <20090924082226.22151.70892.stgit@zeus.themaw.net>
In-Reply-To: <20090924082036.22151.85151.stgit@zeus.themaw.net>
References: <20090924082036.22151.85151.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In autofs4_lookup_expiring() a declaration within the list traversal
loop uses a declaration that has the same name as the function
parameter.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/root.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index e8a8881..a015b49 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -474,23 +474,23 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 	head = &sbi->expiring_list;
 	list_for_each(p, head) {
 		struct autofs_info *ino;
-		struct dentry *dentry;
+		struct dentry *expiring;
 		struct qstr *qstr;
 
 		ino = list_entry(p, struct autofs_info, expiring);
-		dentry = ino->dentry;
+		expiring = ino->dentry;
 
-		spin_lock(&dentry->d_lock);
+		spin_lock(&expiring->d_lock);
 
 		/* Bad luck, we've already been dentry_iput */
-		if (!dentry->d_inode)
+		if (!expiring->d_inode)
 			goto next;
 
-		qstr = &dentry->d_name;
+		qstr = &expiring->d_name;
 
-		if (dentry->d_name.hash != hash)
+		if (expiring->d_name.hash != hash)
 			goto next;
-		if (dentry->d_parent != parent)
+		if (expiring->d_parent != parent)
 			goto next;
 
 		if (qstr->len != len)
@@ -498,15 +498,15 @@ static struct dentry *autofs4_lookup_expiring(struct dentry *dentry)
 		if (memcmp(qstr->name, str, len))
 			goto next;
 
-		if (d_unhashed(dentry)) {
-			dget(dentry);
-			spin_unlock(&dentry->d_lock);
+		if (d_unhashed(expiring)) {
+			dget(expiring);
+			spin_unlock(&expiring->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			spin_unlock(&dcache_lock);
-			return dentry;
+			return expiring;
 		}
 next:
-		spin_unlock(&dentry->d_lock);
+		spin_unlock(&expiring->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
 	spin_unlock(&dcache_lock);

