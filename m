Return-Path: <linux-kernel-owner+w=401wt.eu-S1031611AbXEHTps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031611AbXEHTps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031605AbXEHTpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:45:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031603AbXEHTpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:45:41 -0400
Date: Tue, 8 May 2007 20:44:42 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, olaf.kirch@oracle.com
Subject: [2.6.22 PATCH 05/26] dm crypt: fix avoid cloned bio ref after free
Message-ID: <20070508194442.GL24114@agk.fab.redhat.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	olaf.kirch@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: olaf.kirch@oracle.com

Do not access the bio after generic_make_request

We should never access a bio after generic_make_request - there's
no guarantee it still exists.

Signed-off-by: olaf.kirch@oracle.com
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-crypt.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.21/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-crypt.c	2007-05-01 17:40:48.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-crypt.c	2007-05-01 17:40:48.000000000 +0100
@@ -655,9 +655,12 @@ static void process_write(struct crypt_i
 
 		generic_make_request(clone);
 
+		/* Do not reference clone after this - it
+		 * may be gone already. */
+
 		/* out of memory -> run queues */
 		if (remaining)
-			congestion_wait(bio_data_dir(clone), HZ/100);
+			congestion_wait(WRITE, HZ/100);
 	}
 }
 
