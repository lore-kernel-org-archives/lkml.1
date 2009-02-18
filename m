Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZBRCQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZBRCQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZBRCQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:16:10 -0500
Received: from mail.datangmobile.cn ([219.142.67.62]:30764 "EHLO
	mail.datangmobile.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZBRCQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:16:10 -0500
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6249.0
Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.25-2.6.28)
Date: Wed, 18 Feb 2009 10:16:07 +0800
Message-ID: <D728AD1FA2543948B89DE29C5BF4CD0716AC37FD@bjmail1.bj.datangmobile.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.25-2.6.28)
Thread-Index: AcmREJ+5ixviDtrORO+bdu7Z0t30NAAXfyXA
From: <dayu@datangmobile.cn>
To: <leoli@freescale.com>, <galak@kernel.crashing.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Da Yu <dayu@datangmobile.cn>
Date: Wed, 18 Feb 2009 19:58:20 +0800
Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.25-2.6.28)

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
发件人: Li Yang [mailto:leoli@freescale.com] 
发送时间: 2009年2月17日 22:38
收件人: Kumar Gala
抄送: 笪禹; linux-kernel@vger.kernel.org; linuxppc-dev@ozlabs.org
主题: Re: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.23)

On Tue, Feb 17, 2009 at 10:12 PM, Kumar Gala <galak@kernel.crashing.org> wrote:
>
> On Feb 17, 2009, at 6:44 AM, <dayu@datangmobile.cn> 
> <dayu@datangmobile.cn>
> wrote:
>
>> From: Da Yu <dayu@datangmobile.cn>
>> Date: Tue, 17 Feb 2009 19:58:20 +0800
>> Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC 
>> (2.6.23)
>>
>> Signed-off-by: Da Yu <dayu@datangmobile.cn>
>> ---
>
> Please provide a bit more description as to why this fixes the issue.

The pending register is write 1 clear.  If there are more than one external interrupts pending at the same time, acking the first interrupt will also clear other interrupt pending bits.  That will cause loss of interrupt.

- Leo
