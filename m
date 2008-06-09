Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYFIXq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYFIXq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 19:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYFIXqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 19:46:35 -0400
Received: from [78.13.68.104] ([78.13.68.104]:39601 "EHLO linux.localdomain"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754327AbYFIXqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 19:46:34 -0400
From: Andrea Righi <righi.andrea@gmail.com>
To: balbir@linux.vnet.ibm.com
Cc: menage@google.com, kamezawa.hiroyu@jp.fujitsu.com,
       kosaki.motohiro@jp.fujitsu.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: [RFC PATCH 0/5] memcg: VM overcommit accounting and handling
Date: Tue, 10 Jun 2008 01:32:58 +0200
Message-Id: <1213054383-18137-1-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provide distinct cgroup VM overcommit accounting and handling using the memory
resource controller.

Patchset against latest Linus git tree.

This patchset allows to set different per-cgroup overcommit rules and,
according to them, it's possible to return a memory allocation failure (ENOMEM)
to the applications, instead of always triggering the OOM killer via
mem_cgroup_out_of_memory() when cgroup memory limits are exceeded.

Default overcommit settings are taken from vm.overcommit_memory and
vm.overcommit_ratio sysctl values. Child cgroups initially inherits the VM
overcommit parent's settings.

Cgroup overcommit settings can be overridden using memory.overcommit_memory and
memory.overcommit_ratio files under the cgroup filesystem.

For example:

1. Initialize a cgroup with 50MB memory limit:
# mount -t cgroup none /cgroups -o memory
# mkdir /cgroups/0
# /bin/echo $$ >  /cgroups/0/tasks
# /bin/echo 50M > /cgroups/0/memory.limit_in_bytes

2. Use the "never overcommit" policy with 50% ratio:
# /bin/echo 2 > /cgroups/0/memory.overcommit_memory
# /bin/echo 50 > /cgroups/0/memory.overcommit_ratio

Assuming we have no swap space, cgroup 0 can allocate up to 25MB of virtual
memory. If that limit is exceeded all the further allocation attempts made by
userspace applications will receive a -ENOMEM.

4. Show committed VM statistics:
# cat /cgroups/0/memory.overcommit_as
CommitLimit:     25600 kB
Committed_AS:     9844 kB

5. Use "always overcommmit":
# /bin/echo 1 > /cgroups/0/memory.overcommit_memory

This is very similar to the default memory controller configuration: overcommit
is allowed, but when there's no more available memory oom-killer is invoked.

TODO:
- shared memory is not taken in account (i.e. files in tmpfs)

-Andrea
