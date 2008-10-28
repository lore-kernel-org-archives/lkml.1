Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbYJ1Qal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbYJ1Qal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYJ1Qac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:30:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:34695 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYJ1Qab convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:30:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,500,1220252400"; 
   d="scan'208";a="66469194"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Disable ioat channel only on platforms where ile driver can load
Date: Tue, 28 Oct 2008 16:30:26 -0000
Message-ID: <7F38996F7185A24AB9071ED4950AD8C102253087@swsmsx413.ger.corp.intel.com>
In-Reply-To: <f12847240810270941v68a1cf7aqfa7db14fceb61fe5@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Disable ioat channel only on platforms where ile driver can load
Thread-Index: Ack4UvQ6kg+Yg3VDRMelcuNwdlzzAQAwhIrQ
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com> <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com> <20081011083347.GA31918@elte.hu> <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain> <48FE07AE.4010203@linux.intel.com> <7E82351C108FA840AB1866AC776AEC4637CD27F3@orsmsx505.amr.corp.intel.com> <48FED3FA.6040703@linux.intel.com> <20081022233451.GA28775@linux-os.sc.intel.com> <f12847240810270941v68a1cf7aqfa7db14fceb61fe5@mail.gmail.com>
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>
Cc: <ak@linux.intel.com>, <lenb@kernel.org>, <mingo@elte.hu>,
       <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Henroid, Andrew D" <andrew.d.henroid@intel.com>,
       <torvalds@linux-foundation.org>, <tglx@linutronix.de>, <hpa@zytor.com>
X-OriginalArrivalTime: 28 Oct 2008 16:30:29.0549 (UTC) FILETIME=[7D9305D0:01C9391A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ---------- Original message ----------
> From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> Date: Oct 23, 2008 12:34 AM
> Subject: [PATCH] Disable ioat channel only on platforms where ile
> driver can load
> To: Andi Kleen <ak@linux.intel.com>
> Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>, Len Brown
> <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
> "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Linux
> Kernel Mailing List <linux-kernel@vger.kernel.org>, "Henroid, Andrew
> D" <andrew.d.henroid@intel.com>, Linus Torvalds
> <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>,
> "H. Peter Anvin" <hpa@zytor.com>
> 
> 
> On Wed, Oct 22, 2008 at 12:19:22AM -0700, Andi Kleen wrote:
>> Pallipadi, Venkatesh wrote:
>>> 
>>>>> +#if CONFIG_I7300_IDLE_IOAT_CHANNEL
>>>>> +     device->common.chancnt--;
>>>>> +#endif
>>>> I still think this lone decrement looks fishy. Can there please be
>>>> some explanation how it exactly relates to the i7300 idle driver,
>>>> where the matching increment is, etc.?
>>> 
>>> No. This is not a increment/decrement thing. It is basically
>>> telling other Users of IOAT that they have one IOAT channel less
>>> that they can use. 
>>> The last IOAT channel is used by i7300 idle driver to get the
>>> throttling to work.
>> 
>> Ok then it should be made conditional on the i7300 actually be
>> available 
>> in the system?  It looks like you do it always no matter what
>> chipset is in there. 
> 
> Does the patch below look OK?
> 
> Thanks,
> Venki
> 
> Based on input from Andi Kleen:
> share the platform detection code with ioat_dma and disable the
> channel in 
> dma engine only for specific platforms.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> ---

Hi Venki,

Why for your purposes don't you use dmaengine to request an ioatdma
channel from ioatdma driver?
This way sharing of this channel with other clients 
(like TCP which uses ioatdma for receive offloading) would be possible .
In the previous approach your change was not acceptable from ioatdma
perspective 
(for IOAT_VER_3_0 there are 8 ioat devices, each with single channel
 - in this case you would take away all 8 channels and make ioat ver.3.0
totally disfunctional).
Even with this approach (assuming that it would affect IOAT_VER_1_2
only) 
you reserve one channel of four statically for your purposes only,
leaving for TCP receive offloading 75% of ioatdma resources and thus
affecting its efficiency.

Dan, what do you think?

BTW, could you please next time in case of ioat/dmaengine changes
include Dan and me in the list?

Thanks,
Maciej


> Index: linux-acpi-2.6/drivers/dma/ioat_dma.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/dma/ioat_dma.c  2008-10-22
> 11:42:04.000000000 -0700
> +++ linux-acpi-2.6/drivers/dma/ioat_dma.c       2008-10-22
> 11:42:46.000000000 -0700
> @@ -33,6 +33,7 @@
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/workqueue.h>
> +#include <linux/i7300_idle.h>
>  #include "ioatdma.h"
>  #include "ioatdma_registers.h"
>  #include "ioatdma_hw.h"
> @@ -172,7 +173,9 @@ static int ioat_dma_enumerate_channels(s
>        xfercap = (xfercap_scale == 0 ? -1 : (1UL << xfercap_scale));
> 
>  #if CONFIG_I7300_IDLE_IOAT_CHANNEL
> -       device->common.chancnt--;
> +       if (i7300_idle_platform_probe(NULL, NULL) == 0) {
> +               device->common.chancnt--;
> +       }
>  #endif
>        for (i = 0; i < device->common.chancnt; i++) {
>                ioat_chan = kzalloc(sizeof(*ioat_chan), GFP_KERNEL);

