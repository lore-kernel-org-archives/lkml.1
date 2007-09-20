Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbXITNDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbXITNDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbXITNDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:03:17 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49229 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101AbXITNDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:03:16 -0400
Message-ID: <46F270DA.5030101@bull.net>
Date: Thu, 20 Sep 2007 15:08:42 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
References: <20070919140726.GA4603@ff.dom.local> <46F2123A.9070201@bull.net> <20070920072821.GA2065@ff.dom.local> <46F234DB.7030403@bull.net>
In-Reply-To: <46F234DB.7030403@bull.net>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/09/2007 15:09:06,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 20/09/2007 15:09:08,
	Serialize complete at 20/09/2007 15:09:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey wrote:
> Jarek Poplawski wrote:
> 
>> On Thu, Sep 20, 2007 at 08:24:58AM +0200, Nadia Derbey wrote:
>>
>>> Jarek Poplawski wrote:
>>>
>>>> On 18-09-2007 16:55, Nadia Derbey wrote:
>>>> ...
>>>>
>>>>
>>>>> Well, reviewing the code I found another place where the 
>>>>> rcu_read_unlock() was missing.
>>>>> I'm so sorry for the inconvenience. It's true that I should have 
>>>>> tested with CONFIG_PREEMPT=y :-(
>>>>> Now, the ltp tests pass even with this option set...
>>>>>
>>>>> In attachment you'll find a patch thhat
>>>>> 1) adds the missing rcu_read_unlock()
>>>>> 2) replaces Andrew's fix with a new one: the rcu_read_lock() is now 
>>>>> taken in ipc_lock() / ipc_lock_by_ptr() and released in 
>>>>> ipc_unlock(), exactly as it was done in the ref code.
>>>>
>>>>
>>>>
>>>> BTW, probably I miss something, but I wonder, how this RCU is working
>>>> here. E.g. in msg.c do_msgsnd() there is:
>>>>
>>>> msq = msg_lock_check(ns, msqid);
>>>> ...
>>>>
>>>> msg_unlock(msq);
>>>> schedule();
>>>>
>>>> ipc_lock_by_ptr(&msq->q_perm);
>>>>
>>>> Since msq_lock_check() gets msq with ipc_lock_check() under
>>>> rcu_read_lock(), and then goes msg_unlock(msq) (i.e. ipc_unlock())
>>>> with rcu_read_unlock(), is it valid to use this with
>>>> ipc_lock_by_ptr() yet?
>>>
>>>
>>> Before Calling msg_unlock() they call ipc_rcu_getref() that 
>>> increments a refcount in the rcu header for the msg structure. This 
>>> guarantees that the the structure won't be freed before they relock 
>>> it. Once the structure is relocked by ipc_lock_by_ptr(), they do the 
>>> symmetric operation i.e. ipc_rcu_putref().
>>
>>
>>
>> Yes, I've found this later too - sorry for bothering. I was mislead
>> by the code like this:
>>
>> struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
>> {
>>         struct kern_ipc_perm *out;
>>         int lid = ipcid_to_idx(id);
>>
>>         rcu_read_lock();
>>         out = idr_find(&ids->ipcs_idr, lid);
>>         if (out == NULL) {
>>                 rcu_read_unlock();
>>                 return ERR_PTR(-EINVAL);
>>         }
>>
>> which seems to suggest "out" is an RCU protected pointer, so, I
>> thought these refcounts were for something else. But, after looking
>> at how it's used it turns out to be ~90% wrong: probably 9 out of 10
>> places use refcouning around this,
> 
> 
> Actually, ipc_lock() is called most of the time without the 
> ipc_ids.mutex held and without refcounting (maybe you didn't look for 
> the msg_lock() sem_lock() and shm_lock() too).
> So I think disabling preemption is needed, isn't it?
> 
>> so, these rcu_read_locks() don't
>> work here at all. So, probably I miss something again, but IMHO,
>> these rcu_read_locks/unlocks could be removed here or in
>> ipc_lock_by_ptr() and it should be enough to use them directly, where
>> really needed, e.g., in msg.c do_msgrcv().
>>
> 
> I have to check for the ipc_lock_by_ptr(): may be you're right!
> 

So, here is the ipc_lock_by_ptr() status:
1) do_msgsnd(), semctl_main(GETALL), semctl_main(SETALL) and find_undo() 
call it inside a refcounting.
   ==> no rcu read section needed.

2) *_exit_ns(), ipc_findkey() and sysvipc_find_ipc() call it under the 
ipc_ids mutex lock.
   ==> no rcu read section needed.

3) do_msgrcv() is the only path where ipc_lock_by_ptr() is not called 
under refcounting
   ==> rcu read section + some more checks needed once the spnlock is
       taken.

So I completely agree with you: we might remove the rcu_read_lock() from 
the ipc_lock_by_ptr() and explicitley  call it when needed (actually, it 
is already explicitly called in do_msgrcv()).

Regards,
Nadia

