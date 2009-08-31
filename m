Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbZHaI3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbZHaI3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752726AbZHaI3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:29:41 -0400
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:29565 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752719AbZHaI3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:29:39 -0400
X-YMail-OSG: xEZJZJEVM1kWqiyRd8ZwIl7UKFYoLU1R5XkmkH45bpqYik8jfR5jud2y4OqA8BJxkYJmulrW4_PK648yRGdw2KAmSAK7URuzv2ua27A3Kdi4j7KDsVBo8bDzC30SDv1QvrSPZ2HfNZFxpgV4qv_N6HUwhMOZly4nzHcJPDRI8ckDx_oruiRcsJ1Le1UsFbMcdJlJokYs0E2Ag04pBnHpxZGmfhvhI6JFkdQBZ5Huh0G0c1ydrmm.Dz5q6uJZy9ObYF4tzNdqmmqogpz3KaN9Rw--
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 0/4]: Add ALUA primary/secondary access state/status
	metadata support
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Alasdair G Kergon <agk@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 01:29:21 -0700
Message-Id: <1251707361.4136.47.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greeting SCSI and multipath folks,

This patch series to TCM/LIO v3.1 kernel code in lio-core-2.6.git adds support for struct file ALUA metadata
of primary/secondary access state/status to /var/target/alua/, which allows the ALUA metadata to be loaded
into configfs attributes at TCM + fabric bringup time to reinstate the last saved ALUA metadata across target
power loss, reboots, et al.

Here is what an example running layout of metadata in /var/target/alua looks like:

    target:/mnt/sdb/lio-core-2.6.git# tree /var/target/alua/
    /var/target/alua/
    |-- iSCSI  # These are for fabric dependent Port/LUN ALUA secondary access metadata
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.cff3eedbd2fd+1
    |   |   `-- lun_0
    |   `-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0+1
    |       `-- lun_0
    |  # These are for TCM storage object target port group ALUA primary access metadata
    |-- tpgs_41ee70ff-4fbe-4fb8-a690-b3c65639db10
    |-- tpgs_96eb8120-f0fc-40ce-b673-8ac302aa6b4e
    `-- tpgs_a97e4ce21c0711de829b000c2943d57b
        |-- lio_alua_east
        `-- lio_alua_west

This patch series includes new EXPORT_SYMBOL() calls to target_core_alua.c that add generic configfs
store/show handlers for fabric dependent configfs attribute code, as well as the modification to
LIO-Target/ConfigFS to use these generic handlers.  Also, code has been added for calling filp_open() ->
vfs_writev() -> flip_close() for updating the actual struct file in both primary/secondary access state
transitions for both explict (via MO SET_TARGET_PORT_GROUPS) and implict (via configfs) ALUA operations.

[PATCH 1/4] [Target_Core_Mod/ALUA]: Add support for saving primary port metadata across target power loss
[PATCH 2/4] [Target_Core_Mod/ALUA]: Add support for saving secondary fabric port metadata across target power loss
[PATCH 3/4] [Target_Core_Mod]: Add alua mutex initialization in core_alloc_port()
[PATCH 4/4] [LIO-Target/ConfigFS]: Add ALUA secondary access state attributes for saving/reading metadata

 drivers/lio-core/iscsi_target_configfs.c |   54 +++++++
 drivers/target/target_core_alua.c        |  232 +++++++++++++++++++++++++++++-
 drivers/target/target_core_configfs.c    |   75 ++++++++++-
 drivers/target/target_core_device.c      |    1 +
 include/target/target_core_alua.h        |   17 ++-
 include/target/target_core_base.h        |    7 +
 6 files changed, 378 insertions(+), 8 deletions(-)

The userspace commits to make it all go can be found here:

http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=3dbe22aa3941dbf0126490e95e50a2f536721f3e
http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=494e2f6d1163227602d2336cd65d57bf2cf07e78
http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=e632383be4ac3634325551b8fbc152bb2d2f5fc2
http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=4917f200458845468db33b6abd30c1a0cc64fbba
http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=c0d26101ee33aaf284b7b86391cf7c70c9859816
http://git.kernel.org/?p=linux/storage/lio/lio-utils.git;a=commitdiff;h=fa48c904073a878b36e0b92eda28faebea55aafc

Any comments or questions are welcome!

--nab

