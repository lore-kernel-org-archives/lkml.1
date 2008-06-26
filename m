Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088AbYFZIPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbYFZIPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756553AbYFZIPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:15:21 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:54433 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870AbYFZIPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:15:17 -0400
X-Greylist: delayed 5008 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 04:15:16 EDT
Subject: Re: A question about group CFS scheduling
From: Peter Zijlstra <peterz@infradead.org>
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: vatsa@linux.vnet.ibm.com, mingo@elte.hu, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ac8af0be0806260019q45fa7285oa0fc79fb02254d28@mail.gmail.com>
References: <ac8af0be0806260019q45fa7285oa0fc79fb02254d28@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 10:15:12 +0200
Message-Id: <1214468112.2794.9.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 15:19 +0800, Zhao Forrest wrote:
> Hi experts,
> 
> In Documentation/sched-design-CFS.txt it reads:
> Group scheduler tunables:
> 
> When CONFIG_FAIR_USER_SCHED is defined, a directory is created in sysfs for
> each new user and a "cpu_share" file is added in that directory.
>         # cd /sys/kernel/uids
>         # cat 512/cpu_share             # Display user 512's CPU share
>         1024
>         # echo 2048 > 512/cpu_share     # Modify user 512's CPU share
>         # cat 512/cpu_share             # Display user 512's CPU share
>         2048
>         #
> CPU bandwidth between two users are divided in the ratio of their CPU shares.
> For ex: if you would like user "root" to get twice the bandwidth of user
> "guest", then set the cpu_share for both the users such that "root"'s
> cpu_share is twice "guest"'s cpu_share.
> 
> My question is: how is CPU bandwidth divided between cgroup and
> regular processes?
> For example,
> 1 the cpu_share of user "root" is set to 2048
> 2 the cpu_share of user "guest" is set to 1024
> 3 there're many processes owned by other users, which don't belong to any cgroup

A process always belongs to a (c)group.

> if the relative CPU bandwidth allocated to cgroup of "root" is 2,
> allocated to cgroup of "guest" is 1, then what's the relative CPU
> bandwidth allocated to other regular processes? 2 or 1?

Are you interested in UID based group scheduling or cgroup scheduling?

Let me explain the cgroup case (the sanest option IMHO):

initially all your tasks will belong to the root cgroup, eg:

assuming:
mkdir -p /cgroup/cpu
mount none /cgroup/cpu -t cgroup -o cpu

Then the root cgroup (cgroup:/) is /cgroup/cpu/ and all tasks will be
found in /cgroup/cpu/tasks.

You can then create new groups as sibling from this root group, eg:

cgroup:/foo
cgroup:/bar

They will get a weigth of 1024 by default, exactly as heavy as a nice 0
task.

That means that no matter how many tasks you stuff into foo, their
combined cpu time will be as much as a single tasks in cgroup:/ would
get.

This is fully recursive, so you can also create:

cgroup:/foo/bar and its tasks in turn will get as much combined cpu time
as a single task in cgroup:/foo would get.

In theory this should go on indefinitely, in practise we'll run into
serious numerical issues quite quickly.


The USER grouping basically creates a fake root and all uids (including
0) are its siblings. The only special case is that uid-0 (aka root) will
get twice the weight of the others.




