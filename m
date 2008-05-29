Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYE2Nqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYE2Nqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbYE2NqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:46:10 -0400
Received: from gw.goop.org ([64.81.55.164]:41521 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbYE2NqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:46:09 -0400
Message-ID: <483EB37F.7090902@goop.org>
Date: Thu, 29 May 2008 14:45:35 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [PATCH 1/2] make page-aligned data and bss less fragile
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making a variable page-aligned by using
__attribute__((section(".data.page_aligned"))) is fragile because if
sizeof(variable) is not also a multiple of page size, it leaves
variables in the remainder of the section unaligned.

This patch introduces two new qualifiers, __page_aligned_data and
__page_aligned_bss to set the section *and* the alignment of
variables.  This makes page-aligned variables more robust because the
linker will make sure they're aligned properly.  Unfortunately it
requires *all* page-aligned data to use these macros...

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/linux/linkage.h |    8 ++++++++
 1 file changed, 8 insertions(+)

===================================================================
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_LINKAGE_H
 #define _LINUX_LINKAGE_H
 
+#include <linux/compiler.h>
 #include <asm/linkage.h>
 
 #define notrace __attribute__((no_instrument_function))
@@ -18,6 +19,13 @@
 #ifndef asmregparm
 # define asmregparm
 #endif
+
+/*
+ * Mark a variable page aligned, and put it in an appropriate page
+ * aligned section.
+ */
+#define __page_aligned_data	__section(.data.page_aligned) __aligned(PAGE_SIZE)
+#define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
 
 /*
  * This is used by architectures to keep arguments on the stack


