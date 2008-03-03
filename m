Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYCCObQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYCCObQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYCCObE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:31:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:54045 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYCCObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:31:03 -0500
Date: Mon, 3 Mar 2008 09:31:00 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mark Hounschell <markh@compro.net>
cc: Jon Masters <jonathan@jonmasters.org>, Mark Hounschell <dmarkh@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rt1 IRQ routing anomaly
In-Reply-To: <47CBFED1.7090903@compro.net>
Message-ID: <Pine.LNX.4.58.0803030852460.13556@gandalf.stny.rr.com>
References: <47BD6802.60604@cfl.rr.com>  <Pine.LNX.4.58.0802210743080.9890@gandalf.stny.rr.com>
  <47BD7D09.9050106@compro.net>  <Pine.LNX.4.58.0802211005380.9890@gandalf.stny.rr.com>
 <1204518711.22885.68.camel@perihelion> <Pine.LNX.4.58.0803030820580.20684@gandalf.stny.rr.com>
 <47CBFED1.7090903@compro.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Mar 2008, Mark Hounschell wrote:
5B> >
> >
> Steve is correct. I have plenty of other choices. Steve, you mentioned, a "work around"
> is in -rt3. My only concern is does the current "work around" for other hardware really
> work or may I see this again with other "non cheap" hardware?

We have a work around for secondary IOAPICS, which sometimes shows this
behaviour (on non-cheap hardware).

The problem we have is that for some reason, IO-APICS with PCI-X chips get
confused when the interrupt line is masked. The work around that we
currently have (besides noapic) is to switch the interrupt to an edged
level interrupt instead of masking. We mark the interrupt as IN_PROGRESS
and if new interrupts come in from the same line, we can just flag them as
pending and return.

This works for some boxes. But this can cause problems for other boxes
that don't like having the interrupt being switched from level to edge and
back. For these boxes, the workaround must be disabled.

Then we have a third set of boxes where the masking causes wrong
interrupts (like what you were seeing) and the level/edge hack also causes
problems. For these boxes the only current solution is noapic.


The last solution to this, which is also our long term fix, is to add a
new interface for devices to let them disable the interrupt at the device
level (not masked at the IO-APIC). The disadvantage to this is the longer
time to traverse the PCI Bus, and added traffic on it. But the advantage
is not only a fix to this problem, but a way to figrane the priorities of
interrupts further than just the interrupt line. With this fix we can
create an interrupt thread per device. Also making the use of tasklets and
softirqs obsolete.  But this has a long way to go still.

>
> Is there a known list of hardware this problem is seen on?

We know of some, the list is still growing.

Jon, where are we on the "blacklist"?

-- Steve

