Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbXCAOJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbXCAOJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbXCAOJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:09:59 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:39171 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbXCAOJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:09:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SKe4j+zbXV+xVOqueo1RJ5Xasy8ZTcYUnLYUsWVtXPLKFJlf3Pp8/bR73z5vlJ1gElWAK5yQKWccSd1XvXzG7/rMPMcJLiDThDV9F5q4VVXL/mkfP0TLCjUzhFrX9YSJPBl/FJVl1e6g26TMADSz0eTG2rSn+BcndtI0WWm+/A4=
Message-ID: <8bd0f97a0703010609x6e745d8cv76d033a91822d568@mail.gmail.com>
Date: Thu, 1 Mar 2007 09:09:57 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, "Wu, Bryan" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, a.zummo@towertech.it,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 5/5] Blackfin: on-chip RTC controller driver
In-Reply-To: <20070301091408.GA4324@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172722546.5264.79.camel@roc-desktop>
	 <20070301091408.GA4324@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Thu, Mar 01, 2007 at 12:15:46PM +0800, Wu, Bryan wrote:
> > +#define stamp(fmt, args...) pr_debug("%s:%i: " fmt "\n", __FUNCTION__, __LINE__, ## args)
> > +#define stampit() stamp("here i am")
>
> Are these really necessary for the final driver? It's littered all over
> the place, and presumably the driver should be functional enough to not
> need this sort of debugging instrumentation.

is there really such a thing as a "final driver" ? :)

keeping the stampit()'s in place means i dont have to re-add and
re-delete them every time some one reports a bug ...

> > +static void rtc_bfin_sync_pending(void)
> > +{
> > +     stampit();
> > +     while (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_COMPLETE)) {
> > +             if (!(bfin_read_RTC_ISTAT() & RTC_ISTAT_WRITE_PENDING))
> > +                     break;
> > +     }
> > +     bfin_write_RTC_ISTAT(RTC_ISTAT_WRITE_COMPLETE);
> > +}
>
> No timeout? (and superfluous braces)

the ISTAT is reset every clock tick by the hardware itself ... so the
timeout is implicit

> > +     case RTC_PIE_ON:
> > +             stampit();
> > +             spin_lock_irq(&rtc->lock);
> > +             rtc_bfin_sync_pending();
>
> And it's also called under a spinlock each time.. this is a disaster
> waiting to happen.

i noted the logic behind this decision in the comments in the driver
... i too think it sucks, but i cant fathom a better idea so i'm
certainly open to suggestions :)
-mike
