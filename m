Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbYFQJfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbYFQJfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYFQJfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:35:12 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41133 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYFQJfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:35:10 -0400
Date: Tue, 17 Jun 2008 18:34:09 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: [PATCH] Fix new alloc_bootmem_core (Re: [PATCH -mm 08/14] bootmem: clean up alloc_bootmem_core)
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080605225720.616014665@saeurebad.de>
References: <20080605224940.434439989@saeurebad.de> <20080605225720.616014665@saeurebad.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080617173021.C1FE.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes-san.

I found a bug in this patch.


> -	eidx = end_pfn - PFN_DOWN(node_boot_start);
> +	if (goal && goal < max)
> +		start = ALIGN(goal, step);
> +	else
> +		start = ALIGN(min, step);

Here should check (min < goal) too.

If not, start can becomes smaller than min. and sidx doesn't point
correct index.
alloc_bootmem_node() almost allocates pages of other node,
when node's min address is over MAX_DMA_ADDRESS.

Bye.

----

Fix new alloc_bootmem_core() of bootmem-clean-up-alloc_bootmem_core.patch
in 2.6.26-rc5-mm3.

(min < goal) should be checked too.


Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Johannes Weiner <hannes@saeurebad.de>

---
 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: current/mm/bootmem.c
===================================================================
--- current.orig/mm/bootmem.c	2008-06-17 18:33:31.000000000 +0900
+++ current/mm/bootmem.c	2008-06-17 18:34:27.000000000 +0900
@@ -435,7 +435,7 @@
 
 	step = max(align >> PAGE_SHIFT, 1UL);
 
-	if (goal && goal < max)
+	if (goal && min < goal && goal < max)
 		start = ALIGN(goal, step);
 	else
 		start = ALIGN(min, step);



-- 
Yasunori Goto 


