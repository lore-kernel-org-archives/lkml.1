Return-Path: <linux-kernel-owner+w=401wt.eu-S934270AbYEHWvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270AbYEHWvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764908AbYEHWvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:51:22 -0400
Received: from smtp.ono.com ([62.42.230.12]:5420 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934199AbYEHWvR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:51:17 -0400
Date: Fri, 9 May 2008 00:51:11 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linus-IDE <linux-ide@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: The never enfind DRDY saga
Message-ID: <20080509005111.7cf55350@werewolf.home>
X-Mailer: Claws Mail 3.4.0cvs16 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

I'm getting again my friendly DRDY errors, this time on the new disk I got
to replace the old one (that fortunately was still under warranty...).
This is a brand new disk, it came perfectly packaged...
Now it is not a Seagate, but a WD:

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD3200AVJS-63WDA0
Serial Number:    WD-WCARW2347788
Firmware Version: 12.01B02
User Capacity:    320,072,933,376 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Fri May  9 00:33:06 2008 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

I managed to find a reliable way to reproduce the errors.
Copying about 7Gb of data from the SATA to a SCSI disk gave me 3 errors:

ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata3.00: cmd c8/00:00:b7:e9:0f/00:00:00:00:00/e2 tag 0 dma 131072 in
         res 40/00:00:09:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for UDMA/133
ata3: EH complete
sd 4:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

I got the SMART status (smartctl -a /dev/sdd > s?) before and after the errors,
and it shows no problem:

werewolf:~# diff -u s1 s2
--- s1  2008-05-09 00:33:06.000000000 +0200
+++ s2  2008-05-09 00:36:02.000000000 +0200
@@ -9,7 +9,7 @@
 Device is:        Not in smartctl database [for details use: -P showall]
 ATA Version is:   8
 ATA Standard is:  Exact ATA specification draft version not indicated
-Local Time is:    Fri May  9 00:33:06 2008 CEST
+Local Time is:    Fri May  9 00:36:01 2008 CEST
 SMART support is: Available - device has SMART capability.
 SMART support is: Enabled

@@ -53,16 +53,16 @@
 Vendor Specific SMART Attributes with Thresholds:
 ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Always       -       78
-  3 Spin_Up_Time            0x0003   207   159   021    Pre-fail  Always       -       2633
-  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       183
+  3 Spin_Up_Time            0x0003   218   159   021    Pre-fail  Always       -       2091
+  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       184
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
   7 Seek_Error_Rate         0x000e   200   200   051    Old_age   Always       -       0
   9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       787
  10 Spin_Retry_Count        0x0012   100   100   051    Old_age   Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   051    Old_age   Always       -       0
- 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       183
-192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       172
-193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       193
+ 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       184
+192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       173
+193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       194
 194 Temperature_Celsius     0x0022   102   098   000    Old_age   Always       -       45
 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
 197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       -       36

werewolf:~# diff -u s2 s3
--- s2  2008-05-09 00:36:02.000000000 +0200
+++ s3  2008-05-09 00:37:42.000000000 +0200
@@ -9,7 +9,7 @@
 Device is:        Not in smartctl database [for details use: -P showall]
 ATA Version is:   8
 ATA Standard is:  Exact ATA specification draft version not indicated
-Local Time is:    Fri May  9 00:36:01 2008 CEST
+Local Time is:    Fri May  9 00:37:42 2008 CEST
 SMART support is: Available - device has SMART capability.
 SMART support is: Enabled

@@ -54,15 +54,15 @@
 ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Always       -       78
   3 Spin_Up_Time            0x0003   218   159   021    Pre-fail  Always       -       2091
-  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       184
+  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       185
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
   7 Seek_Error_Rate         0x000e   200   200   051    Old_age   Always       -       0
   9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       787
  10 Spin_Retry_Count        0x0012   100   100   051    Old_age   Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   051    Old_age   Always       -       0
- 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       184
-192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       173
-193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       194
+ 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       185
+192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       174
+193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       195
 194 Temperature_Celsius     0x0022   102   098   000    Old_age   Always       -       45
 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
 197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       -       36

werewolf:~# diff -u s3 s4
--- s3  2008-05-09 00:37:42.000000000 +0200
+++ s4  2008-05-09 00:39:12.000000000 +0200
@@ -9,7 +9,7 @@
 Device is:        Not in smartctl database [for details use: -P showall]
 ATA Version is:   8
 ATA Standard is:  Exact ATA specification draft version not indicated
-Local Time is:    Fri May  9 00:37:42 2008 CEST
+Local Time is:    Fri May  9 00:39:12 2008 CEST
 SMART support is: Available - device has SMART capability.
 SMART support is: Enabled

@@ -53,16 +53,16 @@
 Vendor Specific SMART Attributes with Thresholds:
 ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Always       -       78
-  3 Spin_Up_Time            0x0003   218   159   021    Pre-fail  Always       -       2091
-  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       185
+  3 Spin_Up_Time            0x0003   223   159   021    Pre-fail  Always       -       1833
+  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       186
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
   7 Seek_Error_Rate         0x000e   200   200   051    Old_age   Always       -       0
   9 Power_On_Hours          0x0032   099   099   000    Old_age   Always       -       787
  10 Spin_Retry_Count        0x0012   100   100   051    Old_age   Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   051    Old_age   Always       -       0
- 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       185
-192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       174
-193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       195
+ 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       186
+192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       175
+193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       196
 194 Temperature_Celsius     0x0022   102   098   000    Old_age   Always       -       45
 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
 197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Always       -       36

The disk is just spinning up and down...
(btw, why the spin count increases but the spin time decreases???).
I really don't uderstand. Could it be the controller going nuts ?
Any idea ?
I really doubt that I had got 3 faulty drives in a pack and from different
brands.

Some data:
- kernel: 2.6.26-rc1-git6 + blk-lockin-fix + latest-semaphore-fixes
- hadrware:
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 02)
03:0a.0 RAID bus controller: Adaptec ASC-29320 U320 w/HostRAID (rev 03)
03:0a.1 RAID bus controller: Adaptec ASC-29320 U320 w/HostRAID (rev 03)

werewolf:~/soft/linux/kernel/patches/2.6.25-jam06# lsscsi -H
[0]    aic79xx
[1]    aic79xx
[2]    ata_piix
[3]    ata_piix
[4]    ata_piix
[5]    ata_piix

werewolf:~/soft/linux/kernel/patches/2.6.25-jam06# lsscsi
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: left parse failed
sdev_scandir_sort: right parse failed
sdev_scandir_sort: right parse failed
[target1:0:0]type?   vendor?  model?           rev?  -
[target1:0:1]type?   vendor?  model?           rev?  -
[target2:0:0]type?   vendor?  model?           rev?  -
[target2:0:1]type?   vendor?  model?           rev?  -
[target4:0:0]type?   vendor?  model?           rev?  -
[1:0:0:0]    disk    SEAGATE  ST336807LW       0C01  -
[1:0:1:0]    disk    SEAGATE  ST336807LW       0C01  -
[2:0:0:0]    disk    ATA      ST3120022A       3.06  -
[2:0:1:0]    cd/dvd  HL-DT-ST DVDRAM GSA-H10N  JL12  -
[4:0:0:0]    disk    ATA      WDC WD3200AVJS-6 12.0  -

(garbled output due to some bug in latest gits), but you can guess the sd? )

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
