Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZJFHAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZJFHAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbZJFHAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:00:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZJFHAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:00:51 -0400
Message-ID: <4ACAEB6D.2020601@redhat.com>
Date: Tue, 06 Oct 2009 15:02:05 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, Brian Behlendorf <behlendorf1@llnl.gov>,
       Ben Woodard <bwoodard@llnl.gov>, Stable Team <stable@kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [Patch v2] rwsem: fix rwsem_is_locked() bugs
References: <20091005063919.3958.65581.sendpatchset@localhost.localdomain> <22214.1254748402@redhat.com>
In-Reply-To: <22214.1254748402@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Amerigo Wang <amwang@redhat.com> wrote:
> 
>> -	return (sem->activity != 0);
>> +	return !(sem->activity == 0 && list_empty(&sem->wait_list));
> 
> This needs to be done in the opposite order with an smp_rmb() between[*], I
> think, because the someone releasing the lock will first reduce activity to
> zero, and then attempt to empty the list, so with your altered code as it
> stands, you can get:
> 
> 	CPU 1				CPU 2
> 	===============================	===============================
> 	[sem is read locked, 1 queued writer]
> 	-->up_read()
> 	sem->activity--			-->rwsem_is_locked()
> 	[sem->activity now 0]		sem->activity == 0 [true]
> 					<interrupt>
> 	-->__rwsem_do_wake()
> 	sem->activity = -1
> 	[sem->activity now !=0]
> 	list_del()
> 	[sem->wait_list now empty]	</interrupt>
> 					list_empty(&sem->wait_list) [true]
> 	wake_up_process()
> 	<--__rwsem_do_wake()
> 	<--up_read()
> 	[sem is write locked]		return false [ie. sem is not locked]
> 
> In fact, I don't think even swapping things around addresses the problem.  You
> do not prevent the state inside the sem changing under you whilst you try to
> interpret it.

Hmm, right. I think we have to disable irq and preempt here, so
probably spin_trylock_irq() is a good choice.

Since if we have locks, we don't need memory barriers any more, right?

I just sent out the updated patch.

Thanks!
