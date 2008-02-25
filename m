Return-Path: <linux-kernel-owner+w=401wt.eu-S1759087AbYBYFz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087AbYBYFz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYBYFza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:55:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51723 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbYBYFz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:55:27 -0500
Message-ID: <47C257EB.5060600@cn.fujitsu.com>
Date: Mon, 25 Feb 2008 13:53:47 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: [PATCH] cgroup: fix default notify_on_release setting
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation says the default value of notify_on_release of
a child cgroup is inherited from its parent, which is reasonable,
but the implementation just sets the flag disabled.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d8abe99..e9c2fb0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2232,7 +2232,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	mutex_lock(&cgroup_mutex);
 
-	cgrp->flags = 0;
 	INIT_LIST_HEAD(&cgrp->sibling);
 	INIT_LIST_HEAD(&cgrp->children);
 	INIT_LIST_HEAD(&cgrp->css_sets);
@@ -2242,6 +2241,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	cgrp->root = parent->root;
 	cgrp->top_cgroup = parent->top_cgroup;
 
+	if (notify_on_release(parent))
+		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
+
 	for_each_subsys(root, ss) {
 		struct cgroup_subsys_state *css = ss->create(ss, cgrp);
 		if (IS_ERR(css)) {
-- 
1.5.4.rc3

