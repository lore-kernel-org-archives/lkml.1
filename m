Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbXKAP0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbXKAP0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbXKAPZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:25:55 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:56379 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbXKAPZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=TgxFFycwKfTb6yGDQKEfhFX6CwC3mGlZn1HQDBGUchSGE/ogozvMBBM4w/Rx+yDmaskRNN6f9H5HL41SHixwsO7Hdsk/mBlA/fEl/ijNKSP4ntm6nqxbHvj0K5vC6C1Xn0sCafzsU+tQbwpo7LUb5tmQZBMko+6ekLA8Bz4ONtM=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] [linux-pm] Commit "Hibernation: Enter platform hibernation state in a consistent way)" makes my system to resume instantly from S4
Date: Thu, 1 Nov 2007 17:25:30 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <200710271405.32908.maximlevitsky@gmail.com> <200710300036.13186.maximlevitsky@gmail.com> <200710300031.17355.rjw@sisk.pl>
In-Reply-To: <200710300031.17355.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711011725.30619.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 October 2007 01:31:13 Rafael J. Wysocki wrote:
> On Monday, 29 October 2007 23:36, Maxim Levitsky wrote:
> > On Monday 29 October 2007 22:37:37 Rafael J. Wysocki wrote:
> > > On Monday, 29 October 2007 07:45, Maxim Levitsky wrote:
> > > > On Sunday 28 October 2007 22:23:15 Rafael J. Wysocki wrote:
> > > > > On Sunday, 28 October 2007 21:00, Maxim Levitsky wrote:
> > > > > > On Saturday 27 October 2007 23:46:45 Rafael J. Wysocki wrote:
> > > > > > > On Saturday, 27 October 2007 14:05, Maxim Levitsky wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > Recently I noticed that my system resumes just after suspend to disk.
> > > > > > > > 
> > > > > > > > I traced this to commit 9cd9a0058dd35268b24fa16795a92c800f4086d4.
> > > > > > > > 
> > > > > > > > Note:
> > > > > > > > 
> > > > > > > > This happens only if I enable WOL using /proc/acpi/wakeup
> > > > > > > > (echo "ILAN" > /proc/acpi/wakeup)
> > > > > > > 
> > > > > > > What happens after a suspend to RAM?
> > > > > > I do more testing tomorrow, but what I remember is that,
> > > > > > I had no issues with suspend-to-ram.
> > > > > > (And take into account the fact that _all_ wakeup devices were enabled always,
> > > > > > the rc.local does that for me, and still I did quite a lot of suspends, but I
> > > > > > got the immediate resume, only and always after suspend to disk.
> > > > > 
> > > > > Hm, can you please retest with the above commit applied, but with
> > > > > device_suspend() in hibernation_platform_enter() replaced by device_shutdown()?
> > > > Bingo! doing the above fixes this problem.
> > > > And... strange, since I did test the system with e1000 unloaded, but still got same bug,
> > > > back when I chased that bug, thus it is probably not related to e1000 and WOL.
> > > > 
> > > > the ACPI wake-up source (I have read the DSDT, and ICH datasheets, thus I know that this is a set of bits in southbridge)
> > > > of e1000 is shared with EHCI and HDA sound codec.
> > > > (But usb on my system only able to wake from S3, and the soundchip which can theoretically wake up from S3 too, doesn't have this ability)
> > > > 
> > > > (But disabling this wakeup source, fixes this bug too)
> > > 
> > > OK
> > > 
> > > Please get back to device_suspend() in hibernation_platform_enter() and try
> > > to unload ehci_hcd before hibernation with the wakeup source enabled.
> > Well, ... bingo! again!
> > 
> > Replacing back the device_suspend() , and unloading the ehci_hcd fixes the problem!
> > Even more, loading this module back causes this problem to reappear, and vise-verso.
> > All wakeup sources are enabled always.
> > 
> > Note that I don't have any USB 2.0 devices yet.
> > The usb devices I have are: keyboard,mouse,and joystick.
> > 
> > So now this problem looks fixable, I take a look at ehci driver.
> 
> This is very similar to what I've been observing for some time on one of my
> test boxes wrt suspending to RAM and in that case the problem is also related
> to EHCI (this is a pretty old Celeron-based box with an Intel chipset).
> 
> It looks like in some situations, on some platforms the EHCI controller
> triggers a resume right after the suspend (or hibernation) if the driver's
> .suspend() routine is executed before invoking the ACPI firmware to put the
> system into the sleep state.
> 
> [The "ehci_hcd causes box to resume immediately after suspend to RAM" thread on
> linux-pm was about this problem.]
> 
> Greetings,
> Rafael
> 

Sorry, for a bit late response,

Do you meant that EHCI driver triggers the resume regardless of the above commit?

Now I have checked the source and understand that the above commit is 150% right.
(Actually I always assumed that it was always there, and some developers did that too)


I assumed that on hibernation the sequence is:

.suspend() - disable device + enable wake
snapshot

.resume() - enabled device + disable wake
snapshot writeout
.suspend() - disable device + enable wake


But before the above commit was introduced, the last .suspend()
didn't happen, and thus all the code that enables wake was disabled.
For the same reason rtc-cmos didn't work, since its .resume disables the alarm.

The mystery why my system did react to WOL in S4 is resolved by the fact that
e1000 .shutdown() calls .suspend() to make WOL work in S5 too.
(Btw, this is wrong that rtc-cmos disables alarm in .shutdown()  since it can be used in S5 too)


So, this commit caused the EHCI .suspend to activate the wakeup, and this code probably contains a bug
(Or a lack of hardware workaround)


Thus, since the suspend to ram isn't affected by the above commit, I want to know
whenever it affects the system you have seen resuming from ram instantly with ehci driver.


Best regards,
	Maxim Levitsky
