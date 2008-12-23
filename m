Return-Path: <linux-kernel-owner+w=401wt.eu-S1755644AbYLWAr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbYLWAr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYLWArt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:47:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56585 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbYLWArs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:47:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: TSC not updating after resume: Bug or Feature?
Date: Tue, 23 Dec 2008 01:47:31 +0100
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>, dsaxena@plexity.net,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net> <200812182319.57235.rjw@sisk.pl> <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812211639210.3376@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812230147.32340.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 21 of December 2008, Thomas Gleixner wrote:
> On Thu, 18 Dec 2008, Rafael J. Wysocki wrote:
> 
> > On Thursday, 18 of December 2008, Ingo Molnar wrote:
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > Rafael, would something like this explain why we had to revert Shaggy's 
> > > > patch?
> > 
> > Well, I have yet to understand what the suspend-resume of the timekeeping code
> > actually does.
> 
> Thats rather simple:
> 
> suspend() saves the current time of the persistent clock (if
> available), forwards the timekeeping variables so they can be reused
> on resume, disables timekeeping activities and shuts down the clock
> events layer.
>  
> resume() estimates the suspend time via persistent clock (if
> available) and update xtime with the sleep length. After that it
> reactivates timekeeping and resumes clock events and high resolution
> timers.
> 
> So the sole purpose is:
>    - dis/enable timekeeping and clock event devices.
>    - keep track of the suspend time (if a persistent clock is available)
> 
> We reactivate clock event devices and hrtimers from timekeeping_resume
> because clock events depend on functional timekeeping.

Thanks for the explanation.  In fact, the reactivation of clock event devices
and hrtimers is the part I'm not familiar with.

> > The original description sounds worrisome to me, it looks like we've overlooked
> > something at least.
> 
> Care to explain ?

Well, the fact that in the resume code path the clocksource is only updated as
a result of executing pci_set_power_state() is worrisome.  I would be more
reliable to update it directly at one point.

Thanks,
Rafael
