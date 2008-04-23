Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYDWMf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYDWMf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 08:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYDWMfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 08:35:11 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:33170 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYDWMfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 08:35:09 -0400
Subject: Re: [PATCH 11/11] s390: convert to generic helpers for IPI
	function calls
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org,
       rusty@rustcorp.com.au
In-Reply-To: <20080423114744.GA29422@osiris.boeblingen.de.ibm.com>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com>
	 <1208890227-24808-12-git-send-email-jens.axboe@oracle.com>
	 <20080423075831.GB15850@osiris.boeblingen.de.ibm.com>
	 <20080423081147.GC12774@kernel.dk> <20080423112124.GJ12774@kernel.dk>
	 <20080423114744.GA29422@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 23 Apr 2008 14:42:53 +0200
Message-Id: <1208954573.5090.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 13:47 +0200, Heiko Carstens wrote:
> I don't think that works: the old code also relied on the fact that there
> could be only one cpu sending an smp_call_* IPI (serialized by call_lock).
> The current etr code exploits that to serialize all cpus:
> 
> Do smp_call_function() to force all other cpus into clock_sync_cpu_start()
> where they sort of busy wait(!). Then the master cpu is syncing the clock
> and when it finished the other cpus may continue again and finally leave
> the smp_call_function interrupt handler.
> 
> Your patch series however doesn't make sure anymore that there is only
> one cpu doing an smp_call_function*, so we may deadlock as soon as two
> cpus are trying to synchronize all cpus this way.
> After all I think the etr code should be converted to use stop_machine_run
> instead. However that doesn't allow for master/slave cpus.

Changing the etr code to stop_machine_run() will require a common code
change. We can use the fn() parameter of stop_machine_run() for the cpu
that does the clock synchronization but all the other cpus are not just
disabled. They need to do something before going back to normal
operation,  namely waiting for the clock to get back into sync and then
reprogram the clock comparator before we can allow interrupts again.

Looking at the stop_machine() code it doesn't seem to be to hard to get
this implemented. stop_machine_run() would get a second function
argument that replaces the call to cpu_relax() in stopmachine().
The default if the additional function argument is NULL would be
cpu_relax(). For the etr sync code it would be etr_sync_cpu_start().

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


