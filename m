Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbXBIXhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbXBIXhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbXBIXhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:37:17 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54546 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbXBIXhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:37:16 -0500
Date: Fri, 9 Feb 2007 15:35:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <Pine.LNX.4.64.0702091458180.2786@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702091519330.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702091458180.2786@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Feb 2007, Davide Libenzi wrote:
> 
> That's another way to do it. But you end up creating/destroying a new 
> thread for every request. May be performing just fine.

Well, I actually wanted to add a special CLONE_ASYNC flag, because I
think we could do it better if we know it's a particularly limited special 
case. But that's really just a "small implementation detail", and I don't 
know how big a deal it is. I didn't want to obscure the basic idea with 
anything bigger.

I agree that the create/destroy is a big overhead, but at least it's now 
only done when we actually end up doing some IO (and _after_ we've started 
the IO, of course - that's when we block), so compared to doing it up 
front, I'm hoping that it's not actually that horrid.

The "fork-like" approach also means that it's very flexible. It's not 
really even limited to doing simple system calls any more: you *could*, 
for example, decide that since you already have the thread, and now that 
it's asynchronous, you'd actually return to user space (to let user space 
"complete" whatever asynchronous action it wanted to complete).

> Another, even simpler way IMO, is to just have a plain per-task kthread 
> pool, and a queue.

Yes, that is actually quite doable with basically the same interface. It's 
literally a "small decision" inside of "schedule_async()" on how it 
actually would want to handle the case of "hey, we now have concurrent 
work to be done".

But I actually don't think a per-task kthread pool is necessarily a good 
idea. If a thread pool works for this, then it should have worked for 
regular thread create/destroy loads too - ie there really is little reason 
to special-case the "async system call" case.

NOTE! I'm also not at all sure that we actually want to waste real threads 
on this. My patch is in no way meant to be an "exclusive alternative" to 
fibrils. Quite the reverse, actually: I _like_ those synchronous fibrils, 
but I didn't like how Zach did the overhead of creating them up-front, 
because I really would like the cached case to be totally *synchronous*.

So I wrote my patch with a "schedule_async()" implementation that just 
creates a full-sized thread, but I actually wanted very much to try to 
make it use fibrils that are allocated on-demand too. I was just too lazy.

So the patch is really meant as a "ok, this is how easy it is to make the 
thread allocation be 'on-demand' instead of 'up-front'". The actual 
_policy_ on how thread allocation is done isn't even interesting to me, to 
some degree. I think Zack's fibrils would work fine, a thread pool would 
work fine, and just the silly outright "new thread for everything" that 
the example patch actually used may also possibly work well enough.

It's one reason I liked my patch. It was not only small and simple, it 
really is very flexible, I think. It's also totally independent on how 
you actually end up _executing_ the async requests.

(In fact, you could easily make it a config option whether you support any 
asynchronous behaviour AT ALL. The "async()" system call might still be 
there, but it would just return "0" all the time, and do the actual work 
synchronously).

			Linus
