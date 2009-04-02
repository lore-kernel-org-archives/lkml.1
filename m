Return-Path: <linux-kernel-owner+w=401wt.eu-S934751AbZDBGK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934751AbZDBGK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbZDBGJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:09:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:41531 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbZDBGJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:09:48 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: norsk5@yahoo.com
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v0 PATCH 0/5] Add CPC925 Memory Controller EDAC drivers
Date: Thu,  2 Apr 2009 14:07:15 +0800
Message-Id: <1238652440-9224-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 02 Apr 2009 06:09:39.0602 (UTC) FILETIME=[9B512F20:01C9B359]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Comments:		
---------
Introduce CPC925 Memory Controller EDAC driver, which makes use of error
detections about CPU, ECC and HyperTransport Link on the IBM CPC925
Bridge and Memory Controller.

Since both CPC925 and AMD8131 EDAC drivers would use edac_device_ctl_info
structures, EDAC core has to take the responsibility to allocate a unique
"edac_dev_idx" for each of them, by newly added edac_device_alloc_index().

Note, by far only POLL mode is supported, and they have been tested on 
MAPLE platform, from below test logs we can tell that they could be 
correctly installed and removed, and export proper sysfs interfaces.


Test steps:
-----------
CONFIG_EDAC=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_AMD8111=m
CONFIG_EDAC_AMD8131=m
CONFIG_EDAC_CPC925=m

insmod edac_core.ko
dmesg -n 8
insmod cpc925_edac.ko
cd /sys/devices/system/edac/mc/mc0
ls -lt
ls -lt csrow0/ ,etc
ls -lt csrow4/ ,etc
cd /sys/devices/system/edac/
ls -lt cpu/, etc
ls -lt htlink/, etc
rmmod cpc925_edac
insmod cpc925_edac.ko
insmod amd8131_edac.ko
insmod amd8111_edac.ko
ls -lt


Test results:
-------------
root@localhost:/> insmod edac_core.ko 
root@localhost:/> dmesg -n 8
root@localhost:/> insmod cpc925_edac.ko 
IBM CPC925 EDAC driver  Ver: 1.0.0 Mar 30 2009
	(C) 2008 Wind River Systems, Inc
EDAC DEBUG: cpc925_probe: cpc925_edac platform device found!
EDAC DEBUG: cpc925_mc_get_channels: Dual channel
EDAC DEBUG: edac_mc_register_sysfs_main_kobj()
EDAC DEBUG: edac_mc_register_sysfs_main_kobj() Registered '.../edac/mc0' kobject
EDAC DEBUG: get_total_mem: start 0x0, size 0x80000000
EDAC DEBUG: get_total_mem: start 0x100000000, size 0x80000000
EDAC DEBUG: get_total_mem: total_mem 0x100000000
EDAC DEBUG: edac_mc_add_mc()
EDAC DEBUG: edac_create_sysfs_mci_device() idx=0
EDAC DEBUG: edac_mc_workq_setup()
EDAC MC0: Giving out device to 'cpc925_edac' 'cpc925_edac': DEV cpc925_edac.0
EDAC DEBUG: edac_device_register_sysfs_main_kobj()
EDAC DEBUG: edac_device_add_device()
EDAC DEBUG: find_edac_device_by_dev()
EDAC DEBUG: edac_device_create_sysfs() idx=0
EDAC DEBUG: edac_device_create_instances()
EDAC DEBUG: edac_device_workq_setup()
EDAC DEVICE0: Giving out device to module 'cpc925_edac' controller 'cpu': DEV 'cpu.0' (POLLED)
EDAC DEBUG: cpc925_add_edac_devices: Successfully added edac device for cpu
EDAC DEBUG: edac_device_register_sysfs_main_kobj()
EDAC DEBUG: edac_device_add_device()
EDAC DEBUG: find_edac_device_by_dev()
EDAC DEBUG: edac_device_create_sysfs() idx=1
EDAC DEBUG: edac_device_create_instances()
EDAC DEBUG: edac_device_workq_setup()
EDAC DEVICE1: Giving out device to module 'cpc925_edac' controller 'htlink': DEV 'htlink.0' (POLLED)
EDAC DEBUG: cpc925_add_edac_devices: Successfully added edac device for htlink
EDAC DEBUG: cpc925_probe: success
root@localhost:/> cd /sys/devices/system/edac/
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 3 root root 0 Nov 19 06:27 cpu
drwxr-xr-x 3 root root 0 Nov 19 06:27 htlink
drwxr-xr-x 3 root root 0 Nov 19 06:27 mc
root@localhost:/sys/devices/system/edac> cd mc/mc0
root@localhost:/sys/devices/system/edac/mc/mc0> ls -lt
total 0
-r--r--r-- 1 root root 4096 Nov 19 06:28 ce_count
-r--r--r-- 1 root root 4096 Nov 19 06:28 ce_noinfo_count
drwxr-xr-x 2 root root    0 Nov 19 06:28 csrow0
drwxr-xr-x 2 root root    0 Nov 19 06:28 csrow4
lrwxrwxrwx 1 root root    0 Nov 19 06:28 device -> ../../../../platform/cpc925_edac.0
-r--r--r-- 1 root root 4096 Nov 19 06:28 mc_name
--w------- 1 root root 4096 Nov 19 06:28 reset_counters
-rw-r--r-- 1 root root 4096 Nov 19 06:28 sdram_scrub_rate
-r--r--r-- 1 root root 4096 Nov 19 06:28 seconds_since_reset
-r--r--r-- 1 root root 4096 Nov 19 06:28 size_mb
-r--r--r-- 1 root root 4096 Nov 19 06:28 ue_count
-r--r--r-- 1 root root 4096 Nov 19 06:28 ue_noinfo_count
root@localhost:/sys/devices/system/edac/mc/mc0> cat size_mb 
4096
root@localhost:/sys/devices/system/edac/mc/mc0> cat seconds_since_reset 
35
root@localhost:/sys/devices/system/edac/mc/mc0> cat sdram_scrub_rate 
EDAC DEBUG: cpc925_get_sdram_scrub_rate, Mem Scrub Ctrl Register 0x0
EDAC CPC925 MC0: Scrub mode not enabled
EDAC MC: Scrub rate successfully, fetched: 0
0
root@localhost:/sys/devices/system/edac/mc/mc0> cat ce_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0> cat ce_noinfo_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0> cat ue_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0> cat ue_noinfo_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0> cd csrow0
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> ls -lt
total 0
-r--r--r-- 1 root root 4096 Nov 19 06:28 ce_count
-rw-r--r-- 1 root root 4096 Nov 19 06:28 ch0_ce_count
-rw-r--r-- 1 root root 4096 Nov 19 06:28 ch0_dimm_label
-rw-r--r-- 1 root root 4096 Nov 19 06:28 ch1_ce_count
-rw-r--r-- 1 root root 4096 Nov 19 06:28 ch1_dimm_label
-r--r--r-- 1 root root 4096 Nov 19 06:28 dev_type
-r--r--r-- 1 root root 4096 Nov 19 06:28 edac_mode
-r--r--r-- 1 root root 4096 Nov 19 06:28 mem_type
-r--r--r-- 1 root root 4096 Nov 19 06:28 size_mb
-r--r--r-- 1 root root 4096 Nov 19 06:28 ue_count
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cat dev_type 
x8
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cat edac_mode 
SECDED
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cat mem_type 
Registered-DDR
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cat size_mb 
2048
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cat ce_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cat ue_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cat ch0_ce_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cat ch1_ce_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cat ch0_dimm_label 
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cat ch1_dimm_label 
root@localhost:/sys/devices/system/edac/mc/mc0/csrow0> cd ../csrow4
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> ls -lt
total 0
-r--r--r-- 1 root root 4096 Nov 19 06:29 ce_count
-rw-r--r-- 1 root root 4096 Nov 19 06:29 ch0_ce_count
-rw-r--r-- 1 root root 4096 Nov 19 06:29 ch0_dimm_label
-rw-r--r-- 1 root root 4096 Nov 19 06:29 ch1_ce_count
-rw-r--r-- 1 root root 4096 Nov 19 06:29 ch1_dimm_label
-r--r--r-- 1 root root 4096 Nov 19 06:29 dev_type
-r--r--r-- 1 root root 4096 Nov 19 06:29 edac_mode
-r--r--r-- 1 root root 4096 Nov 19 06:29 mem_type
-r--r--r-- 1 root root 4096 Nov 19 06:29 size_mb
-r--r--r-- 1 root root 4096 Nov 19 06:29 ue_count
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cat dev_type 
Unknown
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cat edac_mode 
SECDED
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cat mem_type 
Registered-DDR
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cat size_mb 
2048
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cat ce_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cat ue_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cat ch0_ce_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cat ch1_ce_count 
0
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cat ch0_dimm_label 
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cat ch1_dimm_label 
root@localhost:/sys/devices/system/edac/mc/mc0/csrow4> cd ../../..
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 3 root root 0 Nov 19 06:27 cpu
drwxr-xr-x 3 root root 0 Nov 19 06:27 htlink
drwxr-xr-x 3 root root 0 Nov 19 06:27 mc
root@localhost:/sys/devices/system/edac> cd cpu
root@localhost:/sys/devices/system/edac/cpu> ls -lt
total 0
drwxr-xr-x 2 root root    0 Nov 19 06:30 cpu0
lrwxrwxrwx 1 root root    0 Nov 19 06:30 device -> ../../../platform/cpu.0
-rw-r--r-- 1 root root 4096 Nov 19 06:30 log_ce
-rw-r--r-- 1 root root 4096 Nov 19 06:30 log_ue
-rw-r--r-- 1 root root 4096 Nov 19 06:30 panic_on_ue
-rw-r--r-- 1 root root 4096 Nov 19 06:30 poll_msec
root@localhost:/sys/devices/system/edac/cpu> cat log_ce 
1
root@localhost:/sys/devices/system/edac/cpu> cat log_ue 
1
root@localhost:/sys/devices/system/edac/cpu> cat panic_on_ue 
0
root@localhost:/sys/devices/system/edac/cpu> echo 1 > panic_on_ue 
root@localhost:/sys/devices/system/edac/cpu> cat panic_on_ue 
1
root@localhost:/sys/devices/system/edac/cpu> cat poll_msec 
1000
root@localhost:/sys/devices/system/edac/cpu> ls -lt cpu0
total 0
-r--r--r-- 1 root root 4096 Nov 19 06:30 ce_count
-r--r--r-- 1 root root 4096 Nov 19 06:30 ue_count
root@localhost:/sys/devices/system/edac/cpu> cat cpu0/ce_count 
0
root@localhost:/sys/devices/system/edac/cpu> cat cpu0/ue_count 
0
root@localhost:/sys/devices/system/edac/cpu> cd ../htlink/
root@localhost:/sys/devices/system/edac/htlink> ls -lt
total 0
lrwxrwxrwx 1 root root    0 Nov 19 06:30 device -> ../../../platform/htlink.0
drwxr-xr-x 2 root root    0 Nov 19 06:30 htlink0
-rw-r--r-- 1 root root 4096 Nov 19 06:30 log_ce
-rw-r--r-- 1 root root 4096 Nov 19 06:30 log_ue
-rw-r--r-- 1 root root 4096 Nov 19 06:30 panic_on_ue
-rw-r--r-- 1 root root 4096 Nov 19 06:30 poll_msec
root@localhost:/sys/devices/system/edac/htlink> cd ..
root@localhost:/sys/devices/system/edac> dmesg -n 4
root@localhost:/sys/devices/system/edac> insmod /amd8111_edac.ko 
root@localhost:/sys/devices/system/edac> insmod /amd8131_edac.ko 
root@localhost:/sys/devices/system/edac> dmesg -n 8
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 3 root root 0 Nov 19 06:31 lpc
drwxr-xr-x 7 root root 0 Nov 19 06:31 pci
drwxr-xr-x 3 root root 0 Nov 19 06:27 cpu
drwxr-xr-x 3 root root 0 Nov 19 06:27 htlink
drwxr-xr-x 3 root root 0 Nov 19 06:27 mc
root@localhost:/sys/devices/system/edac> ls -lt pci
total 0
-rw-r--r-- 1 root root 4096 Nov 19 06:31 check_pci_errors
-rw-r--r-- 1 root root 4096 Nov 19 06:31 edac_pci_log_npe
-rw-r--r-- 1 root root 4096 Nov 19 06:31 edac_pci_log_pe
-rw-r--r-- 1 root root 4096 Nov 19 06:31 edac_pci_panic_on_pe
drwxr-xr-x 2 root root    0 Nov 19 06:31 pci0
drwxr-xr-x 2 root root    0 Nov 19 06:31 pci1
drwxr-xr-x 2 root root    0 Nov 19 06:31 pci2
drwxr-xr-x 2 root root    0 Nov 19 06:31 pci3
drwxr-xr-x 2 root root    0 Nov 19 06:31 pci4
-r--r--r-- 1 root root 4096 Nov 19 06:31 pci_nonparity_count
-r--r--r-- 1 root root 4096 Nov 19 06:31 pci_parity_count
root@localhost:/sys/devices/system/edac> ls -lt lpc/
total 0
lrwxrwxrwx 1 root root    0 Nov 19 06:31 device -> ../../../pci0000:00/0000:00:06.0
-rw-r--r-- 1 root root 4096 Nov 19 06:31 log_ce
-rw-r--r-- 1 root root 4096 Nov 19 06:31 log_ue
drwxr-xr-x 2 root root    0 Nov 19 06:31 lpc0
-rw-r--r-- 1 root root 4096 Nov 19 06:31 panic_on_ue
-rw-r--r-- 1 root root 4096 Nov 19 06:31 poll_msec
root@localhost:/sys/devices/system/edac> lsmod
Module                  Size  Used by
amd8131_edac            7632  0 
amd8111_edac           12528  0 
cpc925_edac            12948  0 
edac_core              83112  8 amd8131_edac,amd8111_edac,cpc925_edac
root@localhost:/sys/devices/system/edac> rmmod cpc925_edac
EDAC DEBUG: edac_device_del_device()
EDAC DEBUG: find_edac_device_by_dev()
EDAC DEBUG: edac_device_remove_sysfs()
EDAC DEBUG: edac_device_ctrl_instance_release()
EDAC MC: Removed device 0 for cpc925_edac cpu: DEV cpu.0
EDAC DEBUG: edac_device_unregister_sysfs_main_kobj()
EDAC DEBUG: cpc925_del_edac_devices: Successfully deleted edac device for cpu
EDAC DEBUG: edac_device_del_device()
EDAC DEBUG: find_edac_device_by_dev()
EDAC DEBUG: edac_device_remove_sysfs()
EDAC DEBUG: edac_device_ctrl_instance_release()
EDAC MC: Removed device 1 for cpc925_edac htlink: DEV htlink.0
EDAC DEBUG: edac_device_unregister_sysfs_main_kobj()
EDAC DEBUG: cpc925_del_edac_devices: Successfully deleted edac device for htlink
EDAC DEBUG: edac_mc_del_mc()
EDAC DEBUG: edac_remove_sysfs_mci_device()
EDAC DEBUG: edac_remove_sysfs_mci_device()  unreg csrow-0
EDAC DEBUG: edac_csrow_instance_release()
EDAC DEBUG: edac_remove_sysfs_mci_device()  unreg csrow-4
EDAC DEBUG: edac_csrow_instance_release()
EDAC DEBUG: edac_remove_sysfs_mci_device()  remove_link
EDAC DEBUG: edac_remove_sysfs_mci_device()  remove_mci_instance
EDAC DEBUG: edac_remove_sysfs_mci_device()  unregister this mci kobj
EDAC DEBUG: edac_mci_control_release() mci instance idx=0 releasing
EDAC MC: Removed device 0 for cpc925_edac cpc925_edac: DEV cpc925_edac.0
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 2 root root 0 Nov 19 06:32 mc
drwxr-xr-x 3 root root 0 Nov 19 06:31 lpc
drwxr-xr-x 7 root root 0 Nov 19 06:31 pci
root@localhost:/sys/devices/system/edac> dmesg -n 4 
root@localhost:/sys/devices/system/edac> insmod /cpc925_edac.ko 
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 3 root root 0 Nov 19 06:32 cpu
drwxr-xr-x 3 root root 0 Nov 19 06:32 htlink
drwxr-xr-x 3 root root 0 Nov 19 06:32 mc
drwxr-xr-x 3 root root 0 Nov 19 06:31 lpc
drwxr-xr-x 7 root root 0 Nov 19 06:31 pci
root@localhost:/sys/devices/system/edac> 


diffstat:
---------
0001-EDAC-Add-CPC925-driver-header-file.patch
 cpc925_edac.h |  283 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 283 insertions(+)

0002-EDAC-Add-CPC925-driver-source-file.patch
 cpc925_edac.c |  757 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 757 insertions(+)

0003-EDAC-Add-CPC925-driver-Kconfig-Makefile.patch
 Kconfig  |    9 +++++++++
 Makefile |    1 +
 2 files changed, 10 insertions(+)

0004-EDAC-Add-edac_device_alloc_index.patch
 amd8111_edac.c |    3 +--
 edac_core.h    |    1 +
 edac_device.c  |   13 +++++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

0005-EDAC-CPC925-MC-platform-device-setup.patch
 setup.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)
