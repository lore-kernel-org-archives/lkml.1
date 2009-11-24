Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbZKXOFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbZKXOFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 09:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbZKXOFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 09:05:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:41343 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932916AbZKXOFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 09:05:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/4] perf tools: Remove unused wrapper routines
Date: Tue, 24 Nov 2009 12:05:17 -0200
Message-Id: <1259071517-3242-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1259071517-3242-3-git-send-email-acme@infradead.org>
References: <1259071517-3242-1-git-send-email-acme@infradead.org>
 <1259071517-3242-2-git-send-email-acme@infradead.org>
 <1259071517-3242-3-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And also make xrealloc and xmalloc weak symbols so that we don't have
this problem:

/usr/lib/gcc/x86_64-redhat-linux/4.4.1/../../../../lib64/libiberty.a(xmalloc.o):
In function `xrealloc':
(.text+0xc0): multiple definition of `xrealloc'
libperf.a(wrapper.o):/home/acme_unencrypted/git/linux-2.6-tip/tools/perf/util/wrapper.c:67:
first defined here
collect2: ld returned 1 exit status

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.h    |   11 +------
 tools/perf/util/wrapper.c |   61 +-------------------------------------------
 2 files changed, 4 insertions(+), 68 deletions(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 30c5517..c673d88 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -290,17 +290,10 @@ static inline char *gitstrchrnul(const char *s, int c)
  * Wrappers:
  */
 extern char *xstrdup(const char *str);
-extern void *xmalloc(size_t size);
+extern void *xmalloc(size_t size) __attribute__((weak));
 extern void *xmemdupz(const void *data, size_t len);
 extern char *xstrndup(const char *str, size_t len);
-extern void *xrealloc(void *ptr, size_t size);
-extern void *xcalloc(size_t nmemb, size_t size);
-extern void *xmmap(void *start, size_t length, int prot, int flags, int fd, off_t offset);
-extern ssize_t xread(int fd, void *buf, size_t len);
-extern ssize_t xwrite(int fd, const void *buf, size_t len);
-extern int xdup(int fd);
-extern FILE *xfdopen(int fd, const char *mode);
-extern int xmkstemp(char *template);
+extern void *xrealloc(void *ptr, size_t size) __attribute__((weak));
 
 static inline void *zalloc(size_t size)
 {
diff --git a/tools/perf/util/wrapper.c b/tools/perf/util/wrapper.c
index 4574ac2..bf44ca8 100644
--- a/tools/perf/util/wrapper.c
+++ b/tools/perf/util/wrapper.c
@@ -79,43 +79,12 @@ void *xrealloc(void *ptr, size_t size)
 	return ret;
 }
 
-void *xcalloc(size_t nmemb, size_t size)
-{
-	void *ret = calloc(nmemb, size);
-	if (!ret && (!nmemb || !size))
-		ret = calloc(1, 1);
-	if (!ret) {
-		release_pack_memory(nmemb * size, -1);
-		ret = calloc(nmemb, size);
-		if (!ret && (!nmemb || !size))
-			ret = calloc(1, 1);
-		if (!ret)
-			die("Out of memory, calloc failed");
-	}
-	return ret;
-}
-
-void *xmmap(void *start, size_t length,
-	int prot, int flags, int fd, off_t offset)
-{
-	void *ret = mmap(start, length, prot, flags, fd, offset);
-	if (ret == MAP_FAILED) {
-		if (!length)
-			return NULL;
-		release_pack_memory(length, fd);
-		ret = mmap(start, length, prot, flags, fd, offset);
-		if (ret == MAP_FAILED)
-			die("Out of memory? mmap failed: %s", strerror(errno));
-	}
-	return ret;
-}
-
 /*
  * xread() is the same a read(), but it automatically restarts read()
  * operations with a recoverable error (EAGAIN and EINTR). xread()
  * DOES NOT GUARANTEE that "len" bytes is read even if the data is available.
  */
-ssize_t xread(int fd, void *buf, size_t len)
+static ssize_t xread(int fd, void *buf, size_t len)
 {
 	ssize_t nr;
 	while (1) {
@@ -131,7 +100,7 @@ ssize_t xread(int fd, void *buf, size_t len)
  * operations with a recoverable error (EAGAIN and EINTR). xwrite() DOES NOT
  * GUARANTEE that "len" bytes is written even if the operation is successful.
  */
-ssize_t xwrite(int fd, const void *buf, size_t len)
+static ssize_t xwrite(int fd, const void *buf, size_t len)
 {
 	ssize_t nr;
 	while (1) {
@@ -179,29 +148,3 @@ ssize_t write_in_full(int fd, const void *buf, size_t count)
 
 	return total;
 }
-
-int xdup(int fd)
-{
-	int ret = dup(fd);
-	if (ret < 0)
-		die("dup failed: %s", strerror(errno));
-	return ret;
-}
-
-FILE *xfdopen(int fd, const char *mode)
-{
-	FILE *stream = fdopen(fd, mode);
-	if (stream == NULL)
-		die("Out of memory? fdopen failed: %s", strerror(errno));
-	return stream;
-}
-
-int xmkstemp(char *template)
-{
-	int fd;
-
-	fd = mkstemp(template);
-	if (fd < 0)
-		die("Unable to create temporary file: %s", strerror(errno));
-	return fd;
-}
-- 
1.6.2.5

