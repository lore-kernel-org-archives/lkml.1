Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab0BVLFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 06:05:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:32942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab0BVLF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 06:05:29 -0500
Date: Mon, 22 Feb 2010 11:04:18 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100218181652.26547.57790.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100218181652.26547.57790.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Init struct probe_point and set counter correctly
Message-ID: <tip-388c3aab5d4f1b0bbfe2d5f47e7cd681866bc573@git.kernel.org>
Git-Commit-ID: 388c3aab5d4f1b0bbfe2d5f47e7cd681866bc573
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 22 Feb 2010 11:04:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  388c3aab5d4f1b0bbfe2d5f47e7cd681866bc573
Gitweb:     http://git.kernel.org/tip/388c3aab5d4f1b0bbfe2d5f47e7cd681866bc573
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 18 Feb 2010 13:16:52 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 22 Feb 2010 11:42:27 +0100

perf probe: Init struct probe_point and set counter correctly

Clear struct probe_point before using it in
show_perf_probe_events(), and set pp->found counter correctly in
synthesize_perf_probe_point(). Without this initialization,
clear_probe_point() will free random addresses.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
LKML-Reference: <20100218181652.26547.57790.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-event.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 29465d4..fde17b0 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -272,6 +272,7 @@ int synthesize_perf_probe_point(struct probe_point *pp)
 	int ret;
 
 	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
+	pp->found = 1;
 	if (!buf)
 		die("Failed to allocate memory by zalloc.");
 	if (pp->offset) {
@@ -294,6 +295,7 @@ int synthesize_perf_probe_point(struct probe_point *pp)
 error:
 		free(pp->probes[0]);
 		pp->probes[0] = NULL;
+		pp->found = 0;
 	}
 	return ret;
 }
@@ -455,6 +457,7 @@ void show_perf_probe_events(void)
 	struct strlist *rawlist;
 	struct str_node *ent;
 
+	memset(&pp, 0, sizeof(pp));
 	fd = open_kprobe_events(O_RDONLY, 0);
 	rawlist = get_trace_kprobe_event_rawlist(fd);
 	close(fd);
