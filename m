Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502Ab0BDWuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 17:50:01 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:18322 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757647Ab0BDWt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 17:49:59 -0500
Subject: [PATCH] cciss: Make cciss_seq_show handle holes in the h->drv[] array.
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stable@kernel.org, mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org
Date: Thu, 04 Feb 2010 16:52:45 -0600
Message-ID: <20100204224929.12371.65766.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: Make cciss_seq_show handle holes in the h->drv[] array.
It is possible (and expected) for there to be holes in the h->drv[]
array, that is, some elements may be NULL pointers.  cciss_seq_show
needs to be made aware of this possibility to avoid an Oops.

To reproduce the Oops which this fixes:

1) Create two "arrays" in the Array Configuratino Utility and
   several logical drives on each array.
2) cat /proc/driver/cciss/cciss* in an infinite loop
3) delete some of the logical drives in the first "array."

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 873e594..9291614 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -337,6 +337,9 @@ static int cciss_seq_show(struct seq_file *seq, void *v)
 	if (*pos > h->highest_lun)
 		return 0;
 
+	if (drv == NULL) /* it's possible for h->drv[] to have holes. */
+		return 0;
+
 	if (drv->heads == 0)
 		return 0;
 

