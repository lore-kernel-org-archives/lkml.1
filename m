Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbYJ1D0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbYJ1D0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 23:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYJ1D0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 23:26:41 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1164 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYJ1D0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 23:26:39 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Subject: Re: [PATCH] PCI: Limit VPD length for Broadcom 5708S
From: "Benjamin Li" <benli@broadcom.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
cc: "willy@linux.intel.com" <willy@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       "Linux Netdev List" <netdev@vger.kernel.org>,
       "Michael Chan" <mchan@broadcom.com>
In-Reply-To: <4906405F.6080708@cosmosbay.com>
References: <48920413.6080508@cosmosbay.com>
 <4906405F.6080708@cosmosbay.com>
Date: Mon, 27 Oct 2008 20:26:25 -0700
Message-ID: <1225164385.3977.11.camel@localhost>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1
X-WSS-ID: 651859EE3IO2979650-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

It looks like the same problem again: we are reading past a valid VPD
address.

After some initial debugging, it looks like dev->vpd is NULL when the
Broadcom 5706C/5706S/5708C/570S/5709 quirk is called.  Because of this
dev->vpd->len is never set to the proper length to limit the VPD reads.
I will debug further to determine what has changed.

Thanks again for pointing out the problem.

-Ben

On Mon, 2008-10-27 at 15:27 -0700, Eric Dumazet wrote:
> Eric Dumazet a écrit :
> > While trying to upgrade kernel from 2.6.25 to 2.6.26 on a ProLiant 
> > BL460c G1,
> > I faced this problem on integrated Broadcom 5708S NIC when trying to UP 
> > them.
> > 
> > bnx2: fw sync timeout, reset code = 1030003
> > 
> > I noticed that commit 99cb233d60cbe644203f19938c729ea2bb004d70 (PCI: 
> > Limit VPD read/write lengths for Broadcom 5706, 5708, 5709 rev.A)
> > was probably a good candidate to solve the problem.
> > 
> > Apparently, it added PCI quirks for a list of Broadcom NICs, but
> > quirk_brcm_570x_limit_vpd() ignores part of them.
> > 
> > I found the following patch useful to restore correct operation on my 
> > machine.
> > 
> > Some information about this nic :
> > 
> > 03:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708S 
> > Gigabit Ethernet (rev 12)
> >        Subsystem: Hewlett-Packard Company NC373i Integrated 
> > Multifunction Gigabit Server Adapter
> >        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
> > ParErr+ Stepping- SERR+ FastB2B-
> >        Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
> > <TAbort- <MAbort- >SERR- <PERR-
> >        Latency: 64 (16000ns min), Cache Line Size 10
> >        Interrupt: pin A routed to IRQ 222
> >        Region 0: Memory at f6000000 (64-bit, non-prefetchable) [size=32M]
> >        [virtual] Expansion ROM at d1200000 [disabled] [size=16K]
> >        Capabilities: [40] PCI-X non-bridge device.
> >                Command: DPERE- ERO- RBC=0 OST=4
> >                Status: Bus=3 Dev=0 Func=0 64bit+ 133MHz+ SCD- USC-, 
> > DC=simple, DMMRBC=0, DMOST=4, DMCRS=2, RSCEM-
> >        Capabilities: [48] Power Management version 2
> >                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
> > PME(D0-,D1-,D2-,D3hot+,D3cold+)
> >                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> >        Capabilities: [50] Vital Product Data
> >        Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=0/0 
> > Enable+
> >                Address: 00000000feeff00c  Data: 4179
> > 
> > after applying patch :
> > 
> > # hexdump -C 
> > "/sys/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/0000:03:00.0/vpd"
> > 00000000  82 2f 00 48 50 20 4e 43  33 37 33 69 20 4d 75 6c  |./.HP 
> > NC373i Mul|
> > 00000010  74 69 66 75 6e 63 74 69  6f 6e 20 47 69 67 61 62  |tifunction 
> > Gigab|
> > 00000020  69 74 20 53 65 72 76 65  72 20 41 64 61 70 74 65  |it Server 
> > Adapte|
> > 00000030  72 00 90 4a 00 50 4e 03  4e 2f 41 45 43 03 4e 2f  
> > |r..J.PN.N/AEC.N/|
> > 00000040  41 53 4e 0a 30 31 32 33  34 35 36 37 38 39 4d 4e  
> > |ASN.0123456789MN|
> > 00000050  04 31 30 33 43 52 56 26  a2 00 00 00 00 00 00 00  
> > |.103CRV&........|
> > 00000060  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  
> > |................|
> > 00000070  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 78  
> > |...............x|
> > 00000080
> > 
> > Patch against current Linus tree, should also be sent for linux-2.6.26.2 
> > inclusion.
> > 
> > I have no idea if 5706S and 5709S also needs this truncation of VPD length
> > 
> > Thank you
> > 
> > [PATCH] PCI: Limit VPD length for Broadcom 5708S
> > 
> > BCM5708S wont work correctly unless VPD length truncated to 128
> > 
> > Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> > 
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index 0fb3650..59667e5 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -1756,9 +1756,12 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_VIA, 
> > 0x324e, quirk_via_cx700_pci_parking_c
> >  */
> > static void __devinit quirk_brcm_570x_limit_vpd(struct pci_dev *dev)
> > {
> > -    /*  Only disable the VPD capability for 5706, 5708, and 5709 rev. A */
> > +    /*
> > +     * Only disable the VPD capability for 5706, 5708, 5708S and 5709 
> > rev. A
> > +     */
> >     if ((dev->device == PCI_DEVICE_ID_NX2_5706) ||
> >         (dev->device == PCI_DEVICE_ID_NX2_5708) ||
> > +        (dev->device == PCI_DEVICE_ID_NX2_5708S) ||
> >         ((dev->device == PCI_DEVICE_ID_NX2_5709) &&
> >          (dev->revision & 0xf0) == 0x0)) {
> >         if (dev->vpd)
> > 
> 
> Hi all
> 
> Just tried linux-2.6.28-rc2 on same platform.
> 
> Same problem again...
> 
> Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.8.1 (Oct 7, 2008)
> bnx2 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> eth0: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz found at mem f6000000, IRQ 16, node addr 00:1e:0b:ec:d3:dc
> bnx2 0000:07:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> eth1: Broadcom NetXtreme II BCM5708 1000Base-SX (B2) PCI-X 64-bit 133MHz found at mem fa000000, IRQ 16, node addr 00:1e:0b:ec:d3:d2
> bnx2 0000:03:00.0: irq 45 for MSI/MSI-X
> bnx2: fw sync timeout, reset code = 1030003
> bnx2 0000:07:00.0: irq 45 for MSI/MSI-X
> bnx2: fw sync timeout, reset code = 1030003
> bnx2 0000:03:00.0: irq 45 for MSI/MSI-X
> bnx2: fw sync timeout, reset code = 1030006
> 
> 
> 2.6.27.4 is running fine on this machine
> 
> Any ideas ?
> 
> Thank you
> 
> Eric
> 
> 
> 
> 


