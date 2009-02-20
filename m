Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbZBTIAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbZBTIAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbZBTH7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 02:59:51 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:27448 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752805AbZBTH7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 02:59:49 -0500
X-YMail-OSG: UPlGCDgVM1lo0E79SFO9.eUMrnlYOfuMVHr3qYsrUEGPshqI7jRP5fg5RP61q_jdNXmUJh91y1lBRe3hLZrCNN58KEqks6QEljZ0ForhFXlqHzPb6z4d4lR4B00zMsbnwZahArsl2IMpppP7.Z25ZYsmjFoUpYBaMcR50XuxacN2owf99NMADQS3x6jLC1.KPnbyJkGmEzE_FCM4kDtMuvn8q52.CRY-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 0/7] [Target_Core_Mod]: Add support for 4k physical/virtual
	sector/block size devices
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, Alan Stern <stern@rowland.harvard.edu>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Hannes Reinecke <hare@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 19 Feb 2009 23:58:43 -0800
Message-Id: <1235116723.12375.1031.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

This patch series adds support for 4k, 2k, 1k (eg: all non 512 byte) sector/block
size usage in Target_Core_Mod subsystem plugins.  None 512-byte sector/block size
emulation has been added for virtual objects provided by IBLOCK, FILEIO and RAMDISK
subsystem plugins. 4k sector support SHOULD be working with pSCSI (passthrough to
Linux/SCSI and struct scsi_device) as well, but has not been tested on real 4k sector
capable SAS or SATA SSD hardware just yet.   If anyone would like to test their
4k capable drives against the current code, please let me know your interest!

Here is things look like so far:

*) IBLOCK

echo 4096 > /sys/kernel/config/target/core/iblock_0/lvm_test0/attrib/block_size
cat /sys/kernel/config/target/core/iblock_0/lvm_test0/attrib/*block_size
4096
512

[ 4539.311153] scsi 8:0:0:0: Direct-Access     LIO-ORG  IBLOCK           v3.0 PQ: 0 ANSI: 5
[ 4539.421510] sd 8:0:0:0: [sdg] 128000 4096-byte hardware sectors (524 MB)
[ 4539.533309] sd 8:0:0:0: [sdg] Write Protect is off
[ 4539.533316] sd 8:0:0:0: [sdg] Mode Sense: 2f 00 00 00

*) FILEIO

echo 4096 > /sys/kernel/config/target/core/fileio_0/fileio/attrib/block_size
cat /sys/kernel/config/target/core/fileio_0/fileio/attrib/*block_size
4096
512

[ 4539.975546] scsi 8:0:0:3: Direct-Access     LIO-ORG  FILEIO           v3.0 PQ: 0 ANSI: 5
[ 4539.978280] sd 8:0:0:3: [sdj] 32768 4096-byte hardware sectors (134 MB)
[ 4539.984753] sd 8:0:0:3: [sdj] Write Protect is off
[ 4539.984760] sd 8:0:0:3: [sdj] Mode Sense: 2f 00 00 00

*) RAMDISK

echo 4096 > /sys/kernel/config/target/core/rd_mcp_0/ramdisk/attrib/block_size
cat /sys/kernel/config/target/core/rd_mcp_0/ramdisk/attrib/*block_size
4096
512

[ 4539.655242] scsi 8:0:0:2: Direct-Access     LIO-ORG  RAMDISK-MCP      v3.0 PQ: 0 ANSI: 5
[ 4539.752674] sd 8:0:0:2: [sdi] 32768 4096-byte hardware sectors (134 MB)
[ 4539.757628] sd 8:0:0:2: [sdi] Write Protect is off
[ 4539.757633] sd 8:0:0:2: [sdi] Mode Sense: 2f 00 00 00

This patch series was tested using badblocks -vswf against IBLOCK, FILEIO and RAMDISK storage
objects connected to an Open/iSCSI initiator.  This patch is made against lio-core-2.6.git/master
and tested on v2.6.29-rc5 x86 32-bit HVM.  The lio-core-2.6.git tree can be found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

[PATCH 1/7] [Target_Core_Mod]: Add hw_block_size and block_size device attributes
[PATCH 2/7] [Target_Core_Mod]: Update core logic to use DEV_ATTRIB(dev)->block_size
[PATCH 3/7] [Target_Core_Mod]: Add div64.o to Makefile for target_core_mod
[PATCH 4/7] [Target_Core_Mod/IBLOCK]: Add 4k sector/block size emulation support
[PATCH 5/7] [Target_Core_Mod/FILEIO]: Add 4k sector/block size emulation support
[PATCH 6/7] [Target_Core_Mod/RAMDISK]: Add 4k sector/block size emulation support
[PATCH 7/7] [Target_Core_Mod/ConfigFS]: Add hw_block_size and block_size configfs attributes

 drivers/lio-core/Makefile                |    1 +
 drivers/lio-core/iscsi_target_configfs.c |    6 ++
 drivers/lio-core/target_core_base.h      |    2 +
 drivers/lio-core/target_core_configfs.c  |    8 +++
 drivers/lio-core/target_core_device.c    |   37 +++++++++++
 drivers/lio-core/target_core_device.h    |    1 +
 drivers/lio-core/target_core_file.c      |   58 +++++++++--------
 drivers/lio-core/target_core_iblock.c    |  101 ++++++++++++++++++++++++++++--
 drivers/lio-core/target_core_iblock.h    |    1 -
 drivers/lio-core/target_core_rd.c        |   31 ++++++---
 drivers/lio-core/target_core_seobj.c     |   12 +++-
 drivers/lio-core/target_core_transport.c |   48 +++++++++------
 drivers/lio-core/target_core_transport.h |    4 +-
 13 files changed, 241 insertions(+), 69 deletions(-)

Comments..?

--nab


