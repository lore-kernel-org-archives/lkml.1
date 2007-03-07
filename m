Return-Path: <linux-kernel-owner+w=401wt.eu-S965398AbXCGRZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965398AbXCGRZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422877AbXCGRSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:18:00 -0500
Received: from ns1.suse.de ([195.135.220.2]:44349 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422890AbXCGRRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:17:53 -0500
Message-Id: <20070307171615.690359618@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, ericvh@gmail.com,
       bunk@stusta.de
Subject: [patch 084/101] v9fs_vfs_mkdir(): fix a double free
Content-Disposition: inline; filename=v9fs_vfs_mkdir-fix-a-double-free.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Adrian Bunk <bunk@stusta.de>

Fix a double free of "dfid" introduced by commit
da977b2c7eb4d6312f063a7b486f2aad99809710 and spotted by the Coverity
checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 fs/9p/vfs_inode.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- linux-2.6.20.1.orig/fs/9p/vfs_inode.c
+++ linux-2.6.20.1/fs/9p/vfs_inode.c
@@ -585,17 +585,14 @@ static int v9fs_vfs_mkdir(struct inode *
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		inode = NULL;
-		goto clean_up_fids;
+		v9fs_fid_destroy(vfid);
+		goto error;
 	}
 
 	dentry->d_op = &v9fs_dentry_operations;
 	d_instantiate(dentry, inode);
 	return 0;
 
-clean_up_fids:
-	if (vfid)
-		v9fs_fid_destroy(vfid);
-
 clean_up_dfid:
 	v9fs_fid_clunk(v9ses, dfid);
 

--
