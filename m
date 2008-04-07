Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYDGW4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYDGW4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYDGW41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:56:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58283 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbYDGW40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:56:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Date: Tue, 8 Apr 2008 00:56:32 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <200804080029.31102.rjw@sisk.pl> <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804080056.33009.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of April 2008, Jiri Kosina wrote:
> On Tue, 8 Apr 2008, Rafael J. Wysocki wrote:
> 
> > > The mce resume is a sysdev.
> > > sysdevs were always supposed to run completely with interrupts off. If they 
> > > don't anymore that's some kind of higher level resume code bug which you need 
> > > to fix there, not hack around in the low level code.
> > They are executed with interrupts disabled, on one CPU.
> 
> So, any idea why mce_resume() -> mce_init() -> debug_smp_processor_id() 
> triggers the warning? Apparently preempt_count is zero, irqs_disabled() 
> returns false, and cpumask_of_cpu() is not equal to current->cpus_allowed.
> 
> So there clearly is a bug somewhere.

Yes, there is.  Still, I wonder why doesn't everyone see it.
 
> > > Obviously turning on preemption anywhere around the machine check is
> > > fatal because it touches CPU state and if you reschedule you could
> > > switch to another CPU and change or access the wrong CPU's state.
> > FWIW, at the point when sysdevs are resumed we are single-threaded.
> 
> Is that really relevant here? We still could be switched over to another 
> CPU, and that would break things.

No, we couldn't, because the other CPUs are off at this point.

Thanks,
Rafael
