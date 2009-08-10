Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbZHJOym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbZHJOym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 10:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZHJOyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 10:54:41 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52653 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZHJOyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 10:54:41 -0400
Date: Mon, 10 Aug 2009 16:54:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>, serue@us.ibm.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Containers <containers@lists.linux-foundation.org>,
       sukadev@us.ibm.com
Subject: Re: [RFC][v4][PATCH 7/7]: Define clone_with_pids syscall
Message-ID: <20090810145425.GA1378@ucw.cz>
References: <20090807061103.GA19343@us.ibm.com> <20090807061517.GG20672@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090807061517.GG20672@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 
> Subject: [RFC][v4][PATCH 7/7]: Define clone_with_pids syscall
> 
> Container restart requires that a task have the same pid it had when it was
> checkpointed. When containers are nested the tasks within the containers
> exist in multiple pid namespaces and hence have multiple pids to specify
> during restart.
> 
> clone_with_pids(), intended for use during restart, is the same as clone(),
> except that it takes a 'target_pid_set' paramter. This parameter lets caller
> choose specific pid numbers for the child process, in the process's active
> and ancestor pid namespaces. (Descendant pid namespaces in general don't
> matter since processes don't have pids in them anyway, but see comments
> in copy_target_pids() regarding CLONE_NEWPID).

This should go to documentation/manpage somewhere.


> Unlike clone(), clone_with_pids() needs CAP_SYS_ADMIN, at least for now, to
> prevent unprivileged processes from misusing this interface.
> 
> Call clone_with_pids as follows:
> 
> 	pid_t pids[] = { 0, 77, 99 };
> 	struct pid_set pid_set;
> 
> 	pid_set.num_pids = sizeof(pids) / sizeof(int);
> 	pid_set.pids = &pids;
> 
> 	syscall(__NR_clone_with_pids, flags, stack, NULL, NULL, NULL, &pid_set);
> 
> If a target-pid is 0, the kernel continues to assign a pid for the process in
> that namespace. In the above example, pids[0] is 0, meaning the kernel will
> assign next available pid to the process in init_pid_ns. But kernel will assign
> pid 77 in the child pid namespace 1 and pid 99 in pid namespace 2. If either
> 77 or 99 are taken, the system call fails with -EBUSY.
> 
> If 'pid_set.num_pids' exceeds the current nesting level of pid namespaces,
> the system call fails with -EINVAL.

Does it make sense to set the pid in anything but innermost container?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
