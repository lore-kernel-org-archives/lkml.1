Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824Ab0AQVLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0AQVLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284Ab0AQVLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:11:36 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:33104 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab0AQVLf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:11:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FMXDgxWKiDkSOeOoHp9BecW8Hi+hiQqeQbPpnGOr4RWL2tHHmZlTuo3p46LAeR3UVC
         qpmxAkEL1X3838HrDAtJqH6swI8lYbFmFRsRqxiq2kS7okH34jIla2WhkKCxAbDBEx26
         WQMaE9x5F0c0JLzhsFVk9iT9gThHd3M/4brY8=
MIME-Version: 1.0
In-Reply-To: <4B536383.7090609@gmail.com>
References: <64bb37e0912250122n4e0e1842q88c0dad7e99ec6a7@mail.gmail.com>
	 <4B484829.6060405@kernel.org>
	 <64bb37e1001092033r1f0b4defw46c1a07101bb2d1b@mail.gmail.com>
	 <4B4A7BC7.6060106@kernel.org> <4B4A815A.60503@gmail.com>
	 <64bb37e1001161358r79ea2da0u88e9894fa5987ef1@mail.gmail.com>
	 <4B536383.7090609@gmail.com>
Date: Sun, 17 Jan 2010 22:11:33 +0100
Message-ID: <64bb37e1001171311u21c58fbj9a13b6aaeb7b2c3f@mail.gmail.com>
Subject: Re: MSI broken in libata?
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 17, 2010 at 8:22 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 01/16/2010 03:58 PM, Torsten Kaiser wrote:
>> Looking at my lspci output I noted the following:
>> For the PCIe-bridges:
>>        Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
>>                DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency
>> L0s<64ns, L1<1us
>>                        ExtTag- RBE+ FLReset-
>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>>                        MaxPayload 128 bytes, MaxReadReq 512 bytes
>> For the tg3 onboard network chips:
>>        Capabilities: [d0] Express (v1) Endpoint, MSI 00
>>                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s<4us,
>> L1 unlimited
>>                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
>> For the SiI chip:
>>        Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
>>                DevCap: MaxPayload 1024 bytes, PhantFunc 0, Latency
>> L0s<64ns, L1<1us
>>                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
>>                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
>> Unsupported-
>>                        RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>>                        MaxPayload 128 bytes, MaxReadReq 4096 bytes
>>
>> So the maximum payload for it is bigger then that of the nVidia bridge.
>> As I don't have knowlegde of the PCI specs, I guess DevCap is what a
>> device is physically capable and DevCtl is the value that the BIOS /
>> kernel hat programmed into it for actual use.
>> If my guess is correct, then the SiI should be correctly limited to
>> 128 bytes payload and that it should work.
>>
>> BUT: Page 47 of the SiI-PDF says for 'Device Status and Control' the
>> following:
>> Bit [14:12]: Max Read Request Size (R/W) – Allowable values are 000B
>> to 011B (128 to 1024 bytes).
>> Default is 010B (512 bytes).
>>
>> So a MaxReadReq value of 4096 as indicated by lspci for my system
>> would be out of bounds.
>>
>> Is is important? (Somehow it seems not: In the Not-MSI-case it is also
>> 4096 bytes, but the system works fine...)
>>
>>
>> Can I do anything else to help debug this?
>
> I don't think the MaxReadReq difference would be an issue - it's the max
> request size that device is allowed to generate, not the max it can accept.
> In any case, not sure how it would affect MSI since those requests would be
> a write, not a read, and would be tiny. You could always try changing it (I
> think setpci should be able to do it, though you might need to dig through
> specs to find out which bits those are).

As the Not-MSI-case is working with the 4096 setting this does not
look very promising as a fix.
The docs from SiI did say, that this field is R/W so setting it via
setpci might work.
But I will defer poking random bytes into PCI configuration space for
later... ;-)

> Unfortunately I don't have any great debug suggestions other than those.. My
> first suspect would still be some kind of HT-MSI mapping issue, but it's
> strange that only writes seem to be having problems..

The easiest way to trigger it, was booting into a static shell via
init=/bin/sash and doing:
dd if=/dev/zero of=/XFS-FS/on/a/disk/connected/to/sii3132 bs=1k count=1M

Reading seemed to work, as even with MSI enabled I was able to mount
the fs and start several programs (like lspci). But when I tried to
write the output to a temporary file, the errors started to appear.

I did a little bit more stress testing with iozone on a ro mounted fs
and that failed too.
So it is not only writing that fails.

test1: iozone -i 1:
[  143.010051] ata2.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen
[  143.010060] ata2.00: failed command: READ FPDMA QUEUED
[  143.010071] ata2.00: cmd 60/00:00:ad:71:d9/01:00:01:00:00/40 tag 0
ncq 131072 in
[  143.010073]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[  143.010079] ata2.00: status: { DRDY }
[  143.010083] ata2.00: failed command: READ FPDMA QUEUED
[  143.010092] ata2.00: cmd 60/00:08:ad:70:d9/01:00:01:00:00/40 tag 1
ncq 131072 in
[  143.010095]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  143.010099] ata2.00: status: { DRDY }
[  143.010108] ata2: hard resetting link

test2: dd if=file-on-sii-attached-diskl of=/dev/null bs=1k
[  112.950063] ata2.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen
[  112.950076] ata2.00: failed command: READ FPDMA QUEUED
[  112.950088] ata2.00: cmd 60/00:00:ad:71:d9/01:00:01:00:00/40 tag 0
ncq 131072 in
[  112.950091]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[  112.950096] ata2.00: status: { DRDY }
[  112.950101] ata2.00: failed command: READ FPDMA QUEUED
[  112.950110] ata2.00: cmd 60/00:08:ad:70:d9/01:00:01:00:00/40 tag 1
ncq 131072 in
[  112.950113]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  112.950117] ata2.00: status: { DRDY }
[  112.950127] ata2: hard resetting link
dd said, that it read 181 Mb before failing

test3: dd if=file-on-sii-attached-diskl of=/dev/null bs=1k iflag=direct
[  118.040055] ata2.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 frozen
[  118.040065] ata2.00: failed command: READ FPDMA QUEUED
[  118.040077] ata2.00: cmd 60/02:00:a5:13:d4/00:00:01:00:00/40 tag 0
ncq 1024 in
[  118.040079]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[  118.040085] ata2.00: status: { DRDY }
[  118.040095] ata2: hard resetting link
dd said, that it only copied 1.4 Mb this time

test4: setting the queue_depth to 1 and repeating test2
[  248.950055] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[  248.950066] ata2.00: failed command: READ DMA
[  248.950078] ata2.00: cmd c8/00:00:ad:79:d9/00:00:00:00:00/e1 tag 0
dma 131072 in
[  248.950080]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[  248.950085] ata2.00: status: { DRDY }
[  248.950095] ata2: hard resetting link
dd failed again at 183 Mb

All these tests where run with an unpatched 2.6.33-rc4.

What was different between -rc4 and my earlier tests was, that there
where additional error messages from do_IRQ.
sata_sil in MSI mode:
[    2.491103] sata_sil24 0000:04:00.0: version 1.1
[    2.491124] sata_sil24 0000:04:00.0: PCI INT A -> Link[LNEB] -> GSI
19 (level, low) -> IRQ 19
[    2.499751]   alloc irq_desc for 29 on node 0
[    2.499752]   alloc kstat_irqs on node 0
[    2.499765] sata_sil24 0000:04:00.0: irq 29 for MSI/MSI-X
[    2.499772] sata_sil24 0000:04:00.0: Using MSI
[    2.504265] sata_sil24 0000:04:00.0: setting latency timer to 64
[    2.504495] scsi0 : sata_sil24
[    2.507735] scsi1 : sata_sil24
[    2.510918] ata1: SATA max UDMA/100 host m128@0xefeffc00 port
0xefef8000 irq 29
[    2.518246] ata2: SATA max UDMA/100 host m128@0xefeffc00 port
0xefefa000 irq 29
[snip]
I mount the test fs with -o ro:
[   83.649367] XFS mounting filesystem sdb2
[   83.757942] Ending clean XFS mount for filesystem: sdb2
I start the iozone test:
[  112.382903] do_IRQ: 0.165 No irq handler for vector (irq -1)
[  112.382923] do_IRQ: 3.165 No irq handler for vector (irq -1)
[  112.382939] do_IRQ: 1.165 No irq handler for vector (irq -1)
[  112.382957] do_IRQ: 2.165 No irq handler for vector (irq -1)
[  143.010051] ata2.00: exception Emask 0x0 SAct 0x3 SErr 0x0 action 0x6 frozen
[  143.010060] ata2.00: failed command: READ FPDMA QUEUED
[  143.010071] ata2.00: cmd 60/00:00:ad:71:d9/01:00:01:00:00/40 tag 0
ncq 131072 in
[  143.010073]          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask
0x4 (timeout)
[  143.010079] ata2.00: status: { DRDY }
[  143.010083] ata2.00: failed command: READ FPDMA QUEUED
[  143.010092] ata2.00: cmd 60/00:08:ad:70:d9/01:00:01:00:00/40 tag 1
ncq 131072 in
[  143.010095]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[  143.010099] ata2.00: status: { DRDY }
[  143.010108] ata2: hard resetting link
[  145.210058] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  145.215060] do_IRQ: 1.165 No irq handler for vector (irq -1)
[  145.215074] do_IRQ: 0.165 No irq handler for vector (irq -1)
[  145.215088] do_IRQ: 2.165 No irq handler for vector (irq -1)
[  145.215097] do_IRQ: 3.165 No irq handler for vector (irq -1)
[  150.210036] ata2.00: qc timeout (cmd 0xec)
[  150.210046] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  150.210050] ata2.00: revalidation failed (errno=-5)
[  150.210058] ata2: hard resetting link
[  152.410050] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[  162.410031] ata2.00: qc timeout (cmd 0xec)
[  162.410039] ata2.00: failed to IDENTIFY (I/O error, err_mask=0x5)
[  162.410043] ata2.00: revalidation failed (errno=-5)
[  162.410048] ata2: limiting SATA link speed to 1.5 Gbps
[  162.410053] ata2: hard resetting link
[  164.610049] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  164.615197] ata2.00: failed to read native max address (err_mask=0x1)
[  164.615203] ata2.00: HPA support seems broken, skipping HPA handling
[  169.610037] ata2.00: qc timeout (cmd 0xef)
[  169.610045] ata2.00: failed to set xfermode (err_mask=0x4)
[  169.610050] ata2.00: disabled
[  169.610071] ata2.00: device reported invalid CHS sector 0
[  169.610091] ata2: hard resetting link
[  171.810055] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
[  171.810080] ata2: EH complete
[  171.810107] sd 1:0:0:0: [sdb] Unhandled error code
[  171.810112] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  171.810118] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 01 d9 70 ad 00 01 00 00
[  171.810132] end_request: I/O error, dev sdb, sector 31027373
[  171.810166] sd 1:0:0:0: [sdb] Unhandled error code
[  171.810170] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  171.810175] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 01 d9 71 ad 00 01 00 00
[  171.810188] end_request: I/O error, dev sdb, sector 31027629
[  171.810204] sd 1:0:0:0: [sdb] Unhandled error code
[  171.810209] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  171.810215] sd 1:0:0:0: [sdb] CDB: Read(10): 28 00 01 d9 70 ad 00 00 08 00
[  171.810229] end_request: I/O error, dev sdb, sector 31027373
[  171.810239] sd 1:0:0:0: [sdb] READ CAPACITY(16) failed
[  171.810245] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  171.810252] sd 1:0:0:0: [sdb] Sense not available.
[  171.810305] sd 1:0:0:0: [sdb] READ CAPACITY failed
[  171.810309] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  171.810314] sd 1:0:0:0: [sdb] Sense not available.
[  171.810387] sd 1:0:0:0: [sdb] Asking for cache data failed
[  171.810392] sd 1:0:0:0: [sdb] Assuming drive cache: write through
[  171.810405] sdb: detected capacity change from 640135028736 to 0
[  196.165461] sd 1:0:0:0: [sdb] READ CAPACITY(16) failed
[  196.165468] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  196.165475] sd 1:0:0:0: [sdb] Sense not available.
[  196.165531] sd 1:0:0:0: [sdb] READ CAPACITY failed
[  196.165535] sd 1:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[  196.165540] sd 1:0:0:0: [sdb] Sense not available.
[  196.165617] sd 1:0:0:0: [sdb] Asking for cache data failed
[  196.165622] sd 1:0:0:0: [sdb] Assuming drive cache: write through

I will look, if I can find out, where the do_IRQ error comes from and
why I didn't see it with -rc1 to -rc3.

Torsten
