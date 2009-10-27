Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbZJ0Unv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbZJ0Unv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932206AbZJ0Unu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:43:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbZJ0Unr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:43:47 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 07/10] perf/probes: Exit searching after
	finding target function
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 27 Oct 2009 16:42:53 -0400
Message-ID: <20091027204252.30545.19251.stgit@harusame>
In-Reply-To: <20091027204156.30545.96425.stgit@harusame>
References: <20091027204156.30545.96425.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exit searching after finding real (not-inlined) function, because
there should be no same symbol in that CU.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 tools/perf/util/probe-finder.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 54e7071..b98d35e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -585,14 +585,14 @@ static int probefunc_callback(struct die_link *dlink, void *data)
 				DIE_IF(ret != DW_DLV_OK);
 				pr_debug("inline definition offset %lld\n",
 					 pf->inl_offs);
-				return 0;
+				return 0;	/* Continue to search */
 			}
 			/* Get probe address */
 			pf->addr = die_get_entrypc(dlink->die);
 			pf->addr += pp->offset;
 			/* TODO: Check the address in this function */
 			show_probepoint(dlink->die, pp->offset, pf);
-			/* Continue to search */
+			return 1; /* Exit; no same symbol in this CU. */
 		}
 	} else if (tag == DW_TAG_inlined_subroutine && pf->inl_offs) {
 		if (die_get_abstract_origin(dlink->die) == pf->inl_offs) {


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
