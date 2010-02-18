Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0BRSK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:10:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526Ab0BRSKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:10:25 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip and 2.6.33-rc8] [BUGFIX] perf probe: Init struct
	probe_point and set counter correctly
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Date: Thu, 18 Feb 2010 13:16:52 -0500
Message-ID: <20100218181652.26547.57790.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clear struct probe_point before using it in show_perf_probe_events(),
and set pp->found counter correctly in synthesize_perf_probe_point().
Without this initialization, clear_probe_point() will free random
addresses.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
