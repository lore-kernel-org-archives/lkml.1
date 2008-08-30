Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYH3OeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYH3OeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYH3OeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:34:06 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:7244 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYH3Odw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mBlWA78HBvtaKNJ+yaVVphQL60TcPlhThms2TUbU8h7WTnSyvgtyy6hSXVVMLFobA1
         MpeRBCpTJtOaEWUBPo7GL4atXlN8so+d5/VdfmuS8LQ2O3tGNmmW+bHW2JlYDTpb560n
         SVQnYVc+jCrm/Gjrx2qTtg1e3Cl+ZDfp91SgU=
Message-ID: <48B95A47.8070408@gmail.com>
Date: Sat, 30 Aug 2008 17:33:43 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Problems with ALPM on devices part of raid array
References: <48B17C20.7020203@gmail.com> <48B926AE.7030108@kernel.org>
In-Reply-To: <48B926AE.7030108@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc-ing linux-kernel since I forgot to do so on my initial report]

On 2008-08-30 13:53, Tejun Heo wrote:
> Török Edwin wrote:
>   
>> I have an AHCI capable chipset now (ICH10), so I tried ALPM[*], by
>> echo-ing min_power to:
>> ./class/scsi_host/host0/link_power_management_policy
>> ./class/scsi_host/host5/link_power_management_policy
>>
>> The 6 SATA2 drives have 3 partitions each, partition 1 is RAID1,
>> partition 3 is RAID10.
>>
>> This soon caused me troubles, as the kernel gave I/O error messages, and
>> unmounted my filesystems running
>> on /dev/md4 (raid10 array). Unfortunately I don't have those messages
>> saved to my logs, because my /var filesystem got automatically unmounted.
>> I had no choice but to reboot, and then md kicked 4 drives out of the
>> md4 array (6 total drives), and then refused
>> to assemble (too few drives). The RAID1 array (md3) got reassembled, and
>> resynced successfully.
>> I had to force the assembly of /dev/md4 [and encountered a mdadm bug
>> while doing so: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=496334]
>>
>> I think ALPM should refuse to set link pm if the device is part of a
>> raid array, or the md driver should be aware
>> of ALPM, and wait a little longer for the device to come back online.
>> Mentioning this problem somewhere in the sources/docs would be nice.
>>     
>
> Being part of RAID is very unlikely to have anything to do with the
> failures.  Can you post kernel, boot log, error messages and the
> output of hdparm -I on array members?

Hi Tejun,

I have found a (safe) way to reproduce this problem, without loosing data.
What I found is that setting the link_power_management_policy to 
min_power is completely harmless, and works,
however setting it *back* to max_performance causes an ATA link hard 
reset, and drives kicked out of RAID array.

For my RAID1 array this is not a big problem, since its resynced fast, 
and I can hot-remove/add drives,
however with RAID10 (last time, I didn't try again) I needed to use 
mdadm --assemble --force, and a full resync
(which takes hours).

I am using this Debian kernel: Linux debian 2.6.26-1-amd64 #1 SMP Thu 
Aug 28 11:13:42 UTC 2008 x86_64 GNU/Linux
You can find .config at end of this mail

The steps are these:
- unmount /var, /usr/, /home, take my raid10 array offline
- now I only have /dev/md3 which is a RAID1 array of 6 drives mounted on /
1. set all my drives to min_power:
# for i in /sys/class/scsi_host/*/link_power_management_policy; echo 
min_power >$i; done

2. check that it worked, do a sync:
# sync

3. now set one of the drives back to max_performance (the drive will get 
an ATA hard reset,
if I change the link pm policy for all drives, then all drives are 
affected, you can see in the dmesg at the end of this mail, I tried both)

# echo max_performance 
 >/sys/class/scsi_host/host0/link_power_management_policy

4. sync again, this time ATA reset messages appear on the console
# sync

[ 2304.355772] ata6.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 2304.355772] ata4.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 2304.355772] ata4.00: irq_stat 0x00400001, PHY RDY changed
[ 2304.355772] ata4: SError: { PHYRdyChg CommWake }
[ 2304.355772] ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 2304.355772]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 2304.355772] ata4.00: status: { DRDY }
[ 2304.355772] ata4: hard resetting link
[ 2304.896743] ata5.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 2304.896743] ata5.00: irq_stat 0x00400001, PHY RDY changed
[ 2304.896743] ata5: SError: { PHYRdyChg CommWake }
[ 2304.896743] ata5.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 2304.896743]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 2304.896743] ata5.00: status: { DRDY }
[ 2304.896743] ata5: hard resetting link
[ 2304.896743] ata6.00: irq_stat 0x00400001, PHY RDY changed
[ 2304.896789] ata6: SError: { PHYRdyChg CommWake }
[ 2304.896835] ata6.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 2304.896836]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 2304.896939] ata6.00: status: { DRDY }
[ 2304.896984] ata6: hard resetting link
[ 2304.897035] ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 2304.897093] ata3.00: irq_stat 0x00400001, PHY RDY changed
[ 2304.897138] ata3: SError: { PHYRdyChg CommWake }
[ 2304.897184] ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 2304.897185]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 2304.897288] ata3.00: status: { DRDY }
[ 2304.897332] ata3: hard resetting link
[ 2304.897381] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 2304.897439] ata2.00: irq_stat 0x00400001, PHY RDY changed
[ 2304.897485] ata2: SError: { PHYRdyChg CommWake }
[ 2304.897530] ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 2304.897531]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 2304.897634] ata2.00: status: { DRDY }
[ 2304.897679] ata2: hard resetting link
[ 2305.832653] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2305.832656] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2305.837489] ata4.00: configured for UDMA/133
[ 2305.837489] ata4: EH complete
[ 2305.837489] ata5.00: configured for UDMA/133
[ 2305.837489] sd 3:0:0:0: [sdd] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2305.837489] sd 3:0:0:0: [sdd] Write Protect is off
[ 2305.837489] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[ 2305.837489] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2305.837489] ata5: EH complete
[ 2305.837489] sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2305.837489] sd 4:0:0:0: [sde] Write Protect is off
[ 2305.837489] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[ 2305.837489] sd 4:0:0:0: [sde] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2305.841497] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2305.841556] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2305.841615] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2305.841615] ata3.00: configured for UDMA/133
[ 2305.841615] ata3: EH complete
[ 2305.841615] ata2.00: configured for UDMA/133
[ 2305.841615] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2305.841615] sd 2:0:0:0: [sdc] Write Protect is off
[ 2305.841615] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 2305.841615] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2305.845240] ata6.00: configured for UDMA/133
[ 2305.845240] ata6: EH complete
[ 2305.841615] ata2: EH complete
[ 2305.841615] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2305.841615] sd 1:0:0:0: [sdb] Write Protect is off
[ 2305.841615] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[ 2305.841615] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2305.841694] sd 5:0:0:0: [sdf] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2305.845240] sd 5:0:0:0: [sdf] Write Protect is off
[ 2305.845284] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[ 2305.845299] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2305.852738] end_request: I/O error, dev sdd, sector 19534911
[ 2305.852738] md: super_written gets error=-5, uptodate=0
[ 2305.852738] raid1: Disk failure on sdd1, disabling device.
[ 2305.852738] raid1: Operation continuing on 5 devices.
[ 2305.852738] end_request: I/O error, dev sdf, sector 19534911
[ 2305.852738] md: super_written gets error=-5, uptodate=0
[ 2305.852738] raid1: Disk failure on sdf1, disabling device.
[ 2305.852738] raid1: Operation continuing on 4 devices.
[ 2305.853240] end_request: I/O error, dev sdc, sector 19534911
[ 2305.853240] md: super_written gets error=-5, uptodate=0
[ 2305.853240] raid1: Disk failure on sdc1, disabling device.
[ 2305.853240] raid1: Operation continuing on 3 devices.
[ 2305.841615] end_request: I/O error, dev sde, sector 19534911
[ 2305.841615] md: super_written gets error=-5, uptodate=0
[ 2305.841615] raid1: Disk failure on sde1, disabling device.
[ 2305.841615] raid1: Operation continuing on 2 devices.
[ 2305.857144] end_request: I/O error, dev sdb, sector 19534911
[ 2305.857144] md: super_written gets error=-5, uptodate=0
[ 2305.857144] raid1: Disk failure on sdb1, disabling device.
[ 2305.857144] raid1: Operation continuing on 1 devices.
[ 2305.872898] RAID1 conf printout:
[ 2305.872898]  --- wd:1 rd:6
[ 2305.872898]  disk 0, wo:0, o:1, dev:sda1
[ 2305.872898]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.872898]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.872898]  disk 3, wo:1, o:0, dev:sde1
[ 2305.872898]  disk 4, wo:1, o:0, dev:sdc1
[ 2305.872898]  disk 5, wo:1, o:0, dev:sdf1
[ 2305.881242] RAID1 conf printout:
[ 2305.881286]  --- wd:1 rd:6
[ 2305.881330]  disk 0, wo:0, o:1, dev:sda1
[ 2305.881379]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.881423]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.881466]  disk 3, wo:1, o:0, dev:sde1
[ 2305.881510]  disk 4, wo:1, o:0, dev:sdc1
[ 2305.881557] RAID1 conf printout:
[ 2305.881599]  --- wd:1 rd:6
[ 2305.881641]  disk 0, wo:0, o:1, dev:sda1
[ 2305.881684]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.881728]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.881772]  disk 3, wo:1, o:0, dev:sde1
[ 2305.881815]  disk 4, wo:1, o:0, dev:sdc1
[ 2305.893241] RAID1 conf printout:
[ 2305.893285]  --- wd:1 rd:6
[ 2305.893328]  disk 0, wo:0, o:1, dev:sda1
[ 2305.893376]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.893418]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.893462]  disk 3, wo:1, o:0, dev:sde1
[ 2305.893506] RAID1 conf printout:
[ 2305.893548]  --- wd:1 rd:6
[ 2305.893589]  disk 0, wo:0, o:1, dev:sda1
[ 2305.893633]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.893676]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.893719]  disk 3, wo:1, o:0, dev:sde1
[ 2305.905242] RAID1 conf printout:
[ 2305.905285]  --- wd:1 rd:6
[ 2305.905329]  disk 0, wo:0, o:1, dev:sda1
[ 2305.905376]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.905418]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.905463] RAID1 conf printout:
[ 2305.905505]  --- wd:1 rd:6
[ 2305.905546]  disk 0, wo:0, o:1, dev:sda1
[ 2305.905590]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.905633]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.917241] RAID1 conf printout:
[ 2305.917284]  --- wd:1 rd:6
[ 2305.917328]  disk 0, wo:0, o:1, dev:sda1
[ 2305.917374]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.917417] RAID1 conf printout:
[ 2305.917460]  --- wd:1 rd:6
[ 2305.917501]  disk 0, wo:0, o:1, dev:sda1
[ 2305.917544]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.929241] RAID1 conf printout:
[ 2305.929284]  --- wd:1 rd:6
[ 2305.929328]  disk 0, wo:0, o:1, dev:sda1

5. The drives are working, they just got kicked out of the array, so 
lets add them back
mdadm --remove /dev/md3 /dev/sdc1 /dev/sdf1 /dev/sde1 /dev/sdd1 /dev/sdb1
mdadm --add /dev/md3 /dev/sdc1 /dev/sdf1 /dev/sde1 /dev/sdd1 /dev/sdb1
dmesg output for this is:
[ 2505.989204] md: md3 still in use.
[ 2521.148651] md: unbind<sdc1>
[ 2521.148651] md: export_rdev(sdc1)
[ 2537.045017] md: unbind<sdf1>
[ 2537.045017] md: export_rdev(sdf1)
[ 2537.070370] md: unbind<sde1>
[ 2537.070370] md: export_rdev(sde1)
[ 2537.812473] md: unbind<sdd1>
[ 2537.812524] md: export_rdev(sdd1)
[ 2537.822335] md: unbind<sdb1>
[ 2537.822335] md: export_rdev(sdb1)
[ 2565.680914] md: bind<sdf1>
[ 2565.722761] RAID1 conf printout:
[ 2565.722761]  --- wd:1 rd:6
[ 2565.722761]  disk 0, wo:0, o:1, dev:sda1
[ 2565.722761]  disk 1, wo:1, o:1, dev:sdf1
[ 2565.724253] md: recovery of RAID array md3
[ 2565.724253] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 2565.724253] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[ 2565.724253] md: using 128k window, over a total of 9767424 blocks.
[ 2565.876674] md: bind<sde1>
[ 2565.995415] md: bind<sdd1>
[ 2566.057634] md: bind<sdb1>
[ 2566.101549] md: bind<sdc1>
[ 2782.657615] md: md3: recovery done.
[ 2783.368035] RAID1 conf printout:
[ 2783.368035]  --- wd:2 rd:6
[ 2783.368035]  disk 0, wo:0, o:1, dev:sda1
[ 2783.368035]  disk 1, wo:0, o:1, dev:sdf1
[ 2783.555376] RAID1 conf printout:
[ 2783.555423]  --- wd:2 rd:6
[ 2783.555467]  disk 0, wo:0, o:1, dev:sda1
[ 2783.555533]  disk 1, wo:0, o:1, dev:sdf1
[ 2783.555576]  disk 2, wo:1, o:1, dev:sdc1
[ 2783.555625] RAID1 conf printout:
[ 2783.555667]  --- wd:2 rd:6
[ 2783.555708]  disk 0, wo:0, o:1, dev:sda1
[ 2783.555751]  disk 1, wo:0, o:1, dev:sdf1
[ 2783.555794]  disk 2, wo:1, o:1, dev:sdc1
[ 2783.555837]  disk 3, wo:1, o:1, dev:sdb1
[ 2783.555882] RAID1 conf printout:
[ 2783.555924]  --- wd:2 rd:6
[ 2783.555966]  disk 0, wo:0, o:1, dev:sda1
[ 2783.559532]  disk 1, wo:0, o:1, dev:sdf1
[ 2783.559532]  disk 2, wo:1, o:1, dev:sdc1
[ 2783.559532]  disk 3, wo:1, o:1, dev:sdb1
[ 2783.559532]  disk 4, wo:1, o:1, dev:sdd1
[ 2783.559532] RAID1 conf printout:
[ 2783.559532]  --- wd:2 rd:6
[ 2783.559532]  disk 0, wo:0, o:1, dev:sda1
[ 2783.559532]  disk 1, wo:0, o:1, dev:sdf1
[ 2783.559532]  disk 2, wo:1, o:1, dev:sdc1
[ 2783.559532]  disk 3, wo:1, o:1, dev:sdb1
[ 2783.559532]  disk 4, wo:1, o:1, dev:sdd1
[ 2783.559532]  disk 5, wo:1, o:1, dev:sde1
[ 2783.559532] md: recovery of RAID array md3
[ 2783.559532] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 2783.559532] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[ 2783.559532] md: using 128k window, over a total of 9767424 blocks.

If I repeat  steps 1-4 again, I get ATA errors again, and drives kicked out.

Best regards,
--Edwin

The output of hdparm -I /dev/sd[a-z] is:

/dev/sda:

ATA device, with non-removable media
    Model Number:       WDC WD7501AALS-00J7B0                  
    Serial Number:      WD-WMATV0086271
    Firmware Revision:  05.00K05
    Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev 2.5
Standards:
    Supported: 8 7 6 5
    Likely used: 8
Configuration:
    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    --
    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors: 1465149168
    device size with M = 1024*1024:      715404 MBytes
    device size with M = 1000*1000:      750156 MBytes (750 GB)
Capabilities:
    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, with device specific minimum
    R/W multiple sector transfer: Max = 16    Current = 0
    Recommended acoustic management value: 128, current value: 254
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
         Cycle time: min=120ns recommended=120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    NOP cmd
       *    DOWNLOAD_MICROCODE
            Power-Up In Standby feature set
       *    SET_FEATURES required to spinup after power up
            SET_MAX security extension
            Automatic Acoustic Management feature set
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
       *    General Purpose Logging feature set
       *    64-bit World wide name
       *    {READ,WRITE}_DMA_EXT_GPL commands
       *    Segmented DOWNLOAD_MICROCODE
       *    SATA-I signaling speed (1.5Gb/s)
       *    SATA-II signaling speed (3.0Gb/s)
       *    Native Command Queueing (NCQ)
       *    Host-initiated interface power management
       *    Phy event counters
            DMA Setup Auto-Activate optimization
       *    Software settings preservation
       *    SMART Command Transport (SCT) feature set
       *    SCT Long Sector Access (AC1)
       *    SCT LBA Segment Access (AC2)
       *    SCT Error Recovery Control (AC3)
       *    SCT Features Control (AC4)
       *    SCT Data Tables (AC5)
            unknown 206[12] (vendor specific)
            unknown 206[13] (vendor specific)
Security:
    Master password revision code = 65534
        supported
    not    enabled
    not    locked
    not    frozen
    not    expired: security count
        supported: enhanced erase
    162min for SECURITY ERASE UNIT. 162min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee0b6d6c1
    NAA        : 5
    IEEE OUI    : 14ee
    Unique ID    : 0b6d6c1
Checksum: correct

/dev/sdb:

ATA device, with non-removable media
    Model Number:       WDC WD7501AALS-00J7B0                  
    Serial Number:      WD-WMATV0083946
    Firmware Revision:  05.00K05
    Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev 2.5
Standards:
    Supported: 8 7 6 5
    Likely used: 8
Configuration:
    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    --
    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors: 1465149168
    device size with M = 1024*1024:      715404 MBytes
    device size with M = 1000*1000:      750156 MBytes (750 GB)
Capabilities:
    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, with device specific minimum
    R/W multiple sector transfer: Max = 16    Current = 0
    Recommended acoustic management value: 128, current value: 254
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
         Cycle time: min=120ns recommended=120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    NOP cmd
       *    DOWNLOAD_MICROCODE
            Power-Up In Standby feature set
       *    SET_FEATURES required to spinup after power up
            SET_MAX security extension
            Automatic Acoustic Management feature set
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
       *    General Purpose Logging feature set
       *    64-bit World wide name
       *    {READ,WRITE}_DMA_EXT_GPL commands
       *    Segmented DOWNLOAD_MICROCODE
       *    SATA-I signaling speed (1.5Gb/s)
       *    SATA-II signaling speed (3.0Gb/s)
       *    Native Command Queueing (NCQ)
       *    Host-initiated interface power management
       *    Phy event counters
            DMA Setup Auto-Activate optimization
       *    Software settings preservation
       *    SMART Command Transport (SCT) feature set
       *    SCT Long Sector Access (AC1)
       *    SCT LBA Segment Access (AC2)
       *    SCT Error Recovery Control (AC3)
       *    SCT Features Control (AC4)
       *    SCT Data Tables (AC5)
            unknown 206[12] (vendor specific)
            unknown 206[13] (vendor specific)
Security:
    Master password revision code = 65534
        supported
    not    enabled
    not    locked
    not    frozen
    not    expired: security count
        supported: enhanced erase
    162min for SECURITY ERASE UNIT. 162min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee0b48ba2
    NAA        : 5
    IEEE OUI    : 14ee
    Unique ID    : 0b48ba2
Checksum: correct

/dev/sdc:

ATA device, with non-removable media
    Model Number:       WDC WD7501AALS-00J7B0                  
    Serial Number:      WD-WMATV0156388
    Firmware Revision:  05.00K05
    Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev 2.5
Standards:
    Supported: 8 7 6 5
    Likely used: 8
Configuration:
    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    --
    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors: 1465149168
    device size with M = 1024*1024:      715404 MBytes
    device size with M = 1000*1000:      750156 MBytes (750 GB)
Capabilities:
    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, with device specific minimum
    R/W multiple sector transfer: Max = 16    Current = 0
    Recommended acoustic management value: 128, current value: 254
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
         Cycle time: min=120ns recommended=120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    NOP cmd
       *    DOWNLOAD_MICROCODE
            Power-Up In Standby feature set
       *    SET_FEATURES required to spinup after power up
            SET_MAX security extension
            Automatic Acoustic Management feature set
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
       *    General Purpose Logging feature set
       *    64-bit World wide name
       *    {READ,WRITE}_DMA_EXT_GPL commands
       *    Segmented DOWNLOAD_MICROCODE
       *    SATA-I signaling speed (1.5Gb/s)
       *    SATA-II signaling speed (3.0Gb/s)
       *    Native Command Queueing (NCQ)
       *    Host-initiated interface power management
       *    Phy event counters
            DMA Setup Auto-Activate optimization
       *    Software settings preservation
       *    SMART Command Transport (SCT) feature set
       *    SCT Long Sector Access (AC1)
       *    SCT LBA Segment Access (AC2)
       *    SCT Error Recovery Control (AC3)
       *    SCT Features Control (AC4)
       *    SCT Data Tables (AC5)
            unknown 206[12] (vendor specific)
            unknown 206[13] (vendor specific)
Security:
    Master password revision code = 65534
        supported
    not    enabled
    not    locked
    not    frozen
    not    expired: security count
        supported: enhanced erase
    162min for SECURITY ERASE UNIT. 162min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee0560c33e7
    NAA        : 5
    IEEE OUI    : 14ee
    Unique ID    : 0560c33e7
Checksum: correct

/dev/sdd:

ATA device, with non-removable media
    Model Number:       WDC WD7501AALS-00J7B0                  
    Serial Number:      WD-WMATV0005417
    Firmware Revision:  05.00K05
    Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev 2.5
Standards:
    Supported: 8 7 6 5
    Likely used: 8
Configuration:
    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    --
    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors: 1465149168
    device size with M = 1024*1024:      715404 MBytes
    device size with M = 1000*1000:      750156 MBytes (750 GB)
Capabilities:
    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, with device specific minimum
    R/W multiple sector transfer: Max = 16    Current = 0
    Recommended acoustic management value: 128, current value: 254
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
         Cycle time: min=120ns recommended=120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    NOP cmd
       *    DOWNLOAD_MICROCODE
            Power-Up In Standby feature set
       *    SET_FEATURES required to spinup after power up
            SET_MAX security extension
            Automatic Acoustic Management feature set
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
       *    General Purpose Logging feature set
       *    64-bit World wide name
       *    {READ,WRITE}_DMA_EXT_GPL commands
       *    Segmented DOWNLOAD_MICROCODE
       *    SATA-I signaling speed (1.5Gb/s)
       *    SATA-II signaling speed (3.0Gb/s)
       *    Native Command Queueing (NCQ)
       *    Host-initiated interface power management
       *    Phy event counters
            DMA Setup Auto-Activate optimization
       *    Software settings preservation
       *    SMART Command Transport (SCT) feature set
       *    SCT Long Sector Access (AC1)
       *    SCT LBA Segment Access (AC2)
       *    SCT Error Recovery Control (AC3)
       *    SCT Features Control (AC4)
       *    SCT Data Tables (AC5)
            unknown 206[12] (vendor specific)
            unknown 206[13] (vendor specific)
Security:
    Master password revision code = 65534
        supported
    not    enabled
    not    locked
    not    frozen
    not    expired: security count
        supported: enhanced erase
    194min for SECURITY ERASE UNIT. 194min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee0b7229d
    NAA        : 5
    IEEE OUI    : 14ee
    Unique ID    : 0b7229d
Checksum: correct

/dev/sde:

ATA device, with non-removable media
    Model Number:       WDC WD7501AALS-00J7B0                  
    Serial Number:      WD-WMATV0053076
    Firmware Revision:  05.00K05
    Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev 2.5
Standards:
    Supported: 8 7 6 5
    Likely used: 8
Configuration:
    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    --
    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors: 1465149168
    device size with M = 1024*1024:      715404 MBytes
    device size with M = 1000*1000:      750156 MBytes (750 GB)
Capabilities:
    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, with device specific minimum
    R/W multiple sector transfer: Max = 16    Current = 0
    Recommended acoustic management value: 128, current value: 254
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
         Cycle time: min=120ns recommended=120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    NOP cmd
       *    DOWNLOAD_MICROCODE
            Power-Up In Standby feature set
       *    SET_FEATURES required to spinup after power up
            SET_MAX security extension
            Automatic Acoustic Management feature set
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
       *    General Purpose Logging feature set
       *    64-bit World wide name
       *    {READ,WRITE}_DMA_EXT_GPL commands
       *    Segmented DOWNLOAD_MICROCODE
       *    SATA-I signaling speed (1.5Gb/s)
       *    SATA-II signaling speed (3.0Gb/s)
       *    Native Command Queueing (NCQ)
       *    Host-initiated interface power management
       *    Phy event counters
            DMA Setup Auto-Activate optimization
       *    Software settings preservation
       *    SMART Command Transport (SCT) feature set
       *    SCT Long Sector Access (AC1)
       *    SCT LBA Segment Access (AC2)
       *    SCT Error Recovery Control (AC3)
       *    SCT Features Control (AC4)
       *    SCT Data Tables (AC5)
            unknown 206[12] (vendor specific)
            unknown 206[13] (vendor specific)
Security:
    Master password revision code = 65534
        supported
    not    enabled
    not    locked
    not    frozen
    not    expired: security count
        supported: enhanced erase
    162min for SECURITY ERASE UNIT. 162min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee0b6d521
    NAA        : 5
    IEEE OUI    : 14ee
    Unique ID    : 0b6d521
Checksum: correct

/dev/sdf:

ATA device, with non-removable media
    Model Number:       WDC WD7501AALS-00J7B0                  
    Serial Number:      WD-WMATV0038929
    Firmware Revision:  05.00K05
    Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev 2.5
Standards:
    Supported: 8 7 6 5
    Likely used: 8
Configuration:
    Logical        max    current
    cylinders    16383    16383
    heads        16    16
    sectors/track    63    63
    --
    CHS current addressable sectors:   16514064
    LBA    user addressable sectors:  268435455
    LBA48  user addressable sectors: 1465149168
    device size with M = 1024*1024:      715404 MBytes
    device size with M = 1000*1000:      750156 MBytes (750 GB)
Capabilities:
    LBA, IORDY(can be disabled)
    Queue depth: 32
    Standby timer values: spec'd by Standard, with device specific minimum
    R/W multiple sector transfer: Max = 16    Current = 0
    Recommended acoustic management value: 128, current value: 254
    DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
         Cycle time: min=120ns recommended=120ns
    PIO: pio0 pio1 pio2 pio3 pio4
         Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
    Enabled    Supported:
       *    SMART feature set
            Security Mode feature set
       *    Power Management feature set
       *    Write cache
       *    Look-ahead
       *    Host Protected Area feature set
       *    WRITE_BUFFER command
       *    READ_BUFFER command
       *    NOP cmd
       *    DOWNLOAD_MICROCODE
            Power-Up In Standby feature set
       *    SET_FEATURES required to spinup after power up
            SET_MAX security extension
            Automatic Acoustic Management feature set
       *    48-bit Address feature set
       *    Device Configuration Overlay feature set
       *    Mandatory FLUSH_CACHE
       *    FLUSH_CACHE_EXT
       *    SMART error logging
       *    SMART self-test
       *    General Purpose Logging feature set
       *    64-bit World wide name
       *    {READ,WRITE}_DMA_EXT_GPL commands
       *    Segmented DOWNLOAD_MICROCODE
       *    SATA-I signaling speed (1.5Gb/s)
       *    SATA-II signaling speed (3.0Gb/s)
       *    Native Command Queueing (NCQ)
       *    Host-initiated interface power management
       *    Phy event counters
            DMA Setup Auto-Activate optimization
       *    Software settings preservation
       *    SMART Command Transport (SCT) feature set
       *    SCT Long Sector Access (AC1)
       *    SCT LBA Segment Access (AC2)
       *    SCT Error Recovery Control (AC3)
       *    SCT Features Control (AC4)
       *    SCT Data Tables (AC5)
            unknown 206[12] (vendor specific)
            unknown 206[13] (vendor specific)
Security:
    Master password revision code = 65534
        supported
    not    enabled
    not    locked
    not    frozen
    not    expired: security count
        supported: enhanced erase
    162min for SECURITY ERASE UNIT. 162min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee0ab55b53
    NAA        : 5
    IEEE OUI    : 14ee
    Unique ID    : 0ab550b53
Checksum: correct

The output of dmesg:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.26-1-amd64 (Debian 2.6.26-4) 
(waldi@debian.org) (gcc version 4.1.3 20080623 (prerelease) (Debian 
4.1.2-23)) #1 SMP Thu Aug 28 11:13:42 UTC 2008
[    0.000000] Command line: root=/dev/md3 ro single
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000cfee0000 - 00000000cfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cfee3000 - 00000000cfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cfef0000 - 00000000cff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 851680) 1 entries of 
3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries 
of 3200 used
[    0.000000] max_pfn_mapped = 1245184
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000F7050, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT CFEE3040, 0038 (r1 GBT    GBTUACPI 42302E31 
GBTU  1010101)
[    0.000000] ACPI: FACP CFEE30C0, 0074 (r1 GBT    GBTUACPI 42302E31 
GBTU  1010101)
[    0.000000] ACPI: DSDT CFEE3180, 4C26 (r1 GBT    GBTUACPI     1000 
MSFT  100000C)
[    0.000000] ACPI: FACS CFEE0000, 0040
[    0.000000] ACPI: HPET CFEE7F00, 0038 (r1 GBT    GBTUACPI 42302E31 
GBTU       98)
[    0.000000] ACPI: MCFG CFEE7F80, 003C (r1 GBT    GBTUACPI 42302E31 
GBTU  1010101)
[    0.000000] ACPI: APIC CFEE7E00, 0084 (r1 GBT    GBTUACPI 42302E31 
GBTU  1010101)
[    0.000000] ACPI: SSDT CFEE88E0, 03AB (r1  PmRef    CpuPm     3000 
INTL 20040311)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000130000000
[    0.000000] Entering add_active_range(0, 0, 158) 0 entries of 3200 used
[    0.000000] Entering add_active_range(0, 256, 851680) 1 entries of 
3200 used
[    0.000000] Entering add_active_range(0, 1048576, 1245184) 2 entries 
of 3200 used
[    0.000000] Bootmem setup node 0 0000000000000000-0000000130000000
[    0.000000]   NODE_DATA [000000000000e000 - 0000000000012fff]
[    0.000000]   bootmap [0000000000013000 -  0000000000038fff] pages 26
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-673397] TEXT DATA BSS
[    0.000000]   early res: 3 [37817000-37fef99f] RAMDISK
[    0.000000]   early res: 4 [9e800-fffff] BIOS reserved
[    0.000000]   early res: 5 [8000-dfff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20002dfffff] PMD -> 
[ffff810001200000-ffff810003ffffff] on node 0
[    0.000000]  [ffffe20003800000-ffffe200043fffff] PMD -> 
[ffff81000c000000-ffff81000cbfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1245184
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0:        0 ->      158
[    0.000000]     0:      256 ->   851680
[    0.000000]     0:  1048576 ->  1245184
[    0.000000] On node 0 totalpages: 1048190
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1247 pages reserved
[    0.000000]   DMA zone: 2695 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833304 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 
0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfee0000 - 
00000000cfee3000
[    0.000000] PM: Registered nosave memory: 00000000cfee3000 - 
00000000cfef0000
[    0.000000] PM: Registered nosave memory: 00000000cfef0000 - 
00000000cff00000
[    0.000000] PM: Registered nosave memory: 00000000cff00000 - 
00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 
00000000e4000000
[    0.000000] PM: Registered nosave memory: 00000000e4000000 - 
00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 
0000000100000000
[    0.000000] Allocating PCI resources starting at e6000000 (gap: 
e4000000:1ac00000)
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 37168 bytes of per cpu data
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 4
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  
Total pages: 1029919
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/md3 ro single
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] time.c: Detected 2833.023 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Checking aperture...
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x4000000 - 0x8000000
[    0.004000] Memory: 4054384k/4980736k available (2225k kernel code, 
138376k reserved, 1080k data, 392k init)
[    0.004000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000] hpet clockevent registered
[    0.083898] Calibrating delay using timer specific routine.. 5669.97 
BogoMIPS (lpj=11339942)
[    0.084005] Security Framework initialized
[    0.084005] SELinux:  Disabled at boot.
[    0.084005] Capability LSM initialized
[    0.084005] Dentry cache hash table entries: 524288 (order: 10, 
4194304 bytes)
[    0.084005] Inode-cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.084005] Mount-cache hash table entries: 256
[    0.084005] Initializing cgroup subsys ns
[    0.084005] Initializing cgroup subsys cpuacct
[    0.084005] Initializing cgroup subsys devices
[    0.084005] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.084005] CPU: L2 cache: 6144K
[    0.084005] CPU 0/0 -> Node 0
[    0.084005] CPU: Physical Processor ID: 0
[    0.084005] CPU: Processor Core ID: 0
[    0.084005] CPU0: Thermal monitoring enabled (TM2)
[    0.084005] using mwait in idle threads.
[    0.084804] ACPI: Core revision 20080321
[    0.132312] CPU0: Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz 
stepping 07
[    0.132412] Using local APIC timer interrupts.
[    0.140008] APIC timer calibration result 20831070
[    0.140008] Detected 20.831 MHz APIC timer.
[    0.140008] Booting processor 1/1 ip 6000
[    0.148009] Initializing CPU#1
[    0.148009] Calibrating delay using timer specific routine.. 5666.08 
BogoMIPS (lpj=11332171)
[    0.148009] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.148009] CPU: L2 cache: 6144K
[    0.148009] CPU 1/1 -> Node 0
[    0.148009] CPU: Physical Processor ID: 0
[    0.148009] CPU: Processor Core ID: 1
[    0.148009] CPU1: Thermal monitoring enabled (TM2)
[    0.228014] CPU1: Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz 
stepping 07
[    0.228014] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.232014] Booting processor 2/3 ip 6000
[    0.240015] Initializing CPU#2
[    0.240015] Calibrating delay using timer specific routine.. 5666.11 
BogoMIPS (lpj=11332223)
[    0.240015] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.240015] CPU: L2 cache: 6144K
[    0.240015] CPU 2/3 -> Node 0
[    0.240015] CPU: Physical Processor ID: 0
[    0.240015] CPU: Processor Core ID: 3
[    0.240015] CPU2: Thermal monitoring enabled (TM2)
[    0.323252] CPU2: Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz 
stepping 07
[    0.323693] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.328020] Booting processor 3/2 ip 6000
[    0.339678] Initializing CPU#3
[    0.339678] Calibrating delay using timer specific routine.. 5666.11 
BogoMIPS (lpj=11332220)
[    0.339678] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.339678] CPU: L2 cache: 6144K
[    0.339678] CPU 3/2 -> Node 0
[    0.339678] CPU: Physical Processor ID: 0
[    0.339678] CPU: Processor Core ID: 2
[    0.339678] CPU3: Thermal monitoring enabled (TM2)
[    0.420332] CPU3: Intel(R) Core(TM)2 Quad  CPU   Q9550  @ 2.83GHz 
stepping 07
[    0.420773] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.425001] Brought up 4 CPUs
[    0.425001] Total of 4 processors activated (22668.27 BogoMIPS).
[    0.425001] CPU0 attaching sched-domain:
[    0.425001]  domain 0: span 0-1
[    0.425001]   groups: 0 1
[    0.425001]   domain 1: span 0-3
[    0.425001]    groups: 0-1 2-3
[    0.425001]    domain 2: span 0-3
[    0.425001]     groups: 0-3
[    0.425001] CPU1 attaching sched-domain:
[    0.425001]  domain 0: span 0-1
[    0.425001]   groups: 1 0
[    0.425001]   domain 1: span 0-3
[    0.425001]    groups: 0-1 2-3
[    0.425001]    domain 2: span 0-3
[    0.425001]     groups: 0-3
[    0.425001] CPU2 attaching sched-domain:
[    0.425001]  domain 0: span 2-3
[    0.425001]   groups: 2 3
[    0.425001]   domain 1: span 0-3
[    0.425001]    groups: 2-3 0-1
[    0.425001]    domain 2: span 0-3
[    0.425001]     groups: 0-3
[    0.425001] CPU3 attaching sched-domain:
[    0.425001]  domain 0: span 2-3
[    0.425001]   groups: 3 2
[    0.425001]   domain 1: span 0-3
[    0.425001]    groups: 2-3 0-1
[    0.425001]    domain 2: span 0-3
[    0.425001]     groups: 0-3
[    0.425001] net_namespace: 1224 bytes
[    0.425001] Booting paravirtualized kernel on bare hardware
[    0.425001] NET: Registered protocol family 16
[    0.425001] ACPI: bus type pci registered
[    0.425001] PCI: MCFG configuration 0: base e0000000 segment 0 buses 
0 - 63
[    0.425001] PCI: MCFG area at e0000000 reserved in E820
[    0.428768] PCI: Using MMCONFIG at e0000000 - e3ffffff
[    0.428811] PCI: Using configuration type 1 for base access
[    0.430039] ACPI: EC: Look up EC in DSDT
[    0.435168] ACPI: Interpreter enabled
[    0.435218] ACPI: (supports S0 S3 S4 S5)
[    0.435374] ACPI: Using IOAPIC for interrupt routing
[    0.442100] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.442100] PCI: Transparent bridge - 0000:00:1e.0
[    0.442100] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.442100] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.442100] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.442100] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.442100] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.442100] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    0.442100] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.458101] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 11 
12 *14 15)
[    0.458101] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 
12 14 15)
[    0.458101] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 
12 14 15)
[    0.458101] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 
12 14 *15)
[    0.458569] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 
12 14 15) *0, disabled.
[    0.459086] ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 5 6 7 9 10 11 
12 14 15)
[    0.464934] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 
12 14 15)
[    0.465397] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 *7 9 10 11 
12 14 15)
[    0.471466] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.471466] pnp: PnP ACPI init
[    0.471466] ACPI: bus type pnp registered
[    0.471466] pnp 00:00: parse allocated resources
[    0.471466] pnp 00:00:   add io  0xcf8-0xcff flags 0x1
[    0.471466] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.471601] pnp 00:01: parse allocated resources
[    0.471606] pnp 00:01:   add io  0x10-0x1f flags 0x1
[    0.471607] pnp 00:01:   add io  0x22-0x3f flags 0x1
[    0.471608] pnp 00:01:   add io  0x44-0x5f flags 0x1
[    0.471610] pnp 00:01:   add io  0x62-0x63 flags 0x1
[    0.471611] pnp 00:01:   add io  0x65-0x6f flags 0x1
[    0.471612] pnp 00:01:   add io  0x74-0x7f flags 0x1
[    0.471613] pnp 00:01:   add io  0x91-0x93 flags 0x1
[    0.471615] pnp 00:01:   add io  0xa2-0xbf flags 0x1
[    0.471616] pnp 00:01:   add io  0xe0-0xef flags 0x1
[    0.471617] pnp 00:01:   add io  0x4d0-0x4d1 flags 0x1
[    0.471618] pnp 00:01:   add io  0x290-0x29f flags 0x1
[    0.471620] pnp 00:01:   add io  0x800-0x87f flags 0x1
[    0.471621] pnp 00:01:   add io  0x290-0x294 flags 0x1
[    0.471622] pnp 00:01:   add io  0x880-0x88f flags 0x1
[    0.471624] pnp 00:01: PNP0c02: calling 
quirk_system_pci_resources+0x0/0x15c
[    0.475466] pnp 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.475466] pnp 00:02: parse allocated resources
[    0.475466] pnp 00:02:   add dma 4 flags 0x4
[    0.475466] pnp 00:02:   add io  0x0-0xf flags 0x1
[    0.475466] pnp 00:02:   add io  0x80-0x90 flags 0x1
[    0.475466] pnp 00:02:   add io  0x94-0x9f flags 0x1
[    0.475466] pnp 00:02:   add io  0xc0-0xdf flags 0x1
[    0.475466] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.475466] pnp 00:03: parse allocated resources
[    0.475466] pnp 00:03:   add irq 8 flags 0x1
[    0.475466] pnp 00:03:   add mem 0xfed00000-0xfed003ff flags 0x1
[    0.475466] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.475466] pnp 00:04: parse allocated resources
[    0.475466] pnp 00:04:   add io  0x70-0x73 flags 0x1
[    0.475466] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.475466] pnp 00:05: parse allocated resources
[    0.475466] pnp 00:05:   add io  0x61-0x61 flags 0x1
[    0.475466] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.475466] pnp 00:06: parse allocated resources
[    0.475466] pnp 00:06:   add io  0xf0-0xff flags 0x1
[    0.475466] pnp 00:06:   add irq 13 flags 0x1
[    0.475466] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.475466] pnp 00:07: parse allocated resources
[    0.475466] pnp 00:07:   add io  0x3f0-0x3f5 flags 0x1
[    0.475466] pnp 00:07:   add io  0x3f7-0x3f7 flags 0x1
[    0.475466] pnp 00:07:   add irq 6 flags 0x1
[    0.475466] pnp 00:07:   add dma 2 flags 0x0
[    0.475466] pnp 00:07: parse resource options
[    0.475466] pnp 00:07: new independent option
[    0.475466] pnp 00:07: new dependent option (priority 0x1)
[    0.475466] pnp 00:07:   io  min 0x3f0 max 0x3f0 align 1 size 6 flags 0x1
[    0.475466] pnp 00:07:   io  min 0x3f7 max 0x3f7 align 1 size 1 flags 0x1
[    0.475466] pnp 00:07:   irq bitmask 
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000040 
flags 0x1
[    0.475466] pnp 00:07:   dma bitmask 0x4 flags 0x0
[    0.475466] pnp 00:07: end dependent options
[    0.475466] pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.475466] pnp 00:08: parse allocated resources
[    0.475466] pnp 00:08:   add io  0x3f8-0x3ff flags 0x1
[    0.475466] pnp 00:08:   add irq 4 flags 0x1
[    0.475466] pnp 00:08: parse resource options
[    0.475466] pnp 00:08: new independent option
[    0.475466] pnp 00:08: new dependent option (priority 0x1)
[    0.475466] pnp 00:08:   io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
[    0.475466] pnp 00:08:   irq bitmask 
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001eb8 
flags 0x1
[    0.475466] pnp 00:08: new dependent option (priority 0x1)
[    0.475466] pnp 00:08:   io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
[    0.475466] pnp 00:08:   irq bitmask 
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001eb8 
flags 0x1
[    0.475466] pnp 00:08: new dependent option (priority 0x1)
[    0.475466] pnp 00:08:   io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
[    0.475466] pnp 00:08:   irq bitmask 
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001eb8 
flags 0x1
[    0.475466] pnp 00:08: new dependent option (priority 0x1)
[    0.475466] pnp 00:08:   io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
[    0.475466] pnp 00:08:   irq bitmask 
00000000,00000000,00000000,00000000,00000000,00000000,00000000,00001eb8 
flags 0x1
[    0.475466] pnp 00:08: end dependent options
[    0.475466] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.475466] pnp 00:09: parse allocated resources
[    0.475466] pnp 00:09:   add irq 12 flags 0x1
[    0.475466] pnp 00:09: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.475466] pnp 00:0a: parse allocated resources
[    0.475466] pnp 00:0a:   add io  0x60-0x60 flags 0x1
[    0.475466] pnp 00:0a:   add io  0x64-0x64 flags 0x1
[    0.475466] pnp 00:0a:   add irq 1 flags 0x1
[    0.475466] pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.475466] pnp 00:0b: parse allocated resources
[    0.475466] pnp 00:0b:   add io  0x400-0x4bf flags 0x1
[    0.475466] pnp 00:0b: PNP0c02: calling 
quirk_system_pci_resources+0x0/0x15c
[    0.475466] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.475466] pnp 00:0c: parse allocated resources
[    0.475466] pnp 00:0c:   add mem 0xe0000000-0xe3ffffff flags 0x1
[    0.475466] pnp 00:0c: PNP0c02: calling 
quirk_system_pci_resources+0x0/0x15c
[    0.475466] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.475466] pnp 00:0d: parse allocated resources
[    0.475466] pnp 00:0d:   add mem 0xd2000-0xd3fff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xf0000-0xf7fff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xf8000-0xfbfff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xfc000-0xfffff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xcfee0000-0xcfefffff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0x0-0x9ffff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0x100000-0xcfedffff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xfec00000-0xfec00fff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xfed10000-0xfed1dfff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xfed20000-0xfed8ffff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xfee00000-0xfee00fff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xffb00000-0xffb7ffff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xfff00000-0xffffffff flags 0x1
[    0.475466] pnp 00:0d:   add mem 0xe0000-0xeffff flags 0x1
[    0.475466] pnp 00:0d: PNP0c01: calling 
quirk_system_pci_resources+0x0/0x15c
[    0.475466] pnp 00:0d: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.475466] pnp 00:0e: parse allocated resources
[    0.475466] pnp 00:0e:   add mem 0xffb80000-0xffbfffff flags 0x1
[    0.475466] pnp 00:0e: Plug and Play ACPI device, IDs INT0800 (active)
[    0.475466] pnp: PnP ACPI: found 15 devices
[    0.475466] ACPI: ACPI bus type pnp unregistered
[    0.475466] usbcore: registered new interface driver usbfs
[    0.475466] usbcore: registered new interface driver hub
[    0.475466] usbcore: registered new device driver usb
[    0.475466] PCI: Using ACPI for IRQ routing
[    0.493155] PCI-GART: No AMD northbridge found.
[    0.493202] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.493381] hpet0: 4 64-bit timers, 14318180 Hz
[    0.497134] ACPI: RTC can wake from S4
[    0.511776] pnp: the driver 'system' has been registered
[    0.511785] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.511831] system 00:01: ioport range 0x290-0x29f has been reserved
[    0.511883] system 00:01: ioport range 0x800-0x87f has been reserved
[    0.511927] system 00:01: ioport range 0x290-0x294 has been reserved
[    0.511971] system 00:01: ioport range 0x880-0x88f has been reserved
[    0.512015] system 00:01: driver attached
[    0.512021] system 00:0b: ioport range 0x400-0x4bf has been reserved
[    0.512065] system 00:0b: driver attached
[    0.512069] system 00:0c: iomem range 0xe0000000-0xe3ffffff could not 
be reserved
[    0.512124] system 00:0c: driver attached
[    0.512127] system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
[    0.512172] system 00:0d: iomem range 0xf0000-0xf7fff could not be 
reserved
[    0.512217] system 00:0d: iomem range 0xf8000-0xfbfff could not be 
reserved
[    0.512262] system 00:0d: iomem range 0xfc000-0xfffff could not be 
reserved
[    0.512307] system 00:0d: iomem range 0xcfee0000-0xcfefffff could not 
be reserved
[    0.512363] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.512408] system 00:0d: iomem range 0x100000-0xcfedffff could not 
be reserved
[    0.512463] system 00:0d: iomem range 0xfec00000-0xfec00fff could not 
be reserved
[    0.512518] system 00:0d: iomem range 0xfed10000-0xfed1dfff could not 
be reserved
[    0.512574] system 00:0d: iomem range 0xfed20000-0xfed8ffff could not 
be reserved
[    0.512629] system 00:0d: iomem range 0xfee00000-0xfee00fff could not 
be reserved
[    0.512685] system 00:0d: iomem range 0xffb00000-0xffb7ffff could not 
be reserved
[    0.512740] system 00:0d: iomem range 0xfff00000-0xffffffff could not 
be reserved
[    0.512796] system 00:0d: iomem range 0xe0000-0xeffff has been reserved
[    0.512840] system 00:0d: driver attached
[    0.514344] Switched to high resolution mode on CPU 2
[    0.518409] Switched to high resolution mode on CPU 1
[    0.518419] Switched to high resolution mode on CPU 3
[    0.522417] PCI: Bridge: 0000:00:01.0
[    0.522417]   IO window: disabled.
[    0.522417]   MEM window: 0xe4000000-0xe6ffffff
[    0.522417]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.522417] PCI: Bridge: 0000:00:1c.0
[    0.522417]   IO window: disabled.
[    0.522417]   MEM window: disabled.
[    0.522417]   PREFETCH window: disabled.
[    0.522417] PCI: Bridge: 0000:00:1c.2
[    0.522417]   IO window: a000-afff
[    0.522417]   MEM window: 0xe7000000-0xe8ffffff
[    0.522417]   PREFETCH window: 0x00000000ec400000-0x00000000ec4fffff
[    0.522417] PCI: Bridge: 0000:00:1c.3
[    0.522417]   IO window: b000-bfff
[    0.522417]   MEM window: 0xe9000000-0xe9ffffff
[    0.522417]   PREFETCH window: disabled.
[    0.522417] PCI: Bridge: 0000:00:1c.4
[    0.522417]   IO window: c000-cfff
[    0.522417]   MEM window: 0xea000000-0xeaffffff
[    0.522417]   PREFETCH window: 0x00000000ec000000-0x00000000ec0fffff
[    0.522417] PCI: Bridge: 0000:00:1c.5
[    0.522417]   IO window: d000-dfff
[    0.522417]   MEM window: 0xeb000000-0xebffffff
[    0.522417]   PREFETCH window: 0x00000000ec100000-0x00000000ec1fffff
[    0.522417] PCI: Bridge: 0000:00:1e.0
[    0.522417]   IO window: disabled.
[    0.522417]   MEM window: 0xec200000-0xec2fffff
[    0.522417]   PREFETCH window: disabled.
[    0.522417] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    0.522417] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.522417] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    0.522417] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.522417] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, 
low) -> IRQ 18
[    0.522417] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.522417] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, 
low) -> IRQ 19
[    0.522417] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.522417] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, 
low) -> IRQ 16
[    0.522417] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.522417] ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 17 (level, 
low) -> IRQ 17
[    0.522417] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[    0.522417] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.522417] NET: Registered protocol family 2
[    0.522688] Switched to high resolution mode on CPU 0
[    0.570387] IP route cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.570387] TCP established hash table entries: 524288 (order: 11, 
8388608 bytes)
[    0.570387] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.570387] TCP: Hash tables configured (established 524288 bind 65536)
[    0.570387] TCP reno registered
[    0.586673] NET: Registered protocol family 1
[    0.586806] checking if image is initramfs... it is
[    1.052297] Freeing initrd memory: 8034k freed
[    1.055838] audit: initializing netlink socket (disabled)
[    1.055838] type=2000 audit(1220103307.032:1): initialized
[    1.065317] Total HugeTLB memory allocated, 0
[    1.065317] VFS: Disk quotas dquot_6.5.1
[    1.065317] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.065317] msgmni has been set to 7934
[    1.065317] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 253)
[    1.065317] io scheduler noop registered
[    1.065317] io scheduler anticipatory registered
[    1.065317] io scheduler deadline registered
[    1.065317] io scheduler cfq registered (default)
[    1.065317] pci 0000:01:00.0: Boot video device
[    1.065317] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    1.065317] assign_interrupt_mode Found MSI capability
[    1.065317] Allocate Port Service[0000:00:01.0:pcie00]
[    1.065317] Allocate Port Service[0000:00:01.0:pcie03]
[    1.065317] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.065317] assign_interrupt_mode Found MSI capability
[    1.065317] Allocate Port Service[0000:00:1c.0:pcie00]
[    1.065317] Allocate Port Service[0000:00:1c.0:pcie02]
[    1.065317] Allocate Port Service[0000:00:1c.0:pcie03]
[    1.065317] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    1.065317] assign_interrupt_mode Found MSI capability
[    1.065317] Allocate Port Service[0000:00:1c.2:pcie00]
[    1.065317] Allocate Port Service[0000:00:1c.2:pcie02]
[    1.065317] Allocate Port Service[0000:00:1c.2:pcie03]
[    1.065317] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    1.065317] assign_interrupt_mode Found MSI capability
[    1.065317] Allocate Port Service[0000:00:1c.3:pcie00]
[    1.065317] Allocate Port Service[0000:00:1c.3:pcie02]
[    1.065317] Allocate Port Service[0000:00:1c.3:pcie03]
[    1.065317] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    1.065317] assign_interrupt_mode Found MSI capability
[    1.065317] Allocate Port Service[0000:00:1c.4:pcie00]
[    1.065317] Allocate Port Service[0000:00:1c.4:pcie02]
[    1.065317] Allocate Port Service[0000:00:1c.4:pcie03]
[    1.065317] PCI: Setting latency timer of device 0000:00:1c.5 to 64
[    1.065317] assign_interrupt_mode Found MSI capability
[    1.065317] Allocate Port Service[0000:00:1c.5:pcie00]
[    1.065317] Allocate Port Service[0000:00:1c.5:pcie02]
[    1.065317] Allocate Port Service[0000:00:1c.5:pcie03]
[    1.069319] hpet_resources: 0xfed00000 is busy
[    1.069319] Linux agpgart interface v0.103
[    1.069319] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing enabled
[    1.069319] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.069319] pnp: the driver 'serial' has been registered
[    1.069319] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.069319] serial 00:08: driver attached
[    1.069428] brd: module loaded
[    1.069428] input: Macintosh mouse button emulation as 
/class/input/input0
[    1.069428] pnp: the driver 'i8042 kbd' has been registered
[    1.069428] i8042 kbd 00:0a: driver attached
[    1.069428] pnp: the driver 'i8042 aux' has been registered
[    1.069428] i8042 aux 00:09: driver attached
[    1.069428] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 
0x60,0x64 irq 1,12
[    1.069618] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.069665] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.089410] mice: PS/2 mouse device common for all mice
[    1.089410] pnp: the driver 'rtc_cmos' has been registered
[    1.089410] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.089410] rtc0: alarms up to one month
[    1.089410] rtc_cmos 00:04: driver attached
[    1.089410] cpuidle: using governor ladder
[    1.089410] cpuidle: using governor menu
[    1.089410] No iBFT detected.
[    1.089410] TCP cubic registered
[    1.089410] NET: Registered protocol family 17
[    1.089410] registered taskstats version 1
[    1.089410] rtc_cmos 00:04: setting system clock to 2008-08-30 
13:35:07 UTC (1220103307)
[    1.089410] Freeing unused kernel memory: 392k freed
[    1.105308] input: AT Translated Set 2 keyboard as /class/input/input1
[    1.147295] ACPI: SSDT CFEE8000, 022A (r1  PmRef  Cpu0Ist     3000 
INTL 20040311)
[    1.147295] ACPI: CPU0 (power states: C1[C1] C2[C2])
[    1.147295] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.147295] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.147295] ACPI: SSDT CFEE84C0, 0152 (r1  PmRef  Cpu1Ist     3000 
INTL 20040311)
[    1.147295] ACPI: CPU1 (power states: C1[C1] C2[C2])
[    1.147295] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.147342] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.147584] ACPI: SSDT CFEE8620, 0152 (r1  PmRef  Cpu2Ist     3000 
INTL 20040311)
[    1.151578] ACPI: CPU2 (power states: C1[C1] C2[C2])
[    1.151578] ACPI: ACPI0007:02 is registered as cooling_device2
[    1.151578] ACPI: Processor [CPU2] (supports 8 throttling states)
[    1.151578] ACPI: SSDT CFEE8780, 0152 (r1  PmRef  Cpu3Ist     3000 
INTL 20040311)
[    1.152903] ACPI: CPU3 (power states: C1[C1] C2[C2])
[    1.153047] ACPI: ACPI0007:03 is registered as cooling_device3
[    1.153092] ACPI: Processor [CPU3] (supports 8 throttling states)
[    1.227512] USB Universal Host Controller Interface driver v3.0
[    1.227512] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, 
low) -> IRQ 16
[    1.227512] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[    1.227512] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.227512] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned 
bus number 1
[    1.227512] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e200
[    1.227512] usb usb1: configuration #1 chosen from 1 choice
[    1.227512] hub 1-0:1.0: USB hub found
[    1.227512] hub 1-0:1.0: 2 ports detected
[    1.273381] No dock devices found.
[    1.277382] SCSI subsystem initialized
[    1.302287] libata version 3.00 loaded.
[    1.327883] Floppy drive(s): fd0 is 1.44M
[    1.346213] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    1.346213] FDC 0 is a post-1991 82077
[    1.346323] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.346378] usb usb1: Product: UHCI Host Controller
[    1.346421] usb usb1: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    1.346466] usb usb1: SerialNumber: 0000:00:1a.0
[    1.354070] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, 
low) -> IRQ 21
[    1.358076] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[    1.358079] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.358154] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned 
bus number 2
[    1.358231] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e000
[    1.358324] usb usb2: configuration #1 chosen from 1 choice
[    1.358384] hub 2-0:1.0: USB hub found
[    1.358427] hub 2-0:1.0: 2 ports detected
[    1.463368] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.463375] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.463375] usb usb2: Product: UHCI Host Controller
[    1.463375] usb usb2: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    1.463375] usb usb2: SerialNumber: 0000:00:1a.1
[    1.463375] ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, 
low) -> IRQ 18
[    1.463375] PCI: Setting latency timer of device 0000:00:1a.2 to 64
[    1.463375] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    1.463375] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned 
bus number 3
[    1.463375] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e100
[    1.463375] usb usb3: configuration #1 chosen from 1 choice
[    1.463375] hub 3-0:1.0: USB hub found
[    1.463375] hub 3-0:1.0: 2 ports detected
[    1.585999] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.586061] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.586116] usb usb3: Product: UHCI Host Controller
[    1.586158] usb usb3: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    1.586201] usb usb3: SerialNumber: 0000:00:1a.2
[    1.586201] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, 
low) -> IRQ 18
[    1.586201] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[    1.586201] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.586201] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned 
bus number 4
[    1.658195] PCI: cache line size of 32 is not supported by device 
0000:00:1a.7
[    1.658195] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xec305000
[    1.675202] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 
10 Dec 2004
[    1.675316] usb usb4: configuration #1 chosen from 1 choice
[    1.675378] hub 4-0:1.0: USB hub found
[    1.675423] hub 4-0:1.0: 6 ports detected
[    1.777768] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    1.777821] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.777875] usb usb4: Product: EHCI Host Controller
[    1.777917] usb usb4: Manufacturer: Linux 2.6.26-1-amd64 ehci_hcd
[    1.777961] usb usb4: SerialNumber: 0000:00:1a.7
[    1.778207] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, 
low) -> IRQ 23
[    1.778207] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    1.778207] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.778207] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 5
[    1.778207] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
[    1.778207] usb usb5: configuration #1 chosen from 1 choice
[    1.778207] hub 5-0:1.0: USB hub found
[    1.778207] hub 5-0:1.0: 2 ports detected
[    1.887153] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.887196] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    1.887196] usb usb5: Product: UHCI Host Controller
[    1.887196] usb usb5: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    1.887196] usb usb5: SerialNumber: 0000:00:1d.0
[    1.887196] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, 
low) -> IRQ 19
[    1.887196] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    1.887196] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.887196] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 6
[    1.887196] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
[    1.887196] usb usb6: configuration #1 chosen from 1 choice
[    1.887196] hub 6-0:1.0: USB hub found
[    1.887196] hub 6-0:1.0: 2 ports detected
[    2.083222] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    2.083283] usb usb6: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.083338] usb usb6: Product: UHCI Host Controller
[    2.083380] usb usb6: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    2.083423] usb usb6: SerialNumber: 0000:00:1d.1
[    2.085264] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, 
low) -> IRQ 18
[    2.085264] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    2.085264] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    2.085264] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 7
[    2.085264] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
[    2.085264] usb usb7: configuration #1 chosen from 1 choice
[    2.085264] hub 7-0:1.0: USB hub found
[    2.085264] hub 7-0:1.0: 2 ports detected
[    2.221219] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    2.221281] usb usb7: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.221336] usb usb7: Product: UHCI Host Controller
[    2.221378] usb usb7: Manufacturer: Linux 2.6.26-1-amd64 uhci_hcd
[    2.221421] usb usb7: SerialNumber: 0000:00:1d.2
[    2.221421] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, 
low) -> IRQ 23
[    2.221421] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    2.221421] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.221421] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 8
[    2.261419] PCI: cache line size of 32 is not supported by device 
0000:00:1d.7
[    2.261419] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xec304000
[    2.285422] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 
10 Dec 2004
[    2.285533] usb usb8: configuration #1 chosen from 1 choice
[    2.285594] hub 8-0:1.0: USB hub found
[    2.285637] hub 8-0:1.0: 6 ports detected
[    2.387996] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    2.388048] usb usb8: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    2.388103] usb usb8: Product: EHCI Host Controller
[    2.388145] usb usb8: Manufacturer: Linux 2.6.26-1-amd64 ehci_hcd
[    2.388188] usb usb8: SerialNumber: 0000:00:1d.7
[    2.393416] ahci 0000:00:1f.2: version 3.0
[    2.393416] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, 
low) -> IRQ 19
[    3.843630] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 
0x3f impl SATA mode
[    3.843693] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo 
pmp pio slum part
[    3.843754] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    3.847601] scsi0 : ahci
[    3.847601] scsi1 : ahci
[    3.847601] scsi2 : ahci
[    3.847601] scsi3 : ahci
[    3.847601] scsi4 : ahci
[    3.847601] scsi5 : ahci
[    3.847680] ata1: SATA max UDMA/133 abar m2048@0xec306000 port 
0xec306100 irq 1273
[    3.847736] ata2: SATA max UDMA/133 abar m2048@0xec306000 port 
0xec306180 irq 1273
[    3.847792] ata3: SATA max UDMA/133 abar m2048@0xec306000 port 
0xec306200 irq 1273
[    3.847848] ata4: SATA max UDMA/133 abar m2048@0xec306000 port 
0xec306280 irq 1273
[    3.847903] ata5: SATA max UDMA/133 abar m2048@0xec306000 port 
0xec306300 irq 1273
[    3.847959] ata6: SATA max UDMA/133 abar m2048@0xec306000 port 
0xec306380 irq 1273
[    4.671777] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.671767] ata1.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    4.671767] ata1.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.672094] ata1.00: configured for UDMA/133
[    5.558790] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.558781] ata2.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    5.558781] ata2.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.563197] ata2.00: configured for UDMA/133
[    6.042309] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.131806] ata3.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    6.131806] ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.131806] ata3.00: configured for UDMA/133
[    6.607219] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.608423] ata4.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    6.608470] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    6.608423] ata4.00: configured for UDMA/133
[    7.090884] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.151506] ata5.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    7.151506] ata5.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    7.151506] ata5.00: configured for UDMA/133
[    8.109286] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.118160] ata6.00: ATA-8: WDC WD7501AALS-00J7B0, 05.00K05, max UDMA/133
[    8.118160] ata6.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    8.122478] ata6.00: configured for UDMA/133
[    7.151506] scsi 0:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 
05.0 PQ: 0 ANSI: 5
[    7.151506] scsi 1:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 
05.0 PQ: 0 ANSI: 5
[    7.151506] scsi 2:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 
05.0 PQ: 0 ANSI: 5
[    7.151506] scsi 3:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 
05.0 PQ: 0 ANSI: 5
[    7.151506] scsi 4:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 
05.0 PQ: 0 ANSI: 5
[    7.151506] scsi 5:0:0:0: Direct-Access     ATA      WDC WD7501AALS-0 
05.0 PQ: 0 ANSI: 5
[    8.429006] r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
[    8.429006] sata_sil24 0000:03:00.0: version 1.1
[    8.429006] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, 
low) -> IRQ 18
[    8.429006] PCI: Setting latency timer of device 0000:03:00.0 to 64
[    8.429006] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 17 (level, 
low) -> IRQ 17
[    8.429006] PCI: Setting latency timer of device 0000:06:00.0 to 64
[    8.429006] scsi6 : sata_sil24
[    8.429006] eth0: RTL8168c/8111c at 0xffffc20000632000, 
00:1f:d0:23:89:fe, XID 3c4000c0 IRQ 1272
[    8.429006] scsi7 : sata_sil24
[    8.429006] ata7: SATA max UDMA/100 host m128@0xe8004000 port 
0xe8000000 irq 18
[    8.429006] ata8: SATA max UDMA/100 host m128@0xe8004000 port 
0xe8002000 irq 18
[   10.840394] ata7: SATA link down (SStatus 0 SControl 0)
[   13.704354] ata8: SATA link down (SStatus 0 SControl 0)
[   14.716334] ACPI: PCI Interrupt 0000:07:07.0[A] -> GSI 23 (level, 
low) -> IRQ 23
[   14.846759] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[23]  
MMIO=[ec204000-ec2047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   14.846759] Uniform Multi-Platform E-IDE driver
[   14.846804] ide: Assuming 33MHz system bus speed for PIO modes; 
override with idebus=xx
[   14.847185] JMB: IDE controller (0x197b:0x2368 rev 0x00) at  PCI slot 
0000:04:00.0
[   14.847185] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, 
low) -> IRQ 19
[   14.847185] JMB: 100% native mode on irq 19
[   14.847185]     ide0: BM-DMA at 0xb400-0xb407
[   14.847185]     ide1: BM-DMA at 0xb408-0xb40f
[   14.847185] Probing IDE interface ide0...
[   14.856760] Driver 'sd' needs updating - please use bus_type methods
[   14.856881] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.856949] sd 0:0:0:0: [sda] Write Protect is off
[   14.860461] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   14.860461] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.860461] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.860461] sd 0:0:0:0: [sda] Write Protect is off
[   14.860461] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   14.860461] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.860461]  sda: sda1 sda2 sda3
[   14.881341] sd 0:0:0:0: [sda] Attached SCSI disk
[   14.881341] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.881341] sd 1:0:0:0: [sdb] Write Protect is off
[   14.881341] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   14.881341] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.881341] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.881341] sd 1:0:0:0: [sdb] Write Protect is off
[   14.881341] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   14.881341] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.881341]  sdb: sdb1 sdb2 sdb3
[   14.906515] sd 1:0:0:0: [sdb] Attached SCSI disk
[   14.906515] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.906515] sd 2:0:0:0: [sdc] Write Protect is off
[   14.906515] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   14.906515] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.906515] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.906515] sd 2:0:0:0: [sdc] Write Protect is off
[   14.906515] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   14.906515] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.906515]  sdc: sdc1 sdc2 sdc3
[   14.928338] sd 2:0:0:0: [sdc] Attached SCSI disk
[   14.928338] sd 3:0:0:0: [sdd] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.928338] sd 3:0:0:0: [sdd] Write Protect is off
[   14.928338] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   14.928338] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.928338] sd 3:0:0:0: [sdd] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.928338] sd 3:0:0:0: [sdd] Write Protect is off
[   14.928338] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   14.928338] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.928338]  sdd: sdd1 sdd2 sdd3
[   14.952282] sd 3:0:0:0: [sdd] Attached SCSI disk
[   14.952282] sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.952282] sd 4:0:0:0: [sde] Write Protect is off
[   14.952282] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[   14.952282] sd 4:0:0:0: [sde] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.954288] sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.954288] sd 4:0:0:0: [sde] Write Protect is off
[   14.954288] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[   14.954288] sd 4:0:0:0: [sde] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.954288]  sde: sde1 sde2 sde3
[   14.976122] sd 4:0:0:0: [sde] Attached SCSI disk
[   14.976202] sd 5:0:0:0: [sdf] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.976265] sd 5:0:0:0: [sdf] Write Protect is off
[   14.976308] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[   14.976323] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.976408] sd 5:0:0:0: [sdf] 1465149168 512-byte hardware sectors 
(750156 MB)
[   14.976472] sd 5:0:0:0: [sdf] Write Protect is off
[   14.976515] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[   14.976530] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   14.976587]  sdf: sdf1 sdf2 sdf3
[   14.994523] sd 5:0:0:0: [sdf] Attached SCSI disk
[   15.594725] hda: ASUS CRW-5232AS, ATAPI CD/DVD-ROM drive
[   16.145540] ieee1394: Host added: ID:BUS[0-00:1023]  
GUID[002bcaee00001fd0]
[   16.706809] hdb: SAMSUNG CD-ROM SH-152A, ATAPI CD/DVD-ROM drive
[   16.762418] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   16.762501] hda: UDMA/33 mode selected
[   16.762660] hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[   16.762726] hdb: UDMA/33 mode selected
[   16.762869] Probing IDE interface ide1...
[   17.581059] ide0 at 0xb000-0xb007,0xb102 on irq 19
[   17.582203] ide1 at 0xb200-0xb207,0xb302 on irq 19
[   17.863689] hda: ATAPI 52X CD-ROM CD-R/RW drive, 2048kB Cache
[   17.863689] Uniform CD-ROM driver Revision: 3.20
[   17.870292] hdb: ATAPI 52X CD-ROM drive, 128kB Cache
[   17.925104] md: raid1 personality registered for level 1
[   17.927090] md: raid10 personality registered for level 10
[   17.929410] md: md3 stopped.
[   17.960031] md: bind<sdb1>
[   17.960031] md: bind<sdd1>
[   17.960083] md: bind<sde1>
[   17.960031] md: bind<sdc1>
[   17.960732] md: bind<sdf1>
[   17.960732] md: bind<sda1>
[   17.971855] raid1: raid set md3 active with 6 out of 6 mirrors
[   17.971855] md: md4 stopped.
[   17.975859] md: bind<sdb3>
[   17.975859] md: bind<sdd3>
[   17.975859] md: bind<sde3>
[   17.976982] md: bind<sdc3>
[   17.975859] md: bind<sdf3>
[   17.975859] md: bind<sda3>
[   17.983851] raid10: raid set md4 active with 6 out of 6 devices
[   18.123469] device-mapper: uevent: version 1.0.3
[   18.123547] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) 
initialised: dm-devel@redhat.com
[   18.139475] PM: Starting manual resume from disk
[   18.189012] kjournald starting.  Commit interval 5 seconds
[   18.189660] EXT3-fs: mounted filesystem with ordered data mode.
[   20.026659] udevd version 125 started
[   20.332956] input: Power Button (FF) as /class/input/input2
[   20.414997] ACPI: Power Button (FF) [PWRF]
[   20.415079] input: Power Button (CM) as /class/input/input3
[   20.483338] ACPI: Power Button (CM) [PWRB]
[   20.496008] ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, 
low) -> IRQ 18
[   20.508008] input: PC Speaker as /class/input/input4
[   20.533768] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, 
low) -> IRQ 22
[   20.533768] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   20.543847] Error: Driver 'pcspkr' is already registered, aborting...
[   21.112299] input: ImPS/2 Generic Wheel Mouse as /class/input/input5
[   21.476256] Error: Driver 'pcspkr' is already registered, aborting...
[   23.959337] Adding 2931852k swap on /dev/sda2.  Priority:-1 extents:1 
across:2931852k
[   23.963712] Adding 2931852k swap on /dev/sdd2.  Priority:-2 extents:1 
across:2931852k
[   24.455456] EXT3 FS on md3, internal journal
[   24.534056] loop: module loaded
[   24.574483] it87: Found IT8718F chip at 0x290, revision 5
[   24.574483] it87: in3 is VCC (+5V)
[   24.596260] coretemp coretemp.0: Using relative temperature scale!
[   24.596290] coretemp coretemp.1: Using relative temperature scale!
[   24.596360] coretemp coretemp.2: Using relative temperature scale!
[   24.596427] coretemp coretemp.3: Using relative temperature scale!
[   25.379749] SGI XFS with ACLs, security attributes, realtime, large 
block/inode numbers, no debug enabled
[   25.379749] SGI XFS Quota Management subsystem
[   25.379749] Filesystem "dm-0": Disabling barriers, not supported by 
the underlying device
[   25.379749] XFS mounting filesystem dm-0
[   25.589938] Ending clean XFS mount for filesystem: dm-0
[   25.589938] Filesystem "dm-1": Disabling barriers, not supported by 
the underlying device
[   25.589938] XFS mounting filesystem dm-1
[   25.808033] Ending clean XFS mount for filesystem: dm-1
[   25.982767] ReiserFS: dm-2: found reiserfs format "3.6" with standard 
journal
[   25.982767] ReiserFS: dm-2: using ordered data mode
[   25.997390] ReiserFS: dm-2: journal params: device dm-2, size 8192, 
journal first block 18, max trans len 1024, max batch 900, max commit 
age 30, max trans age 30
[   25.997390] ReiserFS: dm-2: checking transaction log (dm-2)
[   26.049615] ReiserFS: dm-2: Using r5 hash to sort names
[   27.356049] fuse init (API version 7.9)
[   30.872983] r8169: eth0: link up
[   30.872983] r8169: eth0: link up
[   36.793363] NET: Registered protocol family 10
[   36.793725] lo: Disabled Privacy Extensions
[   51.030543] eth0: no IPv6 routers present
[  137.906238] md: md4 still in use.
[  457.735609] md: md4 stopped.
[  457.735609] md: unbind<sda3>
[  457.735609] md: export_rdev(sda3)
[  457.735609] md: unbind<sdf3>
[  457.735609] md: export_rdev(sdf3)
[  457.735609] md: unbind<sdc3>
[  457.735609] md: export_rdev(sdc3)
[  457.735609] md: unbind<sde3>
[  457.735609] md: export_rdev(sde3)
[  457.735609] md: unbind<sdd3>
[  457.735609] md: export_rdev(sdd3)
[  457.735609] md: unbind<sdb3>
[  457.735609] md: export_rdev(sdb3)
[  765.553777] dmesg(4322): dirtied inode 10440 (dmesg_next) on tmpfs
[  765.558443] lm-profiler(4317): READ block 8913752 on md3
[  765.594108] lm-profiler(4323): READ block 9124536 on md3
[  765.594908] lm-profiler(4317): READ block 8913824 on md3
[  765.607814] lm-profiler(4317): READ block 8914648 on md3
[  765.607819] lm-profiler(4327): READ block 9768168 on md3
[  765.610108] lm-profiler(4317): READ block 8913608 on md3
[  765.610108] diff(4323): READ block 9124568 on md3
[  765.610108] diff(4323): READ block 9124576 on md3
[  765.610108] diff(4323): READ block 9124584 on md3
[  765.610108] diff(4323): READ block 9124592 on md3
[  765.610108] diff(4323): READ block 9124600 on md3
[  765.610108] diff(4323): READ block 9124608 on md3
[  765.610108] diff(4323): READ block 9124616 on md3
[  765.610108] diff(4323): READ block 9124624 on md3
[  765.610108] diff(4323): READ block 9124632 on md3
[  765.611819] lm-profiler(4317): READ block 8913624 on md3
[  765.617081] lm-profiler(4330): READ block 9096920 on md3
[  765.618311] diff(4323): READ block 9124640 on md3
[  765.620603] awk(4327): READ block 9768264 on md3
[  765.621243] awk(4327): READ block 9768696 on md3
[  765.624595] sort(4330): READ block 9096952 on md3
[  765.624595] sort(4330): READ block 9096960 on md3
[  765.624595] sort(4330): READ block 9096968 on md3
[  765.624595] sort(4330): READ block 9096976 on md3
[  765.624595] sort(4330): READ block 9096984 on md3
[  765.624595] sort(4330): READ block 9096992 on md3
[  765.624595] sort(4330): READ block 9097000 on md3
[  765.624595] sort(4330): READ block 9097008 on md3
[  765.624595] sort(4330): READ block 9097016 on md3
[  765.628836] lm-profiler(4331): READ block 9098960 on md3
[  765.629947] sort(4330): READ block 9097024 on md3
[  765.632836] awk(4327): READ block 9768200 on md3
[  765.632843] awk(4327): READ block 9768208 on md3
[  765.632846] awk(4327): READ block 9768216 on md3
[  765.632849] awk(4327): READ block 9768224 on md3
[  765.632851] awk(4327): READ block 9768232 on md3
[  765.632854] awk(4327): READ block 9768240 on md3
[  765.632857] awk(4327): READ block 9768248 on md3
[  765.632860] awk(4327): READ block 9768256 on md3
[  765.632868] awk(4327): READ block 9768272 on md3
[  765.636835] uniq(4331): READ block 9098992 on md3
[  765.639739] awk(4327): READ block 9768544 on md3
[  765.649084] awk(4327): READ block 9768432 on md3
[  765.656835] awk(4327): READ block 8398752 on md3
[  765.656835] awk(4327): READ block 8398760 on md3
[  765.656835] awk(4327): READ block 8398768 on md3
[  765.656835] awk(4327): READ block 8398784 on md3
[  765.665084] awk(4327): READ block 8399360 on md3
[  765.680840] cat(4342): dirtied inode 10449 (write_accesses_1) on tmpfs
[  766.695642] diff(4355): dirtied inode 10463 (dmesg_next) on tmpfs
[  766.699643] cat(4365): dirtied inode 10472 (write_accesses_2) on tmpfs
[  766.699851] cat(4366): dirtied inode 10480 (read_accesses_2) on tmpfs
[  768.243779] diff(4378): dirtied inode 10486 (dmesg_next) on tmpfs
[  768.247780] cat(4388): dirtied inode 10495 (write_accesses_3) on tmpfs
[  769.244968] diff(4392): dirtied inode 10509 (dmesg_next) on tmpfs
[  769.341001] cat(4412): dirtied inode 10527 (read_accesses_4) on tmpfs
[  770.341032] dmesg(4414): dirtied inode 10532 (dmesg_next) on tmpfs
[  770.350000] cat(4434): dirtied inode 10541 (write_accesses_5) on tmpfs
[  771.530834] dmesg(4437): dirtied inode 10555 (dmesg_next) on tmpfs
[  771.934699] cat(4457): dirtied inode 10564 (write_accesses_6) on tmpfs
[  772.937772] dmesg(4460): dirtied inode 10578 (dmesg_next) on tmpfs
[  773.133573] cat(4480): dirtied inode 10587 (write_accesses_7) on tmpfs
[  773.133573] cat(4481): dirtied inode 10596 (read_accesses_7) on tmpfs
[  774.141215] dmesg(4483): dirtied inode 10601 (dmesg_next) on tmpfs
[  774.564704] cat(4503): dirtied inode 10610 (write_accesses_8) on tmpfs
[  774.564704] cat(4504): dirtied inode 10619 (read_accesses_8) on tmpfs
[  775.596162] dmesg(4506): dirtied inode 10624 (dmesg_next) on tmpfs
[  775.603904] cat(4526): dirtied inode 10633 (write_accesses_9) on tmpfs
[  776.796494] diff(4539): dirtied inode 10647 (dmesg_next) on tmpfs
[  776.796494] cat(4549): dirtied inode 10656 (write_accesses_10) on tmpfs
[  778.228980] diff(4553): dirtied inode 10670 (dmesg_next) on tmpfs
[  778.242555] cat(4573): dirtied inode 10688 (read_accesses_11) on tmpfs
[  779.420481] dmesg(4575): dirtied inode 10693 (dmesg_next) on tmpfs
[  779.876449] cat(4595): dirtied inode 10702 (write_accesses_12) on tmpfs
[  779.876449] cat(4596): dirtied inode 10711 (read_accesses_12) on tmpfs
[  780.873748] dmesg(4598): dirtied inode 10716 (dmesg_next) on tmpfs
[  780.885388] cat(4618): dirtied inode 10725 (write_accesses_13) on tmpfs
[  780.885388] cat(4619): dirtied inode 10734 (read_accesses_13) on tmpfs
[  782.061382] dmesg(4621): dirtied inode 10739 (dmesg_next) on tmpfs
[  782.073537] cat(4641): dirtied inode 10748 (write_accesses_14) on tmpfs
[  783.097230] dmesg(4644): dirtied inode 10762 (dmesg_next) on tmpfs
[  783.289200] cat(4664): dirtied inode 10771 (write_accesses_15) on tmpfs
[  783.289200] cat(4665): dirtied inode 10780 (read_accesses_15) on tmpfs
[  784.297200] dmesg(4667): dirtied inode 10785 (dmesg_next) on tmpfs
[  784.792721] cat(4687): dirtied inode 10794 (write_accesses_16) on tmpfs
[  784.792721] cat(4688): dirtied inode 10803 (read_accesses_16) on tmpfs
[  785.793032] dmesg(4690): dirtied inode 10808 (dmesg_next) on tmpfs
[  785.800721] cat(4710): dirtied inode 10817 (write_accesses_17) on tmpfs
[  786.809821] diff(4723): dirtied inode 10831 (dmesg_next) on tmpfs
[  786.815006] cat(4733): dirtied inode 10840 (write_accesses_18) on tmpfs
[  787.815777] dmesg(4736): dirtied inode 10854 (dmesg_next) on tmpfs
[  787.837475] cat(4756): dirtied inode 10863 (write_accesses_19) on tmpfs
[  788.833007] dmesg(4759): dirtied inode 10877 (dmesg_next) on tmpfs
[  788.860578] cat(4779): dirtied inode 10886 (write_accesses_20) on tmpfs
[  789.894393] dmesg(4782): dirtied inode 10900 (dmesg_next) on tmpfs
[  789.898205] cat(4802): dirtied inode 10909 (write_accesses_21) on tmpfs
[  790.915619] diff(4815): dirtied inode 10923 (dmesg_next) on tmpfs
[  790.915619] cat(4825): dirtied inode 10932 (write_accesses_22) on tmpfs
[  791.975208] diff(4838): dirtied inode 10946 (dmesg_next) on tmpfs
[  791.979256] cat(4848): dirtied inode 10955 (write_accesses_23) on tmpfs
[  791.979257] cat(4849): dirtied inode 10964 (read_accesses_23) on tmpfs
[  792.980171] dmesg(4851): dirtied inode 10969 (dmesg_next) on tmpfs
[  793.045383] cat(4871): dirtied inode 10978 (write_accesses_24) on tmpfs
[  794.116424] dmesg(4874): dirtied inode 10992 (dmesg_next) on tmpfs
[  794.123047] cat(4894): dirtied inode 11001 (write_accesses_25) on tmpfs
[  794.123047] cat(4895): dirtied inode 11010 (read_accesses_25) on tmpfs
[  795.132837] diff(4907): dirtied inode 11015 (dmesg_next) on tmpfs
[  795.136607] cat(4917): dirtied inode 11024 (write_accesses_26) on tmpfs
[  796.137000] diff(4921): dirtied inode 11038 (dmesg_next) on tmpfs
[  796.146300] cat(4940): dirtied inode 11047 (write_accesses_27) on tmpfs
[  796.146300] cat(4941): dirtied inode 11056 (read_accesses_27) on tmpfs
[  797.146859] dmesg(4943): dirtied inode 11061 (dmesg_next) on tmpfs
[  797.246607] cat(4963): dirtied inode 11070 (write_accesses_28) on tmpfs
[  798.350273] dmesg(4966): dirtied inode 11084 (dmesg_next) on tmpfs
[  798.359815] cat(4986): dirtied inode 11093 (write_accesses_29) on tmpfs
[  799.363984] dmesg(4989): dirtied inode 11107 (dmesg_next) on tmpfs
[  799.477241] cat(5009): dirtied inode 11116 (write_accesses_30) on tmpfs
[  800.481322] diff(5013): dirtied inode 11130 (dmesg_next) on tmpfs
[  801.658319] diff(5036): dirtied inode 11153 (dmesg_next) on tmpfs
[  801.795692] cat(5055): dirtied inode 11162 (write_accesses_32) on tmpfs
[  801.795692] cat(5056): dirtied inode 11171 (read_accesses_32) on tmpfs
[  802.797730] dmesg(5058): dirtied inode 11176 (dmesg_next) on tmpfs
[  802.805720] cat(5078): dirtied inode 11185 (write_accesses_33) on tmpfs
[  803.807576] dmesg(5081): dirtied inode 11199 (dmesg_next) on tmpfs
[  803.959161] cat(5101): dirtied inode 11208 (write_accesses_34) on tmpfs
[  803.959402] cat(5102): dirtied inode 11217 (read_accesses_34) on tmpfs
[  804.968707] diff(5114): dirtied inode 11222 (dmesg_next) on tmpfs
[  805.126067] cat(5124): dirtied inode 11231 (write_accesses_35) on tmpfs
[  806.129210] dmesg(5127): dirtied inode 11245 (dmesg_next) on tmpfs
[  806.303108] cat(5147): dirtied inode 11254 (write_accesses_36) on tmpfs
[  806.303108] cat(5148): dirtied inode 11263 (read_accesses_36) on tmpfs
[  807.303998] dmesg(5150): dirtied inode 11268 (dmesg_next) on tmpfs
[  807.313250] cat(5170): dirtied inode 11277 (write_accesses_37) on tmpfs
[  807.313250] cat(5171): dirtied inode 11286 (read_accesses_37) on tmpfs
[  808.310769] dmesg(5173): dirtied inode 11291 (dmesg_next) on tmpfs
[  808.498329] cat(5193): dirtied inode 11300 (write_accesses_38) on tmpfs
[  809.692708] dmesg(5196): dirtied inode 11314 (dmesg_next) on tmpfs
[  809.699467] cat(5216): dirtied inode 11323 (write_accesses_39) on tmpfs
[  809.700497] cat(5217): dirtied inode 11332 (read_accesses_39) on tmpfs
[  810.703486] diff(5220): dirtied inode 11337 (dmesg_next) on tmpfs
[  810.716479] cat(5239): dirtied inode 11346 (write_accesses_40) on tmpfs
[  810.716479] cat(5240): dirtied inode 11355 (read_accesses_40) on tmpfs
[  811.717030] dmesg(5242): dirtied inode 11360 (dmesg_next) on tmpfs
[  811.725017] cat(5262): dirtied inode 11369 (write_accesses_41) on tmpfs
[  812.951791] diff(5275): dirtied inode 11383 (dmesg_next) on tmpfs
[  812.955735] cat(5285): dirtied inode 11392 (write_accesses_42) on tmpfs
[  812.955735] cat(5286): dirtied inode 11401 (read_accesses_42) on tmpfs
[  813.956266] dmesg(5288): dirtied inode 11406 (dmesg_next) on tmpfs
[  813.966776] cat(5308): dirtied inode 11415 (write_accesses_43) on tmpfs
[  814.971793] dmesg(5311): dirtied inode 11429 (dmesg_next) on tmpfs
[  815.216769] cat(5331): dirtied inode 11438 (write_accesses_44) on tmpfs
[  816.230846] diff(5344): dirtied inode 11452 (dmesg_next) on tmpfs
[  816.230846] cat(5354): dirtied inode 11461 (write_accesses_45) on tmpfs
[  817.488744] diff(5367): dirtied inode 11475 (dmesg_next) on tmpfs
[  817.492976] cat(5378): dirtied inode 11493 (read_accesses_46) on tmpfs
[  818.489989] dmesg(5380): dirtied inode 11498 (dmesg_next) on tmpfs
[  818.760614] cat(5400): dirtied inode 11507 (write_accesses_47) on tmpfs
[  819.760802] dmesg(5403): dirtied inode 11521 (dmesg_next) on tmpfs
[  820.040758] cat(5423): dirtied inode 11530 (write_accesses_48) on tmpfs
[  821.325241] dmesg(5426): dirtied inode 11544 (dmesg_next) on tmpfs
[  821.331885] cat(5446): dirtied inode 11553 (write_accesses_49) on tmpfs
[  821.334812] cat(5447): dirtied inode 11562 (read_accesses_49) on tmpfs
[  822.340246] diff(5450): dirtied inode 11567 (dmesg_next) on tmpfs
[  822.637298] cat(5470): dirtied inode 11585 (read_accesses_50) on tmpfs
[  823.918483] dmesg(5472): dirtied inode 11590 (dmesg_next) on tmpfs
[  823.926455] cat(5492): dirtied inode 11599 (write_accesses_51) on tmpfs
[  824.927934] dmesg(5495): dirtied inode 11613 (dmesg_next) on tmpfs
[  825.240835] cat(5515): dirtied inode 11622 (write_accesses_52) on tmpfs
[  826.255144] diff(5528): dirtied inode 11636 (dmesg_next) on tmpfs
[  826.575172] cat(5538): dirtied inode 11645 (write_accesses_53) on tmpfs
[  827.578675] dmesg(5541): dirtied inode 11659 (dmesg_next) on tmpfs
[  827.921115] cat(5561): dirtied inode 11668 (write_accesses_54) on tmpfs
[  828.923620] dmesg(5564): dirtied inode 11682 (dmesg_next) on tmpfs
[  829.207516] cat(5584): dirtied inode 11691 (write_accesses_55) on tmpfs
[  830.212796] dmesg(5587): dirtied inode 11705 (dmesg_next) on tmpfs
[  830.563350] cat(5607): dirtied inode 11714 (write_accesses_56) on tmpfs
[  830.563555] cat(5608): dirtied inode 11723 (read_accesses_56) on tmpfs
[  831.577225] diff(5620): dirtied inode 11728 (dmesg_next) on tmpfs
[  831.932973] cat(5630): dirtied inode 11737 (write_accesses_57) on tmpfs
[  832.936478] dmesg(5633): dirtied inode 11751 (dmesg_next) on tmpfs
[  833.315593] cat(5653): dirtied inode 11760 (write_accesses_58) on tmpfs
[  834.317429] dmesg(5656): dirtied inode 11774 (dmesg_next) on tmpfs
[  834.599475] cat(5676): dirtied inode 11783 (write_accesses_59) on tmpfs
[  835.604747] dmesg(5679): dirtied inode 11797 (dmesg_next) on tmpfs
[  835.991417] cat(5699): dirtied inode 11806 (write_accesses_60) on tmpfs
[  835.993835] cat(5700): dirtied inode 11815 (read_accesses_60) on tmpfs
[  836.997441] diff(5703): dirtied inode 11820 (dmesg_next) on tmpfs
[  838.398422] dmesg(5725): dirtied inode 11843 (dmesg_next) on tmpfs
[  838.806655] cat(5745): dirtied inode 11852 (write_accesses_62) on tmpfs
[  840.091206] dmesg(5748): dirtied inode 11866 (dmesg_next) on tmpfs
[  840.099180] cat(5768): dirtied inode 11875 (write_accesses_63) on tmpfs
[  841.525732] diff(5781): dirtied inode 11889 (dmesg_next) on tmpfs
[  841.529731] cat(5791): dirtied inode 11898 (write_accesses_64) on tmpfs
[  841.529731] cat(5792): dirtied inode 11907 (read_accesses_64) on tmpfs
[  842.625119] dmesg(5794): dirtied inode 11912 (dmesg_next) on tmpfs
[  842.630735] cat(5814): dirtied inode 11921 (write_accesses_65) on tmpfs
[  844.085339] diff(5827): dirtied inode 11935 (dmesg_next) on tmpfs
[  844.089031] cat(5837): dirtied inode 11944 (write_accesses_66) on tmpfs
[  844.089031] cat(5838): dirtied inode 11953 (read_accesses_66) on tmpfs
[  845.089646] dmesg(5840): dirtied inode 11958 (dmesg_next) on tmpfs
[  845.375414] cat(5860): dirtied inode 11967 (write_accesses_67) on tmpfs
[  846.380161] dmesg(5863): dirtied inode 11981 (dmesg_next) on tmpfs
[  846.845163] cat(5883): dirtied inode 11990 (write_accesses_68) on tmpfs
[  848.319810] diff(5896): dirtied inode 12004 (dmesg_next) on tmpfs
[  848.326074] cat(5906): dirtied inode 12013 (write_accesses_69) on tmpfs
[  848.326074] cat(5907): dirtied inode 12022 (read_accesses_69) on tmpfs
[  849.323542] dmesg(5909): dirtied inode 12027 (dmesg_next) on tmpfs
[  849.339261] cat(5929): dirtied inode 12036 (write_accesses_70) on tmpfs
[  849.808701] cat(5930): dirtied inode 12045 (read_accesses_70) on tmpfs
[  851.088737] dmesg(5932): dirtied inode 12050 (dmesg_next) on tmpfs
[  851.096428] cat(5952): dirtied inode 12059 (write_accesses_71) on tmpfs
[  852.098491] dmesg(5955): dirtied inode 12073 (dmesg_next) on tmpfs
[  852.588340] cat(5975): dirtied inode 12082 (write_accesses_72) on tmpfs
[  853.592372] diff(5979): dirtied inode 12096 (dmesg_next) on tmpfs
[  854.044575] cat(5999): dirtied inode 12114 (read_accesses_73) on tmpfs
[  855.047932] dmesg(6001): dirtied inode 12119 (dmesg_next) on tmpfs
[  855.334101] cat(6021): dirtied inode 12128 (write_accesses_74) on tmpfs
[  856.576762] dmesg(6024): dirtied inode 12142 (dmesg_next) on tmpfs
[  856.584729] cat(6044): dirtied inode 12151 (write_accesses_75) on tmpfs
[  857.870720] diff(6048): dirtied inode 12165 (dmesg_next) on tmpfs
[  857.911306] cat(6068): dirtied inode 12183 (read_accesses_76) on tmpfs
[  859.120374] dmesg(6070): dirtied inode 12188 (dmesg_next) on tmpfs
[  859.168321] cat(6090): dirtied inode 12197 (write_accesses_77) on tmpfs
[  859.168321] cat(6091): dirtied inode 12206 (read_accesses_77) on tmpfs
[  860.570929] dmesg(6093): dirtied inode 12211 (dmesg_next) on tmpfs
[  860.627646] cat(6113): dirtied inode 12220 (write_accesses_78) on tmpfs
[  861.812753] diff(6117): dirtied inode 12234 (dmesg_next) on tmpfs
[  861.882667] cat(6136): dirtied inode 12243 (write_accesses_79) on tmpfs
[  863.103014] dmesg(6139): dirtied inode 12257 (dmesg_next) on tmpfs
[  863.183005] cat(6159): dirtied inode 12266 (write_accesses_80) on tmpfs
[  864.180480] diff(6163): dirtied inode 12280 (dmesg_next) on tmpfs
[  864.358076] cat(6183): dirtied inode 12298 (read_accesses_81) on tmpfs
[  865.358151] dmesg(6185): dirtied inode 12303 (dmesg_next) on tmpfs
[  865.562082] cat(6205): dirtied inode 12312 (write_accesses_82) on tmpfs
[  867.010309] dmesg(6208): dirtied inode 12326 (dmesg_next) on tmpfs
[  867.018271] cat(6228): dirtied inode 12335 (write_accesses_83) on tmpfs
[  867.022277] cat(6229): dirtied inode 12344 (read_accesses_83) on tmpfs
[  868.221770] dmesg(6231): dirtied inode 12349 (dmesg_next) on tmpfs
[  868.335430] cat(6251): dirtied inode 12358 (write_accesses_84) on tmpfs
[  869.466367] dmesg(6254): dirtied inode 12372 (dmesg_next) on tmpfs
[  869.474329] cat(6274): dirtied inode 12381 (write_accesses_85) on tmpfs
[  870.753724] dmesg(6277): dirtied inode 12395 (dmesg_next) on tmpfs
[  870.765056] cat(6297): dirtied inode 12404 (write_accesses_86) on tmpfs
[  870.766373] cat(6298): dirtied inode 12413 (read_accesses_86) on tmpfs
[  871.877232] dmesg(6300): dirtied inode 12418 (dmesg_next) on tmpfs
[  871.886709] cat(6320): dirtied inode 12427 (write_accesses_87) on tmpfs
[  873.336407] dmesg(6323): dirtied inode 12441 (dmesg_next) on tmpfs
[  873.350087] cat(6343): dirtied inode 12450 (write_accesses_88) on tmpfs
[  874.583197] diff(6356): dirtied inode 12464 (dmesg_next) on tmpfs
[  874.587686] cat(6366): dirtied inode 12473 (write_accesses_89) on tmpfs
[  875.865436] dmesg(6369): dirtied inode 12487 (dmesg_next) on tmpfs
[  876.035963] cat(6389): dirtied inode 12496 (write_accesses_90) on tmpfs
[  877.119425] dmesg(6392): dirtied inode 12510 (dmesg_next) on tmpfs
[  877.127382] cat(6412): dirtied inode 12519 (write_accesses_91) on tmpfs
[  878.406763] dmesg(6415): dirtied inode 12533 (dmesg_next) on tmpfs
[  878.414927] cat(6436): dirtied inode 12551 (read_accesses_92) on tmpfs
[  879.681431] diff(6448): dirtied inode 12556 (dmesg_next) on tmpfs
[  879.685437] cat(6459): dirtied inode 12574 (read_accesses_93) on tmpfs
[  880.681493] dmesg(6461): dirtied inode 12579 (dmesg_next) on tmpfs
[  880.781694] cat(6481): dirtied inode 12588 (write_accesses_94) on tmpfs
[  881.826690] dmesg(6484): dirtied inode 12602 (dmesg_next) on tmpfs
[  881.833445] cat(6504): dirtied inode 12611 (write_accesses_95) on tmpfs
[  883.120460] diff(6508): dirtied inode 12625 (dmesg_next) on tmpfs
[  883.313029] cat(6528): dirtied inode 12643 (read_accesses_96) on tmpfs
[  884.333892] dmesg(6530): dirtied inode 12648 (dmesg_next) on tmpfs
[  884.565845] cat(6550): dirtied inode 12657 (write_accesses_97) on tmpfs
[  884.565845] cat(6551): dirtied inode 12666 (read_accesses_97) on tmpfs
[  885.567901] dmesg(6553): dirtied inode 12671 (dmesg_next) on tmpfs
[  885.975728] cat(6573): dirtied inode 12680 (write_accesses_98) on tmpfs
[  886.978005] dmesg(6576): dirtied inode 12694 (dmesg_next) on tmpfs
[  888.451842] diff(6609): dirtied inode 12717 (dmesg_next) on tmpfs
[  888.455842] cat(6619): dirtied inode 12726 (write_accesses_100) on tmpfs
[  889.455889] dmesg(6622): dirtied inode 12740 (dmesg_next) on tmpfs
[  889.465359] cat(6642): dirtied inode 12749 (write_accesses_101) on tmpfs
[  890.743429] dmesg(6645): dirtied inode 12763 (dmesg_next) on tmpfs
[  890.749394] cat(6665): dirtied inode 12772 (write_accesses_102) on tmpfs
[  891.923889] diff(6678): dirtied inode 12786 (dmesg_next) on tmpfs
[  891.928369] cat(6688): dirtied inode 12795 (write_accesses_103) on tmpfs
[  892.953018] diff(6692): dirtied inode 12809 (dmesg_next) on tmpfs
[  892.961148] cat(6711): dirtied inode 12818 (write_accesses_104) on tmpfs
[  892.961148] cat(6712): dirtied inode 12827 (read_accesses_104) on tmpfs
[  894.148519] dmesg(6714): dirtied inode 12832 (dmesg_next) on tmpfs
[  894.454351] cat(6734): dirtied inode 12841 (write_accesses_105) on tmpfs
[  895.463549] diff(6747): dirtied inode 12855 (dmesg_next) on tmpfs
[  895.469747] cat(6757): dirtied inode 12864 (write_accesses_106) on tmpfs
[  895.471447] cat(6758): dirtied inode 12873 (read_accesses_106) on tmpfs
[  896.475375] dmesg(6760): dirtied inode 12878 (dmesg_next) on tmpfs
[  896.488842] cat(6780): dirtied inode 12887 (write_accesses_107) on tmpfs
[  897.932945] dmesg(6783): dirtied inode 12901 (dmesg_next) on tmpfs
[  897.942429] cat(6803): dirtied inode 12910 (write_accesses_108) on tmpfs
[  899.129500] diff(6807): dirtied inode 12924 (dmesg_next) on tmpfs
[  900.478084] dmesg(6829): dirtied inode 12947 (dmesg_next) on tmpfs
[  900.668040] cat(6849): dirtied inode 12956 (write_accesses_110) on tmpfs
[  901.674425] dmesg(6852): dirtied inode 12970 (dmesg_next) on tmpfs
[  902.036836] cat(6872): dirtied inode 12979 (write_accesses_111) on tmpfs
[  902.037410] cat(6873): dirtied inode 12988 (read_accesses_111) on tmpfs
[  903.224855] dmesg(6875): dirtied inode 12993 (dmesg_next) on tmpfs
[  903.237365] cat(6895): dirtied inode 13002 (write_accesses_112) on tmpfs
[  903.237365] cat(6896): dirtied inode 13011 (read_accesses_112) on tmpfs
[  904.313117] dmesg(6898): dirtied inode 13016 (dmesg_next) on tmpfs
[  904.323475] cat(6918): dirtied inode 13025 (write_accesses_113) on tmpfs
[  905.528059] diff(6931): dirtied inode 13039 (dmesg_next) on tmpfs
[  905.532054] cat(6941): dirtied inode 13048 (write_accesses_114) on tmpfs
[  905.532054] cat(6942): dirtied inode 13057 (read_accesses_114) on tmpfs
[  906.532110] dmesg(6944): dirtied inode 13062 (dmesg_next) on tmpfs
[  906.540591] cat(6964): dirtied inode 13071 (write_accesses_115) on tmpfs
[  907.942817] dmesg(6967): dirtied inode 13085 (dmesg_next) on tmpfs
[  908.134791] cat(6987): dirtied inode 13094 (write_accesses_116) on tmpfs
[  909.141043] diff(6991): dirtied inode 13108 (dmesg_next) on tmpfs
[  909.569009] cat(7011): dirtied inode 13126 (read_accesses_117) on tmpfs
[  910.598250] dmesg(7013): dirtied inode 13131 (dmesg_next) on tmpfs
[  910.790223] cat(7033): dirtied inode 13140 (write_accesses_118) on tmpfs
[  911.792613] dmesg(7036): dirtied inode 13154 (dmesg_next) on tmpfs
[  911.798593] cat(7057): dirtied inode 13172 (read_accesses_119) on tmpfs
[  913.238549] diff(7060): dirtied inode 13177 (dmesg_next) on tmpfs
[  913.430521] cat(7080): dirtied inode 13195 (read_accesses_120) on tmpfs
[  914.431044] dmesg(7082): dirtied inode 13200 (dmesg_next) on tmpfs
[  914.444501] cat(7102): dirtied inode 13209 (write_accesses_121) on tmpfs
[  915.896874] dmesg(7105): dirtied inode 13223 (dmesg_next) on tmpfs
[  916.089267] cat(7125): dirtied inode 13232 (write_accesses_122) on tmpfs
[  917.092028] diff(7129): dirtied inode 13246 (dmesg_next) on tmpfs
[  918.116772] dmesg(7151): dirtied inode 13269 (dmesg_next) on tmpfs
[  918.180452] cat(7171): dirtied inode 13278 (write_accesses_124) on tmpfs
[  919.186799] dmesg(7174): dirtied inode 13292 (dmesg_next) on tmpfs
[  919.193987] cat(7194): dirtied inode 13301 (write_accesses_125) on tmpfs
[  920.682462] diff(7198): dirtied inode 13315 (dmesg_next) on tmpfs
[  920.695417] cat(7218): dirtied inode 13333 (read_accesses_126) on tmpfs
[  921.690950] dmesg(7220): dirtied inode 13338 (dmesg_next) on tmpfs
[  921.707828] cat(7240): dirtied inode 13347 (write_accesses_127) on tmpfs
[  922.729878] dmesg(7243): dirtied inode 13361 (dmesg_next) on tmpfs
[  922.740940] cat(7263): dirtied inode 13370 (write_accesses_128) on tmpfs
[  923.741165] dmesg(7266): dirtied inode 13384 (dmesg_next) on tmpfs
[  923.776489] cat(7286): dirtied inode 13393 (write_accesses_129) on tmpfs
[  924.820556] dmesg(7289): dirtied inode 13407 (dmesg_next) on tmpfs
[  924.826641] cat(7309): dirtied inode 13416 (write_accesses_130) on tmpfs
[  924.826986] cat(7310): dirtied inode 13425 (read_accesses_130) on tmpfs
[  925.838566] diff(7313): dirtied inode 13430 (dmesg_next) on tmpfs
[  925.847562] cat(7332): dirtied inode 13439 (write_accesses_131) on tmpfs
[  925.847562] cat(7333): dirtied inode 13448 (read_accesses_131) on tmpfs
[  926.849577] dmesg(7335): dirtied inode 13453 (dmesg_next) on tmpfs
[  926.859048] cat(7355): dirtied inode 13462 (write_accesses_132) on tmpfs
[  927.866588] diff(7359): dirtied inode 13476 (dmesg_next) on tmpfs
[  928.872937] dmesg(7381): dirtied inode 13499 (dmesg_next) on tmpfs
[  928.957813] cat(7401): dirtied inode 13508 (write_accesses_134) on tmpfs
[  929.960702] dmesg(7404): dirtied inode 13522 (dmesg_next) on tmpfs
[  930.049203] cat(7424): dirtied inode 13531 (write_accesses_135) on tmpfs
[  931.055243] diff(7428): dirtied inode 13545 (dmesg_next) on tmpfs
[  931.159261] cat(7447): dirtied inode 13554 (write_accesses_136) on tmpfs
[  931.165926] cat(7448): dirtied inode 13563 (read_accesses_136) on tmpfs
[  932.163431] dmesg(7450): dirtied inode 13568 (dmesg_next) on tmpfs
[  932.276573] cat(7470): dirtied inode 13577 (write_accesses_137) on tmpfs
[  933.280961] dmesg(7473): dirtied inode 13591 (dmesg_next) on tmpfs
[  934.295069] diff(7497): dirtied inode 13614 (dmesg_next) on tmpfs
[  934.304461] cat(7517): dirtied inode 13632 (read_accesses_139) on tmpfs
[  935.306745] dmesg(7519): dirtied inode 13637 (dmesg_next) on tmpfs
[  935.318188] cat(7539): dirtied inode 13646 (write_accesses_140) on tmpfs
[  936.464208] dmesg(7542): dirtied inode 13660 (dmesg_next) on tmpfs
[  936.472676] cat(7562): dirtied inode 13669 (write_accesses_141) on tmpfs
[  936.474973] cat(7563): dirtied inode 13678 (read_accesses_141) on tmpfs
[  937.475219] dmesg(7565): dirtied inode 13683 (dmesg_next) on tmpfs
[  937.485535] cat(7585): dirtied inode 13692 (write_accesses_142) on tmpfs
[  938.654128] diff(7598): dirtied inode 13706 (dmesg_next) on tmpfs
[  938.658362] cat(7608): dirtied inode 13715 (write_accesses_143) on tmpfs
[  938.658362] cat(7609): dirtied inode 13724 (read_accesses_143) on tmpfs
[  939.655484] dmesg(7611): dirtied inode 13729 (dmesg_next) on tmpfs
[  939.837764] cat(7631): dirtied inode 13738 (write_accesses_144) on tmpfs
[  940.840540] dmesg(7634): dirtied inode 13752 (dmesg_next) on tmpfs
[  941.024787] cat(7654): dirtied inode 13761 (write_accesses_145) on tmpfs
[  942.032292] diff(7658): dirtied inode 13775 (dmesg_next) on tmpfs
[  942.226107] cat(7677): dirtied inode 13784 (write_accesses_146) on tmpfs
[  942.227445] cat(7678): dirtied inode 13793 (read_accesses_146) on tmpfs
[  943.228417] dmesg(7680): dirtied inode 13798 (dmesg_next) on tmpfs
[  943.437244] cat(7700): dirtied inode 13807 (write_accesses_147) on tmpfs
[  944.446942] diff(7713): dirtied inode 13821 (dmesg_next) on tmpfs
[  944.450943] cat(7723): dirtied inode 13830 (write_accesses_148) on tmpfs
[  944.451191] cat(7724): dirtied inode 13839 (read_accesses_148) on tmpfs
[  945.451350] dmesg(7726): dirtied inode 13844 (dmesg_next) on tmpfs
[  945.679542] cat(7746): dirtied inode 13853 (write_accesses_149) on tmpfs
[  946.682674] dmesg(7749): dirtied inode 13867 (dmesg_next) on tmpfs
[  946.694959] cat(7769): dirtied inode 13876 (write_accesses_150) on tmpfs
[  946.694959] cat(7770): dirtied inode 13885 (read_accesses_150) on tmpfs
[  947.696845] dmesg(7772): dirtied inode 13890 (dmesg_next) on tmpfs
[  947.944206] cat(7792): dirtied inode 13899 (write_accesses_151) on tmpfs
[  949.199015] dmesg(7795): dirtied inode 13913 (dmesg_next) on tmpfs
[  949.208325] cat(7815): dirtied inode 13922 (write_accesses_152) on tmpfs
[  949.209994] cat(7816): dirtied inode 13931 (read_accesses_152) on tmpfs
[  950.210718] dmesg(7818): dirtied inode 13936 (dmesg_next) on tmpfs
[  950.479007] cat(7838): dirtied inode 13945 (write_accesses_153) on tmpfs
[  951.483535] dmesg(7841): dirtied inode 13959 (dmesg_next) on tmpfs
[  951.500419] cat(7861): dirtied inode 13968 (write_accesses_154) on tmpfs
[  951.501328] cat(7862): dirtied inode 13977 (read_accesses_154) on tmpfs
[  952.499141] dmesg(7864): dirtied inode 13982 (dmesg_next) on tmpfs
[  952.791099] cat(7884): dirtied inode 13991 (write_accesses_155) on tmpfs
[  953.792088] dmesg(7887): dirtied inode 14005 (dmesg_next) on tmpfs
[  954.086120] cat(7907): dirtied inode 14014 (write_accesses_156) on tmpfs
[  954.086120] cat(7908): dirtied inode 14023 (read_accesses_156) on tmpfs
[  955.083730] dmesg(7910): dirtied inode 14028 (dmesg_next) on tmpfs
[  955.395695] cat(7930): dirtied inode 14037 (write_accesses_157) on tmpfs
[  956.403171] diff(7934): dirtied inode 14051 (dmesg_next) on tmpfs
[  957.718911] dmesg(7956): dirtied inode 14074 (dmesg_next) on tmpfs
[  958.047199] cat(7976): dirtied inode 14083 (write_accesses_159) on tmpfs
[  959.384644] dmesg(7979): dirtied inode 14097 (dmesg_next) on tmpfs
[  959.393293] cat(7999): dirtied inode 14106 (write_accesses_160) on tmpfs
[  959.393293] cat(8000): dirtied inode 14115 (read_accesses_160) on tmpfs
[  960.397808] dmesg(8002): dirtied inode 14120 (dmesg_next) on tmpfs
[  960.749437] cat(8022): dirtied inode 14129 (write_accesses_161) on tmpfs
[  961.749474] dmesg(8025): dirtied inode 14143 (dmesg_next) on tmpfs
[  962.036495] cat(8045): dirtied inode 14152 (write_accesses_162) on tmpfs
[  963.045838] diff(8049): dirtied inode 14166 (dmesg_next) on tmpfs
[  963.369862] cat(8069): dirtied inode 14184 (read_accesses_163) on tmpfs
[  964.369917] dmesg(8071): dirtied inode 14189 (dmesg_next) on tmpfs
[  964.650787] cat(8091): dirtied inode 14198 (write_accesses_164) on tmpfs
[  966.041304] diff(8104): dirtied inode 14212 (dmesg_next) on tmpfs
[  966.044662] cat(8114): dirtied inode 14221 (write_accesses_165) on tmpfs
[  966.044662] cat(8115): dirtied inode 14230 (read_accesses_165) on tmpfs
[  967.327417] dmesg(8117): dirtied inode 14235 (dmesg_next) on tmpfs
[  967.336909] cat(8137): dirtied inode 14244 (write_accesses_166) on tmpfs
[  968.738523] dmesg(8140): dirtied inode 14258 (dmesg_next) on tmpfs
[  968.750517] cat(8160): dirtied inode 14267 (write_accesses_167) on tmpfs
[  968.750518] cat(8161): dirtied inode 14276 (read_accesses_167) on tmpfs
[  970.160950] dmesg(8163): dirtied inode 14281 (dmesg_next) on tmpfs
[  970.167859] cat(8183): dirtied inode 14290 (write_accesses_168) on tmpfs
[  970.167859] cat(8184): dirtied inode 14299 (read_accesses_168) on tmpfs
[  971.176979] diff(8187): dirtied inode 14304 (dmesg_next) on tmpfs
[  971.493459] cat(8206): dirtied inode 14313 (write_accesses_169) on tmpfs
[  971.494797] cat(8207): dirtied inode 14322 (read_accesses_169) on tmpfs
[  972.494708] dmesg(8209): dirtied inode 14327 (dmesg_next) on tmpfs
[  972.779455] cat(8229): dirtied inode 14336 (write_accesses_170) on tmpfs
[  974.221475] dmesg(8232): dirtied inode 14350 (dmesg_next) on tmpfs
[  974.232225] cat(8252): dirtied inode 14359 (write_accesses_171) on tmpfs
[  975.234989] dmesg(8255): dirtied inode 14373 (dmesg_next) on tmpfs
[  975.521707] cat(8275): dirtied inode 14382 (write_accesses_172) on tmpfs
[  975.525291] cat(8276): dirtied inode 14391 (read_accesses_172) on tmpfs
[  976.525295] dmesg(8278): dirtied inode 14396 (dmesg_next) on tmpfs
[  976.533286] cat(8298): dirtied inode 14405 (write_accesses_173) on tmpfs
[  978.133621] dmesg(8301): dirtied inode 14419 (dmesg_next) on tmpfs
[  978.137822] cat(8321): dirtied inode 14428 (write_accesses_174) on tmpfs
[  978.146712] cat(8322): dirtied inode 14436 (read_accesses_174) on tmpfs
[  979.156111] dmesg(8324): dirtied inode 14442 (dmesg_next) on tmpfs
[  979.644117] cat(8344): dirtied inode 14451 (write_accesses_175) on tmpfs
[  979.644117] cat(8345): dirtied inode 14460 (read_accesses_175) on tmpfs
[  980.647899] dmesg(8347): dirtied inode 14465 (dmesg_next) on tmpfs
[  980.928226] cat(8367): dirtied inode 14474 (write_accesses_176) on tmpfs
[  982.389789] dmesg(8370): dirtied inode 14488 (dmesg_next) on tmpfs
[  982.396784] cat(8391): dirtied inode 14506 (read_accesses_177) on tmpfs
[  983.640010] dmesg(8393): dirtied inode 14511 (dmesg_next) on tmpfs
[  983.648527] cat(8413): dirtied inode 14520 (write_accesses_178) on tmpfs
[  984.928878] diff(8417): dirtied inode 14534 (dmesg_next) on tmpfs
[  984.953420] cat(8436): dirtied inode 14543 (write_accesses_179) on tmpfs
[  984.953420] cat(8437): dirtied inode 14552 (read_accesses_179) on tmpfs
[  986.179928] dmesg(8439): dirtied inode 14557 (dmesg_next) on tmpfs
[  986.224383] cat(8459): dirtied inode 14566 (write_accesses_180) on tmpfs
[  987.472835] dmesg(8462): dirtied inode 14580 (dmesg_next) on tmpfs
[  987.521909] cat(8483): dirtied inode 14598 (read_accesses_181) on tmpfs
[  988.928533] diff(8486): dirtied inode 14603 (dmesg_next) on tmpfs
[  988.937100] cat(8505): dirtied inode 14612 (write_accesses_182) on tmpfs
[  988.937100] cat(8506): dirtied inode 14621 (read_accesses_182) on tmpfs
[  990.184049] dmesg(8508): dirtied inode 14626 (dmesg_next) on tmpfs
[  990.248815] cat(8528): dirtied inode 14635 (write_accesses_183) on tmpfs
[  990.248815] cat(8529): dirtied inode 14644 (read_accesses_183) on tmpfs
[  991.255227] diff(8532): dirtied inode 14649 (dmesg_next) on tmpfs
[  991.335832] cat(8551): dirtied inode 14658 (write_accesses_184) on tmpfs
[  991.335832] cat(8552): dirtied inode 14667 (read_accesses_184) on tmpfs
[  992.547850] dmesg(8554): dirtied inode 14672 (dmesg_next) on tmpfs
[  992.632049] cat(8574): dirtied inode 14681 (write_accesses_185) on tmpfs
[  993.801989] diff(8578): dirtied inode 14695 (dmesg_next) on tmpfs
[  993.901940] cat(8597): dirtied inode 14704 (write_accesses_186) on tmpfs
[  993.901941] cat(8598): dirtied inode 14713 (read_accesses_186) on tmpfs
[  995.256871] dmesg(8600): dirtied inode 14718 (dmesg_next) on tmpfs
[  995.361070] cat(8620): dirtied inode 14727 (write_accesses_187) on tmpfs
[  995.364675] cat(8621): dirtied inode 14736 (read_accesses_187) on tmpfs
[  996.508669] dmesg(8623): dirtied inode 14741 (dmesg_next) on tmpfs
[  996.522148] cat(8643): dirtied inode 14750 (write_accesses_188) on tmpfs
[  997.800277] dmesg(8646): dirtied inode 14764 (dmesg_next) on tmpfs
[  997.928756] cat(8667): dirtied inode 14782 (read_accesses_189) on tmpfs
[  999.050046] diff(8670): dirtied inode 14787 (dmesg_next) on tmpfs
[  999.058544] cat(8689): dirtied inode 14796 (write_accesses_190) on tmpfs
[  999.058544] cat(8690): dirtied inode 14805 (read_accesses_190) on tmpfs
[ 1000.340517] dmesg(8692): dirtied inode 14810 (dmesg_next) on tmpfs
[ 1000.485140] cat(8712): dirtied inode 14819 (write_accesses_191) on tmpfs
[ 1001.792331] diff(8716): dirtied inode 14833 (dmesg_next) on tmpfs
[ 1001.803447] cat(8735): dirtied inode 14842 (write_accesses_192) on tmpfs
[ 1001.803447] cat(8736): dirtied inode 14851 (read_accesses_192) on tmpfs
[ 1002.807779] dmesg(8738): dirtied inode 14856 (dmesg_next) on tmpfs
[ 1003.105616] cat(8758): dirtied inode 14865 (write_accesses_193) on tmpfs
[ 1004.356278] diff(8762): dirtied inode 14879 (dmesg_next) on tmpfs
[ 1004.364209] cat(8781): dirtied inode 14888 (write_accesses_194) on tmpfs
[ 1004.364209] cat(8782): dirtied inode 14897 (read_accesses_194) on tmpfs
[ 1005.483712] dmesg(8784): dirtied inode 14902 (dmesg_next) on tmpfs
[ 1005.668700] cat(8804): dirtied inode 14911 (write_accesses_195) on tmpfs
[ 1005.668700] cat(8805): dirtied inode 14920 (read_accesses_195) on tmpfs
[ 1006.676699] dmesg(8807): dirtied inode 14925 (dmesg_next) on tmpfs
[ 1006.927200] cat(8827): dirtied inode 14934 (write_accesses_196) on tmpfs
[ 1008.188428] diff(8831): dirtied inode 14948 (dmesg_next) on tmpfs
[ 1008.376763] cat(8850): dirtied inode 14957 (write_accesses_197) on tmpfs
[ 1008.377992] cat(8851): dirtied inode 14966 (read_accesses_197) on tmpfs
[ 1009.421522] dmesg(8853): dirtied inode 14971 (dmesg_next) on tmpfs
[ 1009.430030] cat(8873): dirtied inode 14980 (write_accesses_198) on tmpfs
[ 1010.711071] diff(8877): dirtied inode 14994 (dmesg_next) on tmpfs
[ 1010.899186] cat(8896): dirtied inode 15003 (write_accesses_199) on tmpfs
[ 1010.900412] cat(8897): dirtied inode 15012 (read_accesses_199) on tmpfs
[ 1011.922168] dmesg(8899): dirtied inode 15017 (dmesg_next) on tmpfs
[ 1012.160934] cat(8919): dirtied inode 15026 (write_accesses_200) on tmpfs
[ 1013.211452] diff(8923): dirtied inode 15040 (dmesg_next) on tmpfs
[ 1013.403982] cat(8942): dirtied inode 15049 (write_accesses_201) on tmpfs
[ 1013.403982] cat(8943): dirtied inode 15058 (read_accesses_201) on tmpfs
[ 1014.599561] dmesg(8945): dirtied inode 15063 (dmesg_next) on tmpfs
[ 1014.605093] cat(8965): dirtied inode 15072 (write_accesses_202) on tmpfs
[ 1015.653317] dmesg(8968): dirtied inode 15086 (dmesg_next) on tmpfs
[ 1015.660059] cat(8988): dirtied inode 15095 (write_accesses_203) on tmpfs
[ 1015.665106] cat(8989): dirtied inode 15104 (read_accesses_203) on tmpfs
[ 1016.665570] dmesg(8991): dirtied inode 15109 (dmesg_next) on tmpfs
[ 1016.675081] cat(9011): dirtied inode 15118 (write_accesses_204) on tmpfs
[ 1017.956111] dmesg(9014): dirtied inode 15132 (dmesg_next) on tmpfs
[ 1017.962127] cat(9034): dirtied inode 15141 (write_accesses_205) on tmpfs
[ 1017.963895] cat(9035): dirtied inode 15150 (read_accesses_205) on tmpfs
[ 1018.969674] diff(9038): dirtied inode 15155 (dmesg_next) on tmpfs
[ 1018.976266] cat(9057): dirtied inode 15164 (write_accesses_206) on tmpfs
[ 1018.976266] cat(9058): dirtied inode 15173 (read_accesses_206) on tmpfs
[ 1020.426869] dmesg(9060): dirtied inode 15178 (dmesg_next) on tmpfs
[ 1020.618849] cat(9081): dirtied inode 15196 (read_accesses_207) on tmpfs
[ 1021.626849] dmesg(9083): dirtied inode 15201 (dmesg_next) on tmpfs
[ 1021.942813] cat(9103): dirtied inode 15210 (write_accesses_208) on tmpfs
[ 1021.942813] cat(9104): dirtied inode 15219 (read_accesses_208) on tmpfs
[ 1022.945266] dmesg(9106): dirtied inode 15224 (dmesg_next) on tmpfs
[ 1022.953861] cat(9126): dirtied inode 15233 (write_accesses_209) on tmpfs
[ 1022.957645] cat(9127): dirtied inode 15242 (read_accesses_209) on tmpfs
[ 1023.963691] diff(9130): dirtied inode 15247 (dmesg_next) on tmpfs
[ 1023.970181] cat(9149): dirtied inode 15256 (write_accesses_210) on tmpfs
[ 1023.970181] cat(9150): dirtied inode 15265 (read_accesses_210) on tmpfs
[ 1025.301905] dmesg(9152): dirtied inode 15270 (dmesg_next) on tmpfs
[ 1026.620938] diff(9176): dirtied inode 15293 (dmesg_next) on tmpfs
[ 1026.628590] cat(9195): dirtied inode 15302 (write_accesses_212) on tmpfs
[ 1026.628590] cat(9196): dirtied inode 15311 (read_accesses_212) on tmpfs
[ 1027.629981] dmesg(9198): dirtied inode 15316 (dmesg_next) on tmpfs
[ 1027.823194] cat(9218): dirtied inode 15325 (write_accesses_213) on tmpfs
[ 1027.823562] cat(9219): dirtied inode 15334 (read_accesses_213) on tmpfs
[ 1028.831105] dmesg(9221): dirtied inode 15339 (dmesg_next) on tmpfs
[ 1029.206013] cat(9241): dirtied inode 15348 (write_accesses_214) on tmpfs
[ 1029.206038] cat(9242): dirtied inode 15357 (read_accesses_214) on tmpfs
[ 1030.396448] dmesg(9244): dirtied inode 15362 (dmesg_next) on tmpfs
[ 1030.401416] cat(9264): dirtied inode 15371 (write_accesses_215) on tmpfs
[ 1030.401416] cat(9265): dirtied inode 15380 (read_accesses_215) on tmpfs
[ 1031.403869] dmesg(9267): dirtied inode 15385 (dmesg_next) on tmpfs
[ 1031.415660] cat(9287): dirtied inode 15394 (write_accesses_216) on tmpfs
[ 1031.415660] cat(9288): dirtied inode 15403 (read_accesses_216) on tmpfs
[ 1032.804163] dmesg(9290): dirtied inode 15408 (dmesg_next) on tmpfs
[ 1033.055856] cat(9310): dirtied inode 15417 (write_accesses_217) on tmpfs
[ 1034.471872] dmesg(9313): dirtied inode 15431 (dmesg_next) on tmpfs
[ 1034.477084] cat(9333): dirtied inode 15440 (write_accesses_218) on tmpfs
[ 1034.484714] cat(9334): dirtied inode 15449 (read_accesses_218) on tmpfs
[ 1035.486685] dmesg(9336): dirtied inode 15454 (dmesg_next) on tmpfs
[ 1035.679219] cat(9356): dirtied inode 15463 (write_accesses_219) on tmpfs
[ 1036.681651] diff(9360): dirtied inode 15477 (dmesg_next) on tmpfs
[ 1037.122902] cat(9379): dirtied inode 15486 (write_accesses_220) on tmpfs
[ 1189.246874] md: md4 stopped.
[ 1189.840012] md: bind<sdb3>
[ 1189.840354] md: bind<sdd3>
[ 1189.840354] md: bind<sde3>
[ 1189.842512] md: bind<sdc3>
[ 1189.842512] md: bind<sdf3>
[ 1189.844013] md: bind<sda3>
[ 1189.875071] raid10: raid set md4 active with 6 out of 6 devices
[ 1198.982375] Filesystem "dm-0": Disabling barriers, not supported by 
the underlying device
[ 1198.987373] XFS mounting filesystem dm-0
[ 1200.519856] Ending clean XFS mount for filesystem: dm-0
[ 1200.535852] Filesystem "dm-1": Disabling barriers, not supported by 
the underlying device
[ 1200.587852] XFS mounting filesystem dm-1
[ 1200.977207] Ending clean XFS mount for filesystem: dm-1
[ 1200.987164] ReiserFS: dm-2: found reiserfs format "3.6" with standard 
journal
[ 1200.987164] ReiserFS: dm-2: using ordered data mode
[ 1201.071161] ReiserFS: dm-2: journal params: device dm-2, size 8192, 
journal first block 18, max trans len 1024, max batch 900, max commit 
age 30, max trans age 30
[ 1201.071640] ReiserFS: dm-2: checking transaction log (dm-2)
[ 1201.125097] ReiserFS: dm-2: Using r5 hash to sort names
[ 1281.909362] mtrr: type mismatch for d0000000,8000000 old: write-back 
new: write-combining
[ 1374.622166] r8169: eth0: link up
[ 1385.653696] eth0: no IPv6 routers present
[ 2162.274814] mtrr: type mismatch for d0000000,8000000 old: write-back 
new: write-combining
[ 2277.379373] md: md4 stopped.
[ 2277.379428] md: unbind<sda3>
[ 2277.379473] md: export_rdev(sda3)
[ 2277.379522] md: unbind<sdf3>
[ 2277.379565] md: export_rdev(sdf3)
[ 2277.379612] md: unbind<sdc3>
[ 2277.379656] md: export_rdev(sdc3)
[ 2277.379702] md: unbind<sde3>
[ 2277.379745] md: export_rdev(sde3)
[ 2277.379792] md: unbind<sdd3>
[ 2277.379842] md: export_rdev(sdd3)
[ 2277.379890] md: unbind<sdb3>
[ 2277.379933] md: export_rdev(sdb3)
[ 2304.355772] ata6.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 2304.355772] ata4.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 2304.355772] ata4.00: irq_stat 0x00400001, PHY RDY changed
[ 2304.355772] ata4: SError: { PHYRdyChg CommWake }
[ 2304.355772] ata4.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 2304.355772]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 2304.355772] ata4.00: status: { DRDY }
[ 2304.355772] ata4: hard resetting link
[ 2304.896743] ata5.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 2304.896743] ata5.00: irq_stat 0x00400001, PHY RDY changed
[ 2304.896743] ata5: SError: { PHYRdyChg CommWake }
[ 2304.896743] ata5.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 2304.896743]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 2304.896743] ata5.00: status: { DRDY }
[ 2304.896743] ata5: hard resetting link
[ 2304.896743] ata6.00: irq_stat 0x00400001, PHY RDY changed
[ 2304.896789] ata6: SError: { PHYRdyChg CommWake }
[ 2304.896835] ata6.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 2304.896836]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 2304.896939] ata6.00: status: { DRDY }
[ 2304.896984] ata6: hard resetting link
[ 2304.897035] ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 2304.897093] ata3.00: irq_stat 0x00400001, PHY RDY changed
[ 2304.897138] ata3: SError: { PHYRdyChg CommWake }
[ 2304.897184] ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 2304.897185]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 2304.897288] ata3.00: status: { DRDY }
[ 2304.897332] ata3: hard resetting link
[ 2304.897381] ata2.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 2304.897439] ata2.00: irq_stat 0x00400001, PHY RDY changed
[ 2304.897485] ata2: SError: { PHYRdyChg CommWake }
[ 2304.897530] ata2.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 2304.897531]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 2304.897634] ata2.00: status: { DRDY }
[ 2304.897679] ata2: hard resetting link
[ 2305.832653] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2305.832656] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2305.837489] ata4.00: configured for UDMA/133
[ 2305.837489] ata4: EH complete
[ 2305.837489] ata5.00: configured for UDMA/133
[ 2305.837489] sd 3:0:0:0: [sdd] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2305.837489] sd 3:0:0:0: [sdd] Write Protect is off
[ 2305.837489] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[ 2305.837489] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2305.837489] ata5: EH complete
[ 2305.837489] sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2305.837489] sd 4:0:0:0: [sde] Write Protect is off
[ 2305.837489] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[ 2305.837489] sd 4:0:0:0: [sde] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2305.841497] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2305.841556] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2305.841615] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2305.841615] ata3.00: configured for UDMA/133
[ 2305.841615] ata3: EH complete
[ 2305.841615] ata2.00: configured for UDMA/133
[ 2305.841615] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2305.841615] sd 2:0:0:0: [sdc] Write Protect is off
[ 2305.841615] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 2305.841615] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2305.845240] ata6.00: configured for UDMA/133
[ 2305.845240] ata6: EH complete
[ 2305.841615] ata2: EH complete
[ 2305.841615] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2305.841615] sd 1:0:0:0: [sdb] Write Protect is off
[ 2305.841615] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[ 2305.841615] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2305.841694] sd 5:0:0:0: [sdf] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2305.845240] sd 5:0:0:0: [sdf] Write Protect is off
[ 2305.845284] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[ 2305.845299] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2305.852738] end_request: I/O error, dev sdd, sector 19534911
[ 2305.852738] md: super_written gets error=-5, uptodate=0
[ 2305.852738] raid1: Disk failure on sdd1, disabling device.
[ 2305.852738] raid1: Operation continuing on 5 devices.
[ 2305.852738] end_request: I/O error, dev sdf, sector 19534911
[ 2305.852738] md: super_written gets error=-5, uptodate=0
[ 2305.852738] raid1: Disk failure on sdf1, disabling device.
[ 2305.852738] raid1: Operation continuing on 4 devices.
[ 2305.853240] end_request: I/O error, dev sdc, sector 19534911
[ 2305.853240] md: super_written gets error=-5, uptodate=0
[ 2305.853240] raid1: Disk failure on sdc1, disabling device.
[ 2305.853240] raid1: Operation continuing on 3 devices.
[ 2305.841615] end_request: I/O error, dev sde, sector 19534911
[ 2305.841615] md: super_written gets error=-5, uptodate=0
[ 2305.841615] raid1: Disk failure on sde1, disabling device.
[ 2305.841615] raid1: Operation continuing on 2 devices.
[ 2305.857144] end_request: I/O error, dev sdb, sector 19534911
[ 2305.857144] md: super_written gets error=-5, uptodate=0
[ 2305.857144] raid1: Disk failure on sdb1, disabling device.
[ 2305.857144] raid1: Operation continuing on 1 devices.
[ 2305.872898] RAID1 conf printout:
[ 2305.872898]  --- wd:1 rd:6
[ 2305.872898]  disk 0, wo:0, o:1, dev:sda1
[ 2305.872898]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.872898]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.872898]  disk 3, wo:1, o:0, dev:sde1
[ 2305.872898]  disk 4, wo:1, o:0, dev:sdc1
[ 2305.872898]  disk 5, wo:1, o:0, dev:sdf1
[ 2305.881242] RAID1 conf printout:
[ 2305.881286]  --- wd:1 rd:6
[ 2305.881330]  disk 0, wo:0, o:1, dev:sda1
[ 2305.881379]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.881423]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.881466]  disk 3, wo:1, o:0, dev:sde1
[ 2305.881510]  disk 4, wo:1, o:0, dev:sdc1
[ 2305.881557] RAID1 conf printout:
[ 2305.881599]  --- wd:1 rd:6
[ 2305.881641]  disk 0, wo:0, o:1, dev:sda1
[ 2305.881684]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.881728]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.881772]  disk 3, wo:1, o:0, dev:sde1
[ 2305.881815]  disk 4, wo:1, o:0, dev:sdc1
[ 2305.893241] RAID1 conf printout:
[ 2305.893285]  --- wd:1 rd:6
[ 2305.893328]  disk 0, wo:0, o:1, dev:sda1
[ 2305.893376]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.893418]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.893462]  disk 3, wo:1, o:0, dev:sde1
[ 2305.893506] RAID1 conf printout:
[ 2305.893548]  --- wd:1 rd:6
[ 2305.893589]  disk 0, wo:0, o:1, dev:sda1
[ 2305.893633]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.893676]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.893719]  disk 3, wo:1, o:0, dev:sde1
[ 2305.905242] RAID1 conf printout:
[ 2305.905285]  --- wd:1 rd:6
[ 2305.905329]  disk 0, wo:0, o:1, dev:sda1
[ 2305.905376]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.905418]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.905463] RAID1 conf printout:
[ 2305.905505]  --- wd:1 rd:6
[ 2305.905546]  disk 0, wo:0, o:1, dev:sda1
[ 2305.905590]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.905633]  disk 2, wo:1, o:0, dev:sdd1
[ 2305.917241] RAID1 conf printout:
[ 2305.917284]  --- wd:1 rd:6
[ 2305.917328]  disk 0, wo:0, o:1, dev:sda1
[ 2305.917374]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.917417] RAID1 conf printout:
[ 2305.917460]  --- wd:1 rd:6
[ 2305.917501]  disk 0, wo:0, o:1, dev:sda1
[ 2305.917544]  disk 1, wo:1, o:0, dev:sdb1
[ 2305.929241] RAID1 conf printout:
[ 2305.929284]  --- wd:1 rd:6
[ 2305.929328]  disk 0, wo:0, o:1, dev:sda1
[ 2505.989204] md: md3 still in use.
[ 2521.148651] md: unbind<sdc1>
[ 2521.148651] md: export_rdev(sdc1)
[ 2537.045017] md: unbind<sdf1>
[ 2537.045017] md: export_rdev(sdf1)
[ 2537.070370] md: unbind<sde1>
[ 2537.070370] md: export_rdev(sde1)
[ 2537.812473] md: unbind<sdd1>
[ 2537.812524] md: export_rdev(sdd1)
[ 2537.822335] md: unbind<sdb1>
[ 2537.822335] md: export_rdev(sdb1)
[ 2565.680914] md: bind<sdf1>
[ 2565.722761] RAID1 conf printout:
[ 2565.722761]  --- wd:1 rd:6
[ 2565.722761]  disk 0, wo:0, o:1, dev:sda1
[ 2565.722761]  disk 1, wo:1, o:1, dev:sdf1
[ 2565.724253] md: recovery of RAID array md3
[ 2565.724253] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 2565.724253] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[ 2565.724253] md: using 128k window, over a total of 9767424 blocks.
[ 2565.876674] md: bind<sde1>
[ 2565.995415] md: bind<sdd1>
[ 2566.057634] md: bind<sdb1>
[ 2566.101549] md: bind<sdc1>
[ 2782.657615] md: md3: recovery done.
[ 2783.368035] RAID1 conf printout:
[ 2783.368035]  --- wd:2 rd:6
[ 2783.368035]  disk 0, wo:0, o:1, dev:sda1
[ 2783.368035]  disk 1, wo:0, o:1, dev:sdf1
[ 2783.555376] RAID1 conf printout:
[ 2783.555423]  --- wd:2 rd:6
[ 2783.555467]  disk 0, wo:0, o:1, dev:sda1
[ 2783.555533]  disk 1, wo:0, o:1, dev:sdf1
[ 2783.555576]  disk 2, wo:1, o:1, dev:sdc1
[ 2783.555625] RAID1 conf printout:
[ 2783.555667]  --- wd:2 rd:6
[ 2783.555708]  disk 0, wo:0, o:1, dev:sda1
[ 2783.555751]  disk 1, wo:0, o:1, dev:sdf1
[ 2783.555794]  disk 2, wo:1, o:1, dev:sdc1
[ 2783.555837]  disk 3, wo:1, o:1, dev:sdb1
[ 2783.555882] RAID1 conf printout:
[ 2783.555924]  --- wd:2 rd:6
[ 2783.555966]  disk 0, wo:0, o:1, dev:sda1
[ 2783.559532]  disk 1, wo:0, o:1, dev:sdf1
[ 2783.559532]  disk 2, wo:1, o:1, dev:sdc1
[ 2783.559532]  disk 3, wo:1, o:1, dev:sdb1
[ 2783.559532]  disk 4, wo:1, o:1, dev:sdd1
[ 2783.559532] RAID1 conf printout:
[ 2783.559532]  --- wd:2 rd:6
[ 2783.559532]  disk 0, wo:0, o:1, dev:sda1
[ 2783.559532]  disk 1, wo:0, o:1, dev:sdf1
[ 2783.559532]  disk 2, wo:1, o:1, dev:sdc1
[ 2783.559532]  disk 3, wo:1, o:1, dev:sdb1
[ 2783.559532]  disk 4, wo:1, o:1, dev:sdd1
[ 2783.559532]  disk 5, wo:1, o:1, dev:sde1
[ 2783.559532] md: recovery of RAID array md3
[ 2783.559532] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 2783.559532] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[ 2783.559532] md: using 128k window, over a total of 9767424 blocks.
[ 2977.087799] ata1.00: exception Emask 0x10 SAct 0x7 SErr 0x50000 
action 0xe frozen
[ 2977.087860] ata1.00: irq_stat 0x00400008, PHY RDY changed
[ 2977.087908] ata1: SError: { PHYRdyChg CommWake }
[ 2977.087957] ata1.00: cmd 60/80:00:bf:d8:dc/00:00:00:00:00/40 tag 0 
ncq 65536 in
[ 2977.087958]          res 40/00:14:bf:d9:dc/00:00:00:00:00/40 Emask 
0x10 (ATA bus error)
[ 2977.088077] ata1.00: status: { DRDY }
[ 2977.088123] ata1.00: cmd 60/80:08:3f:d9:dc/00:00:00:00:00/40 tag 1 
ncq 65536 in
[ 2977.088124]          res 40/00:14:bf:d9:dc/00:00:00:00:00/40 Emask 
0x10 (ATA bus error)
[ 2977.088245] ata1.00: status: { DRDY }
[ 2977.088292] ata1.00: cmd 60/80:10:bf:d9:dc/00:00:00:00:00/40 tag 2 
ncq 65536 in
[ 2977.088293]          res 40/00:14:bf:d9:dc/00:00:00:00:00/40 Emask 
0x10 (ATA bus error)
[ 2977.088412] ata1.00: status: { DRDY }
[ 2977.088462] ata1: hard resetting link
[ 2977.107904] ata4.00: exception Emask 0x10 SAct 0x20 SErr 0x10000 
action 0xe frozen
[ 2977.107904] ata4.00: irq_stat 0x00400008, PHY RDY changed
[ 2977.107904] ata4: SError: { PHYRdyChg }
[ 2977.107904] ata4.00: cmd 61/00:28:bf:d7:dc/01:00:00:00:00/40 tag 5 
ncq 131072 out
[ 2977.107904]          res 40/00:2c:bf:d7:dc/00:00:00:00:00/40 Emask 
0x10 (ATA bus error)
[ 2977.107904] ata4.00: status: { DRDY }
[ 2977.107904] ata4: hard resetting link
[ 2977.973953] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2977.973943] ata1.00: configured for UDMA/133
[ 2977.973943] ata1: EH complete
[ 2977.978160] sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2977.978160] sd 0:0:0:0: [sda] Write Protect is off
[ 2977.978160] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[ 2977.978160] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2977.978160] ata5.00: exception Emask 0x10 SAct 0x3 SErr 0x50000 
action 0xe frozen
[ 2978.028686] ata3.00: exception Emask 0x10 SAct 0x3 SErr 0x50000 
action 0xe frozen
[ 2978.028686] ata3.00: irq_stat 0x00400008, PHY RDY changed
[ 2978.028686] ata3: SError: { PHYRdyChg CommWake }
[ 2978.028686] ata3.00: cmd 61/80:00:bf:d8:dc/00:00:00:00:00/40 tag 0 
ncq 65536 out
[ 2978.028686]          res 40/00:0c:3f:d9:dc/00:00:00:00:00/40 Emask 
0x10 (ATA bus error)
[ 2978.028686] ata3.00: status: { DRDY }
[ 2978.028686] ata3.00: cmd 61/80:08:3f:d9:dc/00:00:00:00:00/40 tag 1 
ncq 65536 out
[ 2978.028686]          res 40/00:0c:3f:d9:dc/00:00:00:00:00/40 Emask 
0x10 (ATA bus error)
[ 2978.028686] ata3.00: status: { DRDY }
[ 2978.028686] ata3: hard resetting link
[ 2977.978160] ata5.00: irq_stat 0x00400008, PHY RDY changed
[ 2977.978160] ata5: SError: { PHYRdyChg CommWake }
[ 2977.978160] ata5.00: cmd 61/80:00:bf:d8:dc/00:00:00:00:00/40 tag 0 
ncq 65536 out
[ 2977.978160]          res 40/00:0c:3f:d9:dc/00:00:00:00:00/40 Emask 
0x10 (ATA bus error)
[ 2977.978160] ata5.00: status: { DRDY }
[ 2977.978160] ata5.00: cmd 61/80:08:3f:d9:dc/00:00:00:00:00/40 tag 1 
ncq 65536 out
[ 2977.978160]          res 40/00:0c:3f:d9:dc/00:00:00:00:00/40 Emask 
0x10 (ATA bus error)
[ 2977.978160] ata5.00: status: { DRDY }
[ 2977.978160] ata5: hard resetting link
[ 2978.034941] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2978.039874] ata4.00: configured for UDMA/133
[ 2978.039874] ata4: EH complete
[ 2978.039874] sd 3:0:0:0: [sdd] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2978.039874] sd 3:0:0:0: [sdd] Write Protect is off
[ 2978.039874] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[ 2978.039874] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2978.914449] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2978.915221] ata5.00: configured for UDMA/133
[ 2978.915221] ata5: EH complete
[ 2978.915221] sd 4:0:0:0: [sde] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2978.915221] sd 4:0:0:0: [sde] Write Protect is off
[ 2978.915221] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[ 2978.915221] sd 4:0:0:0: [sde] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 2978.922939] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 2978.922929] ata3.00: configured for UDMA/133
[ 2978.922929] ata3: EH complete
[ 2978.915221] sd 2:0:0:0: [sdc] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 2978.915221] sd 2:0:0:0: [sdc] Write Protect is off
[ 2978.915221] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[ 2978.915221] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 3046.343693] md: md3: recovery done.
[ 3046.387694] ata6.00: exception Emask 0x10 SAct 0x0 SErr 0x50000 
action 0xe frozen
[ 3046.387694] ata6.00: irq_stat 0x00400001, PHY RDY changed
[ 3046.387694] ata6: SError: { PHYRdyChg CommWake }
[ 3046.387694] ata6.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[ 3046.387694]          res 50/00:00:00:00:00/00:00:00:00:00/a0 Emask 
0x10 (ATA bus error)
[ 3046.387694] ata6.00: status: { DRDY }
[ 3046.387694] ata6: hard resetting link
[ 3047.561017] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 3047.613497] ata6.00: configured for UDMA/133
[ 3047.613497] ata6: EH complete
[ 3047.613497] sd 5:0:0:0: [sdf] 1465149168 512-byte hardware sectors 
(750156 MB)
[ 3047.613497] sd 5:0:0:0: [sdf] Write Protect is off
[ 3047.613497] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[ 3047.613497] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[ 3047.613497] end_request: I/O error, dev sdf, sector 19534911
[ 3047.613497] md: super_written gets error=-5, uptodate=0
[ 3047.613497] raid1: Disk failure on sdf1, disabling device.
[ 3047.613497] raid1: Operation continuing on 1 devices.
[ 3047.645706] RAID1 conf printout:
[ 3047.645706]  --- wd:1 rd:6
[ 3047.645706]  disk 0, wo:0, o:1, dev:sda1
[ 3047.645706]  disk 1, wo:1, o:0, dev:sdf1
[ 3047.645706]  disk 2, wo:1, o:1, dev:sdc1
[ 3047.645706]  disk 3, wo:1, o:1, dev:sdb1
[ 3047.645706]  disk 4, wo:1, o:1, dev:sdd1
[ 3047.645733]  disk 5, wo:1, o:1, dev:sde1
[ 3047.646775] RAID1 conf printout:
[ 3047.646817]  --- wd:1 rd:6
[ 3047.646858]  disk 0, wo:0, o:1, dev:sda1
[ 3047.646902]  disk 1, wo:1, o:0, dev:sdf1
[ 3047.646945]  disk 2, wo:1, o:1, dev:sdc1
[ 3047.646988]  disk 3, wo:1, o:1, dev:sdb1
[ 3047.647031]  disk 4, wo:1, o:1, dev:sdd1
[ 3047.647074]  disk 5, wo:1, o:1, dev:sde1
[ 3047.647117] RAID1 conf printout:
[ 3047.647159]  --- wd:1 rd:6
[ 3047.654048]  disk 0, wo:0, o:1, dev:sda1
[ 3047.654091]  disk 1, wo:1, o:0, dev:sdf1
[ 3047.654134]  disk 2, wo:1, o:1, dev:sdc1
[ 3047.654177]  disk 3, wo:1, o:1, dev:sdb1
[ 3047.654220]  disk 4, wo:1, o:1, dev:sdd1
[ 3047.654263]  disk 5, wo:1, o:1, dev:sde1
[ 3047.654306] RAID1 conf printout:
[ 3047.654348]  --- wd:1 rd:6
[ 3047.654390]  disk 0, wo:0, o:1, dev:sda1
[ 3047.654433]  disk 1, wo:1, o:0, dev:sdf1
[ 3047.654476]  disk 2, wo:1, o:1, dev:sdc1
[ 3047.654519]  disk 3, wo:1, o:1, dev:sdb1
[ 3047.654568]  disk 4, wo:1, o:1, dev:sdd1
[ 3047.654611]  disk 5, wo:1, o:1, dev:sde1
[ 3047.654654] RAID1 conf printout:
[ 3047.654696]  --- wd:1 rd:6
[ 3047.654738]  disk 0, wo:0, o:1, dev:sda1
[ 3047.654781]  disk 1, wo:1, o:0, dev:sdf1
[ 3047.654825]  disk 2, wo:1, o:1, dev:sdc1
[ 3047.654867]  disk 3, wo:1, o:1, dev:sdb1
[ 3047.654911]  disk 4, wo:1, o:1, dev:sdd1
[ 3047.654953]  disk 5, wo:1, o:1, dev:sde1
[ 3047.654996] RAID1 conf printout:
[ 3047.655039]  --- wd:1 rd:6
[ 3047.655080]  disk 0, wo:0, o:1, dev:sda1
[ 3047.655123]  disk 1, wo:1, o:0, dev:sdf1
[ 3047.655167]  disk 2, wo:1, o:1, dev:sdc1
[ 3047.655209]  disk 3, wo:1, o:1, dev:sdb1
[ 3047.655252]  disk 4, wo:1, o:1, dev:sdd1
[ 3047.655296]  disk 5, wo:1, o:1, dev:sde1
[ 3047.655338] RAID1 conf printout:
[ 3047.655380]  --- wd:1 rd:6
[ 3047.655422]  disk 0, wo:0, o:1, dev:sda1
[ 3047.655465]  disk 1, wo:1, o:0, dev:sdf1
[ 3047.655508]  disk 2, wo:1, o:1, dev:sdc1
[ 3047.655551]  disk 3, wo:1, o:1, dev:sdb1
[ 3047.655594]  disk 4, wo:1, o:1, dev:sdd1
[ 3047.655637]  disk 5, wo:1, o:1, dev:sde1
[ 3047.655637] RAID1 conf printout:
[ 3047.655637]  --- wd:1 rd:6
[ 3047.655637]  disk 0, wo:0, o:1, dev:sda1
[ 3047.655637]  disk 1, wo:1, o:0, dev:sdf1
[ 3047.655637]  disk 2, wo:1, o:1, dev:sdc1
[ 3047.655637]  disk 3, wo:1, o:1, dev:sdb1
[ 3047.655637]  disk 4, wo:1, o:1, dev:sdd1
[ 3047.655637]  disk 5, wo:1, o:1, dev:sde1
[ 3047.655637] RAID1 conf printout:
[ 3047.655637]  --- wd:1 rd:6
[ 3047.655637]  disk 0, wo:0, o:1, dev:sda1
[ 3047.655637]  disk 1, wo:1, o:0, dev:sdf1
[ 3047.655637]  disk 2, wo:1, o:1, dev:sdc1
[ 3047.655637]  disk 3, wo:1, o:1, dev:sdb1
[ 3047.655637]  disk 4, wo:1, o:1, dev:sdd1
[ 3047.655637]  disk 5, wo:1, o:1, dev:sde1
[ 3047.664791] RAID1 conf printout:
[ 3047.664835]  --- wd:1 rd:6
[ 3047.664878]  disk 0, wo:0, o:1, dev:sda1
[ 3047.664926]  disk 2, wo:1, o:1, dev:sdc1
[ 3047.664969]  disk 3, wo:1, o:1, dev:sdb1
[ 3047.665011]  disk 4, wo:1, o:1, dev:sdd1
[ 3047.665055]  disk 5, wo:1, o:1, dev:sde1
[ 3047.666439] md: recovery of RAID array md3
[ 3047.666439] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 3047.666439] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for recovery.
[ 3047.666439] md: using 128k window, over a total of 9767424 blocks.
[ 3047.666439] md: resuming recovery of md3 from checkpoint.
[ 3047.666439] md: md3: recovery done.
[ 3047.677522] RAID1 conf printout:
[ 3047.681637]  --- wd:5 rd:6
[ 3047.681679]  disk 0, wo:0, o:1, dev:sda1
[ 3047.681722]  disk 2, wo:0, o:1, dev:sdc1
[ 3047.681765]  disk 3, wo:0, o:1, dev:sdb1
[ 3047.681808]  disk 4, wo:0, o:1, dev:sdd1
[ 3047.681851]  disk 5, wo:0, o:1, dev:sde1

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.26
# Thu Aug 28 10:24:09 2008
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_USER_SCHED is not set
CONFIG_CGROUP_SCHED=y
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
# CONFIG_MARKERS is not set
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
CONFIG_MEMTEST_BOOTPARAM=y
CONFIG_MEMTEST_BOOTPARAM_VALUE=0
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y

#
# Memory hotplug is currently incompatible with Software Suspend
#
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
# CONFIG_X86_PAT is not set
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=m
CONFIG_ACPI_BAY=m
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_WMI=m
CONFIG_ACPI_ASUS=m
CONFIG_ACPI_TOSHIBA=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_POWERNOW_K8_ACPI=y
CONFIG_X86_SPEEDSTEP_CENTRINO=m
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
# CONFIG_PCIEASPM is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=m
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=m
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=m
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=m
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_BINFMT_MISC=m
CONFIG_IA32_EMULATION=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
CONFIG_NET_KEY=m
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IP_VS=m
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m

#
# Bridge: Netfilter Configuration
#
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=m
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=m
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=m

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_SLAVE_NODES=0
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
CONFIG_ATM_MPOA=m
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
CONFIG_DECNET=m
# CONFIG_DECNET_ROUTER is not set
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_ECONET=m
CONFIG_ECONET_AUNUDP=y
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
# CONFIG_AX25_DAMA_SLAVE is not set
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
CONFIG_BT_HCIUSB_SCO=y
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_AF_RXRPC=m
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
# CONFIG_MAC80211_DEBUG is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=m
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
CONFIG_MTD_PHYSMAP=m
CONFIG_MTD_PHYSMAP_START=0x8000000
CONFIG_MTD_PHYSMAP_LEN=0x4000000
CONFIG_MTD_PHYSMAP_BANKWIDTH=2
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
CONFIG_MTD_SBC_GXX=m
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
# CONFIG_MTD_ESB2ROM is not set
# CONFIG_MTD_CK804XROM is not set
# CONFIG_MTD_SCB2_FLASH is not set
CONFIG_MTD_NETtel=m
CONFIG_MTD_DILNETPC=m
CONFIG_MTD_DILNETPC_BOOTSIZE=0x80000
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=m
CONFIG_MTD_INTEL_VR_NOR=m
CONFIG_MTD_PLATRAM=m

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
CONFIG_MTD_DATAFLASH=m
CONFIG_MTD_M25P80=m
CONFIG_M25PXX_USE_FAST_READ=y
CONFIG_MTD_SLRAM=m
CONFIG_MTD_PHRAM=m
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
CONFIG_MTD_DOC2000=m
CONFIG_MTD_DOC2001=m
CONFIG_MTD_DOC2001PLUS=m
CONFIG_MTD_DOCPROBE=m
CONFIG_MTD_DOCECC=m
# CONFIG_MTD_DOCPROBE_ADVANCED is not set
CONFIG_MTD_DOCPROBE_ADDRESS=0
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
# CONFIG_MTD_NAND_ECC_SMC is not set
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
CONFIG_MTD_NAND_CAFE=m
# CONFIG_MTD_NAND_NANDSIM is not set
CONFIG_MTD_NAND_PLATFORM=m
CONFIG_MTD_ALAUDA=m
CONFIG_MTD_ONENAND=m
CONFIG_MTD_ONENAND_VERIFY_WRITE=y
# CONFIG_MTD_ONENAND_OTP is not set
CONFIG_MTD_ONENAND_2X_PROGRAM=y
CONFIG_MTD_ONENAND_SIM=m

#
# UBI - Unsorted block images
#
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=m
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
# CONFIG_PARIDE_EPATC8 is not set
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=65536
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_VIRTIO_BLK=m
CONFIG_MISC_DEVICES=y
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
CONFIG_EEPROM_93CX6=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ACER_WMI=m
CONFIG_ASUS_LAPTOP=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_MSI_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_BAY=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_HP_ILO=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=m
CONFIG_BLK_DEV_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
CONFIG_BLK_DEV_IDEDISK=m
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECS=m
CONFIG_BLK_DEV_DELKIN=m
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDETAPE=m
CONFIG_BLK_DEV_IDEFLOPPY=m
# CONFIG_BLK_DEV_IDESCSI is not set
CONFIG_BLK_DEV_IDEACPI=y
# CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=m
# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
CONFIG_BLK_DEV_IDEPNP=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_OPTI621=m
CONFIG_BLK_DEV_RZ1000=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
CONFIG_BLK_DEV_ALI15X3=m
CONFIG_BLK_DEV_AMD74XX=m
CONFIG_BLK_DEV_ATIIXP=m
CONFIG_BLK_DEV_CMD64X=m
CONFIG_BLK_DEV_TRIFLEX=m
CONFIG_BLK_DEV_CY82C693=m
CONFIG_BLK_DEV_CS5520=m
CONFIG_BLK_DEV_CS5530=m
CONFIG_BLK_DEV_HPT34X=m
# CONFIG_HPT34X_AUTODMA is not set
CONFIG_BLK_DEV_HPT366=m
CONFIG_BLK_DEV_JMICRON=m
CONFIG_BLK_DEV_SC1200=m
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_IT8213=m
CONFIG_BLK_DEV_IT821X=m
CONFIG_BLK_DEV_NS87415=m
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
CONFIG_BLK_DEV_SVWKS=m
CONFIG_BLK_DEV_SIIMAGE=m
CONFIG_BLK_DEV_SIS5513=m
CONFIG_BLK_DEV_SLC90E66=m
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=m
CONFIG_BLK_DEV_TC86C001=m
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_BLK_DEV_HD_ONLY is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=8
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC7XXX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=15000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_DPT_I2O=m
CONFIG_SCSI_ADVANSYS=m
CONFIG_SCSI_ARCMSR=m
# CONFIG_SCSI_ARCMSR_AER is not set
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
CONFIG_SCSI_DMX3191D=m
CONFIG_SCSI_EATA=m
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=m
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=m
# CONFIG_SCSI_IPR_TRACE is not set
# CONFIG_SCSI_IPR_DUMP is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_SRP=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_ATA=m
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=m
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
# CONFIG_SATA_SIS is not set
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
CONFIG_PATA_ARTOP=m
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_MARVELL=m
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PCMCIA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
CONFIG_PATA_SIS=m
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_PATA_SCH=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=m
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_EMC=m
CONFIG_DM_MULTIPATH_RDAC=m
CONFIG_DM_MULTIPATH_HP=m
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
# CONFIG_FIREWIRE is not set
CONFIG_IEEE1394=m
CONFIG_IEEE1394_OHCI1394=m
CONFIG_IEEE1394_PCILYNX=m
CONFIG_IEEE1394_SBP2=m
# CONFIG_IEEE1394_SBP2_PHYS_DMA is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=m
CONFIG_IEEE1394_RAWIO=m
CONFIG_IEEE1394_VIDEO1394=m
CONFIG_IEEE1394_DV1394=m
# CONFIG_IEEE1394_VERBOSEDEBUG is not set
CONFIG_I2O=m
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_NETDEVICES_MULTIQUEUE=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
# CONFIG_MACVLAN is not set
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=m
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_MDIO_BITBANG=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
CONFIG_ENC28J60=m
# CONFIG_ENC28J60_WRITEVERIFY is not set
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
# CONFIG_TULIP_MMIO is not set
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
CONFIG_HP100=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_AMD8111E_NAPI=y
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_ADAPTEC_STARFIRE_NAPI=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
# CONFIG_FORCEDETH_NAPI is not set
CONFIG_EEPRO100=m
CONFIG_E100=m
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=m
CONFIG_SIS900=m
CONFIG_EPIC100=m
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_VIA_RHINE=m
# CONFIG_VIA_RHINE_MMIO is not set
CONFIG_VIA_RHINE_NAPI=y
CONFIG_SC92031=m
# CONFIG_NET_POCKET is not set
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=m
CONFIG_E1000=m
CONFIG_E1000_NAPI=y
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
CONFIG_E1000E=m
CONFIG_E1000E_ENABLED=y
CONFIG_IP1000=m
CONFIG_IGB=m
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_R8169_NAPI=y
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_NETDEV_10000=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T1_NAPI=y
CONFIG_CHELSIO_T3=m
CONFIG_IXGBE=m
CONFIG_IXGB=m
CONFIG_IXGB_NAPI=y
CONFIG_S2IO=m
CONFIG_S2IO_NAPI=y
CONFIG_MYRI10GE=m
CONFIG_NETXEN_NIC=m
CONFIG_NIU=m
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_TEHUTI=m
CONFIG_SFC=m
CONFIG_TR=y
CONFIG_IBMOL=m
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
CONFIG_ABYSS=m

#
# Wireless LAN
#
CONFIG_WLAN_PRE80211=y
CONFIG_STRIP=m
CONFIG_PCMCIA_WAVELAN=m
CONFIG_PCMCIA_NETWAVE=m
CONFIG_WLAN_80211=y
CONFIG_PCMCIA_RAYCS=m
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_AIRO=m
CONFIG_HERMES=m
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_USB_ATMEL=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
# CONFIG_PRISM54 is not set
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_ADM8211=m
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
CONFIG_IWL4965=m
CONFIG_IWL4965_HT=y
CONFIG_IWL4965_LEDS=y
CONFIG_IWL4965_SPECTRUM_MEASUREMENT=y
CONFIG_IWL4965_SENSITIVITY=y
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWL3945=m
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
# CONFIG_IWL3945_DEBUG is not set
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_PIO=y
CONFIG_B43_LEDS=y
CONFIG_B43_RFKILL=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_RFKILL=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set
CONFIG_RT2X00=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_RFKILL=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2400PCI=m
CONFIG_RT2400PCI_RFKILL=y
CONFIG_RT2400PCI_LEDS=y
CONFIG_RT2500PCI=m
CONFIG_RT2500PCI_RFKILL=y
CONFIG_RT2500PCI_LEDS=y
CONFIG_RT61PCI=m
CONFIG_RT61PCI_RFKILL=y
CONFIG_RT61PCI_LEDS=y
CONFIG_RT2500USB=m
CONFIG_RT2500USB_LEDS=y
CONFIG_RT73USB=m
CONFIG_RT73USB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_ARCNET_COM20020_CS=m
CONFIG_WAN=y
CONFIG_LANMEDIA=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m
CONFIG_HDLC_X25=m
CONFIG_PCI200SYN=m
CONFIG_WANXL=m
CONFIG_PC300=m
CONFIG_PC300_MLPPP=y

#
# Cyclades-PC300 MLPPP support is disabled.
#

#
# Refer to the file README.mlppp, provided by PC300 package.
#
# CONFIG_PC300TOO is not set
CONFIG_FARSYNC=m
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
CONFIG_DSCC4_PCI_RST=y
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_WAN_ROUTER_DRIVERS=m
CONFIG_CYCLADES_SYNC=m
CONFIG_CYCLOMX_X25=y
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
CONFIG_SBNI=m
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ATM_DRIVERS=y
CONFIG_ATM_DUMMY=m
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_FORE200E_MAYBE=m
CONFIG_ATM_HE=m
CONFIG_ATM_HE_USE_SUNI=y
CONFIG_FDDI=y
CONFIG_DEFXX=m
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
# CONFIG_ROADRUNNER_LARGE_RINGS is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
CONFIG_ISDN=m
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
CONFIG_ISDN_PPP_BSDCOMP=m
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
# CONFIG_HISAX_NO_SENDCOMPLETE is not set
# CONFIG_HISAX_NO_LLC is not set
# CONFIG_HISAX_NO_KEYPAD is not set
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m
CONFIG_HISAX_TELES_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
CONFIG_HISAX_HFCUSB=m
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m
CONFIG_HISAX_HDLC=y

#
# Active cards
#
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_GIGASET_UNDOCREQ is not set
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=m
CONFIG_ISDN_DIVAS_BRIPCI=y
CONFIG_ISDN_DIVAS_PRIPCI=y
CONFIG_ISDN_DIVAS_DIVACAPI=m
CONFIG_ISDN_DIVAS_USERIDI=m
CONFIG_ISDN_DIVAS_MAINT=m
CONFIG_PHONE=m
CONFIG_PHONE_IXJ=m
CONFIG_PHONE_IXJ_PCMCIA=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=m
CONFIG_KEYBOARD_STOWAWAY=m
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=m
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_UCB1400=m
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PARKBD=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_DEVKMEM=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=m
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
CONFIG_DIGIEPCA=m
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_ISI=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
CONFIG_RISCOM8=m
CONFIG_SPECIALIX=m
# CONFIG_SPECIALIX_RTSCTS is not set
CONFIG_SX=m
CONFIG_RIO=m
CONFIG_RIO_OLDPCI=y
CONFIG_STALDRV=y
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=m
CONFIG_R3964=m
CONFIG_APPLICOM=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_I810=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_OCORES=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_PROSAVAGE=m
CONFIG_I2C_SAVAGE4=m
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_STUB=m
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m
CONFIG_I2C_VOODOO3=m
CONFIG_I2C_PCA_PLATFORM=m

#
# Miscellaneous I2C Chip support
#
CONFIG_DS1682=m
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8574=m
CONFIG_PCF8575=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_MAX6875=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_LM70_LLP=m

#
# SPI Protocol Masters
#
CONFIG_SPI_AT25=m
# CONFIG_SPI_SPIDEV is not set
CONFIG_SPI_TLE62X0=m
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2433=m
# CONFIG_W1_SLAVE_DS2433_CRC is not set
CONFIG_W1_SLAVE_DS2760=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_BATTERY_DS2760=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
CONFIG_SENSORS_APPLESMC=m
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=m
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_SC520_WDT=m
CONFIG_EUROTECH_WDT=m
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
CONFIG_IT8712F_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_SC1200_WDT=m
CONFIG_PC87413_WDT=m
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC37B787_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
CONFIG_MFD_SM501=m
CONFIG_HTC_PASIC3=m

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA7111=m
CONFIG_VIDEO_SAA7114=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_VIVI=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_W9966=m
CONFIG_VIDEO_CPIA=m
CONFIG_VIDEO_CPIA_PP=m
CONFIG_VIDEO_CPIA_USB=m
CONFIG_VIDEO_CPIA2=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_TUNER_3036=m
CONFIG_VIDEO_STRADIS=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_MEYE=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_DPC=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
CONFIG_USB_QUICKCAM_MESSENGER=m
CONFIG_USB_ET61X251=m
CONFIG_VIDEO_OVCAMCHIP=m
CONFIG_USB_W9968CF=m
CONFIG_USB_OV511=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_STV680=m
CONFIG_USB_ZC0301=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_GEMTEK_PCI=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_MAESTRO=m
CONFIG_USB_DSBR=m
CONFIG_USB_SI470X=m
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_DVB_CINERGYT2=m
# CONFIG_DVB_CINERGYT2_TUNING is not set

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=m
CONFIG_AGP_SIS=m
CONFIG_AGP_VIA=m
CONFIG_DRM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=m
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
CONFIG_FB_ARC=m
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
CONFIG_FB_UVESA=m
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_IMAC is not set
CONFIG_FB_N411=m
CONFIG_FB_HGA=m
# CONFIG_FB_HGA_ACCEL is not set
CONFIG_FB_S1D13XXX=m
CONFIG_FB_NVIDIA=m
# CONFIG_FB_NVIDIA_I2C is not set
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
# CONFIG_FB_RIVA is not set
CONFIG_FB_LE80578=m
CONFIG_FB_CARILLO_RANCH=m
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_MATROX_MULTIHEAD=y
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
CONFIG_FB_SIS=m
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
# CONFIG_FB_3DFX_ACCEL is not set
CONFIG_FB_VOODOO1=m
CONFIG_FB_VT8623=m
CONFIG_FB_TRIDENT=m
# CONFIG_FB_TRIDENT_ACCEL is not set
CONFIG_FB_ARK=m
CONFIG_FB_PM3=m
# CONFIG_FB_GEODE is not set
CONFIG_FB_SM501=m
CONFIG_FB_VIRTUAL=m
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
CONFIG_BACKLIGHT_PROGEAR=m

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y

#
# Generic devices
#
CONFIG_SND_PCSP=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m

#
# PCI devices
#
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS5530=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_FM801_TEA575X=m
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0

#
# SPI devices
#

#
# USB devices
#
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y

#
# PCMCIA devices
#
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# ALSA SoC audio for Freescale SOCs
#

#
# SoC Audio for the Texas Instruments OMAP
#

#
# Open Sound System
#
CONFIG_SOUND_PRIME=m
CONFIG_SOUND_TRIDENT=m
CONFIG_SOUND_OSS=m
# CONFIG_SOUND_TRACEINIT is not set
# CONFIG_SOUND_DMAP is not set
CONFIG_SOUND_SSCAPE=m
CONFIG_SOUND_VMIDI=m
CONFIG_SOUND_TRIX=m
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
CONFIG_PSS_MIXER=y
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
CONFIG_SOUND_AEDSP16=m
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0x0
# CONFIG_AEDSP16_MSS is not set
# CONFIG_AEDSP16_SBPRO is not set
CONFIG_SOUND_KAHLUA=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=m
# CONFIG_HID_DEBUG is not set
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_USB_HIDINPUT_POWERBOOK=y
CONFIG_HID_FF=y
CONFIG_HID_PID=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_PANTHERLORD_FF=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_HIDDEV=y

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
CONFIG_USB_MOUSE=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=m
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_ISP116X_HCD=m
CONFIG_USB_ISP1760_HCD=m
# CONFIG_USB_ISP1760_PCI is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
CONFIG_USB_SL811_CS=m
CONFIG_USB_R8A66597_HCD=m

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USB_MON=y

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_AIRPRIME=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
# CONFIG_USB_SERIAL_SAFE_PADDED is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_ADUTUX=m
CONFIG_USB_AUERSWALD=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_PHIDGET=m
CONFIG_USB_PHIDGETKIT=m
CONFIG_USB_PHIDGETMOTORCONTROL=m
CONFIG_USB_PHIDGETSERVO=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_RICOH_MMC=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SPI=m
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_CLEVO_MAIL=m

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_IDE_DISK=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I5000=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
# CONFIG_RTC_DRV_M41T80_WDT is not set
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_MAX6902=m
CONFIG_RTC_DRV_R9701=m
CONFIG_RTC_DRV_RS5C348=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_DCA=m
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_SMX=m

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_EFI_VARS=m
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=m
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4DEV_FS=m
CONFIG_EXT4DEV_FS_XATTR=y
CONFIG_EXT4DEV_FS_POSIX_ACL=y
CONFIG_EXT4DEV_FS_SECURITY=y
CONFIG_JBD=m
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_NOLOCK=m
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V1=m
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="utf8"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
CONFIG_ADFS_FS=m
# CONFIG_ADFS_FS_RW is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
CONFIG_JFFS2_COMPRESSION_OPTIONS=y
CONFIG_JFFS2_ZLIB=y
CONFIG_JFFS2_LZO=y
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
# CONFIG_JFFS2_CMODE_NONE is not set
CONFIG_JFFS2_CMODE_PRIORITY=y
# CONFIG_JFFS2_CMODE_SIZE is not set
# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
CONFIG_CRAMFS=m
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_HPFS_FS=m
CONFIG_QNX4FS_FS=m
CONFIG_ROMFS_FS=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_SUNRPC_BIND34=y
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_NCP_FS=m
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
# CONFIG_NCPFS_STRONG is not set
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
# CONFIG_CODA_FS_OLD_API is not set
CONFIG_AFS_FS=m
# CONFIG_AFS_DEBUG is not set
CONFIG_9P_FS=m

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=m
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_SLAB is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
# CONFIG_NONPROMISC_DEVMEM is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DIRECT_GBPAGES is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_X86_MPPARSE=y
# CONFIG_IOMMU_DEBUG is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_DEBUG_PROC_KEYS is not set
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_SHA1=m
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC7=m
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=m
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
