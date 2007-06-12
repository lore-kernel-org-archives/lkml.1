Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbXFLMkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbXFLMkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754753AbXFLMj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:39:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832AbXFLMj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:39:56 -0400
Message-ID: <466E9433.7090506@redhat.com>
Date: Tue, 12 Jun 2007 13:40:19 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] blkdev_wait_scan module to help initrd scripts
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms060300060102080309030005"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms060300060102080309030005
Content-Type: multipart/mixed;
 boundary="------------080200050002030302030007"

This is a multi-part message in MIME format.
--------------080200050002030302030007
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Why this is needed
------------------

During initrd scripts we load block device modules which asynchronously 
perform partition scans.  These partition checks must have been 
completed before later parts of the scripts run (in particular, vgscan).

Under load, especially for virtual machines, the partition scans aren't 
completed in time and consequently vgscan doesn't find the volume group 
containing root, and the virtual machine fails to boot.

More detail:
   http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=241793#c15

scsi_wait_scan
--------------

SCSI devices have a similar problem.  This is solved by scsi_wait_scan, 
a sort of virtual module which is loaded into the kernel and 
synchronously waits for all SCSI buses to be scanned (it is then 
unloaded right afterwards).  This has been in the kernel since late last 
year.

How it works
------------

I've added a list of block devices which are being scanned for 
partitions (rescan_bdevs).  Function rescan_partitions is modified so 
that during the scan it puts the block device on this list, and takes it 
off after the scan is completed.

I added a function rescan_partitions_wait which checks this list, and 
while it is non-empty, waits for the scan on the first block device on 
the list to complete (and repeats, if necessary, until the list is empty).

The module (blkdev_scan_wait.ko) just calls rescan_partitions_wait 
during its init function.

How to test
-----------

Copy the built module into /lib of an initrd image.  Modify /init so 
that it does:

   echo Wait for partition scans to complete
   insmod /lib/blkdev_wait_scan.ko
   rmmod blkdev_wait_scan
   mkblkdevs

after block devs are loaded but before vgscan is run.

Boot it under load (eg. as a Xen guest with lots of guests starting at 
once or something else stressing the disk).  Logs will look something 
like this (my annotations added):

Registering block device major 202
xvda:Loading dm-mod.ko module        <-- partition scan starts
<6>device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: 
dm-devel@redhat.com
Loading dm-mirror.ko module
Loading dm-zero.ko module
Loading dm-snapshot.ko module
Making device-mapper control node
Wait for partition scans to complete
  xvda1 xvda2           <---- partition scan completes
Scanning logical volumes   <---- vgscan starts
   Reading all physical volumes.  This may take a while...
   Found volume group "VolGroup00" using metadata type lvm2

-----

Signed-off-by: Richard Jones <rjones@redhat.com>

Rich.

-- 
Emerging Technologies, Red Hat - http://et.redhat.com/~rjones/
Registered Address: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
Street, Windsor, Berkshire, SL4 1TE, United Kingdom.  Registered in
England and Wales under Company Registration No. 03798903

--------------080200050002030302030007
Content-Type: text/x-patch;
 name="0001-Added-blkdev_wait_scan-version-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Added-blkdev_wait_scan-version-2.patch"

>From 28779cbc8299da869239732cddab56b5fad4dbf4 Mon Sep 17 00:00:00 2001
From: Richard Jones <rjones@redhat.com>
Date: Thu, 7 Jun 2007 17:05:29 +0100
Subject: [PATCH] Added blkdev_wait_scan version 2.

---
 drivers/block/Kconfig            |   11 ++++++
 drivers/block/Makefile           |    1 +
 drivers/block/blkdev_wait_scan.c |   34 ++++++++++++++++++++
 fs/block_dev.c                   |    1 +
 fs/partitions/check.c            |   63 +++++++++++++++++++++++++++++++++----
 include/linux/fs.h               |    2 +
 include/linux/genhd.h            |    2 +
 7 files changed, 107 insertions(+), 7 deletions(-)
 create mode 100644 drivers/block/blkdev_wait_scan.c

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index b4c8319..df308f3 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -451,6 +451,17 @@ config ATA_OVER_ETH
 	This driver provides Support for ATA over Ethernet block
 	devices like the Coraid EtherDrive (R) Storage Blade.
 
+config BLKDEV_WAIT_SCAN
+       tristate "Module to wait for block devices to finish opening"
+       default m
+       help
+         This module waits for all block devices to finish opening.  The
+         particular use is in initrd scripts, to wait for partition table
+         probing to finish before we start doing vgscan.
+
+         Just modprobe this module after loading block device modules.
+
+
 source "drivers/s390/block/Kconfig"
 
 endmenu
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index dd88e33..f4a63ce 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -29,3 +29,4 @@ obj-$(CONFIG_VIODASD)		+= viodasd.o
 obj-$(CONFIG_BLK_DEV_SX8)	+= sx8.o
 obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
 
+obj-$(CONFIG_BLKDEV_WAIT_SCAN)  += blkdev_wait_scan.o
diff --git a/drivers/block/blkdev_wait_scan.c b/drivers/block/blkdev_wait_scan.c
new file mode 100644
index 0000000..a6b1c9e
--- /dev/null
+++ b/drivers/block/blkdev_wait_scan.c
@@ -0,0 +1,34 @@
+/*
+ * blkdev_wait_scan.c
+ *
+ * Copyright (C) 2007 Red Hat, Richard W.M. Jones <rjones@redhat.com>
+ *
+ * This module waits for all block devices to finish opening.  The
+ * particular use is in initrd scripts, to wait for partition table
+ * probing to finish before we start doing vgscan.
+ *
+ * Just modprobe this module after loading block device modules.
+ *
+ * This is derived from scsi_wait_scan.
+ */
+
+#include <linux/module.h>
+#include <linux/genhd.h>
+
+static int __init blkdev_wait_scan_init(void)
+{
+        rescan_partitions_wait ();
+        return 0;
+}
+
+/* Allow the module to be unloaded. */
+static void __exit blkdev_wait_scan_exit(void)
+{
+}
+
+MODULE_DESCRIPTION("Block device wait for probing to finish");
+MODULE_AUTHOR("Richard W.M. Jones");
+MODULE_LICENSE("GPL");
+
+module_init(blkdev_wait_scan_init);
+module_exit(blkdev_wait_scan_exit);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index ea1480a..9fa5547 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -463,6 +463,7 @@ static void init_once(void * foo, struct kmem_cache * cachep, unsigned long flag
 	sema_init(&bdev->bd_mount_sem, 1);
 	INIT_LIST_HEAD(&bdev->bd_inodes);
 	INIT_LIST_HEAD(&bdev->bd_list);
+	INIT_LIST_HEAD(&bdev->bd_rescan_list);
 #ifdef CONFIG_SYSFS
 	INIT_LIST_HEAD(&bdev->bd_holder_list);
 #endif
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 9a3a058..342e00d 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -527,6 +527,10 @@ exit:
 	}
 }
 
+/* List of block devices which we are currently scanning for partitions. */
+static LIST_HEAD(rescan_bdevs);
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(rescan_bdevs_lock);
+
 int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 {
 	struct parsed_partitions *state;
@@ -534,18 +538,26 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 
 	if (bdev->bd_part_count)
 		return -EBUSY;
+
+        spin_lock(&rescan_bdevs_lock);
+        list_add(&bdev->bd_rescan_list, &rescan_bdevs);
+        spin_unlock(&rescan_bdevs_lock);
+
 	res = invalidate_partition(disk, 0);
-	if (res)
-		return res;
+	if (res) goto done;
 	bdev->bd_invalidated = 0;
 	for (p = 1; p < disk->minors; p++)
 		delete_partition(disk, p);
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
-	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
-		return 0;
-	if (IS_ERR(state))	/* I/O error reading the partition table */
-		return -EIO;
+	if (!get_capacity(disk) || !(state = check_partition(disk, bdev))) {
+		res = 0;
+		goto done;
+	}
+	if (IS_ERR(state)) {	/* I/O error reading the partition table */
+		res = -EIO;
+		goto done;
+	}
 	for (p = 1; p < state->limit; p++) {
 		sector_t size = state->parts[p].size;
 		sector_t from = state->parts[p].from;
@@ -562,9 +574,46 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 #endif
 	}
 	kfree(state);
-	return 0;
+	res = 0;
+
+ done:
+	spin_lock(&rescan_bdevs_lock);
+	list_del(&bdev->bd_rescan_list);
+	spin_unlock(&rescan_bdevs_lock);
+	return res;
 }
 
+/**
+ * rescan_partitions_wait - wait for all block devices to finish
+ *   scanning partition tables.
+ *
+ * This is called by blkdev_wait_scan module.
+ */
+void rescan_partitions_wait(void)
+{
+	struct block_device *bd;
+
+	spin_lock(&rescan_bdevs_lock);
+	while (!list_empty(&rescan_bdevs)) {
+		/* Get the head block device on the list. */
+		bd = list_entry(rescan_bdevs.next,
+				struct block_device, bd_rescan_list);
+		spin_unlock(&rescan_bdevs_lock);
+
+		/* While rescanning the bd_mutex has been acquired, so
+		 * trying to grab it here will block until the rescan
+		 * has completed.
+		 */	
+		mutex_lock(&bd->bd_mutex);
+		mutex_unlock(&bd->bd_mutex);
+
+		spin_lock(&rescan_bdevs_lock);
+	}
+	spin_unlock(&rescan_bdevs_lock);
+}
+
+EXPORT_SYMBOL_GPL(rescan_partitions_wait);
+
 unsigned char *read_dev_sector(struct block_device *bdev, sector_t n, Sector *p)
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ae77c..a96da6d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -477,6 +477,8 @@ struct block_device {
 	int			bd_invalidated;
 	struct gendisk *	bd_disk;
 	struct list_head	bd_list;
+	/* on this list if we are doing a partition scan: */
+	struct list_head        bd_rescan_list;
 	struct backing_dev_info *bd_inode_backing_dev_info;
 	/*
 	 * Private data.  You must have bd_claim'ed the block_device
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 9756fc1..4c8fa75 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -418,6 +418,8 @@ extern void add_partition(struct gendisk *, int, sector_t, sector_t, int);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
 
+extern void rescan_partitions_wait(void);
+
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
 extern struct kobject *get_disk(struct gendisk *disk);
-- 
1.5.0.6


--------------080200050002030302030007--

--------------ms060300060102080309030005
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJAzCC
AtwwggJFoAMCAQICEAS4dW+HXx5T2s1p+JnOIgkwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDIxOTEwMDIxOFoX
DTA4MDIxOTEwMDIxOFowQzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEgMB4G
CSqGSIb3DQEJARYRcmpvbmVzQHJlZGhhdC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDPJ872hlyuT89WhxOjsWO6ZmnJXFozZHACO5WRaOGKE63VWbYdrWrW2zhV11ND
kiZ5nI2IZoN2sga57/bLs1Wcc3W7VCEQ/vP+YqnzvzBPnt9e1gD/Rte64hiNeP58cGjbzjMx
AcBa1ICHzwniYxEP1QAiSu0Hk6ecRiMVVXYxCwa1D46klRkVPtQT89EIXS5Z4EOqQy83UZh/
XdgcsadaRxsgkQNgOif6M1pR149uuW0STunhuaNBz8eNRKFTkmn7Mb+claNdiedViabqgbOt
F7NJjPPivv/aBEPb7e2cRa/SSdziRFZUA5w8Kvpr6JQW6cipV2KwnAMJOwhlgjMlAgMBAAGj
LjAsMBwGA1UdEQQVMBOBEXJqb25lc0ByZWRoYXQuY29tMAwGA1UdEwEB/wQCMAAwDQYJKoZI
hvcNAQEFBQADgYEAwQGFC+ULhnDVOGH/1FhxI7v56HVlKkkXk7Xazf3m/vk3s6lBjrUW9VAe
c7f8uGEIRAyDsWQN/yyVxmwRFleEK6UiZFIOVTTH0Pcb5XSibBO5v7y3TILeqtGQcRYJwT0m
1K5LkZobCUGeZgw0KjCFeLzPzlxv7efYBheyJyFoRB4wggLcMIICRaADAgECAhAEuHVvh18e
U9rNafiZziIJMA0GCSqGSIb3DQEBBQUAMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3
dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJl
ZW1haWwgSXNzdWluZyBDQTAeFw0wNzAyMTkxMDAyMThaFw0wODAyMTkxMDAyMThaMEMxHzAd
BgNVBAMTFlRoYXd0ZSBGcmVlbWFpbCBNZW1iZXIxIDAeBgkqhkiG9w0BCQEWEXJqb25lc0By
ZWRoYXQuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzyfO9oZcrk/PVocT
o7FjumZpyVxaM2RwAjuVkWjhihOt1Vm2Ha1q1ts4VddTQ5ImeZyNiGaDdrIGue/2y7NVnHN1
u1QhEP7z/mKp878wT57fXtYA/0bXuuIYjXj+fHBo284zMQHAWtSAh88J4mMRD9UAIkrtB5On
nEYjFVV2MQsGtQ+OpJUZFT7UE/PRCF0uWeBDqkMvN1GYf13YHLGnWkcbIJEDYDon+jNaUdeP
brltEk7p4bmjQc/HjUShU5Jp+zG/nJWjXYnnVYmm6oGzrRezSYzz4r7/2gRD2+3tnEWv0knc
4kRWVAOcPCr6a+iUFunIqVdisJwDCTsIZYIzJQIDAQABoy4wLDAcBgNVHREEFTATgRFyam9u
ZXNAcmVkaGF0LmNvbTAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAMEBhQvlC4Zw
1Thh/9RYcSO7+eh1ZSpJF5O12s395v75N7OpQY61FvVQHnO3/LhhCEQMg7FkDf8slcZsERZX
hCulImRSDlU0x9D3G+V0omwTub+8t0yC3qrRkHEWCcE9JtSuS5GaGwlBnmYMNCowhXi8z85c
b+3n2AYXsichaEQeMIIDPzCCAqigAwIBAgIBDTANBgkqhkiG9w0BAQUFADCB0TELMAkGA1UE
BhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTESMBAGA1UEBxMJQ2FwZSBUb3duMRowGAYD
VQQKExFUaGF3dGUgQ29uc3VsdGluZzEoMCYGA1UECxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNl
cyBEaXZpc2lvbjEkMCIGA1UEAxMbVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIENBMSswKQYJ
KoZIhvcNAQkBFhxwZXJzb25hbC1mcmVlbWFpbEB0aGF3dGUuY29tMB4XDTAzMDcxNzAwMDAw
MFoXDTEzMDcxNjIzNTk1OVowYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25z
dWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEpjxVc1X7TrnKmVoeaMB1
BHCd3+n/ox7svc31W/Iadr1/DDph8r9RzgHU5VAKMNcCY1osiRVwjt3J8CuFWqo/cVbLrzwL
B+fxH5E2JCoTzyvV84J3PQO+K/67GD4Hv0CAAmTXp6a7n2XRxSpUhQ9IBH+nttE8YQRAHmQZ
cmC3+wIDAQABo4GUMIGRMBIGA1UdEwEB/wQIMAYBAf8CAQAwQwYDVR0fBDwwOjA4oDagNIYy
aHR0cDovL2NybC50aGF3dGUuY29tL1RoYXd0ZVBlcnNvbmFsRnJlZW1haWxDQS5jcmwwCwYD
VR0PBAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFiZWwyLTEzODAN
BgkqhkiG9w0BAQUFAAOBgQBIjNFQg+oLLswNo2asZw9/r6y+whehQ5aUnX9MIbj4Nh+qLZ82
L8D0HFAgk3A8/a3hYWLD2ToZfoSxmRsAxRoLgnSeJVCUYsfbJ3FXJY3dqZw5jowgT2Vfldr3
94fWxghOrvbqNOUQGls1TXfjViF4gtwhGTXeJLHTHUb/XV9lTzGCA2QwggNgAgEBMHYwYjEL
MAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAEuHVvh18eU9rN
afiZziIJMAkGBSsOAwIaBQCgggHDMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZI
hvcNAQkFMQ8XDTA3MDYxMjEyNDAxOVowIwYJKoZIhvcNAQkEMRYEFMm0Md0ALR707Zzf0pXK
zSgMOK8jMFIGCSqGSIb3DQEJDzFFMEMwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0G
CCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGFBgkrBgEEAYI3EAQxeDB2
MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQu
MSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQBLh1b4df
HlPazWn4mc4iCTCBhwYLKoZIhvcNAQkQAgsxeKB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQK
ExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29u
YWwgRnJlZW1haWwgSXNzdWluZyBDQQIQBLh1b4dfHlPazWn4mc4iCTANBgkqhkiG9w0BAQEF
AASCAQCciVgly09xP6zIYDXUt9mdQ1ZRFJOE3Jut+2JHZ8f+uubnM5lORgIsWRi4Ni4W2uCL
qUlv/zTDI01kE/puLHik4yJxnhXI+3fdUMfOYuEOEII46hEMUA6D3GXr7KWLxajWav4nQ9hw
Tybpzf6TjXoh9FEKs8LqerQCm8Lr9hhjMPn0Bev3wmdxFc+sWzopY7aXKo7dpZUJws4pgH/g
2j5/OOqlzckhKUSVHbTXtqLI5npRsO8SBTDawtTVndBg5jYqh/S9vlkEhg3FNDXGST9kk7ly
Xgmw6PEPTfA51Ts/EFfX7gwG3i7nBGb3vgWNhC6abgo059Z76ww9CoY2hEGOAAAAAAAA
--------------ms060300060102080309030005--
