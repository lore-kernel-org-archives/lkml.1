Return-Path: <linux-kernel-owner+w=401wt.eu-S1161217AbXBUN1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161217AbXBUN1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161221AbXBUN1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:27:39 -0500
Received: from www.osadl.org ([213.239.205.134]:59103 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161217AbXBUN1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:27:38 -0500
Subject: Re: Linux 2.6.21-rc1
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 21 Feb 2007 14:32:42 +0100
Message-Id: <1172064762.25076.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 20:53 -0800, Linus Torvalds wrote:
> But there's a ton of architecture updates (arm, mips, powerpc, x86, you 
> name it), ACPI updates, and lots of driver work. And just a lot of 
> cleanups.
> 
> Have fun,

Yup. Fun starts in drivers/net/e1000

e1000 is not working anymore. ifup fails permanentely.
 ADDRCONF(NETDEV_UP): eth0: link is not ready
nothing else

bisect identifies:

d2ed16356ff4fb9de23fbc5e5d582ce580390106 is first bad commit
commit d2ed16356ff4fb9de23fbc5e5d582ce580390106
Author: Kok, Auke <auke-jan.h.kok@intel.com>
Date:   Fri Feb 16 14:39:26 2007 -0800

    e1000: fix shared interrupt warning message

    Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
    Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

Reverting this patch on top of -rc1 helps as well.

	tglx


lspci output:

04:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
        Subsystem: Intel Corporation Unknown device 30a5
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 218
        Region 0: Memory at 90100000 (32-bit, non-prefetchable) [size=128K]
        Region 2: I/O ports at 2000 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable+
                Address: 00000000fee0100c  Data: 414a
        Capabilities: [e0] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <512ns, L1 <64us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM unknown, Port 0
                Link: Latency L0s <128ns, L1 <64us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1


