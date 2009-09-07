Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZIGVKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZIGVKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZIGVKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:10:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45858 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbZIGVKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:10:40 -0400
Date: Mon, 7 Sep 2009 14:15:06 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: serue@us.ibm.com, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com
Subject: [RFC][v5][PATCH 4/8]: Add target_pid parameter to alloc_pidmap()
Message-ID: <20090907211506.GD6685@us.ibm.com>
References: <20090907211302.GA5892@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907211302.GA5892@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: [RFC][v5][PATCH 4/8]: Add target_pid parameter to alloc_pidmap()

With support for setting a specific pid number for a process,
alloc_pidmap() will need a 'target_pid' parameter.

Changelog[v3]:
	- (Eric Biederman): Avoid set_pidmap() function. Added couple of
	  checks for target_pid in alloc_pidmap() itself.
Changelog[v2]:
	- (Serge Hallyn) Check for 'pid < 0' in set_pidmap().(Code
	  actually checks for 'pid <= 0' for completeness).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

Index: linux-mmotm/kernel/pid.c
===================================================================
--- linux-mmotm.orig/kernel/pid.c	2009-09-05 21:17:36.000000000 -0700
+++ linux-mmotm/kernel/pid.c	2009-09-05 21:19:11.000000000 -0700
@@ -146,16 +146,22 @@
 	return 0;
 }
 
-static int alloc_pidmap(struct pid_namespace *pid_ns)
+static int alloc_pidmap(struct pid_namespace *pid_ns, int target_pid)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
 	int rc = -EAGAIN;
 	int pid_max = pid_ns->pid_max;
 	struct pidmap *map;
 
-	pid = last + 1;
-	if (pid >= pid_max)
-		pid = RESERVED_PIDS;
+	if (target_pid) {
+		pid = target_pid;
+		if (pid < 0 || pid >= pid_max)
+			return -EINVAL;
+	} else {
+		pid = last + 1;
+		if (pid >= pid_max)
+			pid = RESERVED_PIDS;
+	}
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
 	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
@@ -168,9 +174,14 @@
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
+					if (!target_pid)
+						pid_ns->last_pid = pid;
 					return pid;
+				} else if (target_pid) {
+					rc = -EBUSY;
+					break;
 				}
+
 				offset = find_next_offset(map, offset);
 				pid = mk_pid(pid_ns, map, offset);
 			/*
@@ -196,6 +207,7 @@
 		}
 		pid = mk_pid(pid_ns, map, offset);
 	}
+
 	return rc;
 }
 
@@ -272,7 +284,7 @@
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		nr = alloc_pidmap(tmp, 0);
 		if (nr < 0)
 			goto out_free;
 
