Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbYJWRin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbYJWRin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYJWRie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:38:34 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:32502 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbYJWRid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=c9pfejljmmc9u1CVjmDsofEawsg9/Dp7EAX2F3e4NEobwKOg+MrURU/AOOM+9Ds1KD
         9sLKNcc/sRIgDPU2CjyaiJhXtK5q+lXH9GAnaxsfQk0UyGDbKnn6TdG4tw6NdMU4lF02
         SzfRie5dHRWWoeONnpx7nDr0WRNiCd+UDjBD0=
Message-ID: <4b6fba110810231038oe89539ex9b5ee28458257b5a@mail.gmail.com>
Date: Thu, 23 Oct 2008 13:38:30 -0400
From: "Daniel Rosenthal" <danielrosenthal@acm.org>
To: "Dario Faggioli" <raistlin@linux.it>
Subject: Re: behavior of hrtimers scheduled to expire in the past, SCHED_SPORADIC subtlety
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <peterz@infradead.org>
In-Reply-To: <1224749448.9835.22.camel@Palanthas>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4b6fba110810221805m70fd7e72rd66da9eba8f9f532@mail.gmail.com>
	 <1224749448.9835.22.camel@Palanthas>
X-Google-Sender-Auth: cdb519334185028a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2008 at 4:10 AM, Dario Faggioli <raistlin@linux.it> wrote:
> First of all I've changed the interface from standard POSIX calls
> (sched_setscheduler, etc.) to the new API (sched_setscheduler2, etc.) as
> suggested in the LKML.

I was thinking about this, and I'm not convinced that this is actually
a good idea. It seems the only POSIX call that arguably needs a dual
is sched_getparam(). Every other function (sched_setscheduler() and
sched_setparam()) should be able to determine from the policy the
appropriate structure to copy from user space. For example, if the
policy is SCHED_SPORADIC, the function knows it needs to copy a new
sched_param structure from user space, including
sched_ss_low_priority, etc., and otherwise it just copies an old
sched_param_legacy structure containing the single field struct
sched_priority. Considerable padding can also be added (making the
final structure 512 bytes or so) to sched_param for future
compatability so this change (hopefully) never has to be made again.

Of course, this would probably require re-coding
do_sched_setscheduler(), and I know this would break the convention of
Linux system call implementations where the user arguments are copied
from user space before any arguments are actually examined, but I
think it is worth it to minimize incompatibility with POSIX, since
after all the whole point of POSIX is to make programs portable and
not implementation specific. I understand such portability is at
conflict with the interest of backwards binary compatibility, but any
POSIX non-conformance should be minimized. In this particular case I
don't see why this can't be done by only adding sched_getparam2() (and
slightly modifying sched_getparam()) and not changing anything else.


> After that I discovered that dealing with poor precision in budget
> accounting (tick resolution) causes very big issues, especially if
> budget and period are very short, and I had to rethink the algorithm and
> the code again to cope with this (and no, hrtick does not help, not so
> much at least!). :-(

Are you talking about a situation in which the platform cannot provide
high-resolution ticks, or do you mean something else?


> All this took very long time, much more than what I expected, but now
> it's ready... I'm just testing it with some corner cases I have been
> able to figure out and, more interestingly, I'm trying to establish a
> meaningful comparison between the present throttling mechanism and the
> SCHED_SPORADIC group scheduling.

This is definitely an interesting issue. In the future it might be
better to model the entire rt-throttling mechanism as a periodic
server, and model group scheduling in the same way. This has been
proposed before by multiple people in real-time systems, including Rob
Davis and Alan Burns.


> In a short while (I hope) I'll send the patch again to you as well as to
> the ML, so that we can discuss about it being more informed. :-)

Thanks. This is very much appreciated :-).


> Also, I'm going to present this work at the next RealTime Linux
> Workshop, next week, in Mexico... Are you attending?

Unfortunately not. Good luck on your presentation though :-).


Daniel


-----------------------------------------------
Daniel Rosenthal
Florida State University
http://ww2.cs.fsu.edu/~rosentha/

Sporadic Server stuff:
http://ww2.cs.fsu.edu/~rosentha/cop5641/
http://ww2.cs.fsu.edu/~rosentha/cop5641/modifications.php
