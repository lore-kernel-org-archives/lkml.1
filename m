Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbYHSOae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbYHSOae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYHSOa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:30:26 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:49208 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYHSOaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:30:25 -0400
Date: Tue, 19 Aug 2008 19:43:45 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm_owner: fix cgroup null dereference
Message-ID: <20080819141344.GF25239@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Jiri Slaby <jirislaby@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1218745013-9537-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1218745013-9537-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jiri Slaby <jirislaby@gmail.com> [2008-08-14 22:16:53]:

> Hi,
> 
> found this in mmotm, a fix for
> mm-owner-fix-race-between-swap-and-exit.patch
>

Does the patch below fix your problem, it's against mmotm 19th August
2008.

 
Reported-by: jirislaby@gmail.com

Jiri reported a problem and saw an oops when the memrlimit-fix-race-with-swap
patch is applied. He sent his patch on top to fix the problem, but ran into
another issue. The root cause of the problem is that we are not suppose
to call task_cgroup on NULL tasks. This patch reverts Jiri's patch and
does not call task_cgroup if the passed task_struct (old) is NULL.


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 kernel/cgroup.c |    5 +++--
 kernel/exit.c   |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~memrlimit-fix-race-with-swap-oops kernel/exit.c
--- linux-2.6.27-rc3/kernel/exit.c~memrlimit-fix-race-with-swap-oops	2008-08-19 18:50:39.000000000 +0530
+++ linux-2.6.27-rc3-balbir/kernel/exit.c	2008-08-19 18:51:05.000000000 +0530
@@ -641,8 +641,8 @@ retry:
 	 * the callback and take action
 	 */
 	down_write(&mm->mmap_sem);
-	cgroup_mm_owner_callbacks(mm->owner, NULL);
 	mm->owner = NULL;
+	cgroup_mm_owner_callbacks(mm->owner, NULL);
 	up_write(&mm->mmap_sem);
 	return;
 
diff -puN kernel/cgroup.c~memrlimit-fix-race-with-swap-oops kernel/cgroup.c
--- linux-2.6.27-rc3/kernel/cgroup.c~memrlimit-fix-race-with-swap-oops	2008-08-19 18:50:39.000000000 +0530
+++ linux-2.6.27-rc3-balbir/kernel/cgroup.c	2008-08-19 18:55:38.000000000 +0530
@@ -2743,13 +2743,14 @@ void cgroup_fork_callbacks(struct task_s
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
-	struct cgroup *oldcgrp, *newcgrp = NULL;
+	struct cgroup *oldcgrp = NULL, *newcgrp = NULL;
 
 	if (need_mm_owner_callback) {
 		int i;
 		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
-			oldcgrp = task_cgroup(old, ss->subsys_id);
+			if (old)
+				oldcgrp = task_cgroup(old, ss->subsys_id);
 			if (new)
 				newcgrp = task_cgroup(new, ss->subsys_id);
 			if (oldcgrp == newcgrp)
diff -puN mm/memrlimitcgroup.c~memrlimit-fix-race-with-swap-oops mm/memrlimitcgroup.c
_

-- 
	Balbir
