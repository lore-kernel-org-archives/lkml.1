Return-Path: <linux-kernel-owner+w=401wt.eu-S1761727AbZDQQOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761727AbZDQQOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758368AbZDQQO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:14:29 -0400
Received: from gw.goop.org ([64.81.55.164]:43620 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760918AbZDQQO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:14:28 -0400
Message-ID: <49E8AAE3.9060005@goop.org>
Date: Fri, 17 Apr 2009 09:14:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca> <49E7D701.9090407@goop.org> <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com> <20090417014209.GA24956@Krystal> <49E81A63.7010700@goop.org> <20090417151646.GB13842@Krystal> <49E89FC1.70006@goop.org> <20090417154228.GB15046@Krystal>
In-Reply-To: <20090417154228.GB15046@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>   
>> Mathieu Desnoyers wrote:
>>     
>>> Given the simplicity of the preempt_disable/enable_notrace found in
>>> preempt.h, we could move them to 
>>>
>>> include/preempt_types.h too, and that would solve all problems, wouldn't
>>> it ?
>>>   
>>>       
>> No, it still needs linux/thread_info.h -> asm/thread_info.h, which in  
>> turn gets quite a lot of things on x86 (and would need to be audited in  
>> each architecture).
>>
>>    J
>>     
>
> Well, I think it's a good time to do some cleanup then. Why on earth
> would thread_info.h be anything else than a "_types"-like header ?
>   

Why indeed?  Because it includes a number of other headers to get the 
definitions it needs, and defines various functions needed to operate on 
the thread_info structure (including the all-important 
current_thread_info()).

Yes, it can be refactored into thread_info.h and thread_info_types.h, 
and all the headers it includes can be similarly refactored, and 
linux/thread_info.h can also be split, and all the asm/*/thread_info.hs 
can be split too, and it can be made to work for all arches under all 
configs... 

But that's going to take a long time, and if its a pre-requisite for 
getting tracing going, then we're not going to see it merged this year.

> If headers has become in such a state in the kernel, then IMHO the
> solution is not to shove more out-of-line functions under the carpet,
> but rather to do the cleanup.
>   

Besides, I'm still not convinced that putting the code inline is a good 
idea.  Direct call/return are not inherently expensive, and they're 
something that CPU vendors have a lot of motivation to optimise for.  In 
particular, the call itself is no more expensive than a jmp other than 
the return-address push, and the ret is also cheap because it will use 
the return address cache rather than having to be a full indirect jmp.

And it would be much easier to justify leaving tracing compile-time 
enabled all the time if each tracepoint really does have a minimal 
icache profile when not enabled.

    J
