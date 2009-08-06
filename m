Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbZHFLYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbZHFLYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZHFLYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:24:31 -0400
Received: from smtp-out.google.com ([216.239.45.13]:13030 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbZHFLYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:24:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=o5P3+aYwbyYALC8G4iis3T9OKH5TkqB7i0fRfDskieLwimnmNvSx4R23geYlPpFqg
	6lku3naWray4M2+K6dwKw==
MIME-Version: 1.0
In-Reply-To: <1249556540.32113.191.camel@twins>
References: <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com>
	 <20090805102057.GT29252@hawkmoon.kerlabs.com>
	 <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
	 <20090805164218.GB26446@hawkmoon.kerlabs.com>
	 <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
	 <20090806095854.GD26446@hawkmoon.kerlabs.com>
	 <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com>
	 <1249554853.32113.145.camel@twins>
	 <6599ad830908060342m1fc8cdd2me25af248a8e0e183@mail.gmail.com>
	 <1249556540.32113.191.camel@twins>
Date: Thu, 6 Aug 2009 04:24:25 -0700
Message-ID: <6599ad830908060424r72e1aa12g2b246785e7bc039c@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, paulmck <paulmck@linux.vnet.ibm.com>,
       oleg <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 4:02 AM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
>
> Taking that many locks in general, some apps (JVM based usually) tend to
> be thread heavy and can easily have hundreds of them, even on relatively

Oh, I'm well aware that apps can be heavily multi-threaded - we have
much worse cases at Google.

>
> Now that's not real nice is it ;-)

Not particularly - but who exactly is going to be moving processes
with thousands of threads between cgroups on a lockdep-enabled debug
kernel?

>
>> But given that AFAICS we can eliminate the overhead associated with a
>> single lock by piggy-backing on the cache line containing
>> sighand->count, hopefully this won't be an issue any more.
>
> Right, so this is a write rarely, read frequently thing, which suggests
> an RCU like approach where the readers pay a minimum synchronization
> penalty.

The documentation for SRCU mentions:

        Therefore, SRCU should be used in preference to rw_semaphore
        only in extremely read-intensive situations, or in situations
        requiring SRCU's read-side deadlock immunity or low read-side
        realtime latency.

What benefits does the additional complexity of SRCU give, over the
simple solution of putting an rwsem in the same cache line as
sighand->count ?

Paul
