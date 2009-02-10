Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZBJJcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZBJJcT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 04:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbZBJJcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 04:32:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59403 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751212AbZBJJcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 04:32:09 -0500
Message-ID: <4991497B.4030200@cn.fujitsu.com>
Date: Tue, 10 Feb 2009 17:31:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: fix possible use after free
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cgroup_kill_sb(), root is freed before sb is detached from the list,
so another sget() may find this sb and call cgroup_test_super(),
which will access the root that has been freed.

Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5a54ff4..42fd3f2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1122,8 +1122,8 @@ static void cgroup_kill_sb(struct super_block *sb) {
 
 	mutex_unlock(&cgroup_mutex);
 
-	kfree(root);
 	kill_litter_super(sb);
+	kfree(root);
 }
 
 static struct file_system_type cgroup_fs_type = {
-- 
1.5.4.rc3
