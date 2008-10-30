Return-Path: <linux-kernel-owner+w=401wt.eu-S1753981AbYJ3IKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbYJ3IKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYJ3IKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:10:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53780 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbYJ3IJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:09:58 -0400
Message-ID: <49096B25.1080002@cn.fujitsu.com>
Date: Thu, 30 Oct 2008 16:07:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroup: fix invalid cgrp->dentry before cgroup has been
 completely removed
References: <490960EF.7020500@cn.fujitsu.com> <6599ad830810300041o1f97999em7b64426414bae380@mail.gmail.com>
In-Reply-To: <6599ad830810300041o1f97999em7b64426414bae380@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Thu, Oct 30, 2008 at 12:23 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> This fixes oops when reading /proc/sched_debug.
>>
>> A cgroup won't be removed completely until finishing cgroup_diput(), so we
>> shouldn't invalidate cgrp->dentry in cgroup_rmdir(). Otherwise, when a
>> group is being removed while cgroup_path() gets called, we may trigger NULL
>> dereference BUG.
> 
> Clearly a bug if it can hit a NULL dereference. But clearing the
> dentry to NULL is something that cgroups inherited from cpusets - it
> looks OK to remove it, but I'm mildly nervous.
> 
> Directly after the code in your patch, we dput() the dentry. So
> theoretically it could be released any time after that. But I guess
> that as soon as it *is* released, cgroup_diput() will be called as
> part of that cleanup, at which point any subsystems should drop any
> pointers they have to the cgroup or the dentry. So I guess it should
> be OK.
> 

The bug is:

cgroup           cpu_subsystem
------------------------------------

cgroup_remove()
                 print_cfs_stats()
                 print_cfs_rq()
cgroup_diput()
                 cpu_cgroup_destroy()

I think a different fix is to add pre_destroy() method to cpu_subsystem,
and move some code from sched_destroy_group() to that method.

But I didn't try it out.
