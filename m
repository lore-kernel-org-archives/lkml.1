Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZEJWKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZEJWKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 18:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbZEJWHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 18:07:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756650AbZEJWH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 18:07:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FkSPBpeU998RdG2HmP1ahDGggM+q8pD3vyXyOUCT4RfbNjYIb/wZXjsdtzmzKFbgt
	XhL9fel4yBuqNEQU632/w==
Date: Sun, 10 May 2009 15:07:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 10/11 -mmotm] oom: avoid oom kill if no interruptible tasks
In-Reply-To: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0905101502470.18804@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are no interruptible system tasks other than kthreads, no task
should be chosen for oom kill since they won't respond to the SIGKILL
anyway.  Instead, we choose to simply fail page allocations if reclaim
cannot free memory and hope for the best.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/oom_kill.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -209,6 +209,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 	struct task_struct *g, *p;
 	struct task_struct *chosen = NULL;
 	struct timespec uptime;
+	unsigned long nr_interruptible = 0;
 	*ppoints = 0;
 	*freed = 0;
 
@@ -225,6 +226,8 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		/* skip the init task */
 		if (is_global_init(p))
 			continue;
+		if (!(p->state & TASK_UNINTERRUPTIBLE))
+			nr_interruptible++;
 		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
 
@@ -277,7 +280,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		}
 	} while_each_thread(g, p);
 
-	return chosen;
+	return nr_interruptible ? chosen : ERR_PTR(-1UL);
 }
 
 /**
