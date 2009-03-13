Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZCMHMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZCMHMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842AbZCMHMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:12:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50320 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZCMHMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:12:01 -0400
Message-ID: <49BA06E2.7080807@cn.fujitsu.com>
Date: Fri, 13 Mar 2009 15:10:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH V3] kallsyms, tracing: output more proper symbol name
References: <49B7863F.6020804@cn.fujitsu.com> <20090311094621.GA13543@elte.hu> <49B7B70F.5010908@grupopie.com> <49B876BB.50007@cn.fujitsu.com> <49B92B25.6020805@grupopie.com>
In-Reply-To: <49B92B25.6020805@grupopie.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulo Marques wrote:
> I would probably still place another test to compare the number of
> underscores, after both symbols are found to be equal in the "linker
> script provided" criteria.
> 
> The way it is now, for my current kallsyms table:
> 
>> ffffffff80200000 A _text
>> ffffffff80200000 T startup_64
>> ffffffff80209000 T _stext
>> ffffffff80209000 t init_post
> 
> a "startup_64" address would display as "_text" and a "init_post"
> address would display as "_stext".
> 
> You can add all the stext/etext symbols as special cases to the
> "may_be_linker_script_provide_symbol" function (like it was on your v1
> patch), but I'm just afraid that we'll find more cases in the future
> that are not automatically caught by these rules...
> 

Subject:  kallsyms, tracing: output more proper symbol name

Impact: bugfix, output reliable result

Debug tools(dump_stack(), ftrace...) are like to print out symbols.
But it is always print out the first aliased symbol.(Aliased symbols
are symbols with the same address), and the first aliased symbol is
sometime not proper.

# echo function_graph > current_tracer
# cat trace
......
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
......

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
---
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
