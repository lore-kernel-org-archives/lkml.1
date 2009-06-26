Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbZFZCUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbZFZCUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZFZCUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:20:00 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:34291 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZFZCUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:20:00 -0400
Message-ID: <4A443033.8060401@gmail.com>
Date: Fri, 26 Jun 2009 04:19:31 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Oleg Nesterov <oleg@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] net: fix race in the receive/select
References: <20090625122545.GA3625@jolsa.lab.eng.brq.redhat.com> <20090625122416.GA23613@redhat.com> <alpine.DEB.1.10.0906251827510.9517@makko.or.mcafeemobile.com> <4A442B65.8040701@gmail.com> <alpine.DEB.1.10.0906251858520.9517@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0906251858520.9517@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 26 Jun 2009 04:19:43 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi a écrit :
> On Fri, 26 Jun 2009, Eric Dumazet wrote:
> 
>> Davide Libenzi a écrit :
>>> On Thu, 25 Jun 2009, Oleg Nesterov wrote:
>>>
>>>> Can't really comment this patch, except this all looks reasonable to me.
>>>> Add more CCs.
>>> While this can work, IMO it'd be cleaner to have the smp_mb() moved from 
>>> fs/select.c to the ->poll() function.
>>> Having a barrier that matches another one in another susbsystem, because 
>>> of the special locking logic of such subsystem, is not too shiny IMHO.
>>>
>> Yes but barrier is necessary only if add_wait_queue() was actually called, and __pollwait()
>> does this call.
>>
>> Adding a plain smp_mb() in tcp_poll() for example would slowdown select()/poll() with NULL
>> timeout.
> 
> Do you think of it as good design adding an MB on a subsystem, because of 
> the special locking logic of another one?
> The (eventual) slowdown, IMO can be argued sideways, by saying that 
> non-socket users will pay the price for their polls.
> 

I wont argue with you David, just try to correct bugs.

fs/ext4/ioctl.c line 182

	set_current_state(TASK_INTERRUPTIBLE);
	add_wait_queue(&EXT4_SB(sb)->ro_wait_queue, &wait);
	if (timer_pending(&EXT4_SB(sb)->turn_ro_timer)) {
		schedule();

Another example of missing barrier after add_wait_queue()

Because add_wait_queue() misses a barrier, we have to add one after each call.

Maybe it would be safer to add barrier in add_wait_queue() itself, not in _pollwait().

