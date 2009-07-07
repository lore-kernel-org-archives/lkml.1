Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbZGGQNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbZGGQNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbZGGQNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:13:35 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:64406 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZGGQNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=lhxXdn2Nr8Alxl9vjhi/eZVzFGX+OuzNRzsJM4IhEdIosGO6iP0r+yjx+71MEFO8UV
         27h9mdeq/ok3Ob9nImjabgqjf5+wjgTa6x/gTW+125wqCLJvZv/gqqlJUFuUxp6jqZ8E
         HHwQHeiXW7hwgNITNvQSWarSrxB2Nye22Gnn4=
Subject: [PATCH] vmalloc.c: fix double error checking
From: "Figo.zhang" <figo1802@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 00:13:21 +0800
Message-Id: <1246983201.2597.13.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is no need for double error checking.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
mm/vmalloc.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f8189a4..56b2469 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -159,20 +159,15 @@ static int vmap_page_range_noflush(unsigned long start, unsigned long end,
 	pgd_t *pgd;
 	unsigned long next;
 	unsigned long addr = start;
-	int err = 0;
 	int nr = 0;
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset_k(addr);
 	do {
 		next = pgd_addr_end(addr, end);
-		err = vmap_pud_range(pgd, addr, next, prot, pages, &nr);
-		if (err)
-			break;
+		if (vmap_pud_range(pgd, addr, next, prot, pages, &nr))
+			return -ENOMEM;
 	} while (pgd++, addr = next, addr != end);
-
-	if (unlikely(err))
-		return err;
 	return nr;
 }
 


