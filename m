Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbXLFPua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbXLFPua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 10:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbXLFPuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 10:50:04 -0500
Received: from 75-130-111-13.dhcp.oxfr.ma.charter.com ([75.130.111.13]:38888
	"EHLO novell1.haskins.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752967AbXLFPuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 10:50:01 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH 1/2] Subject: SCHED - Only adjust overload state when changing
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, ghaskins@novell.com
Date: Thu, 06 Dec 2007 10:27:57 -0500
Message-ID: <20071206152757.7031.54578.stgit@novell1.haskins.net>
In-Reply-To: <20071206152536.7031.16101.stgit@novell1.haskins.net>
References: <20071206152536.7031.16101.stgit@novell1.haskins.net>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The overload set/clears were originally idempotent when this logic was first
implemented.  But that is no longer true due to the addition of the atomic
counter and this logic was never updated to work properly with that change.
So only adjust the overload state if it is actually changing to avoid
getting out of sync.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched_rt.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 4cbde83..53cd9e8 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -34,9 +34,11 @@ static inline void rt_clear_overload(struct rq *rq)
 static void update_rt_migration(struct rq *rq)
 {
 	if (rq->rt.rt_nr_migratory && (rq->rt.rt_nr_running > 1)) {
-		rt_set_overload(rq);
-		rq->rt.overloaded = 1;
-	} else {
+		if (!rq->rt.overloaded) {
+			rt_set_overload(rq);
+			rq->rt.overloaded = 1;
+		}
+	} else if (rq->rt.overloaded) {
 		rt_clear_overload(rq);
 		rq->rt.overloaded = 0;
 	}

