Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYKIUsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYKIUsv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 15:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYKIUsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 15:48:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:53779 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbYKIUso convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 15:48:44 -0500
Date: Sun, 9 Nov 2008 12:48:36 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
Message-ID: <20081109124836.34a2c126@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0811091237110.3468@nehalem.linux-foundation.org>
References: <20081104173300.GF6134@ics.muni.cz>
	<20081109105159.GA5867@joi>
	<20081109113304.GE4353@ics.muni.cz>
	<200811091424.10943.rjw@sisk.pl>
	<20081109200918.GA4361@ics.muni.cz>
	<20081109122835.10f410fa@infradead.org>
	<alpine.LFD.2.00.0811091237110.3468@nehalem.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Nov 2008 12:39:50 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 9 Nov 2008, Arjan van de Ven wrote:
> > 
> > for me, the plan is that we need to get Thomas' fixes tested by
> > someone who can reproduce this very reliably. If they fix it, great.
> > If they don't, time is running out and we need to remove the feature
> > for 2.6.28 (that is 1 line of change), realizing that this just
> > papers over stuff and isn't a real fix, and get back to it for
> > 2.6.29.
> 
> I'd like to see the one-liner fix, even if it turns out to just be a 
> workaround that hides the issue and makes us go back to 2.6.27
> behaviour. I'm about to release -rc4 today, we should be aggressive
> about regressions.

>From bf1003799b70f68f927d312841a05930856ad716 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sun, 9 Nov 2008 12:45:10 -0800
Subject: [PATCH] regression: disable timer peek-ahead for 2.6.28

it's showing up as regressions; disabling it very likely just papers
over an underlying issue, but time is running out for 2.6.28,
lets get back to this for 2.6.29

Fixes: #11826 and #11893

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/cpuidle/cpuidle.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 5bed733..67ec4da 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -65,12 +65,14 @@ static void cpuidle_idle_call(void)
 		return;
 	}
 
+#if 0
+	/* shows regressions, re-enable for 2.6.29 */
 	/*
 	 * run any timers that can be run now, at this point
 	 * before calculating the idle duration etc.
 	 */
 	hrtimer_peek_ahead_timers();
-
+#endif
 	/* ask the governor for the next state */
 	next_state = cpuidle_curr_governor->select(dev);
 	if (need_resched())
-- 
1.6.0.3

