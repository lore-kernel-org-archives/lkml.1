Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbYLOQpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbYLOQpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYLOQod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:44:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48635 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755677AbYLOQoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:44:22 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] fsnotify: use the new open-exec hook for inotify and
	dnotify
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, akpm@linux-foundation.org
Date: Mon, 15 Dec 2008 11:44:19 -0500
Message-ID: <20081215164419.2018.11097.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com>
References: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inotify and dnotify did not get access events when their children were
accessed for shlib or exec purposes.  Trigger on those events as well.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fsnotify.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 88265dd..a7122c6 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -170,6 +170,12 @@ static inline void fsnotify_modify(struct dentry *dentry)
  */
 static inline void fsnotify_open_exec(struct file *file)
 {
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+
+	dnotify_parent(dentry, DN_ACCESS);
+	inotify_dentry_parent_queue_event(dentry, IN_ACCESS, 0, dentry->d_name.name);
+	inotify_inode_queue_event(inode, IN_ACCESS, 0, NULL, NULL);
 }
 
 /*

