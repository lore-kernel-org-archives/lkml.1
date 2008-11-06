Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYKFCAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYKFCAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 21:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbYKFCAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 21:00:39 -0500
Received: from smtp-out.google.com ([216.239.33.17]:18823 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720AbYKFCAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 21:00:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=OoCxHr0p96tOohrD2D45kSEIDGw/fWQA3ddlqLM33pZA0SGmDVFxHVxycsijQtzS1
	0Ykf10JH3dJhtaRqJlIdA==
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Frank Mayhar <fmayhar@google.com>
To: Doug Chapman <doug.chapman@hp.com>
Cc: mingo@elte.hu, roland@redhat.com, adobriyan@gmail.com,
       akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1225219114.24204.37.camel@oberon>
References: <1224694989.8431.23.camel@oberon>
	 <1225132746.14792.13.camel@bobble.smo.corp.google.com>
	 <1225219114.24204.37.camel@oberon>
Content-Type: text/plain
Organization: Google, Inc.
Date: Wed, 05 Nov 2008 17:58:35 -0800
Message-Id: <1225936715.27507.44.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 14:38 -0400, Doug Chapman wrote:
> On Mon, 2008-10-27 at 11:39 -0700, Frank Mayhar wrote:
> > On Wed, 2008-10-22 at 13:03 -0400, Doug Chapman wrote:
> > > Unable to handle kernel paging request at virtual address
> > > 94949494949494a4
> > 
> > I take it this can be read as an uninitialized (or cleared) pointer?
> > 
> > It certainly looks like this is a race in thread (process?) teardown.  I
> > don't have hardware on which to reproduce this but _looks_ like another
> > thread has gotten in and torn down the process while we've been busy.
> 
> I finally managed to get kdump working and caught this in the act.  I
> still need to dig into this more but I think these 2 threads will show
> us the race condition.  Note that this is a slightly hacked kernel in
> that I removed "static" from a few functions to better see what was
> going on but no real functional changes when compared to a recent (day
> old or so) git pull from Linus's tree.

After digging through this a bit, I've concluded that it's probably a
race between process reap and the dequeue_entity() call to update_curr()
combined with a side effect of the slab debug stuff.  The
account_group_exec_runtime() routine (like the rest of these routines)
checks tsk->signal and tsk->signal->cputime.totals for NULL to make sure
they're still valid.  It looks like at this point tsk->signal is valid
(since the tsk->signal->cputime dereference succeeded) but
tsk->signal->cputime.totals is invalid.  That can't happen unless the
process is being reaped, and in fact can only happen in a narrow window
in __cleanup_signal() between the call to thread_group_cputime_free()
and the kmem_cache_free() of the signal struct itself.  Without the slab
debug stuff it would either skip the update (by noticing that pointers
were NULL) or blithely update freed structures.

I can't see anything that would prevent this from happening in the
general case.  I don't see what would stop the parent from coming in on
another CPU and reaping the process after schedule() has picked it off
the rq but before the deactivate_task->dequeue_task->dequeue_entity->
update_curr chain completes.  I see that schedule() disables preemption
on that CPU but will that really do the job?  I also suspect that with
hyperthreading both of these processes are on the same silicon, meaning
that one can be unexpectedly suspended while the other runs, thereby
making the window wider.

Unfortunately I don't know the code well enough to know what the right
fix is.  Maybe account_group_exec_runtime() should check for PF_EXITED?
Maybe update_curr() should do that?  I think that it makes more sense
for dequeue_entity() to do the check and then not call update_curr() if
the task is exiting but I defer to others with more knowledge of this
area.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

