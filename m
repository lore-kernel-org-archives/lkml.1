Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYBRFwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYBRFwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 00:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYBRFvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 00:51:19 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49887 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbYBRFvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 00:51:15 -0500
Message-ID: <47B91C7F.6080602@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 13:49:51 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org
Subject: [PATCH 4/7] cgroup: fix memory leak in cgroup_get_sb()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

opts.release_agent is not kfree()ed in all necessary places.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0c35022..aa76bbd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -961,8 +961,11 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 	}
 
 	root = kzalloc(sizeof(*root), GFP_KERNEL);
-	if (!root)
+	if (!root) {
+		if (opts.release_agent)
+			kfree(opts.release_agent);
 		return -ENOMEM;
+	}
 
 	init_cgroup_root(root);
 	root->subsys_bits = opts.subsys_bits;
-- 
1.5.4.rc3

