Return-Path: <linux-kernel-owner+w=401wt.eu-S1756561AbZCLPdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561AbZCLPdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZCLPc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:32:58 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:48551 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZCLPc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:32:57 -0400
X-Greylist: delayed 95253 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Mar 2009 11:32:56 EDT
Message-ID: <49B92B25.6020805@grupopie.com>
Date: Thu, 12 Mar 2009 15:32:53 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kallsyms, tracing: output more proper symbol name
References: <49B7863F.6020804@cn.fujitsu.com> <20090311094621.GA13543@elte.hu> <49B7B70F.5010908@grupopie.com> <49B876BB.50007@cn.fujitsu.com>
In-Reply-To: <49B876BB.50007@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Paulo Marques wrote:
>> Ingo Molnar wrote:
>>> I like how you try to solve this at symbol table generation 
>>> time.
>> Yes, this is the proper way to do it.
>>
>>> Instead of this hardcoded table, couldnt we use some more 
>>> flexible and more future-proof method? Such as ordering 
>>> same-address symbols by underscores:
>>>
>>>   [same address]
>>>
>>>   non-underscore symbols first        XYZ
>>>   single-undescroe symbols second     _XYZ
>>>   double-underscore symbols third     __XYZ
>>>
>>> that way the scheme would be more or less self-maintaining as an 
>>> underscore already carries a "this is a special, internal 
>>> symbol" notion.
>> I agree with this approach, but to be on the side we should skim through
>> the alias and see if this works for most symbols or not.
>>
>> I just did this for the symbols on my running kernel and it seems to
>> work. The hierarchy for '_' and '__' is in fact necessary:
>>
>>> ffffffff80447418 T __sched_text_start
>>> ffffffff80447418 t sleep_on_common
>>> ffffffff80449830 T __lock_text_start
>>> ffffffff80449830 T __sched_text_end
>>> ffffffff80449830 T _spin_trylock
>>> ffffffff80453d50 R __stop___ex_table
>>> ffffffff80453d50 T __start_notes
>>> ffffffff8045b000 R __start_rodata
>>> ffffffff8045b000 R linux_banner
>> or that "_spin_trylock" might be displayed incorrectly as
>> "__sched_text_end" or something like that.
>>
> 
> sort by underscore may be incorrect. A lots of symbol in .c
> file is '_' or '__' prefix, human are happy to see these symbol.

Since this is just a secondary criteria that applies only to _aliased_
symbols, this shouldn't be a big problem. Symbols with different
addresses are properly placed in the correct order.

> Symbols in my table(in V1 patch) are linker-script-provide symbols.
> Aliased symbols mostly come from linker script. Now, v2 patch's ordering:
> 
> 	[same address]
> 	symbol defined in .c or .S
> 	symbol defined in linker script
> 
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
[...]
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index ad2434b..c6924d4 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -500,11 +500,46 @@ static void optimize_token_table(void)
>  	optimize_result();
>  }
>  
> +/* guess for "linker script provide" symbol */
> +static int may_be_linker_script_provide_symbol(const struct sym_entry *se)
> +{
> +	const char *symbol = (char *)se->sym + 1;
> +	int len = se->len - 1;
> +
> +	if (len < 8)
> +		return 0;
> +
> +	if (symbol[0] != '_' || symbol[1] != '_')
> +		return 0;
> +
> +	/* __start_XXXXX */
> +	if (!memcmp(symbol + 2, "start_", 6))
> +		return 1;
> +
> +	/* __stop_XXXXX */
> +	if (!memcmp(symbol + 2, "stop_", 5))
> +		return 1;
> +
> +	/* __end_XXXXX */
> +	if (!memcmp(symbol + 2, "end_", 4))
> +		return 1;
> +
> +	/* __XXXXX_start */
> +	if (!memcmp(symbol + len - 6, "_start", 6))
> +		return 1;
> +
> +	/* __XXXXX_end */
> +	if (!memcmp(symbol + len - 4, "_end", 4))
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static int compare_symbols(const void *a, const void *b)
>  {
>  	const struct sym_entry *sa;
>  	const struct sym_entry *sb;
> -	int wa, wb;
> +	int wa, wb, la, lb;
>  
>  	sa = a;
>  	sb = b;
> @@ -521,6 +556,12 @@ static int compare_symbols(const void *a, const void *b)
>  	if (wa != wb)
>  		return wa - wb;
>  
> +	/* sort by "linker script provide" type */
> +	la = may_be_linker_script_provide_symbol(sa);
> +	lb = may_be_linker_script_provide_symbol(sb);
> +	if (la != lb)
> +		return la - lb;
> +
>  	/* sort by initial order, so that other symbols are left undisturbed */
>  	return sa->start_pos - sb->start_pos;
>  }

I would probably still place another test to compare the number of
underscores, after both symbols are found to be equal in the "linker
script provided" criteria.

The way it is now, for my current kallsyms table:

> ffffffff80200000 A _text
> ffffffff80200000 T startup_64
> ffffffff80209000 T _stext
> ffffffff80209000 t init_post

a "startup_64" address would display as "_text" and a "init_post"
address would display as "_stext".

You can add all the stext/etext symbols as special cases to the
"may_be_linker_script_provide_symbol" function (like it was on your v1
patch), but I'm just afraid that we'll find more cases in the future
that are not automatically caught by these rules...

-- 
Paulo Marques - www.grupopie.com

"All generalizations are false."
