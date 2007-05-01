Return-Path: <linux-kernel-owner+w=401wt.eu-S1423560AbXEAGOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423560AbXEAGOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 02:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423569AbXEAGOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 02:14:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34754 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423560AbXEAGOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 02:14:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Neil Brown <neilb@suse.de>
Cc: "<Andrew Morton" <akpm@osdl.org>, <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md: Remove broken SIGKILL support
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<1176969641308-git-send-email-ebiederm@xmission.com>
	<17974.36380.681276.553949@notabene.brown>
Date: Tue, 01 May 2007 00:13:45 -0600
In-Reply-To: <17974.36380.681276.553949@notabene.brown> (Neil Brown's message
	of "Tue, 1 May 2007 10:47:24 +1000")
Message-ID: <m1hcqxysti.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown <neilb@suse.de> writes:

> On Thursday April 19, ebiederm@xmission.com wrote:
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> 
>> Currently md_thread calls allow_signal so it can receive a
>> SIGKILL but then does nothing with it except flush the
>> sigkill so that it not can use an interruptible sleep.
>> 
>> This whole dance is silly so remove the unnecessary
>> and broken signal handling logic.
>
> (sorry of the delay in replying)
>
> You missed some related code which should help you see that it is -
> maybe - not completely 'silly' (though I confess it might be slightly
> broken).
> In md_check_recovery:
>
> 	if (signal_pending(current)) {
> 		if (mddev->pers->sync_request) {
> 			printk(KERN_INFO "md: %s in immediate safe mode\n",
> 			       mdname(mddev));
> 			mddev->safemode = 2;
> 		}
> 		flush_signals(current);
> 	}

Thanks.

> The idea is that alt-sysrq-K will send SIGKILL to all processes
> including the md support threads, which will cause them to enter
> "immediate safe mode" so that the metadata will be marked clean
> immediately at every opportunity.  That way you can use alt-sysrq:
>   sync,unmount,kill,reboot
> and be fairly sure that you md array will be shut down cleanly.
>
> I'd be just as happy to link this into Unmount (aka
> do_emergency_remount), but that doesn't seem at all straight forward,
> and in any case should be done before the current code is ripped out.
>
> While we do have a reboot_notifier which tries to stop all arrays,
> I've never been comfortable with that.  A reboot really should just
> reboot... 
>
> What I would REALLY like is for the block device to know whether it is
> open read-only or read-write.  Then I could mark it clean when it
> becomes read-only as would happen when do_emergency_remount remounts
> it read-only.
>
> I might see how hard that would be...

My goal to get signals to kernel threads out of the user space interface
especially for non-privileged processes, so everything that we do with
kernel threads can just be an unimportant implementation detail to user
space.

Eric
