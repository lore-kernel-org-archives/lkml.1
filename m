Return-Path: <linux-kernel-owner+w=401wt.eu-S933620AbZLFDMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbZLFDMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 22:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbZLFDMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 22:12:30 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:43878 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031AbZLFDM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 22:12:29 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>
References: <20091123145409.GA29627@wotan.suse.de>
	<alpine.LFD.2.00.0911280927180.2561@localhost>
	<20091130100041.GA29610@infradead.org>
	<alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>
	<20091130174638.GA9782@elte.hu>
	<alpine.LFD.2.00.0911302206370.24119@localhost.localdomain>
	<1259616429.26472.499.camel@laptop>
	<alpine.LFD.2.00.0911302300550.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
	<alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
	<alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
In-Reply-To: <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain> (Linus Torvalds's message of "Mon\, 30 Nov 2009 14\:49\:10 -0800 \(PST\)")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
Date: Sat, 05 Dec 2009 19:12:28 -0800
Message-ID: <m1y6lg7q3n.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [rfc] "fair" rw spinlocks
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 30 Nov 2009, Thomas Gleixner wrote:
>> 
>> I'm aware of that. The number of places where we read_lock
>> tasklist_lock is 79 in 36 files right now. That's not a horrible task
>> to go through them one by one and do a case by case conversion with a
>> proper changelog. That would only leave the write_lock sites. 
>
> The write_lock sites should be fine, since just changing them to a 
> spinlock should be 100% semantically equivalent - except for the lack of 
> interrupt disable. And the lack of interrupt disable will result in a nice 
> big deadlock if some interrupt really does take the spinlock, which is 
> much easier to debug than a subtle race that would get the wrong read 
> value.
>
>> We can then either do the rw_lock to spin_lock conversion or keep the
>> rw_lock which has no readers anymore and behaves like a spinlock for a
>> transition time so reverts of one of the read_lock -> rcu patches
>> could be done to debug stuff.
>
> So as per the above, I wouldn't worry about the write lockers. Might as 
> well change it to a spinlock, since that's what it will act as. It's not 
> as if there is any chance that the spinlock code is subtly buggy.
>
> So the only reason to keep it as a rwlock would be if you decide to do the 
> read-locked cases one by one, and don't end up with all of them converted. 
> Which is a reasonable strategy too, of course. We don't _have_ to convert 
> them all - if the main problem is some starvation issue, it's sufficient 
> to convert just the main read-lock cases so that writers never get 
> starved.
>
> But converting it all would be nice, because that whole
>
> 	write_lock_irq(&tasklist_lock);
>
> to
>
> 	spin_lock(&tasklist_lock);
>
> conversion would likely be a measurable performance win. Both because 
> spinlocks are fundamentally faster (no atomic on unlock), and because you 
> get rid of the irq disable/enable. But in order to get there, you'd have 
> to convert _all_ the read-lockers, so you'd miss the opportunity to only 
> convert the easy cases.


Atomically sending signal to every member of a process group, is the
big fly in the ointment I am aware of.  Last time I looked I could
not see how to convert it rcu.

Fundamentally: "kill -KILL -pgrp" should be usable to kill all of
the processes in a process group, and "kill -KILL -1" should be usable
to kill everything except the sender and init.  Something I have seen
in shutdown scripts on more than one occasion.

This is a subtle in the sense that it won't show up in simple tests if
you get it wrong.

This is a pain because we occasionally signal a process group from
interrupt context.

The trouble as I recall is how to ensure new processes see the signal.

Eric
