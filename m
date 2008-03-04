Return-Path: <linux-kernel-owner+w=401wt.eu-S932569AbYCDTmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbYCDTmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 14:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760417AbYCDTmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 14:42:21 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:49884 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760100AbYCDTmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 14:42:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=D1I7x+jDJigc9BZZCajzcqtjguAT2MWNh2B9NW2q2vrdN1h+672/ZphIMKYSpQHyDmn/0k6+BKUCLLFZEBIpD+JT2H2Qhk3pDoqJEsQQp3lB4+Auf3lHyEm7+nsWNTNxwgrPdWlXKZSscAROqng7x7IAzqmO5a4QmkOjjRVKcSo=
Message-ID: <3efb10970803041142l4a03dbb9uf11651d4cc7dde96@mail.gmail.com>
Date: Tue, 4 Mar 2008 20:42:17 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] atmel_tc clocksource/clockevent code
Cc: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       "David Brownell" <david-b@pacbell.net>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Nicolas Ferre" <nicolas.ferre@rfo.atmel.com>,
       "Andrew Victor" <linux@maxim.org.za>,
       "john stultz" <johnstul@us.ibm.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1204636061-6275-2-git-send-email-hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204636061-6275-1-git-send-email-hskinnemoen@atmel.com>
	 <1204636061-6275-2-git-send-email-hskinnemoen@atmel.com>
X-Google-Sender-Auth: 5c65f1c11b5f33da
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

Good work on improving this patch. I am very happy with the accurate
clocksource devices, I use the patches from David for quite some time
now.

But, I noticed this comment in the patch:

>  +/* For now, we always use the 32K clock ... this optimizes for NO_HZ,
>  + * because using one of the divided clocks would usually mean the
>  + * tick rate can never be less than several dozen Hz (vs 0.5 Hz).
>  + *
>  + * A divided clock could be good for high resolution timers, since
>  + * 30.5 usec resolution can seem "low".

I want to comment on that.
I noticed that on rm9200 the timer interrupt handler itself can cost
about 50us to more than 100usec in itself (measured through ETM
trace), combined with a worst case interrupt latency of about 75us.
So, a higher resolution than 30usec is useless on these cores, and
setting timers on a frequency that high will just choke the processor
in only handling timers...

To prevent applications to start timers too fast after each other, it
is even useful to limit the granularity of these timers, and to get
them aligned so that they can be handled on just 1 interrupt. (Hmm,
this sounds like the behavior of a ticking kernel ;-))

This is the reason why I stopped using the High-resolution timer
framework on these cores. It just overloads the CPU too much when
several applications use independent timers that are not in sync with
each other. A ticking kernel is therefor more CPU-load friendly...


Kind Regards,

Remy
