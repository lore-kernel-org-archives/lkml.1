Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbZJUJQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbZJUJQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 05:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZJUJQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 05:16:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38451 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbZJUJQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 05:16:43 -0400
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
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
References: <4AD8C7E4.9000903@free.fr> <20091016194451.GA28706@us.ibm.com>
	<4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com>
	<20091020005125.GG27627@count0.beaverton.ibm.com>
	<m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com>
	<m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com>
	<m1r5sxsw7w.fsf@fess.ebiederm.org> <20091021062021.GA2667@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 21 Oct 2009 02:16:36 -0700
In-Reply-To: <20091021062021.GA2667@us.ibm.com> (Sukadev Bhattiprolu's message of "Tue\, 20 Oct 2009 23\:20\:21 -0700")
Message-ID: <m1eioxrtsb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> Eric W. Biederman [ebiederm@xmission.com] wrote:
> | > I will post a version of the patch outside this patchset with min
> | > and max parameters and we can see if it can be optimized/beautified.
> | 
> | Thanks,
> | Eric
>
> Here is the patch.  alloc_pid() calls alloc_pidmap() as follows:
>
> -		nr = alloc_pidmap(tmp);
> +		min = max = 0;
> +		if (target_pids) {
> +			min = target_pids[i];
> +			max = min + 1;
> +		}
> +		nr = alloc_pidmap(tmp, min, max);
>
> It does look like this patch executes a bit more code even in the common
> case but let me know if you think this is better.
> 	
> ---

Not what I was thinking.  The following untested patch is what I was
thinking.  It just exposes last, min, and max to the callers which pass
in different appropriate values.

Eric

diff --git a/kernel/pid.c b/kernel/pid.c
index d3f722d..d9b6f82 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -122,17 +122,17 @@ static void free_pidmap(struct upid *upid)
 	atomic_inc(&map->nr_free);
 }
 
-static int alloc_pidmap(struct pid_namespace *pid_ns)
+static int do_alloc_pidmap(struct pid_namespace *pid_ns, int last, int min, int max)
 {
-	int i, offset, max_scan, pid, last = pid_ns->last_pid;
+	int i, offset, max_scan, pid;
 	struct pidmap *map;
 
 	pid = last + 1;
-	if (pid >= pid_max)
-		pid = RESERVED_PIDS;
+	if (pid >= max)
+		pid = min;
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
-	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
+	max_scan = (max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
 	for (i = 0; i <= max_scan; ++i) {
 		if (unlikely(!map->page)) {
 			void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
@@ -153,7 +153,6 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
@@ -164,16 +163,16 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
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
+			offset = min;
 			if (unlikely(last == offset))
 				break;
 		}
@@ -182,6 +181,25 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	return -1;
 }
 
+static int alloc_pidmap(struct pid_namespace *pid_ns)
+{
+	int nr;
+
+	nr = do_alloc_pidmap(pid_ns, pid_ns->last, RESERVED_PIDS, pid_max);
+	if (nr >= 0)
+		pid_ns->last_pid = nr;
+	return nr;
+}
+
+static int set_pidmap(struct pid_namespace *pid_ns, int target)
+{
+	if (target >= pid_max)
+		return -1;
+	if (target < RESERVED_PIDS)
+		return -1;
+	return do_alloc_pidmap(pid_ns, target - 1, target, target + 1);
+}
+
 int next_pidmap(struct pid_namespace *pid_ns, int last)
 {
 	int offset;
