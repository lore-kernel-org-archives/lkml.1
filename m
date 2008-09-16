Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbYIPWA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbYIPWA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYIPWAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:00:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44079
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751971AbYIPWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:00:17 -0400
Date: Tue, 16 Sep 2008 15:00:11 -0700 (PDT)
Message-Id: <20080916.150011.92089793.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH]: Fix PNP build failure, bugzilla #11276
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This fill fix the following regression list entry:

Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
Date		: 2008-08-06 17:18 (38 days old)
References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
		  http://lkml.org/lkml/2008/7/22/353
Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch		: http://lkml.org/lkml/2008/7/22/364

with what I believe is a better fix than the one referenced
in the regression entry above.

These PNP header interfaces try to work in such a way that
you can reference some of them even if PNP is not enabled,
and the compiler was expected to optimize everything away.

Which is mostly fine, except that there was one interface
for which there was not provided an inline "NOP" implementation.

Once we add that, all of these compile failures cannot handle
any more.

pnp: Provide NOP inline implementation of pnp_get_resource() when !PNP

Fixes kernel bugzilla #11276.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index 1ce54b6..be764e5 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -21,7 +21,14 @@ struct pnp_dev;
 /*
  * Resource Management
  */
+#ifdef CONFIG_PNP
 struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
+#else
+static inline struct resource *pnp_get_resource(struct pnp_dev *dev, unsigned int type, unsigned int num)
+{
+	return NULL;
+}
+#endif
 
 static inline int pnp_resource_valid(struct resource *res)
 {
