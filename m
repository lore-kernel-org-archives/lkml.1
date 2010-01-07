Return-Path: <linux-kernel-owner+w=401wt.eu-S932903Ab0AGDGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab0AGDGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 22:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932707Ab0AGDF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 22:05:58 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:40504 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab0AGDFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 22:05:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kHaIEHy7n4boi/7ecebglnFvPETryD2nnhOv1bv1gP2DaJvn+nHmBCt/k4Bw+PHVpp
         9wHmBO3x9gmLF1tzCuf/KAWh07Y+ZE8pAPyANOyK0XsaXyhIKKUxrbRBKNe6ZrRQAzdy
         JWxCjFDL/IgHT1LEE9RTRWwb0gjZZX8Dphy+w=
Message-ID: <4B454F8B.5040900@gmail.com>
Date: Wed, 06 Jan 2010 21:05:47 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Vivek Mahajan <vivek.mahajan@freescale.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       Peer Chen <pchen@nvidia.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: New MSI support in sata_sil24 still broken in 2.6.33-rc3
References: <64bb37e1001060137h597322e8s4305b7cc1c91527e@mail.gmail.com>	 <4B4531F9.3060108@gmail.com> <64bb37e1001061827i64ead7f9m3dbe1b7b707c79eb@mail.gmail.com>
In-Reply-To: <64bb37e1001061827i64ead7f9m3dbe1b7b707c79eb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2010 08:27 PM, Torsten Kaiser wrote:
> On Thu, Jan 7, 2010 at 1:59 AM, Robert Hancock<hancockrwd@gmail.com>  wrote:
>> On 01/06/2010 03:37 AM, Torsten Kaiser wrote:
>>>
>>> After activating the MSI support by adding sata_sil24.msi=1 to the
>>> kernel command line, the first write to a drive attached to the SiI
>>> 3132 controller results in the following errors:
>>>
>>> [  138.950074] ata2.00: exception Emask 0x0 SAct 0xf SErr 0x0 action 0x6
>>> frozen
>>> [  138.961023] ata2.00: failed command: WRITE FPDMA QUEUED
>>> [  138.970034] ata2.00: cmd 61/00:00:a5:95:4a/04:00:01:00:00/40 tag 0
>>> ncq 524288 out
>>> [  138.970037]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
>>> 0x4 (timeout)
>>
>> Looking at the code in sata_sil24 and the SiI3132 datasheet, there's a
>> control bit which doesn't seem to be handled in the driver, global control
>> register bit 30: "MSI Acknowledge (W). Writing a one to this bit
>> acknowledges a Message Signaled Interrupt and permits generation of another
>> MSI. This bit is cleared immediately after the acknowledgement is recognized
>> by the control logic, hence the bit will always be read as a zero. If all
>> interrupt conditions are removed subsequent to an MSI, it is not necessary
>> to assert this Acknowledge; another MSI will be generated when an interrupt
>> condition occurs."
>>
>> The way the interrupt handler for this driver works is that we check the
>> global IRQ status register, and then based on what ports indicated an
>> interrupt in that register, we check the individual port command completion
>> registers. The issue would seem to be that if a port got an interrupt
>> condition in between these two operations, we'd miss it, and the MSI logic
>> described above then wouldn't generate any more interrupts since we didn't
>> remove all interrupt conditions.
>>
>> Can you try this patch and see if it helps? (Might be whitespace damaged but
>> hopefully you can apply manually in that case.)
>
> Tried it, but writing still fails:
> [   53.467694] XFS mounting filesystem sdb2
> [  141.010058] ata2.00: exception Emask 0x0 SAct 0xf SErr 0x0 action 0x6 frozen
> [  141.020361] ata2.00: failed command: WRITE FPDMA QUEUED
> [  141.028718] ata2.00: cmd 61/00:00:5d:cd:48/04:00:01:00:00/40 tag 0
> ncq 524288 out
> [  141.028721]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [  141.049895] ata2.00: status: { DRDY }
> [  141.056715] ata2.00: failed command: WRITE FPDMA QUEUED
> [  141.065133] ata2.00: cmd 61/00:08:5d:c5:48/04:00:01:00:00/40 tag 1
> ncq 524288 out
> [  141.065135]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [  141.086492] ata2.00: status: { DRDY }
> [  141.093313] ata2.00: failed command: WRITE FPDMA QUEUED
> [  141.101679] ata2.00: cmd 61/00:10:5d:c9:48/04:00:01:00:00/40 tag 2
> ncq 524288 out
> [  141.101682]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [  141.122813] ata2.00: status: { DRDY }
> [  141.129522] ata2.00: failed command: WRITE FPDMA QUEUED
> [  141.137769] ata2.00: cmd 61/00:18:5d:d1:48/04:00:01:00:00/40 tag 3
> ncq 524288 out
> [  141.137771]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [  141.158660] ata2.00: status: { DRDY }
> [  141.165313] ata2: hard resetting link
> [  143.370049] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  148.370031] ata2.00: qc timeout (cmd 0xec)
> [  148.377198] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  148.386450] ata2.00: revalidation failed (errno=-5)
> [  148.394504] ata2: hard resetting link
> [  150.600064] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [  160.600038] ata2.00: qc timeout (cmd 0xec)
> [  160.607451] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  160.616913] ata2.00: revalidation failed (errno=-5)
> [  160.625181] ata2: limiting SATA link speed to 1.5 Gbps
> [  160.633746] ata2: hard resetting link
> [  162.830049] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
> ...
>
> Please note, that in my first report I also mentioned that I get the
> same behavior with sata_nv. If I use sata_nv.msi=1 writing to the
> drives attached to the MCP55 fail. The sata_nv problem is not new,
> that never worked for me, but I only retried it with 2.6.33-rc1.
> Other drivers can use MSI successfull (tg3, hda-intel, radeon).
>
>> diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
>> index 1370df6..d3d8dec 100644
>> --- a/drivers/ata/sata_sil24.c
>> +++ b/drivers/ata/sata_sil24.c
>> @@ -102,6 +102,7 @@ enum {
>>         HOST_CTRL_STOP          = (1<<  18), /* latched PCI STOP */
>>         HOST_CTRL_DEVSEL        = (1<<  19), /* latched PCI DEVSEL */
>>         HOST_CTRL_REQ64         = (1<<  20), /* latched PCI REQ64 */
>> +       HOST_CTRL_MSIACK        = (1<<  30), /* MSI acknowledge */
>>         HOST_CTRL_GLOBAL_RST    = (1<<  31), /* global reset */
>>
>>         /*
>> @@ -1168,6 +1169,7 @@ static irqreturn_t sil24_interrupt(int irq, void
>> *dev_instance)
>>                                        ": interrupt from disabled port %d\n",
>> i);
>>                 }
>>
>> +       writel(IRQ_STAT_4PORTS | HOST_CTRL_MSIACK, host_base + HOST_CTRL);
>>         spin_unlock(&host->lock);
>>   out:
>>         return IRQ_RETVAL(handled);
>>

Hmm, well presumably the problem isn't related to that then. I was 
looking at your lspci output though:

00:05.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a3) 
(prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Device 81f0
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 30
	Region 0: I/O ports at cc00 [size=8]
	Region 1: I/O ports at c880 [size=4]
	Region 2: I/O ports at c800 [size=8]
	Region 3: I/O ports at c480 [size=4]
	Region 4: I/O ports at c400 [size=16]
	Region 5: Memory at efafb000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [b0] MSI: Enable+ Count=1/4 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 4189
	Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+

The HT MSI Mapping capability is not enabled on the device. I'm thinking 
it should be, but I'm not sure. And it's also not enabled on the bus 
which has the Silicon Image controller:

04:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA 
Raid II Controller (rev 01)

on its subordinate bus:

00:0b.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a3) 
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: efe00000-efefffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: nVidia Corporation Device 0000
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0f00c  Data: 4149
	Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
		Mapping Address Base: 00000000fee00000

CCing some people that might have some idea about this..
