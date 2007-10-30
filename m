Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbXJ3Xvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbXJ3Xvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbXJ3Xu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:50:58 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:43016 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753960AbXJ3Xux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:50:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAAZgJ0dMQWvU/2dsb2JhbACBWo5a
Date: Tue, 30 Oct 2007 19:45:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "systemtap@sourceware.org" <systemtap@sourceware.org>
Subject: Re: kallsyms __print_symbol prints first weak symbol encountered
Message-ID: <20071030234550.GA27171@Krystal>
References: <20071030174902.GA6513@Krystal> <47278AB5.5060308@grupopie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <47278AB5.5060308@grupopie.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:45:13 up 93 days, 4 min,  4 users,  load average: 0.84, 0.51, 0.54
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Paulo Marques (pmarques@grupopie.com) wrote:
> Mathieu Desnoyers wrote:
> >Hi,
> 
> Hi,
> 
> >[...]
> >kallsyms returns the first symbol encountered, even though it is weak,
> >when it should in fact return sys_ni_syscall.
> >
> >Is it a concern for anyone else out there ? Would it make sense to fix
> >it ?
> 
> I don't know if it is a concern, but if we're going to fix it, we should
> probably do it in "scripts/kallsyms" by providing a list that is already
> sorted according to "address, weakness".
> 
> This way the run-time kernel keeps the current behavior, without any 
> overhead. Something along the lines of the attached patch (just compile 
> tested).
> 
> However, this is an area where we've had problems in the past with some 
> architectures giving different results between passes, and then any 
> change to the symbol order might make the problem worse and make the 
> build process fail with a "Inconsistent kallsyms data" error message.
> 
> So, if someone wants to use this, it should go through -mm for a while, 
> first.
> 

Runtime test is ok. It fixes the problem. Thanks!

Mathieu

> -- 
> Paulo Marques - www.grupopie.com
> 
> "All I ask is a chance to prove that money can't make me happy."

> --- ./scripts/kallsyms.c.orig	2007-10-30 18:51:28.000000000 +0000
> +++ ./scripts/kallsyms.c	2007-10-30 19:07:58.000000000 +0000
> @@ -34,7 +34,7 @@
>  
>  struct sym_entry {
>  	unsigned long long addr;
> -	unsigned int len;
> +	unsigned int len, start_pos;
>  	unsigned char *sym;
>  };
>  
> @@ -202,8 +202,10 @@ static void read_map(FILE *in)
>  				exit (1);
>  			}
>  		}
> -		if (read_symbol(in, &table[table_cnt]) == 0)
> +		if (read_symbol(in, &table[table_cnt]) == 0) {
> +			table[table_cnt].start_pos = table_cnt;
>  			table_cnt++;
> +		}
>  	}
>  }
>  
> @@ -507,6 +509,35 @@ static void optimize_token_table(void)
>  }
>  
>  
> +static int compare_symbols(const void *a, const void *b)
> +{
> +	struct sym_entry *sa, *sb;
> +	int wa, wb;
> +
> +	sa = (struct sym_entry *) a;
> +	sb = (struct sym_entry *) b;
> +
> +	// sort by address first
> +	if (sa->addr > sb->addr)
> +		return 1;
> +	if (sa->addr < sb->addr)
> +		return -1;
> +
> +	// sort by "weakness" type
> +	wa = (sa->sym[0] == 'w') || (sa->sym[0] == 'W');
> +	wb = (sb->sym[0] == 'w') || (sb->sym[0] == 'W');
> +	if (wa != wb)
> +		return wa - wb;
> +
> +	// sort by initial order, so that other symbols are left undisturbed
> +	return sa->start_pos - sb->start_pos;
> +}
> +
> +static void sort_symbols(void)
> +{
> +	qsort(table, table_cnt, sizeof(struct sym_entry), compare_symbols);
> +}
> +
>  int main(int argc, char **argv)
>  {
>  	if (argc >= 2) {
> @@ -527,6 +558,7 @@ int main(int argc, char **argv)
>  		usage();
>  
>  	read_map(stdin);
> +	sort_symbols();
>  	optimize_token_table();
>  	write_src();
>  
> 


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
