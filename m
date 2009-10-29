Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZJ2IJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZJ2IJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZJ2IJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:09:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:53058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbZJ2IJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:09:44 -0400
Date: Thu, 29 Oct 2009 08:08:36 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091027204252.30545.19251.stgit@harusame>
References: <20091027204252.30545.19251.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf/probes: Exit searching after finding target function
Message-ID: <tip-8030c5f5a57e018fcdeb1f395d7adc123b48ced6@git.kernel.org>
Git-Commit-ID: 8030c5f5a57e018fcdeb1f395d7adc123b48ced6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8030c5f5a57e018fcdeb1f395d7adc123b48ced6
Gitweb:     http://git.kernel.org/tip/8030c5f5a57e018fcdeb1f395d7adc123b48ced6
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 27 Oct 2009 16:42:53 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Oct 2009 08:47:48 +0100

perf/probes: Exit searching after finding target function

Exit searching after finding real (not-inlined) function,
because there should be no same symbol in that CU.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091027204252.30545.19251.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
