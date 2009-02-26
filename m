Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbZBZDcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbZBZDcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZBZDby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:31:54 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:44842 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZBZDby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:31:54 -0500
MIME-Version: 1.0
In-Reply-To: <20090226030050.GA3361@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <200902250007.13069.rjw@sisk.pl>
	 <20090224230935.GA15165@elte.hu> <200902250029.16107.rjw@sisk.pl>
	 <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
	 <alpine.LFD.2.00.0902251724220.3111@localhost.localdomain>
	 <d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com>
	 <alpine.LFD.2.00.0902251848120.3111@localhost.localdomain>
	 <20090226030050.GA3361@elte.hu>
Date: Wed, 25 Feb 2009 19:31:51 -0800
Message-ID: <d6200be20902251931lf563c2aw43d5266e9677e168@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
	suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 7:00 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>>
>>
>> On Wed, 25 Feb 2009, Arve Hjønnevåg wrote:
>> >
>> > On the msm platform the keyboard driver currently leave the interrupts
>> > enabled when suspended. If the interrupt handler is called, we use a
>> > wakelock to abort suspend (without wakelocks you would need to set a
>> > flag and abort in suspend_late instead). If the interrupt occurs after
>> > local_irq_disable, it will still be pending when we get to the suspend
>> > enter hook and suspend will be aborted there.
>> >
>> > As far as I can tell, this change breaks this. If you press a key at
>> > the right time, it will be ignored.
>>
>> Is the irq on a private non-shared interrupt line? If so, you
>> could just mark it as IRQF_TIMER, and the irq disable logic
>> won't touch it.

That would not work without wakelocks support, since the interrupt
could occur after suspend_late which is the last chance for the driver
to abort sleep. (The patch also breaks my current wakelock
implementation since I use a suspend_late hook to abort sleep, but
this should be easy to fix)

> Hm, if that solves the problem then it would be nice to have a
> new IRQF_NO_SUSPEND flag for it, in addition to IRQF_TIMER:

I think the right fix is for any interrupt that has IRQ_WAKEUP set to
abort suspend if it is pending. I don't know if anyone relies on these
interrupts being dropped now though.

-- 
Arve Hjønnevåg
