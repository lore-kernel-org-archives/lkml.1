Return-Path: <linux-kernel-owner+w=401wt.eu-S1752912AbZJXJ0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbZJXJ0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 05:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZJXJ0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 05:26:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:46514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZJXJ0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 05:26:19 -0400
Message-ID: <4AE2C827.8040905@kernel.org>
Date: Sat, 24 Oct 2009 02:25:59 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] pci: only release that resource index is less than 3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


after

| commit 308cf8e13f42f476dfd6552aeff58fdc0788e566
|
|    PCI: get larger bridge ranges when space is available

found one of resource of peer root bus (0x00) get released from root
resource. later one hotplug device can not get big range anymore.
other peer root buses is ok.

it turns out it is from transparent path.

those resources will be used for pci bridge BAR updated.
so need to limit it to 3.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -344,9 +344,14 @@ static struct resource *find_free_bus_re
 			 * if there is no child under that, we should release
 			 * and use it. don't need to reset it, pbus_size_* will
 			 * set it again
+			 * need to be less 3, otherwise can not write it to
+			 * bridge, also need to avoid releasing it from
+			 * transparent bus path
 			 */
-			if (!r->child && !release_resource(r))
-				return r;
+			if (i < 3 && !r->child) {
+				if (!release_resource(r))
+					return r;
+			}
 		}
 	}
 	return NULL;
