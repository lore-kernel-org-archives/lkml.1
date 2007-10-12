Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbXJLRGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbXJLRGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761511AbXJLRFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:05:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761498AbXJLRFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:05:46 -0400
Date: Fri, 12 Oct 2007 18:05:41 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>, Milan Broz <mbroz@redhat.com>
Subject: [2.6.24 PATCH 03/25] dm crypt: drop device ref in ctr error path
Message-ID: <20071012170541.GN24157@agk.fab.redhat.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Milan Broz <mbroz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 04098903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Monakhov <dmonakhov@openvz.org>

Add a missing 'dm_put_device' in an error path in crypt target constructor.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.23/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-crypt.c	2007-10-12 13:15:20.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-crypt.c	2007-10-12 13:15:30.000000000 +0100
@@ -882,7 +882,7 @@ static int crypt_ctr(struct dm_target *t
 		cc->iv_mode = kmalloc(strlen(ivmode) + 1, GFP_KERNEL);
 		if (!cc->iv_mode) {
 			ti->error = "Error kmallocing iv_mode string";
-			goto bad5;
+			goto bad_iv_mode;
 		}
 		strcpy(cc->iv_mode, ivmode);
 	} else
@@ -891,6 +891,8 @@ static int crypt_ctr(struct dm_target *t
 	ti->private = cc;
 	return 0;
 
+bad_iv_mode:
+	dm_put_device(ti, cc->dev);
 bad5:
 	bioset_free(cc->bs);
 bad_bs:
