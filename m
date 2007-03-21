Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXCUQlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXCUQlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXCUQlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:41:04 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:59240 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965AbXCUQlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=G09QI6w+1DjA9YMJ/jGX85aUyyL+T/nnuRWNlj0fNskr7fUljfg/cFkwWah3HmEGz+eaSX1jbDkq/GRdh4IO0Hso1hy8WBGYoG+mgkHcVpm6ixXb88R5UUqt0AS2dblGb3zN9lH8nE2C1WMz6v847HBCMKaPcz+A5vJjoWQbmoI=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Wed, 21 Mar 2007 18:40:52 +0200
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200703211840.53242.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Starting with 2.6.21-rc1 suspend to ram and disk doesn't work anymore on my system.

I did a git-bisect and found that those commits break it:

e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c
ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c
259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c

I already reported about it, but now i know the reason why suspend breaks.

The problem is that both cpu_up/cpu_down were allowed to sleep until now, 
and it did work because those functions could be called only in process context
(the one that writes to /sys/devices/system/cpu/cpu*/online) or  idle thread  that does smp_init()).

But now they are called _after_ all tasks were suspended, so if cpu_down tries for example to take a lock
that is taken by different process, it can't since the different proccess is frozen and can't release the lock.

I tested this and all results are positive:

I disabled 2nd cpu by hand, and then suspend to ram was successfull.
Suspend to disk went correctly, but it hang on resume, and I know why.
It hang in old kernel trying to disable 2nd cpu that was enabled by it.

I was able using kdb to confirm that this is true because it was still possible to enter kdb, and see that
idle thread (swapper) was active, and uswsusp was waiting on mutex inside workqueue_cpu_callback.

The solution for this problem seems to be ether complete audit of code that uses register_cpu_notifier,
to ensure that it doesn't sleep. 
Also documentation should be changed to note about it.

Or, it is also possible to revert this change.

	Regards,
		Maxim Levitsky

