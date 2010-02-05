Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab0BERCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:02:45 -0500
Received: from mga10.intel.com ([192.55.52.92]:40112 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756023Ab0BERCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:02:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,414,1262592000"; 
   d="scan'208";a="770488679"
Message-ID: <4710.10.255.24.35.1265389362.squirrel@linux.intel.com>
Date: Fri, 5 Feb 2010 09:02:42 -0800 (PST)
Subject: [Patch]fixed: perf cannot show existing process callgraph symbol
From: austin_zhang@linux.intel.com
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu, acme@redhat.com
Cc: linux-kernel@vger.kernel.org, austin.zhang@intel.com
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/builtin-record.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 2654253..1d62d2a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -552,7 +552,7 @@ static int __cmd_record(int argc, const char **argv)
 	}

 	if (!system_wide && profile_cpu == -1)
-		event__synthesize_thread(pid, process_synthesized_event,
+		event__synthesize_thread(target_pid, process_synthesized_event,
 					 session);
 	else
 		event__synthesize_threads(process_synthesized_event, session);
-- 
1.6.1.3

