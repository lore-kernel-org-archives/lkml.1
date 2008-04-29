Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbYD2WGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbYD2WGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYD2WGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:06:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478AbYD2WGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:06:32 -0400
Date: Tue, 29 Apr 2008 15:00:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: pmarques@grupopie.com, linux-kernel@vger.kernel.org, robin.getz@analog.com,
       cooloney@kernel.org
Subject: Re: [PATCH 1/2] kallsyms: Allow kernel symbols in L1 to be found in
 Blackfin architecture
Message-Id: <20080429150050.72750260.akpm@linux-foundation.org>
In-Reply-To: <1209119299-27894-2-git-send-email-cooloney@kernel.org>
References: <1209119299-27894-1-git-send-email-cooloney@kernel.org>
	<1209119299-27894-2-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2008 18:28:18 +0800
Bryan Wu <cooloney@kernel.org> wrote:

> From: Robin Getz <robin.getz@analog.com>
> 
> Add _stext_l1, _etext_l1 for the L1 memory section in Blackfin.
> 
> Signed-off-by: Robin Getz <robin.getz@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  kernel/kallsyms.c  |    6 +++++-
>  scripts/kallsyms.c |    8 +++++++-
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index f091d13..456d1f6 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -55,7 +55,11 @@ static inline int is_kernel_inittext(unsigned long addr)
>  
>  static inline int is_kernel_text(unsigned long addr)
>  {
> -	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_etext)
> +	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext)
> +#if defined(CONFIG_BLACKFIN)
> +             || (addr >= (unsigned long)_stext_l1 && addr <= (unsigned long)_etext_l1)
> +#endif
> +	)

That's a bit grubby.  I suppose we could pretend not to have noticed, but
this really isn't the preferred way of putting arch-specific hooks into
arch-neutral code.

Nicer might be to add

void __weak arch_is_kernel_text(unsigned long addr)
{
	return 0;
}

with a declaration in linux/kallsyms.h and then override
arch_is_kernel_text() in arch/blackfin/ code.


>  		return 1;
>  	return in_gate_area_no_task(addr);
>  }
> diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> index c912137..0f7269f 100644
> --- a/scripts/kallsyms.c
> +++ b/scripts/kallsyms.c
> @@ -41,6 +41,7 @@ struct sym_entry {
>  static struct sym_entry *table;
>  static unsigned int table_size, table_cnt;
>  static unsigned long long _text, _stext, _etext, _sinittext, _einittext;
> +static unsigned long long _stext_l1, _etext_l1;
>  static int all_symbols = 0;
>  static char symbol_prefix_char = '\0';
>  
> @@ -98,6 +99,10 @@ static int read_symbol(FILE *in, struct sym_entry *s)
>  		_sinittext = s->addr;
>  	else if (strcmp(sym, "_einittext") == 0)
>  		_einittext = s->addr;
> +	 else if (strcmp(sym, "_stext_l1" ) == 0)
        ^ stray space
                                         ^ and another one

> +		_stext_l1 = s->addr;
> +	else if (strcmp(sym, "_etext_l1" ) == 0)
> +		_etext_l1 = s->addr;
>  	else if (toupper(stype) == 'A')
>  	{
>  		/* Keep these useful absolute symbols */
> @@ -160,7 +165,8 @@ static int symbol_valid(struct sym_entry *s)
>  	 * and inittext sections are discarded */
>  	if (!all_symbols) {
>  		if ((s->addr < _stext || s->addr > _etext)
> -		    && (s->addr < _sinittext || s->addr > _einittext))
> +		    && (s->addr < _sinittext || s->addr > _einittext)
> +		    && (s->addr < _stext_l1 || s->addr > _etext_l1))

so... for non-blackfin, the above addition is equivalent to

	&& (s->addr < 0 || s->addr > 0)

which is always true, except for s->addr==0, in which case we just broke
it.

I guess addr==0 isn't an interesting case here.


