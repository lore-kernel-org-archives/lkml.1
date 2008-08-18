Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbYHRTDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbYHRTDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932393AbYHRTBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:01:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762180AbYHRTBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:01:07 -0400
Date: Mon, 18 Aug 2008 11:59:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] Fair low-latency rwlock v5
In-Reply-To: <20080817191034.GA5258@Krystal>
Message-ID: <alpine.LFD.1.10.0808181150420.3324@nehalem.linux-foundation.org>
References: <20080816073926.GA19546@Krystal> <48A6EC77.8080904@zytor.com> <20080816154330.GA5880@Krystal> <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org>
 <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org> <20080817191034.GA5258@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 Aug 2008, Mathieu Desnoyers wrote:
> 
> Ah, you are right. This new version implements a "single cmpxchg"
> uncontended code path, changes the _fast semantic for "trylock
> uncontended" and also adds the trylock primitives.

Can you also finally

 - separate out the fastpaths more clearly. The slowpaths should not be 
   even visible in the I$ footprint. The fastpaths are probably better off 
   as a separate "fastpath.S" file to make sure that the compiler doesn't 
   inline the slowpath or do other insane things.

   If the fastpath isn't just a few instructions, there's something wrong. 
   It should be written in assembly, so that it's very clear what the 
   fastpath is. Because most of the time, the fastpath is all that really 
   matters (at least as long as there is some reasonable slow-path and 
   contention behaviour - the slowpath matters int hat it shouldn't ever 
   be a _problem_).

 - don't call these "fair". They may be fairER than the regular rwlocks,
   but you'd really need to explain that, and true fairness you (a) can't
   really get without explicit queueing and (b) probably don't even want, 
   because the only starvation people tend to worry about is reader vs 
   writer, and writer-writer fairness tends to be unimportant. So it's not 
   that people want the (expensive) "fairness" it's really that they want 
   something _reasonably_ fair considering the normal worries.

   (ie if you have so much write activity that you get into write-write 
   fairness worries, you shouldn't be using a rwlock to begin with, so 
   that level of fairness is simply not very interesting).

   People react emotionally and too strongly to to words like "fairness" 
   or "freedom". Different people have different ideas on what they mean, 
   and take them to pointless extremes. So just don't use the words, they 
   just detract from the real issue.

Also, the performance numbers on their own are pretty irrelevant, since 
there's nothing to compare them to. It would be much more relevant if you 
had a "this is what the standard rwlock" does as a comparison for each 
number.

				Linus
