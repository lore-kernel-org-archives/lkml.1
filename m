Return-Path: <linux-kernel-owner+w=401wt.eu-S1753519AbYDWLys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519AbYDWLys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYDWLyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:54:38 -0400
Received: from brick.kernel.dk ([87.55.233.238]:7880 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbYDWLyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:54:37 -0400
Date: Wed, 23 Apr 2008 13:54:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, peterz@infradead.org, sam@ravnborg.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 11/11] s390: convert to generic helpers for IPI  function calls
Message-ID: <20080423115430.GK12774@kernel.dk>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-12-git-send-email-jens.axboe@oracle.com> <20080423075831.GB15850@osiris.boeblingen.de.ibm.com> <20080423081147.GC12774@kernel.dk> <20080423112124.GJ12774@kernel.dk> <20080423114744.GA29422@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423114744.GA29422@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23 2008, Heiko Carstens wrote:
> > > > Your generic patch changes semantics of smp_call_function(). At least the
> > > > s390 version of smp_call_function() mask used to not return unless all IPIs
> > > > where received on the target cpus.
> > > > Your patch changes that. It will already return as soon as all IPIs have
> > > > been sent. Unfortunately Martin's etr code in arch/s390/kernel/time.c
> > > 
> > > Yep, this is what I mentioned in the intro mail.
> > > 
> > > > relies on exactly the old semantics.
> > > 
> > > OK, I could not see anything which relied on that and I did think that
> > > it was a somewhat odd interface. By the time that smp_call_function()
> > > stops waiting for startups, we could easily be in the condition that the
> > > N-1 CPUs executed the function part a long time ago. I just didn't see
> > > much usefulness in that, you may as well just set wait == 1 in that
> > > case.
> > > 
> > > > Since this seems to be an s390 only issue, could you just drop the s390
> > > > conversion patch? We'll have to think about how to change the err code
> > > > and convert later I guess.
> > > 
> > > I'll drop the s390 bits. I can easily add something like
> > > smp_call_function_foo() that has this behaviour.
> > 
> > I added an smp_call_function_sync() for this purpose and kept the s390
> > conversion, I would very much appreciate if you could look it over. I
> > wont post the full patchset again today, but you can inspect it here:
> > 
> > http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=refs/heads/generic-ipi
> > 
> > The interesting bits are patch #1 for the generic bits and patch #11 for
> > the s390 part. Thanks!
> 
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

You are right. I'll drop the code again, it would be nice to get rid of
this interface, I guess s390 can do that when they convert to the
generic helpers.

-- 
Jens Axboe

