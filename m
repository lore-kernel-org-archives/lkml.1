Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbYGaMYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbYGaMYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYGaMX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:23:58 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52787 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752387AbYGaMX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:23:58 -0400
Date: Thu, 31 Jul 2008 07:23:55 -0500
From: Paul Jackson <pj@sgi.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: make ntasks to be a monotonic increasing value
Message-Id: <20080731072355.b582b2d6.pj@sgi.com>
In-Reply-To: <48912FDD.8060006@cn.fujitsu.com>
References: <48912FDD.8060006@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I agree that in theory, this kernel/cpuset.c update_tasks_nodemask()
loop could loop forever, and that by forcing ntasks to keep increasing
monotonically, this guarantees that it cannot loop forever.

I also agree that no known exploit of this exists, and doubt that
any could be created.

I did find the added code logic to be a tad more difficult to read
than I'd like.  How about the following patch, instead:

---
 kernel/cpuset.c |    3 +++
 1 file changed, 3 insertions(+)

--- 2.6.25-mm1.orig/kernel/cpuset.c	2008-07-31 07:05:23.000000000 -0500
+++ 2.6.25-mm1/kernel/cpuset.c	2008-07-31 07:13:48.000000000 -0500
@@ -880,6 +880,7 @@ static int update_nodemask(struct cpuset
 	struct task_struct *p;
 	struct mm_struct **mmarray;
 	int i, n, ntasks;
+	int prev_ntasks = 0;
 	int migrate;
 	int fudge;
 	int retval;
@@ -939,7 +940,9 @@ static int update_nodemask(struct cpuset
 	 */
 	while (1) {
 		ntasks = cgroup_task_count(cs->css.cgroup);  /* guess */
+		ntasks = max(ntasks, prev_ntasks);	/* keep increasing */
 		ntasks += fudge;
+		prev_ntasks = ntasks;
 		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
 		if (!mmarray)
 			goto done;


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
