Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbZEYSnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbZEYSnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 14:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZEYSnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 14:43:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53440 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZEYSnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 14:43:32 -0400
Message-ID: <4A1AE5CC.1000209@cs.helsinki.fi>
Date: Mon, 25 May 2009 21:39:08 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jgarzik@pobox.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, cl@linux-foundation.org,
       mpm@selenic.com
Subject: Re: [GIT PULL] scheduler fixes
References: <20090518202031.GA26549@elte.hu> <alpine.LFD.2.01.0905181457320.3301@localhost.localdomain> <Pine.LNX.4.64.0905241911120.12189@melkki.cs.Helsinki.FI> <4A199327.5030503@kernel.org> <20090525025353.GA2580@elte.hu> <4A1A2261.1000504@kernel.org> <20090525051521.GC23032@elte.hu> <Pine.LNX.4.64.0905251142140.32568@melkki.cs.Helsinki.FI> <20090525112504.GB24071@wotan.suse.de> <84144f020905250437x585e66a2oc1124a4f1f43059d@mail.gmail.com> <20090525114127.GE24071@wotan.suse.de> <Pine.LNX.4.64.0905251443390.4115@melkki.cs.Helsinki.FI> <alpine.LFD.2.01.0905250930530.3435@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905250930530.3435@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Linus Torvalds wrote:
> On Mon, 25 May 2009, Pekka J Enberg wrote:
>> diff --git a/init/main.c b/init/main.c
>> index 33ce929..fb0e004 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -576,6 +576,22 @@ asmlinkage void __init start_kernel(void)
>>  	setup_nr_cpu_ids();
>>  	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
>>  
>> +	build_all_zonelists();
>> +	page_alloc_init();
>> +
>> +	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
>> +	parse_early_param();
>> +	parse_args("Booting kernel", static_command_line, __start___param,
>> +		   __stop___param - __start___param,
>> +		   &unknown_bootoption);
>> +	pidhash_init();
>> +	vmalloc_init();
>> +	vfs_caches_init_early();
>> +	/*
>> +	 * Set up kernel memory allocators
>> +	 */
>> +	mem_init();
>> +	kmem_cache_init();
> 
> So what strikes me is a question:
> 
>  - why do we want to do pidhash_init and vfs_caches_init_early() so early?
> 
> Yes, pidhash_init() now uses alloc_bootmem. It's an allocation that is not 
> trivially small, but it's not humongous either (max 4096 hash list heads, 
> one pointer each).

I can certainly fix that up to use kmalloc() or vmalloc(). I moved it 
because I wasn't sure how much it's actually allocating and wanted to do 
the conservative thing here.

Linus Torvalds wrote:
> And vfs_caches_init_early() is actually doing some rather strange things, 
> like doing a "alloc_large_system_hash()" but not unconditionally: it does 
> it in the "late" initialization too, if not done early. inode_init_early 
> does soemthing very similar (ie a _conditional_ early init).
> 
> So none of this seems to really get a huge advantage from the early init. 
> There seems to be some subtle NUMA issues, but do we really want that? I 
> get the feeling that nobody ever wanted to do it early, and then the NUMA 
> people said "I don't wnt to do this early, but I don't want to touch the 
> non-NUMA case, so I'll do it early for non-numa, and late for numa".

SLUB does sysfs setup in kmem_cache_init() and if I saw some oopses if I 
don't call vfs_caches_init_early() first. I didn't look too closely, though.

Linus Torvalds wrote:
> I'm also not entirely sure we really need to do vmalloc_init() that early, 
> but I dunno. It also uses alloc_bootmem().

We can do that later but then we need to fix up vmalloc_init(). There's 
actually a patch floating around to do that.

			Pekka
