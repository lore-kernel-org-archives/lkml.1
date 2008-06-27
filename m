Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbYF0Gxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbYF0Gxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759148AbYF0GuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:50:20 -0400
Received: from ns1.suse.de ([195.135.220.2]:46732 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759116AbYF0GuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:50:17 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jun 2008 16:50:10 +1000
Message-Id: <1080627065010.10418@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 008 of 29] md: Close race in md_probe
References: <20080627164503.9671.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a possible race in md_probe.  If two threads call md_probe
for the same device, then one could exit (having checked that
->gendisk exists) before the other has called kobject_init_and_add,
thus returning an incomplete kobj which will cause problems when
we try to add children to it.

So extend the range of protection of disks_mutex slightly to
avoid this possibility.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 15:31:27.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 15:31:35.000000000 +1000
@@ -3359,9 +3359,9 @@ static struct kobject *md_probe(dev_t de
 	disk->queue = mddev->queue;
 	add_disk(disk);
 	mddev->gendisk = disk;
-	mutex_unlock(&disks_mutex);
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype, &disk->dev.kobj,
 				     "%s", "md");
+	mutex_unlock(&disks_mutex);
 	if (error)
 		printk(KERN_WARNING "md: cannot register %s/md - name in use\n",
 		       disk->disk_name);
