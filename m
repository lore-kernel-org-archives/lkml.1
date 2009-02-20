Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZBTXHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZBTXHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbZBTXHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:07:34 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:43587 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZBTXHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:07:33 -0500
From: Oliver Neukum <oliver@neukum.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFD] Automatic suspend
Date: Sat, 21 Feb 2009 00:12:01 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
References: <200902192215.18365.rjw@sisk.pl> <d6200be20902200326g6caa211ai388d4aa9fc270a28@mail.gmail.com> <200902201657.01145.rjw@sisk.pl>
In-Reply-To: <200902201657.01145.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902210012.08088.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 20 Februar 2009 16:56:59 schrieb Rafael J. Wysocki:

> OK, so what about the following approach:
>
> * Keep the decision making logic (power manager etc.) in user space. 
> Reasons: - It may be arbitrarily complicated

Therefore something functionally equivalent to wakelocks
is needed.

>   - It may include such things as s2ram quirks or hal quirks needed for
> some graphics adapters

If you can't do that I'd say the situation is hopeless.
You need full support for all devices including graphics
cards.

> * Have a per-process (per-task or per-thread group, but the former would be
>   easier IMO) "I_do_not_want_automatic_suspend_to_occur" flag.

I think you got the default logic inverted.

> * Add a new callback, say ->acknowledge(), to the set of each driver's PM
>   operations, that will be called to check if the driver has anything
> against automatic suspend (true - suspend can happen right now, false -
> suspend can't happen).
>
> * Introduce /sys/power/sleep that will work like /sys/power/state, but:
>   - First, it will call ->acknowledge() for each driver (via bus types) to
>     check if any of them wants to postpone the suspend (this will prevent
> tasks from being frozen unnecessarily if it is known in advance that the
> suspend should not happen at the moment).

Ideally most devices should be already suspended, so I am not
sure a new callback is really needed. In any cases it is an optimization
only.

>   - Next, it will check the "I_do_not_want_automatic_suspend_to_occur" flag
>     of each process and the suspend will be aborted if it is true for any
> of them (quite frankly, I think that should be integrated with the freezer,
> in particular the tasks that have TIF_FREEZE set shouldn't be able to set
> this flag and it should be checked in the freezer loop for every task with
> TIF_FREEZE unset).

Why in this order?

>   - Next, it will proceed with suspending just like /sys/power/state does
> (the drivers that missed the opportunity to abort the suspend by returning
> 'false' from ->acknowledge() can still abort the suspend by failing their
> ->suspend() routines).
>
> Then, the decision making logic will be able to use /sys/power/sleep
> whenever it wishes to and the kernel will be able to refuse to suspend if
> it's not desirable at the moment.

I think everything that uses a "trigger" logic from user space is not
a good idea. This will necessary introduce a race between the decision
and the execution during which circumstances can change.

So it seems to me that an allow/disallow system from user space
would be better.

	Regards
		Oliver

