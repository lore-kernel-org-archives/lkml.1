Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbXLEXHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbXLEXHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXLEXHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:07:44 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:42383
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752791AbXLEXHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:07:44 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH] sched: update root-domain spans upon departure
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, ghaskins@novell.com
Date: Wed, 05 Dec 2007 17:45:33 -0500
Message-ID: <20071205224429.4572.92409.stgit@novell1.haskins.net>
In-Reply-To: <20071205222619.4463.63899.stgit@novell1.haskins.net>
References: <20071205222619.4463.63899.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm...I made a last second "optimization" before sending that patch out and
then realized it was racy.  Try this one instead...(sorry for the churn)

-Greg

------------------------------
sched: update root-domain spans upon departure

We shouldnt leave cpus enabled in the spans if that RQ has left the domain.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 05a9a81..02f04bc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5843,6 +5843,9 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
 				class->leave_domain(rq);
 		}
 
+		cpu_clear(rq->cpu, old_rd->span);
+		cpu_clear(rq->cpu, old_rd->online);
+
 		if (atomic_dec_and_test(&old_rd->refcount))
 			kfree(old_rd);
 	}

