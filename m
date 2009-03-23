Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZCWPU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZCWPU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758617AbZCWPTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:19:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:48132 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758390AbZCWPTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:19:31 -0400
Date: Mon, 23 Mar 2009 15:18:38 GMT
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eduard.munteanu@linux360.ro, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <6698c7b983cc20ec84becc757362f48a8948762d.1237813499.git.eduard.munteanu@linux360.ro>
References: <6698c7b983cc20ec84becc757362f48a8948762d.1237813499.git.eduard.munteanu@linux360.ro>
Subject: [tip:tracing/kmemtrace] tracing: provide trace_seq_reserve()
Message-ID: <tip-41033a18aa027a1260c2546c02a1b185e92e6cf5@git.kernel.org>
Git-Commit-ID: 41033a18aa027a1260c2546c02a1b185e92e6cf5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 23 Mar 2009 15:18:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41033a18aa027a1260c2546c02a1b185e92e6cf5
Gitweb:     http://git.kernel.org/tip/41033a18aa027a1260c2546c02a1b185e92e6cf5
Author:     Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
AuthorDate: Mon, 23 Mar 2009 15:12:22 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Mar 2009 16:06:54 +0100

tracing: provide trace_seq_reserve()

trace_seq_reserve() allows a caller to reserve space in a trace_seq and
write directly into it. This makes it easier to export binary data to
userspace via the tracing interface, by simply filling in a struct.

Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
LKML-Reference: <6698c7b983cc20ec84becc757362f48a8948762d.1237813499.git.eduard.munteanu@linux360.ro>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/trace/trace_output.c |   13 +++++++++++++
 kernel/trace/trace_output.h |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 19261fd..6595074 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -167,6 +167,19 @@ int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
 	return trace_seq_putmem(s, hex, j);
 }
 
+void *trace_seq_reserve(struct trace_seq *s, size_t len)
+{
+	void *ret;
+
+	if (len > ((PAGE_SIZE - 1) - s->len))
+		return NULL;
+
+	ret = s->buffer + s->len;
+	s->len += len;
+
+	return ret;
+}
+
 int trace_seq_path(struct trace_seq *s, struct path *path)
 {
 	unsigned char *p;
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index 35c422f..0ae20b8 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -33,6 +33,7 @@ int trace_seq_puts(struct trace_seq *s, const char *str);
 int trace_seq_putc(struct trace_seq *s, unsigned char c);
 int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len);
 int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len);
+void *trace_seq_reserve(struct trace_seq *s, size_t len);
 int trace_seq_path(struct trace_seq *s, struct path *path);
 int seq_print_userip_objs(const struct userstack_entry *entry,
 			  struct trace_seq *s, unsigned long sym_flags);
