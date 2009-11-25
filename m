Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbZKYS60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbZKYS60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759440AbZKYS60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:58:26 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:48601 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZKYS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:58:25 -0500
Date: Wed, 25 Nov 2009 10:58:03 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, hpa@zytor.com,
       Nathan Lynch <nathanl@austin.ibm.com>, haveblue@us.ibm.com,
       Matt Helsley <matthltc@us.ibm.com>, arnd@arndb.de, roland@redhat.com,
       mtk.manpages@googlemail.com, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>
Subject: [v13][PATCH 03/12] Define set_pidmap() function
Message-ID: <20091125185803.GD30858@us.ibm.com>
References: <20091125185543.GA30858@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125185543.GA30858@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: [v13][PATCH 03/12] Define set_pidmap() function

Define a set_pidmap() interface which is like alloc_pidmap() only that
caller specifies the pid number to be assigned.

Changelog[v13]:
	- Don't let do_alloc_pidmap return 0 if it failed to find a pid.
Changelog[v9]:
	- Completely rewrote this patch based on Eric Biederman's code.
Changelog[v7]:
        - [Eric Biederman] Generalize alloc_pidmap() to take a range of pids.
Changelog[v6]:
        - Separate target_pid > 0 case to minimize the number of checks needed.
Changelog[v3]:
        - (Eric Biederman): Avoid set_pidmap() function. Added couple of
          checks for target_pid in alloc_pidmap() itself.
Changelog[v2]:
        - (Serge Hallyn) Check for 'pid < 0' in set_pidmap().(Code
          actually checks for 'pid <= 0' for completeness).

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/pid.c |   46 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index c4d9914..c50a711 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -147,28 +147,29 @@ static int alloc_pidmap_page(struct pidmap *map)
 	return 0;
 }
 
-static int alloc_pidmap(struct pid_namespace *pid_ns)
+static int do_alloc_pidmap(struct pid_namespace *pid_ns, int last, int min,
+		int max)
 {
-	int i, offset, max_scan, pid, last = pid_ns->last_pid;
+	int i, offset, max_scan, pid;
 	int rc = -EAGAIN;
 	struct pidmap *map;
 
 	pid = last + 1;
 	if (pid >= pid_max)
-		pid = RESERVED_PIDS;
+		pid = min;
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
-	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
+	max_scan = (max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
 	for (i = 0; i <= max_scan; ++i) {
 		rc = alloc_pidmap_page(map);
 		if (rc)
 			break;
 
+		rc = -EAGAIN;
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
@@ -179,26 +180,49 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			 * bitmap block and the final block was the same
 			 * as the starting point, pid is before last_pid.
 			 */
-			} while (offset < BITS_PER_PAGE && pid < pid_max &&
+			} while (offset < BITS_PER_PAGE && pid < max &&
 					(i != max_scan || pid < last ||
 					    !((last+1) & BITS_PER_PAGE_MASK)));
 		}
-		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
+		if (map < &pid_ns->pidmap[(max-1)/BITS_PER_PAGE]) {
 			++map;
 			offset = 0;
 		} else {
 			map = &pid_ns->pidmap[0];
-			offset = RESERVED_PIDS;
-			if (unlikely(last == offset)) {
-				rc = -EAGAIN;
+			offset = min;
+			if (unlikely(last == offset))
 				break;
-			}
 		}
 		pid = mk_pid(pid_ns, map, offset);
 	}
 	return rc;
 }
 
+static int alloc_pidmap(struct pid_namespace *pid_ns)
+{
+	int nr;
+
+	nr = do_alloc_pidmap(pid_ns, pid_ns->last_pid, RESERVED_PIDS, pid_max);
+	if (nr >= 0)
+		pid_ns->last_pid = nr;
+	return nr;
+}
+
+static int set_pidmap(struct pid_namespace *pid_ns, int target)
+{
+	if (!target)
+		return alloc_pidmap(pid_ns);
+
+	if (target >= pid_max)
+		return -EINVAL;
+
+	if ((target < 0) || (target < RESERVED_PIDS &&
+				pid_ns->last_pid >= RESERVED_PIDS))
+		return -EINVAL;
+
+	return do_alloc_pidmap(pid_ns, target - 1, target, target + 1);
+}
+
 int next_pidmap(struct pid_namespace *pid_ns, int last)
 {
 	int offset;
-- 
1.6.0.4

