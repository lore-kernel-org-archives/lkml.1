Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbYLSV7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbYLSV7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbYLSVyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:54:37 -0500
Received: from mx1.suse.de ([195.135.220.2]:57995 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbYLSVyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:54:36 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Tao Ma <tao.ma@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 16/45] ocfs2/xattr: Only extend xattr bucket in need.
Date: Fri, 19 Dec 2008 13:53:35 -0800
Message-Id: <1229723644-13630-17-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
References: <1229723644-13630-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <tao.ma@oracle.com>

When the first block of a bucket is filled up with xattr
entries, we normally extend the bucket. But if we are
just replace one xattr with small length, we don't need
to extend it. This is important since we will calculate
what we need before the transaction and in this situation
no resources will be allocated.

Signed-off-by: Tao Ma <tao.ma@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 fs/ocfs2/xattr.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index d8fc714..4501c63 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -4564,7 +4564,9 @@ try_again:
 	     free, need, max_free, le16_to_cpu(xh->xh_free_start),
 	     le16_to_cpu(xh->xh_name_value_len));
 
-	if (free < need || count == ocfs2_xattr_max_xe_in_bucket(inode->i_sb)) {
+	if (free < need ||
+	    (xs->not_found &&
+	     count == ocfs2_xattr_max_xe_in_bucket(inode->i_sb))) {
 		if (need <= max_free &&
 		    count < ocfs2_xattr_max_xe_in_bucket(inode->i_sb)) {
 			/*
-- 
1.5.6

