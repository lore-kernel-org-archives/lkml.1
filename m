Return-Path: <linux-kernel-owner+w=401wt.eu-S1762108AbZGAAi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762108AbZGAAi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759029AbZGAAac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:30:32 -0400
Received: from kroah.org ([198.145.64.141]:34410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759928AbZGAAaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:30:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:04:01 2009
Message-Id: <20090701000401.164726524@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:00:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [patch 30/30] dm: sysfs skip output when device is being destroyed
References: <20090630235944.868879272@mini.kroah.org>
Content-Disposition: inline; filename=dm-sysfs-skip-output-when-device-is-being-destroyed.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milan Broz <mbroz@redhat.com>

commit 4d89b7b4e4726893453d0fb4ddbb5b3e16353994 upstream.

Do not process sysfs attributes when device is being destroyed.

Otherwise code can cause
  BUG_ON(test_bit(DMF_FREEING, &md->flags));
in dm_put() call.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -265,6 +265,10 @@ static int dm_blk_open(struct inode *ino
 		goto out;
 	}
 
+	if (test_bit(DMF_FREEING, &md->flags) ||
+	    test_bit(DMF_DELETING, &md->flags))
+		return NULL;
+
 	dm_get(md);
 	atomic_inc(&md->open_count);
 


