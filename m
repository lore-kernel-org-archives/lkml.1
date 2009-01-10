Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZAJU2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZAJU2V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 15:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZAJU2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 15:28:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:47638 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZAJU2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 15:28:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=q5epTpIOj8BYkhz7VeYfLQXbhp9QGpKz5Vx0AKnvA9T44Nc+hiCMYLNFUGm2HlTSn4
         EzWyOg0JATQCWfQy6eAAJjvgisCzNLCo17waWfscOcU3d6zO/IWuenHHYusuMTEMF5PU
         N8ZWidx/84rV5ZUDWIIra+u0Gch5obSMhkMnA=
Date: Sat, 10 Jan 2009 23:28:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Chapman <jchapman@katalix.com>
Cc: LKML <linux-kernel@vger.kernel.org>, NKML <netdev@vger.kernel.org>
Subject: [PATCH] net: ppp_generic - fix broken userspace
Message-ID: <20090110202802.GF29349@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commits:

	7a95d267fb62cd6b80ef73be0592bbbe1dbd5df7
	ab5024ab23b78c86a0a1425defcdde48710fe449

introduced usage of IDR functionality but broke
userspace side.

Before this commits it was possible to allocate new ppp
interface with specified number. Now it fails with EINVAL.
Fix it by trying to allocate interface with specified unit
number and return EEXIST if fail which allow pppd to ask
us to allocate new unit number.

And fix messages on memory allocation fails - add details
that it's PPP module who is complaining.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

If this is not a right way to fix this issue maybe better
would be to just revert the commits mentioned. Please
review carefully. Thanks!

The patch is on top of current net-next-2.6 tree.

 drivers/net/ppp_generic.c |   43 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 6 deletions(-)

Index: linux-2.6.git/drivers/net/ppp_generic.c
===================================================================
--- linux-2.6.git.orig/drivers/net/ppp_generic.c
+++ linux-2.6.git/drivers/net/ppp_generic.c
@@ -250,6 +250,7 @@ static int ppp_connect_channel(struct ch
 static int ppp_disconnect_channel(struct channel *pch);
 static void ppp_destroy_channel(struct channel *pch);
 static int unit_get(struct idr *p, void *ptr);
+static int unit_set(struct idr *p, void *ptr, int n);
 static void unit_put(struct idr *p, int n);
 static void *unit_find(struct idr *p, int n);
 
@@ -2432,11 +2433,18 @@ ppp_create_interface(int unit, int *retp
 	} else {
 		if (unit_find(&ppp_units_idr, unit))
 			goto out2; /* unit already exists */
-		else {
-			/* darn, someone is cheating us? */
-			*retp = -EINVAL;
+		/*
+		 * if caller need a specified unit number
+		 * lets try to satisfy him, otherwise --
+		 * he should better ask us for new unit number
+		 *
+		 * NOTE: yes I know that returning EEXIST it's not
+		 * fair but at least pppd will ask us to allocate
+		 * new unit in this case so user is happy :)
+		 */
+		unit = unit_set(&ppp_units_idr, ppp, unit);
+		if (unit < 0)
 			goto out2;
-		}
 	}
 
 	/* Initialize the new ppp unit */
@@ -2677,14 +2685,37 @@ static void __exit ppp_cleanup(void)
  * by holding all_ppp_mutex
  */
 
+/* associate pointer with specified number */
+static int unit_set(struct idr *p, void *ptr, int n)
+{
+	int unit, err;
+
+again:
+	if (!idr_pre_get(p, GFP_KERNEL)) {
+		printk(KERN_ERR "PPP: No free memory for idr\n");
+		return -ENOMEM;
+	}
+
+	err = idr_get_new_above(p, ptr, n, &unit);
+	if (err == -EAGAIN)
+		goto again;
+
+	if (unit != n) {
+		idr_remove(p, unit);
+		return -EINVAL;
+	}
+
+	return unit;
+}
+
 /* get new free unit number and associate pointer with it */
 static int unit_get(struct idr *p, void *ptr)
 {
 	int unit, err;
 
 again:
-	if (idr_pre_get(p, GFP_KERNEL) == 0) {
-		printk(KERN_ERR "Out of memory expanding drawable idr\n");
+	if (!idr_pre_get(p, GFP_KERNEL)) {
+		printk(KERN_ERR "PPP: No free memory for idr\n");
 		return -ENOMEM;
 	}
 
