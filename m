Return-Path: <linux-kernel-owner+w=401wt.eu-S1756934AbZHGHFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934AbZHGHFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 03:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZHGHFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 03:05:42 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:55617 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbZHGHFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 03:05:41 -0400
Date: Fri, 7 Aug 2009 09:00:34 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: "Daniel K." <dk@uw.no>
Cc: benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/powerpc: Add kmalloc NULL tests
In-Reply-To: <4A7BCAF1.5070605@uw.no>
Message-ID: <Pine.LNX.4.64.0908070859540.20445@pc-004.diku.dk>
References: <Pine.LNX.4.64.0908062203380.19100@ask.diku.dk> <4A7BCAF1.5070605@uw.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Check that the result of kmalloc/kzalloc is not NULL before dereferencing it.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/powerpc/sysdev/fsl_rio.c       |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index cbb3bed..757a83f 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1057,6 +1057,10 @@ int fsl_rio_setup(struct of_device *dev)
 			law_start, law_size);
 
 	ops = kmalloc(sizeof(struct rio_ops), GFP_KERNEL);
+	if (!ops) {
+		rc = -ENOMEM;
+		goto err_ops;
+	}
 	ops->lcread = fsl_local_config_read;
 	ops->lcwrite = fsl_local_config_write;
 	ops->cread = fsl_rio_config_read;
@@ -1064,6 +1068,10 @@ int fsl_rio_setup(struct of_device *dev)
 	ops->dsend = fsl_rio_doorbell_send;
 
 	port = kzalloc(sizeof(struct rio_mport), GFP_KERNEL);
+	if (!port) {
+		rc = -ENOMEM;
+		goto err_port;
+	}
 	port->id = 0;
 	port->index = 0;
 
@@ -1071,7 +1079,7 @@ int fsl_rio_setup(struct of_device *dev)
 	if (!priv) {
 		printk(KERN_ERR "Can't alloc memory for 'priv'\n");
 		rc = -ENOMEM;
-		goto err;
+		goto err_priv;
 	}
 
 	INIT_LIST_HEAD(&port->dbells);
@@ -1169,11 +1177,13 @@ int fsl_rio_setup(struct of_device *dev)
 
 	return 0;
 err:
-	if (priv)
-		iounmap(priv->regs_win);
-	kfree(ops);
+	iounmap(priv->regs_win);
 	kfree(priv);
+err_priv:
 	kfree(port);
+err_port:
+	kfree(ops);
+err_ops:
 	return rc;
 }
 
