Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab0CBWMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 17:12:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab0CBWLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 17:11:44 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Valerie Aurora <vaurora@redhat.com>
Subject: [PATCH 5/6] union-mount: Call do_whiteout() on unlink and rmdir in unions
Date: Tue,  2 Mar 2010 14:11:28 -0800
Message-Id: <1267567889-4637-6-git-send-email-vaurora@redhat.com>
In-Reply-To: <1267567889-4637-5-git-send-email-vaurora@redhat.com>
References: <1267567889-4637-1-git-send-email-vaurora@redhat.com>
 <1267567889-4637-2-git-send-email-vaurora@redhat.com>
 <1267567889-4637-3-git-send-email-vaurora@redhat.com>
 <1267567889-4637-4-git-send-email-vaurora@redhat.com>
 <1267567889-4637-5-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Call do_whiteout() when removing files and directories from a union
mounted file system.

Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namei.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 85d95fc..9797074 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2670,6 +2670,10 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	error = mnt_want_write(nd.path.mnt);
 	if (error)
 		goto exit3;
+	if (IS_UNIONED_DIR(&nd.path)) {
+		error = do_whiteout(&nd, &path, 1);
+		goto exit4;
+	}
 	error = security_path_rmdir(&nd.path, path.dentry);
 	if (error)
 		goto exit4;
@@ -2758,6 +2762,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 		error = mnt_want_write(nd.path.mnt);
 		if (error)
 			goto exit2;
+		if (IS_UNIONED_DIR(&nd.path)) {
+			error = do_whiteout(&nd, &path, 0);
+			goto exit3;
+		}
 		error = security_path_unlink(&nd.path, path.dentry);
 		if (error)
 			goto exit3;
-- 
1.5.6.5

