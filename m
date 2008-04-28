Return-Path: <linux-kernel-owner+w=401wt.eu-S935111AbYD1VNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935111AbYD1VNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935798AbYD1VNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:13:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:42327 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935464AbYD1VNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CebbixnT1dipvNd9kqXdJqs+7/zm/tKi8TzQQ6oX9zPEO5lqWpRygN451FXR2rQ+UrwLHgIZz9nj1a3ZOOLfKbA3Z7nNfkdHz+00LnpTItAGX6cuP1wRT5ILZaIAPPnFmoe50U2+OTdfBbLQ7NsV6OxcypAH+7N2alH6H7oyYsE=
Subject: [PATCH 2/4] kernel: fix integer as NULL pointer warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 14:13:19 -0700
Message-Id: <1209417199.14173.101.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/cpuset.c:1268:52: warning: Using plain integer as NULL pointer
kernel/pid_namespace.c:95:24: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/cpuset.c        |    3 ++-
 kernel/pid_namespace.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 024888b..48a976c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1265,7 +1265,8 @@ static ssize_t cpuset_common_file_write(struct cgroup *cont,
 		return -E2BIG;
 
 	/* +1 for nul-terminator */
-	if ((buffer = kmalloc(nbytes + 1, GFP_KERNEL)) == 0)
+	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
+	if (!buffer)
 		return -ENOMEM;
 
 	if (copy_from_user(buffer, userbuf, nbytes)) {
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 6d792b6..5ca37fa 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -92,7 +92,7 @@ static struct pid_namespace *create_pid_namespace(int level)
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
 
 	for (i = 1; i < PIDMAP_ENTRIES; i++) {
-		ns->pidmap[i].page = 0;
+		ns->pidmap[i].page = NULL;
 		atomic_set(&ns->pidmap[i].nr_free, BITS_PER_PAGE);
 	}
 
-- 
1.5.5.1.270.g89765


