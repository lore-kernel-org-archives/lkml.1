Return-Path: <linux-kernel-owner+w=401wt.eu-S1762148AbYHDTZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148AbYHDTZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762043AbYHDTYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:24:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762023AbYHDTYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:24:48 -0400
Date: Mon, 4 Aug 2008 15:24:43 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org
cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: [ANNOUNCE] beta version of LVM snapshot merging
Message-ID: <Pine.LNX.4.64.0808041349570.19355@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'd like announce beta version of snapshot merging. The patches can be 
downloaded at http://people.redhat.com/mpatocka/patches/ The patches are 
against kernel 2.6.26, device-mapper.1.02.27 and LVM2.2.02.39.

The snapshot merging allows you to merge snapshot content back into the 
original device. The most useful use for this feature is the possibility 
to rollback state of the whole computer after failed package upgrade, 
administrator's error or so.

Merging of a snapshot is initiated with command "lvconvert -M 
vg/lv_snapshot". lvconvert polls for the termination of merging and then 
automatically removes the merging snapshot. If the computer crashes, the 
merging resumes after a crash and background polling is restarted too 
(from lvchange -ay or vgchange -ay command).

While the merging is active, any accesses to the origin device are 
dicrected the snapshot that is being merged. When the merging finishes, 
the origin target is seamlessly reloaded and the merging snapshot is 
dropped. The filesystem can stay mounted during this time.

There are three types of merging:

--nameorigin (default) - the resulting logical volume will have name, 
minor number and UUID of the original origin volume. When this mode is 
used, neither snapshot nor the origin can be mounted when the merging 
starts. (but you can mount the origin immediatelly after you start 
merging, you don't have to wait until it finishes)

--namesnapshot - the resulting logical volume will have name, minor number 
and UUID of the snapshot to be merged. When the merging starts, the 
snapshot can be mounted and the origin cannot be mounted.

--onactivate - marks the snapshot for merge on next activate (when 
lvchange -ay or vgchange -ay changes the state from inactiva to active), 
but doesn't do actual merging. This option is useful if you need to merge 
over a filesystem that cannot be unmounted (for example root) --- use 
lvconvert -M --onactivate and reboot the computer. On next reboot, the 
merge will start and the system will run with root filesystem 
corresponding to the snapshot that is being merged.

You can have multiple snapshots before you start merging, any existing 
snapshots are maintained stable (i.e. new exceptions to them are allocated 
if the merging modifies the origin). The exception is --namesnapshot 
option which requires that you have only one snapshot. While the merging 
is in progress, new ssnapshots cannot be created.
For example:
- take snapshot before system-wide package update
- do update
- now suppose that you don't like the result of the update:
- take another snapshot
- initiate -M --onactivate with the first snapshot
- reboot
- after reboot you are running with root filesystem in the state before 
the update and you can examine the result of the update on the second 
snapshot. If you decide that you like the update anyway, you can merge it 
back again (with reboot).
(don't forget to regenerate lvm on your initramdisk if you are going to 
try this on root filesystem).


This implementation of snapshot merging is meant to be stable, report any 
possible bugs to me.

Mikulas
