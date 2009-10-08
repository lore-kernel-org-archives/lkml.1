Return-Path: <linux-kernel-owner+w=401wt.eu-S933476AbZJHUIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476AbZJHUIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933407AbZJHUII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:08:08 -0400
Received: from mail-ew0-f228.google.com ([209.85.219.228]:35399 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933181AbZJHUIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:08:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=b9a8QPh0t0rcQQf4lWSB/M9ZR1aOvtqAFDg8AlGufAEtQt96VaiF5TwDmvEh7Pcz4l
         +13DtJWjtnPulfEiSlA7bELq7MAeIUIPPborFrze4bv4Z4nLCc3W5A2XBXOziqpHQ0j3
         /JXf5QJE8mt7lXvFLs0MQc6YClcHf+dp0z2vU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf tools: Provide backward compatibility with previous perf.data version
Date: Thu,  8 Oct 2009 22:07:29 +0200
Message-Id: <1255032449-12022-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have merged the trace.info file into perf.data by adding one section
in the perf headers. This makes it incompatible with previous version:
the new perf tools can't read the older perf.data.

To support the previous format, we check the headers size. If they
have the same size than in the previous format, then ignore the trace
info section that doesn't exist.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
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
 
-- 
1.6.2.3

