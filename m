Return-Path: <linux-kernel-owner+w=401wt.eu-S1765065AbYEUBtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765065AbYEUBtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756920AbYEUBtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:49:06 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:62038 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbYEUBtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:49:04 -0400
Message-ID: <48337F5C.2040601@bk.jp.nec.com>
Date: Wed, 21 May 2008 10:48:12 +0900
From: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kill_something_info: don't take tasklist_lock for pid==-1
 case
References: <47E87F2A.2040303@bk.jp.nec.com> <20080325135645.GA96@tv-sign.ru>
In-Reply-To: <20080325135645.GA96@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 03/25, Atsushi Tsuji wrote:
>> This patch avoid taking tasklist_lock in kill_something_info() when
>> the pid is -1. It can convert to rcu_read_lock() for this case because
>> group_send_sig_info() doesn't need tasklist_lock.
>>
>> This patch is for 2.6.25-rc5-mm1.
>>
>> Signed-off-by: Atsushi Tsuji <a-tsuji@bk.jp.nec.com>
>
> Except: We don't send the signal to /sbin/init. This means that (say)
> kill(-1, SIGKILL) can miss the task forked by init. Note that this
> task could be forked even before we start kill_something_info(), but
> without tasklist there is no guarantee we will see it on the ->tasks
> list.
> 
> I think this is the only problem with this change.

Sorry for late reply and thank you for your comment. I understood the
mechanism that kill(-1, SIGKILL) can miss the tasks forked by init
(and the thread group of the current process, because we don't also
send the signal to them). If kill(-1, SIGKILL) finish before the
forking init process does list_add_tail_rcu(p->tasks) in
copy_process(), the process forked by init appears on the ->tasks list
after that.  Is that right?

If so, I think this problem can happen without my patch.
Because even if kill(-1, SIGKILL) take read_lock(&tasklist_lock) in
kill_something_info(), it can finish before init process take
write_lock(&tasklist_lock) in copy_process(). So the forked process
appears after that, too.

Now, I noticed the important problem. I found the tasklist lock in
kill_something_info() can cause stall when some processes execute
kill(-1,SIGCONT) concurrently. It can happen even if a system has
only 4 CPUs (and even if a user is not privileged (not root)).  This is
because the writer cannot take the tasklist lock when a lot of readers
exist and keep holding it.

This allows a local DoS. So we have to avoid that stall. The
conversion from the tasklist lock to rcu_read_lock() can solve this
problem. I think my patch doesn't make the new problem because the
problem that kill can miss the tasks have originally occurred without
my one. If there is no problem, could you ack it?

Thanks,
-Atsushi Tsuji

