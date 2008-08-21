Return-Path: <linux-kernel-owner+w=401wt.eu-S1759194AbYHUVb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194AbYHUVb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbYHUVbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:31:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44419 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbYHUVbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:31:47 -0400
Message-ID: <48ADDD6D.6000504@zytor.com>
Date: Thu, 21 Aug 2008 14:26:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Writer-biased low-latency rwlock v8
References: <alpine.LFD.1.10.0808161014300.3324@nehalem.linux-foundation.org> <20080816211954.GB7358@Krystal> <alpine.LFD.1.10.0808161422290.3324@nehalem.linux-foundation.org> <20080817075335.GA25019@Krystal> <alpine.LFD.1.10.0808170909420.3324@nehalem.linux-foundation.org> <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal> <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org> <20080821205045.GA24909@Krystal> <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> Because that is already crap.
> 
> Go look at my code once more. Go look at how it has 128 bits of data, 
> exactly so that it DOES NOT HAVE TO LIMIT THE NUMBER OF READERS.
> 
> And then go look at it again.
> 
> Look at it five times, and until you can understand that it still uses 
> just a 32-bit word for the fast-path and no unnecessarily crap in it, but 
> it actually has 128 bits of data for all the slow paths, don't bother 
> emailing me any new versions.
> 
> Please. You -still- apparently haven't looked at it, at least not enough 
> to understand the _point_ of it. You still go on about trying to fit in 
> three or four different numbers in that one word. Even though the whole 
> point of my rwlock is that you need exactly _one_ count (active writers), 
> and _one_ bit (active reader) and _one_ extra bit ("contention, go to slow 
> path, look at the other bits ONLY IN THE SLOW PATH!")
> 
> That leaves 30 bits for readers. If you still think you need to "limit the 
> number of readers", then you aren't getting it.
> 

First of all, let me say I don't pretend to understand formally how you 
deal with overflow-after-the-fact, as unlikely as it is.

However, it seems to me to be an easy way to avoid it.  Simply by 
changing the read-test mask to $0x80000003, you will kick the code down 
the slow path once the read counter reaches $0x80000004 (2^29+1 
readers), where you can do any necessary fixup -- or BUG() -- at leisure.

This fastpath ends up being identical in size and performance to the one 
you posted, although yours could be reduced by changing the test to a 
testb instruction -- at the almost certainly unacceptable expense of 
taking a partial-register stall on the CPUs that have those.

	-hpa
