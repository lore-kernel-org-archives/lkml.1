Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbXDXRUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbXDXRUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 13:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXDXRUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 13:20:15 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37069 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbXDXRUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 13:20:13 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] kthread: Enhance kthread_stop to abort interruptible sleeps
References: <20070413130236.GA173@tv-sign.ru>
	<m1zm5bmywm.fsf@ebiederm.dsl.xmission.com>
	<20070424030924.be44ebfa.akpm@linux-foundation.org>
	<m1r6qat681.fsf@ebiederm.dsl.xmission.com>
	<20070424150558.GA233@tv-sign.ru> <20070424155332.GA321@tv-sign.ru>
Date: Tue, 24 Apr 2007 11:18:27 -0600
In-Reply-To: <20070424155332.GA321@tv-sign.ru> (Oleg Nesterov's message of
	"Tue, 24 Apr 2007 19:53:32 +0400")
Message-ID: <m1irblu1wc.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/24, Oleg Nesterov wrote:
>>
>> Hm, mm_release() clears ->vfork_done before complete().

Duh.  Yes somehow I had a blind spot there.  I clearly
need to handle that case.

>> 	mm_release:
>> 
>> 		struct completion *vfork_done = tsk->vfork_done;
>> 
>> 		if (vfork_done) {
>> 			tsk->vfork_done = NULL;
>> 			complete(vfork_done);
>> 		}
>> 
>> 
>> 	kthread_stop:
>> 
>> 		set_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
>> 		signal_wake_up(tsk, 1);
>> 
>> 		// tsk exits, sets ->vfork_done == NULL
>> 
>> 		wait_for_completion(tsk->vfork_done);
>
> Since the task_struct should be pinned anyway, I think kthread_stop()
> should do:
>
> 	vfork_done = tsk->vfork_done;
> 	barrier();
> 	if (vfork_done)
> 		wait_for_completion(vfork_done);

That should work, and this may explain what is going on. I was trying
to figure out how this could happen but if the thread is running on
another cpu there is a race and it may exit quickly enough to cause us
problems before we get to kthread_stop.

I don't know if this is the problem but it certainly needs to be fixed.

Eric

