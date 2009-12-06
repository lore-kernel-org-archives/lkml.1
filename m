Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbZLFRTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbZLFRTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933929AbZLFRTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:19:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:47495 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933928AbZLFRTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:19:32 -0500
Date: Sun, 6 Dec 2009 17:19:09 GMT
From: tip-bot for OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, hirofumi@mail.parknet.co.jp, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, hirofumi@mail.parknet.co.jp, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <87d42s8iiu.fsf_-_@devron.myhome.or.jp>
References: <87d42s8iiu.fsf_-_@devron.myhome.or.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Misc small fixes
Message-ID: <tip-7691b1ec2e4a8d4bd88dcf88b29792399ebe1c91@git.kernel.org>
Git-Commit-ID: 7691b1ec2e4a8d4bd88dcf88b29792399ebe1c91
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7691b1ec2e4a8d4bd88dcf88b29792399ebe1c91
Gitweb:     http://git.kernel.org/tip/7691b1ec2e4a8d4bd88dcf88b29792399ebe1c91
Author:     OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
AuthorDate: Sun, 6 Dec 2009 20:10:49 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 6 Dec 2009 18:15:02 +0100

perf tools: Misc small fixes

- util/header.c
	"len" is aligned to 64. So, it tries to write the out of
	long_name buffer.

	So, this use "zero_buf" to write aligned area.

- util/trace-event-read.c
	"size" is not including nul byte. So, this allocates it, and set '\0'.

- util/trace-event-parse.c
	It needs parens to calc correct size.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <87d42s8iiu.fsf_-_@devron.myhome.or.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/header.c            |    9 +++++++--
 tools/perf/util/trace-event-parse.c |    2 +-
 tools/perf/util/trace-event-read.c  |    3 ++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4805e6d..08b6759 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -187,7 +187,9 @@ static int do_write(int fd, const void *buf, size_t size)
 
 static int __dsos__write_buildid_table(struct list_head *head, int fd)
 {
+#define NAME_ALIGN	64
 	struct dso *pos;
+	static const char zero_buf[NAME_ALIGN];
 
 	list_for_each_entry(pos, head, node) {
 		int err;
@@ -197,14 +199,17 @@ static int __dsos__write_buildid_table(struct list_head *head, int fd)
 		if (!pos->has_build_id)
 			continue;
 		len = pos->long_name_len + 1;
-		len = ALIGN(len, 64);
+		len = ALIGN(len, NAME_ALIGN);
 		memset(&b, 0, sizeof(b));
 		memcpy(&b.build_id, pos->build_id, sizeof(pos->build_id));
 		b.header.size = sizeof(b) + len;
 		err = do_write(fd, &b, sizeof(b));
 		if (err < 0)
 			return err;
-		err = do_write(fd, pos->long_name, len);
+		err = do_write(fd, pos->long_name, pos->long_name_len + 1);
+		if (err < 0)
+			return err;
+		err = do_write(fd, zero_buf, len - pos->long_name_len + 1);
 		if (err < 0)
 			return err;
 	}
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 0302405..6ffe9d6 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -177,7 +177,7 @@ void parse_proc_kallsyms(char *file, unsigned int size __unused)
 		func_count++;
 	}
 
-	func_list = malloc_or_die(sizeof(*func_list) * func_count + 1);
+	func_list = malloc_or_die(sizeof(*func_list) * (func_count + 1));
 
 	i = 0;
 	while (list) {
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 342dfdd..1744422 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -145,8 +145,9 @@ static void read_proc_kallsyms(void)
 	if (!size)
 		return;
 
-	buf = malloc_or_die(size);
+	buf = malloc_or_die(size + 1);
 	read_or_die(buf, size);
+	buf[size] = '\0';
 
 	parse_proc_kallsyms(buf, size);
 
