Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZB1SxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZB1SxF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbZB1Sw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:52:56 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbZB1Swz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:52:55 -0500
Date: Sat, 28 Feb 2009 10:52:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to
 __copy_from_user_*nocache()
In-Reply-To: <20090228182759.GA28865@elte.hu>
Message-ID: <alpine.LFD.2.00.0902281041160.3111@localhost.localdomain>
References: <20090224020304.GA4496@google.com> <200902272305.01867.nickpiggin@yahoo.com.au> <20090228082922.GB11425@elte.hu> <200902282249.57479.nickpiggin@yahoo.com.au> <20090228125816.GA14917@elte.hu> <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain>
 <20090228092450.3ded2db5@infradead.org> <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain> <20090228182759.GA28865@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Feb 2009, Ingo Molnar wrote:
> 
> OTOH, given how draconian non-temporal stores are, i'm leaning 
> towards removing them from the x86 code altogether. If it matter 
> to performance somewhere it can be reintroduced, based on really 
> well backed up numbers.

It would be interesting to see if we could instead base the decision on 
what we really do care about, namely going to do IO.

And the thing is, in this path we _do_ kind of know that. The caller 
(normally generic_perform_write) already does that whole 
balance_dirty_pages_ratelimited() thing.

So rather than passing in the "total_size" thing, we _could_ pass in 
something that is based on

 - are we O_DIRECT? If so: use uncached
 - perhaps: are we really _really_ large? If so: use uncached, we know the 
   caches aren't going to capture it.
 - are we starting writeout due to dirty page balancing: if so, use 
   uncached.

so we could just add a "nocached" flag to that whole 
__copy_from_user[_inatomic]_nocache thing, and we could make 
balance_dirty_pages_ratelimited() return a flag satung whether we're 
starting write-out or not.

Of course, the dirty writeout will always happen to _old_ pages, so we'll 
actually get notified too late, but assuming you have some steady state 
"heavy IO", it would presumably still be a reasonable heuristic.

But on the other hand, I could personally certainly also imagine just not 
doing that whole uncached thing at all. Myself, I tend to care about the 
peformance of the cached case much more than some odd iozone thing. But 
others will have different priorities..

		Linus
