Return-Path: <linux-kernel-owner+w=401wt.eu-S1752103AbZEFGUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbZEFGUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZEFGT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:19:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:19647 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbZEFGT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=W5LuH+YwJQjMmXT/bjBTOPDqzWIKXXldYbzKlG1P0lVc8XYgXDr0takgvfGavLE0M6
         s94NZWRlTQaXewqOrULyRxlUFC58OBK5PtrYR0VHqh+kJCO1VAuaK159ej/BOyl15+Ba
         6e8LxTVU1IKIvR8w8nVbT4JbcCTA1TljTyJTY=
Date: Wed, 6 May 2009 10:19:53 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Cc: LMMML <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mmotm] mm: init_per_zone_pages_min - get rid of sqrt call
	on small machines
Message-ID: <20090506061953.GA16057@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For small machines we may eliminate call for int_sqrt
by using precaulculated value.

CC: David Rientjes <rientjes@google.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 mm/page_alloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.git/mm/page_alloc.c
=====================================================================
--- linux-2.6.git.orig/mm/page_alloc.c
+++ linux-2.6.git/mm/page_alloc.c
@@ -4610,11 +4610,15 @@ static int __init init_per_zone_pages_mi
 
 	lowmem_kbytes = nr_free_buffer_pages() * (PAGE_SIZE >> 10);
 
-	min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
-	if (min_free_kbytes < 128)
+	/* for small values we may eliminate sqrt operation completely */
+	if (lowmem_kbytes < 1024)
 		min_free_kbytes = 128;
-	if (min_free_kbytes > 65536)
-		min_free_kbytes = 65536;
+	else {
+		min_free_kbytes = int_sqrt(lowmem_kbytes * 16);
+		if (min_free_kbytes > 65536)
+			min_free_kbytes = 65536;
+	}
+
 	setup_per_zone_pages_min();
 	setup_per_zone_lowmem_reserve();
 	setup_per_zone_inactive_ratio();

