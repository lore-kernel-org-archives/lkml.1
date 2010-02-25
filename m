Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933441Ab0BYTcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:32:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:34040 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933400Ab0BYTcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:32:10 -0500
Date: Thu, 25 Feb 2010 19:30:52 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       ananth@in.ibm.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, peterz@infradead.org, efault@gmx.de,
       ananth@in.ibm.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20100225133527.6725.52418.stgit@localhost6.localdomain6>
References: <20100225133527.6725.52418.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] perf probe: Fix bugs in line range finder
Message-ID: <tip-3cb8bc6ac95ff86147d11ee1d36d18e1ddf3637c@git.kernel.org>
Git-Commit-ID: 3cb8bc6ac95ff86147d11ee1d36d18e1ddf3637c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 19:30:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3cb8bc6ac95ff86147d11ee1d36d18e1ddf3637c
Gitweb:     http://git.kernel.org/tip/3cb8bc6ac95ff86147d11ee1d36d18e1ddf3637c
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 25 Feb 2010 08:35:27 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 17:49:28 +0100

perf probe: Fix bugs in line range finder

Fix find_line_range_by_line() to init line_list and remove
misconseptional found marking which should be done when
real lines are found (if there is no lines probe-able,
find_line_range() should return 0).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20100225133527.6725.52418.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-finder.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1b2124d..3e10dbe 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -788,6 +788,7 @@ static void find_line_range_by_line(struct line_finder *lf)
 	Dwarf_Addr addr;
 	int ret;
 
+	INIT_LIST_HEAD(&lf->lr->line_list);
 	ret = dwarf_srclines(lf->cu_die, &lines, &cnt, &__dw_error);
 	DIE_IF(ret != DW_DLV_OK);
 
@@ -848,8 +849,6 @@ static int linefunc_callback(struct die_link *dlink, void *data)
 		lr->start = lf->lno_s;
 		lr->end = lf->lno_e;
 		find_line_range_by_line(lf);
-		/* If we find a target function, this should be end. */
-		lf->found = 1;
 		return 1;
 	}
 	return 0;
