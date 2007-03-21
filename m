Return-Path: <linux-kernel-owner+w=401wt.eu-S933857AbXCUWVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857AbXCUWVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXCUWVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:21:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33179 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933857AbXCUWVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:21:30 -0400
Date: Wed, 21 Mar 2007 23:21:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Message-ID: <20070321222106.GF6057@elf.ucw.cz>
References: <200703211840.53242.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703211840.53242.maximlevitsky@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Starting with 2.6.21-rc1 suspend to ram and disk doesn't work anymore on my system.
> 
> I did a git-bisect and found that those commits break it:
> 
> e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c
> ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c
> 259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c
> 

(Yep, it was in my "to analyze" queue).

> I already reported about it, but now i know the reason why suspend breaks.
> 
> The problem is that both cpu_up/cpu_down were allowed to sleep until now, 
> and it did work because those functions could be called only in process context
> (the one that writes to /sys/devices/system/cpu/cpu*/online) or  idle thread  that does smp_init()).
> 
> But now they are called _after_ all tasks were suspended, so if cpu_down tries for example to take a lock
> that is taken by different process, it can't since the different proccess is frozen and can't release the lock.
> 

Thanks for detailed explanation.

...but, on my machine suspend works ok in -rc4. I'm not seeing this.

...by design, "frozen" tasks must not hold any locks. If frozen task
holds a lock, that's a bug.

> Or, it is also possible to revert this change.

Are you using xfs?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
