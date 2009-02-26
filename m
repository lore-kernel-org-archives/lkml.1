Return-Path: <linux-kernel-owner+w=401wt.eu-S1757492AbZBZDhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492AbZBZDhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZBZDhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:37:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbZBZDhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:37:45 -0500
Date: Wed, 25 Feb 2009 19:37:09 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during 
 suspend-resume
In-Reply-To: <d6200be20902251931lf563c2aw43d5266e9677e168@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0902251935190.3111@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200902250007.13069.rjw@sisk.pl>  <20090224230935.GA15165@elte.hu> <200902250029.16107.rjw@sisk.pl>  <d6200be20902251717r531c022bl4c25fcb902201188@mail.gmail.com>  <alpine.LFD.2.00.0902251724220.3111@localhost.localdomain>
  <d6200be20902251813o3ff4a065nb0a54321e27c512d@mail.gmail.com>  <alpine.LFD.2.00.0902251848120.3111@localhost.localdomain>  <20090226030050.GA3361@elte.hu> <d6200be20902251931lf563c2aw43d5266e9677e168@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Feb 2009, Arve Hjønnevåg wrote:
> 
> That would not work without wakelocks support, since the interrupt
> could occur after suspend_late which is the last chance for the driver
> to abort sleep. (The patch also breaks my current wakelock
> implementation since I use a suspend_late hook to abort sleep, but
> this should be easy to fix)

Since this must be some very deep arch-specific thing anyway, just make 
the dang thing be a "sysdev". At that point, its "suspend" function gets 
called way later (at which point CPU interrupts are off).

> > Hm, if that solves the problem then it would be nice to have a
> > new IRQF_NO_SUSPEND flag for it, in addition to IRQF_TIMER:
> 
> I think the right fix is for any interrupt that has IRQ_WAKEUP set to
> abort suspend if it is pending. I don't know if anyone relies on these
> interrupts being dropped now though.

We could add something like that, but quite frankly, I'd hate to unless 
there is some seriously common case. If it's just an oddball hacky special 
case, it's easier to just say "hey, you have that crazy system device, you 
handle it yourself".

		Linus
