Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYJOPv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYJOPv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754149AbYJOPvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:51:17 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46701 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbYJOPvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:51:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/7] FRV: Eliminate NULL test and memset after alloc_bootmem
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>,
       David Howells <dhowells@redhat.com>
Date: Wed, 15 Oct 2008 16:51:04 +0100
Message-ID: <20081015155104.2158.33413.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
References: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
alloc_bootmem and related functions never return NULL and always return a
zeroed region of memory.  Thus a NULL test or memset after calls to these
functions is unnecessary.

 arch/frv/mm/init.c |    2 --
 1 file changed, 2 deletions(-)

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\)(...)
... when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mm/init.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)


diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index 1b851db..0708284 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -87,8 +87,6 @@ void __init paging_init(void)
 
 		pkmap_page_table = alloc_bootmem_pages(PAGE_SIZE);
 
-		memset(pkmap_page_table, 0, PAGE_SIZE);
-
 		pge = swapper_pg_dir + pgd_index_k(PKMAP_BASE);
 		pue = pud_offset(pge, PKMAP_BASE);
 		pme = pmd_offset(pue, PKMAP_BASE);

