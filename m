Return-Path: <linux-kernel-owner+w=401wt.eu-S935778AbZLQEZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935778AbZLQEZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936477AbZLQEYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:24:47 -0500
Received: from kroah.org ([198.145.64.141]:55792 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935788AbZLQEFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:01 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:56 2009
Message-Id: <20091217035655.965379342@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [100/151] dm snapshot: only take lock for statustype info not table
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 94e76572b5dd37b1f0f4b3742ee8a565daead932 upstream.

Take snapshot lock only for STATUSTYPE_INFO, not STATUSTYPE_TABLE.

Commit 4c6fff445d7aa753957856278d4d93bcad6e2c14
(dm-snapshot-lock-snapshot-while-supplying-status.patch)
introduced this use of the lock, but userspace applications using
libdevmapper have been found to request STATUSTYPE_TABLE while the device
is suspended and the lock is already held, leading to deadlock.  Since
the lock is not necessary in this case, don't try to take it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-snap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1152,10 +1152,11 @@ static int snapshot_status(struct dm_tar
 	unsigned sz = 0;
 	struct dm_snapshot *snap = ti->private;
 
-	down_write(&snap->lock);
-
 	switch (type) {
 	case STATUSTYPE_INFO:
+
+		down_write(&snap->lock);
+
 		if (!snap->valid)
 			DMEMIT("Invalid");
 		else {
@@ -1171,6 +1172,9 @@ static int snapshot_status(struct dm_tar
 			else
 				DMEMIT("Unknown");
 		}
+
+		up_write(&snap->lock);
+
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -1185,8 +1189,6 @@ static int snapshot_status(struct dm_tar
 		break;
 	}
 
-	up_write(&snap->lock);
-
 	return 0;
 }
 


