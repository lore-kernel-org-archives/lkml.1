Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbYDGWd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbYDGWd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 18:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYDGWdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 18:33:49 -0400
Received: from styx.suse.cz ([82.119.242.94]:59175 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753063AbYDGWdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 18:33:49 -0400
Date: Tue, 8 Apr 2008 00:33:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
In-Reply-To: <200804080029.31102.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com>
 <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz> <20080407222352.GG16647@one.firstfloor.org>
 <200804080029.31102.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2008, Rafael J. Wysocki wrote:

> > The mce resume is a sysdev.
> > sysdevs were always supposed to run completely with interrupts off. If they 
> > don't anymore that's some kind of higher level resume code bug which you need 
> > to fix there, not hack around in the low level code.
> They are executed with interrupts disabled, on one CPU.

So, any idea why mce_resume() -> mce_init() -> debug_smp_processor_id() 
triggers the warning? Apparently preempt_count is zero, irqs_disabled() 
returns false, and cpumask_of_cpu() is not equal to current->cpus_allowed.

So there clearly is a bug somewhere.

> > Obviously turning on preemption anywhere around the machine check is
> > fatal because it touches CPU state and if you reschedule you could
> > switch to another CPU and change or access the wrong CPU's state.
> FWIW, at the point when sysdevs are resumed we are single-threaded.

Is that really relevant here? We still could be switched over to another 
CPU, and that would break things.

-- 
Jiri Kosina
SUSE Labs
