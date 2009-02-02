Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbZBBV6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbZBBV6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:58:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757716AbZBBV54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:57:56 -0500
Received: from smtp-out.google.com ([216.239.33.17]:14348 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbZBBV5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:57:55 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:
	content-transfer-encoding:in-reply-to:x-operating-system:user-agent:
	x-gmailtapped-by:x-gmailtapped;
	b=lsEfr8A+tmUKUn4fc4eBZcvCEcsvd8P/R1ImJo9urdJ27wyzcUCZv8Kh42/vVYUiZ
	GE45lD+PWrpluf44WrAuQ==
Date: Mon, 2 Feb 2009 13:57:40 -0800
From: Mandeep Singh Baines <msb@google.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-20090202: task kmemleak:763 blocked for more than 120 seconds.
Message-ID: <20090202215740.GA26550@google.com>
References: <a4423d670902020327x61a1d9dehb1642b25ec7f82f1@mail.gmail.com> <tnxiqns28mm.fsf@pc1117.cambridge.arm.com> <c62985530902020715u73407d4dqe14c340de310c866@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530902020715u73407d4dqe14c340de310c866@mail.gmail.com>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.24.198.65
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker (fweisbec@gmail.com) wrote:
> 2009/2/2 Catalin Marinas <catalin.marinas@arm.com>:
> > Alexander Beregalov <a.beregalov@gmail.com> wrote:
> >> It seems it is blocked forever.
> >
> > Scanning the full memory may take a lot of time, depending on the
> > amount of RAM and the number of objects allocated. It is not unlikely
> > to take more than 120 seconds on some loaded systems. However, it
> > should call schedule() periodically to let other tasks run. Is your
> > system unresponsive during this?
> >
> >> [ 1704.619898] INFO: task kmemleak:763 blocked for more than 120 seconds.
> >> [ 1704.697951] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> >> disables this message.
> >> [ 1704.791613] kmemleak      D 0000000000000001  6008   763      2
> > [...]
> >> [ 1706.246334] no locks held by kmemleak/763.
> >
> > It looks like the kmemleak thread is in the TASK_UNINTERUPTIBLE state.
> > This happens when it calls schedule_timeout_uninterruptible() to sleep
> > between scans. It probably took more than 120 to scan the memory and
> > hence the report.
> >
> > It doesn't look like a problem, only that the watchdog thread checks
> > for uninterruptible tasks. I can try to make it sleep with
> > TASK_INTERRUPTIBLE to avoid the message.
> >
> > Thanks.
> >
> > --
> > Catalin
> > --
> 
> 
> Hi,
> 
> May be it would be better to make the softlockup detector hooking into
> schedule_timeout()
> (ie by using a tracepoint) to check if a thread chose to sleep more
> than hung_task_timeout_secs
> intentionally in a TASK_UNINTERRUPTIBLE state.
> 
> Fixing it into kmemleak would not solve the problem in other tasks
> which do similar sleeps...
> 

The hung_task timeout is now 480 seconds because of sys_sync:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=fb822db465bd9fd4208eef1af4490539b236c54e

But are there are really any other tasks which call
schedule_timeout_uninterruptibl() for with a timeout >480 seconds?

Right now kmemleak appears to be the only exception. (A quick grep didn't turn
anything up.) And it is trivial to change kmemleak to use INTERRUPTIBLE.
Might even be a nice feature. You could stop it faster that way.

I suspect cases where long UNINTERRUPTIBLE sleeps is the right solution are
extremely rare. Since kmemleak can be modified, maybe hold off on ignoring
schedule_timeout_uninterruptible(). Not exempting schedule_timeout_uninter*
reduces code sprawl and discourages long UNINTERRUPTIBLE sleeps.

> Mandeep, if you agree I can try something? Or perhaps you prefer to do
> it yourself. As you wish.

Nah, don't wait for me. If you have a useful patch, just send it;) I'm
actually not the maintainer of hung_task, mingo@elte.hu is, but I am more than
happy to review patches.
