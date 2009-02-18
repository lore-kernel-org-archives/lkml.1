Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbZBRFr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbZBRFr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 00:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZBRFru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 00:47:50 -0500
Received: from mail.datangmobile.cn ([219.142.67.62]:59416 "EHLO
	mail.datangmobile.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZBRFru convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 00:47:50 -0500
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6249.0
Subject: Re: [PATCH] fix the interrupt loss problem on powerpc IPIC(2.6.25-2.6.28)
Date: Wed, 18 Feb 2009 13:47:42 +0800
Message-ID: <D728AD1FA2543948B89DE29C5BF4CD0716AF9623@bjmail1.bj.datangmobile.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: [PATCH] fix the interrupt loss problem on powerpc IPIC(2.6.25-2.6.28)
Thread-Index: AcmRc2EX662LitZ8QuOfu3oSK5cwQwABtreQ
From: <dayu@datangmobile.cn>
To: <olof@lixom.net>
Cc: <leoli@freescale.com>, <galak@kernel.crashing.org>,
       <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

renew description in  the patch,  with this change the 'temp'  is still used to make code clear.

___________________________________________

From: Da Yu <dayu@datangmobile.cn>
Date: Wed, 18 Feb 2009 19:58:20 +0800
Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.25-2.6.28)

Description: The interrupt pending register is write 1 clear.  If there are more than one external interrupts pending at the same time, acking the first interrupt by reading pending register then OR the corresponding bit and write back to pending register will also clear other interrupt pending bits.  That will cause loss of interrupt.

Signed-off-by: Da Yu <dayu@datangmobile.cn>
---

--- a/arch/powerpc/sysdev/ipic.c	2009-02-18 09:47:04.000000000 +0800
+++ b/arch/powerpc/sysdev/ipic.c	2009-02-18 09:46:34.000000000 +0800
@@ -568,8 +568,7 @@ static void ipic_ack_irq(unsigned int vi

 	spin_lock_irqsave(&ipic_lock, flags);

-	temp = ipic_read(ipic->regs, ipic_info[src].ack);
-	temp |= (1 << (31 - ipic_info[src].bit));
+	temp = 1 << (31 - ipic_info[src].bit);
 	ipic_write(ipic->regs, ipic_info[src].ack, temp);

 	/* mb() can't guarantee that ack is finished.  But it does finish
@@ -592,8 +591,7 @@ static void ipic_mask_irq_and_ack(unsign
 	temp &= ~(1 << (31 - ipic_info[src].bit));
 	ipic_write(ipic->regs, ipic_info[src].mask, temp);

-	temp = ipic_read(ipic->regs, ipic_info[src].ack);
-	temp |= (1 << (31 - ipic_info[src].bit));
+	temp = 1 << (31 - ipic_info[src].bit);
 	ipic_write(ipic->regs, ipic_info[src].ack, temp);

 	/* mb() can't guarantee that ack is finished.  But it does finish



 
 

-----邮件原件-----
发件人: Olof Johansson [mailto:olof@lixom.net] 
发送时间: 2009年2月18日 10:43
收件人: 笪禹
抄送: leoli@freescale.com; galak@kernel.crashing.org; linuxppc-dev@ozlabs.org; linux-kernel@vger.kernel.org
主题: Re: [PATCH] fix the interrupt loss problem on powerpc IPIC(2.6.25-2.6.28)

On Wed, Feb 18, 2009 at 10:16:07AM +0800, dayu@datangmobile.cn wrote:
> From: Da Yu <dayu@datangmobile.cn>
> Date: Wed, 18 Feb 2009 19:58:20 +0800
> Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC 
> (2.6.25-2.6.28)
> 
> Signed-off-by: Da Yu <dayu@datangmobile.cn>

Still no proper explanation in the patch.

Also, with this change, is 'temp' really needed, or can you just pass in the mask by hand?


-Olof

> ---
> 
> --- a/arch/powerpc/sysdev/ipic.c	2009-02-18 09:47:04.000000000 +0800
> +++ b/arch/powerpc/sysdev/ipic.c	2009-02-18 09:46:34.000000000 +0800
> @@ -568,8 +568,7 @@ static void ipic_ack_irq(unsigned int vi
> 
>  	spin_lock_irqsave(&ipic_lock, flags);
> 
> -	temp = ipic_read(ipic->regs, ipic_info[src].ack);
> -	temp |= (1 << (31 - ipic_info[src].bit));
> +	temp = 1 << (31 - ipic_info[src].bit);
>  	ipic_write(ipic->regs, ipic_info[src].ack, temp);
> 
>  	/* mb() can't guarantee that ack is finished.  But it does finish

