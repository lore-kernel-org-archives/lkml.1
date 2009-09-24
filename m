Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbZIXIbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbZIXIbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZIXIbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:31:33 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:1113
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbZIXIb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:31:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAMvIukrLO0En/2dsb2JhbADWL4QbBYFYZQ
X-IronPort-AV: E=Sophos;i="4.44,444,1249228800"; 
   d="scan'208";a="468142852"
From: Ian Kent <raven@themaw.net>
Subject: [RFC PATCH 08/11] autofs4 - eliminate d_unhashed in path walk checks
To: Sage Weil <sage@newdream.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       Andreas Dilger <adilger@sun.com>, Yehuda Saheh <yehuda@newdream.net>,
       Jim Garlick <garlick@llnl.gov>
Date: Thu, 24 Sep 2009 16:22:12 +0800
Message-ID: <20090924082212.22151.76953.stgit@zeus.themaw.net>
In-Reply-To: <20090924082036.22151.85151.stgit@zeus.themaw.net>
References: <20090924082036.22151.85151.stgit@zeus.themaw.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We unhash the dentry (in a subsequent patch) in ->d_revalidate() in
order to send mount requests to ->lookup(). But then we can not rely
on d_unhased() to give reliable results because it may be called at
any time by any code path. The d_unhashed() function is used by
__simple_empty() in the path walking callbacks but autofs mount
point dentrys should have no directories at all so a list_empty()
on d_subdirs should be (and is) sufficient.

Signed-off-by: Ian Kent <raven@themaw.net>
---

 fs/autofs4/root.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 81700f4..b6530f3 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -133,7 +133,7 @@ static int autofs4_dir_open(struct inode *inode, struct file *file)
 	 * it.
 	 */
 	spin_lock(&dcache_lock);
-	if (!d_mountpoint(dentry) && __simple_empty(dentry)) {
+	if (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
 		spin_unlock(&dcache_lock);
 		return -ENOENT;
 	}
@@ -257,7 +257,7 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
 	 * mount it again.
 	 */
 	if (ino->flags & AUTOFS_INF_PENDING ||
-	    (!d_mountpoint(dentry) && __simple_empty(dentry))) {
+	    (!d_mountpoint(dentry) && list_empty(&dentry->d_subdirs))) {
 		spin_unlock(&dcache_lock);
 		spin_unlock(&sbi->fs_lock);
 
@@ -340,8 +340,7 @@ static int autofs4_revalidate(struct dentry *dentry, struct nameidata *nd)
 	/* Check for a non-mountpoint directory with no contents */
 	spin_lock(&dcache_lock);
 	if (S_ISDIR(dentry->d_inode->i_mode) &&
-	    !d_mountpoint(dentry) && 
-	    __simple_empty(dentry)) {
+	    !d_mountpoint(dentry) && list_empty(&dentry->d_subdirs)) {
 		DPRINTK("dentry=%p %.*s, emptydir",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
 		spin_unlock(&dcache_lock);

