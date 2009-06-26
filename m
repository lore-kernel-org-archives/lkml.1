Return-Path: <linux-kernel-owner+w=401wt.eu-S1754038AbZFZFmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbZFZFmp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 01:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZFZFme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 01:42:34 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:33748 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbZFZFmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 01:42:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=CgwpaqvNJXKkeX02pIhYHbNzMTfRvfqlr7ctzuloS9HQadSONZwtbjEkws+3lYHbWl
         buLMS7GA0xkyR4zsvalmM9B0QCp7mKRXyaHg2Td9Kh0tFGmsGH/ACi0/DoYGsQ4u/fdO
         KQB57f6XMM6CSb6FU5sb1NeQ66SgSCnNqJ7y0=
Date: Fri, 26 Jun 2009 05:42:30 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Jiri Olsa <jolsa@redhat.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] net: fix race in the receive/select
Message-ID: <20090626054230.GA5204@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0906251947530.9517@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26-06-2009 05:14, Davide Libenzi wrote:
> On Fri, 26 Jun 2009, Eric Dumazet wrote:
> 
>> I wont argue with you David, just try to correct bugs.
>>
>> fs/ext4/ioctl.c line 182
>>
>> 	set_current_state(TASK_INTERRUPTIBLE);
>> 	add_wait_queue(&EXT4_SB(sb)->ro_wait_queue, &wait);
>> 	if (timer_pending(&EXT4_SB(sb)->turn_ro_timer)) {
>> 		schedule();
>>
>> Another example of missing barrier after add_wait_queue()
>>
>> Because add_wait_queue() misses a barrier, we have to add one after each call.
>>
>> Maybe it would be safer to add barrier in add_wait_queue() itself, not in _pollwait().
> 
> Not all the code that uses add_wait_queue() does need to have the MB,
> like code that does the most common pattern:
> 
> xxx_poll(...) {
> 	poll_wait(...);
> 	lock();
> 	flags = calc_flags(->status);
> 	unlock();
> 	return flags;
> }
> 
> xxx_update(...) {
> 	lock();
> 	->status = ...;
> 	unlock();
> 	if (waitqueue_active())
> 		wake_up();
> }
> 
> It's the code that does the lockless flags calculation in ->poll that 
> might need it.
> I dunno what the amount of changes are, but cross-matching MB across 
> subsystems does not look nice.
> IMHO that's a detail of the subsystem locking, and should be confined 
> inside the subsystem itself.
> No?

How about poll_wait_mb() and waitqueue_active_mb() (with mb and
additional check for NULL of wait_queue_head)?

Jarek P.
