Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYCXWoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYCXWoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYCXWoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:44:23 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3245 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbYCXWoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:44:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=gN3jltCGCurm/Hx3xirHe3vY5UImWzZOjwX7Vjf6jjFTsg+/wyDuGSJtnpXQdqSbN
	t5SKTYyvRUKzeaSLkLAwA==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1206380079.21896.20.camel@bobble.smo.corp.google.com>
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
	 <20080304070016.903E127010A@magilla.localdomain>
	 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
	 <20080305040826.D0E6127010A@magilla.localdomain>
	 <1204830243.20004.31.camel@bobble.smo.corp.google.com>
	 <20080311075020.A93DB26F991@magilla.localdomain>
	 <1205269507.23124.57.camel@bobble.smo.corp.google.com>
	 <20080311213507.5BCDF26F991@magilla.localdomain>
	 <1205455050.19551.16.camel@bobble.smo.corp.google.com>
	 <20080321071846.1B22B26F9A7@magilla.localdomain>
	 <1206122240.14638.31.camel@bobble.smo.corp.google.com>
	 <20080322215829.D69D026F9A7@magilla.localdomain>
	 <1206380079.21896.20.camel@bobble.smo.corp.google.com>
Content-Type: text/plain
Organization: Google, Inc.
Date: Mon, 24 Mar 2008 15:43:37 -0700
Message-Id: <1206398617.21896.48.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-24 at 10:34 -0700, Frank Mayhar wrote:
> On Sat, 2008-03-22 at 14:58 -0700, Roland McGrath wrote:
> > The analysis above is correct but your conclusion here is wrong.
> > The current value of an itimer is a user feature, not just a piece
> > of internal bookkeeping.
> 
> After looking at the code again, I now understand what you're talking
> about.  You overloaded it_*_expires to support both the POSIX interval
> timers and RLIMIT_CPU.  So the way I have things, setting one can stomp
> the other.
> 
> > Your code causes any timer_settime or timer_delete call on a process
> > CPU timer or any setrlimit call on RLIMIT_CPU to suddenly change the
> > itimer setting just as if the user had made some setitimer call that
> > was never made or intended.  That's wrong.
> 
> Right, because the original effect was to only set the it_*_expires on
> each individual task struct, leaving the one in the signal struct alone.
> 
> Might it be cleaner to handle the RLIMIT_CPU stuff separately, rather
> than rolling it into the itimer handling?

Okay, my proposed fix for this is to introduce a new field in
signal_struct, rlim_expires, a cputime_t.  Everywhere that the
RLIMIT_CPU code formerly set it_prof_expires it will now set
rlim_expires and in run_posix_cpu_timers() I'll check it against the
thread group prof_time.

I believe that that will solve the problem, if I understand this
correctly.  If I don't, I trust that you will set me straight. :-)
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

