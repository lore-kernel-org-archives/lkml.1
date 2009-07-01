Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZGASPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZGASPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755437AbZGASPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:15:25 -0400
Received: from kroah.org ([198.145.64.141]:52152 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755915AbZGASPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:15:24 -0400
Date: Wed, 1 Jul 2009 11:13:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Cc: Milan Broz <mbroz@redhat.com>, Yi Yang <yi.y.yang@intel.com>,
       Jonathan Brassow <jbrassow@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: [patch 110/108] dm exception store: really fix type lookup
Message-ID: <20090701181323.GC3491@kroah.com>
References: <20090701002838.GA7100@kroah.com>
 <20090701181034.GA3491@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701181034.GA3491@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch

---------------------

From: Milan Broz <mbroz@redhat.com>

commit 874d2f61d31e596c36af7732dc1b3aa2dc233824 upstream.

Fix exception store name handling.

We need to reference exception store by zero terminated string.

Fixes regression introduced in commit f6bd4eb73cdf2a5bf954e497972842f39cabb7e3

Cc: Yi Yang <yi.y.yang@intel.com>
Cc: Jonathan Brassow <jbrassow@redhat.com>
Cc: stable@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-exception-store.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -195,7 +195,7 @@ int dm_exception_store_create(struct dm_
 			      struct dm_exception_store **store)
 {
 	int r = 0;
-	struct dm_exception_store_type *type;
+	struct dm_exception_store_type *type = NULL;
 	struct dm_exception_store *tmp_store;
 	char persistent;
 
@@ -211,12 +211,15 @@ int dm_exception_store_create(struct dm_
 	}
 
 	persistent = toupper(*argv[1]);
-	if (persistent != 'P' && persistent != 'N') {
+	if (persistent == 'P')
+		type = get_type("P");
+	else if (persistent == 'N')
+		type = get_type("N");
+	else {
 		ti->error = "Persistent flag is not P or N";
 		return -EINVAL;
 	}
 
-	type = get_type(&persistent);
 	if (!type) {
 		ti->error = "Exception store type not recognised";
 		r = -EINVAL;
