Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbYESObQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbYESObQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbYESObD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:31:03 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:56788 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757330AbYESObA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:31:00 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-kernel@vger.kernel.org
Subject: unable to access BIOS of Radeon X1650Pro cards (kernel bug?)
Date: Mon, 19 May 2008 16:30:53 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191630.54375.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I'm debugging a weird problem - it started as inability to use xorg radeon driver on X1650Pro cards. The machine (Asus P5K-V board with latest BIOS and 
64-bit, kernel 2.6.25) has 3 VGA cards - one Radeon 7000 PCI card (primary) and two Radeon X1650Pro PCI-E cards. The radeon driver is unable to initialize 
X1650Pro cards because it's unable to access the BIOS:

(II) RADEON(0): initializing int10
(II) Attempted to read BIOS 128KB from /sys/bus/pci/devices/0000:01:00.0/rom: got 0KB
Requesting insufficient memory window!: start: 0xfe700000 end: 0xfe7fffff size 0x10000000
(EE) Cannot find empty range to map base to
(EE) RADEON(0): Cannot read V_BIOS (3)

I tried to read the BIOS using sysfs and it really does not work:
# cd /sys/bus/pci/devices/0000:04:00.0
# cat rom
#

The card seems to be setup correctly:
# lspci -vv -s 04:00.0
04:00.0 VGA compatible controller: ATI Technologies Inc Radeon X1650 Pro (rev 9e)
        Subsystem: PC Partner Limited Device c880
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at d0000000 (64-bit, prefetchable) [disabled] [size=256M]
        Region 2: Memory at feae0000 (64-bit, non-prefetchable) [disabled] [size=64K]
        Region 4: I/O ports at d000 [disabled] [size=256]
        Expansion ROM at feac0000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 128 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <64ns, L1 <1us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000


Then I tried it manually and it does work:
# cat rom_enable.sh
#! /bin/sh
setpci -s 04:00.0 ROM_ADDRESS=feac0001
setpci -s 04:00.0 COMMAND=3

# ./rom_enable.sh

# cat biosdump.c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
int main(void) {
    int mem_fd;
    char *mem;
    FILE *f;
        /* open /dev/mem */
    if ((mem_fd = open("/dev/mem", O_RDWR) ) < 0) {
        printf("can't open /dev/mem \n");
        exit (-1);
    }

    /* mmap memory */
    mem = mmap(NULL, 131072, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_FIXED, mem_fd, 0xfeac0000);
    if ((long)mem < 0) {
        printf("mmap error \n");
        exit (-1);
    }
    f = fopen("dump.bin","w");
    fwrite(mem, 1, 131072, f);
    fclose(f);
    close(mem_fd);
}

# cc biosdump.c -o biosdump

# ./biosdump

# hexdump dump.bin
0000000 aa55 e97e 0277 0000 0000 0000 0000 0000
[...]


And now, sysfs magically works!
# cd /sys/bus/pci/devices/0000:04:00.0
# hexdump rom
0000000 aa55 e97e 0277 0000 0000 0000 0000 0000


Does anyone know what's going on here?

-- 
Ondrej Zary
