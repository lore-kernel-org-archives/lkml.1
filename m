Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbZBRM47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbZBRM47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 07:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZBRM4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 07:56:51 -0500
Received: from mail-gx0-f163.google.com ([209.85.217.163]:39136 "EHLO
	mail-gx0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbZBRM4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 07:56:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OB1/kweMhuPEr2sZZln28LY4YX2wa4ScaI8F+mrUqH1pIz4213br/WB+xaGY3+e+PC
         JlJ/8TmFe33p+MAQdbnAjbvJ7sWJJMT2lB0oTblF6j1ZJxAiq07+N/M6QcRsybO2h8a5
         guWhlS/eTAjfH1wjJtXCcPwcfSXKrXJiztILk=
Date: Wed, 18 Feb 2009 20:56:49 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [Patch] mm: fix null pointer dereference in vm_normal_page()
Message-ID: <20090218125649.GU7272@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One usage of vm_normal_page() is:

    struct page *page = vm_normal_page(gate_vma, start, *pte);

where gate_vma is returned by get_gate_vma() which can be NULL.
So let vm_normal_page return NULL when vma is NULL.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>

---
diff --git a/mm/memory.c b/mm/memory.c
index baa999e..e428aa6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -493,6 +493,9 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 {
 	unsigned long pfn = pte_pfn(pte);
 
+	if (!vma)
+		return NULL;
+
 	if (HAVE_PTE_SPECIAL) {
 		if (likely(!pte_special(pte)))
 			goto check_pfn;


