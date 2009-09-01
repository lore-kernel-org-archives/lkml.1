Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbZIAH6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbZIAH6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 03:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZIAH6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 03:58:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:47438 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937AbZIAH6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 03:58:23 -0400
Message-ID: <4A9CD41C.8060604@kernel.org>
Date: Tue, 01 Sep 2009 16:58:20 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Meelis Roos <mroos@linux.ee>
CC: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: boot panic after oops from sysfs_new_dirent
References: <Pine.SOC.4.64.0908311646150.20934@math.ut.ee> <20090831.142215.111904849.davem@davemloft.net> <Pine.SOC.4.64.0909011003460.10184@math.ut.ee> <4A9CC9E9.2070609@kernel.org> <4A9CCD92.4090909@kernel.org> <Pine.SOC.4.64.0909011032350.10835@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0909011032350.10835@math.ut.ee>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 01 Sep 2009 07:58:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos wrote:
>> Ummm.... one more question.  Is cpu0 missing?  Can you please post the
>> output of "cat /proc/cpuinfo"?
> 
> Yes, there's no CPU numbered 0, the numbers come from hardware slots on 
> backplane.

Aha...  Does the following patch fix the problem?

diff --git a/mm/percpu.c b/mm/percpu.c
index 5fe3784..3311c89 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -197,7 +197,12 @@ static unsigned long pcpu_chunk_addr(struct pcpu_chunk *chunk,
 static bool pcpu_chunk_page_occupied(struct pcpu_chunk *chunk,
 				     int page_idx)
 {
-	return *pcpu_chunk_pagep(chunk, 0, page_idx) != NULL;
+	/*
+	 * Any possible cpu id can be used here, so there's no need to
+	 * worry about preemption or cpu hotplug.
+	 */
+	return *pcpu_chunk_pagep(chunk, raw_smp_processor_id(),
+				 page_idx) != NULL;
 }

 /* set the pointer to a chunk in a page struct */
@@ -297,6 +302,14 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 		return pcpu_first_chunk;
 	}

+	/*
+	 * The address is relative to unit0 which might be unused and
+	 * thus unmapped.  Offset the address to the unit space of the
+	 * current processor before looking it up in the vmalloc
+	 * space.  Note that any possible cpu id can be used here, so
+	 * there's no need to worry about preemption or cpu hotplug.
+	 */
+	addr += raw_smp_processor_id() * pcpu_unit_size;
 	return pcpu_get_page_chunk(vmalloc_to_page(addr));
 }

-- 
tejun
