Return-Path: <linux-kernel-owner+w=401wt.eu-S1752234AbXCQRDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbXCQRDG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 13:03:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752440AbXCQRDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 13:03:06 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57984 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbXCQRDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 13:03:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, containers@lists.osdl.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + remove-the-likelypid-check-in-copy_process.patch added to -mm tree
References: <20070316170255.GA194@tv-sign.ru>
	<m1y7lxm4cc.fsf@ebiederm.dsl.xmission.com>
	<20070317130216.GA78@tv-sign.ru>
	<m1k5xgklun.fsf@ebiederm.dsl.xmission.com>
	<20070317150949.GA302@tv-sign.ru> <20070317152437.GA365@tv-sign.ru>
Date: Sat, 17 Mar 2007 11:01:50 -0600
In-Reply-To: <20070317152437.GA365@tv-sign.ru> (Oleg Nesterov's message of
	"Sat, 17 Mar 2007 18:24:37 +0300")
Message-ID: <m1fy83ls75.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> On 03/17, Oleg Nesterov wrote:
>>
>> > Well the initial kernel process does not have a struct pid so when
>> > it's children start doing:
>> > 	attach_pid(p, PIDTYPE_PGID, task_group(p));
>> > 	attach_pid(p, PIDTYPE_SID, task_session(p));
>> > We will get an oops.
>> 
>> So far this is the only reason to have init_struct_pid. Because the
>> boot CPU (swapper) forks, right?
>
> Damn. I am afraid I was not clear again :) Not init_struct_pid, but
>
> 	+ .pids = { \
> 	+ [PIDTYPE_PID] = INIT_PID_LINK(PIDTYPE_PID), \
> 	+ [PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID), \
> 	+ [PIDTYPE_SID] = INIT_PID_LINK(PIDTYPE_SID), \
> 	+ }, \
>
> for INIT_TASK().
>
>> > So a dummy unhashed struct pid was added for the idle threads.
>> > Allowing several special cases in the code to be removed.
>> > 
>> > With that chance the previous special case to force the idle thread
>> > init session 1 pgrp 1 no longer works because attach_pid no longer
>> > looks at the pid value but instead at the struct pid pointers.
>> > 
>> > So we had to add the __set_special_pids() to continue to keep init
>> > in session 1 pgrp 1.  Since /sbin/init calls setsid() that our setting
>> > the sid and the pgrp may not be strictly necessary.  Still is better
>> > to not take any chances.
>> 
>> Yes, yes, I see. But my (very unclear, sorry) question was: shouldn't we
>> change INIT_SIGNALS then? /sbin/init inherits ->pgrp == ->_session == 1,
>> in that case __set_special_pids(1,1) does nothing.
>
> ... and thus /sbin/init remains attached to the .pids above, no?

The problem is that we dynamically allocate the struct pid for 
pid_t == 1 when we fork init.

Which means we don't have access to it at compile time so we can
no longer make INIT_SIGNALS set ->gprp == ->session == 1.

Eric
