Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYJWOcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYJWOcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbYJWOcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:32:14 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:19585 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYJWOcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:32:14 -0400
Message-ID: <49008A9B.8040905@siemens.com>
Date: Thu, 23 Oct 2008 16:30:51 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 08/13 v2] ftrace: do not trace init sections
References: <20081022212721.167005680@goodmis.org> <20081022213552.440512191@goodmis.org> <49005CD0.2070807@siemens.com> <alpine.DEB.1.10.0810230732100.31839@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0810230732100.31839@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 23 Oct 2008, Jan Kiszka wrote:
> 
>> Steven Rostedt wrote:
>>> The recordmcount script is now robust enough not to process any sections
>>> but the .text section. But the gcc compiler still adds a call to mcount.
>>>
>>> Note: The function mcount looks like:
>>>
>>>   ENTRY(mcount)
>>> 	ret
>>>   END(mcount)
>>>
>>> Which means the overhead is just a return.
>>>
>>> This patch adds notrace to the init sections to not even bother calling
>>> mcount (which simply returns).
>> Sorry for a potentially dumb question (didn't follow all recent ftrace
>> developments), but doesn't this mean that code in such sections is now
>> invisible for all tracers, even with dynamic tracing disabled (in which
>> case they should cause no problem)? What if you *do* want to have such
>> functions in your trace as they may contribute to problem or give other
>> useful hints?
> 
> Not a dumb question, I've thought about this too.
> 
> Well, you can still add tracing into those functions, just the mcount call 
> will not be there. I've thought about other ways to handle this. Perhaps 
> add it only when DYNAMIC_FTRACE is configured. But that to me is a new 
> feature. The patches I'm submitting is to help with performance, bug 
> fixes, and sanity checks. So I left out any optional notraces.

Well, but mcount is only broken for .init sections if dynamic tracing is
on, no? Then I would focus the fix on that case as far as possible.

> 
> e.g. in init.h I could do something like.
> 
> #ifdef CONFIG_DYNAMIC_FTRACE
> # define init_notrace notrace
> #else
> # define init_notrace
> #endif
> 
> And then use the init_notrace throughout the file. If this is considered 
> something that is acceptible for adding into 28, I would be happy to 
> supply a patch.

>From my POV - I'm using mcount tracing for a few years now -, the thing
about this is gaining a complete overview of what happens at function
level, which code paths were taken (at that level). Each bit of
information you (have to) drop can harm here, even more if they come in
larger chunks like in this case.

I don't know if this feature is already considered for / part of
mainline, but oops backtraces based on mcount instrumentation used to be
quite helpful for me to understand the wider context of several faults.
The more you have to mask out of this picture, the harder it gets to
match the trace to your model of the kernel activities. At least you
have to know more in advance about the limitation of the tracer...

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux
