Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbXDFRQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbXDFRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 13:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933504AbXDFRQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 13:16:58 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56712 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510AbXDFRQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 13:16:56 -0400
Date: Fri, 6 Apr 2007 10:16:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Robin Holt <holt@sgi.com>,
       Chris Snook <csnook@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: init's children list is long and slows reaping children.
In-Reply-To: <20070406154750.GA541@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0704061013060.6730@woody.linux-foundation.org>
References: <20070406084250.GA179@tv-sign.ru> <m18xd5amwq.fsf@ebiederm.dsl.xmission.com>
 <20070406094413.GA673@tv-sign.ru> <m1lkh58q16.fsf@ebiederm.dsl.xmission.com>
 <20070406154750.GA541@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Apr 2007, Oleg Nesterov wrote:
> 
> Oops. I misread stop_machine(), it does kernel_thread(), not kthread_create().
> So "stopmachine" threads are all re-parented to init when the caller exits.
> I think it makes sense to set ->exit_state = -1 in stopmachine(), regadless
> of any other changes.

I agree that "->exit_state = -1" makes sense, but I disagree in that I 
don't think it *matters*.

Most of the problematic kernel threads are long-running (as in "never 
exit"). Things like eventd, khelper, migration-threads etc will have init 
as their parent and never actually exit, so their ->exit_state doesn't 
matter. What matters is that they are on the children list, so when you 
have 1024 CPU's, and init has many thousand of these per-cpu threads as 
its children, then the *user* threads (that do exit) will cause problems!

I'd almost prefer to just not add kernel threads to any parent process 
list *at*all*. 

		Linus
