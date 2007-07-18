Return-Path: <linux-kernel-owner+w=401wt.eu-S1762321AbXGRWPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762321AbXGRWPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXGRWP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:15:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:59292 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbXGRWPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:15:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tzlyJnYDxFCp8gyv5BaR6EX8DB0qaxxi9NAHsdxqIaoSeQHa1tr+i0b38T2M6bhlWrXEWs3aRn5qtgBIcv5eUzxvrAQ1Q02FkLCm6JjEMF+Q6/FiTlnLXycnf0zYupk8VfZg7w2nZvpK+GFnjMOPeXMPesa/Yh1gTx/Qbsv1uqA=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix "use after free" / "double free" bug in amd_create_gatt_pages / amd_free_gatt_pages
Date: Thu, 19 Jul 2007 00:14:30 +0200
User-Agent: KMail/1.9.7
Cc: David Airlie <airlied@linux.ie>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707190014.30235.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Coverity spotted a "use after free" bug in 
drivers/char/agp/amd-k7-agp.c::amd_create_gatt_pages().

The problem is this:
	If "entry = kzalloc(sizeof(struct amd_page_map), GFP_KERNEL);"
fails, then there's a loop in the function to free all entries 
allocated so far and break out of the allocation loop. That in itself 
is pretty sane, but then the (now freed) 'tables' is assigned to 
amd_irongate_private.gatt_pages and 'retval' is set to -ENOMEM which 
causes amd_free_gatt_pages(); to be called at the end of the function.
The problem with this is that amd_free_gatt_pages() will then loop 
'amd_irongate_private.num_tables' times and try to free each entry in 
tables[] - this is bad since tables has already been freed and 
furthermore it will call kfree(tables) at the end - a double free.

This patch removes the freeing loop in amd_create_gatt_pages() and 
instead relies entirely on the call to amd_free_gatt_pages() to free 
everything we allocated in case of an error. It also sets 
amd_irongate_private.num_tables to the actual number of entries 
allocated instead of just using the value passed in from the caller - 
this ensures that amd_free_gatt_pages() will only attempt to free 
stuff that was actually allocated.

Note: I'm in no way intimate with this code and I have no way to 
actually test this patch (besides compile test it), so while I've 
tried to be careful in reading the code and make sure the patch 
does the right thing an ACK from someone who actually knows the 
code in-depth would be very much appreciated.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/char/agp/amd-k7-agp.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/char/agp/amd-k7-agp.c b/drivers/char/agp/amd-k7-agp.c
index df0ddf1..56d9c4b 100644
--- a/drivers/char/agp/amd-k7-agp.c
+++ b/drivers/char/agp/amd-k7-agp.c
@@ -100,21 +100,16 @@ static int amd_create_gatt_pages(int nr_tables)
 
 	for (i = 0; i < nr_tables; i++) {
 		entry = kzalloc(sizeof(struct amd_page_map), GFP_KERNEL);
+		tables[i] = entry;
 		if (entry == NULL) {
-			while (i > 0) {
-				kfree(tables[i-1]);
-				i--;
-			}
-			kfree(tables);
 			retval = -ENOMEM;
 			break;
 		}
-		tables[i] = entry;
 		retval = amd_create_page_map(entry);
 		if (retval != 0)
 			break;
 	}
-	amd_irongate_private.num_tables = nr_tables;
+	amd_irongate_private.num_tables = i;
 	amd_irongate_private.gatt_pages = tables;
 
 	if (retval != 0)


