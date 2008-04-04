Return-Path: <linux-kernel-owner+w=401wt.eu-S1761866AbYDDASh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761866AbYDDASh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 20:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757731AbYDDASN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 20:18:13 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:37082
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755474AbYDDASL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 20:18:11 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 6 of 6] xen-balloon: define a section_ops
X-Mercurial-Node: e926df8cca107c8c77aa7b5f93877083cc3d8503
Message-Id: <e926df8cca107c8c77aa.1207267546@localhost>
In-Reply-To: <patchbomb.1207267540@localhost>
Date: Thu, 03 Apr 2008 17:05:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a xen_balloon_section_ops to control how xen balloon pages are onlined.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/xen/balloon.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -139,6 +139,21 @@
 	}
 }
 
+/* Only online a page if there's some memory backing it */
+static bool xen_online_page(struct page *page)
+{
+    unsigned long pfn = page_to_pfn(page);
+
+    if (get_phys_to_machine(pfn) == INVALID_P2M_ENTRY)
+	return false;
+
+    return online_page(page);
+}
+
+static const struct section_ops xen_balloon_section_ops = {
+    .online_page = xen_online_page
+};
+
 /* hotplug some memory we can add pages to */
 static void balloon_expand(unsigned pages)
 {
@@ -165,7 +180,7 @@
 	start_pfn = res->start >> PAGE_SHIFT;
 	end_pfn = (res->end + 1) >> PAGE_SHIFT;
 
-	ret = add_memory_resource(0, res, &default_section_ops);
+	ret = add_memory_resource(0, res, &xen_balloon_section_ops);
 	if (ret)
 		goto release_res;
 


