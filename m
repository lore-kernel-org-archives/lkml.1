Return-Path: <linux-kernel-owner+w=401wt.eu-S932172AbZJ0IM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbZJ0IM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932164AbZJ0IMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:12:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:38025 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135AbZJ0IMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:12:23 -0400
Message-ID: <4AE6AAD3.8020700@kernel.org>
Date: Tue, 27 Oct 2009 01:09:55 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Alex Chiang <achiang@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/4] pci: revert "get larger bridge ranges when space is available"
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com> <4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com> <4AE55D72.7080202@kernel.org> <4AE6A9CA.4060106@kernel.org>
In-Reply-To: <4AE6A9CA.4060106@kernel.org>
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

but revert the commit at first.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -334,17 +334,8 @@ static struct resource *find_free_bus_re
 		r = bus->resource[i];
 		if (r == &ioport_resource || r == &iomem_resource)
 			continue;
-		if (r && (r->flags & type_mask) == type) {
-			if (!r->parent)
-				return r;
-			/*
-			 * if there is no child under that, we should release
-			 * and use it. don't need to reset it, pbus_size_* will
-			 * set it again
-			 */
-			if (!r->child && !release_resource(r))
-				return r;
-		}
+		if (r && (r->flags & type_mask) == type && !r->parent)
+			return r;
 	}
 	return NULL;
 }

