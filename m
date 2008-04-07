Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYDGUIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYDGUIU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYDGUIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:08:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53729 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbYDGUIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:08:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: frank@exit.com
X-Fcc: ~/Mail/linus
Cc: Frank Mayhar <fmayhar@google.com>, linux-kernel@vger.kernel.org
Subject: Re: posix-cpu-timers revamp
In-Reply-To: Frank Mayhar's message of  Saturday, 5 April 2008 22:26:48 -0700 <1207459608.94001.22.camel@jill.exit.com>
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
	<20080331054404.78CDB26F8E9@magilla.localdomain>
	<1206995072.14649.41.camel@bobble.smo.corp.google.com>
	<20080402020707.151E126F8DC@magilla.localdomain>
	<1207158164.11976.32.camel@bobble.smo.corp.google.com>
	<20080402194836.4933026F98A@magilla.localdomain>
	<1207168464.11976.48.camel@bobble.smo.corp.google.com>
	<20080404231739.7E25126F8DC@magilla.localdomain>
	<1207459608.94001.22.camel@jill.exit.com>
X-Windows: the first fully modular software disaster.
Message-Id: <20080407200804.5541926F992@magilla.localdomain>
Date: Mon,  7 Apr 2008 13:08:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, I checked that out.  The one difference here is that that was a
> race between do_exit() (actually release_task()/__exit_signal()) and
> run_posix_cpu_timers().  While this race was the same in that respect,
> there was also a race between all of the timer-tick routines that call
> any of account_group_user_time(), account_group_system_time() or
> account_group_exec_runtime() and __exit_signal().  This is because those
> functions all dereference tsk->signal.

The essence that matters is the same: something that current does with its
own ->signal on a tick vs something that the release_task path does.

> Erm, well, this isn't reorganizing the data structures per se, since
> these are new data structures.

Tomato, tomato.  You're adding new data structures and lifetime rules to
replace data that was described in a different data structure before, yet
your new data's meaningful semantic lifetime exactly matches that of
signal_struct.  You could as well make everything release_task cleans up be
done in __put_task_struct instead, but that would not be a good idea
either.  You've added a word to task_struct (100000 words per 100000-thread
process, vs one word).  It's just not warranted.

> The upshot of this is that none of the timer routines dereference
> tsk->signal, so the races go away, no locking needed.  From my
> perspective this was the simplest solution, since lock dependency
> ordering is _really_ a can of worms.

With the perspective of tunnel vision to just your one test case, adding
something entirely new considering only that case always seems simplest.
That's not how we keep the entire system from getting the wrong kinds of
complexity.

> Regarding the second approach, without locking wouldn't that still be
> racy?  Couldn't exit_state change (and therefore __exit_signal() run)
> between the check and the dereference?

No.  current->exit_state can go from zero to nonzero only by current
running code in the do_exit path.  current does not progress on that
path while current is inside one update_process_times call.


Thanks,
Roland
