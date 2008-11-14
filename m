Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYKNU5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYKNU5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 15:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYKNU5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 15:57:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:44071 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYKNU5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 15:57:10 -0500
Subject: Re: Active waiting with yield()
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, rml@tech9.net, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
	 <20081114190616.30dd273e@lxorguk.ukuu.org.uk>
	 <Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 14 Nov 2008 21:57:01 +0100
Message-Id: <1226696221.7685.8148.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 14:34 -0500, Mikulas Patocka wrote:
> 
> On Fri, 14 Nov 2008, Alan Cox wrote:
> 
> > > * driver unload --- check the count of outstanding requests and call 
> > > yield() repeatedly until it goes to zero, then unload.
> > 
> > Use a wakeup when the request count hits zero
> > 
> > > * reduced size of data structures (and reduced cache footprint for the hot 
> > > path that actually processes requests)
> > 
> > The CPU will predict the non-wakeup path if that is normal. You can even
> > make the wakeup use something like
> > 
> > 	if (exiting & count == 0)
> > 
> > to get the prediction righ
> > 
> > > The downside of yield is slower unloading of the driver by few tens of 
> > > miliseconds, but the user doesn't really care about fractions of a second 
> > > when unloading drivers.
> > 
> > And more power usage, plus extremely rude behaviour when virtualising.
> 
> How these unlikely cases can be rude?
> 
> If I have a race condition that gets triggered just for one user in the 
> world when repeatedly loading & unloading a driver for an hour, and I use 
> yield() to solve it, what's wrong with it? A wait queue increases cache 
> footprint for every user. (even if I use preallocated hashed wait queue, 
> it still eats a cacheline to access it and find out that it's empty)

Depending on the situation, yield() might be a NOP and therefore not
wait at all and possibly lock up the machine.

Consider the task in question to be the highest priority RT task on the
system, you doing: while (!condition) yield(); will lock up the system,
because whatever is to make condition true will never get a chance to
run (not considering SMP).

Clearly you don't understand it, please refrain from using it. Use
regular condition variables (waitqueues).

The rules about yield are:

 - You're likely wrong, don't use it.
 - Seriously, you don't need it.
 - If you still think you do, goto 1.

In all of the kernel there is 1 valid use (and it might only be in the
-rt kernel - didn't check mainline recently).

The _ONLY_ valid use case of yield(), is if you have two equal priority
FIFO threads that co-depend. And that situation is almost always
avoidable.

