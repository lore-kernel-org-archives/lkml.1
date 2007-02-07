Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbXBGCe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbXBGCe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 21:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965273AbXBGCe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 21:34:27 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52417 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbXBGCe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 21:34:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Luigi Genoni <luigi.genoni@pirelli.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 2/2] x86_64 irq:  Handle irqs pending in IRR during irq migration.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<200702021848.55921.luigi.genoni@pirelli.com>
	<m1ejp85tgm.fsf@ebiederm.dsl.xmission.com>
	<200702021905.39922.luigi.genoni@pirelli.com>
	<m1zm7w3wvr.fsf_-_@ebiederm.dsl.xmission.com>
	<m1veik3woc.fsf_-_@ebiederm.dsl.xmission.com>
	<20070206073616.GA15016@elte.hu>
	<m1odo7q6cq.fsf@ebiederm.dsl.xmission.com>
	<20070206222523.GA11602@elte.hu>
Date: Tue, 06 Feb 2007 19:33:10 -0700
In-Reply-To: <20070206222523.GA11602@elte.hu> (Ingo Molnar's message of "Tue,
	6 Feb 2007 23:25:23 +0100")
Message-ID: <m1hctyr921.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Ingo would it be reasonable to get a wait queue so I can wait for an 
>> irq that needs the delayed disable action to actually become masked?
>
> that might make sense, but what will do the wakeup - incidental IRQ 
> arriving on the new CPU? 

That is what I was thinking.

> Isnt that a bit risky - maybe the device wont 
> generate IRQs for a really long time.

Well this is in a user space context called from user space and it
exactly matches the semantics we have now.  If we make it an
interruptible sleep the user space process shouldn't block.

I guess the other thing to do is do it in a non-block fashion
and just call schedule_work from the interrupt context when the
irq is disabled.  For i386 with it's in kernel irq scheduler
that might be better.

I think the nasty case is probably what do we do when it is
the timer interrupt we are dealing with.

Hmm.  I think I should look up what the rules are for
calling local_irq_enable when in interrupt context.  That
might be another way to satisfy this problem.

If local irqs are enabled I don't have to worry about the irr
register.

You've got me brainstorming now.

Eric
