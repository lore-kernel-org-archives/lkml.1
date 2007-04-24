Return-Path: <linux-kernel-owner+w=401wt.eu-S1161789AbXDXPGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161789AbXDXPGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 11:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161792AbXDXPGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 11:06:39 -0400
Received: from mail.screens.ru ([213.234.233.54]:55616 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161789AbXDXPGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 11:06:35 -0400
Date: Tue, 24 Apr 2007 19:05:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] kthread: Enhance kthread_stop to abort interruptible sleeps
Message-ID: <20070424150558.GA233@tv-sign.ru>
References: <20070413130236.GA173@tv-sign.ru> <m1zm5bmywm.fsf@ebiederm.dsl.xmission.com> <20070424030924.be44ebfa.akpm@linux-foundation.org> <m1r6qat681.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1r6qat681.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24, Eric W. Biederman wrote:
>
> The NULL vfork_done is really weird as exec is the only thing that sets
> vfork_done to NULL.

Hm, mm_release() clears ->vfork_done before complete().

	mm_release:

		struct completion *vfork_done = tsk->vfork_done;

		if (vfork_done) {
			tsk->vfork_done = NULL;
			complete(vfork_done);
		}


	kthread_stop:

		set_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
		signal_wake_up(tsk, 1);

		// tsk exits, sets ->vfork_done == NULL

		wait_for_completion(tsk->vfork_done);


Probably Rafael worried about this, but I misunderstood him...

Oleg.

