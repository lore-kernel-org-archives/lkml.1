Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYJJIjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYJJIjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYJJIjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:39:31 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:61361 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYJJIja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:39:30 -0400
Message-ID: <48EF144D.1050906@fr.ibm.com>
Date: Fri, 10 Oct 2008 10:37:33 +0200
From: Daniel Lezcano <dlezcano@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg Kurz <gkurz@fr.ibm.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/2] Track in-kernel when we expect checkpoint/restart
 to work
References: <20081009190405.13A253CB@kernel> <1223626834.8787.8.camel@localhost.localdomain>
In-Reply-To: <1223626834.8787.8.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kurz wrote:
> On Thu, 2008-10-09 at 12:04 -0700, Dave Hansen wrote:
>> Suggested by Ingo.
>>
>> Checkpoint/restart is going to be a long effort to get things working.
>> We're going to have a lot of things that we know just don't work for
>> a long time.  That doesn't mean that it will be useless, it just means
>> that there's some complicated features that we are going to have to
>> work incrementally to fix.
>>
>> This patch introduces a new mechanism to help the checkpoint/restart
>> developers.  A new function pair: task/process_deny_checkpoint() is
>> created.  When called, these tell the kernel that we *know* that the
>> process has performed some activity that will keep it from being
>> properly checkpointed.
>>
>> The 'flag' is an atomic_t for now so that we can have some level
>> of atomicity and make sure to only warn once.
>>
>> For now, this is a one-way trip.  Once a process is no longer
>> 'may_checkpoint' capable, neither it nor its children ever will be.
>> This can, of course, be fixed up in the future.  We might want to
>> reset the flag when a new pid namespace is created, for instance.
>>
> 
> Then this patch should be described as:
> 
> Track in-kernel when we expect checkpoint/restart to fail.
> 
> By the way, why don't you introduce the reverse operation ?

I think implementing the reverse operation will be a nightmare, IMHO it 
is safe to say we deny checkpointing for the process life-cycle either 
if the created resource was destroyed before we initiate the checkpoint.

For example, you create a socket, the process becomes uncheckpointable, 
you close (via sys_close) the socket, you have to track this close to be 
related to the socket which made the process uncheckpointable in order 
to make the operation reversible.

Let's imagine you implement this reverse operation anyway, you have a 
process which creates a TCP connection, writes data and close the socket 
(so you are again checkpointable), but in the namespace there is the 
orphan socket which is not checkpointable yet and you missed this case.
