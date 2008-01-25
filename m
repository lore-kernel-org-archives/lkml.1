Return-Path: <linux-kernel-owner+w=401wt.eu-S1762966AbYAYIlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762966AbYAYIlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759394AbYAYIBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:55 -0500
Received: from mx1.suse.de ([195.135.220.2]:59795 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762032AbYAYIBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:01:53 -0500
From: Andi Kleen <ak@novell.com>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [x86.git] new CPA implementation
Date: Fri, 25 Jan 2008 09:01:48 +0100
User-Agent: KMail/1.9.6
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080125002401.GA31745@elte.hu>
In-Reply-To: <20080125002401.GA31745@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801250901.48422.ak@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> One of the big simplifications was to remove largepage reassembly. (We 
> could perhaps still add that back in the future, if someone shows the 
> performance benefits and real-life significance of it. 

Let's call it a deoptimization, but ok. I suspect you'll hear about 
it again at some point in the future in form of performance regressions.

I'm a little surprised you chose this to simply way though. My feeling was always
that the primary way to simply cpa would have been to get rid of the 
separate flushing step (which in hindsight was probably not a useful
optimization and it caused fairly tricky code) 

Also Linus used to have pretty strong opinions in the past about using
direct pages -- good luck getting it past him.

> But the  
> refcounting was nasty and error-prone and was buggy even with your 
> latest CPA patches.)

What was the remaining problem? 

> 
> other features:
> 
> - the new implementation is much more scalable, because it is lockless 
>   in the fastpath 

What fast path?  This should not really be called that often, especially
not when DEBUG_PAGEALLOC has its own simple implementation.

Anyways the most important general optimization imho (which you unfortunately 
dropped) was to get rid of the WBINVDs which unlike everything else
cpa does are _really_ costly.

>   - while previous c_p_a() implementations used a global  
>   spinlock / or the global init_task.mmap_sem semaphore.

It'll be interesting to see how you avoided all the races.

> - new 64-bit CONFIG_DEBUG_PAGEALLOC support has been implemented and 
>   has been tested to work fine.

That was on my todo list, but yes it was pretty easy now. The only
missing bit really came from the PAT patchkit to add infrastructure
to 64bit to set up 4K pages at boot.
 
> - PAGEALLOC does not require PSE to be cleared from the CPU anymore. 
>   (The pagetables will still be broken up into 4K ptes during bootup, 
>    but that happens as part of the regular c_p_a() sequence. (and thus 
>    we get more testing of the largepage-splitup code)

Clearing the bit was always a nasty hack. Good to finally clean it up.

However I hope you don't allocate memory in the kernel_map_pages in
regular operation now to do split on demand. Doing so would be a mistake
imho because there are all kinds of nasty corner cases with potential
recursion etc.

> - the CPA-testsuite now passes without failures on both 32-bit and 
>   64-bit. (it never fully worked with your CPA series.)

Without reassembly implemented CPA_TEST will always imply running a lot of
the direct memory as 4K pages so it can't be safely enabled on production
kernels anymore. You should probably at least add a warning or limit 
the test to only work on a small portion of the direct mapping now.

Anyways I'll look at redoing GBpages support on top of that new implementation
later. Without reassembly it should be nearly trivial now. Hopefully it can then
be still merged for .25 then.

BTW to play with open cards I found now on my own testing a new GBpages problem that
I'm investigating -- kexec seems to have trouble with it. I'll try to come up
with a fix for that, although I admit I currently don't have any clue why
they even interact.

-Andi
