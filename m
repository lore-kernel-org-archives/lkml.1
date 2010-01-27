Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872Ab0A0R5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0A0R5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858Ab0A0R45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:56:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34080 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab0A0R4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:56:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s0treB1jYDS3oJIkiYTNlGFo/Zbi9Jy27CaRnqfwGJpqYZ4CiitwsRRTH0nVvjU0AY
         49C1yseTQ2PCnG1nmPcT0HNZIzupRWr69FPeQvqzt75zKiliV4w8V+6MlIcZUU2A2ZEx
         pKveBF/oxw7gVJlI6hkHbkGrMe/lMpUktO6ZA=
Date: Wed, 27 Jan 2010 18:56:50 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/4] perf,hw_breakpoint: add lockless reservation for
	hw_breaks
Message-ID: <20100127175647.GA23017@nowhere>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-3-git-send-email-jason.wessel@windriver.com> <4B5F419F.2090901@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5F419F.2090901@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 01:25:19PM -0600, Jason Wessel wrote:
> @@ -250,11 +326,16 @@ int reserve_bp_slot(struct perf_event *b
>  
>  	mutex_lock(&nr_bp_mutex);
>  
> +	ret = dbg_hw_breakpoint_alloc(bp->cpu);
> +	if (ret)
> +		goto end;
> +



This is totally breaking all the constraints that try to
make the reservation cpu-wide/task-wide aware.

Basically, you just reduced the reservation in 4 breakpoints
per cpu.

The current constraints are able to host thousands of
task wide breakpoints, given none of these tasks has
more than 4 breakpoints. What you've just added here breaks
all this flexibility and reduces every breakpoints to
per cpu breakpoints (or system wide), ignoring the per
task contexts, or non-pinned events.

Now I still don't understand why you refuse to use
a best effort approach wrt locking.

A simple mutex_is_locked() would tell you if someone
is trying to reserve a breakpoint. And this is
safe since all the system is stopped at this time,
right? So once you ensure nobody is fighting against
you for the reservation, you can be sure you are alone
until the end of your reservation.

Or if it is not guaranteed the system is stopped when
you reserve a breakpoint for kgdb, you can use
mutex_trylock(). Basically this is the same approach.

If you are fighting against another breakpoint reservation,
it means you are really unlucky, it only happens when
you create such event through a perf syscall, ptrace or ftrace.

Yes a user can create a perf/ftrace/ptrace breakpoint while
another user creates one kgdb, then if the reservation happen
on the same time, either both can make or kgdb will fail.
This *might* happen once in the universe lifetime, should
we really care about that?

I can write a patch for that if you want.

