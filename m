Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbZBZDvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbZBZDvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZBZDuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:50:55 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:4027 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbZBZDuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:50:55 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0902251935190.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <20090224230935.GA15165@elte.hu>
	 <200902250029.16107.rjw@sisk.pl>
	 <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>
	 <alpine.LFD.2.00.0902251724220.3111@localhost.localdomain>
	 <d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com>
	 <alpine.LFD.2.00.0902251848120.3111@localhost.localdomain>
	 <20090226030050.GA3361@elte.hu>
	 <d6200be20902251931lf563c2aw43d5266e9677e168@mail.gmail.com>
	 <alpine.LFD.2.00.0902251935190.3111@localhost.localdomain>
Date: Wed, 25 Feb 2009 19:50:52 -0800
Message-ID: <d6200be20902251950l34d5968q4b553ce8305ebd4b@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
	suspend-resume
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
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

On Wed, Feb 25, 2009 at 7:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 25 Feb 2009, Arve Hjønnevåg wrote:
>>
>> That would not work without wakelocks support, since the interrupt
>> could occur after suspend_late which is the last chance for the driver
>> to abort sleep. (The patch also breaks my current wakelock
>> implementation since I use a suspend_late hook to abort sleep, but
>> this should be easy to fix)
>
> Since this must be some very deep arch-specific thing anyway, just make
> the dang thing be a "sysdev". At that point, its "suspend" function gets
> called way later (at which point CPU interrupts are off).

Wakelocks can use a sysdev, but I don't think a keyboard driver should
be a sysdev.

>
>> > Hm, if that solves the problem then it would be nice to have a
>> > new IRQF_NO_SUSPEND flag for it, in addition to IRQF_TIMER:
>>
>> I think the right fix is for any interrupt that has IRQ_WAKEUP set to
>> abort suspend if it is pending. I don't know if anyone relies on these
>> interrupts being dropped now though.
>
> We could add something like that, but quite frankly, I'd hate to unless
> there is some seriously common case. If it's just an oddball hacky special
> case, it's easier to just say "hey, you have that crazy system device, you
> handle it yourself".

I don't think this is a oddball case. It is very common to connect
keys or keypads to gpios. If these keys are wakeup keys, it is not OK
to loose interrupts during the suspend phase.

-- 
Arve Hjønnevåg
