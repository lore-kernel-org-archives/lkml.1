Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbYIUO13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbYIUO13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 10:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbYIUO1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 10:27:22 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:24485 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYIUO1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 10:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KWMd9/jrdImk5MbJ+qprMuGIoeKceFV3yUYHrmMu5iE8N/lwy9uKZK3CwCEU6zg867
         TeChie0Q0/DAlHAh2y6VpI85tTnCWGrM/Ox1+7fPVIG+NgR4QTKzQyCbHCY2oN+upZRv
         bK00hy+CI7i7o0RFMcutjtKWK3hvgGCeLn9EA=
Date: Sun, 21 Sep 2008 23:27:13 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: check for ioremap() failure in copy_oldmem_page()
Message-ID: <20080921142711.GB8790@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a check for ioremap() failure in copy_oldmem_page().
This patch also includes small coding style fixes.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/crash_dump_64.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: 2.6-git/arch/x86/kernel/crash_dump_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/crash_dump_64.c
+++ 2.6-git/arch/x86/kernel/crash_dump_64.c
@@ -33,14 +33,16 @@ ssize_t copy_oldmem_page(unsigned long p
 		return 0;
 
 	vaddr = ioremap(pfn << PAGE_SHIFT, PAGE_SIZE);
+	if (!vaddr)
+		return -ENOMEM;
 
 	if (userbuf) {
-		if (copy_to_user(buf, (vaddr + offset), csize)) {
+		if (copy_to_user(buf, vaddr + offset, csize)) {
 			iounmap(vaddr);
 			return -EFAULT;
 		}
 	} else
-	memcpy(buf, (vaddr + offset), csize);
+		memcpy(buf, vaddr + offset, csize);
 
 	iounmap(vaddr);
 	return csize;
