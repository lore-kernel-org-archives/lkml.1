Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbYBFNRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbYBFNRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 08:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762775AbYBFNQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 08:16:55 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:53972 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762780AbYBFNQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:16:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=fIujoXQnvmQEHtFAFQ3E3NCysughI9F48kS5uHueOxNBnFN4J3VlOobdo/6AYuLk3wPXsrfh+QLn6voQHuCmo1anW/AIApdG3FeJTB6P4MKe9gBQRR/JzXpRiTFYkoFydo5F6SmAOfo/9deRbB37kl7dc4A/MuIn30hzJimRvbc=
Date: Wed, 6 Feb 2008 22:10:26 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] module: fix __find_symbl() error checks
Message-ID: <20080206131024.GA5057@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch:

http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24/2.6.24-mm1/broken-out/modules-handle-symbols-that-have-a-zero-value.patch

changes the return value of __find_symbol() so that it can handle symbols
that are zero and now it returns -errno for failure.

But some __find_symbl() error checks remain unchanged.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
---
 kernel/module.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: 2.6.24-mm1/kernel/module.c
===================================================================
--- 2.6.24-mm1.orig/kernel/module.c
+++ 2.6.24-mm1/kernel/module.c
@@ -977,7 +977,7 @@ static unsigned long resolve_symbol(Elf_
 
 	ret = __find_symbol(name, &owner, &crc,
 			!(mod->taints & TAINT_PROPRIETARY_MODULE));
-	if (ret) {
+	if (!IS_ERR_VALUE(ret)) {
 		/* use_module can fail due to OOM,
 		   or module initialization or unloading */
 		if (!check_version(sechdrs, versindex, name, mod, crc) ||
@@ -1370,7 +1370,9 @@ void *__symbol_get(const char *symbol)
 
 	preempt_disable();
 	value = __find_symbol(symbol, &owner, &crc, 1);
-	if (value && strong_try_module_get(owner) != 0)
+	if (IS_ERR_VALUE(value))
+		value = 0;
+	else if (strong_try_module_get(owner))
 		value = 0;
 	preempt_enable();
 
