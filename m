Return-Path: <linux-kernel-owner+w=401wt.eu-S1761712AbZDQRJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761712AbZDQRJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 13:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbZDQRJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 13:09:49 -0400
Received: from gw.goop.org ([64.81.55.164]:56985 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759245AbZDQRJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 13:09:48 -0400
Message-ID: <49E8B7DA.4050504@goop.org>
Date: Fri, 17 Apr 2009 10:09:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@lst.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 2/3] RCU move trace defines to rcupdate_types.h
References: <20090417003755.276959950@polymtl.ca> <20090417003931.846405986@polymtl.ca> <49E7D701.9090407@goop.org> <alpine.DEB.2.00.0904162122250.20429@gandalf.stny.rr.com> <20090417014209.GA24956@Krystal> <49E81A63.7010700@goop.org> <20090417151646.GB13842@Krystal> <49E89FC1.70006@goop.org> <20090417154228.GB15046@Krystal> <49E8AAE3.9060005@goop.org> <alpine.DEB.2.00.0904171234400.14919@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0904171234400.14919@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> I was talking with Arjan about this in San Francisco. The expense of doing 
> function calls. He told me (and he can correct me if I'm wrong here) that 
> function calls are like branch predictions. The branch part is the fact 
> that a retq is a jmp that can go to different locations. There's logic in 
> the CPU to match calls with retqs to speed this up.
>   

Right.  The call is to a fixed address, so there's no prediction needed 
at all; the CPU can immediately start fetching instructions at the call 
target without missing a beat.  When it hits the ret in the function, 
assuming nobody has been playing games with the stack pointer or 
modifying the return address on the stack, it can just look up the 
return address from its cache and start fetching from there, again with 
no bubbles.  It should be very close to a pair of jumps, aside from one 
extra memory write (for the return address on stack) - and that 
shouldn't be too bad, because the chances are the cache is hot for the 
stack.

> He also told me that the "mcount" retq that I do is actually more 
> expensive. The logic does not expect a function to return immediately. 
> (for stubs, I'm not sure that was a good design).
>
> Hence,
>
> 	call mcount
>
> [...]
>
> mcount:
> 	retq
>
>
> is expensive, compared to a call to a function that actually does 
> something.
>
> Again, Arjan can correct me here, since I'm just trying to paraphrase what 
> he told me.
>   

Sounds reasonable; it takes a little while for the CPU to work out what 
the return address will be, even though its cached, so doing an 
immediate ret will cause a bubble while it sorts itself out.  But that 
shouldn't be an issue for the calls I'm talking about.

    J
