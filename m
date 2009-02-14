Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbZBNB5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbZBNB5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZBNB5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:57:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44224 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZBNB5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:57:05 -0500
Message-ID: <49962413.9020101@zytor.com>
Date: Fri, 13 Feb 2009 17:53:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org> <49939964.4070607@kernel.org> <49939B08.1050801@kernel.org> <200902140728.55954.rusty@rustcorp.com.au> <4996141A.1050506@kernel.org>
In-Reply-To: <4996141A.1050506@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> 
> Percpu areas are allocated in chunks in vmalloc area.  Each chunk is
> consisted of num_possible_cpus() units and the first chunk is used for
> static percpu variables in the kernel image (special boot time
> alloc/init handling necessary as these areas need to be brought up
> before allocation services are running).  Unit grows as necessary and
> all units grow or shrink in unison.  When a chunk is filled up,
> another chunk is allocated.  ie. in vmalloc area
> 
>   c0                           c1                         c2           
>    -------------------          -------------------        ------------
>   | u0 | u1 | u2 | u3 |        | u0 | u1 | u2 | u3 |      | u0 | u1 | u
>    -------------------  ......  -------------------  ....  ------------
> 
> Allocation is done in offset-size areas of single unit space.  Ie,
> when UNIT_SIZE is 128k, an area at 134k of 512bytes occupy 512bytes at
> 6k of c1:u0, c1:u1, c1:u2 and c1u3.  Percpu access can be done by
> configuring percpu base registers UNIT_SIZE apart.
> 

Okay, let's think about this a bit.

At least for x86, there are two cases:

- 32 bits.  The vmalloc area is *extremely* constrained, and has the 
same class of fragmentation issues as main memory.  In fact, it might 
have *more* just by virtue of being larger.

- 64 bits.  At this point, we have with current memory sizes(*) an 
astronomically large virtual space.  Here we have no real problem 
allocating linearly in virtual space, either by giving each CPU some 
very large hunk of virtual address space (which means each percpu area 
is contiguous in virtual space) or by doing large contiguous allocations 
out of another range.

It doesn't seem to make sense to me at first glance to be any advantage 
to interlacing the CPUs.  Quite on the contrary, it seems to utterly 
preclude ever doing PMDs with a win, since (a) you'd be allocating real 
memory for CPUs which aren't actually there and (b) you'd have the wrong 
NUMA associativity.

	-hpa


(*) In about 20 years we better get the remaining virtual address bits...
