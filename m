Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911Ab0AGXDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0AGXDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674Ab0AGXDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:03:43 -0500
Received: from xenotime.net ([72.52.64.118]:44671 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753504Ab0AGXDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:03:43 -0500
Date: Thu, 7 Jan 2010 15:03:39 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kerne.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sections mismatch detection
Message-Id: <20100107150339.b66fadc5.rdunlap@xenotime.net>
In-Reply-To: <4B44762C.1090605@suse.cz>
References: <1262772683.4263.147.camel@localhost>
	<20100106104823.GA30439@merkur.ravnborg.org>
	<4B44762C.1090605@suse.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jan 2010 12:38:20 +0100 Michal Marek wrote:

> On 6.1.2010 11:48, Sam Ravnborg wrote:
> > On Wed, Jan 06, 2010 at 12:11:23PM +0200, Artem Bityutskiy wrote:
> >> Hi,
> >>
> >> I wonder is it good time to enable DEBUG_SECTION_MISMATCH by default
> >> now? I mean, remove the following from lib/Kconfig.debug:
> >>
> >> config DEBUG_SECTION_MISMATCH
> >>         bool "Enable full Section mismatch analysis"
> >>         depends on UNDEFINED
> >>         # This option is on purpose disabled for now.
> >>         # It will be enabled when we are down to a resonable number
> >>         # of section mismatch warnings (< 10 for an allyesconfig build)
> >>
> >> Just spotted this, and decided to remind.
> > 
> > My original criteria for enabling this was that we had a warnign free build
> > for all*config on x86 and a few other architectures.
> > While focusing on this I never reached this goal as I usually ended
> > up with some problems related to CPU hotplug.
> > I dunno how close we are today at the "zero warning" target.
> >
> ...
> > 
> > But I can see a steady flow of section mismatch fixes so I think the
> > situation looks better these days.
> 
> There is also steady flow of new code ;-). FWIW, a 2.6.32.2 x86 distro
> build shows 29 section mismatch warnings, 12 of these come from
> drivers/staging, the remaining are (duplicates removed):
> 
> WARNING: drivers/pci/built-in.o(.text+0x10a12): Section mismatch in
> reference from the function dmar_ir_support() to the variable
> .init.data:dmar_tbl
> WARNING: vmlinux.o(.devinit.text+0x3aa2): Section mismatch in reference
> from the function ezx_pcap_probe() to the function
> .init.text:set_irq_noprobe()
> WARNING: drivers/char/hw_random/virtio-rng.o(.data+0x44): Section
> mismatch in reference from the variable virtio_rng to the function
> .devexit.text:virtrng_remove()
> WARNING: drivers/scsi/hpsa.o(.text+0x192c): Section mismatch in
> reference from the function hpsa_pci_init() to the function
> .devinit.text:hpsa_interrupt_mode()
> WARNING: drivers/virtio/virtio_balloon.o(.data+0x44): Section mismatch
> in reference from the variable virtio_balloon to the function
> .devexit.text:virtballoon_remove()
> 
> I'll try a current mainline build with DEBUG_SECTION_MISMATCH=y to see
> if/how this changed.

I would prefer to see (logically) the same section mismatch not be
reported multiple times, even though they are in different binary
files.  This would reduce the noise level quite a bit IMO.

E.g., I see this:

WARNING: drivers/scsi/hpsa.o(.text+0x1bd1): Section mismatch in reference from the function hpsa_pci_init() to the function .devinit.text:hpsa_interrupt_mode()
The function hpsa_pci_init() references
the function __devinit hpsa_interrupt_mode().
This is often because hpsa_pci_init lacks a __devinit 
annotation or the annotation of hpsa_interrupt_mode is wrong.

... followed later by ...

WARNING: drivers/built-in.o(.text+0x28e734): Section mismatch in reference from the function hpsa_pci_init() to the function .devinit.text:hpsa_interrupt_mode()
The function hpsa_pci_init() references
the function __devinit hpsa_interrupt_mode().
This is often because hpsa_pci_init lacks a __devinit 
annotation or the annotation of hpsa_interrupt_mode is wrong.

... followed later by ...

WARNING: vmlinux.o(.text+0x5b5cc4): Section mismatch in reference from the function hpsa_pci_init() to the function .devinit.text:hpsa_interrupt_mode()
The function hpsa_pci_init() references
the function __devinit hpsa_interrupt_mode().
This is often because hpsa_pci_init lacks a __devinit 
annotation or the annotation of hpsa_interrupt_mode is wrong.


One of these (preferably the first one) is enough for me.

---
~Randy
