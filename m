Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbYDKKsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbYDKKsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758944AbYDKKsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:48:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:45672 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771AbYDKKsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:48:15 -0400
Date: Fri, 11 Apr 2008 12:49:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <andi@firstfloor.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: BUG: using smp_processor_id() during suspend with 2.6.25-rc8
Message-ID: <20080411104902.GA8734@elf.ucw.cz>
References: <c4e36d110804070625n17eb44e1nbb5558f500f13438@mail.gmail.com> <Pine.LNX.4.64.0804080008420.3896@jikos.suse.cz> <20080407222352.GG16647@one.firstfloor.org> <200804080029.31102.rjw@sisk.pl> <Pine.LNX.4.64.0804080030500.3896@jikos.suse.cz> <20080410094554.GA10321@ucw.cz> <Pine.LNX.4.64.0804110122470.3896@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804110122470.3896@jikos.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-04-11 01:25:13, Jiri Kosina wrote:
> On Thu, 10 Apr 2008, Pavel Machek wrote:
> 
> > > > > sysdevs were always supposed to run completely with interrupts off. If they 
> > > > > don't anymore that's some kind of higher level resume code bug which you need 
> > > > > to fix there, not hack around in the low level code.
> > > > They are executed with interrupts disabled, on one CPU.
> > > So, any idea why mce_resume() -> mce_init() -> debug_smp_processor_id() 
> > > triggers the warning? Apparently preempt_count is zero, irqs_disabled() 
> > > returns false, and cpumask_of_cpu() is not equal to current->cpus_allowed.

...that is okay in case of just one CPU.

> > We are single-threaded because we 'unplugged' all the other cpus... but 
> > I'm not sure the BUG() code realises that...
> 
> That's unrelated, right? The real problem here is that irqs_disabled() 
> call inside debug_smp_processor_id() signalized that interrupts are 
> enabled, and that (correctly) triggered the bug.

Well, we can discuss it personally.

Yes, it is probably bug that interrupts are enabled there. No, the bug
can't potentially bite the user because there should be just one CPU
"plugged in"... so it is kind of false-positive, too..

Does the warning go away with this?


									Pavel

diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 6c90fb9..8195c37 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -35,6 +35,13 @@ unsigned int debug_smp_processor_id(void
 		goto out;
 
 	/*
+	 * It is valid to assume CPU-locality if there's just one
+	 * CPU active
+	 */
+	if (num_online_cpus() == 1)
+		goto out;
+
+	/*
 	 * Avoid recursion:
 	 */
 	preempt_disable();

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
