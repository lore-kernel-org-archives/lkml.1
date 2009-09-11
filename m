Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZIKQXH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZIKQXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:23:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbZIKQXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:23:05 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:34701 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbZIKQXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:23:03 -0400
Date: Fri, 11 Sep 2009 18:23:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 8/8] sound/soc: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0909111822480.10552@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.
Error handling code following an ioremap should iounmap the allocated data.

The semantic match that finds the first problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
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
 sound/soc/fsl/mpc5200_dma.c         |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/sound/soc/fsl/mpc5200_dma.c b/sound/soc/fsl/mpc5200_dma.c
index 9ff62e3..41ffd57 100644
--- a/sound/soc/fsl/mpc5200_dma.c
+++ b/sound/soc/fsl/mpc5200_dma.c
@@ -469,8 +469,11 @@ int mpc5200_audio_dma_create(struct of_device *op)
 
 	/* Get the PSC ID */
 	prop = of_get_property(op->node, "cell-index", &size);
-	if (!prop || size < sizeof *prop)
+	if (!prop || size < sizeof *prop) {
+		iounmap(regs);
+		kfree(psc_dma);
 		return -ENODEV;
+	}
 
 	spin_lock_init(&psc_dma->lock);
 	mutex_init(&psc_dma->mutex);
