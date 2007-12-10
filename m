Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbXLJQkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbXLJQkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 11:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbXLJQkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 11:40:36 -0500
Received: from web52904.mail.re2.yahoo.com ([206.190.49.14]:45297 "HELO
	web52904.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752829AbXLJQkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 11:40:35 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=XLi95DLwmVQ0fUKAEKRY7RCD6gT0ZzXx56P9IhzhqzMF1IPjq9xQ7sl1PRbI1Ud9ZwqaoLhVMwrTKrRFnRpWYEvIEQSXUgarnu4UqcNlK94Es2MpaaEGWXNABO7cDTT7aJFFu1VeGYwpeKeha6FOeqb0OjYPqZ1ry7nQ3xYkCJo=;
X-YMail-OSG: ydDYQe8VM1kkDDVLvx_2LPkYNx43JuEAnnEI8WsZoE_l5wZ44WfonH1b0zG47px2EAtUqBw9yU8gZVgcaELB0j2KE9FmPj_RNKOhqtz3HWT1HuGEYR33L28aIwNwcw--
Date: Mon, 10 Dec 2007 16:40:34 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071209143237.1e608d9f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <224362.84373.qm@web52904.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Arjan van de Ven <arjan@infradead.org> wrote:
> > > I wonder if there's anything else in that area as well..

This is what /proc/iomem contains:

00000000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cbfff : Video ROM
000e4000-000effff : Adapter ROM
000f0000-000fffff : System ROM
00100000-17ffdbff : System RAM
  00100000-002adf17 : Kernel code
  002adf18-0034a263 : Kernel data
17ffdc00-17fffbff : ACPI Tables
17fffc00-17ffffff : ACPI Non-volatile Storage
e8000000-e8000fff : 0000:00:0d.0
  e8000000-e8000fff : ohci_hcd
e8001000-e8001fff : 0000:00:0d.1
  e8001000-e8001fff : ohci_hcd
e8002000-e8002fff : 0000:00:0e.0
e8003000-e80030ff : 0000:00:0d.2
  e8003000-e80030ff : ehci_hcd
e8100000-e81fffff : PCI Bus #01
  e8100000-e810ffff : 0000:01:00.0
    e8100000-e810ffff : radeonfb mmio
  e8120000-e813ffff : 0000:01:00.0
ec000000-efffffff : 0000:00:00.0
f0000000-f7ffffff : PCI Bus #01
  f0000000-f7ffffff : 0000:01:00.0
    f0000000-f7ffffff : radeonfb framebuffer
fffe7000-ffffffff : reserved

# lspci -tvvv
-[0000:00]-+-00.0  Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge
           +-01.0-[0000:01]----00.0  ATI Technologies Inc Radeon RV100 QY [Radeon 7000/VE]
           +-07.0  Intel Corporation 82371AB/EB/MB PIIX4 ISA
           +-07.1  Intel Corporation 82371AB/EB/MB PIIX4 IDE
           +-07.2  Intel Corporation 82371AB/EB/MB PIIX4 USB
           +-07.3  Intel Corporation 82371AB/EB/MB PIIX4 ACPI
           +-0d.0  NEC Corporation USB
           +-0d.1  NEC Corporation USB
           +-0d.2  NEC Corporation USB 2.0
           +-0e.0  Netgear MA301 802.11b Wireless PCI Adapter
           +-0f.0  Creative Labs SB Live! EMU10k1
           \-0f.1  Creative Labs SB Live! Game Port

The wireless PC card is device 0000:00:0e.0. And replacing ioremap() with ioremap_nocache() did
not help either.

This is the PCI entry for the host bridge:

00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (rev 03)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+
FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR-
<PERR-
        Latency: 64
        Region 0: Memory at ec000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [a0] AGP version 1.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3-
Rate=x1,x2
                Command: RQ=1 ArqSz=0 Cal=0 SBA+ AGP+ GART64- 64bit- FW- Rate=x2

One other thing I should mention is that this card works fine in an old P120/Zappa motherboard
machine running Linux 2.4.34.

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

