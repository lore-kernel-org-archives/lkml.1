Return-Path: <linux-kernel-owner+w=401wt.eu-S1763205AbXLUOLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763205AbXLUOLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761553AbXLUOLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:11:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760890AbXLUOLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:11:20 -0500
To: Robert Hancock <hancockr@shaw.ca>
Cc: tcamuso@redhat.com, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       "Chumbalkar, Nagananda" <Nagananda.Chumbalkar@hp.com>
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
From: Andi Kleen <andi@firstfloor.org>
References: <fa.HvUNJ45qy60H427u0v9fNt3Gc7E@ifi.uio.no>
	<fa.uuzqvr64HFsgxfiWwhEmE16Di6c@ifi.uio.no>
	<fa.zhxdNN/1rfQhfJLVmdGBjvKYrCM@ifi.uio.no>
	<fa.z1qlON6DA9ubBPFdrEcaFTMgYOY@ifi.uio.no>
	<fa.U/SCC1Gvd3nSOpkMu5vcsSPYyPE@ifi.uio.no>
	<fa.d8kGTkzOZH22bXRIRiakqgOPBM4@ifi.uio.no> <476B0C58.4030703@shaw.ca>
Date: Fri, 21 Dec 2007 15:11:18 +0100
In-Reply-To: <476B0C58.4030703@shaw.ca> (Robert Hancock's message of "Thu\, 20 Dec 2007 18\:44\:08 -0600")
Message-ID: <p73abo4f88p.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock <hancockr@shaw.ca> writes:

> First off, I would like to see confirmation from the horses's mouths
> here (namely AMD,

AMD publicly releases errata sheets/data sheets for their PCI bridges
(check their website).  I haven't checked the 8132 errata for this
though. Not sure it implements MMCONFIG at all.

However the PCI Express chipsets typically do implement 
their own MMCONFIG aperture.

> The case of the device built into the K8 northbridge that's
> unreachable by MMCONFIG kind of makes sense, 

The internal northbridge devices on K8 are not reachable through
mmconfig. While BIOS are supposed to express this in MCFG by excluding
that bus many don't. That was the original reason I added the
type1<->mcfg sanity check. It catches the K8 case fine.

> since the northbridge is
> what's translating the MMCONFIG memory access into config accesses. 

The way it works on K8 systems is that the CPU internal northbridge
knows nothing about MMCONFIG, but that the external chipsets
implement an MMCONFIG aperture on their own outside the northbridge.

If you have multiple bridges like some SLI K8 setups that could
be multiple ones.

This has changed on the Quad Core Fam10h CPUs BTW -- there the
NB can deliver an single mmconfig aperture that is translated
to appropiate transactions on the Hypertransport link.

What might happen with K8 and 8132 (I'm speculating here) is that 
they got a PCI Express chipset that implements an MMCONFIG 
aperture for its devices, but the system also has a PCI-X 8132
bridge and the MMCONFIG aperture inside the chipset doesn't
support talking to the 8132 which might be "upstream" in the HT
topology. And the BIOS' MCFG doesn't tell Linux that.

-Andi


