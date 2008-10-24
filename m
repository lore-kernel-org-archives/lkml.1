Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYJXXmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYJXXmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbYJXXmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:42:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59580 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbYJXXmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:42:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type;
	b=Nn+ItiMeGCllZacJXITmX6dhjmL9h7eS7uB6bp1wWZS83HTZyCuHW2MWniiSaCJe7
	1+8Yd5EqFcWiRopnHOCtQ==
Date: Fri, 24 Oct 2008 16:42:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [patch] oom: do not dump task state for non thread group leaders
Message-ID: <alpine.DEB.1.10.0810241641090.31793@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When /proc/sys/vm/oom_dump_tasks is enabled, it's only necessary to dump
task state information for thread group leaders.  The kernel log gets
quickly overwhelmed on machines with a massive number of threads by
dumping non-thread group leaders.

Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -297,6 +297,8 @@ static void dump_tasks(const struct mem_cgroup *mem)
 			continue;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
+		if (!thread_group_leader(p))
+			continue;
 
 		task_lock(p);
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
