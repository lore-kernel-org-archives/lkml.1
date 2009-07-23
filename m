Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZGWUan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZGWUan (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 16:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbZGWUan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 16:30:43 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:34534 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZGWUam convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 16:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w0m/4ZWzCwtK0CBObde+1tvuQzIvlDfUw4rc+zy6/BmZjSrqw0Dp+6wQZ8ZgK56fHO
         r1Vb3Txwt64KKjNrbZqO62YuJOF6gvyr0e4mlkVeAOxmcsVBqyWqam6UoJAPjW42Ekug
         xNrKo8KhbITSKVpncFyErHCg/YSbRR41mnrwA=
MIME-Version: 1.0
In-Reply-To: <4A68709E.5060207@csr.com>
References: <1248128808-2241-1-git-send-email-linus.walleij@stericsson.com>
	 <4A6701E3.3000204@csr.com>
	 <63386a3d0907221533u6ab2738dpcb4484595ae757b0@mail.gmail.com>
	 <4A68709E.5060207@csr.com>
Date: Thu, 23 Jul 2009 22:30:40 +0200
Message-ID: <63386a3d0907231330h8695afdsdf7d642d3765b56c@mail.gmail.com>
Subject: Re: [PATCH 1/2] MMC Agressive clocking framework v5
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pierre Ossman <pierre@ossman.eu>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/23 David Vrabel <david.vrabel@csr.com>:
> Linus Walleij wrote:
>> 2009/7/22 David Vrabel <david.vrabel@csr.com>:

>>> 1. With some controllers (e.g., PXA270 I think) turning the clock on and
>>> off is slow.  This means if you're doing back-to-back commands you
>>> should leave the clock on for best performance.
>>
>> OK, when I've been testing this using the default workqueue and
>> schedule_work() covered these cases. Back-on-back commands
>> seemingly doesn't allow the timeout work to schedule, but I might be
>> overseeing the case of several CPU:s there though :-/
>
> Ok, with a configurable timeout your scheme is fine.  The timeout can be
> extended beyond 8 SDCLKs if this is beneficial.

Yep I have that in debugfs, but when I look at Adrians code I see he instead
added a disable delay field to the host struct so let's use his patch
instead then.

> I'm not sure what the best way to add this would be.  You could:
>
> 1. Have a special clock frequency to mean idle and fix up all existing
> controller drivers to interpret this as 400 kHz unless you know the
> controller handles SDIO interrupts with no SDCLK.
>
> or:
>
> 2. Add an additional controller method (set_bus_state?) and only provide
> this on controller drivers you're interested in.

As discussed with Adrian this is what his patch does (adding a new host->ops
function for enable/disable) so let's use his patch.

>>> 3. Regardless of point 1 above.  Using a workqueue item in this way
>>> seems overkill.  Consider using a timer and simply calling mod_timer()
>>> at the start of every command.  When the timer expires, idle the clock.
>>>  You will probably need a "command in progress" bit to ensure you don't
>>> idle the clock if the timer expires in the middle of a command.
>>
>> I would agree if I created a new workqueue, but the timeout of this
>> particular workqueue is unimportant and that's why I'm using the
>> global workqueue and just schedule_work(). This means no extra
>> overhead, no extra thread and basically does the exact same thing.
>
> You currently queue a work item and wake the workqueue every command.
> This is considerably more overhead (when doing back-to-back commands)
> than simply calling mod_timer().
>
> You also potentially delay for a considerable amount of time in the work
> item.

Yep that's the idea almost... But let's raise the timer debate again with
Adrian's patch instead :-)

Linus Walleij
