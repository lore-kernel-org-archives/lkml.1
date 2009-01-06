Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZAFTDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZAFTDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZAFTDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:03:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49881 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbZAFTDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:03:06 -0500
X-Greylist: delayed 9293 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2009 14:03:05 EST
Date: Tue, 6 Jan 2009 14:03:02 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
In-Reply-To: <alpine.LFD.2.00.0901061013250.3057@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0901061401270.10871@gandalf.stny.rr.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>  <20081231104533.abfb1cf9.akpm@linux-foundation.org>  <1230765549.7538.8.camel@think.oraclecorp.com>  <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>  <1231093310.27690.5.camel@twins>
  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <alpine.LFD.2.00.0901060948220.3057@localhost.localdomain> <alpine.LFD.2.00.0901061013250.3057@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Btw, this also fixes a bug: your patch did
> 
> 	+                     __set_task_state(task, state);
> 	+                     /* didnt get the lock, go to sleep: */
> 	+                     schedule();
> 
> for the schedule case without holding the mutex spinlock.
> 
> And that seems very buggy and racy indeed: since it doesn't hold the mutex 
> lock, if the old owner releases the mutex at just the right point (yeah, 
> yeah, it requires a scheduling event on another CPU in order to also miss 
> the whole "task_is_current()" logic), the wakeup can get lost, because you 
> set the state to sleeping perhaps _after_ the task just got woken up. So 
> we stay sleeping even though the mutex is clear.


That is indeed a bug.

Peter, why did you need to move __set_task_state down here?  The -rt patch 
does not do this.

-- Steve
