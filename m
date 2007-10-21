Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbXJUULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbXJUULW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 16:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbXJUULN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 16:11:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:57956 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751843AbXJUULL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 16:11:11 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/+exEBoI/+23iq693TiTsyELUWFcDiMgOSnNOWDf
	JcJBytLSgZwHqT
Date: Sun, 21 Oct 2007 22:11:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ray Lee <ray-lk@madrabbit.org>
cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: ext3 deadlock or Re: [2.6.23] tasks stuck in running state?
In-Reply-To: <2c0942db0710191808u7e417ac7ra93583fd15ffab36@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710212201190.3254@axis700.grange>
References: <47192425.6020507@garzik.org> <2c0942db0710191808u7e417ac7ra93583fd15ffab36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007, Ray Lee wrote:

> On 10/19/07, Jeff Garzik <jeff@garzik.org> wrote:
> > On my main devel box, vanilla 2.6.23 on x86-64/Fedora-7, I'm seeing a
> > certain behavior at least once a day.  I'll start a kernel build (make
> > -sj5 on this box), and it will "hang" in the following way:
> >
> > > 31003 ?        S      0:04 sshd: jgarzik@pts/0
> > > 31004 pts/0    Ss     0:02  \_ -bash
> > >  8280 pts/0    S+     0:00      \_ make ARCH=i386 -sj4
> > >  8690 pts/0    Z+     0:00          \_ [rm] <defunct>
> > >  8691 pts/0    S+     0:00          \_ /bin/sh -c cat include/config/kernel.release 2> /dev/null
> > >  8692 pts/0    R+     6:12              \_ cat include/config/kernel.release
> >
> > Specifically, the symptom is a process, often a simple one like cat(1)
> > or rm(1) or somewhere in check-headers, will stay in the running state,
> > accumulating CPU time.
> >
> > If I Ctrl-C the build, and start over, the build will normally -not- get
> > stuck at the same point, but proceed to chew through one of a bazillion
> > allmodconfig builds.
> 
> I *think* I'm seeing this with firefox under 2.6.23-rc6. I tried a
> `killall -SIGSTOP firefox; killall -SIGCONT firefox` and when I looked
> back it was back to life again, but that may have been a fluke.
> Regardless, try that the next time it happens?

Don't know if that's the same problem as above, but a few minutes ago my 
mail-server locked down completely. First pine froze, then more processes 
started freezing, then the system became unusable, ssh logins got stuck, 
USB- and ps/2 keyboards. I managed to get a trace with the "w" sysrq:

SysRq : Show Blocked State
  task                PC stack   pid father
syslogd       D c01275a3     0  2818      1
       e8a1fe4c 00000086 e8a1fe4c c01275a3 f7e9a200 00000282 e8a1fe5c 00b5ce60
       c1b05cc0 e8a1fe7c c030c8e7 e8a1ff30 c8d553c4 c0407348 c1b58b18 00b5ce60
       c01277d0 c1b1ba90 c0407040 000000da d5f806c0 e8a1fe84 c030c974 e8a1feb4
Call Trace:
 [<c030c8e7>] schedule_timeout+0x47/0xc0
 [<c030c974>] schedule_timeout_uninterruptible+0x14/0x20
 [<c01b94cb>] journal_stop+0xcb/0x270
 [<c01ba1fd>] journal_force_commit+0x1d/0x30
 [<c01b2265>] ext3_force_commit+0x25/0x30
 [<c01ac7dc>] ext3_write_inode+0x2c/0x40
 [<c0183f8b>] __writeback_single_inode+0x30b/0x3e0
 [<c01849b4>] sync_inode+0x24/0x60
 [<c01a8d42>] ext3_sync_file+0xc2/0xd0
 [<c0187340>] do_fsync+0x60/0xa0
 [<c01873a8>] __do_fsync+0x28/0x40
 [<c01873ed>] sys_fsync+0xd/0x10
 [<c010424e>] sysenter_past_esp+0x5f/0x85
 =======================
pine          D c01275a3     0  6910   6243
       d1f55e4c 00200082 c03c0e40 c01275a3 f7e42c80 00200282 d1f55e5c 00b5ce60
       c1b05cc0 d1f55e7c c030c8e7 d1f55f30 c8d553d8 c1b58b18 c90a9e5c 00b5ce60
       c01277d0 d8ae8a90 c0407040 000000c3 d5f806c0 d1f55e84 c030c974 d1f55eb4
Call Trace:
 [<c030c8e7>] schedule_timeout+0x47/0xc0
 [<c030c974>] schedule_timeout_uninterruptible+0x14/0x20
 [<c01b94cb>] journal_stop+0xcb/0x270
 [<c01ba1fd>] journal_force_commit+0x1d/0x30
 [<c01b2265>] ext3_force_commit+0x25/0x30
 [<c01ac7dc>] ext3_write_inode+0x2c/0x40
 [<c0183f8b>] __writeback_single_inode+0x30b/0x3e0
 [<c01849b4>] sync_inode+0x24/0x60
 [<c01a8d42>] ext3_sync_file+0xc2/0xd0
 [<c0187340>] do_fsync+0x60/0xa0
 [<c01873a8>] __do_fsync+0x28/0x40
 [<c01873ed>] sys_fsync+0xd/0x10
 [<c010424e>] sysenter_past_esp+0x5f/0x85
 =======================
sendmail      D c01275a3     0  7448   7446
       c90a9e4c 00000082 c03c0e40 c01275a3 f7e00580 00000282 c90a9e5c 00b5ce60
       c1b05cc0 c90a9e7c c030c8e7 c90a9f30 c8d553ec d1f55e5c c0407348 00b5ce60
       c01277d0 d8ae8030 c0407040 0000004b d5f806c0 c90a9e84 c030c974 c90a9eb4
Call Trace:
 [<c030c8e7>] schedule_timeout+0x47/0xc0
 [<c030c974>] schedule_timeout_uninterruptible+0x14/0x20
 [<c01b94cb>] journal_stop+0xcb/0x270
 [<c01ba1fd>] journal_force_commit+0x1d/0x30
 [<c01b2265>] ext3_force_commit+0x25/0x30
 [<c01ac7dc>] ext3_write_inode+0x2c/0x40
 [<c0183f8b>] __writeback_single_inode+0x30b/0x3e0
 [<c01849b4>] sync_inode+0x24/0x60
 [<c01a8d42>] ext3_sync_file+0xc2/0xd0
 [<c0187340>] do_fsync+0x60/0xa0
 [<c01873a8>] __do_fsync+0x28/0x40
 [<c01873ed>] sys_fsync+0xd/0x10
 [<c010424e>] sysenter_past_esp+0x5f/0x85
 =======================

now you see why I wrote "ext3 deadlock." It's y VIA C7 system, running 
2.6.23-rc9-g804b3f9a, no problems since 5 October, when the kernel has 
been built. No Oops / warnings in dmesg. Or has this been fixed since 
23-rc9?

Thanks
Guennadi
---
Guennadi Liakhovetski
