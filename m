Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZBEPpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZBEPpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 10:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZBEPpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 10:45:35 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:63588 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751863AbZBEPpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 10:45:34 -0500
Date: Thu, 5 Feb 2009 18:45:29 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 2/3] powerpc: Make it possible to safely select
	CONFIG_FRAME_POINTER
Message-ID: <20090205154529.GA20678@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090204150755.GA24163@oksana.dev.rtsoft.ru> <20090204150838.GB30027@oksana.dev.rtsoft.ru> <1233793889.4612.33.camel@pasglop> <1233794154.16878.20.camel@localhost.localdomain> <1233796531.4612.35.camel@pasglop> <20090205013023.GA31417@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090205013023.GA31417@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 04:30:23AM +0300, Anton Vorontsov wrote:
[...]
> > > > > Remove -fno-omit-frame-pointer flag from CFLAGS.
> > > > > Remove -fno-omit-frame-pointer workarounds.
> > > > 
> > > > But what about -pg -requires -fno-omit-frame-pointer ?
> > > 
> > > I don't think it requires -fno-omit-frame-pointer. It is just
> > > incompatible with -fomit-frame-pointer.
> > 
> > From a quick test, you seem to be right.
> > 
> > Now the question of course is whether -pg will internally trigger
> > the bug for which we need the workaround tho...
> 
> According to http://marc.info/?l=linux-kernel&m=121958694215835&w=4
> just removing -fno-omit-frame-pointer solved the problem.
> 
> But I'll double check that on the actual hardware.

Confirmed. Just -pg doesn't cause any ill effects (for the test
I built kernel on a ppc32 board).

While simply adding -fno-omit-frame-pointer caused this during
bootup:

...
Waiting for /dev to be fully populated...
Unable to handle kernel paging request for data at address 0x00000901
Faulting instruction address: 0xc00d9a4c
Oops: Kernel access of bad area, sig: 11 [#1]
MPC837x RDB
Modules linked in:
NIP: c00d9a4c LR: c00d9a34 CTR: c015ac7c
REGS: cf197cd0 TRAP: 0300   Not tainted  (2.6.29-rc3-45527-g727839a-dirty)
MSR: 00009032 <EE,ME,IR,DR>  CR: 44084228  XER: 20000000
DAR: 00000901, DSISR: 22000000
TASK = cfa42a80[1140] 'udevd' THREAD: cf196000
GPR00: fffff000 cf197d80 cfa42a80 cf4213f0 c058e678 00000003 cf42145a 7f7f7f7f
GPR08: 0000012c 00000000 c0580000 cf197d80 84084228 1002414c cf197e9c c058e7b4
GPR16: c058e678 fffffff4 c05b0000 cf197dc0 cf197db8 cf197dc8 00000000 00000000
GPR24: c00e4e30 00000000 24084222 00000001 00000901 cf197e98 cf4213f0 cf197d80
NIP [c00d9a4c] do_lookup+0x7c/0xf8
LR [c00d9a34] do_lookup+0x64/0xf8
Call Trace:
[cf197d80] [c00d9a34] do_lookup+0x64/0xf8 (unreliable)
[cf197db0] [c00db73c] __link_path_walk+0x180/0xdc4
[cf197e30] [c00dc3d8] path_walk+0x58/0xe0
[cf197e60] [c00dc55c] do_path_lookup+0x8c/0x164
[cf197e90] [c00dd260] user_path_at+0x64/0xac
[cf197f00] [c00d3760] sys_readlinkat+0x40/0xb4
[cf197f30] [c00d380c] sys_readlink+0x38/0x50
[cf197f40] [c0018040] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfed4754
    LR = 0x10006280
Instruction dump:
80090000 2f800000 419e0028 7fa4eb78 7c0903a6 4e800421 7c7b1b79 40810040
3800f000 7fc3f378 7f9e0040 419d0018 <935c0000> 7f83e378 93dc0004 4bfffcd1
---[ end trace 4815c47675962320 ]---

FWIW, gcc version 4.2.0.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
