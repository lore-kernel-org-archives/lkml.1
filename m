Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbZLTJxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbZLTJxR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 04:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZLTJxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 04:53:11 -0500
Received: from isilmar.linta.de ([213.133.102.198]:59623 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752687AbZLTJxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 04:53:09 -0500
Date: Sun, 20 Dec 2009 10:52:48 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.33-rc0 regression: 256MB CF card no longer recognized in
 PCMCIA slot
Message-ID: <20091220095248.GC6029@comet.dominikbrodowski.net>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091219215459.GB9011@elf.ucw.cz>
 <4B2D54E7.9060508@garzik.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Sat, Dec 19, 2009 at 05:34:15PM -0500, Jeff Garzik wrote:
> On 12/19/2009 04:55 PM, Pavel Machek wrote:
> >Hi!
> >
> >Subject pretty much says it all... I do get some messages on the
> >console, I'll try to gather them.
> 
> Which driver(s) no longer see it?  Do you think it's the PCMCIA
> subsystem, IDE, libata or other?

My suspicion is that it might be kernel/resource.c -- Pavel, does this patch
fix the issue you're seeing?

Best,
	Dominik


From: Dominik Brodowski <linux@dominikbrodowski.net>
Date: Sun, 20 Dec 2009 10:04:56 +0100
Subject: [PATCH] resources: fix call to alignf() in allocate_resource()

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
