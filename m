Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZL3DUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZL3DUs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 22:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZL3DUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 22:20:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56294 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbZL3DUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 22:20:47 -0500
Message-ID: <4B3AC69F.4070901@cn.fujitsu.com>
Date: Wed, 30 Dec 2009 11:18:55 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] perf tools: adjust symbol address
References: <4B3AC5CD.1000502@cn.fujitsu.com>
In-Reply-To: <4B3AC5CD.1000502@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using relocation offset adjust symbol address if we get
kernel symbol name form elf file

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/perf/builtin-record.c |    3 +++
 tools/perf/util/session.c   |    6 ++++++
 tools/perf/util/symbol.c    |   13 +++++++++++++
 tools/perf/util/symbol.h    |    2 ++
 4 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d13601d..4d86969 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -436,6 +436,9 @@ static int __cmd_record(int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
+	/* Always get relocation offset */
+	inject_events |= PERF_INJECT_RELOCATE_OFFSET;
+
 	if (forks && (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0)) {
 		perror("failed to create pipes");
 		exit(-1);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 74f43af..92d4811 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -243,6 +243,12 @@ static int perf_session__process_event(struct perf_session *self,
 	case PERF_RECORD_UNTHROTTLE:
 		return ops->unthrottle(event, self);
 	case PERF_RECORD_INJECT:
+		if (event->inject.inject_event_id ==
+		    PERF_INJECT_RELOCATE_OFFSET) {
+			update_relocate_offset((s32)event->inject.value);
+			return 0;
+		}
+
 		return ops->inject(event, self);
 	default:
 		self->unknown_events++;
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 79ca6a0..5b58d34 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -19,6 +19,18 @@
 #define NT_GNU_BUILD_ID 3
 #endif
 
+static s32 relocate_offset;
+void update_relocate_offset(s32 offset)
+{
+	relocate_offset = offset;
+}
+
+static inline void update_kernel_address(GElf_Sym *sym, bool kernel)
+{
+	if (kernel)
+		sym->st_value += relocate_offset;
+}
+
 enum dso_origin {
 	DSO__ORIG_KERNEL = 0,
 	DSO__ORIG_JAVA_JIT,
@@ -1012,6 +1024,7 @@ static int dso__load_sym(struct dso *self, struct map *map,
 		if (demangled != NULL)
 			elf_name = demangled;
 new_symbol:
+		update_kernel_address(&sym, kernel);
 		f = symbol__new(sym.st_value, sym.st_size, elf_name);
 		free(demangled);
 		if (!f)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index f27e158..129b4ec 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -10,6 +10,8 @@
 
 #define DEBUG_CACHE_DIR ".debug"
 
+void update_relocate_offset(s32 offset);
+
 #ifdef HAVE_CPLUS_DEMANGLE
 extern char *cplus_demangle(const char *, int);
 
-- 
1.6.1.2


