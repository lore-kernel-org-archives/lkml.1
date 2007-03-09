Return-Path: <linux-kernel-owner+w=401wt.eu-S2992973AbXCIFPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992973AbXCIFPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 00:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992974AbXCIFPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 00:15:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:46241 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992973AbXCIFPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 00:15:17 -0500
Date: Fri, 9 Mar 2007 06:15:12 +0100
From: Nick Piggin <npiggin@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [rfc][patch] futex: restartable futex_wait?
Message-ID: <20070309051512.GB12479@wotan.suse.de>
References: <20070307153349.GA32404@wotan.suse.de> <20070308172902.GA16834@elte.hu> <1173394952.24738.1070.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173394952.24738.1070.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 12:02:31AM +0100, Thomas Gleixner wrote:
> On Thu, 2007-03-08 at 18:29 +0100, Ingo Molnar wrote:
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > Hi Ingo,
> > > 
> > > I'm seeing an LTP test fail for ltp test sigaction_16_24. Basically, 
> > > it tests whether the SA_RESTART flag works for the sem_wait operation.
> 
> Not sure, whether the testcase is correct or not. See below
> 
> > > I see sem_wait is implemented with futex_wait, so I wonder whether we 
> > > can make it restartable? Am I going about it the right way? (Seems to 
> > > fix the testcase here).
> > 
> > i think that's quite right. I'm wondering why this never came up before? 
> > But your fix is not complete i think:
> > 
> > > +             restart->arg2 = time;
> > > +             return -ERESTART_RESTARTBLOCK;
> > > +     }
> > 
> > 'time' here is relative, so the restarted syscall will do a /full/ wait 
> > again.
> > 
> > maybe we should rather convert futex timed-waits to hrtimers? Thomas?
> 
> The problem is that the original API is based on relative time and
> therefor can not be changed. 
> 
> sem_wait returns -EINTR to the application when it is interrupted, while
> pthread_mutex_lock does not.

But this still means sem_wait should restart if SA_RESTART is set, right?

And pthread_mutex_lock could be implemented to not return -EINTR, even if
futex_wait does, couldn't it? (I guess it probably already is, considering
that futex_wait alsready returns -EINTR).

> 
> http://www.opengroup.org/onlinepubs/009695399/functions/sem_wait.html
> 
> http://www.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_lock.html
> 
> We need to create a seperate op for the futex - just like the pi_futex
> and use absolute time there too. 
> 
> 	tglx
> 
