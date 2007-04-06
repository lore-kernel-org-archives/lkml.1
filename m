Return-Path: <linux-kernel-owner+w=401wt.eu-S1767737AbXDFPq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767737AbXDFPq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 11:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767781AbXDFPq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 11:46:59 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:40790 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767737AbXDFPq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 11:46:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Robin Holt <holt@sgi.com>, Chris Snook <csnook@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
References: <20070406084250.GA179@tv-sign.ru>
	<m18xd5amwq.fsf@ebiederm.dsl.xmission.com>
	<20070406094413.GA673@tv-sign.ru>
Date: Fri, 06 Apr 2007 09:45:57 -0600
In-Reply-To: <20070406094413.GA673@tv-sign.ru> (Oleg Nesterov's message of
	"Fri, 6 Apr 2007 13:44:13 +0400")
Message-ID: <m1lkh58q16.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

>> At first glance your patch looks reasonable.
>> 
>> Unfortunately it only applies to the rare thread that calls daemonize,
>> and not also to kernel/kthread/kthread() which means it will miss many of
>> our current kernel threads.
>
> Note that a thread created by kthread_create() has ->parent == "[kthread]",
> not /sbin/init (unless it was created before core_initcall). So I don't really
> understand how stop_machine() creates the threads parented to init.

Duh.  I was looking for that detail but the code was sufficiently
abstracted that I missed it skimming through.  Now I see it thanks.
That at least explains how a handful of threads created with
kthread_create have init as their parent.

My gut feel says it makes sense to change reparent_to_init to 
reparent_to_kthread.  Which will get the all of the kernel daemons
under a single parent.  Further I think it makes sense to see if
we can start kthread earlier. Having kthread have pid == 2 would be
nice.  That way we can kill the conditional that is only used during
early initialization (make the code simpler and more predictable).

Since we seem to need kthread for the work of forking kernel threads,
I don't see much point in not having a proper process tree, and a
single extra child for pid == 1 isn't going to hurt anyone.

Eric
