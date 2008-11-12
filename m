Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbYKLIvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbYKLIvm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYKLIve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:51:34 -0500
Received: from sceest02.correodeempresas.telefonica.es ([212.170.236.203]:57382
	"EHLO sceest02.correodeempresas.telefonica.es" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973AbYKLIvd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:51:33 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Regression: Boot hang sizing transparent PCI-to-PCI bridgesince after 2.6.25-r7.
Date: Wed, 12 Nov 2008 09:50:14 +0100
Message-ID: <D913A682D10DBA4097B5D068D281B09B0266FB4D@S1128EXE.bbva.igrupobbva>
In-Reply-To: <20081111231531.GB7072@us.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Regression: Boot hang sizing transparent PCI-to-PCI bridgesince after 2.6.25-r7.
Thread-Index: AclEU0/swhkN5hRLSqywkWzL8Dm6WAATFJcw
References: <D913A682D10DBA4097B5D068D281B09B0266F65B@S1128EXE.bbva.igrupobbva> <49180973.6080808@gmail.com> <20081110175815.GA7650@us.ibm.com> <20081111231531.GB7072@us.ibm.com>
From: "GARCIA DE SORIA LUCENA, JUAN JESUS" <juanj.g_soria@grupobbva.com>
To: "Gary Hade" <garyhade@us.ibm.com>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Nov 2008 08:50:16.0322 (UTC) FILETIME=[AF013620:01C944A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Gary Hade [mailto:garyhade@us.ibm.com] 
> 
> Correction.  We were not trying to address boot-time hangs 
> but I believe we may have been trying to address expansion 
> ROM related PCI resource allocation failures that we were 
> seeing during boot with certain PCI cards.  However, I doubt 
> that this is relevent to your problem.  The transparent 
> bridge sizing removal change is probably a red herring.

After reading a little bit on how PCI and PCI-to-PCI bridges work, and
how they're handled in linux (http://tldp.org/LDP/tlk/dd/pci.html), I
now know that ranges in the bridge (either I/O, mmio or prefetchable
mem) are simply disabled when start < end, and that's the original
configuration that the BIOS enforces when the bridge is not sized by
Linux.

After inserting kprintf()'s, I see that the hang happens actually while
the positive decoding of the I/O range in the bridge is being activated
in pci_setup_bridge(), sometime in between the writes to the I/O
base/limit registers of the bridge; I don't remember exactly which was
the last pci_Write_config_dword() that allowed the next kprintf() to
succeed. I'll look at it tonight again, but I suspect that the final
enabling write (the one that updates the PCI_IO_BASE_UPPER16 register
with its final value) was the one hanging the machine.

The I/O range being activated was the one in the range 0x1000-0x1fff,
apparently correctly sized to accomodate the two I/O ranges
(0x1000-0x10ff, 0x1400-0x14ff) assigned to the CardBus bridge on the
secondary bus.

One theory is that my system has something actually mapped to that I/O
range in the root PCI bus. When only subtractive decoding is in place
(the I/O range isn't activated), access to the secondary bus behind the
PCI-to-PCI bridge is done when the transaction isn't claimed by any
device in the root bus, after what the PCI docs describe as a 4-cycle
timeout. When the I/O range is activated, that range is positively
decoded by the bridge, which tries to claim the transaction before the
timeout. Perhaps two devices (the bridge and the unknown device on the
root bus) conflict when claiming the same transaction?

Another possibility could be that activating the I/O range disables the
negative decoding in the secondary-to-primary sense of the bridge for
that I/O range. Perhaps some device behind the bridge depends on being
able to forward transactions to the primary bus on that I/O range, but
it's disallowed after the range is configured. For me this seems rather
unlikely, because of the nature of the devices behind the bridge.

I'll look at it more closely again, and I will test whether commenting
out the I/O range sizing (leaving the other ranges to be sized) is
enough to allow the system to run. If so, is there any way to use a
system-specific quirk in order to remove the PCI-to-PCI bridge I/O range
from being sized/activated?


Best regards,

   Juan Jesus.
