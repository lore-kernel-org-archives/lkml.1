Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbYLKTsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbYLKTsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbYLKTTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:19:41 -0500
Received: from kroah.org ([198.145.64.141]:56892 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757966AbYLKTTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:19:40 -0500
Date: Thu, 11 Dec 2008 11:16:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Rene Herman <rene.herman@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 83/83] pnp: make the resource type an unsigned long
Message-ID: <20081211191657.GE5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pnp-make-the-resource-type-an-unsigned-long.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rene Herman <rene.herman@keyaccess.nl>

commit b563cf59c4d67da7d671788a9848416bfa4180ab upstream.

PnP encodes the resource type directly as its struct resource->flags value
which is an unsigned long.  Make it so...

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pnp/base.h     |    2 +-
 drivers/pnp/quirks.c   |    2 +-
 drivers/pnp/resource.c |    4 ++--
 include/linux/pnp.h    |    6 ++++--
 4 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/pnp/base.h
+++ b/drivers/pnp/base.h
@@ -147,7 +147,7 @@ char *pnp_resource_type_name(struct reso
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
 
 void pnp_free_resources(struct pnp_dev *dev);
-int pnp_resource_type(struct resource *res);
+unsigned long pnp_resource_type(struct resource *res);
 
 struct pnp_resource {
 	struct list_head list;
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -245,7 +245,7 @@ static void quirk_system_pci_resources(s
 	 */
 	for_each_pci_dev(pdev) {
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-			unsigned int type;
+			unsigned long type;
 
 			type = pci_resource_flags(pdev, i) &
 					(IORESOURCE_IO | IORESOURCE_MEM);
--- a/drivers/pnp/resource.c
+++ b/drivers/pnp/resource.c
@@ -467,14 +467,14 @@ int pnp_check_dma(struct pnp_dev *dev, s
 #endif
 }
 
-int pnp_resource_type(struct resource *res)
+unsigned long pnp_resource_type(struct resource *res)
 {
 	return res->flags & (IORESOURCE_IO  | IORESOURCE_MEM |
 			     IORESOURCE_IRQ | IORESOURCE_DMA);
 }
 
 struct resource *pnp_get_resource(struct pnp_dev *dev,
-				  unsigned int type, unsigned int num)
+				  unsigned long type, unsigned int num)
 {
 	struct pnp_resource *pnp_res;
 	struct resource *res;
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -22,9 +22,11 @@ struct pnp_dev;
  * Resource Management
  */
 #ifdef CONFIG_PNP
-struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
+struct resource *pnp_get_resource(struct pnp_dev *dev, unsigned long type,
+				unsigned int num);
 #else
-static inline struct resource *pnp_get_resource(struct pnp_dev *dev, unsigned int type, unsigned int num)
+static inline struct resource *pnp_get_resource(struct pnp_dev *dev,
+			unsigned long type, unsigned int num)
 {
 	return NULL;
 }

