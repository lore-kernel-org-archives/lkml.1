Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZCLCpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZCLCpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 22:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZCLCpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 22:45:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62818 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbZCLCpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 22:45:08 -0400
Message-ID: <49B876BB.50007@cn.fujitsu.com>
Date: Thu, 12 Mar 2009 10:43:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@osdl.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kallsyms, tracing: output more proper symbol name
References: <49B7863F.6020804@cn.fujitsu.com> <20090311094621.GA13543@elte.hu> <49B7B70F.5010908@grupopie.com>
In-Reply-To: <49B7B70F.5010908@grupopie.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paulo Marques wrote:
> Ingo Molnar wrote:
>> I like how you try to solve this at symbol table generation 
>> time.
> 
> Yes, this is the proper way to do it.
> 
>> Instead of this hardcoded table, couldnt we use some more 
>> flexible and more future-proof method? Such as ordering 
>> same-address symbols by underscores:
>>
>>   [same address]
>>
>>   non-underscore symbols first        XYZ
>>   single-undescroe symbols second     _XYZ
>>   double-underscore symbols third     __XYZ
>>
>> that way the scheme would be more or less self-maintaining as an 
>> underscore already carries a "this is a special, internal 
>> symbol" notion.
> 
> I agree with this approach, but to be on the side we should skim through
> the alias and see if this works for most symbols or not.
> 
> I just did this for the symbols on my running kernel and it seems to
> work. The hierarchy for '_' and '__' is in fact necessary:
> 
>> ffffffff80447418 T __sched_text_start
>> ffffffff80447418 t sleep_on_common
>> ffffffff80449830 T __lock_text_start
>> ffffffff80449830 T __sched_text_end
>> ffffffff80449830 T _spin_trylock
>> ffffffff80453d50 R __stop___ex_table
>> ffffffff80453d50 T __start_notes
>> ffffffff8045b000 R __start_rodata
>> ffffffff8045b000 R linux_banner
> 
> or that "_spin_trylock" might be displayed incorrectly as
> "__sched_text_end" or something like that.
> 

sort by underscore may be incorrect. A lots of symbol in .c
file is '_' or '__' prefix, human are happy to see these symbol.

Symbols in my table(in V1 patch) are linker-script-provide symbols.
Aliased symbols mostly come from linker script. Now, v2 patch's ordering:

	[same address]
	symbol defined in .c or .S
	symbol defined in linker script

From: Lai Jiangshan <laijs@cn.fujitsu.com>

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

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index ad2434b..c6924d4 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -500,11 +500,46 @@ static void optimize_token_table(void)
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
 static int compare_symbols(const void *a, const void *b)
 {
 	const struct sym_entry *sa;
 	const struct sym_entry *sb;
-	int wa, wb;
+	int wa, wb, la, lb;
 
 	sa = a;
 	sb = b;
@@ -521,6 +556,12 @@ static int compare_symbols(const void *a, const void *b)
 	if (wa != wb)
 		return wa - wb;
 
+	/* sort by "linker script provide" type */
+	la = may_be_linker_script_provide_symbol(sa);
+	lb = may_be_linker_script_provide_symbol(sb);
+	if (la != lb)
+		return la - lb;
+
 	/* sort by initial order, so that other symbols are left undisturbed */
 	return sa->start_pos - sb->start_pos;
 }

