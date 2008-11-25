Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYKYRWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYKYRWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:22:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYKYRVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:21:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36576 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbYKYRVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:21:36 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 4/8] fsnotify: use the new open-exec hook for inotify and
	dnotify
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org,
       a.p.zijlstra@chello.nl
Date: Tue, 25 Nov 2008 12:21:12 -0500
Message-ID: <20081125172112.17115.47123.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
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

