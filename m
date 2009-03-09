Return-Path: <linux-kernel-owner+w=401wt.eu-S1752382AbZCIIUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbZCIIUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 04:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZCIIUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 04:20:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:37082 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbZCIIUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 04:20:23 -0400
From: Harry Ciao <qingtao.cao@windriver.com>
To: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
Subject: [v1 PATCH 0/8] Add AMD8111 and AMD8131 EDAC drivers
Date: Mon,  9 Mar 2009 16:08:09 +0800
Message-Id: <1236586097-3830-1-git-send-email-qingtao.cao@windriver.com>
X-Mailer: git-send-email 1.5.6.2
X-OriginalArrivalTime: 09 Mar 2009 08:20:15.0666 (UTC) FILETIME=[E00FA920:01C9A08F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
root@localhost:/root> insmod edac_core.ko
root@localhost:/root> lsmod 
Module                  Size  Used by
edac_core              83168  0 
root@localhost:/root> ls -lt /sys/devices/system/edac/
total 0
drwxr-xr-x 2 root root 0 May  1 20:52 mc
root@localhost:/root> dmesg -n 8
root@localhost:/root> insmod amd8111_edac.ko 
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
root@localhost:/root> lsmod
Module                  Size  Used by
amd8111_edac           12128  0 
edac_core              83168  3 amd8111_edac
root@localhost:/root> cd /sys/devices/system/edac
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 3 root root 0 May  1 20:52 pci
drwxr-xr-x 3 root root 0 May  1 20:52 lpc
drwxr-xr-x 2 root root 0 May  1 20:52 mc
root@localhost:/sys/devices/system/edac> ls -lt pci
total 0
-rw-r--r-- 1 root root 4096 May  1 20:53 check_pci_errors
-rw-r--r-- 1 root root 4096 May  1 20:53 edac_pci_log_npe
-rw-r--r-- 1 root root 4096 May  1 20:53 edac_pci_log_pe
-rw-r--r-- 1 root root 4096 May  1 20:53 edac_pci_panic_on_pe
-r--r--r-- 1 root root 4096 May  1 20:53 pci_nonparity_count
-r--r--r-- 1 root root 4096 May  1 20:53 pci_parity_count
drwxr-xr-x 2 root root    0 May  1 20:52 pci0
root@localhost:/sys/devices/system/edac> cd pci
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
root@localhost:/sys/devices/system/edac/pci> cd pci0
root@localhost:/sys/devices/system/edac/pci/pci0> ls -lt
total 0
lrwxrwxrwx 1 root root    0 May  1 20:54 device -> ../../../../pci0000:00/0000:00:05.0
-r--r--r-- 1 root root 4096 May  1 20:54 npe_count
-r--r--r-- 1 root root 4096 May  1 20:54 pe_count
root@localhost:/sys/devices/system/edac/pci/pci0> cat npe_count 
0
root@localhost:/sys/devices/system/edac/pci/pci0> cat pe_count 
0
root@localhost:/sys/devices/system/edac/pci/pci0> cd ../..
root@localhost:/sys/devices/system/edac> cd lpc
root@localhost:/sys/devices/system/edac/lpc> ls -lt
total 0
lrwxrwxrwx 1 root root    0 May  1 20:54 device -> ../../../pci0000:00/0000:00:06.0
-rw-r--r-- 1 root root 4096 May  1 20:54 log_ce
-rw-r--r-- 1 root root 4096 May  1 20:54 log_ue
-rw-r--r-- 1 root root 4096 May  1 20:54 panic_on_ue
-rw-r--r-- 1 root root 4096 May  1 20:54 poll_msec
drwxr-xr-x 2 root root    0 May  1 20:52 lpc0
root@localhost:/sys/devices/system/edac/lpc> cat log_ce 
1
root@localhost:/sys/devices/system/edac/lpc> cat log_ue 
1
root@localhost:/sys/devices/system/edac/lpc> cat panic_on_ue 
0
root@localhost:/sys/devices/system/edac/lpc> echo 1 > panic_on_ue 
root@localhost:/sys/devices/system/edac/lpc> cat panic_on_ue 
0
root@localhost:/sys/devices/system/edac/lpc> cat poll_msec 
1000
root@localhost:/sys/devices/system/edac/lpc> ls -lt lpc0/
total 0
-r--r--r-- 1 root root 4096 May  1 20:55 ce_count
-r--r--r-- 1 root root 4096 May  1 20:55 ue_count
root@localhost:/sys/devices/system/edac/lpc> cat lpc0/ce_count 
0
root@localhost:/sys/devices/system/edac/lpc> cat lpc0/ue_count 
0
root@localhost:/sys/devices/system/edac/lpc> cd ..
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
EDAC DEBUG: edac_pci_main_kobj_teardown() called kobject_put on main kobj
EDAC DEBUG: edac_pci_release_main_kobj() here to module_put(THIS_MODULE)
EDAC DEBUG: edac_device_del_device()
EDAC DEBUG: find_edac_device_by_dev()
EDAC DEBUG: edac_device_remove_sysfs()
EDAC DEBUG: edac_device_ctrl_instance_release()
EDAC MC: Removed device 0 for amd8111_edac lpc: DEV 0000:00:06.0
EDAC DEBUG: edac_device_unregister_sysfs_main_kobj()
root@localhost:/sys/devices/system/edac> lsmod
Module                  Size  Used by
edac_core              83168  0 
root@localhost:/sys/devices/system/edac> insmod ~/amd8131_edac.ko 
EDAC DEBUG: edac_pci_alloc_ctl_info()
EDAC DEBUG: edac_pci_add_device()
EDAC DEBUG: add_edac_pci_to_global_list()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_create_sysfs() idx=1
EDAC DEBUG: edac_pci_main_kobj_setup()
EDAC DEBUG: Registered '.../edac/pci' kobject
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
root@localhost:/sys/devices/system/edac> lsmod
Module                  Size  Used by
amd8131_edac            7648  0 
edac_core              83168  2 amd8131_edac
root@localhost:/sys/devices/system/edac> insmod ~/amd8111_edac.ko 
EDAC DEBUG: edac_device_register_sysfs_main_kobj()
amd8111_lpc_bridge_init: port 97 is buggy, not supported by hardware?
EDAC DEBUG: edac_device_add_device()
EDAC DEBUG: find_edac_device_by_dev()
EDAC DEBUG: edac_device_create_sysfs() idx=1
EDAC DEBUG: edac_device_create_instances()
EDAC DEBUG: edac_device_workq_setup()
EDAC DEVICE1: Giving out device to module 'amd8111_edac' controller 'lpc': DEV '0000:00:06.0' (POLLED)
added one edac_dev on AMD8111 vendor 1022, device 7468, name lpc
EDAC DEBUG: edac_pci_alloc_ctl_info()
EDAC DEBUG: edac_pci_add_device()
EDAC DEBUG: add_edac_pci_to_global_list()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_create_sysfs() idx=5
EDAC DEBUG: edac_pci_main_kobj_setup()
EDAC DEBUG: edac_pci_create_instance_kobj()
EDAC DEBUG: edac_pci_create_instance_kobj() Register instance 'pci5' kobject
EDAC DEBUG: edac_pci_workq_setup()
EDAC PCI5: Giving out device to module 'amd8111_edac' controller 'AMD8111_PCI_Controller': DEV '0000:00:05.0' (POLLED)
added one edac_pci on AMD8111 vendor 1022, device 7460, name AMD8111_PCI_Controller
root@localhost:/sys/devices/system/edac> ls -lt
total 0
drwxr-xr-x 7 root root 0 May  1 21:28 pci
drwxr-xr-x 3 root root 0 May  1 21:28 lpc
drwxr-xr-x 2 root root 0 May  1 20:52 mc
root@localhost:/sys/devices/system/edac> cd pci
root@localhost:/sys/devices/system/edac/pci> ls -lt
total 0
-rw-r--r-- 1 root root 4096 May  1 21:28 check_pci_errors
-rw-r--r-- 1 root root 4096 May  1 21:28 edac_pci_log_npe
-rw-r--r-- 1 root root 4096 May  1 21:28 edac_pci_log_pe
-rw-r--r-- 1 root root 4096 May  1 21:28 edac_pci_panic_on_pe
-r--r--r-- 1 root root 4096 May  1 21:28 pci_nonparity_count
-r--r--r-- 1 root root 4096 May  1 21:28 pci_parity_count
drwxr-xr-x 2 root root    0 May  1 21:28 pci5
drwxr-xr-x 2 root root    0 May  1 21:27 pci4
drwxr-xr-x 2 root root    0 May  1 21:27 pci3
drwxr-xr-x 2 root root    0 May  1 21:27 pci2
drwxr-xr-x 2 root root    0 May  1 21:27 pci1
root@localhost:/sys/devices/system/edac/pci> cat check_pci_errors 
1
root@localhost:/sys/devices/system/edac/pci> cat edac_pci_log_npe
1
root@localhost:/sys/devices/system/edac/pci> cat edac_pci_log_pe
1
root@localhost:/sys/devices/system/edac/pci> cat edac_pci_panic_on_pe
1
root@localhost:/sys/devices/system/edac/pci> cat pci_nonparity_count
0
root@localhost:/sys/devices/system/edac/pci> cat pci_parity_count
0
root@localhost:/sys/devices/system/edac/pci> ls -lt pci5
total 0
lrwxrwxrwx 1 root root    0 May  1 21:29 device -> ../../../../pci0000:00/0000:00:05.0
-r--r--r-- 1 root root 4096 May  1 21:29 npe_count
-r--r--r-- 1 root root 4096 May  1 21:29 pe_count
root@localhost:/sys/devices/system/edac/pci> cat pci5/npe_count 
0
root@localhost:/sys/devices/system/edac/pci> cat pci5/pe_count  
0
root@localhost:/sys/devices/system/edac/pci> lsmod
Module                  Size  Used by
amd8111_edac           12128  0 
amd8131_edac            7648  0 
edac_core              83168  4 amd8111_edac,amd8131_edac
root@localhost:/sys/devices/system/edac/pci> rmmod amd8131_edac
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
root@localhost:/sys/devices/system/edac/pci> lsmod
Module                  Size  Used by
amd8111_edac           12128  0 
edac_core              83168  3 amd8111_edac
root@localhost:/sys/devices/system/edac/pci> ls -lt
total 0
-rw-r--r-- 1 root root 4096 May  1 21:28 check_pci_errors
-rw-r--r-- 1 root root 4096 May  1 21:28 edac_pci_log_npe
-rw-r--r-- 1 root root 4096 May  1 21:28 edac_pci_log_pe
-rw-r--r-- 1 root root 4096 May  1 21:28 edac_pci_panic_on_pe
-r--r--r-- 1 root root 4096 May  1 21:28 pci_nonparity_count
-r--r--r-- 1 root root 4096 May  1 21:28 pci_parity_count
drwxr-xr-x 2 root root    0 May  1 21:28 pci5
root@localhost:/sys/devices/system/edac/pci> rmmod amd8111_edac
EDAC DEBUG: edac_pci_del_device()
EDAC DEBUG: find_edac_pci_by_dev()
EDAC DEBUG: edac_pci_workq_teardown()
EDAC PCI: Removed device 5 for amd8111_edac AMD8111_PCI_Controller: DEV 0000:00:05.0
EDAC DEBUG: edac_pci_free_ctl_info()
EDAC DEBUG: edac_pci_remove_sysfs() index=5
EDAC DEBUG: edac_pci_unregister_sysfs_instance_kobj()
EDAC DEBUG: edac_pci_instance_release()
EDAC DEBUG: edac_pci_remove_sysfs() calling edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_main_kobj_teardown()
EDAC DEBUG: edac_pci_main_kobj_teardown() called kobject_put on main kobj
EDAC DEBUG: edac_pci_release_main_kobj() here to module_put(THIS_MODULE)
EDAC DEBUG: edac_device_del_device()
EDAC DEBUG: find_edac_device_by_dev()
EDAC DEBUG: edac_device_remove_sysfs()
EDAC DEBUG: edac_device_ctrl_instance_release()
EDAC MC: Removed device 1 for amd8111_edac lpc: DEV 0000:00:06.0
EDAC DEBUG: edac_device_unregister_sysfs_main_kobj()
root@localhost:/sys/devices/system/edac/pci> lsmod
Module                  Size  Used by
edac_core              83168  0 
root@localhost:/sys/devices/system/edac/pci> 

diffstat:
---------

0001-EDAC-AMD8111-driver-Kconfig-Makefile.patch
 drivers/edac/Kconfig  |    7 +++++++
 drivers/edac/Makefile |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

0002-EDAC-AMD8111-driver-header-file.patch
 drivers/edac/amd8111_edac.h |  130 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 130 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd8111_edac.h

0003-EDAC-AMD8111-driver-source-file.patch
 drivers/edac/amd8111_edac.c |  580 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 580 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd8111_edac.c

0004-EDAC-Add-edac_pci_alloc_index.patch
 drivers/edac/edac_core.h |    1 +
 drivers/edac/edac_pci.c  |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

0005-PCI-Add-AMD8111-PCI-Bridge-PCI-Device-ID.patch
 include/linux/pci_ids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

0006-EDAC-AMD8131-driver-header-file.patch
 drivers/edac/amd8131_edac.h |  119 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 119 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd8131_edac.h

0007-EDAC-AMD8131-driver-souce-file.patch
 drivers/edac/amd8131_edac.c |  370 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 370 insertions(+), 0 deletions(-)
 create mode 100644 drivers/edac/amd8131_edac.c

0008-EDAC-AMD8131-driver-Kconfig-Makefile.patch
 drivers/edac/Kconfig  |    7 +++++++
 drivers/edac/Makefile |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)
