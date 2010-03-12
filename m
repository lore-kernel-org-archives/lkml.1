Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934529Ab0CLTNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 14:13:36 -0500
Received: from smtp123.mail.ukl.yahoo.com ([77.238.184.54]:28438 "HELO
	smtp123.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934480Ab0CLTM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 14:12:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=YTJKRVrGyK/jGpe5hJd5z+KjUuw/mOAt/hRk+siQPx10pDz5csDRYuNRe/vtK04R0l8ZOmjSzFFexcwKGFdl525mUlcRpNPmw0OdeEqFynIMCkAuAKA3X0pXtVCVl/Irzc1Tuc+ZF9fqMew/ZkxsR3usHIfphiePk0Fzq5kAlDU=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: .CW7MlcVM1l4_pO_303EUbGlUYezR9MK1jiTFmCJj2.i.pxnnXZjE_.qmnPtvQ8yiADhrU4ehzwa4mPkxV6k9upWn6Ozd873Yi9nz2WC2Qqq0g28RTU_9WrGvFnBkBNXjhj6Zy5C1yzbgR63uS38ptASTuKyl6JcAPceUsoFGUqV4Dwnpu78gaw6KRKxtFjH2Qv6TJ8l.m_xDxoUFePEK1sgSwRMjX7KSM7JgH1V5C5_gSOHJIgPco_H5sNCoqeWGGArHWAwbuB5zHt9oE2FXNnbUvh8EpEZFw--
X-Yahoo-Newman-Property: ymail-3
From: Albert Herranz <albert_herranz@yahoo.es>
To: linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Albert Herranz <albert_herranz@yahoo.es>, linux-kernel@vger.kernel.org,
       x86@kernel.org, linux-ia64@vger.kernel.org
Subject: [PATCH v4 05/11] swiotlb: add swiotlb_set_default_size()
Date: Fri, 12 Mar 2010 20:12:40 +0100
Message-Id: <1268421166-4791-6-git-send-email-albert_herranz@yahoo.es>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268421166-4791-1-git-send-email-albert_herranz@yahoo.es>
References: <1268421166-4791-1-git-send-email-albert_herranz@yahoo.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current SWIOTLB code uses a default of 64MB for the IO TLB area.
This size can be influenced using a kernel command line parameter "swiotlb".
Unfortunately, the parsing of the kernel command line is done _after_ the
swiotlb is initialized on some architectures.

This patch adds a new function swiotlb_set_default_size() which can be used
before swiotlb_init() to indicate the desired IO TLB area size in bytes.

This will be used later to implement a smaller IO TLB on the Nintendo Wii
video game console which just comes with 24MB + 64MB of RAM.

CC: linuxppc-dev@lists.ozlabs.org
CC: linux-kernel@vger.kernel.org
CC: x86@kernel.org
CC: linux-ia64@vger.kernel.org
Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
---
 include/linux/swiotlb.h |    2 ++
 lib/swiotlb.c           |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 3954228..2af6a45 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -22,6 +22,8 @@ extern int swiotlb_force;
  */
 #define IO_TLB_SHIFT 11
 
+extern size_t __init swiotlb_set_default_size(size_t size);
+
 extern void swiotlb_init(int verbose);
 
 extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 8f2dad9..dbeca50 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -117,6 +117,26 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
+/**
+ * swiotlb_set_default_size() - set the default size for the IO TLB
+ * @size:	size in bytes of the IO TLB
+ *
+ * A platform can use this function to change the default size of the
+ * IO TLB when the default of 64MB is not suitable.
+ * This function must be called before swiotlb_init().
+ *
+ * Note that on some platforms this is the only way to influence the
+ * size of the IO TLB, as the command line may be parsed _after_ the
+ * IO TLB is initialized.
+ */
+size_t __init swiotlb_set_default_size(size_t size)
+{
+	size_t previous_size = io_tlb_nslabs << IO_TLB_SHIFT;
+
+	io_tlb_nslabs = size >> IO_TLB_SHIFT;
+	return previous_size;
+}
+
 void * __weak __init swiotlb_alloc_boot(size_t size, unsigned long nslabs)
 {
 	return alloc_bootmem_low_pages(size);
-- 
1.6.3.3

