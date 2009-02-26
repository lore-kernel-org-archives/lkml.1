Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbZBZWag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbZBZWag (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZBZWa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:30:28 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:40072 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZBZWa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:30:27 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0902261404580.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902261050.50531.rjw@sisk.pl>
	 <d6200be20902261234i5a3896fo78a7f56d16a247c7@mail.gmail.com>
	 <200902262258.55835.rjw@sisk.pl>
	 <alpine.LFD.2.00.0902261404580.3111@localhost.localdomain>
Date: Thu, 26 Feb 2009 14:30:22 -0800
Message-ID: <d6200be20902261430w19ea3e6fye014f8443d9ab5ca@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
	suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
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

On Thu, Feb 26, 2009 at 2:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 26 Feb 2009, Rafael J. Wysocki wrote:
>>
>> Well, how exactly the $subject patch does cause this problem to happen?
>
> Rafael, the problem is that if an interrupt happens while it's disabled -
> but before the CPU has actually turned all interrupts off - the CPU will
> ACK the interrupt (but just set a flag for it being PENDING), so now the
> chipset logic around it will not see it as pending any more, so now the
> chipset won't auto-wake the CPU immediately (or more likely, it won't
> even suspend it).
>
> It's trivial to fix multiple ways, so I wouldn't worry. The most trivial
> way is to just have some sysdev drievr code simply do something like
>
>  static int sysdev_suspend()
>  {
>        for_each_irq(irq,desc) {
>                if (!(desc->flags & IRQF_WAKE))
>                        continue;
>                if (desc->flags & IRQ_PENDING)
>                        return -EBUSY;
>        }
>        return 0;
>  }
>
> and that should automatically mean that if any irq is pending, the suspend
> will fail and we'll immediately wake up again.
>
> It looks trivial, and I don't understand why Arve can't just do the sysdev
> thing.

I can. My point is that the patch breaks our existing code. If anyone
else uses edge triggered wakeup interrupt it may break from them as
well. The main question if this should be fixed separately for every
platform that needs it, or if pending wakeup interrupts should always
abort sleep.

-- 
Arve Hjønnevåg
