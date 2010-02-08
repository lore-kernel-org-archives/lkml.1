Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0BHP6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 10:58:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:54169 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab0BHP6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 10:58:18 -0500
Date: Mon, 8 Feb 2010 15:57:33 GMT
From: "tip-bot for austin_zhang@linux.intel.com" 
	<austin_zhang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, austin_zhang@linux.intel.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, austin_zhang@linux.intel.com,
       mingo@elte.hu
In-Reply-To: <4710.10.255.24.35.1265389362.squirrel@linux.intel.com>
References: <4710.10.255.24.35.1265389362.squirrel@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Fix existing process callgraph symbol
Message-ID: <tip-f7e7ee36757f68778700cde1aaed89e1d23e59fd@git.kernel.org>
Git-Commit-ID: f7e7ee36757f68778700cde1aaed89e1d23e59fd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 08 Feb 2010 15:57:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7e7ee36757f68778700cde1aaed89e1d23e59fd
Gitweb:     http://git.kernel.org/tip/f7e7ee36757f68778700cde1aaed89e1d23e59fd
Author:     austin_zhang@linux.intel.com <austin_zhang@linux.intel.com>
AuthorDate: Fri, 5 Feb 2010 09:02:42 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Feb 2010 16:55:52 +0100

perf record: Fix existing process callgraph symbol

When 'perf record -g' a existing process, even with debuginfo
packages, still cannnot get symbol from 'perf report'.

try:

 perf record -g -p `pidof xxx` -f
 perf report

    68.26%    :1181           b74870f2  [.] 0x000000b74870f2
              |
              |--32.09%-- 0xb73b5b44
              |          0xb7487102
              |          0xb748a4e2
              |          0xb748633d
              |          0xb73b41cd
              |          0xb73b4467
              |          0xb747d531

The reason is: for existing process, in __cmd_record(),
the pid is 0 rather than the existing process id.

Signed-off-by: Austin Zhang <austin_zhang@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4710.10.255.24.35.1265389362.squirrel@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 3ad599b..771533c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -570,7 +570,7 @@ static int __cmd_record(int argc, const char **argv)
 	}
 
 	if (!system_wide && profile_cpu == -1)
-		event__synthesize_thread(pid, process_synthesized_event,
+		event__synthesize_thread(target_pid, process_synthesized_event,
 					 session);
 	else
 		event__synthesize_threads(process_synthesized_event, session);
