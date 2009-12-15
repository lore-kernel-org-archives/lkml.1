Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbZLOCMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbZLOCMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758837AbZLOCMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:12:14 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:43030 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbZLOCMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:12:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wSHoJdRsggbDOwVmwli1nEI8LuSdVjc+wxRoe0AH97vZOcK1W8YIqxMDSFznZMxC09
         pyCBhG6eHLU4KYwiW+sKxnUW8jq/9tGudO4+X0ZwRmTAY7AdIFdjVCT/+PEuZaZVLIps
         SBwF34so5jGL57fltuVjxpG5oZjq8q2Jkq0Rs=
Date: Tue, 15 Dec 2009 03:12:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf symbols: Allow lookups by symbol name
	too
Message-ID: <20091215021201.GB6048@nowhere>
References: <1260564622-12392-1-git-send-email-acme@infradead.org> <tip-79406cd789f745ac6aa9d597895f904a98a14007@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-79406cd789f745ac6aa9d597895f904a98a14007@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 12, 2009 at 07:22:03AM +0000, tip-bot for Arnaldo Carvalho de Melo wrote:
> Commit-ID:  79406cd789f745ac6aa9d597895f904a98a14007
> Gitweb:     http://git.kernel.org/tip/79406cd789f745ac6aa9d597895f904a98a14007
> Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
> AuthorDate: Fri, 11 Dec 2009 18:50:22 -0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 12 Dec 2009 07:42:11 +0100
> 
> perf symbols: Allow lookups by symbol name too
> 
> Configurable via symbol_conf.sort_by_name, so that the cost of an
> extra rb_node on all 'struct symbol' instances is not paid by tools
> that only want to decode addresses.
> 
> How to use it:
> 
> 	symbol_conf.sort_by_name = true;
> 	symbol_init(&symbol_conf);
> 
> 	struct map *map = map_groups__find_by_name(kmaps, MAP__VARIABLE, "[kernel.kallsyms]");
> 
> 	if (map == NULL) {
> 		pr_err("couldn't find map!\n");
> 		kernel_maps__fprintf(stdout);
> 	} else {
> 		struct symbol *sym = map__find_symbol_by_name(map, sym_filter, NULL);
> 		if (sym == NULL)
> 			pr_err("couldn't find symbol %s!\n", sym_filter);
> 		else
> 			pr_info("symbol %s: %#Lx-%#Lx \n", sym_filter, sym->start, sym->end);
> 	}
> 
> Looking over the vmlinux/kallsyms is common enough that I'll add a
> variable to the upcoming struct perf_session to avoid the need to
> use map_groups__find_by_name to get the main vmlinux/kallsyms map.
> 
> The above example looks on the 'variable' symtab, but it is just
> like that for the functions one.
> 
> Also the sort operation is done when we first use
> map__find_symbol_by_name, in a lazy way.



It would be nice to also have a kernel symbol resolution
helper independant of any session.

The problem is that I need to resolve a kernel variable symbol
very early, when we parse record options. We don't have any
session at this time so I can't retrieve the kmaps.

I'm not sure what's the proper way to handle that.

Thanks.

