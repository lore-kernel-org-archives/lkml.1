Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbXIWB6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbXIWB6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 21:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbXIWB6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 21:58:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:6514 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbXIWB6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 21:58:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=ISxnUxiBidEe0opkS2GHBqUKlzi4wx/avQcXuDpu4tqNVWSn5gOimEtkKLYW/j3wjRh1fd/q2wsstBLCtnfdTkYmEX4SliVF9DBeD6pS6eZrI8RtG86FpNFl1UsSoubci0L6WgMJRgFqhUH9rTZOWojvGyec788QF/lornkYvIo=
Date: Sun, 23 Sep 2007 10:56:14 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] use pgd_list_add/pgd_list_del
Message-ID: <20070923015614.GA4024@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup by using pgd_list_add() and pgd_list_del() in the right place.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 include/asm-x86_64/pgalloc.h |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: 2.6-git/include/asm-x86_64/pgalloc.h
===================================================================
--- 2.6-git.orig/include/asm-x86_64/pgalloc.h
+++ 2.6-git/include/asm-x86_64/pgalloc.h
@@ -65,7 +65,6 @@ static inline void pgd_ctor(void *x)
 {
 	unsigned boundary;
 	pgd_t *pgd = x;
-	struct page *page = virt_to_page(pgd);
 
 	/*
 	 * Copy kernel pointers in from init.
@@ -75,19 +74,14 @@ static inline void pgd_ctor(void *x)
 		init_level4_pgt + boundary,
 		(PTRS_PER_PGD - boundary) * sizeof(pgd_t));
 
-	spin_lock(&pgd_lock);
-	list_add(&page->lru, &pgd_list);
-	spin_unlock(&pgd_lock);
+	pgd_list_add(pgd);
 }
 
 static inline void pgd_dtor(void *x)
 {
 	pgd_t *pgd = x;
-	struct page *page = virt_to_page(pgd);
 
-        spin_lock(&pgd_lock);
-	list_del(&page->lru);
-	spin_unlock(&pgd_lock);
+	pgd_list_del(pgd);
 }
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
