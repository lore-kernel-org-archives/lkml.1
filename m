Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbYHZTtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbYHZTtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbYHZTtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:49:02 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47774 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751931AbYHZTtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:49:00 -0400
Message-ID: <48B45E2A.6090102@sgi.com>
Date: Tue, 26 Aug 2008 12:48:58 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <cl@linux-foundation.org>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Jack Steiner <steiner@sgi.com>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -	bisected
References: <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com> <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org> <48B32458.5020104@hp.com> <48B32D39.5040709@linux-foundation.org> <20080826075937.GB7596@elte.hu>
In-Reply-To: <20080826075937.GB7596@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Christoph Lameter <cl@linux-foundation.org> wrote:
> 
>> Alan D. Brunelle wrote:
>>
>>> I think you're right: the kernel as a whole may not be ready for 4,096
>>> CPUs apparently...
>> Mike has been working diligently on getting all these cpumasks off the 
>> stack for the last months and has created an infrastructure to do 
>> this. So I think we are close. It might just be a matter of merging 
>> some more patches that are still left in Ingo's tree.
> 
> hm, there are no such patches left that i know of - the only bits in 
> -tip are the zero-based percpu, which was found to be a bit fragile in 
> testing:

Yes, it's just a case of new changes abusing the stack.
> 
>  earth4:~/tip> git-log-line --author=Travis linus..
>  d379497: Zero based percpu: infrastructure to rebase the per cpu area to zero
>  b3a0cb4: x86: extend percpu ops to 64 bit
> 
> [and it has no relevance to stack footprint.]
> 
> So i dont think the current cpumask_t approach will work. We simply 
> should not get into an endless fight against the windmills that 
> introduce on-stack cpumask_t again and again. We should just take the 
> plunge once and do a clean alloc/free cpumask model. Most of the hotpath 
> cpumasks are constant or pre-constructed, so they are not a real issue.

It would have been nice to know this 9 months ago... ;-)
> 
> Plus, on the general question of stack footprint problems and the 
> difficulty of debugging them, the worst-case stack footprint tracer i 
> wrote for -rt some time ago should be dusted off as well and put into 
> ftrace. David has something quite close to that for Sparc64 already.
> 
> 	Ingo

I'll start experimenting with globally changing cpumask_t to be a pointer,
and see what falls out.

Thanks,
Mike

