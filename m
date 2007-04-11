Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXDKQYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXDKQYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbXDKQYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:24:32 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:32859 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257AbXDKQYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:24:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Don't depend on work queues
References: <20070410185133.GA104@tv-sign.ru>
	<m13b37v517.fsf@ebiederm.dsl.xmission.com>
	<20070411131524.GA284@tv-sign.ru>
Date: Wed, 11 Apr 2007 10:22:58 -0600
In-Reply-To: <20070411131524.GA284@tv-sign.ru> (Oleg Nesterov's message of
	"Wed, 11 Apr 2007 17:15:24 +0400")
Message-ID: <m13b36ubh9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 04/10, Eric W. Biederman wrote:
>> 
>>  static int kthread(void *_create)
>>  {
>>  	struct kthread_create_info *create = _create;
>>  	int (*threadfn)(void *data);
>>  	void *data;
>> -	sigset_t blocked;
>>  	int ret = -EINTR;
>>  
>> -	kthread_exit_files();
>> -
>> -	/* Copy data: it's on keventd's stack */
>> +	/* Copy data: it's on kthread's stack */
>>  	threadfn = create->threadfn;
>>  	data = create->data;
>>  
>> -	/* Block and flush all signals (in case we're not from keventd). */
>> -	sigfillset(&blocked);
>> -	sigprocmask(SIG_BLOCK, &blocked, NULL);
>> -	flush_signals(current);
>> -
>> -	/* By default we can run anywhere, unlike keventd. */
>> -	set_cpus_allowed(current, CPU_MASK_ALL);
>
> The above is OK, but I believe you should add set_cpus_allowed() to
> kthreadd_setup(). Note that kthreadd() is forked after init_idle().

init_idle()?  Yep in sched_init.  I wondered where that happened
for the initial idle thread.  Ugh. That is the first thing that
we fix after we fork init as well.  So yes it would be a good
idea to fix that...

I was expecting init_idle() to happen after we forked kthreadd. I almost
wonder if I should move init_idle....

Anyway that is one bug caught.

Eric

