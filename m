Return-Path: <linux-kernel-owner+w=401wt.eu-S1755453AbZJABB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453AbZJABB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 21:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755398AbZJABB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 21:01:56 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.104]:44292
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755332AbZJABBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 21:01:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKScw0rLO7dJ/2dsb2JhbADXX4QnBIFNVg
X-IronPort-AV: E=Sophos;i="4.44,483,1249228800"; 
   d="scan'208";a="469718531"
From: Ian Kent <raven@themaw.net>
Subject: [PATCH 09/10] autofs4 - rename dentry to expiring in
	autofs4_lookup_expiring()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Sage Weil <sage@newdream.net>, Al Viro <viro@ZenIV.linux.org.uk>,
       Andreas Dilger <adilger@sun.com>, Christoph Hellwig <hch@infradead.org>,
       Yehuda Saheh <yehuda@newdream.net>
Date: Thu, 01 Oct 2009 09:01:54 +0800
Message-ID: <20091001010154.7675.25462.stgit@zeus.themaw.net>
In-Reply-To: <20091001010054.7675.77673.stgit@zeus.themaw.net>
References: <20091001010054.7675.77673.stgit@zeus.themaw.net>
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

