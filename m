Return-Path: <linux-kernel-owner+w=401wt.eu-S1030851AbXCHW4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030851AbXCHW4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030854AbXCHW4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:56:19 -0500
Received: from www.osadl.org ([213.239.205.134]:43819 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030851AbXCHW4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:56:18 -0500
Subject: Re: [rfc][patch] futex: restartable futex_wait?
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <20070308172902.GA16834@elte.hu>
References: <20070307153349.GA32404@wotan.suse.de>
	 <20070308172902.GA16834@elte.hu>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 00:02:31 +0100
Message-Id: <1173394952.24738.1070.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-08 at 18:29 +0100, Ingo Molnar wrote:
> * Nick Piggin <npiggin@suse.de> wrote:
> 
> > Hi Ingo,
> > 
> > I'm seeing an LTP test fail for ltp test sigaction_16_24. Basically, 
> > it tests whether the SA_RESTART flag works for the sem_wait operation.

Not sure, whether the testcase is correct or not. See below

> > I see sem_wait is implemented with futex_wait, so I wonder whether we 
> > can make it restartable? Am I going about it the right way? (Seems to 
> > fix the testcase here).
> 
> i think that's quite right. I'm wondering why this never came up before? 
> But your fix is not complete i think:
> 
> > +             restart->arg2 = time;
> > +             return -ERESTART_RESTARTBLOCK;
> > +     }
> 
> 'time' here is relative, so the restarted syscall will do a /full/ wait 
> again.
> 
> maybe we should rather convert futex timed-waits to hrtimers? Thomas?

The problem is that the original API is based on relative time and
therefor can not be changed. 

sem_wait returns -EINTR to the application when it is interrupted, while
pthread_mutex_lock does not.

http://www.opengroup.org/onlinepubs/009695399/functions/sem_wait.html

http://www.opengroup.org/onlinepubs/009695399/functions/pthread_mutex_lock.html

We need to create a seperate op for the futex - just like the pi_futex
and use absolute time there too. 

	tglx


