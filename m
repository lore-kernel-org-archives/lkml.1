Return-Path: <linux-kernel-owner+w=401wt.eu-S965008AbYEBQ3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965008AbYEBQ3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 12:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759530AbYEBQ2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 12:28:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759310AbYEBQ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 12:28:52 -0400
Date: Fri, 2 May 2008 09:28:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
cc: Adrian Bunk <bunk@kernel.org>, Paul Mackerras <paulus@samba.org>,
       Josh Boyer <jwboyer@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
In-Reply-To: <20080502154406.GA6545@beyonder.ift.unesp.br>
Message-ID: <alpine.LFD.1.10.0805020859080.5994@woody.linux-foundation.org>
References: <20080501003125.GM29330@cs181133002.pp.htv.fi> <20080430000338.50548884@infradead.org> <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org> <20080501132159.GC29330@cs181133002.pp.htv.fi>
 <18458.30641.838156.434563@cargo.ozlabs.ibm.com> <1209697815.2946.156.camel@vader.jdub.homelinux.org> <18458.37891.268060.691285@cargo.ozlabs.ibm.com> <20080502082936.GB2003@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805020750220.5994@woody.linux-foundation.org>
 <20080502154406.GA6545@beyonder.ift.unesp.br>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 May 2008, Carlos R. Mafra wrote:
> 
> So I would like to ask you what an user should do when facing what is
> probably a timing-related bug, as it appears I have the bad luck
> of hitting one.

Quite frankly, it will depend on the bug.

If it's *reliably* timing-related (which sounds crazy, but is not at all 
unheard of), it can be reliably bisected down to some totally unrelated 
commit that doesn't actually introduce the problem at all, but that 
reliably turns it on or off.

That can be very misleading, and can cause us to basically revert a good 
commit, only to not actually fix the bug (and possibly re-introduce the 
bug that the reverted commit tried to fix).

But sometimes it gives us a clue where the timing problem is. But quite 
frankly, that seems to be the exception rather than the rule.

There have been issues that literally seemed to depend on things like 
cacheline placement etc, where changing config options for code that was 
never actually even *run* would change timing just enough to show a bug 
pseudo-reliably or not at all.

The good news is that those timing issues are really quite rare. 

Tha bad news is that when they happen, they are almost totally 
undebuggable. 

> This same problem is still present with yesterday's git, and sometimes
> it hangs without hpet=disable and sometimes it doesn't. (And never
> with hpet=disable in the boot command line)

Hey, it may well be a HPET+NOHZ issue. But it could also be that HPET is 
the thing that just allows you to see the hang.

> And using vga=6 or vga=0x0364 makes a difference in the probability
> of hanging.

.. and yeah, these kinds of really odd and obviously totally unrelated 
issues are a sign of a bug that is either simply hardware instability or 
very subtly timing-related.

The reason I mention hardware instability is that there really are bugs 
that happen due to (for example) power supply instabilities. Brownouts 
under heavy load have been causes of problems, but perhaps surprisingly, 
so has _idle_ time thanks to sleep-states!

The latter is probably due to bad powr conditioning on the CPU power 
lines, where the huge current swings (going at high CPU power to low, and 
back again) not only have made soem motherboards "sing" (or "hum", 
depending on frequency) but also causes voltage instability and then 
the CPU crashes.

Am I saying that's the reason you see problems? Probably not. Most 
instabilities really are due to kernel bugs. But hardware instabilities do 
happen, and they can have these kinds of odd effects.

> I am just waiting -rc1 to be released to send an email with my
> problem again, as I am unable to debug this myself.
> I think this is ok from my part, right?

Yes. You've been a good bug reporter, and kept at it. It's not your fault 
that the bug is hard to pin down. 

Quite frankly, it does sound like the hang happens somewhere around the 

	hpet_init
	hpet_acpi_add
	hpet_resources
	hpet_resources: 0xfed00000 is busy

printk's you added (correct?) and we've had tons of issues with NO_HZ, so 
at a guess it is timer-related.

(And I assume it's stable if/once it gets past that boot hang issue? That 
tends to mean that it's not some hardware instability, it's literally our 
init code).

			Linus
