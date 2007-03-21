Return-Path: <linux-kernel-owner+w=401wt.eu-S965034AbXCUVWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034AbXCUVWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965030AbXCUVWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:22:41 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:39458 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965034AbXCUVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:22:40 -0400
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200703211840.53242.maximlevitsky@gmail.com>
References: <200703211840.53242.maximlevitsky@gmail.com>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 08:22:40 +1100
Message-Id: <1174512160.6665.97.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, 2007-03-21 at 18:40 +0200, Maxim Levitsky wrote:
> Hi,
> 
> Starting with 2.6.21-rc1 suspend to ram and disk doesn't work anymore on my system.
> 
> I did a git-bisect and found that those commits break it:
> 
> e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c
> ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c
> 259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c
> 
> I already reported about it, but now i know the reason why suspend breaks.
> 
> The problem is that both cpu_up/cpu_down were allowed to sleep until now, 
> and it did work because those functions could be called only in process context
> (the one that writes to /sys/devices/system/cpu/cpu*/online) or  idle thread  that does smp_init()).
> 
> But now they are called _after_ all tasks were suspended, so if cpu_down tries for example to take a lock
> that is taken by different process, it can't since the different proccess is frozen and can't release the lock.
> 
> I tested this and all results are positive:
> 
> I disabled 2nd cpu by hand, and then suspend to ram was successfull.
> Suspend to disk went correctly, but it hang on resume, and I know why.
> It hang in old kernel trying to disable 2nd cpu that was enabled by it.
> 
> I was able using kdb to confirm that this is true because it was still possible to enter kdb, and see that
> idle thread (swapper) was active, and uswsusp was waiting on mutex inside workqueue_cpu_callback.
> 
> The solution for this problem seems to be ether complete audit of code that uses register_cpu_notifier,
> to ensure that it doesn't sleep. 
> Also documentation should be changed to note about it.
> 
> Or, it is also possible to revert this change.

Do you know exactly which mutex was being waited on and where it was
taken? If you can say that, it would be much more helpful.

Regards,

Nigel

