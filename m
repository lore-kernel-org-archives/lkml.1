Return-Path: <linux-kernel-owner+w=401wt.eu-S933756AbZLFLkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbZLFLkZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 06:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933724AbZLFLkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 06:40:24 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:54397 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709AbZLFLkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 06:40:22 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] perf: misc small fixes
References: <87ljhg8ioe.fsf@devron.myhome.or.jp>
	<87hbs48imv.fsf@devron.myhome.or.jp>
Date: Sun, 06 Dec 2009 20:10:49 +0900
In-Reply-To: <87hbs48imv.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Sun, 06 Dec 2009 20:08:24 +0900")
Message-ID: <87d42s8iiu.fsf_-_@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Those was checked by valgrind, but not fixed all errors by lazyness. Sorry]

- util/parse-event.c
	"path" is pointer. It should be sizeof(*path)

- util/header.c
	"len" is aligned to 64. So, it tries to write the out of
	long_name buffer.

	So, this use "zero_buf" to write aligned area.

- util/trace-event-read.c
	"size" is not including nul byte. So, this allocates it, and set '\0'.

- util/trace-event-parse.c
	It needs parens to calc correct size.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 tools/perf/util/header.c            |    9 +++++++--
 tools/perf/util/parse-events.c      |    2 +-
 tools/perf/util/trace-event-parse.c |    2 +-
 tools/perf/util/trace-event-read.c  |    3 ++-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff -puN tools/perf/util/parse-events.c~perf-fix-misc tools/perf/util/parse-events.c
--- linux-2.6/tools/perf/util/parse-events.c~perf-fix-misc	2009-12-06 19:42:53.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/util/parse-events.c	2009-12-06 19:42:53.000000000 +0900
@@ -197,7 +197,7 @@ struct tracepoint_path *tracepoint_id_to
 			if (id == config) {
 				closedir(evt_dir);
 				closedir(sys_dir);
-				path = zalloc(sizeof(path));
+				path = zalloc(sizeof(*path));
 				path->system = malloc(MAX_EVENT_LENGTH);
 				if (!path->system) {
 					free(path);
diff -puN tools/perf/util/symbol.c~perf-fix-misc tools/perf/util/symbol.c
diff -puN tools/perf/util/header.c~perf-fix-misc tools/perf/util/header.c
--- linux-2.6/tools/perf/util/header.c~perf-fix-misc	2009-12-06 19:42:53.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/util/header.c	2009-12-06 19:42:53.000000000 +0900
@@ -187,7 +187,9 @@ static int do_write(int fd, const void *
 
 static int __dsos__write_buildid_table(struct list_head *head, int fd)
 {
+#define NAME_ALIGN	64
 	struct dso *pos;
+	static const char zero_buf[NAME_ALIGN];
 
 	list_for_each_entry(pos, head, node) {
 		int err;
@@ -197,14 +199,17 @@ static int __dsos__write_buildid_table(s
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
diff -puN tools/perf/util/trace-event-read.c~perf-fix-misc tools/perf/util/trace-event-read.c
--- linux-2.6/tools/perf/util/trace-event-read.c~perf-fix-misc	2009-12-06 19:42:53.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/util/trace-event-read.c	2009-12-06 19:42:53.000000000 +0900
@@ -145,8 +145,9 @@ static void read_proc_kallsyms(void)
 	if (!size)
 		return;
 
-	buf = malloc_or_die(size);
+	buf = malloc_or_die(size + 1);
 	read_or_die(buf, size);
+	buf[size] = '\0';
 
 	parse_proc_kallsyms(buf, size);
 
diff -puN tools/perf/util/trace-event-parse.c~perf-fix-misc tools/perf/util/trace-event-parse.c
--- linux-2.6/tools/perf/util/trace-event-parse.c~perf-fix-misc	2009-12-06 19:42:53.000000000 +0900
+++ linux-2.6-hirofumi/tools/perf/util/trace-event-parse.c	2009-12-06 19:42:53.000000000 +0900
@@ -177,7 +177,7 @@ void parse_proc_kallsyms(char *file, uns
 		func_count++;
 	}
 
-	func_list = malloc_or_die(sizeof(*func_list) * func_count + 1);
+	func_list = malloc_or_die(sizeof(*func_list) * (func_count + 1));
 
 	i = 0;
 	while (list) {
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
