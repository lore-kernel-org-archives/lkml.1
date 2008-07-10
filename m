Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYGJUTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYGJUTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 16:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYGJUTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 16:19:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54452 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbYGJUTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 16:19:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Date: Thu, 10 Jul 2008 22:20:45 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
References: <20080710115954.GA3639@damson.getinternet.no> <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com> <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
In-Reply-To: <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807102220.47068.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 10 of July 2008, Vegard Nossum wrote:
> Okay, some more info on this one...
> 
> On Thu, Jul 10, 2008 at 4:16 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > BUG: unable to handle kernel paging request at da87d000
> > IP: [<c01991c7>] kmem_cache_alloc+0xc7/0xe0
> > *pde = 28180163 *pte = 1a87d160
> > Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > Pid: 3850, comm: grep Not tainted (2.6.26-rc9-00059-gb190333 #5)
> > EIP: 0060:[<c01991c7>] EFLAGS: 00210203 CPU: 0
> > EIP is at kmem_cache_alloc+0xc7/0xe0
> > EAX: 00000000 EBX: da87c100 ECX: 1adad71a EDX: 6b6b6b6b
> > ESI: 00200282 EDI: da87d000 EBP: f60bfe74 ESP: f60bfe54
> >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> 
> The register %ecx looks innocent but is very important here. The disassembly:
> 
> mov    %edx,%ecx
> shr    $0x2,%ecx
> rep stos %eax,%es:(%edi) <-- the fault
> 
> So %ecx has been loaded from %edx... which is 0x6b6b6b6b/POISON_FREE.
> (0x6b6b6b6b >> 2 == 0x1adadada.)
> 
> %ecx is the counter for the memset, from here:
> 
>         memset(object, 0, c->objsize);
> 
> i.e. %ecx was loaded from c->objsize, so "c" must have been freed.
> Where did "c" come from? Uh-oh...
> 
>         c = get_cpu_slab(s, smp_processor_id());
> 
> This looks like it has very much to do with CPU hotplug/unplug. Is
> there a race between SLUB/hotplug since the CPU slab is used after it
> has been freed?

I wonder if this is related to the fix at:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=70ff05554f91a1edda1f11684da1dbde09e2feea

Rafael
