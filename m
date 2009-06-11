Return-Path: <linux-kernel-owner+w=401wt.eu-S1763572AbZFKMIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763572AbZFKMIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbZFKMIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:08:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39481 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZFKMIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:08:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] MN10300: Don't set the dirty bit in the DTLB entries in
	the TLB-miss handler
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-am33-list@redhat.com,
       David Howells <dhowells@redhat.com>
Date: Thu, 11 Jun 2009 13:08:32 +0100
Message-ID: <20090611120832.16989.99883.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the special handling for the Data TLB entry dirty bit in the TLB-miss
handler.  As the code stands, all that it does is to cause us to take a second
data address exception to set the dirty bit.  Instead, we can just let
pte_mkdirty() set the bit.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/mm/tlb-mn10300.S |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)


diff --git a/arch/mn10300/mm/tlb-mn10300.S b/arch/mn10300/mm/tlb-mn10300.S
index 7892080..7095147 100644
--- a/arch/mn10300/mm/tlb-mn10300.S
+++ b/arch/mn10300/mm/tlb-mn10300.S
@@ -165,24 +165,6 @@ ENTRY(itlb_aerror)
 ENTRY(dtlb_aerror)
 	and	~EPSW_NMID,epsw
 	add	-4,sp
-	mov	d1,(sp)
-
-	movhu	(MMUFCR_DFC),d1			# is it the initial valid write
-						# to this page?
-	and	MMUFCR_xFC_INITWR,d1
- 	beq	dtlb_pagefault			# jump if not
-
-	mov	(DPTEL),d1			# set the dirty bit
-						# (don't replace with BSET!)
-	or	_PAGE_DIRTY,d1
-	mov	d1,(DPTEL)
-	mov	(sp),d1
-	add	4,sp
- 	rti
-
-	ALIGN
-dtlb_pagefault:
-	mov	(sp),d1
 	SAVE_ALL
 	add	-4,sp				# need to pass three params
 

