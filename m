Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYFVP62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYFVP62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 11:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYFVP6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 11:58:18 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:48747 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbYFVP6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 11:58:17 -0400
Date: Sun, 22 Jun 2008 18:56:27 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Travis <travis@sgi.com>,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer
	dereference
Message-ID: <20080622155627.GA20122@cs181140183.pp.htv.fi>
References: <20080622125633.GA8166@damson.getinternet.no> <19f34abd0806220747q5ac41afcg53979f0d98a95d3c@mail.gmail.com> <19f34abd0806220754l230a09d7xd59835cc3e091b94@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19f34abd0806220754l230a09d7xd59835cc3e091b94@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2008 at 04:54:01PM +0200, Vegard Nossum wrote:
> On Sun, Jun 22, 2008 at 4:47 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > On Sun, Jun 22, 2008 at 2:56 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> >> Initializing CPU#1
> >> APIC error on CPU0: 00(40)
> >> Stuck ??
> >> Inquiring remote APIC #1...
> >> ... APIC #1 ID: failed
> >> ... APIC #1 VERSION: failed
> >> ... APIC #1 SPIV: failed
> >
> > Arch-specific __cpu_up() failed...
> >
> >> BUG: unable to handle kernel NULL pointer dereference at 00000024
> >> IP: [<c01e0f06>] sysfs_remove_group+0x16/0xc0
> >> *pde = 00000000
> >> Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> >>
> >> Pid: 3994, comm: bash Not tainted (2.6.26-rc7-00002-g8b2e474-dirty #29)
> >> EIP: 0060:[<c01e0f06>] EFLAGS: 00010282 CPU: 0
> >> EIP is at sysfs_remove_group+0x16/0xc0
> >> EAX: 00000008 EBX: 00000001 ECX: 00000004 EDX: c0694c14
> >> ESI: 00000004 EDI: c07015fc EBP: f3cbfe9c ESP: f3cbfe80
> >>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> >> Process bash (pid: 3994, ti=f3cbe000 task=f3cb4f60 task.ti=f3cbe000)
> >> Stack: c0302262 f4bcda40 f3cbfe98 00000008 00000001 00000004 00000000 f3cbfea8
> >>       c05880b2 c07576c4 f3cbfec8 c014f567 00000001 00000004 c0753c90 0000001f
> >>       00000001 fffffffb f3cbfedc c014f5d9 0000001f 00000000 00000004 f3cbff00
> >> Call Trace:
> >>  [<c0302262>] ? device_unregister+0x12/0x20
> >
> > This is line 131 of fs/sysfs/group.c:
> >
> >        struct sysfs_dirent *dir_sd = kobj->sd;
> >
> >>  [<c05880b2>] ? topology_cpu_callback+0x32/0x70
> >>  [<c014f567>] ? notifier_call_chain+0x37/0x70
> >>  [<c014f5d9>] ? __raw_notifier_call_chain+0x19/0x20
> >>  [<c0586f6e>] ? _cpu_up+0xee/0x100
> >
> > This is line 314 of _cpu_up():
> >
> > out_notify:
> >        if (ret != 0)
> >                __raw_notifier_call_chain(&cpu_chain,
> >                                CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
> >
> >>  [<c0586fc9>] ? cpu_up+0x49/0x70
> >>  [<c05678d8>] ? store_online+0x58/0x80
> >>  [<c0567880>] ? store_online+0x0/0x80
> >>  [<c0302a6b>] ? sysdev_store+0x2b/0x40
> >>  [<c01df0f2>] ? sysfs_write_file+0xa2/0x100
> >>  [<c01a0d06>] ? vfs_write+0x96/0x130
> >>  [<c01df050>] ? sysfs_write_file+0x0/0x100
> >>  [<c01a13cd>] ? sys_write+0x3d/0x70
> >>  [<c010831b>] ? sysenter_past_esp+0x78/0xd1
> >>  =======================
> >> Code: 8b 43 04 83 c3 04 85 c0 75 ed 5b 5e 5d c3 8d b4 26 00 00 00 00 55 89 e5 83 ec 1c 89 7d fc 89 d7 89 5d f4 89 75 f8 89 45 f0 8b 12 <8b> 70 1c 85 d2 74 53 89 f0 e8 bc f5 ff ff 85 c0 89 c3 74 59 8b
> >> EIP: [<c01e0f06>] sysfs_remove_group+0x16/0xc0 SS:ESP 0068:f3cbfe80
> >>
> >>
> >
> > ...adding a few related Ccs.
> 
> Sorry, forgot one. This is probably the root cause of the crash:
> 
> commit e37d05dad7ff9744efd8ea95a70d389e9a65a6fc
> Author: Mike Travis <travis@sgi.com>
> Date:   Thu May 1 04:35:16 2008 -0700
> 
>     cpu: change cpu_sys_devices from array to per_cpu variable
> 
>     Change cpu_sys_devices from array to per_cpu variable in drivers/base/cpu.c.
>...

Can you confirm whether this is definitely the cause or not?

E.g. if it is and 2.6.25 works fine it might qualify as a 2.6.26-rc 
regression.

> Vegard

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

