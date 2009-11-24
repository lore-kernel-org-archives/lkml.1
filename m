Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZKXF0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZKXF0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 00:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZKXF0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 00:26:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49603 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZKXF0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 00:26:20 -0500
Message-ID: <4B0B6E5C.4080900@cn.fujitsu.com>
Date: Tue, 24 Nov 2009 13:25:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 1/5] perf kmem: Add new option to show raw ip
References: <4B0B6E44.6090106@cn.fujitsu.com>
In-Reply-To: <4B0B6E44.6090106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add option "--raw-ip" to show raw ip instead of symbols:

 # ./perf kmem --stat caller --raw-ip
 ------------------------------------------------------------------------------
 Callsite                    |Total_alloc/Per | Total_req/Per | Hit  | Frag
 ------------------------------------------------------------------------------
 0xc05301aa                  |  733184/4096   |  733184/4096  |   179|   0.000%
 0xc0542ba0                  |  483328/4096   |  483328/4096  |   118|   0.000%
 ...

Also show symbols with format sym+offset instead of sym/offset.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/builtin-kmem.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 256d18f..1ef43c2 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -32,15 +32,14 @@ sort_fn_t			caller_sort_fn;
 static int			alloc_lines = -1;
 static int			caller_lines = -1;
 
+static bool			raw_ip;
+
 static char			*cwd;
 static int			cwdlen;
 
 struct alloc_stat {
 	union {
-		struct {
-			char	*name;
-			u64	call_site;
-		};
+		u64	call_site;
 		u64	ptr;
 	};
 	u64	bytes_req;
@@ -323,12 +322,14 @@ static void __print_result(struct rb_root *root, int n_lines, int is_caller)
 
 		if (is_caller) {
 			addr = data->call_site;
-			sym = kernel_maps__find_symbol(addr, NULL, NULL);
+			if (!raw_ip)
+				sym = kernel_maps__find_symbol(addr,
+							       NULL, NULL);
 		} else
 			addr = data->ptr;
 
 		if (sym != NULL)
-			snprintf(bf, sizeof(bf), "%s/%Lx", sym->name,
+			snprintf(bf, sizeof(bf), "%s+%Lx", sym->name,
 				 addr - sym->start);
 		else
 			snprintf(bf, sizeof(bf), "%#Lx", addr);
@@ -345,9 +346,9 @@ static void __print_result(struct rb_root *root, int n_lines, int is_caller)
 	}
 
 	if (n_lines == -1)
-		printf(" ...               | ...             | ...             | ...    | ...   \n");
+		printf(" ...                        | ...            | ...           | ...    | ...   \n");
 
-	printf(" ------------------------------------------------------------------------------\n");
+	printf("%.78s\n", graph_dotted_line);
 }
 
 static void print_summary(void)
@@ -558,6 +559,7 @@ static const struct option kmem_options[] = {
 	OPT_CALLBACK('l', "line", NULL, "num",
 		     "show n lins",
 		     parse_line_opt),
+	OPT_BOOLEAN(0, "raw-ip", &raw_ip, "show raw ip instead of symbol"),
 	OPT_END()
 };
 
-- 
1.6.3

