Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZBWKmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZBWKmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 05:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZBWKmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 05:42:35 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57647 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbZBWKme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:42:34 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl>
	<alpine.LFD.2.00.0902220946070.3111@localhost.localdomain>
	<200902222342.08285.rjw@sisk.pl> <200902230048.33635.rjw@sisk.pl>
	<m1ab8ddfbr.fsf@fess.ebiederm.org> <20090223084400.GB9582@elte.hu>
	<m17i3ha4nk.fsf@fess.ebiederm.org> <20090223094441.GM9582@elte.hu>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 23 Feb 2009 02:42:53 -0800
In-Reply-To: <20090223094441.GM9582@elte.hu> (Ingo Molnar's message of "Mon\, 23 Feb 2009 10\:44\:41 +0100")
Message-ID: <m1bpst77te.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: mingo@elte.hu, tglx@linutronix.de, jbarnes@virtuousgeek.org, lenb@kernel.org, linux-pm@lists.linux-foundation.org, jeremy@goop.org, benh@kernel.crashing.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, rjw@sisk.pl
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ingo Molnar <mingo@elte.hu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4981]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Ingo Molnar <mingo@elte.hu> writes:
>> 
>> > I think this aspect has been well-understood during the 
>> > discussion of this topic and it's just a slightly misleading 
>> > changelog.
>> 
>> As I was a member of that discussion I did not see that.
>> 
>> It took me several passes through the patches to realize the 
>> goal is to allow drivers to be able to sleep while they are in 
>> their late pm shutdown routines.
>> 
>> Why we want this I don't know.  But it seems simple enough to 
>> implement, and it makes it harder to get the late pm suspend 
>> routines wrong, which is always good.
>
> That's not the only goal. The other goal is to further shrink a 
> particular window of suspend fragility: the irqs-disabled stage 
> of the suspend/resume sequence.
>
> Since suspend/resume is a mini-reboot sequence, there's a large 
> amount of code executed - and the variety of code is large as 
> well. We had repeat cases of random drivers re-enabling 
> interrupts and thus breaking other drivers - and these are nasty 
> to debug.
>
> So this patchset disables device IRQs centrally and serializes 
> with pending work - so there's no races with pending IRQs 
> anymore.
>
> The fact that we keep the timer irq running is two-fold: firstly 
> the timer code is special and not really part of the regular 
> suspend/resume sequence.
>
> Drivers want to take timestamps, sometimes they even want to do 
> a small usleep(), etc. Ideally the suspend/resume code is pretty 
> much _the same_ as a regular bootup (and shutdown) code - so we 
> want to provide a similar environment to how drivers initialize 
> and deinitialize, and we want to enable them to share code 
> between bootup/shutdown and suspend/resume agressively.
>
> So the more generic kernel environment we give these fragile 
> handlers, the better we are off in the end. Since we already had 
> IRQS_TIMER, that was just the natural thing to do.

I am all for sharing code, especially if we can factor if
we can find common factors that do the same thing.

I don't know how many times I have found drivers doing something
weird in their shutdown routines that they don't know how
to get the device out of.  The e1000 driver has shown up several
times because it likes to suspend the device on shutdown.

The fact that the methods exposed to drivers were only defined
to be usable on the s2ram/hibernate path is something I have
brought up on more than one occasion as a bad choice.

I'm really not convinced that the rational for separating
out the shutdown methods from the remove methods has
been very good.  That of we don't need to clean up the in-kernel
data structures on reboot so why do something extra that can
introduce instability.

So having been watching a smaller form of this drama on the
reboot path for several years.  Having had a device method
with fixed semantics, and not the dwm sematics of the historical
suspend routing.  I expect there is still a ways to go before
it is simple and easy for drivers to figure out what they need
to implement out of the confusing variety of possible device
methods.

>> > The new suspend code does not rely on truly disabling IRQs 
>> > on the low level. The purpose is to not get IRQs to drivers 
>> > - which might crash/hang/race/misbehave.
>> 
>> Reasonable.  I expect one of the problems with drivers getting 
>> it wrong is that the interface is too complex for mortal 
>> humans to understand.
>
> The suspend/resume state machine certainly used to be a piece of 
> code that makes a seasoned kernel developer weep in fear.
>
> That has changed drastically in the past few months. The 
> suspend+hibernation logic got unified (at least as far as driver 
> methods go), and all the flow and ordering has been cleaned up 
> and has been made more robust.

I will have to look again.  My impression is that overloading
a single method is part of what got us into this mess in the
first place.

No that I don't see things getting better. 

> What makes s2ram fragile is not human failure but the 
> combination of a handful of physical property:
>
> 1) Psychology: shutting the lid or pushing the suspend button is 
>    a deceivingly 'simple' action to the user. But under the 
>    hood, a ton of stuff happens: we deinitialize a lot of 
>    things, we go through _all hardware state_, and we do so in a 
>    serial fashion. If just one piece fails to do the right 
>    thing, the box might not resume. Still, the user expects this 
>    'simple' thing to just work, all the time. No excuses 
>    accepted.
>
> 2) Length of code: To get a successful s2ram sequence the kernel
>    runs through tens of thousands of lines of code. Code which
>    never gets executed on a normal box - only if we s2ram. If 
>    just one step fails, we get a hung box.
>
> 3) Debuggability: a lot of s2ram code runs with the console off, 
>    making any bugs hard to debug. Furthermore we have no 
>    meaningful persistent storage either for kernel bug messages. 
>    The RTC trick of PM_DEBUG works but is a very narrow channel 
>    of information and it takes a lot of time to debug a bug via 
>    that method.

Yep that is an issue.

> The combination of these factors really makes up for a perfect 
> storm in terms of kernel technology: we have this 
> very-deceivingly-simple-looking but complex-and-rarely-executed 
> piece of code, which is very hard to debug.

And much of this as you are finding with this piece of code
is how the software was designed rather then how the software
needed to be.

> Even just one of these factors would be enough to make an 
> otherwise healthy subsystem fragile - no wonder s2ram has been a 
> problem ever since it existed in the upstream kernel.
>
> So now we need just one thing: patience and more of the same 
> good stuff that happened lately.

I think there has been some good progress, and so I am happy
to be patient.  I will still mention on occasion what it
seems we are doing wrong.  Unfortunately I don't have time
to do a lot more than that.

>> > Still, it might make sense to not just use the ->disable 
>> > sequence but primarily the ->shutdown irqchip method (when 
>> > it's available in the irqchip).
>> 
>> Disable seems fine to me.  This is interesting in the context 
>> of all of the irqs that will when masked show up somewhere 
>> else (think boot interrupts).
>> 
>> > While we obviously cannot turn off the PIC that delivers 
>> > timer IRQs at this stage - there's no theoretical reason why 
>> > the suspend sequence couldnt power down some secondary PICs 
>> > as well - in some arch code, or maybe even in the generic 
>> > driver suspend sequence if the device tree is structured 
>> > carefully enough so that the PIC gets turned off last.
>> 
>> If the point is simply to prevent deliver of irqs to the 
>> drivers I don't see the point of anything more than what the 
>> patch does now.
>
> ... except for the usecase i described above. Say some PIC sits 
> on a piece of silicon which gets turned off. I'm not talking 
> about x86 but some custom device. We really dont want that IRQ 
> line to send half of an IRQ message (un-ACK-ed) when it gets 
> turned off. So physically 'suspending' all IRQ lines does make a 
> certain level of long-term sense.

Good point.  We will loose both level and edge triggered events
that occur between suspending the irqs and restoring them but
that is inevitable.  So we might as well call shutdown and totally
turn off the irqs if we can.

I don't know where in the state machine this is getting called but
I would suggest doing this before we shutdown cpus.  We are quickly
reaching the point where laptops will exceed the 8 core limit, of
lowest priority delivery mode.  And only in lowest priority delivery
mode is it possible to migrate irqs outside of the interrupt handlers.

That plus if we suspend the irqs before shutting down the cpus it means
we can safely support more vectors than a single cpu can catch.

I was a little a worried about the shutdown code path because it
requires in the worst case acking a level triggered irq when we have
it disabled, but looking at ack_apic_level that appears to be a well
tested code path.  We just can't reprogram the vector.

> There _might_ be one downside: overhead of ->shutdown() methods. 
> With a typical IRQ count on the typical netbook i doubt it's 
> more than ~50 usecs combined.

Eric
