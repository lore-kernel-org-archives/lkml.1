Return-Path: <linux-kernel-owner+w=401wt.eu-S1752763AbYFPEYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbYFPEYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 00:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750978AbYFPEYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 00:24:44 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:40834 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYFPEYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 00:24:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vPqqoIYvFZqsCHOe+EV1bH/v6Zc0HQ2DeK+ViWLCicyndG5oDPGJdM/EM1NO03Xa/W
         qdA7lCksgwM+zGjHbMB02czEvx81gVM7Sd31wgpByk/7+mBVF8yeACUXL/N8dwR9Igf/
         /lTZnGv0fBkNBlVPe8owkFMBwQPFjwydUvM5Q=
Date: Mon, 16 Jun 2008 12:25:28 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, mingo@elte.hu, hpa@zytor.com
Subject: [PATCH] kernel parameter vmalloc size fix
Message-ID: <20080616042528.GA3003@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

booting kernel with vmalloc=[any size<=16m] will oops.

It's due to the vm area hole.

In include/asm-x86/pgtable_32.h:
#define VMALLOC_OFFSET	(8 * 1024 * 1024)
#define VMALLOC_START	(((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
			 & ~(VMALLOC_OFFSET - 1))

BUG_ON in arch/x86/mm/init_32.c will be triggered:
BUG_ON((unsigned long)high_memory		> VMALLOC_START);

Fixed by return -EINVAL for invalid parameter

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Documentation/kernel-parameters.txt |    3 ++-
arch/x86/kernel/setup_32.c          |   11 +++++++++--
2 files changed, 11 insertions(+), 3 deletions(-)

diff -upr linux/Documentation/kernel-parameters.txt linux.new/Documentation/kernel-parameters.txt
--- linux/Documentation/kernel-parameters.txt	2008-06-16 11:30:29.000000000 +0800
+++ linux.new/Documentation/kernel-parameters.txt	2008-06-16 11:43:01.000000000 +0800
@@ -2139,7 +2139,8 @@ and is between 256 and 4096 characters. 
 			size of <nn>. This can be used to increase the
 			minimum size (128MB on x86). It can also be used to
 			decrease the size and leave more room for directly
-			mapped kernel RAM.
+			mapped kernel RAM. Note that the size must be bigger
+			than 16M now on i386 due to the memory hole.
 
 	vmhalt=		[KNL,S390] Perform z/VM CP command after system halt.
 			Format: <command>
diff -upr linux/arch/x86/kernel/setup_32.c linux.new/arch/x86/kernel/setup_32.c
--- linux/arch/x86/kernel/setup_32.c	2008-06-16 11:28:51.000000000 +0800
+++ linux.new/arch/x86/kernel/setup_32.c	2008-06-16 11:43:35.000000000 +0800
@@ -305,15 +305,22 @@ early_param("highmem", parse_highmem);
 
 /*
  * vmalloc=size forces the vmalloc area to be exactly 'size'
- * bytes. This can be used to increase (or decrease) the
+ * bytes. Now size must be bigger than 16m due to the memory hole.
+ * This can be used to increase (or decrease) the
  * vmalloc area - the default is 128m.
  */
 static int __init parse_vmalloc(char *arg)
 {
+	unsigned int v;
+
 	if (!arg)
 		return -EINVAL;
 
-	__VMALLOC_RESERVE = memparse(arg, &arg);
+	v = memparse(arg, &arg);
+	if (v <= 2 * VMALLOC_OFFSET)
+		return -EINVAL;
+	__VMALLOC_RESERVE = v;
+
 	return 0;
 }
 early_param("vmalloc", parse_vmalloc);
