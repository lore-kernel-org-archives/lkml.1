Return-Path: <linux-kernel-owner+w=401wt.eu-S1759115AbYESNMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115AbYESNMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYESNMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:12:17 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:43057 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYESNMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:12:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=gEMgw0sLj2ihRjSZBnx4ZipwlWr4LTkfJ4uuWtRRDBsrVS0j9Cy0wG4BtOb888e+82QT9YNpOZ3Hbty1t1+6rd1krvA2iknuSxXirz/xdXCvkLgIOAHNvwWBx3U1H0y0SJ/SWtQ5tMCBL2eLDjAmRx8t5qSwuNDy2WU152f7pz0=
Message-ID: <48317CA8.1080700@gmail.com>
Date: Mon, 19 May 2008 22:12:08 +0900
From: MinChan Kim <minchan.kim@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: [PATCH] Fix to return wrong pointer in slob
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Although slob_alloc return NULL, __kmalloc_node returns NULL + align.
Because align always can be changed, it is very hard for debugging
problem of no page if it don't return NULL.

We have to return NULL in case of no page.

Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
---
 mm/slob.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index 6038cba..258d76d 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -469,9 +469,12 @@ void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 			return ZERO_SIZE_PTR;
 
 		m = slob_alloc(size + align, gfp, align, node);
-		if (m)
-			*m = size;
-		return (void *)m + align;
+		if (!m)
+			return NULL;
+		else {
+			*m = size; 
+			return (void *)m + align;
+		}
 	} else {
 		void *ret;
 
-- 
1.5.4.3
