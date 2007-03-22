Return-Path: <linux-kernel-owner+w=401wt.eu-S965119AbXCVAcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965119AbXCVAcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965553AbXCVAcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:32:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:47361 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119AbXCVAci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=aRkVzolx8OlX+5z+xMS6SoPo09YfIP0ioSpkCYB0Io/x86nwziKFxcTB6/UwaxuT5nXZk2zluyEmhYMtz6GcvVQ2sPpw24yHplfO0H0MudN5x8llCQhj7tBHPJikZTaJhsOvVe5pnYwFVtqXhbM0pkyl6dxu/RW5LXk/h0Ijfbc=
From: Maxim <maximlevitsky@gmail.com>
To: nigel@nigel.suspend2.net
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Thu, 22 Mar 2007 02:32:30 +0200
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
References: <200703211840.53242.maximlevitsky@gmail.com> <1174512160.6665.97.camel@nigel.suspend2.net> <200703220114.05228.maximlevitsky@gmail.com>
In-Reply-To: <200703220114.05228.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703220232.30694.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 01:14:05 Maxim wrote:
> On Wednesday 21 March 2007 23:22:40 Nigel Cunningham wrote:
> > Hi.
> > 
> > On Wed, 2007-03-21 at 18:40 +0200, Maxim Levitsky wrote:
> > > Hi,
> > > 
> > > Starting with 2.6.21-rc1 suspend to ram and disk doesn't work anymore on my system.
> > > 
> > > I did a git-bisect and found that those commits break it:
> > > 
> > > e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c
> > > ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c
> > > 259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c
> > > 
> > > I already reported about it, but now i know the reason why suspend breaks.
> > > 
> > > The problem is that both cpu_up/cpu_down were allowed to sleep until now, 
> > > and it did work because those functions could be called only in process context
> > > (the one that writes to /sys/devices/system/cpu/cpu*/online) or  idle thread  that does smp_init()).
> > > 
> > > But now they are called _after_ all tasks were suspended, so if cpu_down tries for example to take a lock
> > > that is taken by different process, it can't since the different proccess is frozen and can't release the lock.
> > > 
> > > I tested this and all results are positive:
> > > 
> > > I disabled 2nd cpu by hand, and then suspend to ram was successfull.
> > > Suspend to disk went correctly, but it hang on resume, and I know why.
> > > It hang in old kernel trying to disable 2nd cpu that was enabled by it.
> > > 
> > > I was able using kdb to confirm that this is true because it was still possible to enter kdb, and see that
> > > idle thread (swapper) was active, and uswsusp was waiting on mutex inside workqueue_cpu_callback.
> > > 
> > > The solution for this problem seems to be ether complete audit of code that uses register_cpu_notifier,
> > > to ensure that it doesn't sleep. 
> > > Also documentation should be changed to note about it.
> > > 
> > > Or, it is also possible to revert this change.
> > 
> > Do you know exactly which mutex was being waited on and where it was
> > taken? If you can say that, it would be much more helpful.
> > 
> > Regards,
> > 
> > Nigel
> > 
> > 
> 
> Hello,
> 
> 	It is workqueue_mutex
> 	and it is taken in kernel/workqueue.c:797
> 
> 	this is guilt of freezable work queues , and XFS uses it (and I use XFS)
> 
> 	Thanks to Rafael J. Wysocki for pointing it out to me.
> 
> 	Regards,
> 		Maxim Levitsky
> 


I think that I made a mistake,

I now reverted the patch that fixes the above error, and I wrote down back-trace from this hang,
and it appears that system hangs in kthread_stop:

This I have written in paper, using kdb:

workqueue_cpu_callback ->
cleanup_workqueue_thread ->
kthread_stop ->

and then wake_up_process (I think , I didn't wrote this on paper, I will check again)


	Regards,
		Maxim Levitsky
