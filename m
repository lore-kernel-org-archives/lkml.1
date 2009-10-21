Return-Path: <linux-kernel-owner+w=401wt.eu-S1752470AbZJUGSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470AbZJUGSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 02:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZJUGSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 02:18:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54824 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZJUGSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 02:18:51 -0400
Date: Tue, 20 Oct 2009 23:20:21 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@librato.com>,
       Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091021062021.GA2667@us.ibm.com>
References: <4AD8C7E4.9000903@free.fr> <20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com> <20091020005125.GG27627@count0.beaverton.ibm.com> <m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com> <m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com> <m1r5sxsw7w.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r5sxsw7w.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| > I will post a version of the patch outside this patchset with min
| > and max parameters and we can see if it can be optimized/beautified.
| 
| Thanks,
| Eric

Here is the patch.  alloc_pid() calls alloc_pidmap() as follows:

-		nr = alloc_pidmap(tmp);
+		min = max = 0;
+		if (target_pids) {
+			min = target_pids[i];
+			max = min + 1;
+		}
+		nr = alloc_pidmap(tmp, min, max);

It does look like this patch executes a bit more code even in the common
case but let me know if you think this is better.
	
---

From: Sukadev Bhattiprolu <suka@suka.(none)>
Date: Tue, 20 Oct 2009 17:01:18 -0700
Subject: [PATCH] Add min and max parameters to alloc_pidmap()

With support for setting a specific pid number for a process, alloc_pidmap()
will need a 'min' and a 'max' parameter.

---
 kernel/pid.c |   47 ++++++++++++++++++++++++++++++++++-------------
 1 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index c4d9914..56e13c1 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -147,18 +147,30 @@ static int alloc_pidmap_page(struct pidmap *map)
 	return 0;
 }
 
-static int alloc_pidmap(struct pid_namespace *pid_ns)
+static int alloc_pidmap(struct pid_namespace *pid_ns, int min, int max)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
 	int rc = -EAGAIN;
 	struct pidmap *map;
 
-	pid = last + 1;
-	if (pid >= pid_max)
-		pid = RESERVED_PIDS;
+	if (min < 0 || max < 0 || max > pid_max)
+		return -EINVAL;
+
+	if (!max)
+		max = pid_max;
+
+	pid = min;
+	if (pid && pid >= max)
+		return -EINVAL;
+	else if (!pid) {
+		pid = last + 1;
+		if (pid >= pid_max)
+			pid = RESERVED_PIDS;
+	}
+
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
-	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
+	max_scan = (max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
 	for (i = 0; i <= max_scan; ++i) {
 		rc = alloc_pidmap_page(map);
 		if (rc)
@@ -168,7 +180,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
+					/*
+					 * 'last_pid' only makes sense when
+					 * choosing from entire range
+					 */
+					if (!min)
+						pid_ns->last_pid = pid;
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
@@ -179,22 +196,26 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
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
 			offset = RESERVED_PIDS;
-			if (unlikely(last == offset)) {
-				rc = -EAGAIN;
-				break;
-			}
 		}
 		pid = mk_pid(pid_ns, map, offset);
+		/*
+		 * If we are back to where we started, well, no pids are
+		 * currently available in selected range.
+		 */
+		if (pid < min || unlikely(last == offset)) {
+			rc = -EAGAIN;
+			break;
+		}
 	}
 	return rc;
 }
@@ -272,7 +293,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
 
 	tmp = ns;
 	for (i = ns->level; i >= 0; i--) {
-		nr = alloc_pidmap(tmp);
+		nr = alloc_pidmap(tmp, 0, 0);
 		if (nr < 0)
 			goto out_free;
 
-- 
1.6.0.4

