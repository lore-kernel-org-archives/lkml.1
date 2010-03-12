Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0CLG65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 01:58:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62380 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753050Ab0CLG64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 01:58:56 -0500
Message-ID: <4B99E62C.1020500@cn.fujitsu.com>
Date: Fri, 12 Mar 2010 14:58:52 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       David Rientjes <rientjes@google.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: [PATCH -mmotm 1/2] cpuset: fix the problem that cpuset_mem_spread_node()
 returns an offline node - fix
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary smp_wmb().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
Against the following patch in mmotm-2010-03-11-13-13:
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
---
 kernel/cpuset.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b15c01c..f36e577 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -933,23 +933,9 @@ static void cpuset_migrate_mm(struct mm_struct *mm, const nodemask_t *from,
 
 	tsk->mems_allowed = *to;
 
-	/*
-	 * After current->mems_allowed is set to a new value, current will
-	 * allocate new pages for the migrating memory region. So we must
-	 * ensure that update of current->mems_allowed have been completed
-	 * by this moment.
-	 */
-	smp_wmb();
 	do_migrate_pages(mm, from, to, MPOL_MF_MOVE_ALL);
 
 	guarantee_online_mems(task_cs(tsk),&tsk->mems_allowed);
-
-	/*
-	 * After doing migrate pages, current will allocate new pages for
-	 * itself not the other tasks. So we must ensure that update of
-	 * current->mems_allowed have been completed by this moment.
-	 */
-	smp_wmb();
 }
 
 /*
-- 
1.6.5.2


