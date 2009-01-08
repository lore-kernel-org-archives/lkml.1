Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbZAHSRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbZAHSRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZAHSRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:17:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271AbZAHSRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:17:06 -0500
Date: Thu, 8 Jan 2009 10:16:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
In-Reply-To: <alpine.DEB.1.10.0901081300370.24688@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.0901081005560.3283@localhost.localdomain>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>  <1231347442.11687.344.camel@twins>  <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>  <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
  <1231365115.11687.361.camel@twins>  <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>  <1231366716.11687.377.camel@twins>  <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>  <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
  <1231426014.11687.456.camel@twins>  <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.DEB.1.10.0901081227260.24688@gandalf.stny.rr.com> <alpine.LFD.2.00.0901080943270.3283@localhost.localdomain>
 <alpine.DEB.1.10.0901081300370.24688@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Jan 2009, Steven Rostedt wrote:
> 
> Ouch! I think you are on to something:

Yeah, there's somethign there, but looking at Chris' backtrace, there's 
nothing there to disable preemption. So if it was this simple case, it 
should still have preempted him to let the other process run and finish 
up.

So I don't think Chris' softlockup is at least _exactly_ that case. 
There's something else going on too.

That said, I do think it's a mistake for us to care about the value of 
"spin_on_owner()". I suspect v8 should

 - always have

	if (need_resched())
		break

   in the outer loop.

 - drop the return value from "spin_on_owner()", and just break out if 
   anything changes (including the need_resched() flag).

 - I'd also drop the "old_value < 0 &&" test, and just test the 
   list_empty() unconditionally. 

Aim for really simple. 

As to what to do about the "!owner" case - we do want to spin on it, but 
the interaction with preemption is kind of nasty. I'd hesitate to make the 
mutex_[un]lock() use preempt_disable() to avoid scheduling in between 
getting the lock and settign the owner, though - because that would slow 
down the normal fast-path case.

Maybe we should just limit the "spin on !owner" to some maximal count.

		Linus
