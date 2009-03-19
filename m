Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbZCSN2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbZCSN2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZCSN2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:28:11 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:63519 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754261AbZCSN2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:28:10 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EACHgwUlMQW1W/2dsb2JhbACBT9EWg3wG
Date: Thu, 19 Mar 2009 09:22:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: oops in tracepoint_update_probe_range()
Message-ID: <20090319132248.GA20200@Krystal>
References: <1237393396.3322.6.camel@localhost.localdomain> <20090318163531.GE21331@elte.hu> <49C1F1DF.2020105@cn.fujitsu.com> <20090319074616.GA17144@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090319074616.GA17144@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:16:40 up 19 days,  9:42,  2 users,  load average: 0.55, 0.54,
	0.47
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > Ingo Molnar wrote:
> > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > 
> > >> Good: f4c3c4cdb1de232
> > >> Bad : 1e08816af0bc345
> > >>
> > >> Config:
> > >> http://userweb.kernel.org/~jaswinder/oops_20090318/config-hpdv5-tip-bad-20090318
> > >>
> > >> oops:
> > >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page1.jpg
> > >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page2.jpg
> > >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page3.jpg
> > >> http://userweb.kernel.org/~jaswinder/oops_20090318/oops_page4.jpg
> > >>
> > >> <freeze>
> > > 
> > > Steve, Frederic - the crashes above are in:
> > > 
> > > 	tracepoint_update_probe_range()
> > > 
> > > in a modular kernel apparently.
> > > 
> > >
> > 

Jaswinder : maybe you have old modules in your /lib/modules/`uname -r`
directory which have the correct version, but the wrong module.h header ?

It does not matter if the core kernel __tracepoint section is there or
not, what really matters here is if the problematic module has a correct
module header.

Also, I wonder which module is being loaded when your crash occurs. Does
this specific module contain tracepoints or not ? Maybe we could add a
little printk() to show the current module being loaded before the crash ?

As Lai said, the loop should be skipped because begin and end will both
be the same value when there are no tracepoints in a given module. So
adding extra length check will not help anything here.

The "return if NULL" test probably works just because the specific
module header mismatch we have here happen to put this field to NULL for
some reason.

Mathieu

> > I look up the jpg files, this oops is occurred when a new module is
> > being loaded.
> > 
> > tracepoint_module_notify() is added by Mathieu Desnoyers on the
> > suggestion of me.
> > 
> > tracepoint_update_probe_range() and tracepoint_module_notify()
> > can not trigger this oops if the arguments are correct.
> > 
> > If @begin is NULL, @end is NULL too, it's ensued by kernel/module.c.
> > 
> > load_module(...):
> > 	mod->tracepoints = section_objs(hdr, sechdrs, secstrings,
> > 					"__tracepoints",
> > 					sizeof(*mod->tracepoints),
> > 					&mod->num_tracepoints);
> > static void *section_objs(...)
> > {
> > 	unsigned int sec = find_sec(hdr, sechdrs, secstrings, name);
> > 
> > 	/* Section 0 has sh_addr 0 and sh_size 0. */
> > 	*num = sechdrs[sec].sh_size / object_size;
> > 	return (void *)sechdrs[sec].sh_addr;
> > }
> > 
> > If the module has not "__tracepoints" section, find_sec() returns 0.
> > So I think, sechdrs[0].sh_size is corrupted.
> > 
> > Is the following fix fixed the oops for you?
> > ---
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 7fa134e..2ee47ff 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -1950,6 +1950,7 @@ static noinline struct module *load_module(void __user *umod,
> >  	sechdrs = (void *)hdr + hdr->e_shoff;
> >  	secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
> >  	sechdrs[0].sh_addr = 0;
> > +	sechdrs[0].sh_size = 0;
> >  
> >  	for (i = 1; i < hdr->e_shnum; i++) {
> >  		if (sechdrs[i].sh_type != SHT_NOBITS
> 
> Jaswinder, could you please try the fix from Lai, but first do:
> 
>  git revert ec625cb  # tracepoints: dont update zero-sized tracepoint sections
>  git revert 09933a1  # tracing: fix oops in tracepoint_update_probe_range()
> 
> ?
> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
