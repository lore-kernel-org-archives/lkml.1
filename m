Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157AbZIJGbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157AbZIJGbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 02:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZIJGbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 02:31:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54427 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431AbZIJGbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 02:31:43 -0400
Date: Wed, 9 Sep 2009 23:09:55 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       container@us.ibm.com, sukadev@us.ibm.com
Subject: [RFC][v6][PATCH 4/9]: Add target_pid parameter to alloc_pidmap()
Message-ID: <20090910060955.GC25883@us.ibm.com>
References: <20090910060627.GA24343@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910060627.GA24343@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: [RFC][v6][PATCH 4/9]: Add target_pid parameter to alloc_pidmap()

With support for setting a specific pid number for a process,
alloc_pidmap() will need a 'target_pid' parameter.

Changelog[v3]:
	- (Eric Biederman): Avoid set_pidmap() function. Added couple of
	  checks for target_pid in alloc_pidmap() itself.
Changelog[v2]:
	- (Serge Hallyn) Check for 'pid < 0' in set_pidmap().(Code
	  actually checks for 'pid <= 0' for completeness).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 kernel/pid.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/pid.c
===================================================================
--- linux-2.6.orig/kernel/pid.c	2009-09-09 19:07:20.000000000 -0700
+++ linux-2.6/kernel/pid.c	2009-09-09 19:07:28.000000000 -0700
@@ -146,16 +146,22 @@ static int alloc_pidmap_page(struct pidm
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
@@ -168,9 +174,14 @@ static int alloc_pidmap(struct pid_names
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
@@ -196,6 +207,7 @@ static int alloc_pidmap(struct pid_names
 		}
 		pid = mk_pid(pid_ns, map, offset);
 	}
+
 	return rc;
 }
 
@@ -272,7 +284,7 @@ struct pid *alloc_pid(struct pid_namespa
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		nr = alloc_pidmap(tmp, 0);
 		if (nr < 0)
 			goto out_free;
 
