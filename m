Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbYESBM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbYESBM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 21:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbYESBLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 21:11:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:50298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205AbYESBK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 21:10:57 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 May 2008 11:10:50 +1000
Message-Id: <1080519011050.7741@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 007 of 10] md: notify userspace on 'stop' events
References: <20080519110910.7473.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dan Williams <dan.j.williams@intel.com>

This additional notification to 'array_state' is needed to allow the monitor
application to learn about stop events via sysfs.  The
sysfs_notify("sync_action") call that comes at the end of do_md_stop() (via
md_new_event) is insufficient since the 'sync_action' attribute has been
removed by this point.

(Seems like a sysfs-notify-on-removal patch is a better fix.  Currently removal
 updates the event count but does not wake up waiters)

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-05-19 11:03:43.000000000 +1000
+++ ./drivers/md/md.c	2008-05-19 11:03:47.000000000 +1000
@@ -3691,6 +3691,8 @@ static int do_md_stop(mddev_t * mddev, i
 
 			module_put(mddev->pers->owner);
 			mddev->pers = NULL;
+			/* tell userspace to handle 'inactive' */
+			sysfs_notify(&mddev->kobj, NULL, "array_state");
 
 			set_capacity(disk, 0);
 			mddev->changed = 1;
