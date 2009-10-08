Return-Path: <linux-kernel-owner+w=401wt.eu-S933529AbZJHUR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529AbZJHUR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933438AbZJHUR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:17:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:42450 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933435AbZJHUR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:17:57 -0400
Date: Thu, 8 Oct 2009 20:16:38 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1255032449-12022-1-git-send-email-fweisbec@gmail.com>
References: <1255032449-12022-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Provide backward compatibility with previous perf.data version
Message-ID: <tip-26dd2cb074d9dc41c9e3cddd7bf175fd0a41febc@git.kernel.org>
Git-Commit-ID: 26dd2cb074d9dc41c9e3cddd7bf175fd0a41febc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 20:16:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26dd2cb074d9dc41c9e3cddd7bf175fd0a41febc
Gitweb:     http://git.kernel.org/tip/26dd2cb074d9dc41c9e3cddd7bf175fd0a41febc
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 8 Oct 2009 22:07:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Oct 2009 22:11:02 +0200

perf tools: Provide backward compatibility with previous perf.data version

We have merged the trace.info file into perf.data by adding one
section in the perf headers. This makes it incompatible with
previous version: the new perf tools can't read the older
perf.data.

To support the previous format, we check the headers size. If they
have the same size than in the previous format, then ignore the
trace info section that doesn't exist.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1255032449-12022-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/header.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 212fade..9aae360 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -287,10 +287,16 @@ struct perf_header *perf_header__read(int fd)
 	do_read(fd, &f_header, sizeof(f_header));
 
 	if (f_header.magic	!= PERF_MAGIC		||
-	    f_header.size	!= sizeof(f_header)	||
 	    f_header.attr_size	!= sizeof(f_attr))
 		die("incompatible file format");
 
+	if (f_header.size != sizeof(f_header)) {
+		/* Support the previous format */
+		if (f_header.size == offsetof(typeof(f_header), trace_info))
+			f_header.trace_info.size = 0;
+		else
+			die("incompatible file format");
+	}
 	nr_attrs = f_header.attrs.size / sizeof(f_attr);
 	lseek(fd, f_header.attrs.offset, SEEK_SET);
 
