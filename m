Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYEZHF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYEZHF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 03:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYEZHFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 03:05:20 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58886 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYEZHFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 03:05:19 -0400
Message-ID: <483A60DE.7080306@bk.jp.nec.com>
Date: Mon, 26 May 2008 16:03:58 +0900
From: Atsushi TSUJI <a-tsuji@bk.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] kill_something_info: don't take tasklist_lock for pid==-1
 case
References: <47E87F2A.2040303@bk.jp.nec.com> <20080325135645.GA96@tv-sign.ru> <m18wy45nej.fsf@frodo.ebiederm.org>
In-Reply-To: <m18wy45nej.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Thank you for your comments.

Eric W. Biederman wrote:
> Sorry for the very delayed response.  I have been moving and overwhelmed
> with everything.
> 
> Oleg Nesterov <oleg@tv-sign.ru> writes:
> 
>> On 03/25, Atsushi Tsuji wrote:
>>> This patch avoid taking tasklist_lock in kill_something_info() when
>>> the pid is -1. It can convert to rcu_read_lock() for this case because
>>> group_send_sig_info() doesn't need tasklist_lock.
>>>
>>> This patch is for 2.6.25-rc5-mm1.
>>>
> 
>> Hmm. Yes, group_send_sig_info() doesn't need tasklist_lock. But we
>> take tasklist_lock to "freeze" the tasks list, so that we can't miss
>> a new forked process.
>>
>> Same for __kill_pgrp_info(), we take tasklist to kill the whole group
>> "atomically".
>>
>>
>> However. Is it really needed? copy_process() returns -ERESTARTNOINTR
>> if signal_pending(), and the new task is always placed at the tail
>> of the list. Looks like nobody can escape the signal, at least fatal
>> or SIGSTOP.
> 
> 
> Call me paranoid but I don't think there is any guarantee without a lock
> that we will hit the -ERESTARTNOITR check for new processes.  I think we
> have a slight race where the fork process may not have received the signal
> (because it is near the tail of the list) but the new process would be
> added to the list immediately after we read it's pointer.

I know it might happen some races, but, as Oleg say, it is no problem
on the user side. Users cannot realize whether the process forked
during kill or after. We can pretend it was forked after kill
finished. So I think the change to convert tasklist_lock to
rcu_read_lock is reasonable way to avoid the local DOS for kill(-1,sig) case.

>> (Unfortunately, attach_pid() adds the task to the head of hlist, this
>>  means we can't avoid tasklist for __kill_pgrp_info).
> 
> Probably.  If there wasn't a chance of sending a signal twice we
> could rescan the list if the head changed.
> 
> What we might be able to do is to switch the tasklist_lock into a seq_lock.
> like was done for the dcache.  The challenge is how to avoid resending
> a signal when we retry.  Store the sequence number in the sighand_struct?
> 
> If we had a magic place that children could check. To see if they belonged
> to a group of processes that was exiting that might help.

I think this idea is good for __kill_pgrp_info(), but it is a big change.

Thanks,
-Atsushi Tsuji
