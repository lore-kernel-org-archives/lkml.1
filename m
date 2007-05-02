Return-Path: <linux-kernel-owner+w=401wt.eu-S2992698AbXEBD60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992698AbXEBD60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 23:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992704AbXEBD60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 23:58:26 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:50571 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992702AbXEBD6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 23:58:24 -0400
Message-ID: <46380C49.3070404@linux.vnet.ibm.com>
Date: Wed, 02 May 2007 09:28:01 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru, containers@lists.osdl.org,
       pj@sgi.com, devel@openvz.org, ebiederm@xmission.com, mbligh@google.com,
       rohitseth@google.com, serue@us.ibm.com, akpm@linux-foundation.org,
       svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 3/9] Containers (V9): Add tasks file interface
References: <20070427104607.252541000@menage.corp.google.com> <20070427111300.406327000@menage.corp.google.com> <46378311.6000703@linux.vnet.ibm.com> <6599ad830705011337r6f200baen841919ac17c6f38b@mail.gmail.com>
In-Reply-To: <6599ad830705011337r6f200baen841919ac17c6f38b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 5/1/07, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>> > +     if (container_is_removed(cont)) {
>> > +             retval = -ENODEV;
>> > +             goto out2;
>> > +     }
>>
>> Can't we make this check prior to kmalloc() and copy_from_user()?
> 
> We could but I'm not sure what it would buy us - we'd be optimizing
> for the case that essentially never occurs.
> 

I am not sure about the never occurs part of it, because we check
for the condition, so it could occur. I agree, it is a premature
optimization and could wait a little longer before going in.

>>
>>
>>
>> > +int container_task_count(const struct container *cont) {
>> > +     int count = 0;
>> > +     struct task_struct *g, *p;
>> > +     struct container_subsys_state *css;
>> > +     int subsys_id;
>> > +     get_first_subsys(cont, &css, &subsys_id);
>> > +
>> > +     read_lock(&tasklist_lock);
>>
>> Can be replaced with rcu_read_lock() and rcu_read_unlock()
> 
> Are you sure about that? I see many users of
> do_each_thread()/while_each_thread() taking a lock on tasklist_lock,
> and only one (fs/binfmt_elf.c) that's clearly relying on an RCU
> critical sections. Documentation?
> 

I suspect they are all pending conversions to be made.
Eric is the expert on this. Meanwhile here's a couple of
pointers. Quoting from the second URL

"We don't need the tasklist_lock to safely iterate through processes
anymore."

http://www.linuxjournal.com/article/6993 (please see incremental use
of RCU) and
http://kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.17/2.6.17-mm2/broken-out/proc-remove-tasklist_lock-from-proc_pid_readdir.patch

>>
>> Any chance we could get a per-container task list? It will
>> help subsystem writers as well.
> 
> It would be possible, yes - but we probably wouldn't want the overhead
> (additional ref counts and list manipulations on every fork/exit) of
> it on by default. We could make it a config option that particular
> subsystems could select.
> 
> I guess the question is how useful is this really, compared to just
> doing a do_each_thread() and seeing which tasks are in the container?
> Certainly that's a non-trivial operation, but in what circumstances is
> it really necessary to do it?
> 
> Paul


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
