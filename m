Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0CBSZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:25:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32779 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab0CBSZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:25:49 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf archive: Don't try to collect files without a build-id
Date: Tue,  2 Mar 2010 15:25:38 -0300
Message-Id: <1267554338-9667-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To avoid these error:

   [root@doppio ~]# perf archive
   tar: .build-id/00/00000000000000000000000000000000000000: Cannot stat:
   No such file or directory
   tar: .build-id/00/00000000000000000000000000000000000000: Cannot stat:
   No such file or directory
   tar: .build-id/00/00000000000000000000000000000000000000: Cannot stat:
   No such file or directory
   tar: .build-id/00/00000000000000000000000000000000000000: Cannot stat:
   No such file or directory
   tar: Exiting with failure status due to previous errors
   [root@doppio ~]#

More work is needed to support archiving symtabs for binaries without a
build-id, perhaps creating a perf.data UUID + adding build-ids for the
binaries copied into the cache and then have this perf.data session UUID
be a directory with symlinks to the by now calculated build-id of the
files inside it.

Or just do an extra pass and insert the calculated build-ids in the
perf.data header.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf-archive.sh |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
index 45fbe2f..910468e 100644
--- a/tools/perf/perf-archive.sh
+++ b/tools/perf/perf-archive.sh
@@ -9,8 +9,9 @@ fi
 
 DEBUGDIR=~/.debug/
 BUILDIDS=$(mktemp /tmp/perf-archive-buildids.XXXXXX)
+NOBUILDID=0000000000000000000000000000000000000000
 
-perf buildid-list -i $PERF_DATA --with-hits > $BUILDIDS
+perf buildid-list -i $PERF_DATA --with-hits | grep -v "^$NOBUILDID " > $BUILDIDS
 if [ ! -s $BUILDIDS ] ; then
 	echo "perf archive: no build-ids found"
 	rm -f $BUILDIDS
-- 
1.6.2.5

