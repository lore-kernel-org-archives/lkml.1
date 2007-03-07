Return-Path: <linux-kernel-owner+w=401wt.eu-S2992707AbXCGWzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992707AbXCGWzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992536AbXCGWzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:55:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992723AbXCGWuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:50:14 -0500
Date: Wed, 7 Mar 2007 14:46:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <hansendc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: 2.6.21-rc2-mm2 hang
Message-Id: <20070307144647.735311cf.akpm@linux-foundation.org>
In-Reply-To: <1173305536.868.8.camel@localhost.localdomain>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<1173305536.868.8.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 14:12:16 -0800
Dave Hansen <hansendc@us.ibm.com> wrote:

> I'm seeing weird hangs running ltp on 2.6.21-rc2-mm2.  It manifests
> itself by the waitpid06 test in LTP hanging.  This is very, very
> reproducible in about 5 seconds by adding '-s wait' to the ltp command
> line.
> 
> I see 4 waitpid06 processes on my 4-way machine spinning in userspace.
> But, the weird part is that I can't ssh in once this happens, but I can
> log in to the console.  I've bisected it down to:
>         
>         sched-fix-idle-load-balancing-in-softirqd-context
> 
> http://sr71.net/~dave/linux/elm3b82-config
> 
> sysrq-t:
> 
> bash          S 00000001     0  1670   1667  1676               (NOTLB)
>        f761ff18 00000086 00000000 00000001 f7afb3ac c16f5f6c f761ff1c c0146eb5
>        e93d3067 fffb8000 f761ff20 c2d922e0 f7ec4030 f7ec413c 00006db1 1457ab10
>        00000025 c038eb60 fffffe00 f7ec4030 f7ec40e4 f761ff88 c011bc38 c014800d
> Call Trace:
>  [<c011bc38>] do_wait+0x271/0x316
>  [<c011bd86>] sys_wait4+0x2f/0x31
>  [<c011bdaf>] sys_waitpid+0x27/0x2c
>  [<c010265c>] syscall_call+0x7/0xb
>  =======================
> runltp        S 00000001     0  1676   1670  1780               (NOTLB)
>        f7625f18 00000082 00000000 00000001 f7adf3ac c16f5bec f7625f1c c0146eb5
>        e8cf4067 fffab000 f7625f20 c2d9a2e0 c30ee050 c30ee15c 00007d8f 3c8acf22
>        00000025 c309e560 fffffe00 c30ee050 c30ee104 f7625f88 c011bc38 c014800d
> Call Trace:
>  [<c011bc38>] do_wait+0x271/0x316
>  [<c011bd86>] sys_wait4+0x2f/0x31
>  [<c011bdaf>] sys_waitpid+0x27/0x2c
>  [<c010265c>] syscall_call+0x7/0xb
>  =======================
> pan           S 00000000     0  1780   1676  1831               (NOTLB)
>        f7639f30 00000086 00000000 00000000 00000000 00000246 f7ad095c f7f0e760
>        00000000 f7639f0c c0162748 c2d922e0 f7a0aab0 f7a0abbc 0000edaf abaf1d13
>        00000026 c038eb60 fffffe00 f7a0aab0 f7a0ab64 f7639fa0 c011bc38 e97e7065
> Call Trace:
>  [<c011bc38>] do_wait+0x271/0x316
>  [<c011bd86>] sys_wait4+0x2f/0x31
>  [<c010265c>] syscall_call+0x7/0xb
>  =======================
> waitpid06     S 00000001     0  1831   1780  1832               (NOTLB)
>        f7637f18 00000082 00000000 00000001 f769b134 c16ed36c f7637f1c c0146eb5
>        f7a38c80 00000000 f7bce030 c2d9a2e0 f7e78030 f7e7813c 00000f64 abdcd3a1
>        00000026 f7bce030 fffffe00 f7e78030 f7e780e4 f7637f88 c011bc38 c014800d
> Call Trace:
>  [<c011bc38>] do_wait+0x271/0x316
>  [<c011bd86>] sys_wait4+0x2f/0x31
>  [<c011bdaf>] sys_waitpid+0x27/0x2c
>  [<c010265c>] syscall_call+0x7/0xb
>  =======================
> 

Michal has reported a similar thing in recent -mm's. 
sched-fix-idle-load-balancing-in-softirqd-context was added in
2.6.21-rc2-mm1.

I'll drop sched-fix-idle-load-balancing-in-softirqd-context.patch and
sched-fix-idle-load-balancing-in-softirqd-context-fix.patch and, as a
consequence, sched-dynticks-idle-load-balancing-v3.patch.

Thanks for doing the bisect - it really helps.
