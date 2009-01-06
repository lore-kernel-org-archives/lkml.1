Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZAFJkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZAFJkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbZAFJkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:40:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56074 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbZAFJkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:40:03 -0500
Message-ID: <496326BA.60605@cn.fujitsu.com>
Date: Tue, 06 Jan 2009 17:39:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix double kfree
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix double kfree in failure path

It's not the responsibility of init_rootdomain() to free root_domain
allocated by alloc_rootdomain().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 545c6fc..2bad712 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6970,7 +6970,7 @@ static int init_rootdomain(struct root_domain *rd, bool bootmem)
 	}
 
 	if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
-		goto free_rd;
+		goto out;
 	if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
 		goto free_span;
 	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
@@ -6986,8 +6986,7 @@ free_online:
 	free_cpumask_var(rd->online);
 free_span:
 	free_cpumask_var(rd->span);
-free_rd:
-	kfree(rd);
+out:
 	return -ENOMEM;
 }
 
-- 
1.5.4.rc3

