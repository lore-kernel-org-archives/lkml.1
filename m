Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXCEU6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXCEU6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933228AbXCEU6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:11 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46841 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbXCEU6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:08 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 02/11] uml - hostfs: fix double free
Date: Mon, 05 Mar 2007 21:49:00 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204900.9072.7418.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25KwfZJ008277

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Fix double free in the error path - when name is assigned into root_inode we do
not own it any more and we must not kfree() it - see patch for details.

Thanks to William Stearns for the initial report.

CC: William Stearns <wstearns@pobox.com>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 fs/hostfs/hostfs_kern.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index e965eb1..6f10e43 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -966,6 +966,9 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
 		goto out_put;
 
 	HOSTFS_I(root_inode)->host_filename = name;
+	/* Avoid that in the error path, iput(root_inode) frees again name through
+	 * hostfs_destroy_inode! */
+	name = NULL;
 
 	err = -ENOMEM;
 	sb->s_root = d_alloc_root(root_inode);
@@ -977,7 +980,7 @@ static int hostfs_fill_sb_common(struct super_block *sb, void *d, int silent)
                 /* No iput in this case because the dput does that for us */
                 dput(sb->s_root);
                 sb->s_root = NULL;
-		goto out_free;
+		goto out;
         }
 
 	return(0);


