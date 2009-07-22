Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbZGVKQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbZGVKQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 06:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbZGVKOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 06:14:54 -0400
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:40236 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbZGVKKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 06:10:48 -0400
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [RFC v17][PATCH 13/60] pids 3/7: Add target_pid parameter to alloc_pidmap()
Date: Wed, 22 Jul 2009 05:59:35 -0400
Message-Id: <1248256822-23416-14-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1248256822-23416-1-git-send-email-orenl@librato.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

With support for setting a specific pid number for a process,
alloc_pidmap() will need a paramter a 'target_pid' parameter.

Changelog[v2]:
	- (Serge Hallyn) Check for 'pid < 0' in set_pidmap().(Code
	  actually checks for 'pid <= 0' for completeness).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/pid.c |   28 ++++++++++++++++++++++++++--
 1 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index 9c678ce..29cf119 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -147,11 +147,35 @@ static int alloc_pidmap_page(struct pidmap *map)
 	return 0;
 }
 
-static int alloc_pidmap(struct pid_namespace *pid_ns)
+static int set_pidmap(struct pid_namespace *pid_ns, int pid)
+{
+	int offset;
+	struct pidmap *map;
+
+	if (pid <= 0 || pid >= pid_max)
+		return -EINVAL;
+
+	offset = pid & BITS_PER_PAGE_MASK;
+	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
+
+	if (alloc_pidmap_page(map))
+		return -ENOMEM;
+
+	if (test_and_set_bit(offset, map->page))
+		return -EBUSY;
+
+	atomic_dec(&map->nr_free);
+	return pid;
+}
+
+static int alloc_pidmap(struct pid_namespace *pid_ns, int target_pid)
 {
 	int i, rc, offset, max_scan, pid, last = pid_ns->last_pid;
 	struct pidmap *map;
 
+	if (target_pid)
+		return set_pidmap(pid_ns, target_pid);
+
 	pid = last + 1;
 	if (pid >= pid_max)
 		pid = RESERVED_PIDS;
@@ -270,7 +294,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		nr = alloc_pidmap(tmp, 0);
 		if (nr < 0)
 			goto out_free;
 
-- 
1.6.0.4

