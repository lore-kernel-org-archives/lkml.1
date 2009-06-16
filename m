Return-Path: <linux-kernel-owner+w=401wt.eu-S1753432AbZFPIQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbZFPIQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbZFPIQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:16:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZFPIQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:16:24 -0400
Date: Tue, 16 Jun 2009 10:16:13 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Richard =?utf-8?Q?R=C3=B6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org,
       Kwangwoo Lee <kwangwoo.lee@gmail.com>
Subject: Re: [RESEND][PATCH] input: Added TSC2003
Message-ID: <20090616081613.GA3679@avionic-design.de>
References: <4A366439.70005@mocean-labs.com> <5d5443650906151110u3f7d9d1cm1990e767d29a45b6@mail.gmail.com> <4A36A1C2.2060805@mocean-labs.com> <20090616062044.GA20209@avionic-design.de> <4A374C50.1000508@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A374C50.1000508@mocean-labs.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1+jKWNWjsN8u1JmrvoRtGCM0MCjC6GtvKAQumz
 ve+ljjcPrBrakYMldtkBxDWReyaj3ftvYvKANUa6aNCM/oYACA
 Etqb4sCIEfkbK4FOQdMyw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cc'ing Kwangwoo Lee]

* Richard Röjfors wrote:
> On 09-06-16 08.20, Thierry Reding wrote:
> >>>>
> >>> Meaning? I think I2C transaction can sleep.
> >> Yes that's what it means, and that's bad in a HR timer callback.
> > 
> > Note that my patch to the tsc2007 to support the tsc2003 exactly fixes this
> > problem. It moves the actual I2C transfers into a workqueue, so no sleeping
> > functions are called from the hrtimer callback.
> 
> Ah good! The IRQ is disabled no sync too.
> We actually don't have the possibility to implement a pen down state callback,
> so I need to modify the code slightly to work even without one. (but not be
> as accurate when the callback is not available)
> 
> Your patch where it schedules work rather than calling the I2C function directly
> isn't in mainline.
> I saw a patch where you added the work scheduling, and a later patch where you
> fixed some spinlock stuff, have you resent the patch for the work scheduling?

I think there were still some issues with that patch. Kwangwoo Lee was the
last to comment. This is from the previous thread:

> On Tue, May 12, 2009 at 12:41 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Mon, May 11, 2009 at 08:38:09AM -0700, Dmitry Torokhov wrote:
> >> Hi,
> >> On Mon, May 11, 2009 at 08:44:00PM +0900, Kwangwoo Lee wrote:
> >> > From d5de0d22109de7564f9bf1df688acbe6b18f41db Mon Sep 17 00:00:00 2001
> >> > From: Kwangwoo Lee <kwangwoo.lee@gmail.com>
> >> > Date: Mon, 11 May 2009 20:05:50 +0900
> >> > Subject: [PATCH 2/2] Input: tsc2007: do I2C transfers in non-interrupt
> >> > context.
> >> >
> >> > This patch enhances pointer movements much smoother.
> >> > The original patch is written by Thierry.
> >> >
> >> > --- a/drivers/input/touchscreen/tsc2007.c
> >> > +++ b/drivers/input/touchscreen/tsc2007.c
> >> > @@ -70,6 +70,7 @@ struct ts_event {
> >> >  struct tsc2007 {
> >> >     struct input_dev        *input;
> >> >     char                    phys[32];
> >> > +   struct work_struct      work;
> >>
> >> Every time I see a work_struct in a driver and don't see
> >> cancel_work_sync() anywhere I know there are issues...
> >>
> 
> Thanks for your comment. I also missed that thing, sorry.
> 
> > Also, why do we need to chain irq->timer->work now? Surely we can bypass
> > the timer if we have to read in process context.
> 
> It's good point. I'll check again.
> Thanks.

So perhaps some more work is required to get this mainlined.

Thierry
