Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935219Ab0CMA0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:26:38 -0500
Received: from kroah.org ([198.145.64.141]:32850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934882Ab0CMAVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:08 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:15 2010
Message-Id: <20100313001515.103664129@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Wysochanski <dwysocha@redhat.com>,
       Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [patch 114/123] dm ioctl: only issue uevent on resume if state changed
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Mike Snitzer <snitzer@redhat.com>

commit 0f3649a9e305ea22eb196a84a2d7520afcaa6060 upstream.

Only issue a uevent on a resume if the state of the device changed,
i.e. if it was suspended and/or its table was replaced.

Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-ioctl.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -897,16 +897,17 @@ static int do_resume(struct dm_ioctl *pa
 			set_disk_ro(dm_disk(md), 1);
 	}
 
-	if (dm_suspended_md(md))
+	if (dm_suspended_md(md)) {
 		r = dm_resume(md);
+		if (!r)
+			dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
+	}
 
 	if (old_map)
 		dm_table_destroy(old_map);
 
-	if (!r) {
-		dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr);
+	if (!r)
 		r = __dev_status(md, param);
-	}
 
 	dm_put(md);
 	return r;


