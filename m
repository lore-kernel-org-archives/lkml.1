Return-Path: <linux-kernel-owner+w=401wt.eu-S964917AbXCGHKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964917AbXCGHKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964931AbXCGHKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:10:22 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:48489 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964917AbXCGHKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:10:20 -0500
Message-ID: <45EE6601.4070107@sw.ru>
Date: Wed, 07 Mar 2007 10:13:05 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@osdl.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, Kirill Korotaev <dev@sw.ru>
Subject: Re: [RFC][PATCH 6/7] Account for the number of tasks within container
References: <45ED7DEC.7010403@sw.ru> <45ED831A.5030108@sw.ru> <6599ad830703061800n38244a8fp68b29fa0290d18d7@mail.gmail.com>
In-Reply-To: <6599ad830703061800n38244a8fp68b29fa0290d18d7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Hi Pavel,
> 
> On 3/6/07, Pavel Emelianov <xemul@sw.ru> wrote:
>> diff -upr linux-2.6.20.orig/include/linux/sched.h
>> linux-2.6.20-0/include/linux/sched.h
>> --- linux-2.6.20.orig/include/linux/sched.h     2007-03-06
>> 13:33:28.000000000 +0300
>> +++ linux-2.6.20-0/include/linux/sched.h        2007-03-06
>> 13:33:28.000000000 +0300
>> @@ -1052,6 +1055,9 @@ struct task_struct {
>>  #ifdef CONFIG_FAULT_INJECTION
>>         int make_it_fail;
>>  #endif
>> +#ifdef CONFIG_PROCESS_CONTAINER
>> +       struct numproc_container *numproc_cnt;
>> +#endif
>>  };
> 
> Why do you need a pointer added to task_struct? One of the main points
> of the generic containers is to avoid every different subsystem and
> resource controller having to add new pointers there.
> 
>> +
>> +       rcu_read_lock();
>> +       np = numproc_from_cont(task_container(current, &numproc_subsys));
>> +       css_get_current(&np->css);
> 
> There's no need to hold a reference here - by definition, the task's
> container can't go away while the task is in it.
> 
> Also, shouldn't you have an attach() method to move the count from one
> container to another when a task moves?

The idea is:

Task may be "the entity that allocates the resources" and "the
entity that is a resource allocated".

When task is the first entity it may move across containers
(that is implemented in your patches). When task is a resource
it shouldn't move across containers like files or pages do.

More generally - allocated resources hold reference to original
container till they die. No resource migration is performed.

Did I express my idea cleanly?

> Paul
> 

