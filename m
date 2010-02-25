Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab0BYPdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:33:12 -0500
Received: from tomts13.bellnexxia.net ([209.226.175.34]:53055 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634Ab0BYPdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:33:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAAInhktGGOM5/2dsb2JhbACbFnS9A4R1BIMX
Date: Thu, 25 Feb 2010 10:33:05 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip v3&10 07/18] x86: Add text_poke_smp for SMP cross
	modifying code
Message-ID: <20100225153305.GC12635@Krystal>
References: <20100225133342.6725.26971.stgit@localhost6.localdomain6> <20100225133438.6725.80273.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100225133438.6725.80273.stgit@localhost6.localdomain6>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:25:11 up 70 days, 23:43,  4 users,  load average: 0.15, 0.10,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Add generic text_poke_smp for SMP which uses stop_machine()
> to synchronize modifying code.
> This stop_machine() method is officially described at "7.1.3
> Handling Self- and Cross-Modifying Code" on the intel's
> software developer's manual 3A.
> 
> Since stop_machine() can't protect code against NMI/MCE, this
> function can not modify those handlers. And also, this function
> is basically for modifying multibyte-single-instruction. For
> modifying multibyte-multi-instructions, we need another special
> trap & detour code.
> 
> This code originaly comes from immediate values with stop_machine()
> version. Thanks Jason and Mathieu!
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Anders Kaseorg <andersk@ksplice.com>
> Cc: Tim Abbott <tabbott@ksplice.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Jason Baron <jbaron@redhat.com>
> ---
> 
>  arch/x86/include/asm/alternative.h |    4 ++
>  arch/x86/kernel/alternative.c      |   60 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
> index f1e253c..b09ec55 100644
> --- a/arch/x86/include/asm/alternative.h
> +++ b/arch/x86/include/asm/alternative.h
> @@ -165,10 +165,12 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
>   * invalid instruction possible) or if the instructions are changed from a
>   * consistent state to another consistent state atomically.
>   * More care must be taken when modifying code in the SMP case because of
> - * Intel's errata.
> + * Intel's errata. text_poke_smp() takes care that errata, but still
> + * doesn't support NMI/MCE handler code modifying.
>   * On the local CPU you need to be protected again NMI or MCE handlers seeing an
>   * inconsistent instruction while you patch.
>   */
>  extern void *text_poke(void *addr, const void *opcode, size_t len);
> +extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
>  
>  #endif /* _ASM_X86_ALTERNATIVE_H */
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index e6ea034..635e4f4 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -7,6 +7,7 @@
>  #include <linux/mm.h>
>  #include <linux/vmalloc.h>
>  #include <linux/memory.h>
> +#include <linux/stop_machine.h>
>  #include <asm/alternative.h>
>  #include <asm/sections.h>
>  #include <asm/pgtable.h>
> @@ -572,3 +573,62 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
>  	local_irq_restore(flags);
>  	return addr;
>  }
> +
> +/*
> + * Cross-modifying kernel text with stop_machine().
> + * This code originally comes from immediate value.
> + */
> +static atomic_t stop_machine_first;
> +static int wrote_text;
> +
> +struct text_poke_params {
> +	void *addr;
> +	const void *opcode;
> +	size_t len;
> +};
> +
> +static int __kprobes stop_machine_text_poke(void *data)
> +{
> +	struct text_poke_params *tpp = data;
> +
> +	if (atomic_dec_and_test(&stop_machine_first)) {
> +		text_poke(tpp->addr, tpp->opcode, tpp->len);
> +		smp_wmb();	/* Make sure other cpus see that this has run */
> +		wrote_text = 1;
> +	} else {
> +		while (!wrote_text)
> +			smp_rmb();
> +		sync_core();

Hrm, there is a problem in there. The last loop, when wrote_text becomes
true, does not perform any smp_mb(), so you end up in a situation where
cpus in the "else" branch may never issue any memory barrier. I'd rather
do:

+static volatile int wrote_text;

...

+static int __kprobes stop_machine_text_poke(void *data)
+{
+	struct text_poke_params *tpp = data;
+
+	if (atomic_dec_and_test(&stop_machine_first)) {
+		text_poke(tpp->addr, tpp->opcode, tpp->len);
+		smp_wmb();	/* order text_poke stores before store to wrote_text */
+		wrote_text = 1;
+	} else {
+		while (!wrote_text)
+			cpu_relax();
+		smp_mb();	/* order wrote_text load before following execution */
+	}

If you don't like the "volatile int" definition of wrote_text, then we
should probably use the ACCESS_ONCE() macro instead.

Thanks,

Mathieu

> +	}
> +
> +	flush_icache_range((unsigned long)tpp->addr,
> +			   (unsigned long)tpp->addr + tpp->len);
> +	return 0;
> +}
> +
> +/**
> + * text_poke_smp - Update instructions on a live kernel on SMP
> + * @addr: address to modify
> + * @opcode: source of the copy
> + * @len: length to copy
> + *
> + * Modify multi-byte instruction by using stop_machine() on SMP. This allows
> + * user to poke/set multi-byte text on SMP. Only non-NMI/MCE code modifying
> + * should be allowed, since stop_machine() does _not_ protect code against
> + * NMI and MCE.
> + *
> + * Note: Must be called under get_online_cpus() and text_mutex.
> + */
> +void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
> +{
> +	struct text_poke_params tpp;
> +
> +	tpp.addr = addr;
> +	tpp.opcode = opcode;
> +	tpp.len = len;
> +	atomic_set(&stop_machine_first, 1);
> +	wrote_text = 0;
> +	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
> +	return addr;
> +}
> +
> 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
