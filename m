Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbYLSQaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbYLSQaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYLSQaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:30:07 -0500
Received: from gw.goop.org ([64.81.55.164]:41975 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbYLSQaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:30:04 -0500
Message-ID: <494BCC08.4070206@goop.org>
Date: Fri, 19 Dec 2008 08:30:00 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: Help interpreting AHCI failure messages
References: <4942D651.1050306@goop.org> <4943317C.8000807@shaw.ca> <49434EC9.4070408@goop.org> <49446DD0.3030600@gmail.com>
In-Reply-To: <49446DD0.3030600@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
>
> Jeremy Fitzhardinge wrote:
>   
>>>> xen_set_ioapic_routing: irq 31 gsi 18 vector 184 ioapic 0 pin 18
>>>> triggering 0 polarity 1ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level,
>>>> low) -> IRQ 31
>>>> xen: PCI device 0000:00:1f.2 pin 3 -> irq 31
>>>> ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x27 impl
>>>> SATA mode
>>>> ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pmp pio slum part
>>>> ems
>>>> scsi0 : ahci
>>>> scsi1 : ahci
>>>> scsi2 : ahci
>>>> scsi3 : ahci
>>>> scsi4 : ahci
>>>> scsi5 : ahci
>>>> ata1: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970100 irq 31
>>>> ata2: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970180 irq 31
>>>> ata3: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970200 irq 31
>>>> ata4: DUMMY
>>>> ata5: DUMMY
>>>> ata6: SATA max UDMA/133 abar m2048@0xff970000 port 0xff970380 irq 31
>>>> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>> ata1.00: qc timeout (cmd 0xec)
>>>> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>>>> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>> ata1.00: qc timeout (cmd 0xec)
>>>> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>>>> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>> ata1.00: qc timeout (cmd 0xec)
>>>> ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
>>>>         
>
> This strongly suggests IRQ delivery problem.
>
>   
>>>> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>> ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>>>>         
>
> But yes this contradicts that.
>
>   
>>>> I'm wondering if you can give me a clue as to what might be failing
>>>> on the AHCI side to give these symptoms, so I have some idea where I
>>>> need to fix things in my code?
>>>>         
>>> The timeouts would tend to suggest interrupts aren't getting through,
>>> you can check /proc/interrupts and see if that IRQ has gotten any
>>> interrupts at all..
>>>       
>> Hm.  I think there might be more to it than that.  When I boot the
>> system with the controller in IDE mode, it has the same GSI/irq and it
>> works OK.
>>
>> Furthermore, ata2 - which is sharing the same interrupt - seems to have
>> managed to read the DVD drive's information, so something must be
>> working.  But why is it failing for the disk?
>>     
>
> Can you try irqpoll on it?
>   

Here's a log of a run where everything works initially, but then it 
starts to fail (about half way into the log).  ATA_DEBUG is enabled, so 
its pretty verbose.

http://kraxel.fedorapeople.org/for-jeremy/xeni.log

Does anything stand out?

The part leading up to and including the failure is:

ata_sg_setup: 13 sg elements mapped
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 05 b7 ad ee 00 00 20
ata_sg_setup: 4 sg elements mapped
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 05 9a 31 be 00 00 40
ata_sg_setup: 8 sg elements mapped
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 05 9f 82 5e 00 00 08
ata_sg_setup: 1 sg elements mapped
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 05 b1 5a 26 00 00 08
ata_sg_setup: 1 sg elements mapped
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 05 b1 a8 c6 00 00 10
ata_sg_setup: 2 sg elements mapped
ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_error: ENTER
ata_port_flush_task: ENTER
ata2: ata_port_flush_task: EXIT
ata_eh_link_autopsy: ENTER
atapi_eh_request_sense: ATAPI request sense
ata_sg_setup: 1 sg elements mapped
ata_port_flush_task: ENTER
ata2: ata_port_flush_task: EXIT
ata_eh_link_autopsy: EXIT
ata_eh_recover: ENTER
ata_eh_revalidate_and_attach: ENTER
ata_eh_recover: EXIT, rc=0
ata_scsi_error: EXIT
ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_error: ENTER
ata_port_flush_task: ENTER
ata2: ata_port_flush_task: EXIT
ata_eh_link_autopsy: ENTER
atapi_eh_request_sense: ATAPI request sense
ata_sg_setup: 1 sg elements mapped
ata_port_flush_task: ENTER
ata2: ata_port_flush_task: EXIT
__ata_port_freeze: ata2 port frozen
ata2.00: qc timeout (cmd 0xa0)
ata_eh_link_autopsy: EXIT
ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: irq_stat 0x40000001
ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 51/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x5 (timeout)
ata2.00: status: { DRDY ERR }
ata_eh_recover: ENTER
__ata_port_freeze: ata2 port frozen
ata2: hard resetting link
ahci_hardreset: ENTER
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=-11
ata_dev_classify: found ATAPI device by sig
ahci_hardreset: EXIT, rc=-11, class=3
ahci_softreset: ENTER
ahci_do_softreset: ENTER
ata_dev_classify: found ATAPI device by sig
ahci_do_softreset: EXIT, class=3
ata_eh_thaw_port: ata2 port thawed
ata_std_postreset: ENTER
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata2.00: ata_dev_read_id: ENTER
ata_sg_setup: 1 sg elements mapped
ata_port_flush_task: ENTER
ata2: ata_port_flush_task: EXIT
__ata_port_freeze: ata2 port frozen
ata2.00: qc timeout (cmd 0xa1)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2.00: revalidation failed (errno=-5)
ata_eh_revalidate_and_attach: EXIT rc=-5
__ata_port_freeze: ata2 port frozen
ata2: hard resetting link
ahci_hardreset: ENTER
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=-11
ata_dev_classify: found ATAPI device by sig
ahci_hardreset: EXIT, rc=-11, class=3
ahci_softreset: ENTER
ahci_do_softreset: ENTER
ata_dev_classify: found ATAPI device by sig
ahci_do_softreset: EXIT, class=3
ata_eh_thaw_port: ata2 port thawed
ata_std_postreset: ENTER
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata2.00: ata_dev_read_id: ENTER
ata_sg_setup: 1 sg elements mapped
ata_port_flush_task: ENTER
ata2: ata_port_flush_task: EXIT
__ata_port_freeze: ata2 port frozen
ata2.00: qc timeout (cmd 0xa1)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2.00: revalidation failed (errno=-5)
ata_eh_revalidate_and_attach: EXIT rc=-5
__ata_port_freeze: ata2 port frozen
ata2: hard resetting link
ahci_hardreset: ENTER
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=-11
ata_dev_classify: found ATAPI device by sig
ahci_hardreset: EXIT, rc=-11, class=3
ahci_softreset: ENTER
ahci_do_softreset: ENTER
ata_dev_classify: found ATAPI device by sig
ahci_do_softreset: EXIT, class=3
ata_eh_thaw_port: ata2 port thawed
ata_std_postreset: ENTER
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata2.00: ata_dev_read_id: ENTER
ata_sg_setup: 1 sg elements mapped
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_timed_out: ENTER
ata_scsi_timed_out: EXIT, ret=0
ata_scsi_error: ENTER
ata_port_flush_task: ENTER
ata1: ata_port_flush_task: EXIT
__ata_port_freeze: ata1 port frozen
ata_eh_link_autopsy: ENTER
ata_eh_link_autopsy: EXIT
ata1.00: exception Emask 0x0 SAct 0xf7 SErr 0x0 action 0x6 frozen
ata1.00: cmd 60/20:00:ee:ad:b7/00:00:05:00:00/40 tag 0 ncq 16384 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1.00: cmd 60/08:08:86:8a:42/00:00:0f:00:00/40 tag 1 ncq 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1.00: cmd 60/08:10:26:5a:b1/00:00:05:00:00/40 tag 2 ncq 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1.00: cmd 60/08:20:26:db:7f/01:00:0f:00:00/40 tag 4 ncq 135168 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1.00: cmd 60/40:28:be:31:9a/00:00:05:00:00/40 tag 5 ncq 32768 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1.00: cmd 60/08:30:5e:82:9f/00:00:05:00:00/40 tag 6 ncq 4096 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata1.00: cmd 60/10:38:c6:a8:b1/00:00:05:00:00/40 tag 7 ncq 8192 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1.00: status: { DRDY }
ata_eh_recover: ENTER
__ata_port_freeze: ata1 port frozen
ata1: hard resetting link
ahci_hardreset: ENTER
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=-11
ata_dev_classify: found ATA device by sig
ahci_hardreset: EXIT, rc=-11, class=1
ahci_softreset: ENTER
ahci_do_softreset: ENTER
ata_dev_classify: found ATA device by sig
ahci_do_softreset: EXIT, class=1
ata_eh_thaw_port: ata1 port thawed
ata_std_postreset: ENTER
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata1.00: ata_dev_read_id: ENTER
ata_sg_setup: 1 sg elements mapped
ata_port_flush_task: ENTER
ata1: ata_port_flush_task: EXIT
__ata_port_freeze: ata1 port frozen
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
ata_eh_revalidate_and_attach: EXIT rc=-5
__ata_port_freeze: ata1 port frozen
ata1: hard resetting link
ahci_hardreset: ENTER
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=-11
ata_dev_classify: found ATA device by sig
ahci_hardreset: EXIT, rc=-11, class=1
ahci_softreset: ENTER
ahci_do_softreset: ENTER
ata_dev_classify: found ATA device by sig
ahci_do_softreset: EXIT, class=1
ata_eh_thaw_port: ata1 port thawed
ata_std_postreset: ENTER
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata1.00: ata_dev_read_id: ENTER
ata_sg_setup: 1 sg elements mapped
ata_port_flush_task: ENTER
ata1: ata_port_flush_task: EXIT
__ata_port_freeze: ata1 port frozen
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
ata_eh_revalidate_and_attach: EXIT rc=-5
__ata_port_freeze: ata1 port frozen
ata1: hard resetting link
ahci_hardreset: ENTER
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=-11
ata_dev_classify: found ATA device by sig
ahci_hardreset: EXIT, rc=-11, class=1
ahci_softreset: ENTER
ahci_do_softreset: ENTER
ata_dev_classify: found ATA device by sig
ahci_do_softreset: EXIT, class=1
ata_eh_thaw_port: ata1 port thawed
ata_std_postreset: ENTER
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata1.00: ata_dev_read_id: ENTER
ata_sg_setup: 1 sg elements mapped
ata_port_flush_task: ENTER
ata2: ata_port_flush_task: EXIT
__ata_port_freeze: ata2 port frozen
ata2.00: qc timeout (cmd 0xa1)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata2.00: revalidation failed (errno=-5)
ata_eh_revalidate_and_attach: EXIT rc=-5
ata2.00: disabled
ata_eh_revalidate_and_attach: ENTER
ata_eh_recover: EXIT, rc=0
ata_eh_link_autopsy: ENTER
ata_eh_link_autopsy: EXIT
ata_eh_recover: ENTER
__ata_port_freeze: ata2 port frozen
ata2: hard resetting link
ahci_hardreset: ENTER
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=-11
ata_dev_classify: found ATAPI device by sig
ahci_hardreset: EXIT, rc=-11, class=3
ahci_softreset: ENTER
ahci_do_softreset: ENTER
ata_dev_classify: found ATAPI device by sig
ahci_do_softreset: EXIT, class=3
ata_eh_thaw_port: ata2 port thawed
ata_std_postreset: ENTER
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata_eh_recover: EXIT, rc=0
ata2: EH complete
ata_scsi_error: EXIT
ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
ata_scsi_dump_cdb: CDB (2:0,0,0) 12 00 00 00 24 00 00 00 00
ata_scsi_dump_cdb: CDB (2:0,0,0) 1e 00 00 00 00 00 00 00 00
ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
ata_scsi_dump_cdb: CDB (2:0,0,0) 12 00 00 00 fe 00 00 00 00
ata_scsi_dump_cdb: CDB (2:0,0,0) 1e 00 00 00 00 00 00 00 00
ata_scsi_dump_cdb: CDB (2:0,0,0) 00 00 00 00 00 00 00 00 00
ata_scsi_dump_cdb: CDB (2:0,0,0) 12 01 00 00 fe 00 00 00 00
ata_scsi_dump_cdb: CDB (2:0,0,0) 1e 00 00 00 00 00 00 00 00
ata_port_flush_task: ENTER
ata1: ata_port_flush_task: EXIT
__ata_port_freeze: ata1 port frozen
ata1.00: qc timeout (cmd 0xec)
ata1.00: failed to IDENTIFY (I/O error, err_mask=0x4)
ata1.00: revalidation failed (errno=-5)
ata_eh_revalidate_and_attach: EXIT rc=-5
ata1.00: disabled
ata_eh_revalidate_and_attach: ENTER
ata_eh_recover: EXIT, rc=0
ata_eh_link_autopsy: ENTER
ata_eh_link_autopsy: EXIT
ata_eh_recover: ENTER
__ata_port_freeze: ata1 port frozen
ata1: hard resetting link
ahci_hardreset: ENTER
sata_link_hardreset: ENTER
sata_link_hardreset: EXIT, rc=-11
ata_dev_classify: found ATA device by sig
ahci_hardreset: EXIT, rc=-11, class=1
ahci_softreset: ENTER
ahci_do_softreset: ENTER
ata_dev_classify: found ATA device by sig
ahci_do_softreset: EXIT, class=1
ata_eh_thaw_port: ata1 port thawed
ata_std_postreset: ENTER
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata_std_postreset: EXIT
ata_eh_revalidate_and_attach: ENTER
ata_eh_recover: EXIT, rc=0
ata1: EH complete
ata_scsi_error: EXIT
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 05 b1 a8 c6 00 00 10
sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sda, sector 95529158
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 05 9f 82 5e 00 00 08
sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sda, sector 94339678
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 05 9a 31 be 00 00 40
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 0f 7f db 26 00 01 08
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 05 b1 5a 26 00 00 08
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 0f 42 8a 86 00 00 08
ata_scsi_dump_cdb: CDB (1:0,0,0) 28 00 05 b7 ad ee 00 00 20
sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sda, sector 93991358
sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sda, sector 260037414
sd 0:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
end_request: I/O error, dev sda, sector 95509030


Thanks,
    J

