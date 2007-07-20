Return-Path: <linux-kernel-owner+w=401wt.eu-S1761024AbXGTMui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024AbXGTMui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbXGTMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:50:31 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:49129 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbXGTMua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eNx4ixAoEIOn6JiEWNWMy9oblG33hBfARsQW9KtHQyZrOvDr2WZXJpMGsD6L/GF5Sfon4L49I8h/VyRg7P8kAwfHSR+tAOtLlN3d4OdHa4ZRs65eVxLqRitTlJs0pU33HLOSHQzqgIjF+EjT3PXrLCJtNU7wRotOx2MuziYVC74=
Message-ID: <d120d5000707200550q47148983w6b525f95fe67cd1f@mail.gmail.com>
Date: Fri, 20 Jul 2007 08:50:29 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH for review] [12/48] x86_64: use the global PIT lock
Cc: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <200707201025.12915.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070719348.540885000@suse.de> <200707192152.03321.ak@suse.de>
	 <200707200024.21467.dtor@insightbb.com>
	 <200707201025.12915.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Andi Kleen <ak@suse.de> wrote:
>
> > +static DEFINE_SPINLOCK(i8253_lock);
> > +
> > static __init int add_pcspkr(void)
> > {
> > struct platform_device *pd;
> > @@ -1501,9 +1503,14 @@ static __init int add_pcspkr(void)
> > if (!pd)
> > return -ENOMEM;
> >
> > +pd->dev.platform_data = &i8253_lock;
>
> That seems pretty ugly to pass spinlocks around in void * pointers.

That spinlock _is_ platform data. We could define

struct pcspkr_platform_data {
        spinlock_t *lock;
};

and pass around this as the rest of platform code does but then we'd
need a header file and it would add a level of indirection but if you
like this better I can change it. Otherwise spinlock is another data
structure and we pass them around all teh time.

> Also
> out of general memory bloat reasons i don't like allocating big data structures
> just for this.
>

I am not sure where you see new data structure allocation... If you
look at your box you should see that /sys/bus/platform/devices/pcspkr
device is already there. We already create it so that pcspkr driver
can bind to it.

> Wouldn't  it be better to just define i8253_lock weakly in the pcspkr code and let
> the architecture override it?

Yes, it probably is btetter.

>
> > Index: work/arch/x86_64/kernel/time.c
> > ===================================================================
> > --- work.orig/arch/x86_64/kernel/time.c
> > +++ work/arch/x86_64/kernel/time.c
> > @@ -23,6 +23,7 @@
> > #include <linux/module.h>
> > #include <linux/device.h>
> > #include <linux/sysdev.h>
> > +#include <linux/platform_device.h>
> > #include <linux/bcd.h>
> > #include <linux/notifier.h>
> > #include <linux/cpu.h>
> > @@ -185,7 +186,7 @@ void main_timer_handler(void)
> > set_rtc_mmss(xtime.tv_sec);
> > rtc_update = xtime.tv_sec + 660;
> > }
> > -
> > +
> > write_sequnlock(&xtime_lock);
> > }
>
> No random white space changes in patches, multiple occurrences ?!?
>

By bad, sorry.

-- 
Dmitry
