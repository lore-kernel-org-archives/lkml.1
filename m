Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbYCDHAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbYCDHAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 02:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYCDHAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 02:00:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbYCDHAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 02:00:24 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Frank Mayhar <fmayhar@google.com>
X-Fcc: ~/Mail/linus
Cc: parag.warudkar@gmail.com,
       Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
In-Reply-To: Frank Mayhar's message of  Friday, 29 February 2008 11:55:04 -0800 <1204314904.4850.23.camel@peace.smo.corp.google.com>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	<20080206165045.89b809cc.akpm@linux-foundation.org>
	<1202345893.8525.33.camel@peace.smo.corp.google.com>
	<alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	<20080207162203.3e3cf5ab@Varda>
	<alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	<alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	<20080207165455.04ec490b@Varda>
	<alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	<alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	<1204314904.4850.23.camel@peace.smo.corp.google.com>
X-Shopping-List: (1) Global defusers
   (2) Hectic lubricating approval distenders
   (3) Coughing neglect logs
   (4) Periodical chowder carrion
   (5) Erroneous detection indigestion
Message-Id: <20080304070016.903E127010A@magilla.localdomain>
Date: Mon,  3 Mar 2008 23:00:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the detailed explanation and for bringing this to my attention.

This is a problem we knew about when I first implemented posix-cpu-timers
and process-wide SIGPROF/SIGVTALRM.  I'm a little surprised it took this
long to become a problem in practice.  I originally expected to have to
revisit it sooner than this, but I certainly haven't thought about it for
quite some time.  I'd guess that HZ=1000 becoming common is what did it.

The obvious implementation for the process-wide clocks is to have the
tick interrupt increment shared utime/stime/sched_time fields in
signal_struct as well as the private task_struct fields.  The all-threads
totals accumulate in the signal_struct fields, which would be atomic_t.
It's then trivial for the timer expiry checks to compare against those
totals.

The concern I had about this was multiple CPUs competing for the
signal_struct fields.  (That is, several CPUs all running threads in the
same process.)  If the ticks on each CPU are even close to synchronized,
then every single time all those CPUs will do an atomic_add on the same
word.  I'm not any kind of expert on SMP and cache effects, but I know
this is bad.  However bad it is, it's that bad all the time and however
few threads (down to 2) it's that bad for that many CPUs.

The implementation we have instead is obviously dismal for large numbers
of threads.  I always figured we'd replace that with something based on
more sophisticated thinking about the CPU-clash issue.  

I don't entirely follow your description of your patch.  It sounds like it
should be two patches, though.  The second of those patches (workqueue)
sounds like it could be an appropriate generic cleanup, or like it could
be a complication that might be unnecessary if we get a really good
solution to main issue.  

The first patch I'm not sure whether I understand what you said or not.
Can you elaborate?  Or just post the unfinished patch as illustration,
marking it as not for submission until you've finished.


Thanks,
Roland
