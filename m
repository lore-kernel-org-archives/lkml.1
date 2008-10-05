Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYJEPik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYJEPik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 11:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYJEPic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 11:38:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:18395 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYJEPic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 11:38:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=Gei60m0GnNwULNp9Heojwvgz1QcMIgfnN8oL8R1AXQQjjW/j2J3+NfiIizWAmr5nGq
         hRyXLKqTP8DTbeAE1g+wn4+O7C+TS8udltfRJ1hLfK0aGcDCVWY/olZRe1BvSDpPkLpD
         oERiU5YzTB5whk9kGlfn0z4zrrWeCWo2wc5Ek=
Date: Sun, 5 Oct 2008 17:38:37 +0200
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.28] bluetooth: fix leak of uninitialized data to
	userspace
Message-ID: <20081005153836.GA15807@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 45be27894a18f87b71b855fcc4afd50f860254b4 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 5 Oct 2008 17:25:45 +0200
Subject: [PATCH] bluetooth: fix leak of uninitialized data to userspace

    struct hci_dev_list_req {
            __u16  dev_num;
            struct hci_dev_req dev_req[0];  /* hci_dev_req structures */
    };

sizeof(struct hci_dev_list_req) == 4, so the two bytes immediately
following "dev_num" will never be initialized. When this structure
is copied to userspace, these uninitialized bytes are leaked.

Fix by using kzalloc() instead of kmalloc(). Found using kmemcheck.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 net/bluetooth/hci_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 278a3ac..7bb0f1c 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -756,7 +756,7 @@ int hci_get_dev_list(void __user *arg)
 
 	size = sizeof(*dl) + dev_num * sizeof(*dr);
 
-	if (!(dl = kmalloc(size, GFP_KERNEL)))
+	if (!(dl = kzalloc(size, GFP_KERNEL)))
 		return -ENOMEM;
 
 	dr = dl->dev_req;
-- 
1.5.5.1

