Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbXLWB1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbXLWB1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbXLWB1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:27:04 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48348 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbXLWB1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:27:01 -0500
Message-ID: <476DB95F.3090801@garzik.org>
Date: Sat, 22 Dec 2007 20:26:55 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 22 Dec 2007, Arjan van de Ven wrote:
> 
>> On Sat, 22 Dec 2007 09:20:06 -0500
>> Jeff Garzik <jeff@garzik.org> wrote:
>>> Yuck.  And, Linus is just being silly.  Wait a year then turn on 
>>> MMCONFIG :)  It took PCI MSI a while to mature, but is finally
>>> getting there.
> 
> That _really_ doesn't work.
> 
> Old machines don't go away. We can't just say "wait a year and turn on 
> MMCONFIG", because all the broken machines WILL STILL EXIST.

You are reinforcing my point :)

The exact same thing can be said for PCI MSI machines that are broken. 
Outside of Intel machines, early PCI MSI life was yucky and broken. 
Time passed, we got a handle on the problem set, we quirked that 
problematic set of systems, and life moved on.

And these days, we are benefitting from that -- most new hardware is 
MSI-capable if not MSIX-capable, and we are turning that on.

Some day in the future MSI-only (no INTX) hardware will ship in volume, 
and we will already be adequately prepared for that day.

But here the two items diverge:  PCI MSI _can_ be an _option_ for most 
hardware, hence pci_enable_msi().  But the same cannot be said for 
MMCONFIG, for reasons outlined below...


>> Do you hate the name or the concept? I'm certainly open for a better name.... 
> 
> Just make it so. The name is fine, the concept is unavoidable. The people 
> who complain are whiners that haven't ever had to deal with the fact that 
> there are broken machines around. 
> 
> For example, right now Jeff never sees the problem, because when MMCONFIG 
> doesn't work, it's never his problem - nothing in the machine works. But 
> if he has to add a "pci_enable_mmconfig()" to the drivers he maintains, he 
> sees it as a _new_ problem, so he obviously thinks it's stupid: he was 
> never impacted by the issues it fixed!

I forcibly turn on mmconfig on all my machines, and monitor lkml, to 
make sure I'm aware of the extent of the problem -- and the extent of 
peoples' exaggeration of this problem.


> So it's natural for Jeff to not like it, but that doesn't make Jeff right 
> in this case. It just means that Jeff never had to worry about it before, 
> because as long as MMCONFIG wasn't per-driver, the problems it caused were 
> never *his* problems. But that doesn't make them less of a problem.

Doing it at the driver level fundamentally doesn't work:

Regardless of whether a driver is loaded or not, you may NEED to see 
extended capabilities.  The system may NEED to see those capabilities 
just to parse them for sane operation.

And pciutils should be able to see all of config space, not just the 
Linus-sanitized portion of it.  This will make debugging more difficult, 
for example, because "lspci -vvvxxx" will not be giving me the full 
"before" and "after" snapshots I need from users, to see if anything 
changes based on <some hardware poking during debugging>.

I know when you look you see all sorts of brokenness.  But you and I 
both know that will pass, with time.  If its buggy, turn it off.  If 
not, turn it on.  All these hardware makers are paying attention and 
fixing errata; evidence of forward progress in that regard has already 
appeared even.

Finally, this introduces a new per-device model for PCI config space 
accesses, something we have NEVER done before.  PCI config space should 
always be all or none.  If MMCONFIG is fucked, just turn it off completely.

Having to deal with NEW issues brought on by this NEW per-device config 
space access model is stupid-by-design.  Always-off is better than 
changing the access model from global to per-device.

It is even MORE unlikely that hardware makers test the "mmconfig over 
here, type1 over there" mixed accesses.  Linux should not go down that road.

Always-off is better than mixed access models.

	Jeff



