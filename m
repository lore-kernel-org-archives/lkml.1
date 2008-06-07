Return-Path: <linux-kernel-owner+w=401wt.eu-S1761588AbYFGOxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761588AbYFGOxQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbYFGOxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:53:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:11991 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbYFGOxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:53:00 -0400
Message-ID: <484AA0C5.9040108@colorfullife.com>
Date: Sat, 07 Jun 2008 16:52:53 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ipc/sem.c: convert sem_array.sem_pending to struct
 list_head
References: <200805241638.m4OGc4L5006320@mail.q-ag.de> <483EC693.7030808@bull.net>
In-Reply-To: <483EC693.7030808@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey wrote:
> Manfred Spraul wrote:
>> sem_array.sem_pending is a double linked list, the attached
>> patch converts it to struct list_head.
>>
>> Signed-Off-By: Manfred Spraul <manfred@colorfullife.com>
>
> Reviewed-By: Nadia Derbey <Nadia.Derbey@bull.net>
>
>>
>> @@ -438,16 +405,15 @@ static void update_queue (struct sem_array * sma)
>>      int error;
>>      struct sem_queue * q;
>>  
>> -    q = sma->sem_pending;
>> -    while(q) {
>> +    q = list_entry(sma->sem_pending.next, struct sem_queue, list);
>> +    while(&q->list != &sma->sem_pending) {
>
> I guess here you are not using list_first_entry() because the pending 
> requests might be empty?
>
Actually - no. I wasn't aware of list_first_entry().
But:
- Looking at list.h: list_first_entry() shouldn't be used on empty lists.
- the loop in update_queue() is complicated enough, some open-coding 
doesn't hurt.

>> @@ -1194,7 +1171,6 @@ asmlinkage long sys_semtimedop(int semid, 
>> struct sembuf __user *tsops,
>>  
>>      sma = sem_lock(ns, semid);
>>      if (IS_ERR(sma)) {
>> -        BUG_ON(queue.prev != NULL);
>
> Instead of removing it why not replacing the bug_ON() by a check on 
> the queue still being linked?
>
The list_del() poisoning is IMHO efficient enough.

--
    Manfred
