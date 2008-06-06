Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbYFFNuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbYFFNuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 09:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbYFFNuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 09:50:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:8009 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYFFNuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:50:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=XnFSqBWiw7s7Qu0DpUrzx9QemYJG9hnLxiBpf9auNlxP+wpybBJrRwa2MTNpLVe4TV
         Rdx4jIkQaFYhfyY/qSfeaxtwxC9t0p6VZhAPqzMDBqSx4rSJrEarUFEe8+Jy2PhL/0ev
         48Qp651TrDJBR0q01rplbgbOthozHdcraM03w=
Message-ID: <19f34abd0806060650q203bef48rd3b20c0cabec4774@mail.gmail.com>
Date: Fri, 6 Jun 2008 15:50:01 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: linux-next: Tree for June 5
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48493CBD.1000202@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	 <20080605195604.41623687.akpm@linux-foundation.org>
	 <20080606071707.GB9708@elte.hu>
	 <20080606002957.6329a0ec.akpm@linux-foundation.org>
	 <20080606024811.70db9ab2.akpm@linux-foundation.org>
	 <20080606035413.37f340ef.akpm@linux-foundation.org>
	 <20080606115759.GA29321@elte.hu>
	 <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com>
	 <48493CBD.1000202@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 3:33 PM, Mike Travis <travis@sgi.com> wrote:
> Vegard Nossum wrote:
>>
>> I reproced it with gc 4.1.2. I think the error is somewhere in kernel/sched.c.
>>
>> static int __build_sched_domains(const cpumask_t *cpu_map,
>>                                  struct sched_domain_attr *attr)
>> {
>> ...
>>         for (i = 0; i < MAX_NUMNODES; i++) {
>> ...
>>                 sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);
>> ...
>>
>> This code is calling into the allocator with a spurious value of i,
>> which causes SLAB to use an index (of 4 in my case) that is out of
>> bounds for its nodelist array (at least it hasn't been initialized).
>>
>> This bit of code (a bit further down, inside the same loop) is also dubious:
>>
>>                         sg = kmalloc_node(sizeof(struct sched_group),
>>                                           GFP_KERNEL, i);
>>                         if (!sg) {
>>                                 printk(KERN_WARNING
>>                                 "Can not alloc domain group for node %d\n", j);
>>                                 goto error;
>>                         }
>>
>> Where it passes i to kmalloc_node() but reports an allocation for node
>> j. Which one is correct?
>>

Hm, I think I'm wrong and the code is correct. However...

>> Hope this helps, will send an update if I find out more.
>>
>>
>> Vegard
>>
>
> Thanks Vegard for tracking this down.  My thoughts were along the same
> wavelength... ;-)

I applied this patch
@@ -7133,6 +7133,14 @@ static int __build_sched_domains(const
cpumask_t *cpu_map,
                cpus_clear(*covered);

                cpus_and(*nodemask, *nodemask, *cpu_map);
+
+               printk("node %d\n", i);
+               for (j = 0; j < NR_CPUS; ++j)
+                       printk("%c", cpu_isset(j, *nodemask) ? 'X' : '.');
+               printk("\n");
+
+               printk("empty = %d\n", cpus_empty(*nodemask));
+
                if (cpus_empty(*nodemask)) {
                        sched_group_nodes[i] = NULL;
                        continue;

and it shows some really strange output, maybe it makes sense to you:

(the X means cpu is in the node)

Total of 2 processors activated (11976.24 BogoMIPS).
node 0
XX..............................................................................
................................................................................
................................................................................
...............
empty = 0
node 1
XX..............................................................................
................................................................................
................................................................................
...............
empty = 0
l3 = cachep->nodelists[0] (size-64) = ffff81003f824340
node 2
................................................................................
................................................................................
................................................................................
...............
empty = 1
node 3
................................................................................
................................................................................
................................................................................
...............
empty = 1
node 4
X...............................................................................
................................................................................
................................................................................
...............
empty = 0

This is a P4 3.0GHz with 1 physical CPU (but HT, so two logical CPUs).
Yet node 4 is claimed to have a cpu too. That's bogus!

(But I don't think it's an error in sched.c any more, probably the
code that sets up the node maps.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
