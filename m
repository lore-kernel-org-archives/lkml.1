Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbZKHI1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbZKHI1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 03:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbZKHI1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 03:27:31 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42767 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZKHI1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 03:27:30 -0500
Date: Sun, 8 Nov 2009 09:27:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Dasgupta, Romit" <romit@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel
 threads
Message-ID: <20091108082727.GC16482@elf.ucw.cz>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE31F934@dbde02.ent.ti.com>
 <20091107165421.GA1630@ucw.cz>
 <B85A65D85D7EB246BE421B3FB0FBB59301DE31FCF1@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DE31FCF1@dbde02.ent.ti.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-11-08 09:52:52, Dasgupta, Romit wrote:
> > Subject: Re: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel
> > threads
> > 
> > Hi!
> > 
> > > Kicks out a frozen thread from the refrigerator when an active thread has
> > > invoked kthread_stop on the frozen thread.
...
> > > @@ -49,7 +50,7 @@ void refrigerator(void)
> > >
> > >  	for (;;) {
> > >  		set_current_state(TASK_UNINTERRUPTIBLE);
> > > -		if (!frozen(current))
> > > +		if (!frozen(current) || (!current->mm && kthread_should_stop()))
> > >  			break;
> > >  		schedule();
> > 
> > Well, what if the thread does some processing before stopping? That
> > would break refrigerator assumptions...
> 
> The suspend thread will block until the 'to be stopped' thread clears up. That is what any call to kthread_stop would boil down to. The target thread would anyway be out of the refrigerator so I am not sure what assumption you mean here. Eventually, the target thread would clear up and wake up the suspend thread and then things would go on as usual.

(Please format to 80 columns).

No, I do not get it.

Lets say we have

evil_data_writer thread that needs to be stopped becuase it writes to
filesystem

nofreeze random_stopper thread

now we create the suspend image, and start writing it out. But that's
okay, evil_data_writer is stopped so it can't do no harm. But now
random_stopper decides to thread_stop() the evil_data_writer, and this
new code allows it to exit the refrigerator, *do some writing*, and
then stop.

That's bad, right?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
