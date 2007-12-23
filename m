Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbXLWRdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbXLWRdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 12:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbXLWRdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 12:33:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852AbXLWRdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 12:33:05 -0500
Date: Sun, 23 Dec 2007 09:32:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Jeff Garzik <jeff@garzik.org>, Loic Prylli <loic@myri.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
In-Reply-To: <20071223110337.GA25441@jurassic.park.msu.ru>
Message-ID: <alpine.LFD.0.9999.0712230925240.21557@woody.linux-foundation.org>
References: <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org> <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
 <476DDFEE.3010009@garzik.org> <alpine.LFD.0.9999.0712222034150.21557@woody.linux-foundation.org> <476DE98F.2010009@garzik.org> <476DF1A6.3060900@myri.com> <476DF5BE.5030004@garzik.org> <20071223110337.GA25441@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Dec 2007, Ivan Kokshaysky wrote:
> 
> This is a result of all-or-none approach, as mmconfig is fundamentally
> unsafe until after PCI init is done.

Yes. One of the things I want to have happen (and which 
"pci_enable_mmconf()" would do automatically) is that we always probe 
using conf1 cycles in any machine where conf1 works at all. 

Then, some late PCI quirk or some per-device quirk (or driver) can decide 
to enable mmconf later, and that avoids the current nightmare with the 
whole resource ordering. 

Of course, if there really are machines that have somehow disabled conf1 
accesses, we'd have to use mmconfig early, but that should automatically 
be handled by the PCI config probing stuff (ie we already test whether 
conf1 accesses seem to work, and would fall back on alternate config 
cycle accesses if conf1 looks broken).

Right now, the check that MMCONF space has to be in e820-reserved memory 
space protects us from *most* of the probe-time problems, but that's also 
obviously the check that actually means that MMCONF isn't actually used on 
the vast majority of machines out there.

(For example: I have three machines that I know have working MMCONF. On 
only one of theose does Linux actually even enable MMCONF accesses, 
because on the two other ones the BIOSes do the crazy "put it in some 
space that is reserved by PnP crap later", so we actually refuse to touch 
it. So at least in my limited environment, we hardly get any MMCONFIG test 
coverage, exactly because we have to be so totally anal about not enabling 
it early, because we cannot guarantee that it's not clashing with anything 
else).

			Linus
