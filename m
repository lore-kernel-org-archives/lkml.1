Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYAJU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYAJU3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbYAJU3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:29:32 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:55254 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbYAJU3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:29:30 -0500
Subject: Re: [RFC PATCH 13/22 -v2] handle accurate time keeping over long
	delays
From: john stultz <johnstul@us.ibm.com>
To: Tony Luck <tony.luck@intel.com>, bob.picco@hp.com
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com>
References: <20080109232914.676624725@goodmis.org>
	 <20080109233044.288563621@goodmis.org>
	 <1199923219.6350.16.camel@localhost.localdomain>
	 <12c511ca0801101154q224c7a43sa016190cf209d304@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 12:29:19 -0800
Message-Id: <1199996959.6108.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-10 at 11:54 -0800, Tony Luck wrote:
> > Tony:  ia64 also needs something like this, but I found the fsyscall asm
> > bits a little difficult to grasp. So I'll need some assistance on how to
> > include the accumulated cycles into the final calculation.
> 
> I'm trying to figure out all the ramifications of the new
> "cycle_accumulated" field.  Does it really need to be
> propagated all the way to the low level assembler (which
> I don't want to mess with unless I really, really have to).
> Can't I do the necessary calculations in update_vsyscall()
> [Where I can do them in C :-)] and keep the same low
> level assembly code.  I think I must be missing some
> important bit of what is going on here.

(Added Bob Picco to the mail, as he was involved in the ia64 clocksource
work).

So the background on the patch is this:

Some clocksources wrap frequently (every few seconds, for example). This
can cause issues if we defer the update_wall_time() function where we
accumulate time for too long (this really only happens on -rt systems
right now). 

To avoid that issue, we've added the cycle_accumulated value, which acts
as a midpoint, where we can quickly accumulate cycles off of the
counter, without doing the more expensive update_wall_time() function.
This avoids issues with the clocksource wrapping, but requires that
cycle_accumulated be added in to the gettiemofday() calculation.

If you noticed in my email, the fix for ppc was a bit easier, as it has
only a 64bit counter that is quite unlikely to wrap twice between calls
to update_wall_time(). There we could decrement the cycles_last value by
cycles_accumulated and get the same effect of adding it in.

Unfortunately on ia64, I suspect it will be necessary to do similar to
the x86_64 code and add in the cycles accumulated value in
vgettime/fgettime function, since there is the possibility of quickly
wrapping clocksources on that architecture. 

So unless someone can point out a nicer trick, it likely means adding a
new cycles_accumulated value to the fsyscall structure and the asm to do
the addition. :(

thanks
-john


