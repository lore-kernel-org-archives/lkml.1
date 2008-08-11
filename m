Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYHKSS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYHKSS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 14:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbYHKSSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 14:18:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:16275 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbYHKSSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 14:18:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,189,1217833200"; 
   d="scan'208";a="428227659"
Date: Mon, 11 Aug 2008 11:17:52 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Al Viro <viro@ZenIV.linux.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Wolfgang Walter <wolfgang.walter@stwm.de>
Subject: Re: [2.6.27-rc2-git4] Kernel panic on VIA Ester+VIA CX700
Message-ID: <20080811181752.GK13158@linux-os.sc.intel.com>
References: <20080809220154.GO28946@ZenIV.linux.org.uk> <E1KS2KD-0000he-00@gondolin.me.apana.org.au> <20080810133056.2fd69a20@neptune.home> <489F7C2B.30807@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <489F7C2B.30807@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2008 at 04:39:23PM -0700, H. Peter Anvin wrote:
> Bruno Prémont wrote:
> >
> > Recompiling without viafb+squashfs patches makes the panic go away.
> >
> > So something from viafb or squashfs triggers the panic or prepare
> > for something else to trigger it...
> >
> 
> Out of those, viafb by far seems most likely.  Could you try compiling
> with only one or the other?

[    5.010629] general protection fault: 0000 [#1] 
[    5.021782] Modules linked in:
[    5.030227] 
[    5.030227] Pid: 3, comm: ksoftirqd/0 Not tainted (2.6.27-rc2-git4_nocrypto #1)
[    5.030227] EIP: 0060:[<c01042f5>] EFLAGS: 00010046 CPU: 0
[    5.030227] EIP is at math_state_restore+0x25/0x60
[    5.030227] EAX: f781db3d EBX: f781d898 ECX: 00000000 EDX: 00000000
[    5.030227] ESI: f781d000 EDI: f782c20c EBP: f781d840 ESP: f781d838
[    5.030227]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    5.030227] Process ksoftirqd/0 (pid: 3, ti=f781d000 task=f782c6a0 task.ti=f782a000)
[    5.030227] Stack: f782c000 f782c6a0 f781d890 c01038dd f782c000 00000000 f782c000 f782c6a0 
[    5.030227]        f782c20c f781d890 f7807e00 0000007b 0000007b 00000000 ffffffff c0101e8f 
[    5.030227]        00000060 00010002 f782c8ac f782c000 c04d8180 c011fa50 f782afc0 c03cfa61 
[    5.030227] Call Trace:
[    5.030227]  [<c01038dd>] ? device_not_available+0x2d/0x32
[    5.030227]  [<c0101e8f>] ? __switch_to+0x2f/0x130

It got a GP fault, because in __switch_to() we were doing unlazy_fpu() and
fxsave generated a DNA fault(which shouldn't happen unless we are hitting the
via padlock instruction issue or something else) and the math_state_restore()
found the task's math state pointer to be 0xf781db3d (EAX in the oops) and while
doing fxrstor we got GP fault, as the fxrstor pointer(EAX) is not 16byte
aligned.

It is interesting to see the EAX value similar to stack pointer. Task's
FP area gets dynamically allocated and as such EAX def looks wrong here.
I also see the config is using 4K stacks. Some config(viafb/squashfs?) causing
some thing wrong with the kernel stack?
