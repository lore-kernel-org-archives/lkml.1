Return-Path: <linux-kernel-owner+w=401wt.eu-S1751536AbXCDJdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbXCDJdO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 04:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXCDJdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 04:33:14 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:12669 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbXCDJdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 04:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Zuwd1XIQ1UyuI1IzHoDwx03zfifLkqfyARMaKYC6x/AwHfdAcORSVrRFYpMe2UOO3ZAwa+sbxrWOfEIqmMEsKFf3h3XtW/i9GpJjifHAUyfriwb9Q2gSDGERSC3RyhpIGG8suRL9j93lXpphbrjBIjOmB4ZNIh1Fj4RPpTHO1u0=
Message-ID: <f2b55d220703040133m51279edfn58c5100bf09ea63c@mail.gmail.com>
Date: Sun, 4 Mar 2007 01:33:10 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: ray-gmail@madrabbit.org
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Ihar `Philips` Filipau" <thephilips@gmail.com>,
       "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
In-Reply-To: <2c0942db0703031312g15726e69gcce7a1d0b955ab76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <efa6f5910703021120ia0b8d18ne0c806eb2e73da4c@mail.gmail.com>
	 <20070303103427.GC22557@2ka.mipt.ru>
	 <efa6f5910703030258ne76cd8as8a3900fc22456a91@mail.gmail.com>
	 <2c0942db0703031312g15726e69gcce7a1d0b955ab76@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't take this the wrong way, Ray, but I don't think _you_
understand the problem space that people are (or should be) trying to
address here.

Servers want to always, always block.  Not on a socket, not on a stat,
not on any _one_ thing, but in a condition where the optimum number of
concurrent I/O requests are outstanding (generally of several kinds
with widely varying expected latencies).  I have an embedded server I
wrote that avoids forking internally for any reason, although it
watches the damn serial port signals in parallel with handling network
I/O, audio, and child processes that handle VoIP signaling protocols
(which are separate processes because it was more practical to write
them in a different language with mediocre embeddability).  There's a
lot of things that can block out there, not just disk I/O, but the
only thing a genuinely scalable server process ever blocks on (apart
from the odd spinlock) is a wait-for-IO-from-somewhere mechanism like
select or epoll or kqueue (or even sleep() while awaiting SIGRT+n, or
if it genuinely doesn't suck, the thread scheduler).

Furthermore, not only do servers want to block rather than shove more
I/O into the plumbing than it can handle without backing up, they also
want to throttle the concurrency of requests at the kernel level *for
the kernel's benefit*.  In particular, a server wants to submit to the
kernel a ton of stats and I/O in parallel, far more than it makes
sense to actually issue concurrently, so that efficient sequencing of
these requests can be left to the kernel.  But the server wants to
guide the kernel with regard to the ratios of concurrency appropriate
to the various classes and the relative urgency of the individual
requests within each class.  The server also wants to be able to
reprioritize groups of requests or cancel them altogether based on new
information about hardware status and user behavior.

Finally, the biggest argument against syslets/threadlets AFAICS is
that -- if done incorrectly, as currently proposed -- they would unify
the AIO and normal IO paths in the kernel.  This would shackle AIO to
the current semantics of synchronous syscalls, in which buffers are
passed as bare pointers and exceptional results are tangled up with
programming errors.  This would, in turn, make it quite impossible for
future hardware to pipeline and speculatively execute chains of AIO
operations, leaving "syslets" to a few RDBMS programmers with time to
burn.  The unimproved ease of long term maintenance on the kernel (not
to mention the complete failure to make the writing of _correct_,
performant server code any easier) makes them unworthy of
consideration for inclusion.

So, while everybody has been talking about cached and non-cached
cases, those are really total irrelevancies.  The principal problem
that needs solving is to model the process's pool of in-flight I/O
requests, together with a much larger number of submitted but not yet
issued requests whose results are foreseeably likely to be needed
soon, using a data structure that efficiently supports _all_ of the
operations needed, including bulk cancellation, reprioritization, and
batch migration based on affinities among requests and locality to the
correct I/O resources.  Memory footprint and gentle-on-real-hardware
scheduling are secondary, but also important, considerations.  If you
happen to be able to service certain things directly from cache,
that's gravy -- but it's not very smart IMHO to put that central to
your design process.

Cheers,
- Michael
