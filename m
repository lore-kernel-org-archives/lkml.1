Return-Path: <linux-kernel-owner+w=401wt.eu-S1753759AbZBQMou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbZBQMou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZBQMom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:44:42 -0500
Received: from mail.datangmobile.cn ([219.142.67.62]:46341 "EHLO
	mail.datangmobile.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbZBQMol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:44:41 -0500
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6249.0
Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.23)
Date: Tue, 17 Feb 2009 20:44:37 +0800
Message-ID: <D728AD1FA2543948B89DE29C5BF4CD0716AC2DDE@bjmail1.bj.datangmobile.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.23)
Thread-Index: AcmQ2n06DcXf5Ar+T+SgI94lU1s0UQADMFlQAAVmoQA=
From: <dayu@datangmobile.cn>
To: <LeoLi@freescale.com>, <linux-kernel@vger.kernel.org>
Cc: <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Da Yu <dayu@datangmobile.cn>
Date: Tue, 17 Feb 2009 19:58:20 +0800
Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.23)

Signed-off-by: Da Yu <dayu@datangmobile.cn>
---

--- a/arch/powerpc/sysdev/ipic.c	2009-02-17 15:10:18.000000000 +0800
+++ b/arch/powerpc/sysdev/ipic.c	2009-02-17 20:05:28.000000000 +0800
@@ -561,8 +561,7 @@ static void ipic_ack_irq(unsigned int vi

 	spin_lock_irqsave(&ipic_lock, flags);

-	temp = ipic_read(ipic->regs, ipic_info[src].pend);
-	temp |= (1 << (31 - ipic_info[src].bit));
+	temp = 1 << (31 - ipic_info[src].bit);
 	ipic_write(ipic->regs, ipic_info[src].pend, temp);

 	spin_unlock_irqrestore(&ipic_lock, flags);
@@ -581,8 +580,7 @@ static void ipic_mask_irq_and_ack(unsign
 	temp &= ~(1 << (31 - ipic_info[src].bit));
 	ipic_write(ipic->regs, ipic_info[src].mask, temp);

-	temp = ipic_read(ipic->regs, ipic_info[src].pend);
-	temp |= (1 << (31 - ipic_info[src].bit));
+	temp = 1 << (31 - ipic_info[src].bit);
 	ipic_write(ipic->regs, ipic_info[src].pend, temp);

 	spin_unlock_irqrestore(&ipic_lock, flags);






 

-----邮件原件-----
发件人: Li Yang-R58472 [mailto:LeoLi@freescale.com] 
发送时间: 2009年2月17日 18:17
收件人: 笪禹; linux-kernel@vger.kernel.org
抄送: linuxppc-dev@ozlabs.org
主题: RE: PROBLEM: incorrect interrupt ack lead to interrupt loss on freescale powerpc

> -----Original Message-----
> From: dayu@datangmobile.cn [mailto:dayu@datangmobile.cn]
> Sent: Tuesday, February 17, 2009 4:34 PM
> To: linux-kernel@vger.kernel.org
> Cc: Li Yang-R58472
> Subject: PROBLEM: incorrect interrupt ack lead to interrupt loss on 
> freescale powerpc
> 
>  
> [1.] One line summary of the problem: incorrect interrupt ack  lead to 
> interrupt loss

Acked-by: Li Yang <leoli@freescale.com>

However, please resend the patch with a brief description and Signed-off-by at the top of the patch.  You can read the Documentation/SubmittiongPatches for more information, or even a Chinese version under Documentation/zh_CN/.

Here are some small comments about the patch itself,

--- a/arch/powerpc/sysdev/ipic.c	2009-02-17 15:10:18.000000000 +0800
+++ b/arch/powerpc/sysdev/ipic.c	2009-02-17 15:10:24.000000000 +0800
@@ -9,6 +9,7 @@
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
+ * Da Yu <dayu@datangmobile.cn> fixed the interrupt loss problem on 
+ powerpc IPIC


It's not recommended to add changelog in the source now.  Please describe in the patch description area.

  */
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -561,8 +562,7 @@
 
 	spin_lock_irqsave(&ipic_lock, flags);
 
-	temp = ipic_read(ipic->regs, ipic_info[src].pend);
-	temp |= (1 << (31 - ipic_info[src].bit));
+	temp = (1 << (31 - ipic_info[src].bit));


Remove unneeded brackets.


 	ipic_write(ipic->regs, ipic_info[src].pend, temp);
 
 	spin_unlock_irqrestore(&ipic_lock, flags); @@ -581,8 +581,7 @@
 	temp &= ~(1 << (31 - ipic_info[src].bit));
 	ipic_write(ipic->regs, ipic_info[src].mask, temp);
 
-	temp = ipic_read(ipic->regs, ipic_info[src].pend);
-	temp |= (1 << (31 - ipic_info[src].bit));
+	temp = (1 << (31 - ipic_info[src].bit));

Same as above.


 	ipic_write(ipic->regs, ipic_info[src].pend, temp);
 
 	spin_unlock_irqrestore(&ipic_lock, flags);
