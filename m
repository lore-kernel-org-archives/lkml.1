Return-Path: <linux-kernel-owner+w=401wt.eu-S1752271AbZFFGgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbZFFGgb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 02:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZFFGgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 02:36:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43510 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZFFGgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 02:36:23 -0400
Date: Sat, 6 Jun 2009 09:36:24 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: akpm@linux-foundation.org
cc: linux-kernel@vger.kernel.org, apw@canonical.com, colin.king@canonical.com,
       tim.gardner@canonicalc.com, bjorn.helgaas@hp.com
Subject: [PATCH 2/2] pnp: add PNP resource range checking function
Message-ID: <Pine.LNX.4.64.0906060934500.11247@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Add a PNP resource range check function, indicating whether a resource
has been assigned to any device.

This patch fixes a serious performance regression on Asus Eee PC 701 (and
probably other) systems. See the following URL for details:

  http://bugs.launchpad.net/bugs/349314

[ apw@canonical.com: fixed up exports et al ]
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Acked-by: Colin King <colin.king@canonical.com>
Acked-by: Tim Gardner <tim.gardner@canonicalc.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Andrew, I am not completely sure if this is needed or not. But apparently 
the Ubuntu folks think it is and I did test the combination of these two 
patches.

 drivers/pnp/resource.c |   18 ++++++++++++++++++
 include/linux/pnp.h    |    2 ++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/pnp/resource.c b/drivers/pnp/resource.c
index f604061..ba97654 100644
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -638,6 +638,24 @@ int pnp_possible_config(struct pnp_dev *dev, int type, resource_size_t start,
 }
 EXPORT_SYMBOL(pnp_possible_config);
 
+int pnp_range_reserved(resource_size_t start, resource_size_t end)
+{
+	struct pnp_dev *dev;
+	struct pnp_resource *pnp_res;
+	resource_size_t *dev_start, *dev_end;
+
+	pnp_for_each_dev(dev) {
+		list_for_each_entry(pnp_res, &dev->resources, list) {
+			dev_start = &pnp_res->res.start;
+			dev_end   = &pnp_res->res.end;
+			if (ranged_conflict(&start, &end, dev_start, dev_end))
+				return 1;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(pnp_range_reserved);
+
 /* format is: pnp_reserve_irq=irq1[,irq2] .... */
 static int __init pnp_setup_reserve_irq(char *str)
 {
diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index ca3c887..b063c73 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -446,6 +446,7 @@ int pnp_start_dev(struct pnp_dev *dev);
 int pnp_stop_dev(struct pnp_dev *dev);
 int pnp_activate_dev(struct pnp_dev *dev);
 int pnp_disable_dev(struct pnp_dev *dev);
+int pnp_range_reserved(resource_size_t start, resource_size_t end);
 
 /* protocol helpers */
 int pnp_is_active(struct pnp_dev *dev);
@@ -476,6 +477,7 @@ static inline int pnp_start_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_stop_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_activate_dev(struct pnp_dev *dev) { return -ENODEV; }
 static inline int pnp_disable_dev(struct pnp_dev *dev) { return -ENODEV; }
+static inline int pnp_range_reserved(resource_size_t start, resource_size_t end) { return 0;}
 
 /* protocol helpers */
 static inline int pnp_is_active(struct pnp_dev *dev) { return 0; }
-- 
1.5.6.3

