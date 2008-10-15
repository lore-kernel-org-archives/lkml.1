Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYJOPNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYJOPNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbYJOPNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:13:30 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:37790 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYJOPN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:13:29 -0400
Message-ID: <48F60891.1070807@fr.ibm.com>
Date: Wed, 15 Oct 2008 17:13:21 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: Ingo Molnar <mingo@elte.hu>, Dave Hansen <dave@linux.vnet.ibm.com>,
       jeremy@goop.org, arnd@arndb.de, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrey Mirkin <major@openvz.org>
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>	<20081009124658.GE2952@elte.hu> <1223557122.11830.14.camel@nimitz>	<20081009131701.GA21112@elte.hu> <1223559246.11830.23.camel@nimitz>	<20081009134415.GA12135@elte.hu> <1223571036.11830.32.camel@nimitz> <20081010153951.GD28977@elte.hu> <48F30315.1070909@fr.ibm.com> <48F3737B.6070904@cs.columbia.edu>
In-Reply-To: <48F3737B.6070904@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> the self checkpoint and self restore syscalls, like Oren is proposing, are 
>> simpler but they require the process cooperation to be triggered. we could
>> image doing that in a special signal handler which would allow us to jump
>> in the right task context. 
> 
> This description is not accurate:
> 
> For checkpoint, both implementations use an "external" task to read the state
> from other tasks. (In my implementation that "other" task can be self).

which is good, since some applications want to checkpoint themselves and that's
a way to provide them a generic service.
 
> For restart, both implementation expect the restarting process to restore its
> own state. They differ in that Andrew's patchset also creates that process
> while mine (at the moment) relies on the existing (self) task.

hmm, 

It seems that your patchset relies on the fact that the tasks are checkpointed 
and restarted at a syscall boundary. right ? I'm might be completely wrong
on that :)

> In other words, none of them will require any cooperation on part of the
> checkpointed tasks, and both will require cooperation on part of the restarting
> tasks (the latter is easy since we create and fully control these tasks).

yes.

>> I don't have any preference but looking at the code of the different patchsets
>> there are some tricky areas and I'm wondering which path is easier, safer, 
>> and portable. 
> 
> I am thinking which path is preferred: create the processes in kernel space
> (like Andrew's patch does) or in user space (like Zap does). In the mini-summit
> we agreed in favor of kernel space, but I can still see arguments why user space
> may be better.

I'm more familiar with the second algorithm, restarting the process tree in
user space and let each task restart itself with the sys_restart syscall. But
that's because I've been working on a C/R framework which freezes tasks on 
a syscall boundary, which makes a developer's life easy for restart. 

But as you know, a restarted process resumes its execution where it was 
checkpointed. So i'm wondering what are the hidden issues with a in-kernel 
checkpoint and in-kernel restart. To be more precise, why Andrey needs a 
i386_ret_from_resume  trampoline in : 

	http://lkml.org/lkml/2008/9/3/181

and why don't you ? 

> (note: I refer strictly to the creation of the processes during restart, not 
>  how their state is restored).

OK 

> any thoughts ?

thanks Oren,

C.
