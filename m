Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbZCNI6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbZCNI6T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbZCNI6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:58:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:50533 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZCNI6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:58:03 -0400
Date: Sat, 14 Mar 2009 08:57:28 GMT
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       sam@ravnborg.org, pmarques@grupopie.com, tglx@linutronix.de,
       laijs@cn.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, tglx@linutronix.de, pmarques@grupopie.com,
       laijs@cn.fujitsu.com, mingo@elte.hu
In-Reply-To: <49BA06E2.7080807@cn.fujitsu.com>
References: <49BA06E2.7080807@cn.fujitsu.com>
Subject: [tip:tracing/ftrace] kallsyms, tracing: output more proper symbol name
Message-ID: <tip-b478b782e110fdb4135caa3062b6d687e989d994@git.kernel.org>
Git-Commit-ID: b478b782e110fdb4135caa3062b6d687e989d994
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 14 Mar 2009 08:57:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b478b782e110fdb4135caa3062b6d687e989d994
Gitweb:     http://git.kernel.org/tip/b478b782e110fdb4135caa3062b6d687e989d994
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Fri, 13 Mar 2009 15:10:26 +0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 14 Mar 2009 09:55:04 +0100

kallsyms, tracing: output more proper symbol name

Impact: bugfix, output more reliable symbol lookup result

Debug tools(dump_stack(), ftrace...) are like to print out symbols.
But it is always print out the first aliased symbol.(Aliased symbols
are symbols with the same address), and the first aliased symbol is
sometime not proper.

 # echo function_graph > current_tracer
 # cat trace
.....
 1)   1.923 us    |    select_nohz_load_balancer();
 1) + 76.692 us   |  }
 1)               |  default_idle() {
 1)   ==========> |    __irqentry_text_start() {
 1)   0.000 us    |      native_apic_mem_write();
 1)               |      irq_enter() {
 1)   0.000 us    |        idle_cpu();
 1)               |        tick_check_idle() {
 1)   0.000 us    |          tick_check_oneshot_broadcast();
 1)               |          tick_nohz_stop_idle() {
.....

It's very embarrassing, it ouputs "__irqentry_text_start()",
actually, it should output "smp_apic_timer_interrupt()".
(these two symbol are the same address, but "__irqentry_text_start"
is deemed to the first aliased symbol by scripts/kallsyms)

This patch puts symbols like "__irqentry_text_start" to the second
aliased symbols. And a more proper symbol name becomes the first.

Aliased symbols mostly come from linker script. The solution is
guessing "is this symbol defined in linker script", the symbols
defined in linker script will not become the first aliased symbol.

And if symbols are found to be equal in this "linker script provided"
criteria, symbols are sorted by the number of prefix underscores.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Paulo Marques <pmarques@grupopie.com>
LKML-Reference: <49BA06E2.7080807@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 scripts/kallsyms.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index ad2434b..6654cbe 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -500,6 +500,51 @@ static void optimize_token_table(void)
 	optimize_result();
 }
 
+/* guess for "linker script provide" symbol */
+static int may_be_linker_script_provide_symbol(const struct sym_entry *se)
+{
+	const char *symbol = (char *)se->sym + 1;
+	int len = se->len - 1;
+
+	if (len < 8)
+		return 0;
+
+	if (symbol[0] != '_' || symbol[1] != '_')
+		return 0;
+
+	/* __start_XXXXX */
+	if (!memcmp(symbol + 2, "start_", 6))
+		return 1;
+
+	/* __stop_XXXXX */
+	if (!memcmp(symbol + 2, "stop_", 5))
+		return 1;
+
+	/* __end_XXXXX */
+	if (!memcmp(symbol + 2, "end_", 4))
+		return 1;
+
+	/* __XXXXX_start */
+	if (!memcmp(symbol + len - 6, "_start", 6))
+		return 1;
+
+	/* __XXXXX_end */
+	if (!memcmp(symbol + len - 4, "_end", 4))
+		return 1;
+
+	return 0;
+}
+
+static int prefix_underscores_count(const char *str)
+{
+	const char *tail = str;
+
+	while (*tail != '_')
+		tail++;
+
+	return tail - str;
+}
+
 static int compare_symbols(const void *a, const void *b)
 {
 	const struct sym_entry *sa;
@@ -521,6 +566,18 @@ static int compare_symbols(const void *a, const void *b)
 	if (wa != wb)
 		return wa - wb;
 
+	/* sort by "linker script provide" type */
+	wa = may_be_linker_script_provide_symbol(sa);
+	wb = may_be_linker_script_provide_symbol(sb);
+	if (wa != wb)
+		return wa - wb;
+
+	/* sort by the number of prefix underscores */
+	wa = prefix_underscores_count((const char *)sa->sym + 1);
+	wb = prefix_underscores_count((const char *)sb->sym + 1);
+	if (wa != wb)
+		return wa - wb;
+
 	/* sort by initial order, so that other symbols are left undisturbed */
 	return sa->start_pos - sb->start_pos;
 }
