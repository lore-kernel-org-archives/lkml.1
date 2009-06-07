Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZFGJVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZFGJVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:21:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZFGJU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:20:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:40558 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbZFGJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:20:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=KP64q0d8Zjef8wj5BoA44enKhevlZxtZxnkfEK0LkiLXP4nGXj3ccDxQeVCyoG7ou5
         uTUvO6DQrRECiE3CHXJGzsNNNDHpgE6wQselGPOnzo7nNMzUOhC7sNtmm2DQSe4UvbaE
         8eLOhcs50ySKnX/rg4u+ElDugsK6oV3DVPTnE=
Date: Sun, 7 Jun 2009 11:20:54 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ide-tape: fix proc warning
Message-ID: <20090607092054.GA26408@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>, bzolnier@gmail.com,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is yet another ide-tape fix against ide-2.6.git/for-next.

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 7 Jun 2009 11:05:53 +0200
Subject: [PATCH] ide-tape: fix proc warning

When accessing ide-tape over the chrdev interface, I get

[  278.147906] ------------[ cut here ]------------
[  278.152685] WARNING: at fs/proc/generic.c:847 remove_proc_entry+0x199/0x1b8()
[  278.160070] Hardware name: P4I45PE    1.00
[  278.160076] remove_proc_entry: removing non-empty directory 'ide0/hdb', leaking at least 'name'
[  278.160080] Modules linked in: rtc intel_agp pcspkr thermal processor thermal_sys parport_pc parport agpgart button
[  278.160100] Pid: 2312, comm: mt Not tainted 2.6.30-rc2 #3
[  278.160105] Call Trace:
[  278.160117]  [<c012141d>] warn_slowpath+0x71/0xa0
[  278.160126]  [<c035f219>] ? _spin_unlock_irqrestore+0x29/0x2c
[  278.160132]  [<c011c686>] ? try_to_wake_up+0x1b6/0x1c0
[  278.160141]  [<c011c69b>] ? default_wake_function+0xb/0xd
[  278.160149]  [<c0177ead>] ? pollwake+0x4a/0x55
[  278.160156]  [<c035f240>] ? _spin_unlock+0x24/0x26
[  278.160163]  [<c0165d38>] ? add_partial+0x44/0x49
[  278.160169]  [<c01669e8>] ? __slab_free+0xba/0x29c
[  278.160177]  [<c01a13d8>] ? sysfs_delete_inode+0x0/0x3c
[  278.160184]  [<c019ca92>] remove_proc_entry+0x199/0x1b8
[  278.160191]  [<c01a297e>] ? remove_dir+0x27/0x2e
[  278.160199]  [<c025f3ab>] ide_proc_unregister_device+0x40/0x4c
[  278.160207]  [<c02599cd>] drive_release_dev+0x14/0x47
[  278.160214]  [<c0250538>] device_release+0x35/0x5a
[  278.160221]  [<c01f8bed>] kobject_release+0x40/0x50
[  278.160226]  [<c01f8bad>] ? kobject_release+0x0/0x50
[  278.160232]  [<c01f96ac>] kref_put+0x3c/0x4a
[  278.160238]  [<c01f8b29>] kobject_put+0x37/0x3c
[  278.160243]  [<c025020c>] put_device+0xf/0x11
[  278.160249]  [<c025789f>] ide_device_put+0x2d/0x30
[  278.160255]  [<c02658da>] ide_tape_put+0x24/0x32
[  278.160261]  [<c0266e0c>] idetape_chrdev_release+0x17f/0x18e
[  278.160269]  [<c016c4f5>] __fput+0xca/0x175
[  278.160275]  [<c016c5b9>] fput+0x19/0x1b
[  278.160280]  [<c0169d19>] filp_close+0x51/0x5b
[  278.160286]  [<c0169d96>] sys_close+0x73/0xad
[  278.160293]  [<c0102a61>] syscall_call+0x7/0xb
[  278.160298] ---[ end trace f16d907ea1f89336 ]---

because it tries to free its proc entry in drive_release_dev()
in the call chain resulting from ide_tape_put() but it chokes on
/proc/ide/ide[01]/hd?/name which is added during driver registration and
should go only at driver removal time.

Add/remove those proc entries everytime the device is accessed.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 055f52e..9d9d771 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -252,6 +252,7 @@ static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
 		else
 			get_device(&tape->dev);
 	}
+	ide_proc_register_driver(tape->drive, tape->driver);
 	mutex_unlock(&idetape_ref_mutex);
 	return tape;
 }
@@ -261,6 +262,7 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 	ide_drive_t *drive = tape->drive;
 
 	mutex_lock(&idetape_ref_mutex);
+	ide_proc_unregister_driver(drive, tape->driver);
 	put_device(&tape->dev);
 	ide_device_put(drive);
 	mutex_unlock(&idetape_ref_mutex);
-- 
1.6.3.1


-- 
Regards/Gruss,
    Boris.
