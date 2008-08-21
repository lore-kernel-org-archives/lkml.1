Return-Path: <linux-kernel-owner+w=401wt.eu-S1756831AbYHUHSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbYHUHSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYHUHSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:18:07 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:20595 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757325AbYHUHSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:18:05 -0400
Subject: [patch for 2.6.27? 1/1] nfs: BUG_ON in nfs_follow_mountpoint
	(Trond's comment fixed)
From: "Denis V. Lunev" <den@openvz.org>
To: Trond.Myklebust@netapp.com
Cc: bfields@fieldses.org, akpm@linux-foundation.org, den@openvz.org,
       LKML <linux-kernel@vger.kernel.org>
X-Greylist: IP, sender and recipient auto-whitelisted, not delayed by
	milter-greylist-2.0.2 (vzorg.swsoft.net [64.131.90.7]); Wed, 20 Aug 2008
	20:16:12 -0400 (EDT)
Content-Type: text/plain
Organization: OpenVz kernel team
Date: Thu, 21 Aug 2008 11:18:44 +0400
Message-Id: <1219303124.6621.8.camel@iris.sw.ru>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Denis V. Lunev" <den@openvz.org>

Unfortunately, BUG_ON(IS_ROOT(dentry)) can happen inside
nfs_follow_mountpoint with NFS running Fedora 8 using a specific setup.

See https://bugzilla.redhat.com/show_bug.cgi?id=458622

So the situation should be handled on NFS client gracefully.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/namespace.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/nfs/namespace.c~nfs-bug_on-in-nfs_follow_mountpoint fs/nfs/namespace.c
--- a/fs/nfs/namespace.c~nfs-bug_on-in-nfs_follow_mountpoint
+++ a/fs/nfs/namespace.c
@@ -105,7 +105,10 @@ static void * nfs_follow_mountpoint(stru
 
 	dprintk("--> nfs_follow_mountpoint()\n");
 
-	BUG_ON(IS_ROOT(dentry));
+	err = -EIO;
+	if (IS_ROOT(dentry))
+		goto out_err;
+
 	dprintk("%s: enter\n", __func__);
 	dput(nd->path.dentry);
 	nd->path.dentry = dget(dentry);
_

