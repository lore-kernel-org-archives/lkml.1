Return-Path: <linux-kernel-owner+w=401wt.eu-S1759038AbZCMTiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038AbZCMTiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbZCMTiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:38:18 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:43019 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZCMTiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:38:17 -0400
Date: Fri, 13 Mar 2009 20:40:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paulo Marques <pmarques@grupopie.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] kallsyms, tracing: output more proper symbol name
Message-ID: <20090313194013.GA23304@uranus.ravnborg.org>
References: <49B7863F.6020804@cn.fujitsu.com> <20090311094621.GA13543@elte.hu> <49B7B70F.5010908@grupopie.com> <49B876BB.50007@cn.fujitsu.com> <49B92B25.6020805@grupopie.com> <49BA06E2.7080807@cn.fujitsu.com> <49BA2704.9040404@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BA2704.9040404@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 05:27:32PM +0800, Lai Jiangshan wrote:
> Lai Jiangshan wrote:
> > Paulo Marques wrote:
> >> I would probably still place another test to compare the number of
> >> underscores, after both symbols are found to be equal in the "linker
> >> script provided" criteria.
> >>
> >> The way it is now, for my current kallsyms table:
> >>
> >>> ffffffff80200000 A _text
> >>> ffffffff80200000 T startup_64
> >>> ffffffff80209000 T _stext
> >>> ffffffff80209000 t init_post
> >> a "startup_64" address would display as "_text" and a "init_post"
> >> address would display as "_stext".
> >>
> >> You can add all the stext/etext symbols as special cases to the
> >> "may_be_linker_script_provide_symbol" function (like it was on your v1
> >> patch), but I'm just afraid that we'll find more cases in the future
> >> that are not automatically caught by these rules...
> >>
> > 
> 
> [resend, previous v3 has some mistakes]
> 
> Subject:  kallsyms, tracing: output more proper symbol name
> 
> Impact: bugfix, output reliable result
> 
> Debug tools(dump_stack(), ftrace...) are like to print out symbols.
> But it is always print out the first aliased symbol.(Aliased symbols
> are symbols with the same address), and the first aliased symbol is
> sometime not proper.
> 
> # echo function_graph > current_tracer
> # cat trace
> ......
>  1)   1.923 us    |    select_nohz_load_balancer();
>  1) + 76.692 us   |  }
>  1)               |  default_idle() {
>  1)   ==========> |    __irqentry_text_start() {
>  1)   0.000 us    |      native_apic_mem_write();
>  1)               |      irq_enter() {
>  1)   0.000 us    |        idle_cpu();
>  1)               |        tick_check_idle() {
>  1)   0.000 us    |          tick_check_oneshot_broadcast();
>  1)               |          tick_nohz_stop_idle() {
> ......
> 
> It's very embarrassing, it ouputs "__irqentry_text_start()",
> actually, it should output "smp_apic_timer_interrupt()".
> (these two symbol are the same address, but "__irqentry_text_start"
> is deemed to the first aliased symbol by scripts/kallsyms)
> 
> This patch puts symbols like "__irqentry_text_start" to the second
> aliased symbols. And a more proper symbol name becomes the first.
> 
> Aliased symbols mostly come from linker script. The solution is
> guessing "is this symbol defined in linker script", the symbols
> defined in linker script will not become the first aliased symbol.
> 
> And if symbols are found to be equal in this "linker script provided"
> criteria, symbols are sorted by the number of prefix underscores.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Looks good to me.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
