Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbXCUWgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbXCUWgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933944AbXCUWgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:36:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60270 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933895AbXCUWgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:36:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Wed, 21 Mar 2007 23:39:02 +0100
User-Agent: KMail/1.9.5
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org
References: <200703211840.53242.maximlevitsky@gmail.com> <20070321222106.GF6057@elf.ucw.cz>
In-Reply-To: <20070321222106.GF6057@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703212339.02972.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 21 March 2007 23:21, Pavel Machek wrote:
> Hi!
> 
> > Starting with 2.6.21-rc1 suspend to ram and disk doesn't work anymore on my system.
> > 
> > I did a git-bisect and found that those commits break it:
> > 
> > e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c
> > ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c
> > 259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c
> > 
> 
> (Yep, it was in my "to analyze" queue).
> 
> > I already reported about it, but now i know the reason why suspend breaks.
> > 
> > The problem is that both cpu_up/cpu_down were allowed to sleep until now, 
> > and it did work because those functions could be called only in process context
> > (the one that writes to /sys/devices/system/cpu/cpu*/online) or  idle thread  that does smp_init()).
> > 
> > But now they are called _after_ all tasks were suspended, so if cpu_down tries for example to take a lock
> > that is taken by different process, it can't since the different proccess is frozen and can't release the lock.
> > 
> 
> Thanks for detailed explanation.
> 
> ...but, on my machine suspend works ok in -rc4. I'm not seeing this.
> 
> ...by design, "frozen" tasks must not hold any locks. If frozen task
> holds a lock, that's a bug.
> 
> > Or, it is also possible to revert this change.
> 
> Are you using xfs?

Well, this is the only case that can trigger it.  There are no other freezable
workqueues.

Greetings,
Rafael
