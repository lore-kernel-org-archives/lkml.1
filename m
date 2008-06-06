Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYFFMeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYFFMeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 08:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYFFMeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 08:34:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:13364 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbYFFMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:34:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sR2Wzyg1QP8rQ4yQx0MFA/qUH+4I2iN5AJCmEYbmHxhtyNOBk6EncNDGPeGfqdDZVL
         dMVEMSoKD98YQ+jziC0fD4W0P4IxMzheKDOiey/UcifPE7VBUFBxbZeSoBzrBR31hl4b
         UW89CvmMjaaO6k/T+10sN+ax6B/+MvIvQhMYI=
Message-ID: <19f34abd0806060533x6d3ff66tc29306143103fc40@mail.gmail.com>
Date: Fri, 6 Jun 2008 14:33:56 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: linux-next: Tree for June 5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, "Mike Travis" <travis@sgi.com>
In-Reply-To: <20080606115759.GA29321@elte.hu>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2008 at 1:57 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> Good
>>
>>       a9ad585c8a18f7ba754b85f5786976609b9d7d29
>>       Author: Mike Travis <travis@sgi.com>  2008-05-12 12:21:12
>>       Committer: Thomas Gleixner <tglx@linutronix.de>  2008-05-23 09:07:47
>>       Parent: 543e21916497be5a4005fd5820264ce1de9bd56d (x86: restore pda nodenumber field)
>>       Child:  78d49c6d890aee9cf8aea371011c9d7b0121b822 (x86: remove static boot_cpu_pda array v2)
>>       Branch:
>>       Follows: v2.6.26-rc2
>>       Precedes: next-20080526
>>
>>           x86: remove the static 256k node_to_cpumask_map
>>
>> crash, as described earlier.
>
> thanks for tracking it down! This was the origin of the commit:
>
>  # tip/x86/numa: a9ad585: x86: remove the static 256k node_to_cpumask_map
>
> which has been in -tip since May 12 and in linux-next for two weeks
> AFAICS, which is beyond the point of being something freshly wrong.
>
> So i suspect something more subtle here. What compiler version are you
> using? This crash is not something that has been found in testing before
> - i use rather new compilers, gcc 4.2.2 most of the time. Previous
> compilers miscompile the kernel seriously so it's not usable for our
> regression testing grid.
>

Hi,

I reproced it with gc 4.1.2. I think the error is somewhere in kernel/sched.c.

static int __build_sched_domains(const cpumask_t *cpu_map,
                                 struct sched_domain_attr *attr)
{
...
        for (i = 0; i < MAX_NUMNODES; i++) {
...
                sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);
...

This code is calling into the allocator with a spurious value of i,
which causes SLAB to use an index (of 4 in my case) that is out of
bounds for its nodelist array (at least it hasn't been initialized).

This bit of code (a bit further down, inside the same loop) is also dubious:

                        sg = kmalloc_node(sizeof(struct sched_group),
                                          GFP_KERNEL, i);
                        if (!sg) {
                                printk(KERN_WARNING
                                "Can not alloc domain group for node %d\n", j);
                                goto error;
                        }

Where it passes i to kmalloc_node() but reports an allocation for node
j. Which one is correct?

Hope this helps, will send an update if I find out more.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
