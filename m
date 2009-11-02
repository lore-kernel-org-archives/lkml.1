Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbZKBRpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbZKBRpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbZKBRpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:45:33 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:11102 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057AbZKBRpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:45:32 -0500
Subject: [PATCH] resources: when allocate_resource() fails,
	leave resource untouched
To: Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Nov 2009 10:45:36 -0700
Message-ID: <20091102174536.12512.56685.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When "allocate_resource(root, new, size, ...)" fails, we currently
clobber "new".  This is inconvenient for the caller, who might care
about the original contents of the resource.

For example, when pci_bus_alloc_resource() fails, the "can't allocate
mem resource %pR" message from pci_assign_resources() currently contains
junk for the resource start/end.

This patch delays the "new" update until we're about to return success.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 kernel/resource.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index fb11a58..dc15686 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -308,35 +308,37 @@ static int find_resource(struct resource *root, struct resource *new,
 			 void *alignf_data)
 {
 	struct resource *this = root->child;
+	resource_size_t start, end;
 
-	new->start = root->start;
+	start = root->start;
 	/*
 	 * Skip past an allocated resource that starts at 0, since the assignment
 	 * of this->start - 1 to new->end below would cause an underflow.
 	 */
 	if (this && this->start == 0) {
-		new->start = this->end + 1;
+		start = this->end + 1;
 		this = this->sibling;
 	}
 	for(;;) {
 		if (this)
-			new->end = this->start - 1;
+			end = this->start - 1;
 		else
-			new->end = root->end;
-		if (new->start < min)
-			new->start = min;
-		if (new->end > max)
-			new->end = max;
-		new->start = ALIGN(new->start, align);
+			end = root->end;
+		if (start < min)
+			start = min;
+		if (end > max)
+			end = max;
+		start = ALIGN(start, align);
 		if (alignf)
 			alignf(alignf_data, new, size, align);
-		if (new->start < new->end && new->end - new->start >= size - 1) {
-			new->end = new->start + size - 1;
+		if (start < end && end - start >= size - 1) {
+			new->start = start;
+			new->end = start + size - 1;
 			return 0;
 		}
 		if (!this)
 			break;
-		new->start = this->end + 1;
+		start = this->end + 1;
 		this = this->sibling;
 	}
 	return -EBUSY;

