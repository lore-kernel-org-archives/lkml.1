Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbZJNRIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbZJNRIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 13:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbZJNRIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 13:08:20 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:58425 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZJNRIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 13:08:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=lFv+k6VCUImX2wjjPJ0vDmjBFp0vPkirkDCXtqPfAN3Gd8wWl8rkJEDLNgVZjMmmlT
         tEuxRvchd9fkiXc10HVnDKpUJ9X4DyP1m84C1ZMgCghbXziV28qxBMtd1VntFnHLKH47
         zk4xIilsAQ3h/iwHjktgZrm7qOohyHYVl1+oE=
Message-ID: <4AD60776.5090404@gmail.com>
Date: Wed, 14 Oct 2009 19:16:38 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "Du, Alek" <alek.du@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: Fix test on unsigned in lnw_irq_type()
References: <4AD33958.7020900@gmail.com>	 <20091012151127.312c986a.akpm@linux-foundation.org>	 <EADF0A36011179459010BDF5142A457501CEB8C146@pdsmsx502.ccr.corp.intel.com>	 <20091013105901.972f7dbe.akpm@linux-foundation.org>	 <EADF0A36011179459010BDF5142A457501CEC48A68@pdsmsx502.ccr.corp.intel.com> <25e057c00910140850j787e9fd6lcd6ac236a0f4851d@mail.gmail.com> <EADF0A36011179459010BDF5142A457501CEC48E76@pdsmsx502.ccr.corp.intel.com>
In-Reply-To: <EADF0A36011179459010BDF5142A457501CEC48E76@pdsmsx502.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wrong test was used, gpio is unsigned. Also lnw->chip.ngpio is
set to 64, so if gpio equals that, then reg (= gpio / 32) becomes 2,
an index out of bounds for GRER and GFER that have 2 elements.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
>>>> From: Andrew Morton [mailto:akpm@linux-foundation.org]
>>>>> -    if (gpio < 0 || gpio > lnw->chip.ngpio)
>>>>> +    if (gpio > lnw->chip.ngpio)
>>>>>              return -EINVAL;
>>>>
>>>> Should that be >= ?

> Oh, my bad. Andrew is right, should be >=...

Ok, how about this then?

diff --git a/drivers/gpio/langwell_gpio.c b/drivers/gpio/langwell_gpio.c
index 5711ce5..72af3fc 100644
--- a/drivers/gpio/langwell_gpio.c
+++ b/drivers/gpio/langwell_gpio.c
@@ -123,7 +123,7 @@ static int lnw_irq_type(unsigned irq, unsigned type)
 	void __iomem *grer = (void __iomem *)(&lnw->reg_base->GRER[reg]);
 	void __iomem *gfer = (void __iomem *)(&lnw->reg_base->GFER[reg]);
 
-	if (gpio < 0 || gpio > lnw->chip.ngpio)
+	if (gpio >= lnw->chip.ngpio)
 		return -EINVAL;
 	spin_lock_irqsave(&lnw->lock, flags);
 	if (type & IRQ_TYPE_EDGE_RISING)
