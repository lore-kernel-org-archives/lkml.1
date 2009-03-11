Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbZCKDjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbZCKDjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 23:39:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZCKDik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 23:38:40 -0400
Received: from mail.windriver.com ([147.11.1.11]:40107 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933AbZCKDij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 23:38:39 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v2 PATCH 0/7] Add AMD8111 and AMD8131 EDAC drivers
Date: Wed, 11 Mar 2009 11:25:50 +0800
Message-Id: <1236741957-3570-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 11 Mar 2009 03:38:24.0429 (UTC) FILETIME=[D5012DD0:01C9A1FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This is the v2 series of patches for EDAC AMD8111 & AMD8131 drivers.
I have integrated suggestions from Bert, Greg and Andrew.
Tests all passed on Maple platform, these modules could be properly
loaded/unloaded, with their sysfs interfaces created/cleaned.

Any suggestions are warmly welcomed!

Best regards,

Harry


Comments:		
---------
Introduce AMD8111 EDAC driver, which makes use of error detections 
on the LPC Bridge Controller and PCI Bridge Controller on the AMD8111 
HyperTransport I/O Hub.

Introduce AMD8131 EDAC driver source file, which makes use of error
detections on the PCI-X Bridge Controllers on the AMD8131 HyperTransport
PCI-X Tunnel.

Since both AMD8111 and AMD8131 EDAC drivers would use edac_pci_ctl_info
structures, EDAC core has to take the responsibility to allocate a unique
"edac_pci_idx" for each of them, by newly added edac_pci_alloc_index().

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

insmod edac_core.ko
dmesg -n 8
insmod amd8111_edac.ko
cd /sys/devices/system/edac
ls -lt
ls -lt pci/ ,etc
ls -lt lpc/ ,etc
rmmod amd8111_edac
insmod amd8131_edac.ko
insmod amd8111_edac.ko
cd /sys/devices/system/edac
ls -lt
ls -lt pci/pci* ,etc
rmmod amd8131_edac
rmmod amd8111_edac

Test results:
-------------

root@localhost:/> insmod edac_core.ko 
root@localhost:/> dmesg -n 8
root@localhost:/> insmod amd8111_edac.ko 
AMD8111 EDAC driver  Ver: 1.0.0 Mar 11 2009
	(c) 2008 Wind River Systems, Inc.
EDAC DEBUG: edac_device_register_sysfs_main_kobj()
amd8111_lpc_bridge_init: port 97 is buggy, not supported by hardware?
EDAC DEBUG: edac_device_add_device()
EDAC DEBUG: find_edac_device_by_dev()
EDAC DEBUG: edac_device_create_sysfs() idx=0
EDAC DEBUG: edac_device_create_instances()
EDAC DEBUG: edac_device_workq_setup()
EDAC DEVICE0: Giving out device to module 'amd8111_edac' controller 'lpc': DEV '0000:00:06.0' (POLLED)
added one edac_dev on AMD8111 vendor 1022, device 7468, name lpc
EDAC DEBUG: edac_pci_alloc_ctl_info()
EDAC DEBUG: edac_pci_add_device()
EDAC DEBUG: add_edac_pci_to_global_list()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_create_sysfs() idx=0
EDAC DEBUG: edac_pci_main_kobj_setup()
EDAC DEBUG: Registered '.../edac/pci' kobject
EDAC DEBUG: edac_pci_create_instance_kobj()
EDAC DEBUG: edac_pci_create_instance_kobj() Register instance 'pci0' kobject
EDAC DEBUG: edac_pci_workq_setup()
EDAC PCI0: Giving out device to module 'amd8111_edac' controller 'AMD8111_PCI_Controller': DEV '0000:00:05.0' (POLLED)
added one edac_pci on AMD8111 vendor 1022, device 7460, name AMD8111_PCI_Controller
root@localhost:/> insmod amd8131_edac.ko
AMD8131 EDAC driver  Ver: 1.0.0 Mar 11 2009
	(c) 2008 Wind River Systems, Inc.
EDAC DEBUG: edac_pci_alloc_ctl_info()
EDAC DEBUG: edac_pci_add_device()
EDAC DEBUG: add_edac_pci_to_global_list()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_create_sysfs() idx=1
EDAC DEBUG: edac_pci_main_kobj_setup()
EDAC DEBUG: edac_pci_create_instance_kobj()
EDAC DEBUG: edac_pci_create_instance_kobj() Register instance 'pci1' kobject
EDAC DEBUG: edac_pci_workq_setup()
EDAC PCI1: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_NORTH_A': DEV '0000:00:01.0' (POLLED)
added one device on AMD8131 vendor 1022, device 7451, devfn 8, name AMD8131_PCIX_NORTH_A
EDAC DEBUG: edac_pci_alloc_ctl_info()
EDAC DEBUG: edac_pci_add_device()
EDAC DEBUG: add_edac_pci_to_global_list()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_create_sysfs() idx=2
EDAC DEBUG: edac_pci_main_kobj_setup()
EDAC DEBUG: edac_pci_create_instance_kobj()
EDAC DEBUG: edac_pci_create_instance_kobj() Register instance 'pci2' kobject
EDAC DEBUG: edac_pci_workq_setup()
EDAC PCI2: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_NORTH_B': DEV '0000:00:02.0' (POLLED)
added one device on AMD8131 vendor 1022, device 7451, devfn 10, name AMD8131_PCIX_NORTH_B
EDAC DEBUG: edac_pci_alloc_ctl_info()
EDAC DEBUG: edac_pci_add_device()
EDAC DEBUG: add_edac_pci_to_global_list()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_create_sysfs() idx=3
EDAC DEBUG: edac_pci_main_kobj_setup()
EDAC DEBUG: edac_pci_create_instance_kobj()
EDAC DEBUG: edac_pci_create_instance_kobj() Register instance 'pci3' kobject
EDAC DEBUG: edac_pci_workq_setup()
EDAC PCI3: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_SOUTH_A': DEV '0000:00:03.0' (POLLED)
added one device on AMD8131 vendor 1022, device 7451, devfn 18, name AMD8131_PCIX_SOUTH_A
EDAC DEBUG: edac_pci_alloc_ctl_info()
EDAC DEBUG: edac_pci_add_device()
EDAC DEBUG: add_edac_pci_to_global_list()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_create_sysfs() idx=4
EDAC DEBUG: edac_pci_main_kobj_setup()
EDAC DEBUG: edac_pci_create_instance_kobj()
EDAC DEBUG: edac_pci_create_instance_kobj() Register instance 'pci4' kobject
EDAC DEBUG: edac_pci_workq_setup()
EDAC PCI4: Giving out device to module 'amd8131_edac' controller 'AMD8131_PCIX_SOUTH_B': DEV '0000:00:04.0' (POLLED)
added one device on AMD8131 vendor 1022, device 7451, devfn 20, name AMD8131_PCIX_SOUTH_B
root@localhost:/> 
root@localhost:/> cd /sys/devices/system/edac/
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 3 root root 0 Oct 30 06:31 lpc
drwxr-xr-x 2 root root 0 Oct 30 06:31 mc
drwxr-xr-x 7 root root 0 Oct 30 06:31 pci
root@localhost:/sys/devices/system/edac> ls -lt lpc
total 0
lrwxrwxrwx 1 root root    0 Oct 30 06:31 device -> ../../../pci0000:00/0000:00:06.0
-rw-r--r-- 1 root root 4096 Oct 30 06:31 log_ce
-rw-r--r-- 1 root root 4096 Oct 30 06:31 log_ue
drwxr-xr-x 2 root root    0 Oct 30 06:31 lpc0
-rw-r--r-- 1 root root 4096 Oct 30 06:31 panic_on_ue
-rw-r--r-- 1 root root 4096 Oct 30 06:31 poll_msec
root@localhost:/sys/devices/system/edac> cd lpc
root@localhost:/sys/devices/system/edac/lpc> cat log_ce 
1
root@localhost:/sys/devices/system/edac/lpc> cat log_ue 
1
root@localhost:/sys/devices/system/edac/lpc> cat panic_on_ue 
0
root@localhost:/sys/devices/system/edac/lpc> echo 1 > panic_on_ue 
root@localhost:/sys/devices/system/edac/lpc> cat panic_on_ue 
1
root@localhost:/sys/devices/system/edac/lpc> cat poll_msec 
1000
root@localhost:/sys/devices/system/edac/lpc> cd lpc0/
root@localhost:/sys/devices/system/edac/lpc/lpc0> ls -lt
total 0
-r--r--r-- 1 root root 4096 Oct 30 06:32 ce_count
-r--r--r-- 1 root root 4096 Oct 30 06:32 ue_count
root@localhost:/sys/devices/system/edac/lpc/lpc0> cat ce_count 
0
root@localhost:/sys/devices/system/edac/lpc/lpc0> cat ue_count 
0
root@localhost:/sys/devices/system/edac/lpc/lpc0> cd ../..
root@localhost:/sys/devices/system/edac> cd pci
root@localhost:/sys/devices/system/edac/pci> ls -lt
total 0
-rw-r--r-- 1 root root 4096 Oct 30 06:32 check_pci_errors
-rw-r--r-- 1 root root 4096 Oct 30 06:32 edac_pci_log_npe
-rw-r--r-- 1 root root 4096 Oct 30 06:32 edac_pci_log_pe
-rw-r--r-- 1 root root 4096 Oct 30 06:32 edac_pci_panic_on_pe
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci0
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci1
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci2
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci3
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci4
-r--r--r-- 1 root root 4096 Oct 30 06:32 pci_nonparity_count
-r--r--r-- 1 root root 4096 Oct 30 06:32 pci_parity_count
root@localhost:/sys/devices/system/edac/pci> cat check_pci_errors 
0
root@localhost:/sys/devices/system/edac/pci> echo 1 > check_pci_errors 
root@localhost:/sys/devices/system/edac/pci> cat check_pci_errors 
1
root@localhost:/sys/devices/system/edac/pci> cat edac_pci_log_npe 
1
root@localhost:/sys/devices/system/edac/pci> cat edac_pci_log_pe  
1
root@localhost:/sys/devices/system/edac/pci> cat edac_pci_panic_on_pe 
0
root@localhost:/sys/devices/system/edac/pci> echo 1 > edac_pci_panic_on_pe 
root@localhost:/sys/devices/system/edac/pci> cat edac_pci_panic_on_pe 
1
root@localhost:/sys/devices/system/edac/pci> cat pci_nonparity_count 
0
root@localhost:/sys/devices/system/edac/pci> cat pci_parity_count 
0
root@localhost:/sys/devices/system/edac/pci> ls -lt
total 0
-rw-r--r-- 1 root root 4096 Oct 30 06:32 edac_pci_panic_on_pe
-rw-r--r-- 1 root root 4096 Oct 30 06:32 check_pci_errors
-rw-r--r-- 1 root root 4096 Oct 30 06:32 edac_pci_log_npe
-rw-r--r-- 1 root root 4096 Oct 30 06:32 edac_pci_log_pe
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci0
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci1
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci2
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci3
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci4
-r--r--r-- 1 root root 4096 Oct 30 06:32 pci_nonparity_count
-r--r--r-- 1 root root 4096 Oct 30 06:32 pci_parity_count
root@localhost:/sys/devices/system/edac/pci> ls -lt pci0
total 0
lrwxrwxrwx 1 root root    0 Oct 30 06:33 device -> ../../../../pci0000:00/0000:00:05.0
-r--r--r-- 1 root root 4096 Oct 30 06:33 npe_count
-r--r--r-- 1 root root 4096 Oct 30 06:33 pe_count
root@localhost:/sys/devices/system/edac/pci> cat pci0/npe_count 
0
root@localhost:/sys/devices/system/edac/pci> cat pci0/pe_count  
0
root@localhost:/sys/devices/system/edac/pci> ls -lt pci*
-r--r--r-- 1 root root 4096 Oct 30 06:32 pci_nonparity_count
-r--r--r-- 1 root root 4096 Oct 30 06:32 pci_parity_count

pci0:
total 0
lrwxrwxrwx 1 root root    0 Oct 30 06:33 device -> ../../../../pci0000:00/0000:00:05.0
-r--r--r-- 1 root root 4096 Oct 30 06:33 npe_count
-r--r--r-- 1 root root 4096 Oct 30 06:33 pe_count

pci1:
total 0
lrwxrwxrwx 1 root root    0 Oct 30 06:33 device -> ../../../../pci0000:00/0000:00:01.0
-r--r--r-- 1 root root 4096 Oct 30 06:33 npe_count
-r--r--r-- 1 root root 4096 Oct 30 06:33 pe_count

pci2:
total 0
lrwxrwxrwx 1 root root    0 Oct 30 06:33 device -> ../../../../pci0000:00/0000:00:02.0
-r--r--r-- 1 root root 4096 Oct 30 06:33 npe_count
-r--r--r-- 1 root root 4096 Oct 30 06:33 pe_count

pci3:
total 0
lrwxrwxrwx 1 root root    0 Oct 30 06:33 device -> ../../../../pci0000:00/0000:00:03.0
-r--r--r-- 1 root root 4096 Oct 30 06:33 npe_count
-r--r--r-- 1 root root 4096 Oct 30 06:33 pe_count

pci4:
total 0
lrwxrwxrwx 1 root root    0 Oct 30 06:33 device -> ../../../../pci0000:00/0000:00:04.0
-r--r--r-- 1 root root 4096 Oct 30 06:33 npe_count
-r--r--r-- 1 root root 4096 Oct 30 06:33 pe_count
root@localhost:/sys/devices/system/edac/pci> cd ..
root@localhost:/sys/devices/system/edac> lsmod
Module                  Size  Used by
amd8131_edac            7456  0 
amd8111_edac           12476  0 
edac_core              82664  4 amd8131_edac,amd8111_edac
root@localhost:/sys/devices/system/edac> rmmod amd8111_edac
EDAC DEBUG: edac_pci_del_device()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_workq_teardown()
EDAC PCI: Removed device 0 for amd8111_edac AMD8111_PCI_Controller: DEV 0000:00:05.0
EDAC DEBUG: edac_pci_free_ctl_info()
EDAC DEBUG: edac_pci_remove_sysfs() index=0
EDAC DEBUG: edac_pci_unregister_sysfs_instance_kobj()
EDAC DEBUG: edac_pci_instance_release()
EDAC DEBUG: edac_pci_remove_sysfs() calling edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_device_del_device()
EDAC DEBUG: find_edac_device_by_dev()
EDAC DEBUG: edac_device_remove_sysfs()
EDAC DEBUG: edac_device_ctrl_instance_release()
EDAC MC: Removed device 0 for amd8111_edac lpc: DEV 0000:00:06.0
EDAC DEBUG: edac_device_unregister_sysfs_main_kobj()
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 6 root root 0 Oct 30 06:33 pci
drwxr-xr-x 2 root root 0 Oct 30 06:31 mc
root@localhost:/sys/devices/system/edac> ls -lt pci
total 0
-rw-r--r-- 1 root root 4096 Oct 30 06:32 edac_pci_panic_on_pe
-rw-r--r-- 1 root root 4096 Oct 30 06:32 check_pci_errors
-rw-r--r-- 1 root root 4096 Oct 30 06:32 edac_pci_log_npe
-rw-r--r-- 1 root root 4096 Oct 30 06:32 edac_pci_log_pe
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci1
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci2
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci3
drwxr-xr-x 2 root root    0 Oct 30 06:32 pci4
-r--r--r-- 1 root root 4096 Oct 30 06:32 pci_nonparity_count
-r--r--r-- 1 root root 4096 Oct 30 06:32 pci_parity_count
root@localhost:/sys/devices/system/edac> rmmod amd8131_edac
EDAC DEBUG: edac_pci_del_device()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_workq_teardown()
EDAC PCI: Removed device 4 for amd8131_edac AMD8131_PCIX_SOUTH_B: DEV 0000:00:04.0
EDAC DEBUG: edac_pci_free_ctl_info()
EDAC DEBUG: edac_pci_remove_sysfs() index=4
EDAC DEBUG: edac_pci_unregister_sysfs_instance_kobj()
EDAC DEBUG: edac_pci_instance_release()
EDAC DEBUG: edac_pci_remove_sysfs() calling edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_del_device()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_workq_teardown()
EDAC PCI: Removed device 3 for amd8131_edac AMD8131_PCIX_SOUTH_A: DEV 0000:00:03.0
EDAC DEBUG: edac_pci_free_ctl_info()
EDAC DEBUG: edac_pci_remove_sysfs() index=3
EDAC DEBUG: edac_pci_unregister_sysfs_instance_kobj()
EDAC DEBUG: edac_pci_instance_release()
EDAC DEBUG: edac_pci_remove_sysfs() calling edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_del_device()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_workq_teardown()
EDAC PCI: Removed device 2 for amd8131_edac AMD8131_PCIX_NORTH_B: DEV 0000:00:02.0
EDAC DEBUG: edac_pci_free_ctl_info()
EDAC DEBUG: edac_pci_remove_sysfs() index=2
EDAC DEBUG: edac_pci_unregister_sysfs_instance_kobj()
EDAC DEBUG: edac_pci_instance_release()
EDAC DEBUG: edac_pci_remove_sysfs() calling edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_del_device()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_workq_teardown()
EDAC PCI: Removed device 1 for amd8131_edac AMD8131_PCIX_NORTH_A: DEV 0000:00:01.0
EDAC DEBUG: edac_pci_free_ctl_info()
EDAC DEBUG: edac_pci_remove_sysfs() index=1
EDAC DEBUG: edac_pci_unregister_sysfs_instance_kobj()
EDAC DEBUG: edac_pci_instance_release()
EDAC DEBUG: edac_pci_remove_sysfs() calling edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_main_kobj_teardown() called kobject_put on main kobj
EDAC DEBUG: edac_pci_release_main_kobj() here to module_put(THIS_MODULE)
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 2 root root 0 Oct 30 06:31 mc
root@localhost:/sys/devices/system/edac> rmmod edac_core
EDAC DEBUG: edac_exit()
root@localhost:/sys/devices/system/edac> ls -lt
total 0
root@localhost:/sys/devices/system/edac> lsmod
Module                  Size  Used by
root@localhost:/sys/devices/system/edac> 


diffstat:
---------
0001-EDAC-AMD8111-driver-header-file.patch
 drivers/edac/amd8111_edac.h |  130 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 130 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd8111_edac.h

0002-EDAC-AMD8111-driver-source-file.patch
 drivers/edac/amd8111_edac.c |  580 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 580 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd8111_edac.c

0003-EDAC-AMD8111-driver-Kconfig-Makefile.patch
 drivers/edac/Kconfig  |    7 +++++++
 drivers/edac/Makefile |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

0004-EDAC-Add-edac_pci_alloc_index.patch
 drivers/edac/edac_core.h |    1 +
 drivers/edac/edac_pci.c  |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

0005-EDAC-AMD8131-driver-header-file.patch
 drivers/edac/amd8131_edac.h |  119 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 119 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd8131_edac.h

0006-EDAC-AMD8131-driver-souce-file.patch
 drivers/edac/amd8131_edac.c |  370 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 370 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd8131_edac.c

0007-EDAC-AMD8131-driver-Kconfig-Makefile.patch
 drivers/edac/Kconfig  |    7 +++++++
 drivers/edac/Makefile |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)
