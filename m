Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761Ab0ADSUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab0ADSUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 13:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428Ab0ADSTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 13:19:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab0ADSTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 13:19:41 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 3/4] perf tools: Create write_padded routine out of __dsos__write_buildid_table
Date: Mon,  4 Jan 2010 16:19:28 -0200
Message-Id: <1262629169-22797-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1262629169-22797-1-git-send-email-acme@infradead.org>
References: <1262629169-22797-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Will be used by other options where padding is needed.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 709e325..942f7da 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -173,6 +173,20 @@ static int do_write(int fd, const void *buf, size_t size)
 	return 0;
 }
 
+#define NAME_ALIGN 64
+
+static int write_padded(int fd, const void *bf, size_t count,
+			size_t count_aligned)
+{
+	static const char zero_buf[NAME_ALIGN];
+	int err = do_write(fd, bf, count);
+
+	if (!err)
+		err = do_write(fd, zero_buf, count_aligned - count);
+
+	return err;
+}
+
 #define dsos__for_each_with_build_id(pos, head)	\
 	list_for_each_entry(pos, head, node)	\
 		if (!pos->has_build_id)		\
@@ -181,9 +195,7 @@ static int do_write(int fd, const void *buf, size_t size)
 
 static int __dsos__write_buildid_table(struct list_head *head, int fd)
 {
-#define NAME_ALIGN	64
 	struct dso *pos;
-	static const char zero_buf[NAME_ALIGN];
 
 	dsos__for_each_with_build_id(pos, head) {
 		int err;
@@ -197,10 +209,8 @@ static int __dsos__write_buildid_table(struct list_head *head, int fd)
 		err = do_write(fd, &b, sizeof(b));
 		if (err < 0)
 			return err;
-		err = do_write(fd, pos->long_name, pos->long_name_len + 1);
-		if (err < 0)
-			return err;
-		err = do_write(fd, zero_buf, len - pos->long_name_len - 1);
+		err = write_padded(fd, pos->long_name,
+				   pos->long_name_len + 1, len);
 		if (err < 0)
 			return err;
 	}
-- 
1.6.2.5

