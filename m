Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZK0PR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZK0PR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 10:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbZK0PR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 10:17:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:41514 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZK0PR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 10:17:57 -0500
Subject: Re: WARNING: kernel/smp.c:292 smp_call_function_single [Was: mmotm
 2009-11-24-16-47 uploaded]
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B0FEA3E.5050108@gmail.com>
References: <200911250111.nAP1BFg5030254@imap1.linux-foundation.org>
	 <4B0FEA3E.5050108@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Nov 2009 16:17:16 +0100
Message-ID: <1259335036.6483.440.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-27 at 16:03 +0100, Jiri Slaby wrote:
> On 11/25/2009 01:47 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-11-24-16-47 has been uploaded to
> 
> Hi, when executing qemu-kvm I often get following warning and a hard lockup.
> 
> WARNING: at kernel/smp.c:292 smp_call_function_single+0xbd/0x140()
> Hardware name: To Be Filled By O.E.M.
> Modules linked in: kvm_intel kvm fuse ath5k ath
> Pid: 3265, comm: qemu-kvm Not tainted 2.6.32-rc8-mm1_64 #912
> Call Trace:
>  [<ffffffff81039678>] warn_slowpath_common+0x78/0xb0
>  [<ffffffffa007fd50>] ? __vcpu_clear+0x0/0xd0 [kvm_intel]
>  [<ffffffff810396bf>] warn_slowpath_null+0xf/0x20
>  [<ffffffff8106410d>] smp_call_function_single+0xbd/0x140
>  [<ffffffffa0080af6>] vmx_vcpu_load+0x46/0x170 [kvm_intel]
>  [<ffffffffa004dd94>] kvm_arch_vcpu_load+0x24/0x60 [kvm]
>  [<ffffffffa0047a8d>] kvm_sched_in+0xd/0x10 [kvm]
>  [<ffffffff8102de37>] finish_task_switch+0x67/0xc0
>  [<ffffffff814699f8>] schedule+0x2f8/0x9c0

> 
> It is a regression against 2009-11-13-19-59.
> 
> Any ideas?

Looks like kvm is trying to send an IPI from the preempt notifiers,
which are called with IRQs disabled, not a sane thing to do.

If they really want that, they'll have to use a pre-allocated struct
call_single_data and use __smp_call_function_single.

