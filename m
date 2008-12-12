Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYLLVxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYLLVxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYLLVv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:51:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55974 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbYLLVv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:51:57 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 04/14] fsnotify: use the new open-exec hook for
	inotify and dnotify
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:51:35 -0500
Message-ID: <20081212215135.27112.64080.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
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
index ffe787f..6fbf455 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -172,6 +172,12 @@ static inline void fsnotify_modify(struct file *file)
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

