Return-Path: <linux-kernel-owner+w=401wt.eu-S937779AbXHGVoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937779AbXHGVoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937158AbXHGVTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:19:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937151AbXHGVTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:19:37 -0400
Message-ID: <46B8E1D3.8050501@redhat.com>
Date: Tue, 07 Aug 2007 17:19:15 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Jerry Jiang <wjiang@resilience.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain> <20070806123551.a6c3c154.wjiang@resilience.com> <46B72C58.5030502@redhat.com> <46B894E4.4010501@nortel.com> <46B8D6D7.2020206@redhat.com> <46B8DDF3.7050008@nortel.com>
In-Reply-To: <46B8DDF3.7050008@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Chris Snook wrote:
> 
>> But if you're not using SMP, the only way you get a race condition is 
>> if your compiler is reordering instructions that have side effects 
>> which are invisible to the compiler.  This can happen with MMIO 
>> registers, but it's not an issue with an atomic_t we're declaring in 
>> real memory.
> 
> I refer back to the interrupt handler case.  Suppose we have:
> 
> while(!atomic_read(flag))
>      continue;
> 
> where flag is an atomic_t that is set in an interrupt handler, the 
> volatile may be necessary on some architectures to force the compiler to 
> re-read "flag" each time through the loop.
> 
> Without the "volatile", the compiler could be perfectly within its 
> rights to evaluate "flag" once and create an infinite loop.
> 
> Now I'm not trying to say that we should explictly use "volatile" in 
> common code, but that it is possible that it is required within the 
> arch-specific atomic_t accessors even on uniprocessor systems.
> 
> Chris

That's why we define atomic_read like so:

#define atomic_read(v)          ((v)->counter)

This avoids the aliasing problem, because the compiler must de-reference the 
pointer every time, which requires a memory fetch.  This is usually fast thanks 
to caching, and hardware cache invalidation enforces correctness when it does 
change.

