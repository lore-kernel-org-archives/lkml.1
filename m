Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbYJMK6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbYJMK6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbYJMK6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:58:01 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:36825 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbYJMK6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:58:00 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: GIT head no longer boots on x86-64
Date: Mon, 13 Oct 2008 12:56:54 +0200
Message-Id: <1223895414-19793-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081013112024.0183f982@lxorguk.ukuu.org.uk>
References: <20081013112024.0183f982@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you try the debug patch below to see what address is text_poke trying
to translate?

---
 mm/vmalloc.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bba06c4..8b8d0a4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -179,13 +179,17 @@ struct page *vmalloc_to_page(const void *vmalloc_addr)
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *ptep, pte;
+	char buf[KSYM_NAME_LEN];
 
 	/*
 	 * XXX we might need to change this if we add VIRTUAL_BUG_ON for
 	 * architectures that do not vmalloc module space
 	 */
-	VIRTUAL_BUG_ON(!is_vmalloc_addr(vmalloc_addr) &&
-			!is_module_address(addr));
+/*	VIRTUAL_BUG_ON(!is_vmalloc_addr(vmalloc_addr) &&
+			!is_module_address(addr));*/
+	sprint_symbol(buf, (unsigned long)__builtin_return_address(0));
+	if (!is_vmalloc_addr(vmalloc_addr) && !is_module_address(addr))
+		printk("BUG? %s (from %s): %p\n", __func__, buf, vmalloc_addr);
 
 	if (!pgd_none(*pgd)) {
 		pud = pud_offset(pgd, addr);
-- 
1.6.0.2

