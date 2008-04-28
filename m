Return-Path: <linux-kernel-owner+w=401wt.eu-S935966AbYD1Q1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935966AbYD1Q1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934694AbYD1Q1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:27:43 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41144 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933918AbYD1Q1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:27:42 -0400
Message-ID: <4815FAFF.8010701@sgi.com>
Date: Mon, 28 Apr 2008 09:27:43 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/11] x86: cleanup early per cpu variables/accesses	v5-folded
References: <20080426001548.829332000@polaris-admin.engr.sgi.com> <20080428134253.GD3973@elte.hu> <20080428151339.GA25626@elte.hu>
In-Reply-To: <20080428151339.GA25626@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, I'll check it out asap.  It does look like a pda was accessed too
early.  Having "CONFIG_DEBUG_PER_CPU_MAPS" on might help with this.

Mike

Ingo Molnar wrote:
...
> got this early crash:
> 
>  Allocating PCI resources starting at 50000000 (gap: 40000000:a0000000)
>  PERCPU: Allocating 32864 bytes of per cpu data
>  PANIC: early exception 0e rip 10:ffffffff80aa9683 error 2 cr2 8
>  Pid: 0, comm: swapper Not tainted 2.6.25-sched-devel.git-x86-latest.git  #93
> 
>  Call Trace:
>  PANIC: early exception 0e rip 10:ffffffff8020cd69 error 0 cr2 30
> 
>   http://redhat.com/~mingo/misc/config-Mon_Apr_28_16_20_05_CEST_2008.bad
>   http://redhat.com/~mingo/misc/log-Mon_Apr_28_16_20_05_CEST_2008.bad
> 
> ... from the dreaded randconfig tester :)
> 
> the crash secondary one in dump_trace(), see below. Seems percpu data 
> structures are confused?
> 
> 	Ingo
> 
> ---------------------->
> ffffffff8020cd20 <dump_trace>:
> ffffffff8020cd20:	55                   	push   %rbp
> ffffffff8020cd21:	48 89 e5             	mov    %rsp,%rbp
> ffffffff8020cd24:	41 57                	push   %r15
> ffffffff8020cd26:	41 56                	push   %r14
> ffffffff8020cd28:	41 55                	push   %r13
> ffffffff8020cd2a:	41 54                	push   %r12
> ffffffff8020cd2c:	53                   	push   %rbx
> ffffffff8020cd2d:	48 83 ec 48          	sub    $0x48,%rsp
> ffffffff8020cd31:	e8 5a e8 ff ff       	callq  ffffffff8020b590 <mcount>
> ffffffff8020cd36:	65 8b 04 25 24 00 00 	mov    %gs:0x24,%eax
> ffffffff8020cd3d:	00 
> ffffffff8020cd3e:	89 c0                	mov    %eax,%eax
> ffffffff8020cd40:	49 89 d4             	mov    %rdx,%r12
> ffffffff8020cd43:	48 89 4d a8          	mov    %rcx,-0x58(%rbp)
> ffffffff8020cd47:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
> ffffffff8020cd4e:	00 
> ffffffff8020cd4f:	4c 89 45 a0          	mov    %r8,-0x60(%rbp)
> ffffffff8020cd53:	4c 89 4d 98          	mov    %r9,-0x68(%rbp)
> ffffffff8020cd57:	48 85 ff             	test   %rdi,%rdi
> ffffffff8020cd5a:	48 89 55 b0          	mov    %rdx,-0x50(%rbp)
> ffffffff8020cd5e:	48 8b 15 ab 0b 88 00 	mov    0x880bab(%rip),%rdx        # ffffffff80a8d910 <_cpu_pda>
> ffffffff8020cd65:	48 8b 04 c2          	mov    (%rdx,%rax,8),%rax
> ffffffff8020cd69:	48 8b 48 30          	mov    0x30(%rax),%rcx
> ffffffff8020cd6d:	0f 84 8a 03 00 00    	je     ffffffff8020d0fd <dump_trace+0x3dd>
> ffffffff8020cd73:	48 8b 5f 08          	mov    0x8(%rdi),%rbx
> ffffffff8020cd77:	4d 85 e4             	test   %r12,%r12
> ffffffff8020cd7a:	48 89 5d c0          	mov    %rbx,-0x40(%rbp)
> ffffffff8020cd7e:	0f 84 57 03 00 00    	je     ffffffff8020d0db <dump_trace+0x3bb>
> ffffffff8020cd84:	48 83 7d a8 00       	cmpq   $0x0,-0x58(%rbp)
> ffffffff8020cd89:	75 20                	jne    ffffffff8020cdab <dump_trace+0x8b>
> ffffffff8020cd8b:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
> ffffffff8020cd92:	00 00 
> ffffffff8020cd94:	48 39 c7             	cmp    %rax,%rdi
> ffffffff8020cd97:	0f 84 6e 03 00 00    	je     ffffffff8020d10b <dump_trace+0x3eb>
> ffffffff8020cd9d:	48 8b 87 b0 03 00 00 	mov    0x3b0(%rdi),%rax
> ffffffff8020cda4:	48 8b 00             	mov    (%rax),%rax
> ffffffff8020cda7:	48 89 45 a8          	mov    %rax,-0x58(%rbp)
> ffffffff8020cdab:	49 89 ce             	mov    %rcx,%r14
> ffffffff8020cdae:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%rbp)
> ffffffff8020cdb5:	48 c7 c1 20 24 af 80 	mov    $0xffffffff80af2420,%rcx
> ffffffff8020cdbc:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
> ffffffff8020cdc0:	48 8b 5d b0          	mov    -0x50(%rbp),%rbx
> ffffffff8020cdc4:	31 ff                	xor    %edi,%edi
> ffffffff8020cdc6:	48 8b 04 13          	mov    (%rbx,%rdx,1),%rax
> ffffffff8020cdca:	4c 8b 48 08          	mov    0x8(%rax),%r9
> ffffffff8020cdce:	66 90                	xchg   %ax,%ax
> ffffffff8020cdd0:	89 f8                	mov    %edi,%eax
> ffffffff8020cdd2:	48 8b 5d 90          	mov    -0x70(%rbp),%rbx
> ffffffff8020cdd6:	89 f9                	mov    %edi,%ecx
> ffffffff8020cdd8:	48 8d 34 c5 00 00 00 	lea    0x0(,%rax,8),%rsi
> ffffffff8020cddf:	00 
> ffffffff8020cde0:	4a 8d 04 0e          	lea    (%rsi,%r9,1),%rax
> ffffffff8020cde4:	48 8b 14 18          	mov    (%rax,%rbx,1),%rdx
> ffffffff8020cde8:	49 39 d4             	cmp    %rdx,%r12
> ffffffff8020cdeb:	73 19                	jae    ffffffff8020ce06 <dump_trace+0xe6>
> ffffffff8020cded:	4c 8d 82 00 f0 ff ff 	lea    -0x1000(%rdx),%r8
> ffffffff8020cdf4:	4d 39 c4             	cmp    %r8,%r12
> ffffffff8020cdf7:	0f 83 0f 02 00 00    	jae    ffffffff8020d00c <dump_trace+0x2ec>
> ffffffff8020cdfd:	83 ff 03             	cmp    $0x3,%edi
> ffffffff8020ce00:	0f 84 e9 00 00 00    	je     ffffffff8020ceef <dump_trace+0x1cf>
> ffffffff8020ce06:	48 ff c7             	inc    %rdi

