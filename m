Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZHUD4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZHUD4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 23:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbZHUD4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 23:56:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40638 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbZHUD4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 23:56:45 -0400
Date: Fri, 21 Aug 2009 13:56:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michel =?UTF-8?B?RMOkbnplcg==?= <daenzer@vmware.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: linux-next: manual merge of the agp tree with the powerpc tree
Message-Id: <20090821135644.3f817b82.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the agp tree got a conflict in
drivers/char/agp/uninorth-agp.c between commit uninorth_create_gatt_table
("agp/uninorth: Simplify cache flushing") from the powerpc tree and
commit 6a12235c7d2d75c7d94b9afcaaecd422ff845ce0 ("agp: kill phys_to_gart
() and gart_to_phys()") from the agp tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/agp/uninorth-agp.c
index bba29ab,4317a55..0000000
--- a/drivers/char/agp/uninorth-agp.c
+++ b/drivers/char/agp/uninorth-agp.c
@@@ -424,28 -424,14 +424,28 @@@ static int uninorth_create_gatt_table(s
  	if (table == NULL)
  		return -ENOMEM;
  
 +	pages = kmalloc((1 << page_order) * sizeof(struct page*), GFP_KERNEL);
 +	if (pages == NULL)
 +		goto enomem;
 +
  	table_end = table + ((PAGE_SIZE * (1 << page_order)) - 1);
  
 -	for (page = virt_to_page(table); page <= virt_to_page(table_end); page++)
 +	for (page = virt_to_page(table), i = 0; page <= virt_to_page(table_end);
 +	     page++, i++) {
  		SetPageReserved(page);
 +		pages[i] = page;
 +	}
  
  	bridge->gatt_table_real = (u32 *) table;
 -	bridge->gatt_table = (u32 *)table;
 +	/* Need to clear out any dirty data still sitting in caches */
 +	flush_dcache_range((unsigned long)table,
 +			   (unsigned long)(table_end + PAGE_SIZE));
 +	bridge->gatt_table = vmap(pages, (1 << page_order), 0, PAGE_KERNEL_NCG);
 +
 +	if (bridge->gatt_table == NULL)
 +		goto enomem;
 +
- 	bridge->gatt_bus_addr = virt_to_gart(table);
+ 	bridge->gatt_bus_addr = virt_to_phys(table);
  
  	for (i = 0; i < num_entries; i++)
  		bridge->gatt_table[i] = 0;
