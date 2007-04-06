Return-Path: <linux-kernel-owner+w=401wt.eu-S933647AbXDFRgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933647AbXDFRgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbXDFRgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:36:07 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42733 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933675AbXDFRgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:36:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
References: <20070406084250.GA179@tv-sign.ru>
	<m18xd5amwq.fsf@ebiederm.dsl.xmission.com>
	<20070406094413.GA673@tv-sign.ru>
	<m1lkh58q16.fsf@ebiederm.dsl.xmission.com>
	<20070406154750.GA541@tv-sign.ru>
	<Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>
Date: Fri, 06 Apr 2007 11:34:39 -0600
In-Reply-To: <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>
	(Linus Torvalds's message of "Fri, 6 Apr 2007 10:16:27 -0700 (PDT)")
Message-ID: <m1ejmx76fk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, 6 Apr 2007, Oleg Nesterov wrote:
>> 
>> Oops. I misread stop_machine(), it does kernel_thread(), not kthread_create().
>> So "stopmachine" threads are all re-parented to init when the caller exits.
>> I think it makes sense to set ->exit_state = -1 in stopmachine(), regadless
>> of any other changes.
>
> I agree that "->exit_state = -1" makes sense, but I disagree in that I 
> don't think it *matters*.
>
> Most of the problematic kernel threads are long-running (as in "never 
> exit"). Things like eventd, khelper, migration-threads etc will have init 
> as their parent and never actually exit, so their ->exit_state doesn't 
> matter. What matters is that they are on the children list, so when you 
> have 1024 CPU's, and init has many thousand of these per-cpu threads as 
> its children, then the *user* threads (that do exit) will cause problems!
>
> I'd almost prefer to just not add kernel threads to any parent process 
> list *at*all*. 

Oleg is coming from a different case where it was found that exiting kernel
threads were causing problems for nash when nash was run as init in an
initramfs.  While I think that case is likely a user space bug because
nash should check the pid from waidpid before assuming the process it
was waiting for returned.

I do think you can construct valid embedded cases where you can prove
there that among the user space processes certain actions are safe
when they exit that a spare kernel space thread could invalidate.

It just happens that the exit signal of kernel threads just matters on
the other end of system size.

Eric
