Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYIXObk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYIXObk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 10:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYIXObb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 10:31:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60219 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbYIXObb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 10:31:31 -0400
Date: Wed, 24 Sep 2008 10:31:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [Patch -tip] x86/ftrace: use uaccess in atomic context
In-Reply-To: <48DA5D6C.4010008@gmail.com>
Message-ID: <alpine.DEB.1.10.0809241030460.31061@gandalf.stny.rr.com>
References: <48DA5D6C.4010008@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Sep 2008, Fr?d?ric Weisbecker wrote:

> Hello,
> 
> With last -tip I get this bug:
> 
> [   49.439988] in_atomic():0, irqs_disabled():1
> [   49.440118] INFO: lockdep is turned off.
> [   49.440118] Pid: 2814, comm: modprobe Tainted: G        W 2.6.27-rc7 #4
> [   49.440118]  [<c01215e1>] __might_sleep+0xe1/0x120
> [   49.440118]  [<c01148ea>] ftrace_modify_code+0x2a/0xd0
> [   49.440118]  [<c01148a2>] ? ftrace_test_p6nop+0x0/0xa
> [   49.440118]  [<c016e80e>] __ftrace_update_code+0xfe/0x2f0
> [   49.440118]  [<c01148a2>] ? ftrace_test_p6nop+0x0/0xa
> [   49.440118]  [<c016f190>] ftrace_convert_nops+0x50/0x80
> [   49.440118]  [<c016f1d6>] ftrace_init_module+0x16/0x20
> [   49.440118]  [<c015498b>] load_module+0x185b/0x1d30
> [   49.440118]  [<c01767a0>] ? find_get_page+0x0/0xf0
> [   49.440118]  [<c02463c0>] ? sprintf+0x0/0x30
> [   49.440118]  [<c034e012>] ? mutex_lock_interruptible_nested+0x1f2/0x350
> [   49.440118]  [<c0154eb3>] sys_init_module+0x53/0x1b0
> [   49.440118]  [<c0352340>] ? do_page_fault+0x0/0x740
> [   49.440118]  [<c0104012>] syscall_call+0x7/0xb
> [   49.440118]  =======================
> 
> It is because ftrace_modify_code() calls copy_to_user and 
> copy_from_user.
> These functions have been inserted after guessing that there 
> couldn't be any race condition but copy_[to/from]_user might 
> sleep and __ftrace_update_code is called with local_irq_saved.
> 
> These function have been inserted since this commit:
> d5e92e8978fd2574e415dc2792c5eb592978243d: 
> "ftrace: x86 use copy from user function"
> 
> Following is a patch which correct it.
> ---
> Adapt uaccess functions's use to atomic context in ftrace_modify_code()
> since we are in IRQ-off context: __ftrace_update_code() calls
> local_irq_save().
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---

I had this exact patch sitting it my quilt queue. I thought I sent it out, 
but it must have been lost in the noise.

Thanks,

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

