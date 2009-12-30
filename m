Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbZL3NKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbZL3NKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 08:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZL3NKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 08:10:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:53696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZL3NKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 08:10:39 -0500
Date: Wed, 30 Dec 2009 11:10:16 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] perf tools: adjust symbol address
Message-ID: <20091230131016.GC2956@ghostprotocols.net>
References: <4B3AC5CD.1000502@cn.fujitsu.com>
 <4B3AC69F.4070901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3AC69F.4070901@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 30, 2009 at 11:18:55AM +0800, Xiao Guangrong escreveu:
> Using relocation offset adjust symbol address if we get
> kernel symbol name form elf file
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 79ca6a0..5b58d34 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -19,6 +19,18 @@
>  #define NT_GNU_BUILD_ID 3
>  #endif
>  
> +static s32 relocate_offset;
> +void update_relocate_offset(s32 offset)
> +{
> +	relocate_offset = offset;
> +}
> +
> +static inline void update_kernel_address(GElf_Sym *sym, bool kernel)
> +{
> +	if (kernel)
> +		sym->st_value += relocate_offset;
> +}

This should be done on the dso level, we may process multiple kernels,
some with relocation, some without.

Humm, even at the _map_ level, because then we can just use the normal
map_ip mechanism, this time the not using the identity map stuff, i.e.
we have to get an IP from some event, then subtract the relocate_offset
that will be in map->start.

- Arnaldo
