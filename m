Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZCTIPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZCTIPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZCTIPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:15:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:62367 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbZCTIPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:15:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=HBlYN9LumtBRxir7cnKxr5hS4a9/5bYR/0EbCCllGk2qtNedBFLJ/BF35uBD4IGAi
	aUKDlAUw6PORm0rsCaiMw==
MIME-Version: 1.0
Date: Fri, 20 Mar 2009 16:15:16 +0800
Message-ID: <9c0b8b730903200115i7ae4512di97418958e05f6a0e@mail.gmail.com>
Subject: [PATCH] crypto/scatterwalk.c to skip unnecessary flush_dcache_page() 
	calls which may cause kernel panic
From: =?Big5?B?Q2h1bmctWWloIFdhbmcgKKT9sVLFdCk=?= <cywang@google.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am developing the ipsec tools on ARM platform. When I turn the
 CONFIG_DEBUG_VM on, the ipsec traffic triggers the kernel panic
which is caused by the VM_DEBUG_ON(PageSlab(page)) of
page_mapping() in the call of flush_dcache_page().

The root cause is that ipsec/esp intends to encrypt the original
data and dynamically allocate cache memory in socket buffer for
this purpose. However, all the cache memory pages dynamically
allocated in socket buffer will be flagged as PG_slab by
__SetPageSlab(). That's the reason it asserts on
VM_BUG_ON(PageSlab(page)) in flush_dcache_page(). Since the
flush_dcache_page() is to ensure the cache coherency between
kernel mapping and userspace mapping. The kernel cache memory
created in socket buffer for encrypting ipsec traffic does not
need to call this function at all since it is all kernel space
data.

Below is my patch for fixing this bug for  CONFIG_DEBUG_VM=y.

Chung-yih


diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 9aeeb52..3de89a4 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -54,7 +54,8 @@ static void scatterwalk_pagedone(struct scatter_walk
*walk, int out,
                struct page *page;

                page = sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT);
-               flush_dcache_page(page);
+               if (!PageSlab(page))
+                       flush_dcache_page(page);
        }

        if (more) {
