Return-Path: <linux-kernel-owner+w=401wt.eu-S1755809AbZA3U1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809AbZA3U1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 15:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753995AbZA3U1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 15:27:24 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983AbZA3U1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 15:27:23 -0500
Date: Fri, 30 Jan 2009 15:27:14 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix memory corruption in console selection
Message-ID: <Pine.LNX.4.64.0901301516190.2813@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ I don't know who is the console maintainer or if there is any, so I'm 
posting this to Linus ]


Fix an off-by-two memory error in console selection.

The loop below goes from sel_start to sel_end (inclusive), so it writes 
one more character. This one more character was added to the allocated 
size (+1), but it was not multiplied by an UTF-8 multiplier.

This patch fixes a memory corruption when UTF-8 console is used and the 
user selects a few characters, all of them 3-byte in UTF-8 (for example a 
frame line).

When memory redzones are enabled, a redzone corruption is reported. When 
they are not enabled, trashing of random memory occurs.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/char/selection.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.29-rc3-devel/drivers/char/selection.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/char/selection.c	2009-01-30 21:03:07.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/char/selection.c	2009-01-30 21:03:38.000000000 +0100
@@ -268,7 +268,7 @@ int set_selection(const struct tiocl_sel
 
 	/* Allocate a new buffer before freeing the old one ... */
 	multiplier = use_unicode ? 3 : 1;  /* chars can take up to 3 bytes */
-	bp = kmalloc((sel_end-sel_start)/2*multiplier+1, GFP_KERNEL);
+	bp = kmalloc(((sel_end-sel_start)/2+1)*multiplier, GFP_KERNEL);
 	if (!bp) {
 		printk(KERN_WARNING "selection: kmalloc() failed\n");
 		clear_selection();
