Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbZFZDTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbZFZDTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 23:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbZFZDSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 23:18:52 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42670 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbZFZDSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 23:18:50 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 25 Jun 2009 20:14:22 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] net: fix race in the receive/select
In-Reply-To: <4A443033.8060401@gmail.com>
Message-ID: <alpine.DEB.1.10.0906251947530.9517@makko.or.mcafeemobile.com>
References: <20090625122545.GA3625@jolsa.lab.eng.brq.redhat.com> <20090625122416.GA23613@redhat.com> <alpine.DEB.1.10.0906251827510.9517@makko.or.mcafeemobile.com> <4A442B65.8040701@gmail.com> <alpine.DEB.1.10.0906251858520.9517@makko.or.mcafeemobile.com>
 <4A443033.8060401@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Eric Dumazet wrote:

> I wont argue with you David, just try to correct bugs.
> 
> fs/ext4/ioctl.c line 182
> 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	add_wait_queue(&EXT4_SB(sb)->ro_wait_queue, &wait);
> 	if (timer_pending(&EXT4_SB(sb)->turn_ro_timer)) {
> 		schedule();
> 
> Another example of missing barrier after add_wait_queue()
> 
> Because add_wait_queue() misses a barrier, we have to add one after each call.
> 
> Maybe it would be safer to add barrier in add_wait_queue() itself, not in _pollwait().

Not all the code that uses add_wait_queue() does need to have the MB,
like code that does the most common pattern:

xxx_poll(...) {
	poll_wait(...);
	lock();
	flags = calc_flags(->status);
	unlock();
	return flags;
}

xxx_update(...) {
	lock();
	->status = ...;
	unlock();
	if (waitqueue_active())
		wake_up();
}

It's the code that does the lockless flags calculation in ->poll that 
might need it.
I dunno what the amount of changes are, but cross-matching MB across 
subsystems does not look nice.
IMHO that's a detail of the subsystem locking, and should be confined 
inside the subsystem itself.
No?



- Davide


