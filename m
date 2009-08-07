Return-Path: <linux-kernel-owner+w=401wt.eu-S932784AbZHGPKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784AbZHGPKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932627AbZHGPKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:10:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:35475 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932470AbZHGPKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:10:41 -0400
Date: Fri, 7 Aug 2009 15:09:52 GMT
From: tip-bot for Pierre Habouzit <pierre.habouzit@intersec.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, pierre.habouzit@intersec.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, pierre.habouzit@intersec.com, mingo@elte.hu
In-Reply-To: <1249647361-11582-2-git-send-email-pierre.habouzit@intersec.com>
References: <1249647361-11582-2-git-send-email-pierre.habouzit@intersec.com>
Subject: [tip:perfcounters/urgent] perf util: Fix do_read() to fail on EOF instead of busy-looping
Message-ID: <tip-47efff9a9b958f1c459a4c669168be0de474a9e3@git.kernel.org>
Git-Commit-ID: 47efff9a9b958f1c459a4c669168be0de474a9e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 07 Aug 2009 15:09:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47efff9a9b958f1c459a4c669168be0de474a9e3
Gitweb:     http://git.kernel.org/tip/47efff9a9b958f1c459a4c669168be0de474a9e3
Author:     Pierre Habouzit <pierre.habouzit@intersec.com>
AuthorDate: Fri, 7 Aug 2009 14:16:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 7 Aug 2009 17:08:17 +0200

perf util: Fix do_read() to fail on EOF instead of busy-looping

While toying with perf, I've noticed that perf record can
easily enter a busy loop when doing something as silly as:

    $ perf record -A ls

Yeah, do_read here really wants to read a known size, not being
able to should die(), not busy-loop ;)

That was the cause for the bug.

Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1249647361-11582-2-git-send-email-pierre.habouzit@intersec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/header.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 95a44bc..b92a457 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -185,6 +185,8 @@ static void do_read(int fd, void *buf, size_t size)
 
 		if (ret < 0)
 			die("failed to read");
+		if (ret == 0)
+			die("failed to read: missing data");
 
 		size -= ret;
 		buf += ret;
