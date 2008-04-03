Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYDCFjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYDCFjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 01:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYDCFjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 01:39:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41609 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbYDCFjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 01:39:04 -0400
Date: Thu, 03 Apr 2008 14:37:20 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Subject: [Patch 000/005](memory hotplug) freeing pages allocated by bootmem for hotremove v2.
Cc: Andrew Morton <akpm@osdl.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, linux-mm <linux-mm@kvack.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080403140221.D1F2.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello.

I update my patch set to free pages which is allocated by bootmem.
Please comment.

---
This patch set is to free pages which is allocated by bootmem for
memory-hotremove. Some structures of memory management are
allocated by bootmem. ex) memmap, etc.
To remove memory physically, some of them must be freed according
to circumstance.
This patch set makes basis to free those pages, and free memmaps.

Basic my idea is using remain members of struct page to remember
information of users of bootmem (section number or node id).
When the section is removing, kernel can confirm it.
By this information, some issues can be solved.

  1) When the memmap of removing section is allocated on other
     section by bootmem, it should/can be free. 
  2) When the memmap of removing section is allocated on the
     same section, it shouldn't be freed. Because the section has to be
     offlined already and all pages must be isolated against
     page allocater.
  3) When removing section has other section's memmap, 
     kernel will be able to show easily which section should be removed
     before it for user. (Not implemented yet)
  4) When the above case 2), the page migrator will be able to check and skip
     memmap againt page isolation when page offline.
     Current page migration fails in this case because this page is 
     just reserved page and it can't distinguish this pages can be
     removed or not. But, it will be able to do by this patch.
     (Not implemented yet.)
  5) The node information like pgdat has similar issues. But, this
     will be able to be solved too by this.
     (Not implemented yet, but, remembering node id in the pages.)

Fortunately, current bootmem allocator just keeps PageReserved flags,
and doesn't use any other members of page struct. The users of
bootmem doesn't use them too.

This patch set is for 2.6.25-rc5-mm1.
And it needs Badari-san's generic __remove_pages() support patch.
  http://marc.info/?l=linux-kernel&m=120666094428775&w=2

Change log since v1.
  - allocate usemap on same section of pgdat. usemap's page is hard to be removed
    until other sections removing. This is avoid dependency problem between
    sections.
  - make alloc_bootmem_section() for above.
  - fix compile error for other config.
  - Add user counting. If a page is used by some user, it can be checked.

Todo:
  - for SPARSEMEM_VMEMMAP.
    Freeing vmemmap's page is more diffcult than normal sparsemem.
    Because not only memmap's page, but also the pages like page table must
    be removed too. If removing section has pages for , then it must
    be migrated too. Relocatable page table is necessary.
    (Ross Biro-san is working for it.)
    http://marc.info/?l=linux-mm&m=120110502617654&w=2



Thanks.



-- 
Yasunori Goto 


