Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbZAMAxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbZAMAxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 19:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZAMAxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 19:53:43 -0500
Received: from r00tworld.com ([212.85.137.21]:45764 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbZAMAxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 19:53:43 -0500
X-Greylist: delayed 2012 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 19:53:42 EST
From: pageexec@freemail.hu
To: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 13 Jan 2009 01:19:09 +0200
MIME-Version: 1.0
Subject: Re: [patch] x86: fix PTE corruption issue while mapping RAM using /dev/mem
Reply-to: pageexec@freemail.hu
CC: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, Daniel.Beschorner@facton.com,
       stable@kernel.org
Message-ID: <496BDDFD.27997.A74B06@pageexec.freemail.hu>
In-reply-to: <20090112235135.GA22722@elte.hu>
References: <20090112203114.GA13157@linux-os.sc.intel.com>, <20090112235135.GA22722@elte.hu>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Tue, 13 Jan 2009 01:19:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 Jan 2009 at 0:51, Ingo Molnar wrote:

> applied to tip/x86/urgent, thanks Suresh!
> 
> note that the patch caused some conflicts (there were other changes in 
> pat.c) - i merged it up manually but could you please check the final 
> commit in tip/master whether it's all OK?

i don't think that it got applied properly:

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 85cbd3c..ea36ed7 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -347,9 +347,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
        new->end        = end;
        new->type       = actual_type;

-       if (new_type)
-               *new_type = actual_type;
-
        spin_lock(&memtype_lock);

        if (cached_entry && start >= cached_start)
@@ -437,6 +434,9 @@ int free_memtype(u64 start, u64 end)
        if (is_ISA_range(start, end - 1))
                return 0;

+       if (new_type)
+               *new_type = actual_type;
+
        is_range_ram = pagerange_is_ram(start, end);
        if (is_range_ram == 1)
                return free_ram_pages_type(start, end);

free_memtype doesn't even have a new_type argument for starters ;), patch
must have applied it at the wrong place...

