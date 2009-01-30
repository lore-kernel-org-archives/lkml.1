Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZA3QQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZA3QQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 11:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZA3QQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 11:16:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:36943 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZA3QQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 11:16:27 -0500
Subject: Re: [PATCH -v3] use per cpu data for single cpu ipi calls
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901300800350.3150@localhost.localdomain>
References: <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com>
	 <20090128173039.cbc29e81.akpm@linux-foundation.org>
	 <1233218954.7835.11.camel@twins>
	 <alpine.DEB.1.10.0901290958170.13065@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901290912320.3123@localhost.localdomain>
	 <alpine.DEB.1.10.0901291232570.27527@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901290959540.3123@localhost.localdomain>
	 <1233253380.4495.123.camel@laptop>
	 <alpine.LFD.2.00.0901291030510.3123@localhost.localdomain>
	 <1233254680.4495.126.camel@laptop>  <20090130112310.GI30821@kernel.dk>
	 <1233318733.4495.174.camel@laptop>
	 <alpine.LFD.2.00.0901300800350.3150@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 17:16:10 +0100
Message-Id: <1233332170.4495.200.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 08:04 -0800, Linus Torvalds wrote:

> My only question is whetherr we might even drop the kmalloc() some day: 
> I suspect that the CSD_FLAG_LOCK is essentially never a contention point, 
> and the cost (and occasional synchronization) of kmalloc() quite possibly 
> overwhelms any theoretical scaling ability.

IIRC the recent SL*B numbers posted showed that a kmalloc could be as
cheap as ~100 cycles or something. IPIs are sadly still a bit more
expensive.

> If another CPU hasn't even received its IPI before the same CPU sends the 
> next one, I'm not sure we _want_ to send one, in fact.

I think the intent was to re-route IO-completion interrupts to whatever
cpu/node issued the IO with the idea that that cpu/node has the page
hottest etc. and transferring the completion is cheaper than bouncing
the page.

Since that would be relaying hardware interrupts, there's nothing much
you can do about the rate, or something, that's up to the firmware on
$$$ scsi thing.

But Jens already said that that path was using the __ variant and
providing its own csds, the kmalloc isn't needed there, so it might all
be moot.

> But that's a secondary issue, and isn't a correctness thing, just a "do we 
> really need three different allocations?" musing..

Nick, Jens, I was under the presumption that the kmalloc was needed for
something other than failing to deadlock, happen to remember what?

