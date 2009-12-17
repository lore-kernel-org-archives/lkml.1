Return-Path: <linux-kernel-owner+w=401wt.eu-S936636AbZLQEhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936636AbZLQEhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935352AbZLQEgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:36:19 -0500
Received: from kroah.org ([198.145.64.141]:55531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935014AbZLQEEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:21 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:50 2009
Message-Id: <20091217035650.285311596@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [057/151] NFS: Fix nfs_migrate_page()
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 190f38e5cedc910940b1da9015f00458c18f97b4 upstream.

The call to migrate_page() will cause the page->private field to be
cleared.
Also fix up the locking around the page->private transfer, so that we ensure
that calls to nfs_page_find_request() don't end up racing.

Finally, fix up a double free bug: nfs_unlock_request() already calls
nfs_release_request() for us...

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Tested-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/write.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1612,15 +1612,16 @@ int nfs_migrate_page(struct address_spac
 	if (ret)
 		goto out_unlock;
 	page_cache_get(newpage);
+	spin_lock(&mapping->host->i_lock);
 	req->wb_page = newpage;
 	SetPagePrivate(newpage);
-	set_page_private(newpage, page_private(page));
+	set_page_private(newpage, (unsigned long)req);
 	ClearPagePrivate(page);
 	set_page_private(page, 0);
+	spin_unlock(&mapping->host->i_lock);
 	page_cache_release(page);
 out_unlock:
 	nfs_clear_page_tag_locked(req);
-	nfs_release_request(req);
 out:
 	return ret;
 }


