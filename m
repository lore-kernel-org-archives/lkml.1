Return-Path: <linux-kernel-owner+w=401wt.eu-S2993128AbXDYViX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993128AbXDYViX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993129AbXDYViX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:38:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58017 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993128AbXDYViW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:38:22 -0400
Date: Thu, 26 Apr 2007 03:07:25 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miles Lane <miles.lane@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Oleg Nesterov <oleg@tv-sign.ru>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7-mm1 + sysfs-oops-workaround.patch -- software suspend failed (1 tasks refusing to freeze)
Message-ID: <20070425213725.GG15134@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <a44ae5cd0704242227x14986fe3v5c2fc3a5bceedc89@mail.gmail.com> <20070424224137.0ccf7874.akpm@linux-foundation.org> <a44ae5cd0704242249i210ba860i659c230b5dbb211c@mail.gmail.com> <20070424225429.544075c8.akpm@linux-foundation.org> <a44ae5cd0704242341n4c8d9eaaw4516759ff79e8cd5@mail.gmail.com> <20070425000735.130ec3e7.akpm@linux-foundation.org> <a44ae5cd0704250048i474d7249l7d5b27f6adaf2742@mail.gmail.com> <20070425011902.714d85d6.akpm@linux-foundation.org> <a44ae5cd0704251300o2804e71dwebeda266415b691b@mail.gmail.com> <20070425141245.1bb29930.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425141245.1bb29930.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Looks like we went off-list :)

On Wed, Apr 25, 2007 at 02:12:45PM -0700, Andrew Morton wrote:
> On Wed, 25 Apr 2007 13:00:01 -0700
> "Miles Lane" <miles.lane@gmail.com> wrote:
> 
> > SysRq : Show State
> 
> OK.  Your freezer failure is caused by lots of breakage with networking's
> rtnl_lock.
> 
> My usual first step with these traces is to search for " D ":
> 
> avahi-daemon  D 000003D0     0  2853      1 (NOTLB)
>        c32e1c80 00000092 a4206282 000003d0 00000000 00000046 a4206282 000003d0
>        c1ca35e4 c03b9b54 c30fc2f0 c1ca34d0 c036f520 c32e1cb0 c036f4e0 00000246
>        c32e1cd0 c0299cc7 00000000 00000002 c0299dfe 00000246 00000202 c1f7f060
> Call Trace:
>  [__mutex_lock_slowpath+330/610] __mutex_lock_slowpath+0x14a/0x262
>  [mutex_lock+31/35] mutex_lock+0x1f/0x23
>  [rtnl_lock+16/18] rtnl_lock+0x10/0x12
>  [ip_mc_leave_group+24/170] ip_mc_leave_group+0x18/0xaa
>  [ip_setsockopt+1608/2365] ip_setsockopt+0x648/0x93d
>  [udp_setsockopt+67/74] udp_setsockopt+0x43/0x4a
>  [sock_common_setsockopt+30/37] sock_common_setsockopt+0x1e/0x25
>  [sys_setsockopt+105/133] sys_setsockopt+0x69/0x85
>  [sys_socketcall+488/577] sys_socketcall+0x1e8/0x241
>  [sysenter_past_esp+95/153] sysenter_past_esp+0x5f/0x99
> 
> and
> 
> multiload-app D 000003D0     0  4159      1 (NOTLB)
>        c733ee10 00200092 aa7df471 000003d0 00000000 00200046 aa7df471 000003d0
>        c7277624 c03b9b54 c72fea98 00000000 c036f520 c733ee40 c036f4e0 00200246
>        c733ee60 c0299cc7 00000000 00000002 c0299dfe 00200246 00000000 00000000
> Call Trace:
>  [__mutex_lock_slowpath+330/610] __mutex_lock_slowpath+0x14a/0x262
>  [mutex_lock+31/35] mutex_lock+0x1f/0x23
>  [rtnl_lock+16/18] rtnl_lock+0x10/0x12
>  [dev_ioctl+1066/1134] dev_ioctl+0x42a/0x46e
>  [sock_ioctl+446/458] sock_ioctl+0x1be/0x1ca
>  [do_ioctl+34/104] do_ioctl+0x22/0x68
>  [vfs_ioctl+575/594] vfs_ioctl+0x23f/0x252
>  [sys_ioctl+49/74] sys_ioctl+0x31/0x4a
>  [sysenter_past_esp+95/153] sysenter_past_esp+0x5f/0x99
> 
> 
> and
> 
> wpa_supplican D 000003D0     0  6511      1 (NOTLB)
>        c724cc50 00200092 a33ddada 000003d0 00000000 00200046 a33ddada 000003d0
>        c7191624 c03b9b54 c72fe330 c46c64d0 c036f520 c724cc80 c036f4e0 00200246
>        c724cca0 c0299cc7 00000000 00000002 c0299dfe 00200046 00000000 00000000
> Call Trace:
>  [__mutex_lock_slowpath+330/610] __mutex_lock_slowpath+0x14a/0x262
>  [mutex_lock+31/35] mutex_lock+0x1f/0x23
>  [rtnetlink_rcv+26/68] rtnetlink_rcv+0x1a/0x44
>  [netlink_data_ready+21/85] netlink_data_ready+0x15/0x55
>  [netlink_sendskb+34/83] netlink_sendskb+0x22/0x53
>  [netlink_unicast+443/469] netlink_unicast+0x1bb/0x1d5
>  [netlink_sendmsg+582/594] netlink_sendmsg+0x246/0x252
>  [sock_sendmsg+204/229] sock_sendmsg+0xcc/0xe5
>  [sys_sendto+204/236] sys_sendto+0xcc/0xec
>  [sys_send+54/56] sys_send+0x36/0x38
>  [sys_socketcall+318/577] sys_socketcall+0x13e/0x241
>  [sysenter_past_esp+95/153] sysenter_past_esp+0x5f/0x99
> 
> and lots more of the same.
> 
> 
> There is something seriously scrogged with networking locking in -mm.  We
> know there's one locking bug which manifests in the bare net-2.6.22 tree,
> and I'm suspecting that there are other (albeit perhaps related) locking
> bugs triggered by something else in -mm.  Something which precedes
> git-net.patch in the series file (ie: another subsystem tree).
> 
> So for now, we should assume that there's no freezer-related problem being
> demonstrated here.

Doesn't look like it ATM. 

> 

Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
