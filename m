Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbZCSHqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbZCSHqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbZCSHqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:46:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45528 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbZCSHqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:46:43 -0400
Date: Thu, 19 Mar 2009 08:46:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: oops in tracepoint_update_probe_range()
Message-ID: <20090319074616.GA17144@elte.hu>
References: <1237393396.3322.6.camel@localhost.localdomain> <20090318163531.GE21331@elte.hu> <49C1F1DF.2020105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C1F1DF.2020105@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> >> Good: f4c3c4cdb1de232
> >> Bad : 1e08816af0bc345
> >>
> >> Config:
> >> http://userweb.kernel.org/~jaswinder/oops_20090318/config-hpdv5-tip-bad-20090318
> >>
> >> oops:
> >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page1.jpg
> >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page2.jpg
> >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page3.jpg
> >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page4.jpg
> >>
> >> <freeze>
> > 
> > Steve, Frederic - the crashes above are in:
> > 
> > 	tracepoint_update_probe_range()
> > 
> > in a modular kernel apparently.
> > 
> >
> 
> I look up the jpg files, this oops is occurred when a new module is
> being loaded.
> 
> tracepoint_module_notify() is added by Mathieu Desnoyers on the
> suggestion of me.
> 
> tracepoint_update_probe_range() and tracepoint_module_notify()
> can not trigger this oops if the arguments are correct.
> 
> If @begin is NULL, @end is NULL too, it's ensued by kernel/module.c.
> 
> load_module(...):
> 	mod->tracepoints = section_objs(hdr, sechdrs, secstrings,
> 					"__tracepoints",
> 					sizeof(*mod->tracepoints),
> 					&mod->num_tracepoints);
> static void *section_objs(...)
> {
> 	unsigned int sec = find_sec(hdr, sechdrs, secstrings, name);
> 
> 	/* Section 0 has sh_addr 0 and sh_size 0. */
> 	*num = sechdrs[sec].sh_size / object_size;
> 	return (void *)sechdrs[sec].sh_addr;
> }
> 
> If the module has not "__tracepoints" section, find_sec() returns 0.
> So I think, sechdrs[0].sh_size is corrupted.
> 
> Is the following fix fixed the oops for you?
> ---
> diff --git a/kernel/module.c b/kernel/module.c
> index 7fa134e..2ee47ff 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1950,6 +1950,7 @@ static noinline struct module *load_module(void __user *umod,
>  	sechdrs = (void *)hdr + hdr->e_shoff;
>  	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
>  	sechdrs[0].sh_addr = 0;
> +	sechdrs[0].sh_size = 0;
>  
>  	for (i = 1; i < hdr->e_shnum; i++) {
>  		if (sechdrs[i].sh_type != SHT_NOBITS

Jaswinder, could you please try the fix from Lai, but first do:

 git revert ec625cb  # tracepoints: dont update zero-sized tracepoint sections
 git revert 09933a1  # tracing: fix oops in tracepoint_update_probe_range()

?

	Ingo
