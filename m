Return-Path: <linux-kernel-owner+w=401wt.eu-S1754913AbZCKO1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbZCKO1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 10:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZCKO1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 10:27:07 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:60249 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZCKO1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 10:27:06 -0400
X-Greylist: delayed 2999 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 10:27:05 EDT
Message-ID: <49B7B70F.5010908@grupopie.com>
Date: Wed, 11 Mar 2009 13:05:19 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kallsyms, tracing: output more proper symbol name
References: <49B7863F.6020804@cn.fujitsu.com> <20090311094621.GA13543@elte.hu>
In-Reply-To: <20090311094621.GA13543@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
>> +#define VMLINUX_SYMBOL(_sym_) #_sym_
>> +
>> +static const char *hide_symbols[] = {
>> +	/* misc symbols */
>> +	"_text",
>> +	"_stext",
>> +	"_etext",
>> +	"_sinittext",
>> +	"_einittext",
>> +
>> +	/* symbols from include/asm-generic/vmlinux.lds.h */
>> +	VMLINUX_SYMBOL(__start_mcount_loc),
>> +	VMLINUX_SYMBOL(__stop_mcount_loc),
[...]
>> +	VMLINUX_SYMBOL(__early_initcall_end),
>> +	VMLINUX_SYMBOL(__per_cpu_start),
>> +	VMLINUX_SYMBOL(__per_cpu_end)
>> +};
> 
> I like how you try to solve this at symbol table generation 
> time.

Yes, this is the proper way to do it.

> Instead of this hardcoded table, couldnt we use some more 
> flexible and more future-proof method? Such as ordering 
> same-address symbols by underscores:
> 
>   [same address]
> 
>   non-underscore symbols first        XYZ
>   single-undescroe symbols second     _XYZ
>   double-underscore symbols third     __XYZ
> 
> that way the scheme would be more or less self-maintaining as an 
> underscore already carries a "this is a special, internal 
> symbol" notion.

I agree with this approach, but to be on the side we should skim through
the alias and see if this works for most symbols or not.

I just did this for the symbols on my running kernel and it seems to
work. The hierarchy for '_' and '__' is in fact necessary:

> ffffffff80447418 T __sched_text_start
> ffffffff80447418 t sleep_on_common
> ffffffff80449830 T __lock_text_start
> ffffffff80449830 T __sched_text_end
> ffffffff80449830 T _spin_trylock
> ffffffff80453d50 R __stop___ex_table
> ffffffff80453d50 T __start_notes
> ffffffff8045b000 R __start_rodata
> ffffffff8045b000 R linux_banner

or that "_spin_trylock" might be displayed incorrectly as
"__sched_text_end" or something like that.

-- 
Paulo Marques - www.grupopie.com

"Who is general Failure and why is he reading my disk?"
