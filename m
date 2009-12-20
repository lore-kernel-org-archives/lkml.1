Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbZLTJxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbZLTJxM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbZLTJxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:53:10 -0500
Received: from isilmar.linta.de ([213.133.102.198]:59620 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752484AbZLTJxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:53:08 -0500
Date: Sun, 20 Dec 2009 10:50:02 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] resources: fix call to alignf() in allocate_resource()
Message-ID: <20091220095001.GA6029@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Bjorn Helgaas <bjorn.helgaas@hp.com>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The second parameter to alignf() in allocate_resource() must
reflect what new resource is attempted to be allocated, else
functions like pcibios_align_resource() (at least on x86) or
pcmcia_align() can't work correctly.

Commit 1e5ad9679016275d422e36b12a98b0927d76f556 broke this by
setting the "new" resource until we're about to return success.
To keep the resource untouched when allocate_resource() fails,
a "tmp" resource is introduced.

CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>

diff --git a/kernel/resource.c b/kernel/resource.c
index dc15686..af96c1e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -308,37 +308,37 @@ static int find_resource(struct resource *root, struct resource *new,
 			 void *alignf_data)
 {
 	struct resource *this = root->child;
-	resource_size_t start, end;
+	struct resource tmp = *new;
 
-	start = root->start;
+	tmp.start = root->start;
 	/*
 	 * Skip past an allocated resource that starts at 0, since the assignment
-	 * of this->start - 1 to new->end below would cause an underflow.
+	 * of this->start - 1 to tmp->end below would cause an underflow.
 	 */
 	if (this && this->start == 0) {
-		start = this->end + 1;
+		tmp.start = this->end + 1;
 		this = this->sibling;
 	}
 	for(;;) {
 		if (this)
-			end = this->start - 1;
+			tmp.end = this->start - 1;
 		else
-			end = root->end;
-		if (start < min)
-			start = min;
-		if (end > max)
-			end = max;
-		start = ALIGN(start, align);
+			tmp.end = root->end;
+		if (tmp.start < min)
+			tmp.start = min;
+		if (tmp.end > max)
+			tmp.end = max;
+		tmp.start = ALIGN(tmp.start, align);
 		if (alignf)
-			alignf(alignf_data, new, size, align);
-		if (start < end && end - start >= size - 1) {
-			new->start = start;
-			new->end = start + size - 1;
+			alignf(alignf_data, &tmp, size, align);
+		if (tmp.start < tmp.end && tmp.end - tmp.start >= size - 1) {
+			new->start = tmp.start;
+			new->end = tmp.start + size - 1;
 			return 0;
 		}
 		if (!this)
 			break;
-		start = this->end + 1;
+		tmp.start = this->end + 1;
 		this = this->sibling;
 	}
 	return -EBUSY;
