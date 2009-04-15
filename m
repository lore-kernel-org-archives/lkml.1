Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbZDOB6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbZDOB6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbZDOB61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:58:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50475 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbZDOB60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:58:26 -0400
Message-ID: <49E53F22.8080501@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 09:57:54 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vsprintf: introduce %pf
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> If I remember well, a format which could let us to print a pure
> function name has been suggested by Andrew Morton some monthes ago.
> 
> The current %pF is very convenient to print a function symbol, but
> often we only want to print the name of the function, without
> its asm offset.
> 
> That's what does %pf in this patch.
> The lowecase f has been chosen for its intuitive sense of a weak kind
> of %pF
> 
> The support for this new format would be welcome for the tracing tree
> where the need to print pure function names is often needed and also
> on other parts:
> 
> $ git-grep -E "kallsyms_lookup\(.+?\)"
> arch/blackfin/kernel/traps.c:   symname = kallsyms_lookup(address, &symsize, &offset, &modname, namebuf);
> arch/powerpc/xmon/xmon.c:               name = kallsyms_lookup(pc, &size, &offset, NULL, tmpstr);
> arch/sh/kernel/cpu/sh5/unwind.c:        sym = kallsyms_lookup(pc, NULL, &offset, NULL, namebuf);
> arch/x86/kernel/ftrace.c:       kallsyms_lookup((unsigned long) syscall, NULL, NULL, NULL, str);
> kernel/kprobes.c:               sym = kallsyms_lookup((unsigned long)p->addr, NULL,
> kernel/lockdep.c:       return kallsyms_lookup((unsigned long)key, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup((unsigned long)rec->ops->func, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, NULL, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(rec->ip, NULL, NULL, &modname, str);
> kernel/trace/ftrace.c:  kallsyms_lookup(*ptr, NULL, NULL, NULL, str);
> kernel/trace/trace_functions.c: kallsyms_lookup(ip, NULL, NULL, NULL, str);
> kernel/trace/trace_output.c:    kallsyms_lookup(address, NULL, NULL, NULL, str);
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  lib/vsprintf.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index b56f6d0..15c9094 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -575,12 +575,15 @@ static char *string(char *buf, char *end, char *s, struct printf_spec spec)
>  }
>  
>  static char *symbol_string(char *buf, char *end, void *ptr,
> -				struct printf_spec spec)
> +				struct printf_spec spec, char ext)
>  {
>  	unsigned long value = (unsigned long) ptr;
>  #ifdef CONFIG_KALLSYMS
>  	char sym[KSYM_SYMBOL_LEN];
> -	sprint_symbol(sym, value);
> +	if (ext != 'f')
> +		sprint_symbol(sym, value);
> +	else
> +		kallsyms_lookup(value, NULL, NULL, NULL, sym);
>  	return string(buf, end, sym, spec);
>  #else
>  	spec.field_width = 2*sizeof(void *);
> @@ -692,7 +695,8 @@ static char *ip4_addr_string(char *buf, char *end, u8 *addr,
>   *
>   * Right now we handle:
>   *
> - * - 'F' For symbolic function descriptor pointers
> + * - 'F' For symbolic function descriptor pointers with asm offset
> + * - 'f' For simple function symbol
Hello, Frederic

Good patch.

But is it necessary to add some explain of '%pf' in bstr_printf() and
vsnprintf() as:
  /*
   ...
   * %pS output the name of a text symbol
-  * %pF output the name of a function pointer
+  * %pf output the name of a function pointer
+  * %pF output the name of a function pointer with asm offset
   * %pR output the address range in a struct resource
   ...
   */
For programmers tend to find manual in comment of vsnprintf() instead of
pointer().

Thanks
Zhaolei

>   * - 'S' For symbolic direct pointers
>   * - 'R' For a struct resource pointer, it prints the range of
>   *       addresses (not the name nor the flags)
> @@ -715,10 +719,11 @@ static char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  
>  	switch (*fmt) {
>  	case 'F':
> +	case 'f':
>  		ptr = dereference_function_descriptor(ptr);
>  		/* Fallthrough */
>  	case 'S':
> -		return symbol_string(buf, end, ptr, spec);
> +		return symbol_string(buf, end, ptr, spec, *fmt);
>  	case 'R':
>  		return resource_string(buf, end, ptr, spec);
>  	case 'm':


