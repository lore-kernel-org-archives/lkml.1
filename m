Return-Path: <linux-kernel-owner+w=401wt.eu-S1763034AbYFDXaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763034AbYFDXaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 19:30:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758401AbYFDX3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 19:29:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46706 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbYFDX3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 19:29:53 -0400
From: Neil Brown <neilb@suse.de>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 5 Jun 2008 09:29:38 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18503.9570.282729.926846@notabene.brown>
Subject: Re: 2.6.25 md oops during boot.
In-Reply-To: message from Neil Brown on Thursday June 5
References: <20080604154137.GA26157@redhat.com>
	<18503.8514.710121.995152@notabene.brown>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday June 5, neilb@suse.de wrote:
> 
> I wouldn't say this is a likely scenario as it requires (I think)
> kmalloc failure very early in boot.  But I cannot see any other
> possible cause.

On closer inspection, I can see another possible cause.  I don't think
it is likely (yet) but it might be possible.

If two threads enter md_probe for the same mddev, then the second one
to get disks_mutex could exit before the first had called
kobject_init_and_add, so it could make available an mddev where
kobj.sd was NULL.

I cannot imagine how two threads could be doing that so early in boot,
but I cannot rule it out.

This (untested) patch should close both these possible problems.

NeilBrown


-----------------
Fix error paths if md_probe fails.

md_probe can fail (e.g. alloc_disk could fail) without
returning an error (as it alway returns NULL).
So when we call mddev_find immediately afterwards, we need
to check that md_probe actually succeeded.  This means checking
that mdev->gendisk is non-NULL.

Also there is a possible race - if two threads call md_probe
for the same device, then one could exit (having checked that
->gendisk exists) before the other has called kobject_init_and_add,
thus returning an incomplete kobj which is cause problems when
we try to add children to it.

So extend the range of protection of disks_mutex slightly to
avoid this possibility.

Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-03 16:35:41.000000000 +1000
+++ ./drivers/md/md.c	2008-06-05 09:19:56.000000000 +1000
@@ -3363,9 +3363,9 @@ static struct kobject *md_probe(dev_t de
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
@@ -3935,8 +3935,10 @@ static void autorun_devices(int part)
 
 		md_probe(dev, NULL, NULL);
 		mddev = mddev_find(dev);
-		if (!mddev) {
-			printk(KERN_ERR 
+		if (!mddev || !mddev->gendisk) {
+			if (mddev)
+				mddev_put(mddev);
+			printk(KERN_ERR
 				"md: cannot allocate memory for md drive.\n");
 			break;
 		}


