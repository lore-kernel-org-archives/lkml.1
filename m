Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYKDFoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYKDFoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 00:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYKDFn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 00:43:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:12142 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYKDFn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 00:43:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=OgzpLQUV2E/t0VkJUTrGyee6NMGbBN1ieWQerPNrjtUEU0LyVAIf+DgRbW4x9u1Zq
	bP3N8GEmbbfU8vrqNzh4Q==
MIME-Version: 1.0
In-Reply-To: <20080811235325.121356317@us.ibm.com>
References: <20080811235323.872291138@us.ibm.com>
	 <20080811235325.121356317@us.ibm.com>
Date: Mon, 3 Nov 2008 21:43:52 -0800
Message-ID: <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>
Subject: Re: [PATCH 3/5] Container Freezer: Implement freezer cgroup subsystem
From: Paul Menage <menage@google.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 3:53 PM, Matt Helsley <matthltc@us.ibm.com> wrote:
> +}
> +
> +static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
> +{
> +       struct freezer *freezer;
> +
> +       task_lock(task);
> +       freezer = task_freezer(task);
> +       task_unlock(task);
> +
> +       BUG_ON(freezer->state == STATE_FROZEN);
> +       spin_lock_irq(&freezer->lock);
> +       /* Locking avoids race with FREEZING -> RUNNING transitions. */
> +       if (freezer->state == STATE_FREEZING)
> +               freeze_task(task, true);
> +       spin_unlock_irq(&freezer->lock);
> +}

Sorry for such a delayed response to this patch, but I just noticed
(in mainline now)
the change to move the task_lock() to only encompass the
task_freezer() call.

That results in absolutely zero protection from the task_lock() - as
soon as you drop it, then in theory the current task could move cgroup
and the old freezer structure be freed.

Having said that, I think that in this case any locking my be
unnecessary since task isn't on the tasklist yet, so can't be selected
to move cgroups. (Although this does make me wonder whether
cpuset.c:move_member_tasks_to_cpuset() can fail silently if it races
with a fork).

On top of that, for a system that configures in the cgroup freezer
system but doesn't ever use it, every task is in the same freezer
cgroup (the root cgroup) and task_freezer(task)->lock becomes a global
spinlock. I think this would certainly show up on some benchmarks
although I don't know how bad it would be in a practical sense. But it
might be worth considering making using of the cgroup bind() callback
to track whether or not the freezer subsystem is in use, and
short-circuiting this in freezer_fork() without any locking if you're
not active.

Paul
