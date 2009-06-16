Return-Path: <linux-kernel-owner+w=401wt.eu-S935991AbZFPFwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935991AbZFPFwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbZFPFux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:50:53 -0400
Received: from kroah.org ([198.145.64.141]:48293 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758982AbZFPFuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:50:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Armin Kuster <akuster@mvista.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/64] Sysfs: fix possible memleak in sysfs_follow_link
Date: Mon, 15 Jun 2009 22:45:53 -0700
Message-Id: <1245131213-24168-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Armin Kuster <akuster@mvista.com>

There is the possiblity of a memory leak if a page is allocated and if
sysfs_getlink() fails in the sysfs_follow_link.

Signed-off-by: Armin Kuster <akuster@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/symlink.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index a3ba217..1d897ad 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -192,8 +192,11 @@ static void *sysfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	int error = -ENOMEM;
 	unsigned long page = get_zeroed_page(GFP_KERNEL);
-	if (page)
+	if (page) {
 		error = sysfs_getlink(dentry, (char *) page); 
+		if (error < 0)
+			free_page((unsigned long)page);
+	}
 	nd_set_link(nd, error ? ERR_PTR(error) : (char *)page);
 	return NULL;
 }
-- 
1.6.3.2

