Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYGELVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYGELVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbYGELVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:21:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:38939 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbYGELVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:21:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=kWI5bJMREiKAupwXWtBlloG+1QfK0tgmLz6dqS1uEmwf8XOoYuXn5vRhqhS+hRxaSk
         ZqgbMDy/86VrEItKeBSwBufPHg+FGaWhy9GsoV2s84dx/DudbiYK9Wx+GW8xTtfygAl7
         GBRDFa+9lN2l8Dk7HwOzqn4WKf8Ge01lwgbWg=
Date: Sat, 5 Jul 2008 20:21:17 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Subject: [PATCH] auxdisplay: small cleanups
Message-ID: <20080705112116.GC17071@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Use BUILD_BUG_ON for CFAG12864B_SIZE instead of runtime-check

- Use get_zeroed_page()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Miguel Ojeda Sandonis <maxextreme@gmail.com>
---
 drivers/auxdisplay/cfag12864b.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

Index: 2.6-git/drivers/auxdisplay/cfag12864b.c
===================================================================
--- 2.6-git.orig/drivers/auxdisplay/cfag12864b.c
+++ 2.6-git/drivers/auxdisplay/cfag12864b.c
@@ -336,16 +336,9 @@ static int __init cfag12864b_init(void)
 			"ks0108 is not initialized\n");
 		goto none;
 	}
+	BUILD_BUG_ON(PAGE_SIZE < CFAG12864B_SIZE);
 
-	if (PAGE_SIZE < CFAG12864B_SIZE) {
-		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
-			"page size (%i) < cfag12864b size (%i)\n",
-			(unsigned int)PAGE_SIZE, CFAG12864B_SIZE);
-		ret = -ENOMEM;
-		goto none;
-	}
-
-	cfag12864b_buffer = (unsigned char *) __get_free_page(GFP_KERNEL);
+	cfag12864b_buffer = (unsigned char *) get_zeroed_page(GFP_KERNEL);
 	if (cfag12864b_buffer == NULL) {
 		printk(KERN_ERR CFAG12864B_NAME ": ERROR: "
 			"can't get a free page\n");
@@ -367,8 +360,6 @@ static int __init cfag12864b_init(void)
 	if (cfag12864b_workqueue == NULL)
 		goto cachealloced;
 
-	memset(cfag12864b_buffer, 0, CFAG12864B_SIZE);
-
 	cfag12864b_clear();
 	cfag12864b_on();
 
