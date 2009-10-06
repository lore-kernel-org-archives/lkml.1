Return-Path: <linux-kernel-owner+w=401wt.eu-S933243AbZJFUhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbZJFUhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933204AbZJFUhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:37:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933181AbZJFUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:37:17 -0400
Date: Tue, 6 Oct 2009 13:34:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: khilman@deeprootsystems.com, venkatesh.pallipadi@intel.com,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, lenb@kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] CPUidle: always return with interrupts enabled
Message-Id: <20091006133456.5177a32a.akpm@linux-foundation.org>
In-Reply-To: <200909302321.33088.rjw@sisk.pl>
References: <1254332153-23493-1-git-send-email-khilman@deeprootsystems.com>
	<200909302321.33088.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 23:21:33 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Wednesday 30 September 2009, Kevin Hilman wrote:
> > In the case where cpuidle_idle_call() returns before changing state
> > due to a need_resched(), it was returning with IRQs disabled.
> > 
> > This patch ensures IRQs are (re)enabled before returning.
> 
> Venki, any comments on this?

Rigor mortis is setting in on this one.

Venki's most recent linux-acpi email was on July 31.

> > Reported-by: Hemanth V <hemanthv@ti.com>
> > Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> > ---
> >  drivers/cpuidle/cpuidle.c |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> > index ad41f19..12fdd39 100644
> > --- a/drivers/cpuidle/cpuidle.c
> > +++ b/drivers/cpuidle/cpuidle.c
> > @@ -76,8 +76,11 @@ static void cpuidle_idle_call(void)
> >  #endif
> >  	/* ask the governor for the next state */
> >  	next_state = cpuidle_curr_governor->select(dev);
> > -	if (need_resched())
> > +	if (need_resched()) {
> > +		local_irq_enable();
> >  		return;
> > +	}
> > +
> >  	target_state = &dev->states[next_state];
> >  
> >  	/* enter the state and update stats */

The patch seems correct to me.  The code is hopelessly poorly
documented as per usual, but other paths in that function, including
the call to target_state->enter() (which devolves to default_idle) also
enable interrupts.

Kevin, the changelog is not good.  It tells us what was wrong with the
code but does not describe the user-visible effects of the bug.

I'm unable to find any bug report from Hemanth so I'm all in the dark.

Your cc to linux-omap makes me suspect that <whatever the problem was>
was exhibited on a non-x86 platform, under some circumstances.  Perhaps
that explains (for unknown reasons) why <whatever the problem was> was
not observed on x86.  But I'm totally in the dark and grasping for
clues and have no way of determining (for example) whether we should
backport the fix to earlier kernels.


Please send along the additional information?
