Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZBHVpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZBHVpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:45:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZBHVov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:44:51 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:55168 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413AbZBHVou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:44:50 -0500
Date: Sun, 8 Feb 2009 22:44:47 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/6] drivers/isdn: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0902082244180.25891@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kmalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,l;
position p1,p2;
expression *ptr != NULL;
@@

(
if ((x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...)) == NULL) S
|
x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
)
<... when != x
     when != if (...) { <+...x...+> }
x->f = E
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c         |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 595ba8e..0b28141 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -4599,6 +4599,7 @@ init_e1_port(struct hfc_multi *hc, struct hm_map *m)
 			printk(KERN_ERR "%s: no memory for coeffs\n",
 			    __func__);
 			ret = -ENOMEM;
+			kfree(bch);
 			goto free_chan;
 		}
 		bch->nr = ch;
@@ -4767,6 +4768,7 @@ init_multi_port(struct hfc_multi *hc, int pt)
 			printk(KERN_ERR "%s: no memory for coeffs\n",
 			    __func__);
 			ret = -ENOMEM;
+			kfree(bch);
 			goto free_chan;
 		}
 		bch->nr = ch + 1;
