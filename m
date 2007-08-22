Return-Path: <linux-kernel-owner+w=401wt.eu-S1760633AbXHVJCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760633AbXHVJCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758240AbXHVIxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:31 -0400
Received: from 1wt.eu ([62.212.114.60]:2080 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757771AbXHVIx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:27 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084016.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:12 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Milan Broz <mbroz@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Patrick McHardy <kaber@trash.net>, Alasdair G Kergon <agk@redhat.com>,
       Christophe Saout <christophe@saout.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 28/58] dm io: fix panic on large request
Content-Disposition: inline; filename=0028-dm-io-fix-panic-on-large-request.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Flush workqueue before releasing bioset and mopools in dm-crypt.  There can
be finished but not yet released request.

Call chain causing oops:
  run workqueue
    dec_pending
      bio_endio(...);
      	<remove device request - remove mempool>
      mempool_free(io, cc->io_pool);

This usually happens when cryptsetup create temporary
luks mapping in the beggining of crypt device activation.

When dm-core calls destructor crypt_dtr, no new request
are possible.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Cc: Patrick McHardy <kaber@trash.net>
Acked-by: Alasdair G Kergon <agk@redhat.com>
Cc: Christophe Saout <christophe@saout.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/md/dm-crypt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b9ff4e3..6b50991 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -917,6 +917,8 @@ static void crypt_dtr(struct dm_target *ti)
 {
 	struct crypt_config *cc = (struct crypt_config *) ti->private;
 
+	flush_workqueue(_kcryptd_workqueue);
+
 	bioset_free(cc->bs);
 	mempool_destroy(cc->page_pool);
 	mempool_destroy(cc->io_pool);
-- 
1.5.2.5

-- 
