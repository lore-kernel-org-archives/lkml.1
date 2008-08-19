Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbYHSVMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbYHSVMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYHSVMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:12:13 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:22707 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753615AbYHSVML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:12:11 -0400
Date: Wed, 20 Aug 2008 01:12:10 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH 1/2] rtc: rtc-ds1374: fix 'no irq' case handling
Message-ID: <20080819211210.GA16708@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080812161733.GA32164@oksana.dev.rtsoft.ru> <9e4733910808191339s28a05f90pef57961e8d24fbdb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <9e4733910808191339s28a05f90pef57961e8d24fbdb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 04:39:09PM -0400, Jon Smirl wrote:
> On 8/12/08, Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> > On a PowerPC board with ds1374 RTC I'm getting this error while
> >  RTC tries to probe:
> >
> >  rtc-ds1374 0-0068: unable to request IRQ
> >
> >  This happens because I2C probing code (drivers/of/of_i2c.c) is
> >  specifying IRQ0 for 'no irq' case, which is correct.
> 
> Shouldn't this be
> 
> >  -       if (client->irq <= NO_IRQ)
> 
> instead of
> 
> >  -       if (client->irq < 0)
> >  +       if (client->irq <= 0)
> 
> Since NO_IRQ can vary by platform (0 or -1)?

First of all, NO_IRQ is not defined for every architecture. You can't
use it for truly cross-platform drivers.

Secondly, "<= 0" will work for both NO_IRQ == 0 and NO_IRQ == -1,
since client->irq is signed type.

As for false positives, I don't believe that there is any platform
that use IRQ0 for external interrupts.

[...]
> In of_i2c.c shouldn't there be an error check?
> 
> 		info.irq = irq_of_parse_and_map(node, 0);
> 
> if (info.irq < NO_IRQ) {report error; continue }

irq_of_parse_and_map() returns unsigned type, plus it is defined
only for PowerPC, and for PowerPC NO_IRQ is always 0.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
