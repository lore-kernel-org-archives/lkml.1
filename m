Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbXKXXRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbXKXXRg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 18:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXKXXRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 18:17:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33663 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbXKXXRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 18:17:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: nohz and strange sleep latencies
Date: Sun, 25 Nov 2007 00:35:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       kernel list <linux-kernel@vger.kernel.org>
References: <20071119203152.GA1772@elf.ucw.cz> <20071124224013.GB1544@elf.ucw.cz> <200711250029.55461.rjw@sisk.pl>
In-Reply-To: <200711250029.55461.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711250035.27400.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 25 of November 2007, Rafael J. Wysocki wrote:
> On Saturday, 24 of November 2007, Pavel Machek wrote:
> > Hi!
> > 
> > > > > but perhaps somehow we miss this fact and fail to turn off the lapic 
> > > > > clockevents drivers?
> > > > 
> > > > Ok, I guess I'm lost. If I offline second CPU, I immediately get
> > > > 1000Hz timer tick... is that expected?
> > > 
> > > Hmm. No. I have no idea why this is happening.
> > > 
> > > 34196 total events, 55.083 events/sec
> > > echo 0 >/sys/devices/system/cpu/cpu1/online
> > > 36073 total events, 54.679 events/sec
> > 
> > Digging into process_32|64.c...
> > 
> > 64:
> >         while (1) {
> >                 while (!need_resched()) {
> >                         void (*idle)(void);
> > 
> >                         if (__get_cpu_var(cpu_idle_state))
> >                                 __get_cpu_var(cpu_idle_state) = 0;
> > 
> >                         tick_nohz_stop_sched_tick();
> > 
> > 32:
> >         while (1) {
> >                 tick_nohz_stop_sched_tick();
> >                 while (!need_resched()) {
> >                         void (*idle)(void);
> > 
> >                         if (__get_cpu_var(cpu_idle_state))
> >                                 __get_cpu_var(cpu_idle_state) = 0;
> > 
> > ...eek? Which one is wrong?
> 
> Hm, it looks like you should have quoted more lines ...
> 
> In the second case (32), the tick_nohz_stop_sched_tick() seems to be
> redundant, so I bet it's this one.

OTOH, the ARM's process.c is more similar to process_32.c ...
