Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZK3U1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZK3U1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 15:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZK3U1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 15:27:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35275 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZK3U1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 15:27:22 -0500
Date: Mon, 30 Nov 2009 21:27:18 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Nicolas Pitre <nico@marvell.com>, Eric Miao <eric.y.miao@gmail.com>,
       John Stultz <johnstul@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Remy Bohmer <linux@bohmer.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Gallo <andrea.gallo@stericsson.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jamie Lokier <jamie@shareable.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] genirq: warn about IRQF_SHARED|IRQF_DISABLED at the
	right place
Message-ID: <20091130202718.GC19172@pengutronix.de>
References: <1259356206-14843-1-git-send-email-u.kleine-koenig@pengutronix.de> <1259578067-29169-1-git-send-email-u.kleine-koenig@pengutronix.de> <200911301221.30601.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200911301221.30601.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 12:21:30PM -0800, David Brownell wrote:
> On Monday 30 November 2009, Uwe Kleine-König wrote:
> > +               if (new->flags & IRQF_DISABLED)
> > +                       pr_warning("IRQ %d/%s: IRQF_DISABLED is not guaranteed "
> > +                                       "on shared IRQs\n", irq, new->name);
> 
> This should have copied the original test ... this way,
> it's dropping the SHARED constraint, and trying to morph
> into a generic "IRQF_DISABLED is eeebil!" test.
No, it doesn't.  The inserted code is in an if block:

	old_ptr = &desc->action;
	old = *old_ptr;
	if (old) {
		/* ... */
		if (!((old->flags & new->flags) & IRQF_SHARED) ||
			((old->flags ^ new->flags) & IRQF_TRIGGER_MASK)) {
			old_name = old->name;
			goto mismatch;
		}

		...

+		if (new->flags & IRQF_DISABLED)
+			pr_warning("...");

and the mismatch label is further below.  So the warning is still only
hit if a shared irq is registered.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
