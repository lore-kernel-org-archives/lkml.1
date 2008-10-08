Return-Path: <linux-kernel-owner+w=401wt.eu-S1755208AbYJHQUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbYJHQUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 12:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbYJHQUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 12:20:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbYJHQUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 12:20:38 -0400
Date: Wed, 8 Oct 2008 09:19:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <srostedt@redhat.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, hugh@veritas.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [RFC][PATCH 7/7] lockdep: spin_lock_nest_lock()
In-Reply-To: <48ECD9C8.4000700@redhat.com>
Message-ID: <alpine.LFD.2.00.0810080906520.3208@nehalem.linux-foundation.org>
References: <20080804130317.994042639@chello.nl> <20080804131012.246115111@chello.nl> <48974512.7000206@goop.org> <1217876046.3589.61.camel@twins> <489757EC.3000309@goop.org> <alpine.LFD.1.10.0808041230070.3340@nehalem.linux-foundation.org>
 <20081008152708.GA11207@goodmis.org> <alpine.LFD.2.00.0810080836410.3208@nehalem.linux-foundation.org> <48ECD9C8.4000700@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 8 Oct 2008, Steven Rostedt wrote:
> 
> Unfortunately, you cut out my comment that I stated "unless there is a good
> reason not to", which the below example is a good reason ;-)

Well, teh thing is, as long as you think nesting is good, you end up being 
very confused when it isn't.

> I just find that seeing something like:
> 
>    lock(A);
>    lock(B);
> 
>    [do something]
> 
>    unlock(A);
>    unlock(B);
> 
> just seems to be sloppy.

Of course you'll often get nesting almost by mistake.

For example, any normal locking that is hierarchical tends to nest 
naturally, especially if you end up using lots of small functions (which 
you should). Or simply due to error handling.

So in that sense, nesting may be a "natural" thing, but partly exactly 
_because_ it is fairly natural, we should not try to make it even more 
than that, because then when things don't nest (and it does happen), if 
the "things should nest" camp gets too strong, bugs happen.

They happen because somebody looks at the non-nesting case, and thinks 
it's sloppy, and tries to fix it. And in the process just complicates 
matters - and very likely introduces bugs.

And THAT is why people shouldn't think that locks "should" nest. Because 
they shouldn't. They often do, but we're better off making people very 
aware of the fact that 'often' isn't 'good design', it's just a matter of 
'it happens in practice' rather than 'it should be that way'.

I know for a fact that some people thought unlocking in non-nested order 
was a bug. And I believe that belief is a dangerous one.

				Linus
