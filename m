Return-Path: <linux-kernel-owner+w=401wt.eu-S965095AbXCKTgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095AbXCKTgL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 15:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965083AbXCKTgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 15:36:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40761 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965095AbXCKTgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 15:36:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Milan Broz <mbroz@redhat.com>
Subject: Re: SwSusp to disk doesn't work - Try 2
Date: Sun, 11 Mar 2007 20:38:51 +0100
User-Agent: KMail/1.9.5
Cc: Thomas Meyer <thomas@m3y3r.de>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>
References: <45F44599.3060508@m3y3r.de> <200703111926.20183.rjw@sisk.pl> <45F452A2.2050009@redhat.com>
In-Reply-To: <45F452A2.2050009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703112038.52375.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 March 2007 20:04, Milan Broz wrote:
> Rafael J. Wysocki napsal(a):
> > On Sunday, 11 March 2007 19:08, Thomas Meyer wrote:
> >> Suspend to disk doesn't work on my laptop.
> >>
> >> The suspend seems to hang while enabling the non-boot cpus again.
> >>
> >> with platform = "test" and state = "disk" i get this:
> 
> >> Enabling non-boot CPUs ...
> ...
> > 
> > Could you please put some printk()s in kernel/cpu.c:_cpu_up() to see where
> > it gets stuck?  I bet one of the notifiers goes to sleep (cpufreq, maybe).
> 
> Hi,
> I see the same problem - 2.6.21-rc3 with NO_HZ set (tickless), 

Ah, NO_HZ.  Thomas Gleixner's address added to the Cc list.

> short printk trace 
> 
> enable_nonboot_cpus
>  _cpu_up
>   raw_notifier_callchain (CPU_UP_PREPARE)
>     ...
>     update_sched_domains
>      detach_destroy_domains
>        [waits here] --> synchronize_sched (==synchronize_rcu)

Well, I think the call to wait_for_completion() does not return, probably
because the task supposed to complete the completion is frozen at this
point.  Can you please try to confirm that it gets stuck on
wait_for_completion() in synchronize_rcu()?

Rafael
