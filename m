Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbZCMT0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbZCMT0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 15:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbZCMT0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 15:26:14 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:40177 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZCMT0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 15:26:13 -0400
Message-ID: <49BAB342.6040407@grupopie.com>
Date: Fri, 13 Mar 2009 19:25:54 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] kallsyms, tracing: output more proper symbol name
References: <49B7863F.6020804@cn.fujitsu.com> <20090311094621.GA13543@elte.hu> <49B7B70F.5010908@grupopie.com> <49B876BB.50007@cn.fujitsu.com> <49B92B25.6020805@grupopie.com> <49BA06E2.7080807@cn.fujitsu.com> <49BA2704.9040404@cn.fujitsu.com>
In-Reply-To: <49BA2704.9040404@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> [...]
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
> [...]
> Aliased symbols mostly come from linker script. The solution is
> guessing "is this symbol defined in linker script", the symbols
> defined in linker script will not become the first aliased symbol.
> 
> And if symbols are found to be equal in this "linker script provided"
> criteria, symbols are sorted by the number of prefix underscores.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> [...]
> +static int prefix_underscores_count(const char *str)
> +{
> +	const char *tail = str;
> +
> +	while (*tail == '_')
> +		tail++;
> +
> +	return tail - str;
> +}
> +
>  static int compare_symbols(const void *a, const void *b)
>  {
>  	const struct sym_entry *sa;
> @@ -521,6 +566,18 @@ static int compare_symbols(const void *a, const void *b)
>  	if (wa != wb)
>  		return wa - wb;
>  
> +	/* sort by "linker script provide" type */
> +	wa = may_be_linker_script_provide_symbol(sa);
> +	wb = may_be_linker_script_provide_symbol(sb);
> +	if (wa != wb)
> +		return wa - wb;
> +
> +	/* sort by the number of prefix underscores */
> +	wa = prefix_underscores_count((const char *)sa->sym + 1);
> +	wb = prefix_underscores_count((const char *)sb->sym + 1);
> +	if (wa != wb)
> +		return wa - wb;
> +
>  	/* sort by initial order, so that other symbols are left undisturbed */
>  	return sa->start_pos - sb->start_pos;
>  }

The code seems fine. I have no time to compile and test it right now,
but there are no obvious problems as far as I can see.

Reviewed-by: Paulo Marques <pmarques@grupopie.com>

-- 
Paulo Marques - www.grupopie.com

"Measure with laser, mark with chalk, cut with chainsaw."
