Return-Path: <linux-kernel-owner+w=401wt.eu-S932909AbZKFWk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909AbZKFWk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932482AbZKFWkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:40:25 -0500
Received: from kroah.org ([198.145.64.141]:56752 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357AbZKFWWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:38 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:41 2009
Message-Id: <20091106221541.821263847@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [24/99] dm snapshot: lock snapshot while supplying status
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=dm-snapshot-lock-snapshot-while-supplying-status.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikulas Patocka <mpatocka@redhat.com>

commit 4c6fff445d7aa753957856278d4d93bcad6e2c14 upstream.

This patch locks the snapshot when returning status.  It fixes a race
when it could return an invalid number of free chunks if someone
was simultaneously modifying it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1147,6 +1147,8 @@ static int snapshot_status(struct dm_tar
 	unsigned sz = 0;
 	struct dm_snapshot *snap = ti->private;
 
+	down_write(&snap->lock);
+
 	switch (type) {
 	case STATUSTYPE_INFO:
 		if (!snap->valid)
@@ -1178,6 +1180,8 @@ static int snapshot_status(struct dm_tar
 		break;
 	}
 
+	up_write(&snap->lock);
+
 	return 0;
 }
 


