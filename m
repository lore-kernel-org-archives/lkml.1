Return-Path: <linux-kernel-owner+w=401wt.eu-S933266AbZINSa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbZINSa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933255AbZINSay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:30:54 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:51782 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173AbZINSax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:30:53 -0400
Message-ID: <4AAE8BDE.3090002@linux.vnet.ibm.com>
Date: Mon, 14 Sep 2009 13:30:54 -0500
From: Brian King <brking@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Nathan Fontenot <nfont@austin.ibm.com>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] dynamic logical partitioning infrastructure
References: <4AAABC55.4070207@austin.ibm.com> <4AAABCE3.5090702@austin.ibm.com>
In-Reply-To: <4AAABCE3.5090702@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Fontenot wrote:
> +#include <linux/kernel.h>
> +#include <linux/kref.h>
> +#include <linux/notifier.h>
> +#include <linux/proc_fs.h>
> +#include <linux/spinlock.h>
> +
> +#include <asm/prom.h>
> +#include <asm/machdep.h>
> +#include <asm/uaccess.h>
> +#include <asm/rtas.h>
> +#include <asm/pSeries_reconfig.h>
> +
> +#define CFG_CONN_WORK_SIZE    4096
> +static char workarea[CFG_CONN_WORK_SIZE];
> +spinlock_t workarea_lock;

This can be:

static DEFINE_SPINLOCK(workarea_lock);

Then you can get rid of the runtime initializer.

> +
> +int release_drc(u32 drc_index)
> +{
> +    int dr_status, rc;
> +
> +    rc = rtas_call(rtas_token("get-sensor-state"), 2, 2, &dr_status,
> +               DR_ENTITY_SENSE, drc_index);
> +    if (rc || dr_status != DR_ENTITY_PRESENT)
> +        return -1;
> +
> +    rc = rtas_set_indicator(ISOLATION_STATE, drc_index, ISOLATE);
> +    if (rc)
> +        return -1;
> +
> +    rc = rtas_set_indicator(ALLOCATION_STATE, drc_index, ALLOC_UNUSABLE);
> +    if (rc) {
> +        rtas_set_indicator(ISOLATION_STATE, drc_index, UNISOLATE);
> +        return -1;
> +    }

Is there a better return value here that might be more descriptive than -1?


> +
> +    return 0;
> +}
> +
> +static int pseries_dlpar_init(void)
> +{
> +    spin_lock_init(&workarea_lock);
> +
> +    if (!machine_is(pseries))
> +        return 0;

What's the point of this if check if you return 0 either way?

> +
> +    return 0;
> +}
> +__initcall(pseries_dlpar_init);


> Index: powerpc/arch/powerpc/platforms/pseries/reconfig.c
> ===================================================================
> --- powerpc.orig/arch/powerpc/platforms/pseries/reconfig.c    2009-09-11
> 12:43:39.000000000 -0500
> +++ powerpc/arch/powerpc/platforms/pseries/reconfig.c    2009-09-11
> 12:51:52.000000000 -0500
> @@ -95,7 +95,7 @@
>     return parent;
> }
> 
> -static BLOCKING_NOTIFIER_HEAD(pSeries_reconfig_chain);
> +struct blocking_notifier_head pSeries_reconfig_chain =
> BLOCKING_NOTIFIER_INIT(pSeries_reconfig_chain);

Can't this just be?

BLOCKING_NOTIFIER_HEAD(pSeries_reconfig_chain);

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center



