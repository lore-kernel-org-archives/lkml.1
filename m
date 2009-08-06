Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbZHFQGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbZHFQGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZHFQGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:06:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51927 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZHFQGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:06:44 -0400
Subject: [PATCH] perf_counter: fix double list iteration
From: Peter Zijlstra <peterz@infradead.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1249573080.32113.547.camel@twins>
References: <4A7A7778.7000000@inria.fr>  <1249573080.32113.547.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Aug 2009 18:06:26 +0200
Message-Id: <1249574786.32113.550.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 17:38 +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-06 at 08:26 +0200, Brice Goglin wrote:
> > Hello Ingo
> > 
> > I finally managed to test the threaded perfcounter statistics (thanks a
> > lot for implementing it). I am running 2.6.31-rc5 (with the AMD
> > magny-cours patches but I don't think they matter here). I am trying to
> > measure local/remote memory accesses per thread during the well-known
> > stream benchmark. It's compiled with OpenMP using 16 threads on a
> > quad-socket quad-core barcelona machine.
> > 
> > Command line is:
> >  /mnt/scratch/bgoglin/cpunode/linux-2.6.31/tools/perf/perf record -f -s
> > -e r1000001e0 -e r1000002e0 -e r1000004e0 -e r1000008e0 ./stream
> > 
> > It seems to work fine with a single -e <counter> on the command line
> > while it crashes when there are at least 2 of them.
> > It seems to work fine without -s as well.
> 
> OK, I can reproduce OOPSen this way, got me baffled though.
> 
> I'll prod at it some...

D'0h really dumb mistake...

---
Subject: perf_counter: fix double list iteration

A silly copy-paste resulted in a messed up iteration which would cause
an OOPS.

Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 06d210c..6da7611 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1104,7 +1104,7 @@ static void perf_counter_sync_stat(struct perf_counter_context *ctx,
 		__perf_counter_sync_stat(counter, next_counter);
 
 		counter = list_next_entry(counter, event_entry);
-		next_counter = list_next_entry(counter, event_entry);
+		next_counter = list_next_entry(next_counter, event_entry);
 	}
 }
 

