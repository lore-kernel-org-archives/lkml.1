Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYI2TV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYI2TV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 15:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbYI2TVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 15:21:49 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:35338 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751786AbYI2TVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 15:21:48 -0400
X-YMail-OSG: d1nRT8MVM1n9osYIhFFzauv4gMIS.MYoY2Dc0HEeKXQqK73JC1cHEBS3gSl0fFEWNEYKzOwkeogGXfDaIfO_gZ7x6M68U8cFsdFVwBCZFR3gTUGcQRJ3aF9f7fprXN.XIYw7VkVflR3fGRsRhJd5excA.5O8kWQerhUI0l8WjkS7J1y9quJpx0nzmq2ssn3XNaqqes3ckGAOzrEjbBtv_e4-
X-Yahoo-Newman-Property: ymail-3
Subject: [ANNOUNCE]: ConfigFS enabled Generic Target Mode and iSCSI Target
	Stack on v2.6.27-rc7
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>,
       SCST-Devel <scst-devel@lists.sourceforge.net>,
       iet-dev <iscsitarget-devel@lists.sourceforge.net>
Cc: Joel Becker <joel.becker@oracle.com>,
       Jerome Martin <tramjoe.merin@gmail.com>, Greg KH <greg@kroah.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Ming Zhang <blackmagic02881@gmail.com>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 12:21:41 -0700
Message-Id: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

I am happy to announce that the first ConfigFS configurable generic
target engine (target_core_mod) and iSCSI Target Stack
(iscsi_target_mod) are now able to use ConfigFS symlinks for the
creation of Linux Storage Objects from drivers/scsi, block, or fs/
storage objects to iSCSI Target Port Endpoints.

The code is available currently running on v2.6.27-rc7 and has been
broken up into a number of commits at:
http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

Now that the primary configfs functionality is up and allowing iSCSI
Initiator Traffic to the symlinked storage objects from a generic target
engine, I will be continuing work on the complete logic for configfs
enabled iscsi_target_mod, as well as removing the legacy IOCTL control
path as equivalent functionality is added with ConfigFS.  

Also, one of the next major steps for the upstream generic target engine
and iSCSI target stack is to include SCST's target mode API between
Engine / Fabric to give target_core_mod a proper Fabric API to allow
other SCST fabric modules to access target_core_mod's configfs enabled
storage objects.  Also, allowing STGT to use the configfs interface to
allow for userspace fabrics to the same target_core_mod storage objects
is also on the list, but I imagine interest from those communities will
certainly help drive those efforts.  

Here are the shell variables required to make it all go:

export CONFIGFS=/sys/kernel/config/
export TARGET=/sys/kernel/config/target/core/
export FABRIC=/sys/kernel/config/target/iscsi/

The storage objects registered with target_core_mod via $TARGET may be
mapped from $TARGET/$HBA/$STORAGE_OBJECT any number of times to:

$FABRIC/$IQN/tpgt_1/lun/lun_0/$PORT_LINK
$FABRIC/$IQN/tpgt_1/lun/lun_1/$PORT_LINK
$FABRIC/$IQN/tpgt_2/lun/lun_0/$PORT_LINK
$FABRIC/$ANOTHER_IQN/tpgt_1/lun_0/$PORT_LINK
....
....

Here are the shell commands to bring storage objects online..

# Create a IBLOCK HBA and virtual storage object
mkdir -p $TARGET/iblock_0/lvm_test0
# Tell the virtual storage object what struct block_device we want
echo iblock_major=254,iblock_minor=2 > $TARGET/iblock_0/lvm_test0/dev_control
# Enable the virtual storage object and call bd_claim()
echo 1 > $TARGET/iblock_0/lvm_test0/dev_enable

DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"

# Create the network portal on $DEF_IQN/tpgt_1
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/np/172.16.201.137:3260"
# Create LUN 0 on $DEF_IQN/tpgt_1
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0"
# Create the iSCSI Target Port Mapping for $DEF_IN/tpgt_1 LUN 0
# to lvm_test0 and give it the port symbolic name of lio_west_port
ln -s $TARGET/iblock_0/lvm_test0 "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0/lio_west_port"

# Allow iSCSI Initiators to login to $DEF_IQN/tpgt_1
#warning Currently uses generate_node_acls=1,cache_dynamic_acls=1,demo_mode_lun_access=1
echo 1 > $FABRIC/$DEF_IQN/tpgt_1/tpg_enable

target:~# tree $CONFIGFS
/sys/kernel/config/
`-- target
    |-- core
    |   `-- iblock_0
    |       |-- hba_info
    |       `-- lvm_test0
    |           |-- dev_control
    |           |-- dev_enable
    |           `-- dev_info
    |-- iscsi
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
    |   |   `-- tpgt_1
    |   |       |-- lun
    |   |       |   `-- lun_0
    |   |       |       |-- lio_west_port -> ../../../../../../target/core/iblock_0/lvm_test0
    |   |       |       |-- port_control
    |   |       |       `-- port_info
    |   |       |-- np
    |   |       |   `-- 172.16.201.137:3260
    |   |       |       `-- portal_info
    |   |       |-- tpg_control
    |   |       `-- tpg_enable
    |   `-- lio_version
    `-- version


----------------------------------------------------------

# Add some more HBA and storage Objects
target:~# mkdir -p $TARGET/fileio_0/file_object
target:~# mkdir -p $TARGET/rd_mcp_0/ramdisk0
target:~# mkdir -p $TARGET/rd_dr_0/ramdisk0

target:~# mkdir -p $TARGET/pscsi_0/sdd
target:~# echo scsi_channel_id=0,scsi_target_id=3,scsi_lun_id=0 > $TARGET/pscsi_0/sdd/dev_control   
target:~# echo 1 > $TARGET/pscsi_0/sdd/dev_enable 

# Now, create LUN 1 and another Port Symlink to a new device on the same $IQN/tpgt_1
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1"
# Create the iSCSI Target Port Mapping for $DEF_IN/tpgt_1 LUN 1
# to lvm_test0 and give it the port symbolic name of lio_east_port
ln -s $TARGET/pscsi_0/sdd/ "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1/lio_east_port"

target:~# tree $CONFIGFS
/sys/kernel/config/
`-- target
    |-- core
    |   |-- fileio_0
    |   |   |-- file_object
    |   |   |   |-- dev_control
    |   |   |   |-- dev_enable
    |   |   |   `-- dev_info
    |   |   `-- hba_info
    |   |-- iblock_0
    |   |   |-- hba_info
    |   |   `-- lvm_test0
    |   |       |-- dev_control
    |   |       |-- dev_enable
    |   |       `-- dev_info
    |   |-- pscsi_0
    |   |   |-- hba_info
    |   |   `-- sdd
    |   |       |-- dev_control
    |   |       |-- dev_enable
    |   |       `-- dev_info
    |   |-- rd_dr_0
    |   |   |-- hba_info
    |   |   `-- ramdisk0
    |   |       |-- dev_control
    |   |       |-- dev_enable
    |   |       `-- dev_info
    |   `-- rd_mcp_0
    |       |-- hba_info
    |       `-- ramdisk0
    |           |-- dev_control
    |           |-- dev_enable
    |           `-- dev_info
    |-- iscsi
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
    |   |   `-- tpgt_1
    |   |       |-- lun
    |   |       |   |-- lun_0
    |   |       |   |   |-- lio_west_port -> ../../../../../../target/core/iblock_0/lvm_test0
    |   |       |   |   |-- port_control
    |   |       |   |   `-- port_info
    |   |       |   `-- lun_1
    |   |       |       |-- lio_east_port -> ../../../../../../target/core/pscsi_0/sdd
    |   |       |       |-- port_control
    |   |       |       `-- port_info
    |   |       |-- np
    |   |       |   `-- 172.16.201.137:3260
    |   |       |       `-- portal_info
    |   |       |-- tpg_control
    |   |       `-- tpg_enable
    |   `-- lio_version
    `-- version

22 directories, 29 files

--nab


