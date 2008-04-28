Return-Path: <linux-kernel-owner+w=401wt.eu-S1763605AbYD1AlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763605AbYD1AlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751007AbYD1AlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:41:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38908 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbYD1AlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:41:05 -0400
Date: Mon, 28 Apr 2008 02:40:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: [patch] mm: node-setup agnostic free_bootmem()
Message-ID: <20080428004046.GA16155@elte.hu>
References: <20080426185516.GA32364@elte.hu> <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org> <20080426194143.GA8366@elte.hu> <87hcdmnccu.fsf@saeurebad.de> <20080427234630.GC14338@elte.hu> <877iein859.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877iein859.fsf@saeurebad.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Weiner <hannes@saeurebad.de> wrote:

> > so i very much agree that your changes are cleaner, i just wanted to 
> > have one that has all the fixes included.
> 
> I had planned this to be another patch because there are more then one 
> boundary check I wanted to tighten.  I can merge them though if you 
> like.

no, better to have them in separate patches.

> > Would you like to post a patch against current -git or should i 
> > extract the cleaner reserve_bootmem() from your previous patch?
> 
> I just moved and have only sporadic internet access and free time 
> slots available.  Would be nice if you could do it!

sure, find the merged patch below, against latest -git, boot-tested on 
x86. Is this what you had in mind?

	Ingo

---------------->
Subject: mm: node-setup agnostic free_bootmem()
From: Johannes Weiner <hannes@saeurebad.de>
Date: Wed, 16 Apr 2008 13:36:31 +0200

Make free_bootmem() look up the node holding the specified address
range which lets it work transparently on single-node and multi-node
configurations.

If the address range exceeds the node range, it well be marked free
across node boundaries, too.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Andi Kleen <andi@firstfloor.org>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Christoph Lameter <clameter@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/bootmem.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

Index: linux-x86.q/mm/bootmem.c
===================================================================
--- linux-x86.q.orig/mm/bootmem.c
+++ linux-x86.q/mm/bootmem.c
@@ -493,8 +493,31 @@ int __init reserve_bootmem(unsigned long
 void __init free_bootmem(unsigned long addr, unsigned long size)
 {
 	bootmem_data_t *bdata;
-	list_for_each_entry(bdata, &bdata_list, list)
-		free_bootmem_core(bdata, addr, size);
+	unsigned long pos = addr;
+	unsigned long partsize = size;
+
+	list_for_each_entry(bdata, &bdata_list, list) {
+		unsigned long remainder = 0;
+
+		if (pos < bdata->node_boot_start)
+			continue;
+
+		if (PFN_DOWN(pos + partsize) > bdata->node_low_pfn) {
+			remainder = PFN_DOWN(pos + partsize) - bdata->node_low_pfn;
+			partsize -= remainder;
+		}
+
+		free_bootmem_core(bdata, pos, partsize);
+
+		if (!remainder)
+			return;
+
+		pos = PFN_PHYS(bdata->node_low_pfn + 1);
+	}
+	printk(KERN_ERR "free_bootmem: request: addr=%lx, size=%lx, "
+			"state: pos=%lx, partsize=%lx\n", addr, size,
+			pos, partsize);
+	BUG();
 }
 
 unsigned long __init free_all_bootmem(void)
