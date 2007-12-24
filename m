Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbXLXSw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbXLXSw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 13:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbXLXSws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 13:52:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39558 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbXLXSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 13:52:47 -0500
Date: Mon, 24 Dec 2007 10:51:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Loic Prylli <loic@myri.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
In-Reply-To: <476F6047.50100@garzik.org>
Message-ID: <alpine.LFD.0.9999.0712241036040.21557@woody.linux-foundation.org>
References: <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
 <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com> <476DF5BE.5030004@garzik.org> <20071223110337.GA25441@jurassic.park.msu.ru>
 <alpine.LFD.0.9999.0712230925240.21557@woody.linux-foundation.org> <476F6047.50100@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 24 Dec 2007, Jeff Garzik wrote:
> 
> Definitely.  So, two questions:
> 
> What's the preferred way to deal with the desire to view extended config space
> with "lspci -vvvxxx"?

Well, there's two issues right now with MMCONFIG

 - we've hit various bugs in it. The bugs are admittedly very rare, but 
   they are really painful when they happen.

   This is the more "fundamental" of the problems, and this is the one 
   that means that on some machines, the answer to the above question will 
   simply *always* be that we simply will never *ever* show the extended 
   config space - because even though it might work, we are going to 
   decide that it's simply too dangerous.

   (Hypothetical example: we might, for example, end up saying that we 
   will simply never enable mmconfig at all unless the BIOS DMI date says 
   that the motherboard was built in 2008 or later)

 - the (currently more common) problem that our initial probing is totally 
   screwed up with mmconfig.

   This is the thing that causes *most* of our current problems, and the 
   fact is, we absolutely cannot do the initial kernel PCI probing using 
   mmconfig accesses. Not only do we not have enough information about the 
   resources yet at that stage to decide sanely whether mmconfig can 
   really work, but it is my sincere hope that some day the mmconfig MMIO 
   region itself will be defined by some standard BAR etc, so trying to 
   probe the BARs using mmconfig would be a chicken-and-egg problem.

   There's also the issue that we want to often *validate* the mmconfig 
   address using config space accesses, and right now we have some really 
   ugly code that actually uses "pci_conf1_read()" _explicitly_ to avoid 
   using mmconfig for this (see arch/x86/pci/mmconfig-shared.c).

The *second* problem is entirely a kernel internal issue. It's the one 
that causes us the biggest issues right now, but it's also the one that 
will not impact user space at all once if is fixed. So once we do the 
*early* probing using anything but mmconfig accesses, we can then much 
more easily enable mmconfig later, and by the time the user does anything 
like "lspci -vvvxxxx", we could do those mmconfig accesses.

I also suspect that we *may* want to use a separate file for the extended 
config. Right now, things like lspci read the config space by accessing 
a file like

	/sys/bus/pci/devices/0000:00:00.0/config

and I'm not at all sure we want to extend that one past the first 256 
bytes of config space. Why? Because I don't want old programs that may not 
know how dangerous the rest of the space is to read extended config space 
by mistake when they don't know how to parse it anyway.

So I would *suggest* (but this may be overly cautious) that we at least 
consider forcing people who actually want to read extended config space to 
have to use a separate file for it ("/sys/.../extended-config"), because 
that would then also be a sign to the kernel that "ok, the user really 
asked for us to use mmconfig cycles here".

> Is there a path for hw vendors, after passing 1,001 anal checks, to maintain
> the current behavior as it exists today in arch/x86/pci/mmconfig_{32,64}.c?

Well, the *current* behaviour as far as setup is concerned is 
unacceptable. But yes, longer term, we should be able to just have quirk 
entries for saying "enable mmconfig because I know it's safe", except we 
should not enable them until after the core PCI probing has completed.

			Linus
