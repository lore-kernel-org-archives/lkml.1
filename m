Return-Path: <linux-kernel-owner+w=401wt.eu-S1761938AbXH1VZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761938AbXH1VZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760748AbXH1VZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:25:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52222 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437AbXH1VZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:25:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH -mm 2/3] PM: More fine grained ACPI handling during suspend and hibernation (rev. 3)
Date: Tue, 28 Aug 2007 23:35:46 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708272347.45438.rjw@sisk.pl> <200708272351.10882.rjw@sisk.pl> <200708281548.45912.lenb@kernel.org>
In-Reply-To: <200708281548.45912.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708282335.47113.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28 August 2007 21:48, Len Brown wrote:
> On Monday 27 August 2007 17:51, Rafael J. Wysocki wrote:
> > According to the ACPI specification (eg. ACPI 2.0c, sec. 7.3.1, 7.3.3,
> > ACPI 3.0b, sec. 7.3.1, 7.3.3) the _GTS and _BFS global control methods should
> > be executed, respectively, right before entering a sleep state (S1-S4) and right
> > after leaving it, but we don't follow this reqirement.  Namely, in our
> > implementation the nonboot CPUs are disabled after executing _GTS and enabled
> > before executing _BFS, which doesn't seem to be correct.
> 
> I've never encountered a BIOS that actually implements _GTS or _BFS,
> so I expect that changing how they are invoked may be somewhat academic.

It is for now, but once we have a system that implements them, we'd most
probably need to change the current code, so I think it's better to consider
that in advance.

> > [In fact, the ACPI 
> > specification requires that no physical I/O and interrupt servicing be performed
> > after the sleep state has been left and before _BFS is executed as well as after
> > executing _GTS and before the sleep state is entered, but we can't follow this
> > requirement literally, 
> 
> > since our AML interpreter needs to run with interrupts 
> > enabled and we need to carry out some operations with interrupts disabled before
> > entering the sleep state and after leaving it.]
> 
> This is sort of a myth.
> 
> The real requirement is that the ACPI interpreter must be able to call kmalloc().
> It does this today via acpi_os_allocate(), which does this:
> 
> kmalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
> 
> No, we don't actually run the interpreter during device interrupts,
> but we need to be able to run it with interrupts off for boot,
> suspend, and resume.

At present, during suspend and resume we always call the AML interpreter
with interrupts enabled.

Frankly, I'd like _BFS and _GTS to be executed with interrupts disabled,
just as the specification tells us to do.  If you think that's safe, I'll
change the patch to work this way.

> So how did boot work before this hack was added?
> kmalloc() does a might_sleep(), but deep down in
> cond_sleep, there is a handy little check for
> if (system_state == SYSTEM_RUNNING)
> to disable the run-time oops.
> 
> I suggested that since it works during boot, and resume is in many
> ways similar to boot, we should just re-use system_state for early resume.
> But at the time, akpm told me not to use system_state, and so we have the hack above.
> 
> I don't recall his reasoning -- it might be something that should
> be re-visited.  I don't like disabling the may_sleep() check all the time,
> I'd rather just disable it during the critical boot/suspend/resume states.
> 
> > Moreover, acpi_enable() called 
> > after restoring the system memory state from a hibernation image should really
> > be executed before enabling the nonboot CPUs, since functional ACPI may be
> > needed for that.  All of this means that we need to handle ACPI in a more fine
> > grained manner during suspend and hibernation.
> 
> I don't follow the requirement to boot an ACPI-enabled resume image
> from a non-ACPI-enabled boot kernel.  Certainly this isn't a scenario
> described by the ACPI spec, which transitions between G1(S4) and G0(S0) without
> going through an ACPI-disabled state.

That actually depends on which version of the ACPI specification you consider.

In ACPI 3.0 (and later) there's section 15 "Waking and Sleeping" that
describes, among other things, the supposed system start sequence (in 15.3.3).
It clearly states that we're supposed to check if ACPI is enabled (and enable
if not), only _after_ the hibernation image has been loaded.  After that, in
turn, we should execute _BFS and subsequently _WAK, so my interpretation is
that we should not execute any ACPI methods before that point.

Anyway, however, if the user passes acpi=off to the boot kernel, ACPI may not
be enabled until the image kernel gets control.  Thus, it should always check
if ACPI is enabled (and enable it, if need be) before doing anything
ACPI-related and that should happen before the nonboot CPUs are enabled.
Preferrably, with interrupts off, as that should be done before we attempt to
execute _BFS.

Greetings,
Rafael
