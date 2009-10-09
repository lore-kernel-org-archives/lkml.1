Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbZJIJKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbZJIJKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbZJIJKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:10:54 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63970 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbZJIJKx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:10:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SnUYI3YXBQEbYjJ64Z06ogifikaCxNVqzvmz9heqjEGF2FgahZLyyD5bTZ9yblsX+R
         pBIaehuvhS0RrAMDoAVO31waDSMiiX7ff7eO5LMbZdIH14pF0X6HOEEd+GjL7LG+d0C0
         R8sFcnrnYZ7hFglnvmHZSEAxz/5XtRS6hwUxE=
MIME-Version: 1.0
In-Reply-To: <129600E5E5FB004392DDC3FB599660D7B78C93C0@irsmsx504.ger.corp.intel.com>
References: <1253630313-20225-1-git-send-email-linus.walleij@stericsson.com>
	 <129600E5E5FB004392DDC3FB599660D7B78C93C0@irsmsx504.ger.corp.intel.com>
Date: Fri, 9 Oct 2009 11:10:16 +0200
Message-ID: <63386a3d0910090210u19e20035l9e88bfc806022f4@mail.gmail.com>
Subject: Re: [PATCH 1/2] Add COH 901 318 DMA block driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Then a quick comment in addition to the COH 901 318 v2...

2009/9/30 Sosnowski, Maciej <maciej.sosnowski@intel.com>:

>> +     coh901318_stop(chan);
>> +
>> +     spin_lock_irqsave(&cohc->lock, flags);
>> +
>> +     /* Clear any pending BE or TC interrupt */
>> +     if (cohc->id < 32) {
>> +             writel(1 << cohc->id, virtbase + COH901318_BE_INT_CLEAR1);
>> +             writel(1 << cohc->id, virtbase + COH901318_TC_INT_CLEAR1);
>> +     } else {
>> +             writel(1 << (cohc->id - 32), virtbase +
>> +                    COH901318_BE_INT_CLEAR2);
>> +             writel(1 << (cohc->id - 32), virtbase +
>> +                    COH901318_TC_INT_CLEAR2);
>> +     }
>> +
>> +     enable_powersave(cohc);
>
> enable_powersave() has been called in coh901318_stop() already

Yes, however an IRQ can come in between coh901318_stop() and
spin_lock_irqsave(), disabling powersave. So to avoid a possible race,
we enable it again. We cannot move coh901318_stop() after the spinlock
either, because the coh901318_stop() use the same spinlock, and then it
deadlocks. And I cannot require the lock to be held while calling
coh901318_stop() because it is an exported symbol.

Linus Walleij
