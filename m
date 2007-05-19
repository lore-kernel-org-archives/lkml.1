Return-Path: <linux-kernel-owner+w=401wt.eu-S1764914AbXESWzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764914AbXESWzE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761737AbXESWyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:54:55 -0400
Received: from neon.samage.net ([85.17.153.66]:42018 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761575AbXESWyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:54:54 -0400
Message-ID: <2318.81.207.0.53.1179615289.squirrel@secure.samage.net>
In-Reply-To: <464F409D.9030408@gmail.com>
References: <20070510072005.GA27316@linux-sh.org>
    <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com>
    <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com>
    <20070511005217.GA23186@li <464B3505.20004@gmail.com>
    <1800.81.207.0.53.1179590050.squirrel@secure.samage.net>
    <464F409D.9030408@gmail.com>
Date: Sun, 20 May 2007 00:54:49 +0200 (CEST)
Subject: Re: [PATCH] libata: implement ata_wait_after_reset()
From: "Indan Zupancic" <indan@nul.nu>
To: "Tejun Heo" <htejun@gmail.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       garyhade@us.ibm.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 3b058867a8808b2a73617ccb478d635a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 20:23, Tejun Heo wrote:
> Indan Zupancic wrote:
>> Resume takes now ten seconds or more, while it used to take only a few seconds,
>> what changed? A few kernel versions ago (2.6.21-rc or so?) it retried in 5 seconds
>> instead of 10, but even that is too long.
>
> There are two different things at play here...
>
> 1. We dropped libata specific suspend/resume implementation in favor of
> sd driven one.  Unfortunately, the new implementation currently can't do
> background spinup, so that's probably why you can feel the delay.  We
> need to figure out how to do background spinup with the new implementation.

What are the advantages of that, except slower resume? ;-)

> 2. To make reset finish in defined time, each reset try now has defined
> deadlines.  I was trying to be conservative so I chose 10sec for the
> first try.

Right. So to me it seems that failed, because the undefined reset time is just
replaced with a fixed ad hoc sleep, which is longer than any undefined reset
mechanism. So where did the advantage go? Better to go back to how it was,
is my impression. Or make that deadline 10 seconds and after that give up,
instead of the other way round. Or just move to async reset.

>  It's driven by timing table near the top of libata-eh.c, so
> adjusting the table is easy and maybe we can be a bit more aggressive
> with the first two tries.  But if we solve #1, this shouldn't matter too
> much.

#2 seems totally unrelated to #1, as #1 is about spinup, and #2 about reset.
Only relation is that #2 slows down #1 because #1 needs to wait on #2.


>> Maybe a silly question, but why do we wait for the harddisk to show up? Maybe that
>> makes a little bit of sense at bootup, but for resume from ram, where nothing is
>> supposed to have changed, it seems a bit strange. Why not wait when something tries
>> to access the harddisk or something?
>
> I hope it's explained now.

Almost. Explained is why we wait on the disk, but that's only the sd_resume part.
It's still unclear why resume must wait till the reset is done.


>> I wonder if sil_pci_device_resume() and sd_resume() know about each other...
>> I'll disable sd_resume() and see how that goes.
>
> Yeap, that should work.  In most configurations, devices spin up
> immediately after power is restored.  sd_resume() just waits for the
> device to be revalidated in such cases.

And it kicks the disk into action. Why? Only thing it does is sending a START_STOP
command. I assume that causes the disk to spin up. But for e.g. laptopmode I can
imagine that's quite annoying. I think sd_resume() is totally unnecessary and can
be removed, because it seems wrong to always force the harddisk to spin up,
background spin up or not.

Greetings,

Indan


