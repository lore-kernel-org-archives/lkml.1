Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYHYCX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYHYCX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 22:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYHYCXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 22:23:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51658 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbYHYCXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 22:23:18 -0400
Message-ID: <48B21756.4020208@cn.fujitsu.com>
Date: Mon, 25 Aug 2008 10:22:14 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] devcgroup: use kmemdup()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This saves 40 bytes on my x86_32 box.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 security/device_cgroup.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 46f2397..9c625f6 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -84,13 +84,9 @@ static int dev_whitelist_copy(struct list_head *dest, struct list_head *orig)
 	struct dev_whitelist_item *wh, *tmp, *new;
 
 	list_for_each_entry(wh, orig, list) {
-		new = kmalloc(sizeof(*wh), GFP_KERNEL);
+		new = kmemdup(wh, sizeof(*wh), GFP_KERNEL);
 		if (!new)
 			goto free_and_exit;
-		new->major = wh->major;
-		new->minor = wh->minor;
-		new->type = wh->type;
-		new->access = wh->access;
 		list_add_tail(&new->list, dest);
 	}
 
@@ -114,11 +110,10 @@ static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
 {
 	struct dev_whitelist_item *whcopy, *walk;
 
-	whcopy = kmalloc(sizeof(*whcopy), GFP_KERNEL);
+	whcopy = kmemdup(wh, sizeof(*wh), GFP_KERNEL);
 	if (!whcopy)
 		return -ENOMEM;
 
-	memcpy(whcopy, wh, sizeof(*whcopy));
 	spin_lock(&dev_cgroup->lock);
 	list_for_each_entry(walk, &dev_cgroup->whitelist, list) {
 		if (walk->type != wh->type)
-- 
1.5.4.rc3
