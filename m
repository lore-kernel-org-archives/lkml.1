Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYGYAv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYGYAv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYGYAvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:51:50 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:25800 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753323AbYGYAvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:51:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aOfWmE1ETbbn4wrZl5XqpEjDQ9Gd5KVo2UlgFgYWf6/aKXk50rHy2ue32LF34dwGx9gJtoHLt95PzpJ6jR+u1nj/XI6hGHYdEih3xP5jmuYvk5FjLS0+3vHqUX+W47+6XhLknqZRSUSet51tZF8pa6ruMnsdlfgKjvYgm3RMWQY=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch/rfc 2.6.26-git] fix PAGE_ALIGN build breakage
Date: Thu, 24 Jul 2008 17:51:47 -0700
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241751.48057.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this afternoon's GIT tree I saw builds failing on avr32,
basically PAGE_ALIGN was used before it was available.

Appended are quick hacks that got it to work for me ... I'm
not sure what the right fix would be though.  Hence "RFC".  ;)

- Dave


--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -36,14 +36,15 @@ extern int sysctl_legacy_va_layout;
 extern unsigned long mmap_min_addr;
 
 #include <asm/page.h>
+
+/* to align the pointer to the (next) page boundary */
+#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
+
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
-
 /*
  * Linux kernel virtual memory manager primitives.
  * The idea being to have a "virtual" mm in the same way
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
 #include <linux/marker.h>
+#include <linux/mm.h>
 #include <asm/local.h>
 
 #include <asm/module.h>
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -59,6 +59,7 @@ struct sched_param {
 #include <linux/errno.h>
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
+#include <linux/mm.h>
 
 #include <asm/system.h>
 #include <asm/page.h>
