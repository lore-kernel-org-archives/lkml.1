Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbYFEIdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbYFEIdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYFEIdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:33:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44594 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYFEIdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:33:06 -0400
Date: Thu, 05 Jun 2008 17:31:50 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH -mm 11/14] bootmem: respect goal more likely
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <87abi0semc.fsf@saeurebad.de>
References: <20080605115235.6453.E1E9C6FF@jp.fujitsu.com> <87abi0semc.fsf@saeurebad.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080605170323.645F.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I gotcha!  :-)

 	max -= PFN_DOWN(bdata->node_boot_start);
 	start -= PFN_DOWN(bdata->node_boot_start);
+	fallback -= PFN_DOWN(bdata->node_boot_start);
 
 	if (bdata->last_success > start) {
-		/* Set goal here to trigger a retry on failure */
-		start = goal = ALIGN(bdata->last_success, step);
+		fallback = start; -------------------------------- (*)
+		start = ALIGN(bdata->last_success, step);
 	}

(*) is root cause. "fallback" is set as 0, because start is index of bitmap
at here. When normal zone is allocated first, and DMA zone is required by
alloc_bootmem_low() later and first page is free yet, fallback is set as 0.

+	if (fallback) {
+		start = ALIGN(fallback, step);
+		fallback = 0;
+		goto find_block;
+	}
+

As a result, this retry code is skipped, and alloc_bootmem_low() fails. 
So, when I change here from fallback to a retry_flag, my box can boot up.

Thanks.
-- 
Yasunori Goto 


