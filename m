Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYKAURA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYKAURA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 16:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYKAUQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 16:16:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:55837 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbYKAUQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 16:16:52 -0400
Date: Sat, 1 Nov 2008 13:16:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: (BUG?) round_jiffies() is non-monotonic on SMP
Message-ID: <20081101131648.398fe54a@infradead.org>
In-Reply-To: <Pine.LNX.4.44L0.0811011541040.24707-100000@netrider.rowland.org>
References: <20081101092905.443a2dc5@infradead.org>
	<Pine.LNX.4.44L0.0811011541040.24707-100000@netrider.rowland.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008 15:54:16 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Sat, 1 Nov 2008, Arjan van de Ven wrote:
> 
> > > If this is known, is it regarded as a potential problem?  It
> > > certainly seems likely that some code somewhere depends on
> > > timeouts expiring in the correct order.
> > 
> > I don't think timeouts EVER have that guarantee between different
> > cpus; even if you don't round the timeouts.
> > After all, your CPU A can be in some delay loop with irqs off for
> > longer than the delta was, and boom.. the timers fire in different
> > order.
> 
> Why is that?  The fact that CPU A is busy might mean that the timer
> routines run on some other CPU... but they should still be called in
> the correct order.

Hi,

I think you misunderstand how timers work right now ;)

timers are a per cpu list, and each cpu has its own interrupt to
service this per cpu list.

now... if one cpu disables interrupts for a while, that cpus interrupts
get blocked, including that cpus timer handling irq (whichever method
is used for that)... and only that cpus timers will get delayed, the
other cpus will just keep rolling...


> 
> Is it possible for timer 1 to expire before timer 2 but the handler
> gets interrupted, with the result that timer 2's handler runs to
> completion on a different CPU before timer 1's handler has managed to
> execute more than a couple of instructions?  If it is then I agree,
> timer-ordering requirements between CPUs don't make much sense.

yes
> 
> 
> Come to think of it, is there any good reason why round_jiffies()  
> doesn't always round up?  It seems a lot safer.

at the time folks had concerns about making a big error in that
direction...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
