Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbZKQHRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbZKQHRG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 02:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZKQHRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 02:17:05 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58420 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZKQHRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 02:17:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/7] dm: use __GFP_HIGH instead PF_MEMALLOC
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
In-Reply-To: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com>
Message-Id: <20091117161616.3DD7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 17 Nov 2009 16:17:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Non MM subsystem must not use PF_MEMALLOC. Memory reclaim need few
memory, anyone must not prevent it. Otherwise the system cause
mysterious hang-up and/or OOM Killer invokation.

Cc: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 drivers/md/dm-ioctl.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index a679429..4d24b0a 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1396,7 +1396,13 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
 	if (tmp.data_size < (sizeof(tmp) - sizeof(tmp.data)))
 		return -EINVAL;
 
-	dmi = vmalloc(tmp.data_size);
+
+	/*
+	 * We use __vmalloc(__GFP_HIGH) instead vmalloc() because trying to
+	 * avoid low memory issues when a device is suspended.
+	 */
+	dmi = __vmalloc(tmp.data_size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_HIGH,
+			PAGE_KERNEL);
 	if (!dmi)
 		return -ENOMEM;
 
@@ -1473,20 +1479,10 @@ static int ctl_ioctl(uint command, struct dm_ioctl __user *user)
 		DMWARN("dm_ctl_ioctl: unknown command 0x%x", command);
 		return -ENOTTY;
 	}
-
-	/*
-	 * Trying to avoid low memory issues when a device is
-	 * suspended.
-	 */
-	current->flags |= PF_MEMALLOC;
-
 	/*
 	 * Copy the parameters into kernel space.
 	 */
 	r = copy_params(user, &param);
-
-	current->flags &= ~PF_MEMALLOC;
-
 	if (r)
 		return r;
 
-- 
1.6.2.5



