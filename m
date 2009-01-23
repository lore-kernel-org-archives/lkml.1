Return-Path: <linux-kernel-owner+w=401wt.eu-S1758666AbZAWAtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666AbZAWAtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 19:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZAWAt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 19:49:27 -0500
Received: from smtp-out.google.com ([216.239.45.13]:19194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbZAWAtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 19:49:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=OAibRAXySRhAqprmaWbaOEJqD/PcBVLh+mmTUsx8x4ZBqf0mSYgXsmplKM3OBKfI3
	mHx5HtZrUWMm/CTb8hYNA==
From: Paul Menage <menage@google.com>
Subject: [PATCH] cgroup: Fix root_count when mount fails due to busy subsystem
To: akpm@linux-foundation.org, serue@us.ibm.com
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org
Date: Thu, 22 Jan 2009 16:48:41 -0800
Message-ID: <20090123004703.25103.29754.stgit@menage.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.75
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup: Fix root_count when mount fails due to busy subsystem

root_count was being incremented in cgroup_get_sb() after all error
checking was complete, but decremented in cgroup_kill_sb(), which can
be called on a superblock that we gave up on due to an error.  This
patch changes cgroup_kill_sb() to only decrement root_count if the
root was previously linked into the list of roots.

Signed-off-by: Paul Menage <menage@google.com>

---

I was actually surprised to find that list_del() doesn't crash when
run on an unattached list_head structure.

 kernel/cgroup.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index adcd0bb..9ce27e8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1115,8 +1115,10 @@ static void cgroup_kill_sb(struct super_block *sb) {
 	}
 	write_unlock(&css_set_lock);
 
-	list_del(&root->root_list);
-	root_count--;
+	if (!list_empty(&root->root_list)) {
+		list_del(&root->root_list);
+		root_count--;
+	}
 
 	mutex_unlock(&cgroup_mutex);
 

