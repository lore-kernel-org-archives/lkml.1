Return-Path: <linux-kernel-owner+w=401wt.eu-S1753150AbYFVJKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbYFVJKv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYFVJKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:10:44 -0400
Received: from wr-out-0506.google.com ([64.233.184.236]:24562 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbYFVJKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g2A7widGA6qbWYY4IAtRU7ga+J3xPu2fiq5w6n7VE3mucn9iOb6qCd9i9ZL+HOdxQy
         oyfYmHRWyG90t8GVydDnMHe5pE+PXdRziCmfjTAx0gtpr3uOo0XWkRFGYG55YPPSYVGL
         w7meJW5w0tnbircmcvHqqVlJE6xEBXuPrtL68=
Date: Sun, 22 Jun 2008 13:10:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: v2.6.26-rc7/cgroups: circular locking dependency
Message-ID: <20080622091013.GA7285@cvg>
References: <20080621173859.GA6846@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080621173859.GA6846@damson.getinternet.no>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vegard Nossum - Sat, Jun 21, 2008 at 07:38:59PM +0200]
| Hi,
| 
| I decided to see what cgroups is all about, and followed the instructions
| in Documentation/cgroups.txt :-) It happened when I did this:
| 
|     [root@damson /dev/cgroup/Vegard 0]
|     # echo 1 > cpuset.cpus
| 
| I can also provide the kernel config if necessary.
| 
| 
| Vegard
| 
|  
|  =======================================================
|  [ INFO: possible circular locking dependency detected ]
|  2.6.26-rc7 #25
|  -------------------------------------------------------
|  bash/10032 is trying to acquire lock:
|   (&cpu_hotplug.lock){--..}, at: [<c015efbc>] get_online_cpus+0x2c/0x40
|  
|  but task is already holding lock:
|   (cgroup_mutex){--..}, at: [<c0160e6f>] cgroup_lock+0xf/0x20
|  
|  which lock already depends on the new lock.
|  
|  
|  the existing dependency chain (in reverse order) is:
|  
|  -> #1 (cgroup_mutex){--..}:
|         [<c015a435>] __lock_acquire+0xf45/0x1040
|         [<c015a5c8>] lock_acquire+0x98/0xd0
|         [<c05416d1>] mutex_lock_nested+0xb1/0x300
|         [<c0160e6f>] cgroup_lock+0xf/0x20
|         [<c0164750>] cpuset_handle_cpuhp+0x20/0x180
|         [<c014ea77>] notifier_call_chain+0x37/0x70
|         [<c014eae9>] __raw_notifier_call_chain+0x19/0x20
|         [<c051f8c8>] _cpu_down+0x78/0x240
|         [<c051fabb>] cpu_down+0x2b/0x40
|         [<c0520cd9>] store_online+0x39/0x80
|         [<c02f627b>] sysdev_store+0x2b/0x40
|         [<c01d3372>] sysfs_write_file+0xa2/0x100
|         [<c0195486>] vfs_write+0x96/0x130
|         [<c0195b4d>] sys_write+0x3d/0x70
|         [<c010831b>] sysenter_past_esp+0x78/0xd1
|         [<ffffffff>] 0xffffffff
|  
|  -> #0 (&cpu_hotplug.lock){--..}:
|         [<c0159fe5>] __lock_acquire+0xaf5/0x1040
|         [<c015a5c8>] lock_acquire+0x98/0xd0
|         [<c05416d1>] mutex_lock_nested+0xb1/0x300
|         [<c015efbc>] get_online_cpus+0x2c/0x40
|         [<c0163e6d>] rebuild_sched_domains+0x7d/0x3a0
|         [<c01653a4>] cpuset_common_file_write+0x204/0x440
|         [<c0162bc7>] cgroup_file_write+0x67/0x130
|         [<c0195486>] vfs_write+0x96/0x130
|         [<c0195b4d>] sys_write+0x3d/0x70
|         [<c010831b>] sysenter_past_esp+0x78/0xd1
|         [<ffffffff>] 0xffffffff
|  
|  other info that might help us debug this:
|  
|  1 lock held by bash/10032:
|   #0:  (cgroup_mutex){--..}, at: [<c0160e6f>] cgroup_lock+0xf/0x20
|  
|  stack backtrace:
|  Pid: 10032, comm: bash Not tainted 2.6.26-rc7 #25
|   [<c0157ae7>] print_circular_bug_tail+0x77/0x90
|   [<c0159fe5>] __lock_acquire+0xaf5/0x1040
|   [<c015a5c8>] lock_acquire+0x98/0xd0
|   [<c015efbc>] ? get_online_cpus+0x2c/0x40
|   [<c05416d1>] mutex_lock_nested+0xb1/0x300
|   [<c015efbc>] ? get_online_cpus+0x2c/0x40
|   [<c015efbc>] ? get_online_cpus+0x2c/0x40
|   [<c015efbc>] get_online_cpus+0x2c/0x40
|   [<c0163e6d>] rebuild_sched_domains+0x7d/0x3a0
|   [<c0158e65>] ? mark_held_locks+0x65/0x80
|   [<c0190ac5>] ? kfree+0xb5/0x120
|   [<c027736a>] ? heap_free+0xa/0x10
|   [<c027736a>] ? heap_free+0xa/0x10
|   [<c01653a4>] cpuset_common_file_write+0x204/0x440
|   [<c0163c30>] ? started_after+0x0/0x70
|   [<c010e585>] ? native_sched_clock+0xb5/0x110
|   [<c0162e10>] ? started_after+0x0/0x70
|   [<c0164c80>] ? cpuset_test_cpumask+0x0/0x20
|   [<c0164ca0>] ? cpuset_change_cpumask+0x0/0x20
|   [<c0162bc7>] cgroup_file_write+0x67/0x130
|   [<c01651a0>] ? cpuset_common_file_write+0x0/0x440
|   [<c010e585>] ? native_sched_clock+0xb5/0x110
|   [<c0195486>] vfs_write+0x96/0x130
|   [<c0162b60>] ? cgroup_file_write+0x0/0x130
|   [<c0195b4d>] sys_write+0x3d/0x70
|   [<c010831b>] sysenter_past_esp+0x78/0xd1
|   =======================
| 

Hi Vegard,

would be interesting to see your config please

		- Cyrill -
