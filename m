Return-Path: <linux-kernel-owner+w=401wt.eu-S937340AbXGTRfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937340AbXGTRfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937120AbXGTRek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:34:40 -0400
Received: from smtp2.Stanford.EDU ([171.67.20.25]:54468 "EHLO
	smtp2.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764512AbXGTReh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:34:37 -0400
Subject: Re: [patch] slub crashes with recent -git
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070719194234.GA27917@elte.hu>
References: <20070719194234.GA27917@elte.hu>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 10:34:34 -0700
Message-Id: <1184952874.12655.4.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-19 at 21:42 +0200, Ingo Molnar wrote:
> Linus, Christoph,
> 
> recent slub commits in -git cause this bootup crash:
> 
>  Freeing unused kernel memory: 324k freed
>  Write protecting the kernel read-only data: 1294k

Just curious, are the crashes even possible in 2.6.22.1? (I see the same
patchable code snippet in the source). Just wondering if I should also
apply this to 2.6.21.1-rt4...

-- Fernando


>  ------------[ cut here ]------------
>  kernel BUG at mm/slub.c:2401!
>  invalid opcode: 0000 [#1]
>  PREEMPT SMP 
>  Modules linked in:
>  CPU:    0
>  EIP:    0060:[<c017dac3>]    Not tainted VLI
>  EFLAGS: 00010046   (2.6.22 #1)
>  EIP is at ksize+0x13/0x42
>  eax: 00000000   ebx: 00000000   ecx: 00000020   edx: 00000000
>  esi: f76a4000   edi: 00000004   ebp: f7b11e74   esp: f7b11e74
>  ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
>  Process udevd (pid: 824, ti=f7b11000 task=f7ca5000 task.ti=f7b11000)
>  Stack: f7b11e94 c016c28b f768cb00 00000020 f7ca5000 00000004 f76a4000 fffffff4 
>         f7b11eb4 c03cf158 00000002 f76a4000 00000020 f768cb00 f76a4000 f7b11ed8 
>         f7b11ed0 c03cfbc6 f768cb00 f768cb00 c046bf80 f768cb00 0000000c f7b11f6c 
>  Call Trace:
>   [<c0105e3e>] show_trace_log_lvl+0x19/0x2e
>   [<c0105ef0>] show_stack_log_lvl+0x9d/0xa5
>   [<c010628f>] show_registers+0x1f5/0x334
>   [<c01064e6>] die+0x118/0x1fc
>   [<c0426e7f>] do_trap+0x8e/0xa8
>   [<c0106ac3>] do_invalid_op+0x88/0x92
>   [<c0426a92>] error_code+0x72/0x78
>   [<c016c28b>] krealloc+0x27/0x6d
>   [<c03cf158>] netlink_realloc_groups+0x61/0xd9
>   [<c03cfbc6>] netlink_bind+0x4f/0x121
>   [<c03afe8d>] sys_bind+0x67/0x86
>   [<c03b11e3>] sys_socketcall+0x8f/0x244
>   [<c0104ef2>] sysenter_past_esp+0x6b/0xb5
>   =======================
>  Code: 40 02 00 75 03 8b 52 0c 8b 02 5d 84 c0 b8 00 00 00 00 0f 49 d0 89 d0 c3 55 31 d2 83 f8 10 89 e5 74 34 e8 bc ff ff ff 85 c0 75 04 <0f> 0b eb fe 8b 40 10 85 c0 75 04 0f 0b eb fe 8b 10 f6 c6 0c 74 
> 
> i had to apply the patch below to make the kernel boot again.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Index: linux/mm/slub.c
> ===================================================================
> --- linux.orig/mm/slub.c
> +++ linux/mm/slub.c
> @@ -2394,7 +2394,7 @@ size_t ksize(const void *object)
>  	struct page *page;
>  	struct kmem_cache *s;
>  
> -	if (object == ZERO_SIZE_PTR)
> +	if (object == ZERO_SIZE_PTR || !object)
>  		return 0;
>  
>  	page = get_object_page(object);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

