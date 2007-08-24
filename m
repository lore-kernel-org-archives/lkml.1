Return-Path: <linux-kernel-owner+w=401wt.eu-S1764524AbXHXW4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764524AbXHXW4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 18:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756922AbXHXWz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 18:55:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47935 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755689AbXHXWz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 18:55:58 -0400
Date: Fri, 24 Aug 2007 15:54:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: ego@in.ibm.com, mingo@elte.hu, vatsa@in.ibm.com, oleg@tv-sign.ru,
       pj@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] hotplug cpu: migrate a task within its cpuset
Message-Id: <20070824155455.cc161b61.akpm@linux-foundation.org>
In-Reply-To: <20070824221806.GA3602@sgi.com>
References: <20070824221806.GA3602@sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2007 17:18:06 -0500
Cliff Wickman <cpw@sgi.com> wrote:

> When a cpu is disabled, move_task_off_dead_cpu() is called for tasks
> that have been running on that cpu.
> 
> Currently, such a task is migrated:
>  1) to any cpu on the same node as the disabled cpu, which is both online
>     and among that task's cpus_allowed
>  2) to any cpu which is both online and among that task's cpus_allowed
> 
> It is typical of a multithreaded application running on a large NUMA system
> to have its tasks confined to a cpuset so as to cluster them near the
> memory that they share. Furthermore, it is typical to explicitly place such
> a task on a specific cpu in that cpuset.  And in that case the task's
> cpus_allowed includes only a single cpu.

operator error..

> This patch would insert a preference to migrate such a task to some cpu within
> its cpuset (and set its cpus_allowed to its entire cpuset).
> 
> With this patch, migrate the task to:
>  1) to any cpu on the same node as the disabled cpu, which is both online
>     and among that task's cpus_allowed
>  2) to any online cpu within the task's cpuset
>  3) to any cpu which is both online and among that task's cpus_allowed

Wouldn't it be saner to refuse the offlining request if the CPU has tasks
which cannot be migrated to any other CPU?  I mean, the operator has gone
and asked the machine to perform two inconsistent/incompatible things at
the same time.

Look at it this way.  If we were to merge this patch then it would be
logical to also merge a patch which has the following description:

  "if an process attempts to pin itself onto an presently-offlined CPU,
   the kernel will choose a different CPU according to <heuristics> and
   will pin the process to that CPU instead".

Which is the same thing as your patch, only it handles the two events when
they occur in the other order.

No?
