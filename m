Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbYAaJwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbYAaJwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 04:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbYAaJwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 04:52:09 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:42620 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbYAaJwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 04:52:05 -0500
Message-ID: <47A19A48.4000005@bull.net>
Date: Thu, 31 Jan 2008 10:52:08 +0100
From: Pierre Peiffer <pierre.peiffer@bull.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [PATCH 2.6.24-rc8-mm1 12/15] (RFC) IPC/semaphores: make use of
 RCU to free the sem_undo_list
References: <20080129160229.612172683@bull.net> <20080129162131.743970100@bull.net> <20080130212650.GA8945@sergelap.austin.rr.com>
In-Reply-To: <20080130212650.GA8945@sergelap.austin.rr.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/01/2008 11:00:45,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 31/01/2008 11:00:48,
	Serialize complete at 31/01/2008 11:00:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting pierre.peiffer@bull.net (pierre.peiffer@bull.net):
>> From: Pierre Peiffer <pierre.peiffer@bull.net>
>>
>> Today, the sem_undo_list is freed when the last task using it exits.
>> There is no mechanism in place, that allows a safe concurrent access to
>> the sem_undo_list of a target task and protects efficiently against a
>> task-exit.
>>
>> That is okay for now as we don't need this.
>>
>> As I would like to provide a /proc interface to access this data, I need
>> such a safe access, without blocking the target task if possible. 
>>
>> This patch proposes to introduce the use of RCU to delay the real free of
>> these sem_undo_list structures. They can then be accessed in a safe manner
>> by any tasks inside read critical section, this way:
>>
>> 	struct sem_undo_list *undo_list;
>> 	int ret;
>> 	...
>> 	rcu_read_lock();
>> 	undo_list = rcu_dereference(task->sysvsem.undo_list);
>> 	if (undo_list)
>> 		ret = atomic_inc_not_zero(&undo_list->refcnt);
>> 	rcu_read_unlock();
>> 	...
>> 	if (undo_list && ret) {
>> 		/* section where undo_list can be used quietly */
>> 		...
>> 	}
>> 	...
> 
> And of course then
> 
> 	if (atomic_dec_and_test(&undo_list->refcnt))
> 		free_semundo_list(undo_list);
> 
> by that task.
> 

I will precise this too.

>> Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
> 
> Looks correct in terms of locking/refcounting.
> 
> Signed-off-by: Serge Hallyn <serue@us.ibm.com>
> 

Thanks !

-- 
Pierre

