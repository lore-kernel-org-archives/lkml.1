Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbYKENJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbYKENJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYKENJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:09:39 -0500
Received: from rv-out-0506.google.com ([209.85.198.224]:48523 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbYKENJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:09:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=elQq7CIIfde5gCmR/L6O0bP8o1INGDmoR8mjYb5Wk3ehv9FMEx2NuKG6+fsmdWJznG
         NEqq0zw1d9cDgnelexJ8mWjfoHrdBELSYO8hIEcX+pABN9X7LSn13EYilLr7YiaHRN6v
         k843Wh0HokM5ul93j4NDxOqGaO3E67Eyi1oWs=
Message-ID: <c4e36d110811050509t51719671saa7eb337fca39656@mail.gmail.com>
Date: Wed, 5 Nov 2008 14:09:36 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: sys_sched_yield keeps locked irq before call of schedule()
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20081105130113.GB29548@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110811050457m36346fe1m63ffbb143f684637@mail.gmail.com>
	 <20081105130113.GB29548@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/5 Ingo Molnar <mingo@elte.hu>:
>
> * Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>
>> Hi
>>
>> With recent 2.6.28-rc3 kernel I've noticed that schedule() is
>> sometime being called with locked IRQ
>>
>> Call Trace:
>>  [<ffffffff81334592>] _spin_lock_irq+0x92/0xa0
>>  [<ffffffff8133126b>] schedule+0x13b/0x4cb
>>  [<ffffffff81013c10>] ? native_sched_clock+0x70/0xa0
>>  [<ffffffff81040930>] ? sys_sched_yield+0x0/0x80
>>  [<ffffffff810409a5>] sys_sched_yield+0x75/0x80
>>  [<ffffffff8100c6bb>] system_call_fastpath+0x16/0x1b
>
> is this some special warning you added? The stock kernel certainly
> does not emit this warning.

Yes - it's my personal debug checker that tries to watch wether irq &
irqsafe are running in pair.
So it shows a warning if there is a call of spin_lock_irq and irq is
already dissabled.

>
>> Which is a result of the function sys_sched_yield() that calls
>> schedule() while it keeps irq.
>>
>> Is it correct to call the function schedule() which 'usually'
>> expects irq being unlocked and do some 'lenghty' operations (i.e.
>> debug statistics) which do not need to keep irq locked for such a
>> long time?
>
> the debug statistics are all fast and we disable interrupts straight
> away when entering the schedule().

IRQ is disabled with spin_lock_irc() inside schedule() and it looks
like there is quite a few lines above which receive 'extra' bonus with
being run without enabled irq, but as I said - I'm just checking
whether this is intentional or not.

Zdenek
