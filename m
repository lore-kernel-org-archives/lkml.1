Return-Path: <linux-kernel-owner+w=401wt.eu-S1761879AbXGXRoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761879AbXGXRoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754999AbXGXRog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:44:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:30385 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194AbXGXRof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Le92jxzZP2Ft5elXIqycUtsVWvqVL7US+c74mkCXUooy+JDQogQkGAVAiMAFrrlNI00joJagv4V4oYPyQ3aJLdvSWgFp7LjmJ8gH+sFLnAtxBKWMPcwM5SXgqwuH//m7lxntNnDJCpFCXjFISy0oNnoIQJpxmUaCytzdT85u4Zg=
Message-ID: <dda83e780707241044qde262feqe6306a7cd7da4f88@mail.gmail.com>
Date: Tue, 24 Jul 2007 10:44:34 -0700
From: "Bret Towe" <magnade@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: mm: fix fault vs invalidate race for linear mappings
In-Reply-To: <dda83e780707241027k369c2f01j6d16b21266df3a05@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780707241027k369c2f01j6d16b21266df3a05@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/24/07, Bret Towe <magnade@gmail.com> wrote:
> for a while in -git I've had an issue that on boot when gdm loads the
> screen stays black
> using ctrl-f1 doesn't return to a console and killing X doesn't help any
> ssh'ing into the box does work top only shows 100% io-wait
> dmesg shows nothing odd
>
> the work around I have is at the moment is to just move the radeon drm module
> out of the way so it doesn't load on boot and X works just fine like that
> I did some bisecting which took a few days and tracked it down to
> commit d00806b183152af6d24f46f0c33f14162ca1262a
>
> its way to complex for me to revert it on top of -rc1 to verify that's
> the issue tho
> I keep forgetting to get a trace of what its waiting on when I'm in that kernel
> I assume that would be of use and Ill get that later

[  166.174606] SysRq : Show State
[  166.174620]   task                PC stack   pid father
[  166.174624] init          S 0ff6ff5c     0     1      0
[  166.174630] Call Trace:
[  166.174632] [dffc5910] [00000020] 0x20 (unreliable)
[  166.174661] [dffc59d0] [c0008ea0] __switch_to+0x5c/0x94
[  166.174674] --- Exception: c1b05c80 at 0xdffc5a80
[  166.174679]     LR = 0xc1b05c80
[  166.174682] [dffc59f0] [c020fc88] schedule+0x194/0x390 (unreliable)
[  166.174692] [dffc5a40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.174698] [dffc5a90] [c00a0768] do_select+0x3dc/0x4a8
[  166.174706] [dffc5d60] [c00a0acc] core_sys_select+0x298/0x380
[  166.174711] [dffc5ec0] [c00a11d8] sys_select+0xc0/0x23c
[  166.174717] [dffc5f10] [c0005240] ppc_select+0x104/0x128
[  166.174723] [dffc5f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.174734] --- Exception: c01 at 0xff6ff5c
[  166.174738]     LR = 0x10011d10
[  166.174741] kthreadd      S 00000000     0     2      0
[  166.174746] Call Trace:
[  166.174748] [dffc7e80] [c002eec0] do_fork+0xd4/0x238 (unreliable)
[  166.174757] [dffc7f40] [c0008ea0] __switch_to+0x5c/0x94
[  166.174763] [dffc7f60] [c020fc88] schedule+0x194/0x390
[  166.174768] [dffc7fb0] [c0046d50] kthreadd+0x68/0x11c
[  166.174778] [dffc7ff0] [c0014060] kernel_thread+0x44/0x60
[  166.174785] ksoftirqd/0   S 00000000     0     3      2
[  166.174789] Call Trace:
[  166.174791] [dffcbe80] [00000002] 0x2 (unreliable)
[  166.174796] [dffcbf40] [c0008ea0] __switch_to+0x5c/0x94
[  166.174802] [dffcbf60] [c020fc88] schedule+0x194/0x390
[  166.174807] [dffcbfb0] [c003568c] ksoftirqd+0x98/0x9c
[  166.174816] [dffcbfd0] [c0046bdc] kthread+0x48/0x84
[  166.174821] [dffcbff0] [c0014060] kernel_thread+0x44/0x60
[  166.174827] watchdog/0    S 00000000     0     4      2
[  166.174831] Call Trace:
[  166.174834] [dffcdf40] [c0008ea0] __switch_to+0x5c/0x94
[  166.174840] [dffcdf60] [c020fc88] schedule+0x194/0x390
[  166.174845] [dffcdfb0] [c00623d4] watchdog+0x44/0x6c
[  166.174854] [dffcdfd0] [c0046bdc] kthread+0x48/0x84
[  166.174859] [dffcdff0] [c0014060] kernel_thread+0x44/0x60
[  166.174865] events/0      R running      0     5      2
[  166.174870] khelper       S 00000000     0     6      2
[  166.174874] Call Trace:
[  166.174876] [dffd3e60] [c0008c60] sys_clone+0x68/0x84 (unreliable)
[  166.174883] [dffd3f20] [c0008ea0] __switch_to+0x5c/0x94
[  166.174888] [dffd3f40] [c020fc88] schedule+0x194/0x390
[  166.174894] [dffd3f90] [c0042c54] worker_thread+0xd8/0x120
[  166.174899] [dffd3fd0] [c0046bdc] kthread+0x48/0x84
[  166.174904] [dffd3ff0] [c0014060] kernel_thread+0x44/0x60
[  166.174910] kblockd/0     S 00000000     0    48      2
[  166.174914] Call Trace:
[  166.174917] [dff83e60] [c017d7a4] ide_execute_command+0x70/0xac (unreliable)
[  166.174925] [dff83f20] [c0008ea0] __switch_to+0x5c/0x94
[  166.174931] [dff83f40] [c020fc88] schedule+0x194/0x390
[  166.174936] [dff83f90] [c0042c54] worker_thread+0xd8/0x120
[  166.174941] [dff83fd0] [c0046bdc] kthread+0x48/0x84
[  166.174947] [dff83ff0] [c0014060] kernel_thread+0x44/0x60
[  166.174953] kseriod       S 00000000     0    54      2
[  166.174957] Call Trace:
[  166.174959] [dff93e40] [deadbeef] 0xdeadbeef (unreliable)
[  166.174965] [dff93f00] [c0008ea0] __switch_to+0x5c/0x94
[  166.174971] [dff93f20] [c020fc88] schedule+0x194/0x390
[  166.174976] [dff93f70] [c0188278] serio_thread+0xcc/0x32c
[  166.174987] [dff93fd0] [c0046bdc] kthread+0x48/0x84
[  166.174992] [dff93ff0] [c0014060] kernel_thread+0x44/0x60
[  166.174998] pdflush       S 00000000     0    79      2
[  166.175003] Call Trace:
[  166.175005] [c1c21e60] [fdd5b27f] 0xfdd5b27f (unreliable)
[  166.175011] [c1c21f20] [c0008ea0] __switch_to+0x5c/0x94
[  166.175017] [c1c21f40] [c020fc88] schedule+0x194/0x390
[  166.175022] [c1c21f90] [c006e8e8] pdflush+0xbc/0x1f4
[  166.175030] [c1c21fd0] [c0046bdc] kthread+0x48/0x84
[  166.175035] [c1c21ff0] [c0014060] kernel_thread+0x44/0x60
[  166.175041] pdflush       S 00000000     0    80      2
[  166.175045] Call Trace:
[  166.175048] [c1c23e60] [e24153f4] xfs_inode_flush+0x194/0x1b0 [xfs]
(unreliable)
[  166.175155] [c1c23f20] [c0008ea0] __switch_to+0x5c/0x94
[  166.175163] [c1c23f40] [c020fc88] schedule+0x194/0x390
[  166.175168] [c1c23f90] [c006e8e8] pdflush+0xbc/0x1f4
[  166.175174] [c1c23fd0] [c0046bdc] kthread+0x48/0x84
[  166.175179] [c1c23ff0] [c0014060] kernel_thread+0x44/0x60
[  166.175187] kswapd0       S 00000000     0    81      2
[  166.175191] Call Trace:
[  166.175193] [c1c25df0] [e4abdf33] 0xe4abdf33 (unreliable)
[  166.175201] [c1c25eb0] [c0008ea0] __switch_to+0x5c/0x94
[  166.175207] [c1c25ed0] [c020fc88] schedule+0x194/0x390
[  166.175212] [c1c25f20] [c0072a78] kswapd+0x410/0x434
[  166.175219] [c1c25fd0] [c0046bdc] kthread+0x48/0x84
[  166.175224] [c1c25ff0] [c0014060] kernel_thread+0x44/0x60
[  166.175230] aio/0         S 00000000     0   135      2
[  166.175235] Call Trace:
[  166.175237] [dfab7e60] [0061006e] 0x61006e (unreliable)
[  166.175242] [dfab7f20] [c0008ea0] __switch_to+0x5c/0x94
[  166.175248] [dfab7f40] [c020fc88] schedule+0x194/0x390
[  166.175254] [dfab7f90] [c0042c54] worker_thread+0xd8/0x120
[  166.175259] [dfab7fd0] [c0046bdc] kthread+0x48/0x84
[  166.175264] [dfab7ff0] [c0014060] kernel_thread+0x44/0x60
[  166.175270] ksuspend_usbd S 00000000     0   921      2
[  166.175275] Call Trace:
[  166.175277] [df449e60] [c1943800] 0xc1943800 (unreliable)
[  166.175282] [df449f20] [c0008ea0] __switch_to+0x5c/0x94
[  166.175288] [df449f40] [c020fc88] schedule+0x194/0x390
[  166.175294] [df449f90] [c0042c54] worker_thread+0xd8/0x120
[  166.175299] [df449fd0] [c0046bdc] kthread+0x48/0x84
[  166.175304] [df449ff0] [c0014060] kernel_thread+0x44/0x60
[  166.175310] khpsbpkt      S 00000000     0   927      2
[  166.175315] Call Trace:
[  166.175317] [dfb5be70] [c02e0664] kthread_create_list+0x0/0x8 (unreliable)
[  166.175329] [dfb5bf30] [c0008ea0] __switch_to+0x5c/0x94
[  166.175335] [dfb5bf50] [c020fc88] schedule+0x194/0x390
[  166.175340] [dfb5bfa0] [e2082948] hpsbpkt_thread+0x13c/0x140 [ieee1394]
[  166.175380] [dfb5bfd0] [c0046bdc] kthread+0x48/0x84
[  166.175385] [dfb5bff0] [c0014060] kernel_thread+0x44/0x60
[  166.175392] khubd         S 00000000     0   939      2
[  166.175396] Call Trace:
[  166.175398] [c1b2de30] [c003a500] process_timeout+0x0/0x20 (unreliable)
[  166.175407] [c1b2def0] [c0008ea0] __switch_to+0x5c/0x94
[  166.175413] [c1b2df10] [c020fc88] schedule+0x194/0x390
[  166.175419] [c1b2df60] [e20b4b90] hub_thread+0x1b4/0xc70 [usbcore]
[  166.175471] [c1b2dfd0] [c0046bdc] kthread+0x48/0x84
[  166.175477] [c1b2dff0] [c0014060] kernel_thread+0x44/0x60
[  166.175484] knodemgrd_0   S 00000000     0   951      2
[  166.175488] Call Trace:
[  166.175490] [c1b1fe40] [c0104a40] ida_get_new_above+0x90/0x1ec (unreliable)
[  166.175497] [c1b1ff00] [c0008ea0] __switch_to+0x5c/0x94
[  166.175503] [c1b1ff20] [c020fc88] schedule+0x194/0x390
[  166.175509] [c1b1ff70] [e2088b04] nodemgr_host_thread+0x3d0/0xae0 [ieee1394]
[  166.175529] [c1b1ffd0] [c0046bdc] kthread+0x48/0x84
[  166.175535] [c1b1fff0] [c0014060] kernel_thread+0x44/0x60
[  166.175541] xfslogd/0     S 00000000     0  1236      2
[  166.175545] Call Trace:
[  166.175548] [c1c69e60] [c002964c] enqueue_task+0x24/0x40 (unreliable)
[  166.175561] [c1c69f20] [c0008ea0] __switch_to+0x5c/0x94
[  166.175567] [c1c69f40] [c020fc88] schedule+0x194/0x390
[  166.175573] [c1c69f90] [c0042c54] worker_thread+0xd8/0x120
[  166.175578] [c1c69fd0] [c0046bdc] kthread+0x48/0x84
[  166.175583] [c1c69ff0] [c0014060] kernel_thread+0x44/0x60
[  166.175589] xfsdatad/0    S 00000000     0  1237      2
[  166.175593] Call Trace:
[  166.175596] [dfb1fe60] [c02e0664] kthread_create_list+0x0/0x8 (unreliable)
[  166.175603] [dfb1ff20] [c0008ea0] __switch_to+0x5c/0x94
[  166.175609] [dfb1ff40] [c020fc88] schedule+0x194/0x390
[  166.175614] [dfb1ff90] [c0042c54] worker_thread+0xd8/0x120
[  166.175620] [dfb1ffd0] [c0046bdc] kthread+0x48/0x84
[  166.175625] [dfb1fff0] [c0014060] kernel_thread+0x44/0x60
[  166.175631] xfs_mru_cache S 00000000     0  1241      2
[  166.175635] Call Trace:
[  166.175637] [c19d3e60] [00000009] 0x9 (unreliable)
[  166.175643] [c19d3f20] [c0008ea0] __switch_to+0x5c/0x94
[  166.175649] [c19d3f40] [c020fc88] schedule+0x194/0x390
[  166.175654] [c19d3f90] [c0042c54] worker_thread+0xd8/0x120
[  166.175660] [c19d3fd0] [c0046bdc] kthread+0x48/0x84
[  166.175665] [c19d3ff0] [c0014060] kernel_thread+0x44/0x60
[  166.175671] xfsbufd       S 00000000     0  1246      2
[  166.175675] Call Trace:
[  166.175677] [c1bf7e10] [c00f51cc] elv_rb_add+0x74/0x88 (unreliable)
[  166.175688] [c1bf7ed0] [c0008ea0] __switch_to+0x5c/0x94
[  166.175693] [c1bf7ef0] [c020fc88] schedule+0x194/0x390
[  166.175698] [c1bf7f40] [c0210720] schedule_timeout+0x68/0xe4
[  166.175704] [c1bf7f90] [e24209f4] xfsbufd+0x70/0x180 [xfs]
[  166.175756] [c1bf7fd0] [c0046bdc] kthread+0x48/0x84
[  166.175761] [c1bf7ff0] [c0014060] kernel_thread+0x44/0x60
[  166.175769] xfssyncd      S 00000000     0  1247      2
[  166.175773] Call Trace:
[  166.175776] [df529e00] [00001032] 0x1032 (unreliable)
[  166.175782] [df529ec0] [c0008ea0] __switch_to+0x5c/0x94
[  166.175788] [df529ee0] [c020fc88] schedule+0x194/0x390
[  166.175793] [df529f30] [c0210720] schedule_timeout+0x68/0xe4
[  166.175799] [df529f80] [e2428418] xfssyncd+0x180/0x1cc [xfs]
[  166.175835] [df529fd0] [c0046bdc] kthread+0x48/0x84
[  166.175840] [df529ff0] [c0014060] kernel_thread+0x44/0x60
[  166.175847] udevd         S 0fec6f5c     0  1427      1
[  166.175851] Call Trace:
[  166.175854] [df0819d0] [c0008ea0] __switch_to+0x5c/0x94
[  166.175860] [df0819f0] [c020fc88] schedule+0x194/0x390
[  166.175865] [df081a40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.175871] [df081a90] [c00a0768] do_select+0x3dc/0x4a8
[  166.175877] [df081d60] [c00a0acc] core_sys_select+0x298/0x380
[  166.175883] [df081ec0] [c00a11d8] sys_select+0xc0/0x23c
[  166.175888] [df081f10] [c0005240] ppc_select+0x104/0x128
[  166.175894] [df081f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.175900] --- Exception: c01 at 0xfec6f5c
[  166.175906]     LR = 0x100049fc
[  166.175908] portmap       S 0ff089e0     0  2340      1
[  166.175913] Call Trace:
[  166.175915] [de557a10] [c01c2c64] ip_rcv+0x2e4/0x590 (unreliable)
[  166.175922] [de557ad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.175928] [de557af0] [c020fc88] schedule+0x194/0x390
[  166.175933] [de557b40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.175939] [de557b90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.175944] [de557f20] [c00a0378] sys_poll+0x74/0x88
[  166.175949] [de557f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.175955] --- Exception: c01 at 0xff089e0
[  166.175960]     LR = 0xff0899c
[  166.175962] rpc.statd     S 0ff44f5c     0  2376      1
[  166.175967] Call Trace:
[  166.175969] [defab910] [c002964c] enqueue_task+0x24/0x40 (unreliable)
[  166.175977] [defab9d0] [c0008ea0] __switch_to+0x5c/0x94
[  166.175983] [defab9f0] [c020fc88] schedule+0x194/0x390
[  166.175988] [defaba40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.175994] [defaba90] [c00a0768] do_select+0x3dc/0x4a8
[  166.175999] [defabd60] [c00a0acc] core_sys_select+0x298/0x380
[  166.176005] [defabec0] [c00a11d8] sys_select+0xc0/0x23c
[  166.176010] [defabf10] [c0005240] ppc_select+0x104/0x128
[  166.176015] [defabf40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176021] --- Exception: c01 at 0xff44f5c
[  166.176026]     LR = 0x10006204
[  166.176028] rpc.idmapd    S 0ff22414     0  2459      1
[  166.176033] Call Trace:
[  166.176035] [de759d50] [c002964c] enqueue_task+0x24/0x40 (unreliable)
[  166.176042] [de759e10] [c0008ea0] __switch_to+0x5c/0x94
[  166.176048] [de759e30] [c020fc88] schedule+0x194/0x390
[  166.176053] [de759e80] [c0210720] schedule_timeout+0x68/0xe4
[  166.176058] [de759ed0] [c00c4f70] sys_epoll_wait+0x1bc/0x4cc
[  166.176069] [de759f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176075] --- Exception: c01 at 0xff22414
[  166.176080]     LR = 0xffde034
[  166.176083] nfsv4-svc     S 00000000     0  2471      2
[  166.176087] Call Trace:
[  166.176090] [de79bdb0] [c00a81f4] destroy_inode+0x58/0x8c (unreliable)
[  166.176099] [de79be70] [c0008ea0] __switch_to+0x5c/0x94
[  166.176105] [de79be90] [c020fc88] schedule+0x194/0x390
[  166.176110] [de79bee0] [c0210754] schedule_timeout+0x9c/0xe4
[  166.176116] [de79bf30] [e25f9da0] svc_recv+0x1bc/0x46c [sunrpc]
[  166.176178] [de79bf90] [e26a3e20] nfs_callback_svc+0xac/0x16c [nfs]
[  166.176264] [de79bff0] [c0014060] kernel_thread+0x44/0x60
[  166.176272] rpciod/0      S 00000000     0  2472      2
[  166.176276] Call Trace:
[  166.176278] [de7a3e60] [c0a80101] 0xc0a80101 (unreliable)
[  166.176286] [de7a3f20] [c0008ea0] __switch_to+0x5c/0x94
[  166.176293] [de7a3f40] [c020fc88] schedule+0x194/0x390
[  166.176298] [de7a3f90] [c0042c54] worker_thread+0xd8/0x120
[  166.176304] [de7a3fd0] [c0046bdc] kthread+0x48/0x84
[  166.176309] [de7a3ff0] [c0014060] kernel_thread+0x44/0x60
[  166.176316] getty         S 0ff66b94     0  2508      1
[  166.176320] Call Trace:
[  166.176323] [de00dcd0] [de00dd38] 0xde00dd38 (unreliable)
[  166.176328] [de00dd90] [c0008ea0] __switch_to+0x5c/0x94
[  166.176334] [de00ddb0] [c020fc88] schedule+0x194/0x390
[  166.176339] [de00de00] [c0210754] schedule_timeout+0x9c/0xe4
[  166.176345] [de00de50] [c0157268] read_chan+0x198/0x67c
[  166.176353] [de00dec0] [c0154854] tty_read+0xa4/0xe0
[  166.176359] [de00def0] [c0091308] vfs_read+0xe8/0x198
[  166.176366] [de00df10] [c009178c] sys_read+0x4c/0x90
[  166.176371] [de00df40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176376] --- Exception: c01 at 0xff66b94
[  166.176381]     LR = 0x10001c74
[  166.176384] getty         S 0ff66b94     0  2509      1
[  166.176388] Call Trace:
[  166.176391] [de04dcd0] [de04dd38] 0xde04dd38 (unreliable)
[  166.176396] [de04dd90] [c0008ea0] __switch_to+0x5c/0x94
[  166.176402] [de04ddb0] [c020fc88] schedule+0x194/0x390
[  166.176407] [de04de00] [c0210754] schedule_timeout+0x9c/0xe4
[  166.176413] [de04de50] [c0157268] read_chan+0x198/0x67c
[  166.176418] [de04dec0] [c0154854] tty_read+0xa4/0xe0
[  166.176423] [de04def0] [c0091308] vfs_read+0xe8/0x198
[  166.176428] [de04df10] [c009178c] sys_read+0x4c/0x90
[  166.176434] [de04df40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176439] --- Exception: c01 at 0xff66b94
[  166.176444]     LR = 0x10001c74
[  166.176447] getty         S 0ff66b94     0  2511      1
[  166.176451] Call Trace:
[  166.176454] [de0b1cd0] [de0b1d38] 0xde0b1d38 (unreliable)
[  166.176459] [de0b1d90] [c0008ea0] __switch_to+0x5c/0x94
[  166.176465] [de0b1db0] [c020fc88] schedule+0x194/0x390
[  166.176470] [de0b1e00] [c0210754] schedule_timeout+0x9c/0xe4
[  166.176476] [de0b1e50] [c0157268] read_chan+0x198/0x67c
[  166.176481] [de0b1ec0] [c0154854] tty_read+0xa4/0xe0
[  166.176486] [de0b1ef0] [c0091308] vfs_read+0xe8/0x198
[  166.176491] [de0b1f10] [c009178c] sys_read+0x4c/0x90
[  166.176497] [de0b1f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176502] --- Exception: c01 at 0xff66b94
[  166.176507]     LR = 0x10001c74
[  166.176510] getty         S 0ff66b94     0  2512      1
[  166.176514] Call Trace:
[  166.176516] [de0f1cd0] [de0f1d38] 0xde0f1d38 (unreliable)
[  166.176522] [de0f1d90] [c0008ea0] __switch_to+0x5c/0x94
[  166.176528] [de0f1db0] [c020fc88] schedule+0x194/0x390
[  166.176533] [de0f1e00] [c0210754] schedule_timeout+0x9c/0xe4
[  166.176538] [de0f1e50] [c0157268] read_chan+0x198/0x67c
[  166.176544] [de0f1ec0] [c0154854] tty_read+0xa4/0xe0
[  166.176549] [de0f1ef0] [c0091308] vfs_read+0xe8/0x198
[  166.176554] [de0f1f10] [c009178c] sys_read+0x4c/0x90
[  166.176559] [de0f1f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176565] --- Exception: c01 at 0xff66b94
[  166.176570]     LR = 0x10001c74
[  166.176572] getty         S 0ff66b94     0  2513      1
[  166.176577] Call Trace:
[  166.176579] [de131cd0] [de131d38] 0xde131d38 (unreliable)
[  166.176585] [de131d90] [c0008ea0] __switch_to+0x5c/0x94
[  166.176590] [de131db0] [c020fc88] schedule+0x194/0x390
[  166.176596] [de131e00] [c0210754] schedule_timeout+0x9c/0xe4
[  166.176601] [de131e50] [c0157268] read_chan+0x198/0x67c
[  166.176607] [de131ec0] [c0154854] tty_read+0xa4/0xe0
[  166.176612] [de131ef0] [c0091308] vfs_read+0xe8/0x198
[  166.176617] [de131f10] [c009178c] sys_read+0x4c/0x90
[  166.176622] [de131f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176628] --- Exception: c01 at 0xff66b94
[  166.176632]     LR = 0x10001c74
[  166.176635] getty         S 0ff66b94     0  2514      1
[  166.176640] Call Trace:
[  166.176642] [de173cd0] [de173d38] 0xde173d38 (unreliable)
[  166.176647] [de173d90] [c0008ea0] __switch_to+0x5c/0x94
[  166.176653] [de173db0] [c020fc88] schedule+0x194/0x390
[  166.176658] [de173e00] [c0210754] schedule_timeout+0x9c/0xe4
[  166.176664] [de173e50] [c0157268] read_chan+0x198/0x67c
[  166.176669] [de173ec0] [c0154854] tty_read+0xa4/0xe0
[  166.176675] [de173ef0] [c0091308] vfs_read+0xe8/0x198
[  166.176680] [de173f10] [c009178c] sys_read+0x4c/0x90
[  166.176685] [de173f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176690] --- Exception: c01 at 0xff66b94
[  166.176695]     LR = 0x10001c74
[  166.176698] syslogd       S 0ff6ff5c     0  2555      1
[  166.176702] Call Trace:
[  166.176705] [de2b5910] [de2b59c8] 0xde2b59c8 (unreliable)
[  166.176710] [de2b59d0] [c0008ea0] __switch_to+0x5c/0x94
[  166.176716] [de2b59f0] [c020fc88] schedule+0x194/0x390
[  166.176721] [de2b5a40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.176727] [de2b5a90] [c00a0768] do_select+0x3dc/0x4a8
[  166.176732] [de2b5d60] [c00a0acc] core_sys_select+0x298/0x380
[  166.176738] [de2b5ec0] [c00a11d8] sys_select+0xc0/0x23c
[  166.176743] [de2b5f10] [c0005240] ppc_select+0x104/0x128
[  166.176749] [de2b5f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176754] --- Exception: c01 at 0xff6ff5c
[  166.176759]     LR = 0x10005268
[  166.176762] dd            R running      0  2584      1
[  166.176766] klogd         S 0ff66b94     0  2586      1
[  166.176771] Call Trace:
[  166.176773] [de2e7c60] [df2be6a0] 0xdf2be6a0 (unreliable)
[  166.176779] [de2e7d20] [c0008ea0] __switch_to+0x5c/0x94
[  166.176784] [de2e7d40] [c020fc88] schedule+0x194/0x390
[  166.176790] [de2e7d90] [c0097f94] pipe_wait+0x60/0x94
[  166.176799] [de2e7dc0] [c00987a0] pipe_read+0xd0/0x548
[  166.176805] [de2e7e30] [c0090708] do_sync_read+0xc4/0x138
[  166.176810] [de2e7ef0] [c0091308] vfs_read+0xe8/0x198
[  166.176815] [de2e7f10] [c009178c] sys_read+0x4c/0x90
[  166.176820] [de2e7f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176826] --- Exception: c01 at 0xff66b94
[  166.176830]     LR = 0x10001e3c
[  166.176833] dbus-daemon   S 0feb29e0     0  2607      1
[  166.176838] Call Trace:
[  166.176840] [ddc6fad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.176846] [ddc6faf0] [c020fc88] schedule+0x194/0x390
[  166.176851] [ddc6fb40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.176857] [ddc6fb90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.176863] [ddc6ff20] [c00a0378] sys_poll+0x74/0x88
[  166.176868] [ddc6ff40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176873] --- Exception: c01 at 0xfeb29e0
[  166.176878]     LR = 0xfeb299c
[  166.176881] hald          S 0fcc49e0     0  2623      1
[  166.176885] Call Trace:
[  166.176887] [ddf25a10] [c0006a84] do_softirq+0x58/0x5c (unreliable)
[  166.176893] [ddf25ad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.176899] [ddf25af0] [c020fc88] schedule+0x194/0x390
[  166.176904] [ddf25b40] [c0210720] schedule_timeout+0x68/0xe4
[  166.176910] [ddf25b90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.176915] [ddf25f20] [c00a034c] sys_poll+0x48/0x88
[  166.176920] [ddf25f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176926] --- Exception: c01 at 0xfcc49e0
[  166.176931]     LR = 0xfcc499c
[  166.176933] hald-runner   S 0fdf99e0     0  2624   2623
[  166.176938] Call Trace:
[  166.176940] [ddf45a10] [c01011f4] cfq_add_rq_rb+0xcc/0xd0 (unreliable)
[  166.176951] [ddf45ad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.176957] [ddf45af0] [c020fc88] schedule+0x194/0x390
[  166.176962] [ddf45b40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.176968] [ddf45b90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.176973] [ddf45f20] [c00a0378] sys_poll+0x74/0x88
[  166.176978] [ddf45f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.176984] --- Exception: c01 at 0xfdf99e0
[  166.176989]     LR = 0xfdf999c
[  166.176992] dhcdbd        S 0ff0ff5c     0  2649      1
[  166.176996] Call Trace:
[  166.176998] [ddfc1910] [c017bef0] ide_intr+0x260/0x264 (unreliable)
[  166.177005] [ddfc19d0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177010] --- Exception: dde53c00 at schedule_timeout+0x64/0xe4
[  166.177016]     LR = 0x61656d00
[  166.177019] [ddfc19f0] [c020fc88] schedule+0x194/0x390 (unreliable)
[  166.177025] [ddfc1a40] [c0210720] schedule_timeout+0x68/0xe4
[  166.177030] [ddfc1a90] [c00a0768] do_select+0x3dc/0x4a8
[  166.177035] [ddfc1d60] [c00a0acc] core_sys_select+0x298/0x380
[  166.177041] [ddfc1ec0] [c00a1258] sys_select+0x140/0x23c
[  166.177046] [ddfc1f10] [c0005240] ppc_select+0x104/0x128
[  166.177052] [ddfc1f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177057] --- Exception: c01 at 0xff0ff5c
[  166.177062]     LR = 0x100067c0
[  166.177065] NetworkManage S 0fb4ea34     0  2664      1
[  166.177069] Call Trace:
[  166.177072] [dd8a5a10] [c006c948] __alloc_pages+0x70/0x2e4 (unreliable)
[  166.177078] [dd8a5ad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177084] --- Exception: dd8a5bc4 at 0xdd8a5bc4
[  166.177089]     LR = 0xdd8a5b80
[  166.177092] [dd8a5af0] [c020fc88] schedule+0x194/0x390 (unreliable)
[  166.177097] [dd8a5b40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.177103] [dd8a5b90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.177108] [dd8a5f20] [c00a0378] sys_poll+0x74/0x88
[  166.177113] [dd8a5f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177119] --- Exception: c01 at 0xfb4ea34
[  166.177124]     LR = 0xfb4ea1c
[  166.177126] NetworkManage S 0fb4ea34     0  2683      1
[  166.177131] Call Trace:
[  166.177133] [ddb51a10] [ddb51d8c] 0xddb51d8c (unreliable)
[  166.177138] [ddb51ad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177144] [ddb51af0] [c020fc88] schedule+0x194/0x390
[  166.177149] [ddb51b40] [c0210720] schedule_timeout+0x68/0xe4
[  166.177155] [ddb51b90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.177160] [ddb51f20] [c00a034c] sys_poll+0x48/0x88
[  166.177165] [ddb51f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177171] --- Exception: c01 at 0xfb4ea34
[  166.177176]     LR = 0xfb4ea1c
[  166.177179] NetworkManage S 0fd089e0     0  2687      1
[  166.177183] Call Trace:
[  166.177185] [ddb4ba10] [c006c948] __alloc_pages+0x70/0x2e4 (unreliable)
[  166.177191] [ddb4bad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177197] [ddb4baf0] [c020fc88] schedule+0x194/0x390
[  166.177202] [ddb4bb40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.177208] [ddb4bb90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.177213] [ddb4bf20] [c00a0378] sys_poll+0x74/0x88
[  166.177218] [ddb4bf40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177224] --- Exception: c01 at 0xfd089e0
[  166.177229]     LR = 0xfd0899c
[  166.177232] system-tools- S 0fd909e0     0  2700      1
[  166.177236] Call Trace:
[  166.177239] [ddb73a10] [ddd9d0c0] 0xddd9d0c0 (unreliable)
[  166.177244] [ddb73ad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177249] [ddb73af0] [c020fc88] schedule+0x194/0x390
[  166.177255] [ddb73b40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.177260] [ddb73b90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.177266] [ddb73f20] [c00a0378] sys_poll+0x74/0x88
[  166.177271] [ddb73f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177276] --- Exception: c01 at 0xfd909e0
[  166.177281]     LR = 0xfd9099c
[  166.177284] dbus-daemon   S 0feb29e0     0  2701   2700
[  166.177288] Call Trace:
[  166.177291] [dd8ada10] [00001032] 0x1032 (unreliable)
[  166.177296] [dd8adad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177302] [dd8adaf0] [c020fc88] schedule+0x194/0x390
[  166.177307] [dd8adb40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.177313] [dd8adb90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.177318] [dd8adf20] [c00a0378] sys_poll+0x74/0x88
[  166.177323] [dd8adf40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177328] --- Exception: c01 at 0xfeb29e0
[  166.177333]     LR = 0xfeb299c
[  166.177336] dhclient      S 0ff4bf5c     0  2762   2649
[  166.177340] Call Trace:
[  166.177343] [ded93910] [ffffffff] 0xffffffff (unreliable)
[  166.177348] [ded939d0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177354] [ded939f0] [c020fc88] schedule+0x194/0x390
[  166.177359] [ded93a40] [c0210720] schedule_timeout+0x68/0xe4
[  166.177365] [ded93a90] [c00a0768] do_select+0x3dc/0x4a8
[  166.177370] [ded93d60] [c00a0acc] core_sys_select+0x298/0x380
[  166.177376] [ded93ec0] [c00a1258] sys_select+0x140/0x23c
[  166.177381] [ded93f10] [c0005240] ppc_select+0x104/0x128
[  166.177387] [ded93f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177392] --- Exception: c01 at 0xff4bf5c
[  166.177397]     LR = 0x1005fd8c
[  166.177400] gdm           S 0f14c9e0     0  2778      1
[  166.177404] Call Trace:
[  166.177406] [dd60ba10] [00000001] 0x1 (unreliable)
[  166.177411] [dd60bad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177417] [dd60baf0] [c020fc88] schedule+0x194/0x390
[  166.177423] [dd60bb40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.177428] [dd60bb90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.177433] [dd60bf20] [c00a0378] sys_poll+0x74/0x88
[  166.177439] [dd60bf40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177444] --- Exception: c01 at 0xf14c9e0
[  166.177449]     LR = 0xf14c99c
[  166.177452] gdm           S 0f14c9e0     0  2781   2778
[  166.177456] Call Trace:
[  166.177458] [c1ef3a10] [e20a4960] ide_do_rw_disk+0x330/0x5ac
[ide_disk] (unreliable)
[  166.177471] [c1ef3ad0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177476] [c1ef3af0] [c020fc88] schedule+0x194/0x390
[  166.177482] [c1ef3b40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.177487] [c1ef3b90] [c00a018c] do_sys_poll+0x338/0x4b0
[  166.177493] [c1ef3f20] [c00a0378] sys_poll+0x74/0x88
[  166.177498] [c1ef3f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177503] --- Exception: c01 at 0xf14c9e0
[  166.177508]     LR = 0xf14c99c
[  166.177511] Xorg          D 0f781064     0  2784   2781
[  166.177515] Call Trace:
[  166.177518] [dd62dbd0] [c0310000] __log_buf+0x364c/0x2000c (unreliable)
[  166.177528] [dd62dc90] [c0008ea0] __switch_to+0x5c/0x94
[  166.177534] [dd62dcb0] [c020fc88] schedule+0x194/0x390
[  166.177539] --- Exception: dd62dd90 at 0xdd62dd50
[  166.177544]     LR = 0x32851000
[  166.177547] [dd62dd00] [c021038c] io_schedule+0x30/0x54 (unreliable)
[  166.177553] [dd62dd20] [c0066dfc] sync_page+0x60/0x80
[  166.177561] [dd62dd30] [c0210938] __wait_on_bit_lock+0x98/0xf8
[  166.177567] [dd62dd60] [c0066d68] __lock_page+0x50/0x60
[  166.177572] [dd62dd90] [c00753ac] __do_fault+0x7b0/0x7e4
[  166.177580] [dd62ddf0] [c0016fb4] do_page_fault+0x16c/0x528
[  166.177588] [dd62df40] [c00135f8] handle_page_fault+0xc/0x80
[  166.177594] --- Exception: 301 at 0xf781064
[  166.177599]     LR = 0xf781390
[  166.177602] cupsd         S 0fb81f5c     0  2856      1
[  166.177606] Call Trace:
[  166.177608] [dd3fb910] [c0290000] __ksymtab___bitmap_parse+0x4/0x8
(unreliable)
[  166.177619] [dd3fb9d0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177625] [dd3fb9f0] [c020fc88] schedule+0x194/0x390
[  166.177631] [dd3fba40] [c0210720] schedule_timeout+0x68/0xe4
[  166.177636] [dd3fba90] [c00a0768] do_select+0x3dc/0x4a8
[  166.177642] [dd3fbd60] [c00a0acc] core_sys_select+0x298/0x380
[  166.177647] [dd3fbec0] [c00a1258] sys_select+0x140/0x23c
[  166.177652] [dd3fbf10] [c0005240] ppc_select+0x104/0x128
[  166.177658] [dd3fbf40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177664] --- Exception: c01 at 0xfb81f5c
[  166.177668]     LR = 0x1001bd44
[  166.177671] dirmngr       S 0fdfcf5c     0  2886      1
[  166.177675] Call Trace:
[  166.177678] [dcdd7910] [82004448] 0x82004448 (unreliable)
[  166.177683] [dcdd79d0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177689] [dcdd79f0] [c020fc88] schedule+0x194/0x390
[  166.177694] [dcdd7a40] [c0210720] schedule_timeout+0x68/0xe4
[  166.177699] [dcdd7a90] [c00a0768] do_select+0x3dc/0x4a8
[  166.177704] [dcdd7d60] [c00a0acc] core_sys_select+0x298/0x380
[  166.177710] [dcdd7ec0] [c00a1258] sys_select+0x140/0x23c
[  166.177715] [dcdd7f10] [c0005240] ppc_select+0x104/0x128
[  166.177721] [dcdd7f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177726] --- Exception: c01 at 0xfdfcf5c
[  166.177731]     LR = 0xfef0c4c
[  166.177734] mouseemu      S 0ff402e8     0  2912      1
[  166.177738] Call Trace:
[  166.177741] [de79dd40] [cfc9b4d0] 0xcfc9b4d0 (unreliable)
[  166.177746] [de79de00] [c0008ea0] __switch_to+0x5c/0x94
[  166.177752] [de79de20] [c020fc88] schedule+0x194/0x390
[  166.177757] [de79de70] [c0210e44] do_nanosleep+0x78/0xa8
[  166.177763] [de79de90] [c004a4b8] hrtimer_nanosleep+0x50/0x198
[  166.177773] [de79df10] [c004a6c8] sys_nanosleep+0xc8/0xcc
[  166.177779] [de79df40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177785] --- Exception: c01 at 0xff402e8
[  166.177790]     LR = 0xff400a4
[  166.177792] mouseemu      R running      0  2913   2912
[  166.177797] sshd          S 1fa9ef5c     0  2938      1
[  166.177801] Call Trace:
[  166.177804] [dc3e3910] [480a862d] 0x480a862d (unreliable)
[  166.177809] [dc3e39d0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177815] [dc3e39f0] [c020fc88] schedule+0x194/0x390
[  166.177820] [dc3e3a40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.177826] [dc3e3a90] [c00a0768] do_select+0x3dc/0x4a8
[  166.177831] [dc3e3d60] [c00a0acc] core_sys_select+0x298/0x380
[  166.177836] [dc3e3ec0] [c00a11d8] sys_select+0xc0/0x23c
[  166.177842] [dc3e3f10] [c0005240] ppc_select+0x104/0x128
[  166.177847] [dc3e3f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177853] --- Exception: c01 at 0x1fa9ef5c
[  166.177858]     LR = 0x2000f9c8
[  166.177861] atd           S 0ff152e8     0  3034      1
[  166.177865] Call Trace:
[  166.177867] [dbce9d40] [cfc9b4d0] 0xcfc9b4d0 (unreliable)
[  166.177873] [dbce9e00] [c0008ea0] __switch_to+0x5c/0x94
[  166.177879] [dbce9e20] [c020fc88] schedule+0x194/0x390
[  166.177884] [dbce9e70] [c0210e44] do_nanosleep+0x78/0xa8
[  166.177890] [dbce9e90] [c004a4b8] hrtimer_nanosleep+0x50/0x198
[  166.177896] [dbce9f10] [c004a6c8] sys_nanosleep+0xc8/0xcc
[  166.177902] [dbce9f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177907] --- Exception: c01 at 0xff152e8
[  166.177912]     LR = 0xff150a4
[  166.177915] cron          S 0fedc2e8     0  3048      1
[  166.177920] Call Trace:
[  166.177922] [dbcc1d40] [c009c04c] __link_path_walk+0x83c/0xf44 (unreliable)
[  166.177928] [dbcc1e00] [c0008ea0] __switch_to+0x5c/0x94
[  166.177934] [dbcc1e20] [c020fc88] schedule+0x194/0x390
[  166.177940] [dbcc1e70] [c0210e44] do_nanosleep+0x78/0xa8
[  166.177945] [dbcc1e90] [c004a4b8] hrtimer_nanosleep+0x50/0x198
[  166.177951] [dbcc1f10] [c004a6c8] sys_nanosleep+0xc8/0xcc
[  166.177957] [dbcc1f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.177963] --- Exception: c01 at 0xfedc2e8
[  166.177968]     LR = 0xfedc0a4
[  166.177971] sshd          S 1fa9ef5c     0  3184   2938
[  166.177975] Call Trace:
[  166.177978] [dbfb7910] [c0035ac8] irq_exit+0x48/0x58 (unreliable)
[  166.177987] [dbfb79d0] [c0008ea0] __switch_to+0x5c/0x94
[  166.177992] [dbfb79f0] [c020fc88] schedule+0x194/0x390
[  166.177998] [dbfb7a40] [c0210754] schedule_timeout+0x9c/0xe4
[  166.178003] [dbfb7a90] [c00a0768] do_select+0x3dc/0x4a8
[  166.178009] [dbfb7d60] [c00a0acc] core_sys_select+0x298/0x380
[  166.178014] [dbfb7ec0] [c00a11d8] sys_select+0xc0/0x23c
[  166.178020] [dbfb7f10] [c0005240] ppc_select+0x104/0x128
[  166.178025] [dbfb7f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.178030] --- Exception: c01 at 0x1fa9ef5c
[  166.178035]     LR = 0x200164dc
[  166.178038] bash          S 0fed0b94     0  3186   3184
[  166.178043] Call Trace:
[  166.178045] [db803cd0] [00000001] 0x1 (unreliable)
[  166.178050] [db803d90] [c0008ea0] __switch_to+0x5c/0x94
[  166.178056] [db803db0] [c020fc88] schedule+0x194/0x390
[  166.178061] [db803e00] [c0210754] schedule_timeout+0x9c/0xe4
[  166.178066] [db803e50] [c0157268] read_chan+0x198/0x67c
[  166.178073] [db803ec0] [c0154854] tty_read+0xa4/0xe0
[  166.178078] [db803ef0] [c0091308] vfs_read+0xe8/0x198
[  166.178083] [db803f10] [c009178c] sys_read+0x4c/0x90
[  166.178088] [db803f40] [c00131cc] ret_from_syscall+0x0/0x38
[  166.178094] --- Exception: c01 at 0xfed0b94
[  166.178099]     LR = 0x1009c1c4
