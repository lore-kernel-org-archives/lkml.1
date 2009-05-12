Return-Path: <linux-kernel-owner+w=401wt.eu-S1760026AbZELCY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760026AbZELCY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 22:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZELCYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 22:24:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39163 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbZELCYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 22:24:47 -0400
Message-ID: <4A08DDE2.1080708@garzik.org>
Date: Mon, 11 May 2009 22:24:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>, roland@redhat.com
Subject: Re: [RFC PATCH 2/2] kernel/sched.c: VLA in middle of struct
References: <20090508184838.GA11157@havoc.gtf.org> <20090508185015.GA11320@havoc.gtf.org> <20090508190944.GB12130@elte.hu> <200905101819.41765.rusty@rustcorp.com.au> <20090511105816.GG4648@elte.hu> <4A088DF4.7080305@garzik.org> <20090511204933.GA7737@elte.hu>
In-Reply-To: <20090511204933.GA7737@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>>> That cpumask[] should probably be cpumask[0], to document the
>>>>> aliasing to ->span and ->cpus properly.
>>>> If the comment wasn't sufficient documentation, I don't think that  
>>>> would help :(
>>> It's a visual helper: it matches up with how we do these 'zero size  
>>> array means dynamic structure continuation' tricks generally.
>>>
>>> I first mis-parsed the code for a second when seeing cpumask[].  
>>> cpumask[0] stands out like a sore thumb. And we dont read comments  
>>> anyway ;-)
>>>
>>> Jeff, i suspect you found this because you are working on something  
>>> rather interesting? :) If yes, would it help your project if we did  
>>> the cpumask[0] cleanup and pushed it upstream immediately?
>> I think cpumask[0] would be more clear and consistent with the 
>> rest of the kernel.
>>
>> But unfortunately for the twin projects of (a) static analysis and 
>> checking with 'sparse', and (b) compiling under another compiler, 
>> VLA-in-middle-of-struct is a killer in either case.
> 
> even if at the end of the struct?

Putting the VLA at the end of the struct would be a huge help, yes.

For example, struct sched_group and struct sched_domain are OK as-is 
(though "[0]" would be preferred).

It is the definition of struct static_sched_group and struct 
static_sched_domain that creates the problem, because with the bitmap 
following cpumask[] and span[], the VLA is no longer at the end of the 
struct.

VLA-in-the-middle raises the complexity required of the compiler quite a 
bit.  As a result, VLA-in-middle is not implemented in sparse or clang 
(LLVM's C front-end and static analyzer).

	Jeff



