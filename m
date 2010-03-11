Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384Ab0CKSxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 13:53:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:38841 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933735Ab0CKSxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 13:53:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, stable@kernel.org
Subject: [PATCH 1/2] perf record: Don't try to find buildids in a zero sized file
Date: Thu, 11 Mar 2010 15:53:11 -0300
Message-Id: <1268333592-30872-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Fixing this symptom:

[acme@mica linux-2.6-tip]$ perf record -a -f
  Fatal: Permission error - are you root?

Bus error
[acme@mica linux-2.6-tip]$

I.e. if for some reason no data is collected, in this case a non root user
trying to do systemwide profiling, no data will be collected, and then we end
up trying to mmap a zero sized file and access the file header, b00m.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: stable@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f573bbb..3bf1409 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -394,6 +394,9 @@ static int process_buildids(void)
 {
 	u64 size = lseek(output, 0, SEEK_CUR);
 
+	if (size == 0)
+		return 0;
+
 	session->fd = output;
 	return __perf_session__process_events(session, post_processing_offset,
 					      size - post_processing_offset,
-- 
1.5.5.1

