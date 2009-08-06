Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZHFR6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZHFR6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZHFR6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:58:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:52581 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZHFR6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:58:48 -0400
Date: Thu, 6 Aug 2009 17:58:00 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Brice.Goglin@inria.fr, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, Brice.Goglin@inria.fr,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249574786.32113.550.camel@twins>
References: <1249574786.32113.550.camel@twins>
Subject: [tip:perfcounters/urgent] perf_counter: Fix double list iteration in per task precise stats
Message-ID: <tip-914e406e7b27cea336d3dfc12daa75930edd88a6@git.kernel.org>
Git-Commit-ID: 914e406e7b27cea336d3dfc12daa75930edd88a6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 06 Aug 2009 17:58:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  914e406e7b27cea336d3dfc12daa75930edd88a6
Gitweb:     http://git.kernel.org/tip/914e406e7b27cea336d3dfc12daa75930edd88a6
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 6 Aug 2009 18:06:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 6 Aug 2009 19:54:17 +0200

perf_counter: Fix double list iteration in per task precise stats

Brice Goglin reported:

> I finally managed to test the threaded perfcounter statistics (thanks a
> lot for implementing it). I am running 2.6.31-rc5 (with the AMD
> magny-cours patches but I don't think they matter here). I am trying to
> measure local/remote memory accesses per thread during the well-known
> stream benchmark. It's compiled with OpenMP using 16 threads on a
> quad-socket quad-core barcelona machine.
>
> Command line is:
>  /mnt/scratch/bgoglin/cpunode/linux-2.6.31/tools/perf/perf record -f -s
> -e r1000001e0 -e r1000002e0 -e r1000004e0 -e r1000008e0 ./stream
>
> It seems to work fine with a single -e <counter> on the command line
> while it crashes when there are at least 2 of them.
> It seems to work fine without -s as well.

A silly copy-paste resulted in a messed up iteration which would
cause the OOPS.

Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Brice Goglin <Brice.Goglin@inria.fr>
LKML-Reference: <1249574786.32113.550.camel@twins>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 199ed47..673c1aa 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1104,7 +1104,7 @@ static void perf_counter_sync_stat(struct perf_counter_context *ctx,
 		__perf_counter_sync_stat(counter, next_counter);
 
 		counter = list_next_entry(counter, event_entry);
-		next_counter = list_next_entry(counter, event_entry);
+		next_counter = list_next_entry(next_counter, event_entry);
 	}
 }
 
