Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbZD0VlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbZD0VlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZD0VlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:41:05 -0400
Received: from mail.vyatta.com ([76.74.103.46]:44021 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbZD0VlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:41:03 -0400
Date: Mon, 27 Apr 2009 14:40:54 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       Jarek Poplawski <jarkao2@gmail.com>, Paul Mackerras <paulus@samba.org>,
       paulmck@linux.vnet.ibm.com, kaber@trash.net, jeff.chua.linux@gmail.com,
       laijs@cn.fujitsu.com, jengelh@medozas.de, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-CPU r**ursive lock {XV}
Message-ID: <20090427144054.1fb9b7a6@nehalam>
In-Reply-To: <alpine.LFD.2.00.0904271340400.22156@localhost.localdomain>
References: <49F22465.80305@gmail.com>
	<20090425133052.4cb711f5@nehalam>
	<49F4A6E3.7080102@cosmosbay.com>
	<20090426185646.GB29238@Krystal>
	<20090426145746.1184aeba@nehalam>
	<1240854297.7620.65.camel@twins>
	<20090427113010.5e3f1700@nehalam>
	<20090427185423.GC23862@elte.hu>
	<20090427120658.35a858bb@nehalam>
	<alpine.LFD.2.00.0904271219570.22156@localhost.localdomain>
	<20090427203616.GB3836@ioremap.net>
	<alpine.LFD.2.00.0904271340400.22156@localhost.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Apr 2009 13:58:48 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 28 Apr 2009, Evgeniy Polyakov wrote:
> > 
> > Just ot be sure readers will not lose the discssion topic: do you object
> > against naming or realizaion?
> 
> I said _long_ ago that I thought the patch was fine. 
> 
> What I object to is people mis-representing the lock, and apparently 
> having a really hard time admitting that having a good grounding in 
> networking doesn't necessarily mean that you know everything about 
> something as basic as locking.
> 
> > If its about the former, does 'dog's breath lock' proposed by Stephen 
> > fit?
> 
> Is that just an attempt to avoid admitting that they were wrong about lock 
> naming? And then trying to trivialize it by calling things by a 
> _different_ wrong name, but silly enough that they hope people won't call 
> them on it?

The part that concerns me is that the reader lock used in a nested manner on
same cpu may still be broken on -rt. Other than that it is just language
lawyering; violent agreement that the lock gets used multiple times by
same CPU. I never had the occasion to address this before
(and avoided such usage), but this legacy code exists and needs to
be dealt with.


> Why not just use the correct name? I think it was Mathieu that just 
> suggested:
> 
> 	[PATCH] netfilter: use bh disabling with per-cpu read-write lock
> 
> or just call it "netfilter: use per-CPU read-write lock".

[PATCH] netfilter: Ceci n'est pas une serrure récurrente

I don't care. I don't care. Don't you get the point yet.



> 
> Why are people so against calling things by their correct names? Why do 
> certain network people seem to force a stupid and incorrect description, 
> when they have been told (a) that it's wrong and (b) why it's wrong 
> several times?

Because meaning comes from context, and my meaning comes from different
context. So we disagree on correct names. 

> What's so hard with just doing the TechnicallyRightThing(tm) and 
> describing it as such?
> 
> And btw - don't get me wrong. There are _other_ ways to do that locking 
> too. You don't have to use a rwlock. You can do it with explicit counting, 
> the way Eric's original patch did. But it would be wrong to call that one 
> "recursive lock" too.
> 
> Or you _could_ use a recursive lock, but nobody has actually posted such 
> patches. It would work. No question about it. And if it actually _were_ a 
> recursive lock, I wouldn't have objected about the description saying it 
> is (although I would probably have objected to it being unnecessarily 
> complex, when a simpler rwlock or the explicit count thing would be 
> sufficient).
> 
> But since the current simple patch is using a rwlock, why not just say 
> that? Why call it something incorrect ("recursive lock") or nonsensical 
> ("dog's breath lock").
> 
> As I tried to explain with an analogy, networking people would (quite 
> correctly) object to me calling a serial line an "ethernet cable". Why is 
> it so hard for netfilter people to then see why it's wrong to call a 
> rwlock a "recursive lock".
> 
> I mean, guys, if you don't want to read up on decades of locking work, 
> just google for it. Google for "recursive lock" (_with_ the quotes). At 
> least for me, the very first hit gives a reasonable explanation for it, 
> and it says:
> 
>   "POSIX allows mutexes to be recursive. That means the same thread can 
>    lock the same mutex twice and won't deadlock."
> 
> and realize that the "same thread" part is very much a keyword, not juat 
> a random implementation detail (the first answer to the question is 
> better than the question, but even the question at the top really does 
> get at the basics).
> 
> And please do realize that neither rwlocks nor the counting locks from 
> Dumazet's original patch do that. Never did. They simply aren't recursive 
> locks.
> 
> So just don't call them that. But is "dog's breath" any better? Yes, maybe 
> it's less _misleading_, but it sure as hell isn't any more descriptive.
> 
> 			Linus
