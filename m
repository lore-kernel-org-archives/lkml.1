Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYDOSUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYDOSUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 14:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbYDOSUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 14:20:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbYDOSUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 14:20:32 -0400
Date: Tue, 15 Apr 2008 11:14:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
In-Reply-To: <20080415174109.GD9191@parisc-linux.org>
Message-ID: <alpine.LFD.1.00.0804151101590.2879@woody.linux-foundation.org>
References: <4803AD91.5020001@firstfloor.org> <e2e108260804142318m19cf55c7p9973d3500de18120@mail.gmail.com> <1208242017.7053.4.camel@lappy> <e2e108260804150017u7d0aad8do9b26f7531a3a5226@mail.gmail.com> <1208249088.7124.7.camel@twins>
 <alpine.LFD.1.00.0804150907080.2879@woody.linux-foundation.org> <4804D779.6070907@firstfloor.org> <alpine.LFD.1.00.0804150952300.2879@woody.linux-foundation.org> <4804E29F.9060703@firstfloor.org> <alpine.LFD.1.00.0804151023350.2879@woody.linux-foundation.org>
 <20080415174109.GD9191@parisc-linux.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Apr 2008, Matthew Wilcox wrote:
> 
> > In other words, what makes me not like this is hat we first turn 
> > semaphores into the generic code (which is largely what completions were: 
> > just a special case of the generic semaphores!) and then turns completions 
> > into these things. That just doesn't make any sense to me!
> 
> Blame me for not realising that completions were semaphores under a
> different name.

The origin of completions is literally the semaphore code - just 
simplified to use spinlocks and be usable as just a mutex. We used to use 
semaphores, and because of the subtle race with lockless semaphores I 
wrote that stupid completion code as a "generic semaphore with a very 
specific usage schenario" and called them "completions".

The completions _could_ have been extended/used as mutex semaphores, but 
the difference was really the mental model for them. That then limited the 
implementation of them: the functions working on completions are defined 
on purpose to be limited - it doesn't really have "up()" and "down()" 
functions: "complete()" is really a up(), but "wait_for_completion()" is 
more like a "wait_until_I_could_do_a_trydown()" function.

Would it make sense to use completions for countable events too? Yeah. In 
fact, we have some things that really would like to do counting, both in 
the sense of "wait for <n> events to all complete" _and_ in the sense of 
"allow up to <n> events to be outstanding". Both of which could be done as 
a counting function (just make "complete" increment the counter, and then 
make "wait for <n> events" initialize it to negative, while "allow <n>
outstanding events" would be a positive counter, and make 
"wait_for_completion()" basically be a "decrement and wait until it 
is zero".

IOW, completions() really follow the same patterns as semaphores, and it 
*does* make sense to just have one single code-base. But if we want to 
make semaphores go away, I think that it would be better to implement 
semaphores in terms of "extended completions" rather than the other way 
around. That way, we could one day really get rid of semaphores entirely.

		Linus
