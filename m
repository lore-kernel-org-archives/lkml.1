Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbZJLWPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbZJLWPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 18:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933459AbZJLWPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 18:15:38 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:23441 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933457AbZJLWPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 18:15:37 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] x86/pci: intel bus root res with IOH reading -v2
Date: Mon, 12 Oct 2009 16:14:49 -0600
User-Agent: KMail/1.9.10
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
References: <4AC97C00.7090503@kernel.org> <200910061257.54877.bjorn.helgaas@hp.com> <20091012203453.GC7648@elte.hu>
In-Reply-To: <20091012203453.GC7648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
To: "Undisclosed.Recipients:"@domain.invalid
Message-Id: <200910121614.49826.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending to linux-kernel and linux-pci because I fat-fingered
something and introduced HTML, so the lists bounced it.]

On Monday 12 October 2009 02:34:53 pm Ingo Molnar wrote:
> 
> * Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > On Tuesday 06 October 2009 11:51:22 am Yinghai Lu wrote:
> > > Bjorn Helgaas wrote:
> > > > On Sunday 04 October 2009 10:54:24 pm Yinghai Lu wrote:
> > > >> for intel system with multi IOH. we could read peer root resource from PCI conf,
> > > >> and don't trust _CRS again for root bus
> > > > 
> > > > Ugh.  Are we going to end up with amd_bus.c, intel_bus.c, nvidia_bus.c,
> > > > broadcom_bus.c, serverworks_bus.c, etc.?
> > > only needed when you have muti ...
> > 
> > I think that translates to "yes, we will need all those bits as soon 
> > as those vendors support larger systems with multiple IOHs."  And I 
> > think that's the wrong answer.
> 
> Why is having cleanly separated per vendor information/driver wrong? I 
> think it's the right answer in most cases. _Especially_ when the other 
> option is to 'rely on the firmware'.

For the patch in question, we don't even have a root cause for the bug
(or at least, I couldn't decipher it from the changelog).  There's a
reference to _CRS being wrong, but we don't currently use _CRS for
x86 host bridges.

But in general, my objection is that even if BIOS provides perfectly
valid information about host bridge apertures, the the fact that Linux
ignores that information means we have to add this sort of vendor-
specific code every time we trip over something.  And we're tripping
over things quite often.

Windows consumes this _CRS information, so while I grant there are
certainly BIOS bugs there, I think most of the bugs are actually in
Linux.

> > > again we should trust HW conf than BIOS.
> > 
> > Certainly there's a tradeoff between a generic driver that relies on 
> > the BIOS, and a platform-specific driver that uses only the hardware. 
> > The first leaves us vulnerable to BIOS bugs, but the second leads to a 
> > plethora of drivers that require updates as hardware changes.
> 
> We do that quite well in Linux - it's one of our main strengths.
> 
> Why should we have to rely on correct firmware? Why is it wrong to know 
> about the hw's structure, to query the hardware and ignore the firmware 
> if the hardware state tells us otherwise?

If we need to learn something useful about the HW that the generic
description isn't expressive enough to tell us, that's fine.  But
that's not the case here -- all we need is the very simple description
of the bridge apertures.  I object to the idea that "new machine X
comes out, it has a correct ACPI description of the host bridges,
let's go write some X-specific code so Linux can run on it."

I *like* the idea of "new machine X comes out, oops, the BIOS is
broken, let's write a quirk to work around the BIOS defect so Linux
can run on it."  But I think this is actually less common than many
people think, simply because most machines are tested with Windows,
and that shakes out the most egregious BIOS bugs.

Bjorn
