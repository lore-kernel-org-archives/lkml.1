Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZGUK0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZGUK0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:26:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZGUK0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:26:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51598 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675AbZGUK0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:26:12 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: menage@google.com, lizf@cn.fujitsu.com,
       containers@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] cgroup: fix reverse unlock sequence in cgroup_get_sb
Date: Tue, 21 Jul 2009 18:25:26 +0800
Message-Id: <1248171926-20232-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cgroup_get_sb, the lock sequence is:
	mutex_lock(&inode->i_mutex);
	mutex_lock(&cgroup->mutex);
so the last unlock sequence should be:
	mutex_unlock(&cgroup->mutex);
	mutex_unlock(&inode->i_mutex);

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 kernel/cgroup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3737a68..11ef162 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1140,8 +1140,8 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
 		BUG_ON(root->number_of_cgroups != 1);
 
 		cgroup_populate_dir(root_cgrp);
-		mutex_unlock(&inode->i_mutex);
 		mutex_unlock(&cgroup_mutex);
+		mutex_unlock(&inode->i_mutex);
 	}
 
 	simple_set_mnt(mnt, sb);
-- 
1.6.2.5

