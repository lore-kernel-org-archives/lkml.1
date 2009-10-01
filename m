Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbZJAVCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbZJAVCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 17:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbZJAVCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 17:02:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56723 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbZJAVCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 17:02:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 01/19] freezer: don't get over-anxious while waiting
Date: Thu, 1 Oct 2009 23:04:00 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: jeff@garzik.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       pm list <linux-pm@lists.linux-foundation.org>,
       Oren Laadan <orenl@librato.com>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-2-git-send-email-tj@kernel.org> <20091001183655.GA9995@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20091001183655.GA9995@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910012304.00720.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 October 2009, Pavel Machek wrote:
> 
> > Freezing isn't exactly the most latency sensitive operation and
> > there's no reason to burn cpu cycles and power waiting for it to
> > complete.  msleep(10) instead of yield().  This should improve
> > reliability of emergency hibernation.
> 
> i don't see how it improves reliability, but its probably ok.
> 
> Well... for hibernation anyway. I can imagine cgroup users where
> freeze is so fast that this matters. rjw cc-ed.		pavel

Thanks.  I'd like to hear from the cgroup freezer people about that.

> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > ---
> >  kernel/power/process.c |   13 +++++++++----
> >  1 files changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/power/process.c b/kernel/power/process.c
> > index cc2e553..9d26a0a 100644
> > --- a/kernel/power/process.c
> > +++ b/kernel/power/process.c
> > @@ -41,7 +41,7 @@ static int try_to_freeze_tasks(bool sig_only)
> >  	do_gettimeofday(&start);
> >  
> >  	end_time = jiffies + TIMEOUT;
> > -	do {
> > +	while (true) {
> >  		todo = 0;
> >  		read_lock(&tasklist_lock);
> >  		do_each_thread(g, p) {
> > @@ -62,10 +62,15 @@ static int try_to_freeze_tasks(bool sig_only)
> >  				todo++;
> >  		} while_each_thread(g, p);
> >  		read_unlock(&tasklist_lock);
> > -		yield();			/* Yield is okay here */
> > -		if (time_after(jiffies, end_time))
> > +		if (!todo || time_after(jiffies, end_time))
> >  			break;
> > -	} while (todo);
> > +
> > +		/*
> > +		 * We need to retry.  There's no reason to be
> > +		 * over-anxious about it and waste power.
> > +		 */

The comment above looks like it's only meaningful in the context of the patch.
After it's been applied the meaning of the comment won't be so obvious, I'm
afraid.

> > +		msleep(10);
> > +	}
> >  
> >  	do_gettimeofday(&end);
> >  	elapsed_csecs64 = timeval_to_ns(&end) - timeval_to_ns(&start);

Thanks,
Rafael
