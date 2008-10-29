Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYJ2PNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYJ2PNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYJ2PN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:13:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:41391 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbYJ2PN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:from:date:message-id:user-agent:mime-version
         :content-type:sender;
        b=jmLTfdPhjmM3UJO9LQ9C26bT3SCR7+RTBTN5Z2NyxUx+XHHtiioIarDu0qBtUfLcsu
         /90pCQR2uhf3EIpSIbEjRfuLtgTYJI6D64eD25/n/olwMJ5i8e52gOuBUu+mrLPH72tW
         0scR3sVYXduSQT+baiTlCClGY9VBg/4LpxyJ4=
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: 2.6.28-rc2: (mtd)block/partitions BUG with kobject reference count
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Wed, 29 Oct 2008 16:13:23 +0100
Message-ID: <87ej1z4ep8.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm seing what looks like a kobject reference count issue with
mtdblock_ro + mtd_dataflash + mtd partitions and repeated unbind/bind.
I'm on 2.6.28-rc2, but I can reproduce the problem on 2.6.27 as well.

The issue is that the devices/virtual/bdi/31:<index> doesn't get
released on unbind, so the next bind BUGs with:

mtd_dataflash spi28672.1: AT45DB041x (528 KBytes) pagesize 264 bytes
Creating 2 MTD partitions on "xdb":
0x00000000-0x00000108 : "xdb_id"
blktrans_notify_add(c35258f0), type = 6
sysfs: duplicate filename '31:12' can not be created
------------[ cut here ]------------
Badness at fs/sysfs/dir.c:462
NIP: c0095e74 LR: c0095e74 CTR: c00ed798
REGS: c35c1b00 TRAP: 0700   Not tainted  (2.6.28-rc2)
MSR: 00029032 <EE,ME,IR,DR>  CR: 22002082  XER: 20000000
TASK = c34f1000[310] 'sh' THREAD: c35c0000
GPR00: c0095e74 c35c1bb0 c34f1000 00000038 00001c5f ffffffff c00eddd0
c0249b58
GPR08: c024a004 c023e52c 00001c5f 00000001 44002084 efffffff c00fe4bc
c00fe408
GPR16: c00fecb0 c0100000 c00fe618 c00fe3a8 c00fe348 c00fe570 c00febdc
00000000
GPR24: c35bc20c c35c1cd8 c01e145c c35c1bf8 c387ca28 c35c1bc8 c355cacc
ffffffef
NIP [c0095e74] sysfs_add_one+0x34/0x50
LR [c0095e74] sysfs_add_one+0x34/0x50
Call Trace:
[c35c1bb0] [c0095e74] sysfs_add_one+0x34/0x50 (unreliable)
[c35c1bc0] [c0096464] create_dir+0x58/0xac
[c35c1bf0] [c0096504] sysfs_create_dir+0x4c/0x70
[c35c1c10] [c00cb748] kobject_add_internal+0xc4/0x1b4
[c35c1c30] [c00cbd40] kobject_add+0x80/0x98
[c35c1c60] [c00f1adc] device_add+0x8c/0x490
[c35c1ca0] [c00f1fa4] device_create_vargs+0x94/0xcc
[c35c1cd0] [c004d328] bdi_register+0x64/0x8c
[c35c1d10] [c00c82b4] add_disk+0xe0/0x118
[c35c1d40] [c0101254] add_mtd_blktrans_dev+0x258/0x278
[c35c1d60] [c0101468] mtdblock_add_mtd+0x5c/0x70
[c35c1d70] [c01008f8] blktrans_notify_add+0x58/0x98
[c35c1d90] [c00fde90] add_mtd_device+0xdc/0x140
[c35c1db0] [c00ff3d0] add_mtd_partitions+0x594/0x5d0
[c35c1e00] [c01afd38] add_dataflash_otp+0x190/0x1cc
[c35c1e30] [c01b0000] dataflash_probe+0x28c/0x2ac
[c35c1e60] [c01056f0] spi_drv_probe+0x2c/0x3c
[c35c1e70] [c00f43b4] driver_probe_device+0xe8/0x18c
[c35c1e90] [c00f36b8] driver_bind+0x74/0xd4
[c35c1eb0] [c00f2d10] drv_attr_store+0x34/0x44
[c35c1ec0] [c0095310] sysfs_write_file+0x130/0x1a0
[c35c1ef0] [c005c9d8] vfs_write+0xb8/0x104
[c35c1f10] [c005ce18] sys_write+0x4c/0x8c
[c35c1f40] [c000f3bc] ret_from_syscall+0x0/0x38

I don't see the problem without mtd partitions or with only 1
partition, so it seems related to the partition code.

If I enable kobject debugging I see the following:

bind:

mtd_dataflash spi28672.1: AT45DB041x (528 KBytes) pagesize 264 bytes
Creating 2 MTD partitions on "xdb":
0x00000000-0x00000108 : "xdb_id"
blktrans_notify_add(c35aba44), type = 6
kobject: 'mtdblock12' (c35d6af4): kobject_add_internal: parent: 'block', set: 'devices'
kobject: 'mtdblock12' (c35d6af4): kobject_uevent_env
kobject: 'mtdblock12' (c35d6af4): kobject_uevent_env: filter function caused the event to drop!
kobject: 'holders' (c35abe58): kobject_add_internal: parent: 'mtdblock12', set: '<NULL>'
kobject: 'slaves' (c35abec4): kobject_add_internal: parent: 'mtdblock12', set: '<NULL>'
kobject: 'mtdblock12' (c35d6af4): kobject_uevent_env
kobject: 'mtdblock12' (c35d6af4): fill_kobj_path: path = '/devices/virtual/block/mtdblock12'
kobject: 'queue' (c3477a44): kobject_add_internal: parent: 'mtdblock12', set: '<NULL>'
kobject: 'queue' (c3477a44): kobject_uevent_env
kobject: 'queue' (c3477a44): kobject_uevent_env: filter function caused the event to drop!
kobject: 'iosched' (c3856498): kobject_add_internal: parent: 'queue', set: '<NULL>'
kobject: 'iosched' (c3856498): kobject_uevent_env
kobject: 'iosched' (c3856498): kobject_uevent_env: filter function caused the event to drop!
kobject: '31:12' (c35d6ca8): kobject_add_internal: parent: 'bdi', set: 'devices'
kobject: '31:12' (c35d6ca8): kobject_uevent_env
kobject: '31:12' (c35d6ca8): fill_kobj_path: path = '/devices/virtual/bdi/31:12'
kobject: 'mtd12' (c35d6ddc): kobject_add_internal: parent: 'mtd', set: 'devices'
kobject: 'mtd12' (c35d6ddc): kobject_uevent_env
kobject: 'mtd12' (c35d6ddc): fill_kobj_path: path = '/devices/virtual/mtd/mtd12'
kobject: 'mtd12ro' (c35d6f10): kobject_add_internal: parent: 'mtd', set: 'devices'
kobject: 'mtd12ro' (c35d6f10): kobject_uevent_env
kobject: 'mtd12ro' (c35d6f10): fill_kobj_path: path = '/devices/virtual/mtd/mtd12ro'
0x00000108-0x00084000 : "xdb_fpga"
blktrans_notify_add(c3506730), type = 6
kobject: 'mtdblock13' (c35dc284): kobject_add_internal: parent: 'block', set: 'devices'
kobject: 'mtdblock13' (c35dc284): kobject_uevent_env
kobject: 'mtdblock13' (c35dc284): kobject_uevent_env: filter function caused the event to drop!
kobject: 'holders' (c3543cc0): kobject_add_internal: parent: 'mtdblock13', set: '<NULL>'
kobject: 'slaves' (c35a62f0): kobject_add_internal: parent: 'mtdblock13', set: '<NULL>'
kobject: 'mtdblock13' (c35dc284): kobject_uevent_env
kobject: 'mtdblock13' (c35dc284): fill_kobj_path: path = '/devices/virtual/block/mtdblock13'
kobject: 'queue' (c3477a44): kobject_add_internal: parent: 'mtdblock13', set: '<NULL>'
kobject: 'queue' (c3477a44): kobject_uevent_env
kobject: 'queue' (c3477a44): kobject_uevent_env: filter function caused the event to drop!
kobject: 'iosched' (c3856498): kobject_add_internal: parent: 'queue', set: '<NULL>'
kobject: 'iosched' (c3856498): kobject_uevent_env
kobject: 'iosched' (c3856498): kobject_uevent_env: filter function caused the event to drop!
kobject: '31:13' (c35dc06c): kobject_add_internal: parent: 'bdi', set: 'devices'
kobject: '31:13' (c35dc06c): kobject_uevent_env
kobject: '31:13' (c35dc06c): fill_kobj_path: path = '/devices/virtual/bdi/31:13'
kobject: 'mtd13' (c35dc438): kobject_add_internal: parent: 'mtd', set: 'devices'
kobject: 'mtd13' (c35dc438): kobject_uevent_env
kobject: 'mtd13' (c35dc438): fill_kobj_path: path = '/devices/virtual/mtd/mtd13'
kobject: 'mtd13ro' (c35dc56c): kobject_add_internal: parent: 'mtd', set: 'devices'
kobject: 'mtd13ro' (c35dc56c): kobject_uevent_env
kobject: 'mtd13ro' (c35dc56c): fill_kobj_path: path = '/devices/virtual/mtd/mtd13ro'

unbind:

blktrans_notify_remove(c3506730), type = 6
kobject: '31:13' (c35dc06c): kobject_uevent_env
kobject: '31:13' (c35dc06c): fill_kobj_path: path = '/devices/virtual/bdi/31:13'
kobject: '31:13' (c35dc06c): kobject_cleanup
kobject: '31:13' (c35dc06c): calling ktype release
kobject: '31:13': free name
kobject: 'iosched' (c3856498): kobject_uevent_env
kobject: 'iosched' (c3856498): kobject_uevent_env: filter function caused the event to drop!
kobject: 'queue' (c3477a44): kobject_uevent_env
kobject: 'queue' (c3477a44): kobject_uevent_env: filter function caused the event to drop!
kobject: 'holders' (c3543cc0): kobject_cleanup
kobject: 'holders' (c3543cc0): auto cleanup kobject_del
kobject: 'holders' (c3543cc0): calling ktype release
kobject: (c3543cc0): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (c35a62f0): kobject_cleanup
kobject: 'slaves' (c35a62f0): auto cleanup kobject_del
kobject: 'slaves' (c35a62f0): calling ktype release
kobject: (c35a62f0): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'mtdblock13' (c35dc284): kobject_uevent_env
kobject: 'mtdblock13' (c35dc284): fill_kobj_path: path = '/devices/virtual/block/mtdblock13'
kobject: 'mtdblock13' (c35dc284): kobject_cleanup
kobject: 'mtdblock13' (c35dc284): calling ktype release
kobject: 'mtdblock13': free name
kobject: 'mtd13' (c35dc438): kobject_uevent_env
kobject: 'mtd13' (c35dc438): fill_kobj_path: path = '/devices/virtual/mtd/mtd13'
kobject: 'mtd13' (c35dc438): kobject_cleanup
kobject: 'mtd13' (c35dc438): calling ktype release
kobject: 'mtd13': free name
kobject: 'mtd13ro' (c35dc56c): kobject_uevent_env
kobject: 'mtd13ro' (c35dc56c): fill_kobj_path: path = '/devices/virtual/mtd/mtd13ro'
kobject: 'mtd13ro' (c35dc56c): kobject_cleanup
kobject: 'mtd13ro' (c35dc56c): calling ktype release
kobject: 'mtd13ro': free name
blktrans_notify_remove(c35aba44), type = 6
kobject: 'iosched' (c3856498): kobject_uevent_env
kobject: 'iosched' (c3856498): kobject_uevent_env: attempted to send uevent without kset!
kobject: 'queue' (c3477a44): kobject_uevent_env
kobject: 'queue' (c3477a44): kobject_uevent_env: attempted to send uevent without kset!
kobject: 'holders' (c35abe58): kobject_cleanup
kobject: 'holders' (c35abe58): auto cleanup kobject_del
kobject: 'holders' (c35abe58): calling ktype release
kobject: (c35abe58): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (c35abec4): kobject_cleanup
kobject: 'slaves' (c35abec4): auto cleanup kobject_del
kobject: 'slaves' (c35abec4): calling ktype release
kobject: (c35abec4): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'mtdblock12' (c35d6af4): kobject_uevent_env
kobject: 'mtdblock12' (c35d6af4): fill_kobj_path: path = '/devices/virtual/block/mtdblock12'
kobject: 'mtd12' (c35d6ddc): kobject_uevent_env
kobject: 'mtd12' (c35d6ddc): fill_kobj_path: path = '/devices/virtual/mtd/mtd12'
kobject: 'mtd12' (c35d6ddc): kobject_cleanup
kobject: 'mtd12' (c35d6ddc): calling ktype release
kobject: 'mtd12': free name
kobject: 'mtd12ro' (c35d6f10): kobject_uevent_env
kobject: 'mtd12ro' (c35d6f10): fill_kobj_path: path = '/devices/virtual/mtd/mtd12ro'
kobject: 'mtd12ro' (c35d6f10): kobject_cleanup
kobject: 'mtd12ro' (c35d6f10): calling ktype release
kobject: 'mtd12ro': free name

The 'attempted to send uevent without kset!' seems odd, and the fact
that 31:12 isn't removed + release isn't called for mtdblock12.

To compare, here's the output with only 1 partition:

bind:

mtd_dataflash spi28672.1: AT45DB041x (528 KBytes) pagesize 264 bytes
Creating 1 MTD partitions on "xdb":
0x00000000-0x00000108 : "xdb_id"
blktrans_notify_add(c354823c), type = 6
kobject: 'mtdblock12' (c35c40a4): kobject_add_internal: parent: 'block', set: 'devices'
kobject: 'mtdblock12' (c35c40a4): kobject_uevent_env
kobject: 'mtdblock12' (c35c40a4): kobject_uevent_env: filter function caused the event to drop!
kobject: 'holders' (c355ef34): kobject_add_internal: parent: 'mtdblock12', set: '<NULL>'
kobject: 'slaves' (c3522130): kobject_add_internal: parent: 'mtdblock12', set: '<NULL>'
kobject: 'mtdblock12' (c35c40a4): kobject_uevent_env
kobject: 'mtdblock12' (c35c40a4): fill_kobj_path: path = '/devices/virtual/block/mtdblock12'
kobject: 'queue' (c3477a44): kobject_add_internal: parent: 'mtdblock12', set: '<NULL>'
kobject: 'queue' (c3477a44): kobject_uevent_env
kobject: 'queue' (c3477a44): kobject_uevent_env: filter function caused the event to drop!
kobject: 'iosched' (c3856498): kobject_add_internal: parent: 'queue', set: '<NULL>'
kobject: 'iosched' (c3856498): kobject_uevent_env
kobject: 'iosched' (c3856498): kobject_uevent_env: filter function caused the event to drop!
kobject: '31:12' (c35c4258): kobject_add_internal: parent: 'bdi', set: 'devices'
kobject: '31:12' (c35c4258): kobject_uevent_env
kobject: '31:12' (c35c4258): fill_kobj_path: path = '/devices/virtual/bdi/31:12'
kobject: 'mtd12' (c35c438c): kobject_add_internal: parent: 'mtd', set: 'devices'
kobject: 'mtd12' (c35c438c): kobject_uevent_env
kobject: 'mtd12' (c35c438c): fill_kobj_path: path = '/devices/virtual/mtd/mtd12'
kobject: 'mtd12ro' (c35c44c0): kobject_add_internal: parent: 'mtd', set: 'devices'
kobject: 'mtd12ro' (c35c44c0): kobject_uevent_env
kobject: 'mtd12ro' (c35c44c0): fill_kobj_path: path = '/devices/virtual/mtd/mtd12ro'

unbind:

blktrans_notify_remove(c354823c), type = 6
kobject: '31:12' (c35c4258): kobject_uevent_env
kobject: '31:12' (c35c4258): fill_kobj_path: path = '/devices/virtual/bdi/31:12'
kobject: '31:12' (c35c4258): kobject_cleanup
kobject: '31:12' (c35c4258): calling ktype release
kobject: '31:12': free name
kobject: 'iosched' (c3856498): kobject_uevent_env
kobject: 'iosched' (c3856498): kobject_uevent_env: filter function caused the event to drop!
kobject: 'queue' (c3477a44): kobject_uevent_env
kobject: 'queue' (c3477a44): kobject_uevent_env: filter function caused the event to drop!
kobject: 'holders' (c355ef34): kobject_cleanup
kobject: 'holders' (c355ef34): auto cleanup kobject_del
kobject: 'holders' (c355ef34): calling ktype release
kobject: (c355ef34): dynamic_kobj_release
kobject: 'holders': free name
kobject: 'slaves' (c3522130): kobject_cleanup
kobject: 'slaves' (c3522130): auto cleanup kobject_del
kobject: 'slaves' (c3522130): calling ktype release
kobject: (c3522130): dynamic_kobj_release
kobject: 'slaves': free name
kobject: 'mtdblock12' (c35c40a4): kobject_uevent_env
kobject: 'mtdblock12' (c35c40a4): fill_kobj_path: path = '/devices/virtual/block/mtdblock12'
kobject: 'mtdblock12' (c35c40a4): kobject_cleanup
kobject: 'mtdblock12' (c35c40a4): calling ktype release
kobject: 'mtdblock12': free name
kobject: 'mtd12' (c35c438c): kobject_uevent_env
kobject: 'mtd12' (c35c438c): fill_kobj_path: path = '/devices/virtual/mtd/mtd12'
kobject: 'mtd12' (c35c438c): kobject_cleanup
kobject: 'mtd12' (c35c438c): calling ktype release
kobject: 'mtd12': free name
kobject: 'mtd12ro' (c35c44c0): kobject_uevent_env
kobject: 'mtd12ro' (c35c44c0): fill_kobj_path: path = '/devices/virtual/mtd/mtd12ro'
kobject: 'mtd12ro' (c35c44c0): kobject_cleanup
kobject: 'mtd12ro' (c35c44c0): calling ktype release
kobject: 'mtd12ro': free name

I don't really know the mtd and/or block subsystem good enough to know
where to look - Any ideas?

-- 
Bye, Peter Korsgaard
