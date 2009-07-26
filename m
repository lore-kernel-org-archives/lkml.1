Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbZGZW02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbZGZW02 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 18:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZGZW01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 18:26:27 -0400
Received: from www.tglx.de ([62.245.132.106]:38950 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbZGZW01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 18:26:27 -0400
Date: Mon, 27 Jul 2009 00:21:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [Patch RFC 14/37] scsi: aacraid semaphore cleanup
In-Reply-To: <1248639091.4766.4.camel@mulgrave.site>
Message-ID: <alpine.LFD.2.00.0907270004430.2936@localhost.localdomain>
References: <20090726081459.455111897@linutronix.de>  <20090726081555.073502498@linutronix.de> <1248639091.4766.4.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009, James Bottomley wrote:

> cc linux-scsi added
> 
> On Sun, 2009-07-26 at 08:18 +0000, Thomas Gleixner wrote:
> > plain text document attachment
> > (driver-scsi-aacraid-sema-cleanup.patch)
> > The usage of these "mutex"es is non obvious and probably completions
> > in some places. Make it them semaphores.
> 
> -ENOCONTEXT on this ... I assume this is just a global
> s/init_MUTEX/semaphore_init/?

Well, in cases where the mutex use case is obvious it's a semaphore to
mutex conversion. But this one is definitly not.

> I think both are really just mutexes; no need for a counting semaphore.
> There's no stack declaration issues (the fibs are long lived entities)
> that would necessitate a completion.

It's not about stack declaration. These semaphores can not be
converted to mutexes for following reasons:

1) there is no mutex_init_locked() and there never will be one

2) the sem is taken from context A and released from context B. That
violates the mutex semantics where the lock/unlock has to happen in
the same thread context.

i.e. wait_sem is taken from

     aac_do_ioctl()
	next_getadapter_fib()

but release from

    aac_check_health() or aac_command_thread()

I have no idea how that hell of code works, but wait_sem is definitely
not a mutex and neither is event_wait. The beasts might serialize
stuff as well, but they are also (ab)used as a completion to wait for
whatever.

Thanks,

	tglx
