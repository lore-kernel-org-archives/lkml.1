Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYHBHjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYHBHjs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 03:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbYHBHjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 03:39:40 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:35958 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYHBHjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 03:39:39 -0400
Message-ID: <48940F0F.4050604@fr.ibm.com>
Date: Sat, 02 Aug 2008 09:38:55 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 3/6] Container Freezer: Implement freezer cgroup subsystem
References: <20080801050659.924495279@us.ibm.com> <20080801050700.797996261@us.ibm.com>  <200808020058.37407.rjw@sisk.pl> <1217635891.25300.292.camel@localhost.localdomain>
In-Reply-To: <1217635891.25300.292.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley wrote:
> On Sat, 2008-08-02 at 00:58 +0200, Rafael J. Wysocki wrote:
>> On Friday, 1 of August 2008, Matt Helsley wrote:
>>> This patch implements a new freezer subsystem in the control groups framework.
>>> It provides a way to stop and resume execution of all tasks in a cgroup by
>>> writing in the cgroup filesystem.
>>>
>>> The freezer subsystem in the container filesystem defines a file named
>>> freezer.state. Writing "FROZEN" to the state file will freeze all tasks in the
>>> cgroup. Subsequently writing "RUNNING" will unfreeze the tasks in the cgroup.
>>> Reading will return the current state.
>>>
>>> * Examples of usage :
>>>
>>>    # mkdir /containers/freezer
>>>    # mount -t cgroup -ofreezer freezer  /containers
>>>    # mkdir /containers/0
>>>    # echo $some_pid > /containers/0/tasks
>>>
>>> to get status of the freezer subsystem :
>>>
>>>    # cat /containers/0/freezer.state
>>>    RUNNING
>>>
>>> to freeze all tasks in the container :
>>>
>>>    # echo FROZEN > /containers/0/freezer.state
>>>    # cat /containers/0/freezer.state
>>>    FREEZING
>>>    # cat /containers/0/freezer.state
>>>    FROZEN
>>>
>>> to unfreeze all tasks in the container :
>>>
>>>    # echo RUNNING > /containers/0/freezer.state
>>>    # cat /containers/0/freezer.state
>>>    RUNNING
>>>
>>> This is the basic mechanism which should do the right thing for user space task
>>> in a simple scenario.
>>>
>>> It's important to note that freezing can be incomplete. In that case we return
>>> EBUSY. This means that some tasks in the cgroup are busy doing something that
>>> prevents us from completely freezing the cgroup at this time. After EBUSY,
>>> the cgroup will remain partially frozen -- reflected by freezer.state reporting
>>> "FREEZING" when read. The state will remain "FREEZING" until one of these
>>> things happens:
>>>
>>> 	1) Userspace cancels the freezing operation by writing "RUNNING" to
>>> 		the freezer.state file
>>> 	2) Userspace retries the freezing operation by writing "FROZEN" to
>>> 		the freezer.state file (writing "FREEZING" is not legal
>>> 		and returns EIO)
>>> 	3) The tasks that blocked the cgroup from entering the "FROZEN"
>>> 		state disappear from the cgroup's set of tasks.
>>>
>>> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
>>> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
>>> Acked-by: Serge E. Hallyn <serue@us.ibm.com>
>>> Tested-by: Matt Helsley <matthltc@us.ibm.com>
>>> ---
>>>  include/linux/cgroup_freezer.h |   71 ++++++++
>>>  include/linux/cgroup_subsys.h  |    6 
>>>  include/linux/freezer.h        |   16 +-
>>>  init/Kconfig                   |    7 
>>>  kernel/Makefile                |    1 
>>>  kernel/cgroup_freezer.c        |  328 +++++++++++++++++++++++++++++++++++++++++
>>>  6 files changed, 425 insertions(+), 4 deletions(-)
>>>  create mode 100644 include/linux/cgroup_freezer.h
>>>  create mode 100644 kernel/cgroup_freezer.c
>>>
>>> Index: linux-2.6.27-rc1-mm1/include/linux/cgroup_freezer.h
>>> ===================================================================
>>> --- /dev/null
>>> +++ linux-2.6.27-rc1-mm1/include/linux/cgroup_freezer.h
>>> @@ -0,0 +1,71 @@
>>> +#ifndef _LINUX_CGROUP_FREEZER_H
>>> +#define _LINUX_CGROUP_FREEZER_H
>>> +/*
>>> + * cgroup_freezer.h -  control group freezer subsystem interface
>>> + *
>>> + * Copyright IBM Corporation, 2007
>>> + *
>>> + * Author : Cedric Le Goater <clg@fr.ibm.com>
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms of version 2.1 of the GNU Lesser General Public License
>>> + * as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it would be useful, but
>>> + * WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>>> + */
>>> +
>>> +#include <linux/cgroup.h>
>>> +
>>> +#ifdef CONFIG_CGROUP_FREEZER
>>> +
>>> +enum freezer_state {
>>> +	STATE_RUNNING = 0,
>>> +	STATE_FREEZING,
>>> +	STATE_FROZEN,
>>> +};
>>> +
>>> +struct freezer {
>>> +	struct cgroup_subsys_state css;
>>> +	enum freezer_state state;
>>> +	spinlock_t lock; /* protects _writes_ to state */
>>> +};
>>> +
>>> +static inline struct freezer *cgroup_freezer(
>>> +		struct cgroup *cgroup)
>>> +{
>>> +	return container_of(
>>> +		cgroup_subsys_state(cgroup, freezer_subsys_id),
>>> +		struct freezer, css);
>>> +}
>>> +
>>> +static inline struct freezer *task_freezer(struct task_struct *task)
>>> +{
>>> +	return container_of(task_subsys_state(task, freezer_subsys_id),
>>> +			    struct freezer, css);
>>> +}
>>> +
>>> +static inline int cgroup_frozen(struct task_struct *task)
>>> +{
>>> +	struct freezer *freezer;
>>> +	enum freezer_state state;
>>> +
>>> +	task_lock(task);
>>> +	freezer = task_freezer(task);
>>> +	state = freezer->state;
>>> +	task_unlock(task);
>>> +
>>> +	return state == STATE_FROZEN;
>>> +}
>>> +
>>> +#else /* !CONFIG_CGROUP_FREEZER */
>>> +
>>> +static inline int cgroup_frozen(struct task_struct *task)
>>> +{
>>> +	return 0;
>>> +}
>>> +
>>> +#endif /* !CONFIG_CGROUP_FREEZER */
>>> +
>>> +#endif /* _LINUX_CGROUP_FREEZER_H */
>> Hmm.  I wonder if we really need a separate file for this.  I'd prefer it to be
>> in freezer.h, unless there's a good reason not to place it in there.
> 
> 	Yeah, it's a pretty small header so combining it with another header
> would be nice. However if we combine it with freezer.h we'd be including
> cgroup.h in unrelated filesystem code. An alternative might be to put it
> into a cgroup header for "small" subsystems (which might just be
> cgroup.h for now..).
> 
> Thanks for the review!

I'm not sure the inline is really useful. In that case, we could probably do 
something like the following : 

include/linux/freezer.h :

	#ifdef CONFIG_CGROUP_FREEZER

	extern int cgroup_frozen(struct task_struct *task);

	#else /* !CONFIG_CGROUP_FREEZER */

	static inline int cgroup_frozen(struct task_struct *task)
	{
		return 0;
	}

	#endif /* !CONFIG_CGROUP_FREEZER */

and in kernel/cgroup_freezer.c:

	int cgroup_frozen(struct task_struct *task)
	{
		struct freezer *freezer;
		enum freezer_state state;

		task_lock(task);
		freezer = task_freezer(task);
		state = freezer->state;
		task_unlock(task);

		return state == STATE_FROZEN;
	}

and kill include/linux/cgroup_freezer.h ? 

Thanks Matt,

C.



