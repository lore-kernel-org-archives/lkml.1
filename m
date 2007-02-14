Return-Path: <linux-kernel-owner+w=401wt.eu-S964815AbXBNXOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815AbXBNXOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 18:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964816AbXBNXOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 18:14:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50485 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964815AbXBNXOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 18:14:14 -0500
Date: Wed, 14 Feb 2007 15:13:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
In-Reply-To: <20070214220948.GA3790@elte.hu>
Message-ID: <Pine.LNX.4.64.0702141504140.20368@woody.linux-foundation.org>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
 <20070214220948.GA3790@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Feb 2007, Ingo Molnar wrote:
> 
> i think you are banging on open doors. That async_stat() call is very 
> much what i'd like to see glibc to provide, not really the raw syslet 
> interface.

Right. Which is why I wrote (and you removed) the rest of my email.

If the "raw" interfaces aren't actually what you use, and you just expect 
glibc to translate things into them, WHY DO WE HAVE THEM AT ALL?

> The 'cost' of syslets is mostly the atom->next pointer in essence.

No. The cost is:

 - indirect interfaces are harder to follow and debug. It's a LOT easier 
   to debug things that go wrong when it just does what you ask it for, 
   instead of writing to memory and doing something totally obscure.

   I don't know about you, but I use "strace" a lot. That's the kind of 
   cost we have.

 - the cost is the extra and totally unnecessary setup for the 
   indirection, that nobody reallyis likely to use.

> The whole async infrastructure only takes up 20 nsecs more in the cached 
> case. (but with some crazier hacks i got the one-shot atom overhead 
> [compared to a simple synchronous null syscall] to below 10 nsecs, so 
> there's room in there for further optimizations. Our current null 
> syscall latency is around ~150 nsecs.)

You are not counting the whole setup cost there, then, because your setup 
cost is going to be at a minimum more expensive than the null system call.

And yes, for benchmarks, it's going to be done just once, and then the 
benchmark will loop a million times. But for other things like libraries, 
that don't know whether they get called once, or a million times, this is 
a big deal.

This is why I'd like a "async_stat()" to basically be the *same* cost as a 
"stat()". To within nanoseconds. WITH ALL THE SETUP! Because otherwise, a 
library may not be able to use it without thinking about it a lot, because 
it simply doesn't know whether the caller is going to call it once or many 
times.

THIS was why I wanted the "synchronous mode". Exactly because it removes 
all the questions about "is it worth it". If the cost overhead is 
basically zero, you know it's always worth it.

Now, if you make the "async_submit()" _incldue_ the setup itself (as you 
alluded to in one of your emails), and the cost of that is basically 
negligible, and it still allows people to do things simply and just submit 
a single system call without any real overhead, then hey, it's may be a 
complex interface, but at least you can _use_ it as a simple one.

At that point most of my arguments against it go away. It might still be 
over-engineered, but if the costs aren't visible, and it's obvious enough 
that the over-engineering doesn't result in subtle bugs, THEN (and only
then) is a more complex and generic interface worth it even if nobody 
actually ends up using it.

		Linus
