Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbYHAVCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbYHAVCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbYHAVCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:02:23 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:40469 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536AbYHAVCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:02:21 -0400
Date: Fri, 01 Aug 2008 17:02:16 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
 shutdowns
In-reply-to: <alpine.LFD.1.10.0807261434380.2958@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Message-id: <alpine.LFD.1.10.0808011701500.3011@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200807241727.41715.trenn@suse.de>
 <alpine.LFD.1.10.0807261434380.2958@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From lenb@kernel.org Sat Jul 26 14:40:36 2008
Date: Sat, 26 Jul 2008 14:40:35 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-acpi <linux-acpi@vger.kernel.org>, "Moore, Robert" <robert.moore@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>, Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature shutdowns

Thomas,

Thank you for debugging and reporting this issue.
I agree with some of your observations and conclusions,
but not with others, so lets review this carefully.

39a2d7c72b358c6253a2ec28e17b023b7f6f41c
(ACPI: Reject below-freezing temperatures as invalid critical temperatures)
was general workaround resulting from a specific HP machine
with a BIOS bug.

The machine functioned properly in 2.6.25, but shutdown
in 2.6.26-rc1.  Arjan and I debugged this together.
Unfortunately, we both neglected to put the bug URL
in the commit-it, so here it is:

http://bugzilla.kernel.org/show_bug.cgi?id=10686

The failure in bug 10686 is similar, but not identical
to the one you reported here with CRT returning 0.
Arjan's HP has a _CRT with no return statement at all.
In Linux-2.6.25, this _CRT was rejected with

ACPI Exception (thermal-0365): AE_BAD_DATA, No critical threshold [20070126]

and the entire thermal zone was rejected.

4e3156b183aa087bc19804b3295c7c1a71f64752
(ACPICA: changed order of interpretation of operand objects)
ironically, a MS bug compatibility patch,
had the side effect of causing the implicit return
workaround applied to _CRT to return 2006 rather than bombing out.
This was interpreted as 200.7K, or -73C.

Bob looked into this one, and determined that the latest
ACPICA will return 0 here.

http://bugzilla.kernel.org/show_bug.cgi?id=10686#c9

Bob,
It may be helpful if you can elaborate on "latest ACPICA"
in this comment -- ie what release, or better yet, what patch
will cause Linux behavior to change on this code fragment?

If we suddenly start returning 0 there, we'll still be okay
because Arjan's patch above will still catch it.

Anyway, we had a choice of simple fixes for Arjan's HP.
At the time, the question was whether to reject
the entire thermal zone -- failing like 2.6.25
(a thermal zone w/o a _CRT is invalid per spec)
or to reject just the _CRT (ala thermal.nocrt).

We decided to keep it simple (and similar to 2.6.25)
and reject the entire thermal zone.  Thinking about this more,
I think it would be a good idea to instead go
the thermal.nocrt route -- for if this machine
had ACPI fan control (this one doesn't),
the rest of the thermal zone
would be pretty important to normal use....

Rui,
as maintainer of ACPI_THERMAL, perhaps you can look into that,
if Thomas doesn't beat you to it?

In light of Thomas' sighting and Bob's mention that the
latest interpreter will return 0 here...

ALL THIS TELLS US is that Vista doesn't fail certification
when _CRT returns 0.

IT DOES NOT TELL US that Vista has any sort of _CRT bug,
or that Vista mandates _CRT=0.
The T61 I'm typing on has a valid _CRT and a Vista sticker...

The AML Thomas' showed did this:

                If (_OSI ("Windows 2006")) {
                    Store (0x40, TPOS)
                }

            Method (_CRT, 0, Serialized) {
                If (LLess (TPOS, 0x40)) {
                    Return (...valid...)
                }
                Else {
                    Return (Zero)
		}

I draw a totally different conclusion than Thomas does.

This does not look like a Vista workaround to me,
it looks like a simple BIOS bug that Vista doesn't catch.

We've seen BIOS bugs like this many times.
They are consistent with this conversation:

Morning:
BIOS Manager: "please quickly update this platform to support Vista"
BIOS writer: "I'm busy today, but have 30 minutes if I work through lunch..."

Afternoon:
BIOS Manager: "did you look at that Vista update yet?"
BIOS Writer: "yes, I think I did it in only 20 minutes"
BIOS Manager: "you're awesome!  lets send it through WHQL,
	as I've got something else for you to do."

The BIOS passes WHQL and nobody with a brain ever looks
at the source code again...

It would be useful to find out what Vista actually _does_
with _CRT=0.  ie. do they throw out the thermal zone,
or just the _CRT.  Linux should ideally do the same.
However, the fact that plenty of systems with Vista stickers
are shipping with valid _CRT proves that it isn't Vista that
is mandating _CRT=0.

So I DO NOT BELIEVE that this sighting is proof that we should disable
OSI compatibility with Vista or any other version of Windows.
I feel STRONGLY that it is better to be compatible with the
tested path through the BIOS -- even if that tested
path includes workarounds for BIOS bugs that Windows
doesn't catch.  (or workarounds for real Windows bugs --
though I don't believe this thread isn't an example of one)
The alternative would be the FAR GREATER EVIL of trying
to be compatible with an entirely untested path
through the BIOS.  We've been there before and it
was horrific.

I think we all agree that the LONG term solution is to have
tools where OEMs can CERTIFY compatibility with Linux
and a large portion of the machines that Linux runs on
having passed that certification.  When that happens,
that is the time to re-visit our current strategy of
being bug compatible with Windows.  While I believe that
this is a realistic and valuable goal in some markets,
is seems unrealistic in the foreseeable future
in other markets.  ie. I think it is valuable and worth pursuing,
but I would not expect universal success in the foreseeable
future.

Andi,
I ACK Thomas' suggestion to check for <= 0C for HOT,
PSV and ACx trip points.  While we don't have such a
failure in hand and thus this is not urgent, it can
only make Linux more bomb proof.  We might dress it
up a bit, however.  I think that with acpi=strict,
we should complain loudly if this workaround is invoked,
if not disable it altogether.  Thus an OEM who can
boot with acpi=strict and not get warnings or failures
knows that they're not requiring any of our out-of-spec
workarounds.

Further, Thomas' sighting demonstrates that it is important
to get Arjan's patch back into the .stable releases.

thanks,
-Len


