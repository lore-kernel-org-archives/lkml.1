Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZELIzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZELIzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 04:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbZELIz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 04:55:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50641 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbZELIzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 04:55:25 -0400
Date: Tue, 12 May 2009 10:54:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
Message-ID: <20090512085402.GA18004@elte.hu>
References: <20090508184838.GA11157@havoc.gtf.org> <20090508185015.GA11320@havoc.gtf.org> <20090508190944.GB12130@elte.hu> <200905101819.41765.rusty@rustcorp.com.au> <20090511105816.GG4648@elte.hu> <4A088DF4.7080305@garzik.org> <20090511204933.GA7737@elte.hu> <4A08DDE2.1080708@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A08DDE2.1080708@garzik.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> Ingo Molnar wrote:
>>>>>> That cpumask[] should probably be cpumask[0], to document the
>>>>>> aliasing to ->span and ->cpus properly.
>>>>> If the comment wasn't sufficient documentation, I don't think 
>>>>> that  would help :(
>>>> It's a visual helper: it matches up with how we do these 'zero size 
>>>>  array means dynamic structure continuation' tricks generally.
>>>>
>>>> I first mis-parsed the code for a second when seeing cpumask[].   
>>>> cpumask[0] stands out like a sore thumb. And we dont read comments  
>>>> anyway ;-)
>>>>
>>>> Jeff, i suspect you found this because you are working on something 
>>>>  rather interesting? :) If yes, would it help your project if we 
>>>> did  the cpumask[0] cleanup and pushed it upstream immediately?
>>> I think cpumask[0] would be more clear and consistent with the rest 
>>> of the kernel.
>>>
>>> But unfortunately for the twin projects of (a) static analysis and  
>>> checking with 'sparse', and (b) compiling under another compiler,  
>>> VLA-in-middle-of-struct is a killer in either case.
>>
>> even if at the end of the struct?
>
> Putting the VLA at the end of the struct would be a huge help, 
> yes.
>
> For example, struct sched_group and struct sched_domain are OK 
> as-is (though "[0]" would be preferred).
>
> It is the definition of struct static_sched_group and struct 
> static_sched_domain that creates the problem, because with the 
> bitmap following cpumask[] and span[], the VLA is no longer at the 
> end of the struct.
>
> VLA-in-the-middle raises the complexity required of the compiler 
> quite a bit.  As a result, VLA-in-middle is not implemented in 
> sparse or clang (LLVM's C front-end and static analyzer).

feel free to send patches for this - i dont have those build modes 
to test that it's sufficient. I'd suggest to go the simplest path: 
remove all the vla aliasing tricks: just make struct sched_domain 
use a plain struct cpumask and eliminate static_sched_domain 
altogether.

The memory overhead is marginal as most of our sched domains are 
static allocated (and full size) anyway.

	Ingo
