Return-Path: <linux-kernel-owner+w=401wt.eu-S934748AbZJJSiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934748AbZJJSiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 14:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934617AbZJJSip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 14:38:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934541AbZJJSio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 14:38:44 -0400
Date: Sat, 10 Oct 2009 11:37:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Valdis.Kletnieks@vt.edu
cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Byron Stanoszek <bstanoszek@comtime.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.32-rc3: low mem - only 378MB on x86_32 with 64GB. Why?
In-Reply-To: <32059.1255198236@turing-police.cc.vt.edu>
Message-ID: <alpine.LFD.2.01.0910101121190.3438@localhost.localdomain>
References: <Pine.LNX.4.64.0910052334480.17655@boston.corp.fedex.com> <alpine.LFD.2.01.0910051110200.3432@localhost.localdomain> <b6a2187b0910051715y4ee63503y148ba2d7e24cad8e@mail.gmail.com> <alpine.LFD.2.01.0910051727420.3432@localhost.localdomain>
 <b6a2187b0910052312o662642b2teded3d19548b9151@mail.gmail.com> <alpine.LFD.2.01.0910060731190.3432@localhost.localdomain>            <b6a2187b0910090928r648169dax86178a3e8b8c2f21@mail.gmail.com> <32059.1255198236@turing-police.cc.vt.edu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Oct 2009, Valdis.Kletnieks@vt.edu wrote:
>
> When the x86 went 64-bit, the register pressure relief from the 
> additional registers usually more then outweighs the additional memory 
> bandwidth (basically, if you're spending twice as much time on each 
> load/store, but only doing it 40% as often, you come out ahead...)

That's mainly stack traffic, and x86 has always been good at it. More 
registers makes for simpler (and fewer) instructions due to less reloads, 
but for kernel loads, it's not the biggest advantage.

If you have 8GB of RAM or more, the biggest advantage _by_far_ for the 
kernel is that you don't spend 25% of your system time playing with 
k[un]map() and the TLB flushing that goes along with it. You also have 
much more freedom to allocate (and thus cache) inodes, dentries and 
various other fundamental kernel data structures.

Also, the reason MIPS and Sparc had a slowdown for 64-bit code was only 
partially the bigger cache footprint (and that depends a lot on the app 
anyway: many applications aren't that pointer-intensive. The kernel is 
_very_ pointer-intensive, but even for something like that, most data 
structures tend to blow up by 50%, not 100%).

The other reason for slowdown is that generating those pointers (for 
function calls in particular) is more complex, and x86-64 is better at 
that than MIPS and Sparc. That complex instruction encoding with 
variable-size instructions means that you don't have to try to fit all 
constants in the instruction stream either in the fixed-sized instruction, 
or by doing indirect data access to memory through a GP register. 

So x86-64 not only had the register expansion advantage, it had less of a 
code generation downside to 64-bit mode to begin with. Want to have large 
constants in the code? No problem. Sure, it makes your code bigger, but 
you can still have them predecoded in the instruction stream rather than 
have to load them from memory. Much nicer for everybody.

And for the kernel, the bigger virtual address space really is a _huge_ 
deal. HIGHMEM accesses really are very slow.  You don't see that in user 
space, but I really have seen 25% performance differences between 
non-highmem builds and CONFIG_HIGHMEM4G enabled for things that try to put 
a lot of data in highmem (and the 64G one is even more expensive). And 
that was just with 2GB of RAM.

And when it makes the difference between doing IO or not doign IO (ie 
caching or not caching - when the dentry cache can't grow any more because 
it _needs_ to be in lowmem), you can literally see an order-of-magnitude 
difference.

With 8GB+ of ram, I guarantee you that the kernel spent tons of time on 
just mappign high pages, _and_ it couldn't grow inodes and dentry caches 
nearly as big as it would have wanted to. Going to x86-64 makes all those 
issues just go away entirely.

So it's not "you can save a few instructions by not spilling to stack as 
much". It's a much bigger deal than that. There's a reason I personally 
refuse to even care about >2GB 32-bit machines. There's just no excuse 
these days to do that.

			Linus
