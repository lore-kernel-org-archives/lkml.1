Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbZH1RUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbZH1RUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 13:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZH1RUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 13:20:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbZH1RUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 13:20:15 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 3/3] inotify: update the group mask on mark addition
To: linux-kernel@vger.kernel.org
Date: Fri, 28 Aug 2009 13:20:17 -0400
Message-ID: <20090828172017.24585.24644.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090828172004.24585.14234.stgit@paris.rdu.redhat.com>
References: <20090828172004.24585.14234.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seperating the addition and update of marks in inotify resulted in a
regression in that inotify never gets events.  The inotify group mask is
always 0.  This mask should be updated any time a new mark is added.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/inotify/inotify_user.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index 6111670..dcd2040 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -591,6 +591,10 @@ retry:
 	/* match the ref from fsnotify_init_markentry() */
 	fsnotify_put_mark(&tmp_ientry->fsn_entry);
 
+	/* if this mark added a new event update the group mask */
+	if (mask & ~group->mask)
+		fsnotify_recalc_group_mask(group);
+
 out_err:
 	if (ret < 0)
 		kmem_cache_free(inotify_inode_mark_cachep, tmp_ientry);

