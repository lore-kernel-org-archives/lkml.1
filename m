Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbZCSJmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbZCSJmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 05:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbZCSJmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 05:42:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:51268 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZCSJmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:42:01 -0400
Subject: Re: oops in tracepoint_update_probe_range()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
In-Reply-To: <20090319074616.GA17144@elte.hu>
References: <1237393396.3322.6.camel@localhost.localdomain>
	 <20090318163531.GE21331@elte.hu> <49C1F1DF.2020105@cn.fujitsu.com>
	 <20090319074616.GA17144@elte.hu>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 15:11:03 +0530
Message-Id: <1237455663.3127.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 08:46 +0100, Ingo Molnar wrote:
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

After reverting above two commits and applying Lai's patch still gives
me oops:
[    5.027136] hub 6-0:1.0: state 7 ports 3 chg 0000 evt 0000
[    5.444563] BUG: unable to handle kernel NULL pointer dereference at (null)
[    5.444906] IP: [<ffffffff8107d50a>] tracepoint_update_probe_range+0x1f/0x9b
[    5.445155] PGD 13d5a8067 PUD 13d5ea067 PMD 0 
[    5.445376] Oops: 0000 [#1] SMP 
[    5.445437] last sysfs file: /sys/class/firmware/timeout
[    5.445437] CPU 0 
[    5.445437] Modules linked in: scsi_wait_scan(+)
[    5.445437] Pid: 877, comm: modprobe Not tainted 2.6.29-rc8-tip #383 HP Pavilion dv5 Notebook PC
[    5.445437] RIP: 0010:[<ffffffff8107d50a>]  [<ffffffff8107d50a>] tracepoint_update_probe_range+0x1f/0x9b
[    5.445437] RSP: 0018:ffff88013d5ede78  EFLAGS: 00010287
[    5.445437] RAX: ffff88013d5ec000 RBX: 0000000000000000 RCX: ffffffff81650940
[    5.445437] RDX: ffffffffa0000300 RSI: 0000001400000000 RDI: ffffffff81650960
[    5.445437] RBP: ffff88013d5ede98 R08: ffffc200006799c8 R09: ffff88013d5eddb8
[    5.445437] R10: dead000000200200 R11: 6db6db6db6db6db7 R12: 00000000fffffffc
[    5.445437] R13: 0000000000000000 R14: 0000001400000000 R15: 0000000000000001
[    5.445437] FS:  00007f9d94e4f6f0(0000) GS:ffff880028022000(0000) knlGS:0000000000000000
[    5.445437] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    5.445437] CR2: 0000000000000000 CR3: 000000013d5cf000 CR4: 00000000000006a0
[    5.445437] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.445437] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    5.445437] Process modprobe (pid: 877, threadinfo ffff88013d5ec000, task ffff88013e3d2710)
[    5.445437] Stack:
[    5.445437]  0000000000000000 00000000fffffffc 0000000000000000 ffffffffa0000300
[    5.445437]  ffff88013d5edea8 ffffffff8107d5b0 ffff88013d5edee8 ffffffff8143e834
[    5.445437]  ffffffff8164e4d0 ffffffff8164e4d0 0000000000000000 0000000000000000
[    5.445437] Call Trace:
[    5.445437]  [<ffffffff8107d5b0>] tracepoint_module_notify+0x2a/0x2e
[    5.445437]  [<ffffffff8143e834>] notifier_call_chain+0x33/0x5b
[    5.445437]  [<ffffffff8105377c>] __blocking_notifier_call_chain+0x4d/0x6a
[    5.445437]  [<ffffffff810537a8>] blocking_notifier_call_chain+0xf/0x11
[    5.445437]  [<ffffffff81061c90>] sys_init_module+0x94/0x1c8
[    5.445437]  [<ffffffff8100bb2b>] system_call_fastpath+0x16/0x1b
[    5.445437] Code: e8 05 df 3b 00 31 c0 5b 41 5c c9 c3 55 48 89 e5 41 56 49 89 f6 41 55 41 54 53 48 89 fb 48 c7 c7 60 09 65 81 e8 95 e1 3b 00 eb 62 <48> 8b 3b e8 9d fa ff ff 48 85 c0 49 89 c4 74 3f 48 8b 33 48 8d 
[    5.445437] RIP  [<ffffffff8107d50a>] tracepoint_update_probe_range+0x1f/0x9b
[    5.445437]  RSP <ffff88013d5ede78>
[    5.445437] CR2: 0000000000000000
[    5.450260] ---[ end trace 20c410fa785114f0 ]---

Thanks,
--
JSR

