Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbYIPTzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbYIPTzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 15:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbYIPTzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 15:55:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13014 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYIPTzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 15:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QIdo4Bj5Bd7r58WaoYejtO3lyFYTfwfZgjynudEmt3ck63p9Gz+B1SzBwzWNhCgah6
         xNN7DA4YUYxRamBzlh/pM7Vr4TlxrlTSW5twA+5J9XHz/tPfWXxCLWl1OeTp7KbMFul0
         ZW0cZKbCrzM7E3XwelilTL9Sxueafp8m2UwnQ=
Message-ID: <48D06372.3050809@gmail.com>
Date: Tue, 16 Sep 2008 21:54:58 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: ralf@linux-mips.org, yoichi_yuasa@tripeaks.co.jp,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MIPS] vr41xx: unsigned irq cannot be negative
References: <48CF02EE.8050406@gmail.com> <48CF8E05.6050000@ru.mvista.com>
In-Reply-To: <48CF8E05.6050000@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:
> Hello.

>> @@ -79,8 +80,9 @@ static void irq_dispatch(unsigned int irq)
>>              desc->chip->mask(source_irq);
>>              desc->chip->ack(source_irq);
>>          }
>> -        irq = cascade->get_irq(irq);
>> -        if (irq < 0)
>> +        ret = cascade->get_irq(irq);
>> +        irq = ret;
>> +        if (ret < 0)
>>              atomic_inc(&irq_err_count);
>>          else
>>              irq_dispatch(irq);
>>   
> 
>  How about this:
> 
>         ret = cascade->get_irq(irq);
>         if (ret < 0)
>             atomic_inc(&irq_err_count);
>         else
>             irq_dispatch(ret);
> 
> 
> WBR, Sergei

good suggestion, but shouldn't we then remove source_irq
as well?

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/arch/mips/vr41xx/common/irq.c b/arch/mips/vr41xx/common/irq.c
index cba36a2..ab4e327 100644
--- a/arch/mips/vr41xx/common/irq.c
+++ b/arch/mips/vr41xx/common/irq.c
@@ -63,6 +63,7 @@ static void irq_dispatch(unsigned int irq)
 {
 	irq_cascade_t *cascade;
 	struct irq_desc *desc;
+	int ret;
 
 	if (irq >= NR_IRQS) {
 		atomic_inc(&irq_err_count);
@@ -71,21 +72,22 @@ static void irq_dispatch(unsigned int irq)
 
 	cascade = irq_cascade + irq;
 	if (cascade->get_irq != NULL) {
-		unsigned int source_irq = irq;
-		desc = irq_desc + source_irq;
+		desc = irq_desc + irq;
 		if (desc->chip->mask_ack)
-			desc->chip->mask_ack(source_irq);
+			desc->chip->mask_ack(irq);
 		else {
-			desc->chip->mask(source_irq);
-			desc->chip->ack(source_irq);
+			desc->chip->mask(irq);
+			desc->chip->ack(irq);
 		}
-		irq = cascade->get_irq(irq);
-		if (irq < 0)
+
+		ret = cascade->get_irq(irq);
+		if (ret < 0)
 			atomic_inc(&irq_err_count);
 		else
-			irq_dispatch(irq);
+			irq_dispatch(ret);
+
 		if (!(desc->status & IRQ_DISABLED) && desc->chip->unmask)
-			desc->chip->unmask(source_irq);
+			desc->chip->unmask(irq);
 	} else
 		do_IRQ(irq);
 }

