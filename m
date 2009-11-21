Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZKVMSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZKVMSX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754888AbZKVMSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:18:21 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:57240 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbZKVMSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:18:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=R7fZkKiK6GXVFPR8InpDf1rat03pDhBTD0GmKRZdLt63ORxnJPUlSZRvIaxyMTnXiX
         DC5n8+rQVfnlrOcK24kUZsLPiUVeZWvmfiFelLty1aLDuTGVd3vuoWMQuYl3z2dyhaoJ
         eRHoYU2EHWUjoMYd8dIk+89tdTBVmu/cRHjK4=
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 1/2] pid: tighten pidmap spinlock critical section by removing kfree()
Date: Sat, 21 Nov 2009 10:16:19 -0200
Message-Id: <0e91f1c4ecc5bc5000f729ccb56e9b6e1fbd4bd3.1258805412.git.andre.goddard@gmail.com>
X-Mailer: git-send-email 1.6.5.3.298.g39add
In-Reply-To: <cover.1258805412.git.andre.goddard@gmail.com>
References: <cover.1258805412.git.andre.goddard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid calling kfree() under pidmap spinlock, calling it afterwards.

Normally kfree() is very fast, but sometimes it can be slow, so avoid
calling it under the spinlock if we can.

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 kernel/pid.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index d3f722d..55fd590 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -141,11 +141,12 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 			 * installing it:
 			 */
 			spin_lock_irq(&pidmap_lock);
-			if (map->page)
-				kfree(page);
-			else
+			if (!map->page) {
 				map->page = page;
+				page = NULL;
+			}
 			spin_unlock_irq(&pidmap_lock);
+			kfree(page);
 			if (unlikely(!map->page))
 				break;
 		}
-- 
1.6.5.3.298.g39add

