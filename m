Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbZIOOPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbZIOOPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 10:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZIOOPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 10:15:14 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45908 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753349AbZIOOPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 10:15:13 -0400
Message-ID: <4AAFA16B.2040806@austin.ibm.com>
Date: Tue, 15 Sep 2009 09:15:07 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Brian King <brking@linux.vnet.ibm.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dynamic logical partitioning infrastructure
References: <4AAABC55.4070207@austin.ibm.com> <4AAABCE3.5090702@austin.ibm.com> <4AAE8BDE.3090002@linux.vnet.ibm.com>
In-Reply-To: <4AAE8BDE.3090002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian King wrote:
> Nathan Fontenot wrote:
>> +#include <linux/kernel.h>
>> +#include <linux/kref.h>
>> +#include <linux/notifier.h>
>> +#include <linux/proc_fs.h>
>> +#include <linux/spinlock.h>
>> +
>> +#include <asm/prom.h>
>> +#include <asm/machdep.h>
>> +#include <asm/uaccess.h>
>> +#include <asm/rtas.h>
>> +#include <asm/pSeries_reconfig.h>
>> +
>> +#define CFG_CONN_WORK_SIZE    4096
>> +static char workarea[CFG_CONN_WORK_SIZE];
>> +spinlock_t workarea_lock;
> 
> This can be:
> 
> static DEFINE_SPINLOCK(workarea_lock);
> 
> Then you can get rid of the runtime initializer.

Good catch,  I will fix it in the updated patches.

> 
>> +
>> +int release_drc(u32 drc_index)
>> +{
>> +    int dr_status, rc;
>> +
>> +    rc = rtas_call(rtas_token("get-sensor-state"), 2, 2, &dr_status,
>> +               DR_ENTITY_SENSE, drc_index);
>> +    if (rc || dr_status != DR_ENTITY_PRESENT)
>> +        return -1;
>> +
>> +    rc = rtas_set_indicator(ISOLATION_STATE, drc_index, ISOLATE);
>> +    if (rc)
>> +        return -1;
>> +
>> +    rc = rtas_set_indicator(ALLOCATION_STATE, drc_index, ALLOC_UNUSABLE);
>> +    if (rc) {
>> +        rtas_set_indicator(ISOLATION_STATE, drc_index, UNISOLATE);
>> +        return -1;
>> +    }
> 
> Is there a better return value here that might be more descriptive than -1?

Yes,  I could return the rtas error code to the user to allow the caller to
evaluate it if they wanted to.  For what I am doing I am only concerned with
success/failure so I did not deal with returning anything other than -1.

I'll update the next patch to return the rtas error for failures and 0
for success.

> 
> 
>> +
>> +    return 0;
>> +}
>> +
>> +static int pseries_dlpar_init(void)
>> +{
>> +    spin_lock_init(&workarea_lock);
>> +
>> +    if (!machine_is(pseries))
>> +        return 0;
> 
> What's the point of this if check if you return 0 either way?

Yes, it seems a bit odd here, but in patches later in this series I
add additional initialization steps after the machine_is() check
such that it makes sense to bail out here if the check fails.

> 
>> +
>> +    return 0;
>> +}
>> +__initcall(pseries_dlpar_init);
> 
> 
>> Index: powerpc/arch/powerpc/platforms/pseries/reconfig.c
>> ===================================================================
>> --- powerpc.orig/arch/powerpc/platforms/pseries/reconfig.c    2009-09-11
>> 12:43:39.000000000 -0500
>> +++ powerpc/arch/powerpc/platforms/pseries/reconfig.c    2009-09-11
>> 12:51:52.000000000 -0500
>> @@ -95,7 +95,7 @@
>>     return parent;
>> }
>>
>> -static BLOCKING_NOTIFIER_HEAD(pSeries_reconfig_chain);
>> +struct blocking_notifier_head pSeries_reconfig_chain =
>> BLOCKING_NOTIFIER_INIT(pSeries_reconfig_chain);
> 
> Can't this just be?
> 
> BLOCKING_NOTIFIER_HEAD(pSeries_reconfig_chain);
> 

I think I tried this and was having issues,  I don't remember what they
were though.  I will try to fix this in the updated patch.

-Nathan Fontenot
