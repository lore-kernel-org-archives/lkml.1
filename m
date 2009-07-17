Return-Path: <linux-kernel-owner+w=401wt.eu-S1756139AbZGQUVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139AbZGQUVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZGQUVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:21:43 -0400
Received: from kroah.org ([198.145.64.141]:43121 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbZGQUTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:19:51 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:12:34 2009
Message-Id: <20090717201234.451772052@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:09:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [patch 16/24] md: fix error path when duplicate name is found on md device creation.
References: <20090717200851.907421303@mini.kroah.org>
Content-Disposition: inline; filename=md-fix-error-path-when-duplicate-name-is-found-on-md-device-creation.patch
In-Reply-To: <20090717201639.GA14209@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 1ec22eb2b4a2e1a763106bce36b11c02eaa84e61 upstream.

When an md device is created by name (rather than number) we need to
check that the name is not already in use.  If this check finds a
duplicate, we return an error without dropping the lock or freeing
the newly create mddev.
This patch fixes that.

Found-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3876,6 +3876,8 @@ static int md_alloc(dev_t dev, char *nam
 			if (mddev2->gendisk &&
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
+				mutex_unlock(&disks_mutex);
+				mddev_put(mddev);
 				return -EEXIST;
 			}
 		spin_unlock(&all_mddevs_lock);


