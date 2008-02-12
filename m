Return-Path: <linux-kernel-owner+w=401wt.eu-S1761991AbYBLNPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761991AbYBLNPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbYBLNPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:15:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47732 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbYBLNPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:15:01 -0500
Date: Tue, 12 Feb 2008 14:50:27 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212135027.GA1343@one.firstfloor.org>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212123839.GA15360@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 01:38:39PM +0100, Ingo Molnar wrote:
> So unless i forgot about something (please yell if so), it seems to me 
> kgdb is now pretty ready for an upstream merge.

I don't know -- I have not reread everything. Please don't consider
my comments as approval of the code base. I still think it does quite
a lot of dubious and ugly things overall and should get far more clean up
and get more testing too.

> do spinning for now: we dont _ever_ want to break a correctly working 
> system with kgdb.

Stopping all CPUs for indefinite time very much seems like 
"breaking a correctly working system" to me.  In a correctly working system 
kgdb is never entered.

> A valid counter-argument is _not_ to argue "but it would be nice to have 
> if the system is broken in X, Y and Z ways" (like you did), but to point 
> it out why the behavior we chose is wrong on a correctly working system.
> 
> Yes, a buggy system might misbehave in various ways but my primary 
> interest is in keeping correctly working systems correct.

The only way I know of to do that is gdb vmlinux /proc/kcore 
kgdb certainly isn't it.

> And note that kgdb is not just a "debugger", it's a system inspection 
> tool. An intelligent, human-controlled printk.

For that gdb vmlinux /proc/kcore already works fine. Or fireproxy.
If that was the only goal we wouldn't need all that stub code.


> > > just introduce unnecessary complexity.
> > 
> > The question is less about actually having it as a module, but just if 
> > the interfaces are clean enough to allow it as a module. If not you 
> > should probably clean them up.
> 
> but your contention is simply wrong. Most of our debugging 
> infrastructure is non-modular for a good reason. Modularization 
> increases complexity and that's exactly the wrong direction for 

The main complexity in module handling is handling (or rather preventing)
module unload.  I explicitely excluded that in my earlier mail. 
Module loading on the other hand tends to be relatively easy.

I did a modular kernel debugger on my own some time ago and once
the interfaces were clean it was very simple. I think the reverse
is true too -- if having it as a module is easy then the interfaces
are clean too. That is why I asked for it. It's a good basic
sanity check on the design.

> 
> > > no, not all architectures have it. This is a weak alias that is 
> > > otherwise not linked into the kernel.
> > 
> > Can't be very many because oprofile needs it and it works on most 
> > archs now. Anyways, the right thing is to just add it to the 
> > architectures that still miss it, not reimplement it in kgdb.
> 
> it's not reimplemented - kgdb_arch_pc() does not directly map to 
> instruction_pointer().

If that is true then it is definitely misnamed and likely 
incorrectly implemented on the architecture in question.

> > [...] If kgdb is active it should have priority over crash dumps.
> 
> that's the approach we are taking: be as unintrusive as possible. This 
> means that the notifier here is registered at the lowest priority. You 
> might disagree with it but it's a completely sensible and consistent 
> approach.

Yeah, it is consistently wrong agreed.

-Andi

