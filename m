Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYFVQCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYFVQCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 12:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbYFVQC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 12:02:27 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:7653 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbYFVQC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 12:02:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SquptqMbsQnpj0BHdnTG6SzhT1qbZZlyWxPB104MzPSU8CH0/jLNIVJcAMc/FvL+F9
         GRq/weRmbe2fVveIdjYe0eGlzsiob2DA+XH5WMXI7X25073zHVwQvTYpulF14OM2DJwv
         1ci5DBePV0Mo4CkfU6bnMy3cb8tXYLfwv3FPo=
Date: Sun, 22 Jun 2008 20:02:02 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Paul Menage <menage@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>
Subject: Re: v2.6.26-rc7/cgroups: circular locking dependency
Message-ID: <20080622160201.GC7285@cvg>
References: <20080621173859.GA6846@damson.getinternet.no> <2f11576a0806220834m3572ee80i72229cb9a1613558@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0806220834m3572ee80i72229cb9a1613558@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[KOSAKI Motohiro - Mon, Jun 23, 2008 at 12:34:04AM +0900]
| CC'ed Paul Jackson
| 
| it seems typical ABBA deadlock.
| I think cpuset use cgrou_lock() by mistake.
| 
| IMHO, cpuset_handle_cpuhp() sholdn't use cgroup_lock() and
| shouldn't call rebuild_sched_domains().
| 
| 
|  -> #1 (cgroup_mutex){--..}:
|        [<c015a435>] __lock_acquire+0xf45/0x1040
|        [<c015a5c8>] lock_acquire+0x98/0xd0
|        [<c05416d1>] mutex_lock_nested+0xb1/0x300
|        [<c0160e6f>] cgroup_lock+0xf/0x20			   cgroup_lock
|        [<c0164750>] cpuset_handle_cpuhp+0x20/0x180
|        [<c014ea77>] notifier_call_chain+0x37/0x70
|        [<c014eae9>] __raw_notifier_call_chain+0x19/0x20
|        [<c051f8c8>] _cpu_down+0x78/0x240			cpu_hotplug.lock
|        [<c051fabb>] cpu_down+0x2b/0x40				  cpu_add_remove_lock
|        [<c0520cd9>] store_online+0x39/0x80
|        [<c02f627b>] sysdev_store+0x2b/0x40
|        [<c01d3372>] sysfs_write_file+0xa2/0x100
|        [<c0195486>] vfs_write+0x96/0x130
|        [<c0195b4d>] sys_write+0x3d/0x70
|        [<c010831b>] sysenter_past_esp+0x78/0xd1
|        [<ffffffff>] 0xffffffff
| 
|  -> #0 (&cpu_hotplug.lock){--..}:
|        [<c0159fe5>] __lock_acquire+0xaf5/0x1040
|        [<c015a5c8>] lock_acquire+0x98/0xd0
|        [<c05416d1>] mutex_lock_nested+0xb1/0x300
|        [<c015efbc>] get_online_cpus+0x2c/0x40			      cpu_hotplug.lock
|        [<c0163e6d>] rebuild_sched_domains+0x7d/0x3a0
|        [<c01653a4>] cpuset_common_file_write+0x204/0x440	cgroup_lock
|        [<c0162bc7>] cgroup_file_write+0x67/0x130
|        [<c0195486>] vfs_write+0x96/0x130
|        [<c0195b4d>] sys_write+0x3d/0x70
|        [<c010831b>] sysenter_past_esp+0x78/0xd1
|        [<ffffffff>] 0xffffffff
| 
| 
| > Hi,
| >
| > I decided to see what cgroups is all about, and followed the instructions
| > in Documentation/cgroups.txt :-) It happened when I did this:
| >
| >    [root@damson /dev/cgroup/Vegard 0]
| >    # echo 1 > cpuset.cpus
| >
| > I can also provide the kernel config if necessary.
| >
| >
| > Vegard
| >
| >
| >  =======================================================
| >  [ INFO: possible circular locking dependency detected ]
| >  2.6.26-rc7 #25
| >  -------------------------------------------------------
| >  bash/10032 is trying to acquire lock:
| >  (&cpu_hotplug.lock){--..}, at: [<c015efbc>] get_online_cpus+0x2c/0x40
| >
| >  but task is already holding lock:
| >  (cgroup_mutex){--..}, at: [<c0160e6f>] cgroup_lock+0xf/0x20
| >
| >  which lock already depends on the new lock.
| 

Thanks Kosaki!

		- Cyrill -
