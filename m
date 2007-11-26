Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbXKZVlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbXKZVlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 16:41:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbXKZVlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 16:41:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57333 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbXKZVli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 16:41:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] fix setsid() for sub-namespace /sbin/init
References: <20071126142553.GA16525@tv-sign.ru>
	<m1zlx0n7ga.fsf@ebiederm.dsl.xmission.com>
	<20071126201139.GA84@tv-sign.ru>
Date: Mon, 26 Nov 2007 14:40:22 -0700
In-Reply-To: <20071126201139.GA84@tv-sign.ru> (Oleg Nesterov's message of
	"Mon, 26 Nov 2007 23:11:39 +0300")
Message-ID: <m1r6icn0s9.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 11/26, Eric W. Biederman wrote:
>>
>> Oleg Nesterov <oleg@tv-sign.ru> writes:
>> 
>> > sys_setsid() still deals with pid_t's from the global namespace. This means
>> > that the "session > 1" check can't help for sub-namespace init, setsid()
> can't
>> > succeed because copy_process(CLONE_NEWPID) populates PIDTYPE_PGID/SID links.
>> 
>> We can do even better.  We can remove the misguided code from
>> copy_process(CLONE_NEWPID) that populates the PIDTYPE_PGID/SID links
>> and generally does set setsid by hand,
>
> Yes you are right. IIRC there was a patch from you, but I didn't follow the
> discussion, sorry, so I don't know what was the verdict.

Since session == pgrp == 0 is the historical start condition for /sbin/init there
is no problem from the session perspective, it in fact is better.

The only case that might have cared was setting si_pid when sending signals,
and it turns out it is both simple and necessary to handle that case across
namespaces anyway.

So there is no reason not to handle this.

> If we remove that "almost setsid" from copy_process(), we can remove the fat
> comment and the "session != 1" chunk from setsid().
>
>> and the code from kernel_init
>> that call set_special_pid(), allowing us to remove the special case
>> entirely.
>
> This is different, perhaps we can keep this call. kernel_thread(kernel_init)
> attaches /sbin/init to init_struct_pid. Nothing bad, and a "good" init should
> do setsid() anyway. But who knows? Some special environment may expect that
> getpgrp() != 0. Not that I really disagree on this issue though.

init starting with session == pgrp == 0 is historical linux behavior.  I consider
the current 2.6 behavior a temporary aberation from the historical linux behavior.

sysvinit does call setsid.  And nothing really bad will happen if someone forgets
to call setsid, in some obscure version of init.

Plus once we do this the code will be easier to maintain because we have
removed one obscure special case.

Eric
