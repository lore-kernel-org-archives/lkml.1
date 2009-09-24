Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbZIXRCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbZIXRCz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZIXRCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:02:52 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:51026 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753886AbZIXRCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:02:52 -0400
Date: Thu, 24 Sep 2009 10:01:31 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Oren Laadan <orenl@cs.columbia.edu>, serue@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: [RFC][v7][PATCH 4/9]: Add target_pid parameter to alloc_pidmap()
Message-ID: <20090924170131.GD16989@us.ibm.com>
References: <20090924165548.GA16586@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924165548.GA16586@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Subject: [RFC][v7][PATCH 4/9]: Add target_pid parameter to alloc_pidmap()

With support for setting a specific pid number for a process,
alloc_pidmap() will need a 'target_pid' parameter.

Changelog[v6]:
	- Separate target_pid > 0 case to minimize the number of checks needed.
Changelog[v3]:
	- (Eric Biederman): Avoid set_pidmap() function. Added couple of
	  checks for target_pid in alloc_pidmap() itself.
Changelog[v2]:
	- (Serge Hallyn) Check for 'pid < 0' in set_pidmap().(Code
	  actually checks for 'pid <= 0' for completeness).

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 kernel/pid.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

Index: linux-2.6/kernel/pid.c
===================================================================
--- linux-2.6.orig/kernel/pid.c	2009-09-09 19:07:20.000000000 -0700
+++ linux-2.6/kernel/pid.c	2009-09-10 10:23:27.000000000 -0700
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
@@ -164,6 +170,15 @@ static int alloc_pidmap(struct pid_names
 		if (rc)
 			break;
 
+		if (target_pid) {
+			rc = -EBUSY;
+			if (!test_and_set_bit(offset, map->page)) {
+				atomic_dec(&map->nr_free);
+				rc = pid;
+			}
+			return rc;
+		}
+
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
@@ -196,6 +211,7 @@ static int alloc_pidmap(struct pid_names
 		}
 		pid = mk_pid(pid_ns, map, offset);
 	}
+
 	return rc;
 }
 
@@ -272,7 +288,7 @@ struct pid *alloc_pid(struct pid_namespa
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		nr = alloc_pidmap(tmp, 0);
 		if (nr < 0)
 			goto out_free;
 
