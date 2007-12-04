Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbXLDVT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbXLDVT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXLDVTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:19:16 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:52368 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772AbXLDVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:19:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAJtSVUdMROHU/2dsb2JhbACBWg
Date: Tue, 4 Dec 2007 16:14:10 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [-mm PATCH] kallsyms should prefer non weak symbols
Message-ID: <20071204211410.GA5995@Krystal>
References: <4755BA14.8060706@grupopie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4755BA14.8060706@grupopie.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:12:46 up 31 days,  2:18,  7 users,  load average: 0.20, 0.25,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paulo Marques (pmarques@grupopie.com) wrote:
>
> When resolving symbol names from addresses with aliased symbol names, 
> kallsyms_lookup always returns the first symbol, even if it is a weak 
> symbol.
>
> This patch changes this by sorting the symbols with the weak symbols last 
> before feeding them to the kernel. This way the kernel runtime isn't 
> changed at all, only the kallsyms build system is changed.
>
> Another side effect is that the symbols get sorted by address, too. So, 
> even if future binutils version have some bug in "nm" that makes it fail to 
> correctly sort symbols by address, the kernel won't be affected by this.
>
>
> From: Paulo Marques <pmarques@grupopie.com>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>

Please wait for me to accept the changes before adding signed-off-by.

See comment below,

> -- 
> Paulo Marques - www.grupopie.com
>
> "There cannot be a crisis today; my schedule is already full."

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

Comments should be /* */ , not //.

Please run through scripts/checkpatch.pl before submitting.

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
