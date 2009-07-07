Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZGGGui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZGGGui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 02:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZGGGu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 02:50:28 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:49417 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZGGGu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 02:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pYMh2I/IvoV+vchJxk7m6QTA7JzuJBjLRXkpRTfwrcHI0i+bEpXauh6R3VXjgl+8oY
         UNfyMdghhQDi+jzZGCYfhNDDOjlWjDX0Ye3rlF28nKqxyljUXPNHI1cTecxOdFFUt1iV
         uEtErm9HNoF1UiHps9oZ7tpa1hPA3yVP+1LXs=
Date: Tue, 7 Jul 2009 08:50:14 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Joao Correia <joaomiguelcorreia@gmail.com>,
       Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 (
	possibly?caused by netem)
Message-ID: <20090707065014.GA3296@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <20090706163106.GA4559@ami.dom.local> <a5d9929e0907061023g4306d80ewfc8907653b949005@mail.gmail.com> <200907061926.43625.andres@anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907061926.43625.andres@anarazel.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 07:26:43PM +0200, Andres Freund wrote:
> On Monday 06 July 2009 19:23:18 Joao Correia wrote:
> > Hello
> >
> > Since i already had the kernel compiled and ready to boot when i read
> > this, i gave it a go anyway :-).
> >
> > I can reproduce the freeze with those 4 patches applied, so i can
> > confirm that its, at least, related to, or exposed by, those patches.
> > There must be something else too, or its just too much fuzziness, but
> > the freeze takes a bit more time (approximately five minutes, give or
> > take) compared to the instant freeze before, but its there with the
> > patches, and without them, no freeze.
> >
> > I assume there isnt a "safe" way to get them out of current .31-rc's,
> > right?
> `echo 0 > /proc/sys/kernel/timer_migration` should mitigate the problem.

I guess it should fix it entirely. Btw., here is a patch disabling the
timers' part, so to make it hrtimers only. Could you try?

Thanks,
Jarek P.
---

diff --git a/kernel/timer.c b/kernel/timer.c
index 0b36b9e..011429c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -634,7 +634,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	cpu = smp_processor_id();
 
-#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
+#if 0
 	if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
 		int preferred_cpu = get_nohz_load_balancer();
 
