Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYGUH5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYGUH5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756833AbYGUH5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:57:30 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:39758 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663AbYGUH52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:57:28 -0400
Date: Mon, 21 Jul 2008 09:57:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: jgarzik@pobox.com, raisch@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/7] drivers/net/ehea/ehea_main.c: Release mutex in error
 handling code
Message-ID: <Pine.LNX.4.64.0807210957060.24625@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The mutex is released on a successful return, so it would seem that it
should be released on an error return as well.

The semantic patch finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression l;
@@

mutex_lock(l);
... when != mutex_unlock(l)
    when any
    when strict
(
if (...) { ... when != mutex_unlock(l)
+   mutex_unlock(l);
    return ...;
}
|
mutex_unlock(l);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
diff -u -p a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -2937,9 +2937,9 @@ static void ehea_rereg_mrs(struct work_s
 				}
 			}
 		}
-       mutex_unlock(&dlpar_mem_lock);
-       ehea_info("re-initializing driver complete");
+	ehea_info("re-initializing driver complete");
 out:
+	mutex_unlock(&dlpar_mem_lock);
 	return;
 }
 
