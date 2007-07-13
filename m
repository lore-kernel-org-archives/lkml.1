Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbXGMDsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbXGMDsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXGMDru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:47:50 -0400
Received: from outbound04.telus.net ([199.185.220.223]:57096 "EHLO
	outbound04.telus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbXGMDrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:47:48 -0400
X-Greylist: delayed 12168 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jul 2007 23:47:48 EDT
Message-ID: <1184286293.4696c655bccb2@webmail.telus.net>
Date: Thu, 12 Jul 2007 17:24:53 -0700
From: nikola.trajic@telus.net
To: linux-kernel@vger.kernel.org
Subject: Is it fixed in 2.6.20 (raid1 spare rebuilding does not resume after raid1 is stopped)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.1-cvs
X-Originating-IP: 209.68.187.231
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



[1.] One line summary of the problem:
 
raid1 spare rebuilding does not resume after the reboot ( 2.6.18)
 
[2.] Full description of the problem/report:
 
----------------------------------------------                    

1. When a mirrored raid is created, this raid1 is in the 'State : clean, resyncing'.

md0 : active raid1 sdd[3](S) sdb[2](S) sda[1] sdc[0]
      244198448 blocks super 1.2 [2/2] [UU]
      [>....................]  resync =  2.1% (5146880/244198448)
finish=773.1min speed=5150K/sec

-- the most important attributes are obtained with: mdadm --detail /dev/md0

Raid Level : raid1
Persistence : Superblock is persistent
State : clean, resyncing
Rebuild Status : 2% complete
UUID : 301792c7:4c8e2854:19398dbf:f9d5253e
Events : 0
Number   Major   Minor   RaidDevice State
       0       8       32        0      active sync   /dev/sata1
       1       8        0        1      active sync   /dev/sata2
       2       8       16        -      spare   /dev/sata3
       3       8       48        -      spare   /dev/sata4

2.  Each individual block device in the array has a state written in its
superblock (mdadm --examine /dev/sataX ):

/dev/sata1: (original)
                     State : active
                     Array Slot : 0 (0, 1)
                     Array State : uU 
/dev/sata2: (mirror)
                    State : active
                    Array Slot : 1 (0, 1)
                    Array State : uu       
/dev/sata3: (spare)
                    State : active
                    Array Slot : 2 (0, 1)
                    Array State : uu      
/dev/sata4: (spare)
                    State : active
                    Array Slot : 3 (0, 1)
                    Array State : uu      

3. When /dev/sata2 is pulled out from the box, md driver kicks this disk out of
the arrray and starts reconstruction and recovery, migrating to 'State : clean,
degraded, recovering' where a spare `jumps in` to support recovery effort:

md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 5000 KB/sec)
for reconstruction.
md: using 128k window, over a total of 244198448 blocks.
md: unbind<sda>                                                                
             <--- kick out: 1st step
md: export_rdev(sda)                                                           
            <--- kick out: 2nd step

md0 : active raid1 sdc[0] sdd[3] sdb[2](S)
      244198448 blocks super 1.2 [2/1] [U_]
      [>....................]  recovery =  0.1% (295168/244198448)
finish=812.5min speed=5002K/sec 

-- the most important attributes are obtained with: mdadm --detail /dev/md0
Raid Level : raid1
Persistence : Superblock is persistent
State : clean, degraded, recovering
Rebuild Status : 1% complete
Events : 4                                                                     
             
UUID : 301792c7:4c8e2854:19398dbf:f9d5253e
       0       8       32        0      active sync   /dev/sata1
       3       8       48        1      spare rebuilding   /dev/sata4          
  <--- the spare disk which jumped in to support recovery
       2       8       16        -      spare   /dev/sata3    

The only managed device that changed its state is the spare, and its superblock
is changed, as well as the metadata for the raid1.

Now, instead of rebooting the box, stop the raid1, then restart it (this is
exactly what`s happening on reboot, isn't it ?)

4. Stop the recovering raid1: ( mdadm --manage -S /dev/md0 )
This is how raid1 behaves:
md: md0 stopped.
md: unbind<sdc>
md: export_rdev(sdc)
md: unbind<sdd>
md: export_rdev(sdd)
md: unbind<sdb>
md: export_rdev(sdb)
mdadm: stopped /dev/md0

NOTE: md0 is out of kernel, but the metadata about it is persistent on each
disk: no mdadm info can be extracted from /dev/md0 in stopped state.  

5. Restart the stopped raid1 ( mdadm --assemble -R /dev/md0 )

mdadm: failed to add /dev/sata3 to /dev/md0                                    
     <----- *** the second spare, sata3  is not added to array md0
md: md0: raid array is not clean -- starting background reconstruction      
<----- md device was in a recovery state (not clean), before the shut down.
Device or resource busy
raid1: raid set md0 active with 1 out of 2 mirrors                             
        <----- this is wrong, md0 should be set to 'State : clean, degraded,
recovering', not 'Active' 
md: syncing RAID array md0                                                     
             *** either some wrong bit is set on assembly (restart), or the
wrong bit was stored on stop
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec)
for reconstruction.
mdadm: /dev/md0 has been started with 2 drives and 2 spares.                <---
*** wrong info, the spare that jumped in to support rebuild, is treated as a
normal mirror disk
md: using 128k window, over a total of 244198448 blocks.                       
                              number of spares and number of drives is bad
md: md0: sync done.                                                            
                <---- what the hack, resync/recovery should start ?!

md0 : active raid1 sdc[0] sdb[2](S) sdd[3]                                     
        <---- sdb is a spare (S) , OK
      244198448 blocks super 1.2 [2/2] [UU]                                    
        <----  state of the raid`s is UU, and was U- before the raid1 shutdown

-- the most important attributes after raid1 restart are obtained with: mdadm
--detail /dev/md0
Raid Level : raid1
Persistence : Superblock is persistent
State : clean                                                                  
                      <--- before shutdown was: {clean, degraded, recovering},
and is not preserved
Rebuild Status : 1% complete
UUID : 301792c7:4c8e2854:19398dbf:f9d5253e
       0       8       32        0      active sync   /dev/sata1               
             <--- original ok
       3       8       48        1      active sync   /dev/sata4               
             <--- *** mirror is not recognized as a spare, which is helping the
rebuild/recovery
       2       8       16        -      spare   /dev/sata3                     
                

6. Check the superblock of each individual disk ( mdadm -E /dev/sata1 ):


/dev/sata1: (original)           CHANGED TO:
                     WAS: State : active       --->  IS: State : clean
                     Array Slot : 0 (0, 1)       --->  IS: Array Slot : 0 (0,
failed, empty, 1)
                     Array State : uU            --->  IS: Array State : Uu 1
failed                               <---- the disk1`s state and the raid1 state
are bad in the disk1`s superblock
/dev/sata2: (mirror)
                    State : active                  taken out 
                    Array Slot : 1 (0, 1)         taken out
                    Array State : uu              taken out
/dev/sata3: (spare)                NOT INCL. INTO md0
                    WAS: State : active          ---> IS: State : active
                    WAS: Array Slot : 2 (0, 1) ---> IS: Array Slot : 2 (0,
failed, empty, 1)                <---- the disk3`s state and the array state are
bad (from within disk3`s SB)
                    WAS: Array State : uu      ---> IS: Array State : uu 1 failed
/dev/sata4: (spare)  ( that jumped in to help recovery)
                    WAS: State : active          --->  IS: State : active
                    WAS: Array Slot : 3 (0, 1) --->  IS: Array Slot : 3 (0,
failed, empty, 1)               <---- the disk4`s state and the array state are
bad (from within didk4`s SB)
                    WAS: Array State : uu      ----> IS: Array State : uU 1 failed 
-----------------------------------------------------------------
 
[3.] Keywords (i.e., modules, networking, kernel):
md, raid1
[4.] Kernel information
2.6.18, mips
[4.1.] Kernel version (from /proc/version):
Linux version 2.6.18
[4.2.] Kernel .config file:
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.18
# Wed Jul 11 11:39:03 2007
#
CONFIG_MIPS=y
 
#
# Machine selection
#
# CONFIG_MIPS_MTX1 is not set
# CONFIG_MIPS_BOSPORUS is not set
# CONFIG_MIPS_PB1000 is not set
# CONFIG_MIPS_PB1100 is not set
# CONFIG_MIPS_PB1500 is not set
# CONFIG_MIPS_PB1550 is not set
# CONFIG_MIPS_PB1200 is not set
# CONFIG_MIPS_DB1000 is not set
# CONFIG_MIPS_DB1100 is not set
# CONFIG_MIPS_DB1500 is not set
# CONFIG_MIPS_DB1550 is not set
# CONFIG_MIPS_DB1200 is not set
# CONFIG_MIPS_MIRAGE is not set
# CONFIG_BASLER_EXCITE is not set
# CONFIG_MIPS_COBALT is not set
# CONFIG_MACH_DECSTATION is not set
# CONFIG_MIPS_EV64120 is not set
# CONFIG_MIPS_EV96100 is not set
# CONFIG_MIPS_IVR is not set
# CONFIG_MIPS_GENERIC_8172 is not set
# CONFIG_MACH_JAZZ is not set
# CONFIG_LASAT is not set
# CONFIG_MIPS_ATLAS is not set
# CONFIG_MIPS_MALTA is not set
# CONFIG_MIPS_SEAD is not set
# CONFIG_WR_PPMC is not set
# CONFIG_MIPS_SIM is not set
# CONFIG_MOMENCO_JAGUAR_ATX is not set
# CONFIG_MOMENCO_OCELOT is not set
# CONFIG_MOMENCO_OCELOT_3 is not set
# CONFIG_MOMENCO_OCELOT_C is not set
# CONFIG_MOMENCO_OCELOT_G is not set
# CONFIG_MIPS_XXS1500 is not set

[5.] Most recent kernel version which did not have the bug:
[6.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
[7.] A small shell script or example program which triggers the
     problem (if possible)
[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)
 
[8.2.] Processor information (from /proc/cpuinfo):
system type             : PMC-Sierra PM74100
Hardware Revision       : 2
processor               : 0
cpu model               : RM9000 V12.1  FPU V2.0
BogoMIPS                : 899.07
wait instruction        : yes
microsecond timers      : yes
tlb_entries             : 64
extra interrupt vector  : no
hardware watchpoint     : yes
ASEs implemented        :
VCED exceptions         : not available
VCEI exceptions         : not available
[8.3.] Module information (from /proc/modules):
aes 32912 0 - Live 0xc0091000
aoe 27584 0 - Live 0xc0071000
bonding 94320 0 - Live 0xc2229000
block2mtd 7264 1 - Live 0xc0038000
[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
f8000000-f800ffff : Sequoia IO MEM 0
f8000000-f80000ff : 0000:00:01.0
f8000400-f80004ff : 0000:00:02.0
f8000400-f80004ff : sata_promise
f8000800-f800087f : 0000:00:02.0
f8000800-f800087f : sata_promise
f9000000-f900ffff : Sequoia IO MEM 1
f9000000-f90000ff : 0000:01:01.0
[8.5.] PCI information ('lspci -vvv' as root)
[8.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi1 Channel: 00 Id: 00 Lun: 00
Vendor: ATA      Model: ST3250820AS      Rev: 3.AA
ype:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
Vendor: ATA      Model: ST3250820AS      Rev: 3.AA
Type:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi3 Channel: 00 Id: 00 Lun: 00
Vendor: ATA      Model: WDC WD2500YS-01S Rev: 20.0
ype:   Direct-Access                    ANSI SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
Vendor: ITE TECH Model:  PEN DRIVE Flash Rev: 2.15
Type:   Direct-Access                    ANSI SCSI revision: 02 
[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
AFTER RESTART:
cat /sys/block/md0/md/*
clean
0
244198448
0
raid1
1.2
0

%cat: /sys/block/md0/md/new_dev: Permission denied
2
18446744073709551615
0.204
0
0
idle
0 / 488396896
0
200000 (system)
1000 (system)
 
%cat /sys/block/md0/md/dev-sdb/*
0
136
244198516
none
spare 
 
%cat /sys/block/md0/md/dev-sdc/*
0
136
244198516
0
in_sync 
%
cat /sys/block/md0/md/dev-sdd/*
0
136
245117308
1
in_sync 
 
[X.] Other notes, patches, fixes, workarounds:

