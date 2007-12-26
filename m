Return-Path: <linux-kernel-owner+w=401wt.eu-S1751928AbXLZPWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbXLZPWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 10:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbXLZPWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 10:22:38 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:39622 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbXLZPWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 10:22:37 -0500
Date: Wed, 26 Dec 2007 16:21:37 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: hpa@zytor.com, autofs@linux.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/4] fs/autofs: Use time_before, time_before_eq, etc.
Message-ID: <Pine.LNX.4.58.0712261621000.1185@pc-041.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the semantic patch making this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@ change_compare_np @
expression E;
@@

(
- jiffies <= E
+ time_before_eq(jiffies,E)
|
- jiffies >= E
+ time_after_eq(jiffies,E)
|
- jiffies < E
+ time_before(jiffies,E)
|
- jiffies > E
+ time_after(jiffies,E)
)

@ include depends on change_compare_np @
@@

#include <linux/jiffies.h>

@ no_include depends on !include && change_compare_np @
@@

  #include <linux/...>
+ #include <linux/jiffies.h>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---

diff -u -p linux-2.6/fs/autofs/dirhash.c linuxcopy/fs/autofs/dirhash.c
--- linux-2.6/fs/autofs/dirhash.c	2006-11-30 19:05:26.000000000 +0100
+++ linuxcopy/fs/autofs/dirhash.c	2007-12-25 20:53:48.000000000 +0100
@@ -47,7 +47,7 @@ struct autofs_dir_ent *autofs_expire(str
 			return NULL;	/* No entries */
 		/* We keep the list sorted by last_usage and want old stuff */
 		ent = list_entry(dh->expiry_head.next, struct autofs_dir_ent, exp);
-		if (jiffies - ent->last_usage < timeout)
+		if (time_before(jiffies, ent->last_usage + timeout))
 			break;
 		/* Move to end of list in case expiry isn't desirable */
 		autofs_update_usage(dh, ent);
