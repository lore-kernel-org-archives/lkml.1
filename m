Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbYGJTtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbYGJTtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYGJTtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:49:10 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:62499 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbYGJTtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:49:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lErKTc5uwEsCGBrDo2WFGm5w8wUs/rkVzg20ZxR4DAU812j8wfT9Mff5sEt0N5ywi4
         Sm2f8U6BDff/7Ue5O6ibmt/qEmIQwvE2YwGSupUU0mqCzq7fKCOoko736Bj2QXTTejMh
         gxUwVZ9jJBgYTmqjGP7nWGzkZ4pWLjH2wxJno=
Message-ID: <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
Date: Thu, 10 Jul 2008 21:49:03 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100512y7fff3716r3ff37305e863f26@mail.gmail.com>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
	 <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, some more info on this one...

On Thu, Jul 10, 2008 at 4:16 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> BUG: unable to handle kernel paging request at da87d000
> IP: [<c01991c7>] kmem_cache_alloc+0xc7/0xe0
> *pde = 28180163 *pte = 1a87d160
> Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> Pid: 3850, comm: grep Not tainted (2.6.26-rc9-00059-gb190333 #5)
> EIP: 0060:[<c01991c7>] EFLAGS: 00210203 CPU: 0
> EIP is at kmem_cache_alloc+0xc7/0xe0
> EAX: 00000000 EBX: da87c100 ECX: 1adad71a EDX: 6b6b6b6b
> ESI: 00200282 EDI: da87d000 EBP: f60bfe74 ESP: f60bfe54
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068

The register %ecx looks innocent but is very important here. The disassembly:

mov    %edx,%ecx
shr    $0x2,%ecx
rep stos %eax,%es:(%edi) <-- the fault

So %ecx has been loaded from %edx... which is 0x6b6b6b6b/POISON_FREE.
(0x6b6b6b6b >> 2 == 0x1adadada.)

%ecx is the counter for the memset, from here:

        memset(object, 0, c->objsize);

i.e. %ecx was loaded from c->objsize, so "c" must have been freed.
Where did "c" come from? Uh-oh...

        c = get_cpu_slab(s, smp_processor_id());

This looks like it has very much to do with CPU hotplug/unplug. Is
there a race between SLUB/hotplug since the CPU slab is used after it
has been freed?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
