Return-Path: <linux-kernel-owner+w=401wt.eu-S1755557AbZJAG4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbZJAG4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbZJAG4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:56:21 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:45197 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754500AbZJAG4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:56:21 -0400
Message-ID: <4AC4527C.10703@snapgear.com>
Date: Thu, 01 Oct 2009 16:55:56 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andreas Schwab <schwab@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: m86k/m68knommu tree build failure
References: <20090910151137.fb71c103.sfr@canb.auug.org.au>	<4AA890B5.8000207@snapgear.com> <m363brb4yk.fsf@hase.home> <4AC44E3E.9000301@snapgear.com>
In-Reply-To: <4AC44E3E.9000301@snapgear.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg Ungerer wrote:
> Hi Andreas,
> 
> Andreas Schwab wrote:
>> Greg Ungerer <gerg@snapgear.com> writes:
>>
>>> Hi Stephen,
>>>
>>> Stephen Rothwell wrote:
>>>> Today's linux-next build (m68k defconfig) failed like this:
>>>>
>>>> kernel/built-in.o: In function `ptrace_resume':
>>>> ptrace.c:(.text+0xc5d6): undefined reference to 
>>>> `user_disable_single_step'
>>>> ptrace.c:(.text+0xc5fe): undefined reference to 
>>>> `user_enable_single_step'
>>>> ptrace.c:(.text+0xc620): undefined reference to 
>>>> `user_disable_single_step'
>>>>
>>>> Caused by commit 5db612ef70d24be12f6dbf5d06b23bcd6bc2fc05 ("m68knommu:
>>>> define arch_has_single_step() and friends").  This commit added
>>>> definitions of these functions for m68knommu, but added declarations 
>>>> (and
>>>> arch_has_single_step()) in a common header file.
>>> Ah, yes, thanks. I'll fix that. I don't regularly build for m68k,
>>> so I missed that in my test builds.
>>
>> An m68k implementation is here
>> <http://permalink.gmane.org/gmane.linux.ports.m68k/721>.
> 
> I have 2 patches now for m68knommu (first is below, second following).
> If no complaints I'll add to the for-next branch of the m68knommu
> git tree.

Second patch:


m68knommu: remove ptrace PEEK and POKE

Remove the no longer needed ptrace PEEK and POKE ioctl support.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
  arch/m68knommu/kernel/ptrace.c |   68 
----------------------------------------
  1 files changed, 0 insertions(+), 68 deletions(-)

diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
index 4d38289..5a37549 100644
--- a/arch/m68knommu/kernel/ptrace.c
+++ b/arch/m68knommu/kernel/ptrace.c
@@ -116,12 +116,6 @@ long arch_ptrace(struct task_struct *child, long 
request, long addr, long data)
  	int ret;

  	switch (request) {
-		/* when I and D space are separate, these will need to be fixed. */
-		case PTRACE_PEEKTEXT: /* read word at location addr. */
-		case PTRACE_PEEKDATA:
-			ret = generic_ptrace_peekdata(child, addr, data);
-			break;
-
  		/* read the word at location addr in the USER area. */
  		case PTRACE_PEEKUSR: {
  			unsigned long tmp;
@@ -160,12 +154,6 @@ long arch_ptrace(struct task_struct *child, long 
request, long addr, long data)
  			break;
  		}

-		/* when I and D space are separate, this will have to be fixed. */
-		case PTRACE_POKETEXT: /* write the word at location addr. */
-		case PTRACE_POKEDATA:
-			ret = generic_ptrace_pokedata(child, addr, data);
-			break;
-
  		case PTRACE_POKEUSR: /* write the word at location addr in the USER 
area */
  			ret = -EIO;
  			if ((addr & 3) || addr < 0 ||
@@ -202,62 +190,6 @@ long arch_ptrace(struct task_struct *child, long 
request, long addr, long data)
  			}
  			break;

-		case PTRACE_SYSCALL: /* continue and stop at next (return from) 
syscall */
-		case PTRACE_CONT: { /* restart after signal. */
-			long tmp;
-
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			if (request == PTRACE_SYSCALL)
-				set_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			else
-				clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			child->exit_code = data;
-			/* make sure the single step bit is not set. */
-			tmp = get_reg(child, PT_SR) & ~(TRACE_BITS << 16);
-			put_reg(child, PT_SR, tmp);
-			wake_up_process(child);
-			ret = 0;
-			break;
-		}
-
-		/*
-		 * make the child exit.  Best I can do is send it a sigkill.
-		 * perhaps it should be put in the status that it wants to
-		 * exit.
-		 */
-		case PTRACE_KILL: {
-			long tmp;
-
-			ret = 0;
-			if (child->exit_state == EXIT_ZOMBIE) /* already dead */
-				break;
-			child->exit_code = SIGKILL;
-			/* make sure the single step bit is not set. */
-			tmp = get_reg(child, PT_SR) & ~(TRACE_BITS << 16);
-			put_reg(child, PT_SR, tmp);
-			wake_up_process(child);
-			break;
-		}
-
-		case PTRACE_SINGLESTEP: {  /* set the trap flag. */
-			long tmp;
-
-			ret = -EIO;
-			if (!valid_signal(data))
-				break;
-			clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-			tmp = get_reg(child, PT_SR) | (TRACE_BITS << 16);
-			put_reg(child, PT_SR, tmp);
-
-			child->exit_code = data;
-			/* give it a chance to run. */
-			wake_up_process(child);
-			ret = 0;
-			break;
-		}
-
  		case PTRACE_DETACH:	/* detach a process that was attached. */
  			ret = ptrace_detach(child, data);
  			break;



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
