Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbZFZPu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbZFZPu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbZFZPuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:50:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56858 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZFZPuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:50:11 -0400
From: "Singh, Vimal" 
	<IMCEAEX-_O=TI_OU=BD_CN=RECIPIENTS_CN=X0094262@dlee86.itg.ti.com>
To: David Woodhouse <dwmw2@infradead.org>,
       "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
       "jzhang@ti.com" <jzhang@ti.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "david-b@pacbell.net" <david-b@pacbell.net>
Date: Fri, 26 Jun 2009 21:15:23 +0530
Subject: RE: [PATCH][MTD][NAND]: fix omap2.c compile failure and warning
Thread-Topic: [PATCH][MTD][NAND]: fix omap2.c compile failure and warning
Thread-Index: Acn2cDCwauoIdiwQSz65goR/2Dq2+wABO18Q
Message-ID: <19F8576C6E063C45BE387C64729E739404321C60D1@dbde02.ent.ti.com>
References: <1246022509-16194-1-git-send-email-tom.leiming@gmail.com>,<1246028984.663.9.camel@macbook.infradead.org>
In-Reply-To: <1246028984.663.9.camel@macbook.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 8:39 PM, David Woodhouse<dwmw2@infradead.org> wrote:
> On Fri, 2009-06-26 at 21:21 +0800, tom.leiming@gmail.com wrote:
>> From: Ming Lei <tom.leiming@gmail.com>
>>
>> drivers/mtd/nand/omap2.c: In function 'omap_wait':
>> drivers/mtd/nand/omap2.c:543: error: 'jiffies' undeclared (first use in this function)
>> drivers/mtd/nand/omap2.c:543: error: (Each undeclared identifier is reported only once
>> drivers/mtd/nand/omap2.c:543: error: for each function it appears in.)
>> drivers/mtd/nand/omap2.c:557: error: implicit declaration of function 'time_before'
>
> OK.
>
>> ......
>>
>> drivers/mtd/nand/omap2.c: In function 'omap_wait':
>> drivers/mtd/nand/omap2.c:545: warning: 'status' may be used uninitialized in this function
>
> Hm, why do you set it to zero? In the (fairly unlikely) case where you
> never go through the loop at all, because you're preempted until the
> timeout has completed, what value do you want it to return?
>
> Don't just make changes by bashing on the keyboard until the compiler
> shuts up; please apply brain.
>
> That way, I think you'll notice that the return value from this function
> is completely screwed anyway.... Vimal? Shouldn't it be returning
> NAND_STATUS_FAIL in the failure case, not a value read directly from the
> hardware register? And shouldn't there be a cpu_relax() (or even
> schedule) in there too?

That's correct David. I think 'cond_resched()' would be fine here.

>
>> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
>> ---
>>  drivers/mtd/nand/omap2.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
>> index 0cd76f8..2905c79 100644
>> --- a/drivers/mtd/nand/omap2.c
>> +++ b/drivers/mtd/nand/omap2.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/mtd/nand.h>
>>  #include <linux/mtd/partitions.h>
>>  #include <linux/io.h>
>> +#include <linux/jiffies.h>
>>
>>  #include <asm/dma.h>
>>
>> @@ -541,7 +542,8 @@ static int omap_wait(struct mtd_info *mtd, struct nand_chip *chip)
>>       struct omap_nand_info *info = container_of(mtd, struct omap_nand_info,
>>                                                       mtd);
>>       unsigned long timeo = jiffies;
>> -     int status, state = this->state;
>> +     int state = this->state;
>> +     int status = 0;
>>
>>       if (state == FL_ERASING)
>>               timeo += (HZ * 400) / 1000;
> --
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

---
Vimal