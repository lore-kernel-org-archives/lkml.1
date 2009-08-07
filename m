Return-Path: <linux-kernel-owner+w=401wt.eu-S932202AbZHGHke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbZHGHke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757086AbZHGHke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:40:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:53888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035AbZHGHkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:40:33 -0400
Date: Fri, 7 Aug 2009 07:39:49 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Brice.Goglin@inria.fr, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, Brice.Goglin@inria.fr,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1249585061.4975.17.camel@laptop>
References: <1249585061.4975.17.camel@laptop>
Subject: [tip:perfcounters/urgent] perf tools: Fix multi-counter stat bug caused by incorrect reading of perf.data file header
Message-ID: <tip-ce71e78d91c4e7c02ce85f26319e53a824be4ffb@git.kernel.org>
Git-Commit-ID: ce71e78d91c4e7c02ce85f26319e53a824be4ffb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 07:39:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce71e78d91c4e7c02ce85f26319e53a824be4ffb
Gitweb:     http://git.kernel.org/tip/ce71e78d91c4e7c02ce85f26319e53a824be4ffb
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 6 Aug 2009 20:57:41 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 09:37:29 +0200

perf tools: Fix multi-counter stat bug caused by incorrect reading of perf.data file header

Brice Goglin reported that only the first result from a
multi-counter perf record --stat run is accurate, the
rest looks bogus.

A silly mistake made us re-read the first attribute for
every recorded attribute.

Reported-by: Brice Goglin <Brice.Goglin@inria.fr>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Brice Goglin <Brice.Goglin@inria.fr>
Cc: paulus@samba.org
LKML-Reference: <1249585061.4975.17.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/header.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 450384b..95a44bc 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -213,9 +213,10 @@ struct perf_header *perf_header__read(int fd)
 
 	for (i = 0; i < nr_attrs; i++) {
 		struct perf_header_attr *attr;
-		off_t tmp = lseek(fd, 0, SEEK_CUR);
+		off_t tmp;
 
 		do_read(fd, &f_attr, sizeof(f_attr));
+		tmp = lseek(fd, 0, SEEK_CUR);
 
 		attr = perf_header_attr__new(&f_attr.attr);
 
