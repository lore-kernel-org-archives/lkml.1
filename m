Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbZHCSIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbZHCSIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZHCSIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:08:00 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbZHCSH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:07:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=DEd5OqoYkpS94TwJ6g/I5+TjHQAneDKRV7b8qwobdUW4OdfCVsYRfUyrCRl/EfHxW
	Wm2dqwCYbO3FcWzIYlQ6A==
MIME-Version: 1.0
In-Reply-To: <20090803175452.GA5481@us.ibm.com>
References: <20090731012908.27908.62208.stgit@hastromil.mtv.corp.google.com>
	 <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com>
	 <20090803175452.GA5481@us.ibm.com>
Date: Mon, 3 Aug 2009 11:07:54 -0700
Message-ID: <6599ad830908031107l4b924a86r423c4fedc06b0040@mail.gmail.com>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by tgid 
	at once
From: Paul Menage <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Ben Blum <bblum@google.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 10:54 AM, Serge E. Hallyn<serue@us.ibm.com> wrote:
>> +     if (guarantee) {
>> +             /*
>> +              * our caller promises us that the css_set we want already
>> +              * exists, so we use find_existing_css_set directly.
>> +              */
>> +             struct cgroup_subsys_state *template[CGROUP_SUBSYS_COUNT];
>> +             read_lock(&css_set_lock);
>> +             newcg = find_existing_css_set(oldcg, cgrp, template);
>> +             BUG_ON(!newcg);
>> +             get_css_set(newcg);
>> +             read_unlock(&css_set_lock);
>> +     } else {
>> +             might_sleep();
>
> So cgroup_task_migrate() might sleep, but
>

might sleep if guarantee==0

>> +             retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, 1);
>
> Here it is called under rcu_read_lock().

With guarantee==1

>
> What *exactly* is it we are protecting with cgroup_fork_mutex?
> 'fork' (as the name implies) is not a good answer, since we should be
> protecting data, not code.  If it is solely tsk->cgroups, then perhaps
> we should in fact try switching to (s?)rcu.  Then cgroup_fork() could
> just do rcu_read_lock, while cgroup_task_migrate() would make the change
> under a spinlock (to protect against concurrent cgroup_task_migrate()s),
> and using rcu_assign_pointer to let cgroup_fork() see consistent data
> either before or after the update...  That might mean that any checks done
> before completing the migrate which involve the # of tasks might become
> invalidated before the migration completes?

What's being protected is the ability to move an entire thread group
to the new destination cgroup, even in the presence of concurrent
thread clone operations. New threads aren't visible to other threads
until the point when they're attached to the tasklist, so if any
concurrent do_fork() operation is somewhere between the call to
cgroup_fork() and the attachment to the tasklist when the "attach proc
to new cgroup" operation occurs, it may get left behind.

Paul
