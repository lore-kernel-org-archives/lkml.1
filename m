Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZJAGiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZJAGiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 02:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbZJAGiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 02:38:15 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:44559 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753368AbZJAGiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 02:38:14 -0400
Message-ID: <4AC44E3E.9000301@snapgear.com>
Date: Thu, 01 Oct 2009 16:37:50 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Andreas Schwab <schwab@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: m86k/m68knommu tree build failure
References: <20090910151137.fb71c103.sfr@canb.auug.org.au>	<4AA890B5.8000207@snapgear.com> <m363brb4yk.fsf@hase.home>
In-Reply-To: <m363brb4yk.fsf@hase.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

Andreas Schwab wrote:
> Greg Ungerer <gerg@snapgear.com> writes:
> 
>> Hi Stephen,
>>
>> Stephen Rothwell wrote:
>>> Today's linux-next build (m68k defconfig) failed like this:
>>>
>>> kernel/built-in.o: In function `ptrace_resume':
>>> ptrace.c:(.text+0xc5d6): undefined reference to `user_disable_single_step'
>>> ptrace.c:(.text+0xc5fe): undefined reference to `user_enable_single_step'
>>> ptrace.c:(.text+0xc620): undefined reference to `user_disable_single_step'
>>>
>>> Caused by commit 5db612ef70d24be12f6dbf5d06b23bcd6bc2fc05 ("m68knommu:
>>> define arch_has_single_step() and friends").  This commit added
>>> definitions of these functions for m68knommu, but added declarations (and
>>> arch_has_single_step()) in a common header file.
>> Ah, yes, thanks. I'll fix that. I don't regularly build for m68k,
>> so I missed that in my test builds.
> 
> An m68k implementation is here
> <http://permalink.gmane.org/gmane.linux.ports.m68k/721>.

I have 2 patches now for m68knommu (first is below, second following).
If no complaints I'll add to the for-next branch of the m68knommu
git tree.

Regards
Greg



m68knommu: define arch_has_single_step() and friends

Towards adding CONFIG_UTRACE support for non-mmu m68k add
arch_has_single_step, and its support functions
user_enable_single_step() and user_disable_single_step().

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---
  arch/m68k/include/asm/ptrace.h |   12 ++++++++++++
  arch/m68knommu/kernel/ptrace.c |   18 +++++++++++++++---
  2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/ptrace.h b/arch/m68k/include/asm/ptrace.h
index 8c9194b..beb2091 100644
--- a/arch/m68k/include/asm/ptrace.h
+++ b/arch/m68k/include/asm/ptrace.h
@@ -82,6 +82,18 @@ struct switch_stack {
  #define instruction_pointer(regs) ((regs)->pc)
  #define profile_pc(regs) instruction_pointer(regs)
  extern void show_regs(struct pt_regs *);
+
+/*
+ * These are defined as per linux/ptrace.h.
+ */
+struct task_struct;
+
+#ifndef CONFIG_MMU
+#define	arch_has_single_step()	(1)
+extern void user_enable_single_step(struct task_struct *);
+extern void user_disable_single_step(struct task_struct *);
+#endif
+
  #endif /* __KERNEL__ */
  #endif /* __ASSEMBLY__ */
  #endif /* _M68K_PTRACE_H */
diff --git a/arch/m68knommu/kernel/ptrace.c b/arch/m68knommu/kernel/ptrace.c
index ef70ca0..4d38289 100644
--- a/arch/m68knommu/kernel/ptrace.c
+++ b/arch/m68knommu/kernel/ptrace.c
@@ -86,6 +86,20 @@ static inline int put_reg(struct task_struct *task, 
int regno,
  	return 0;
  }

+void user_enable_single_step(struct task_struct *task)
+{
+	unsigned long srflags;
+	srflags = get_reg(task, PT_SR) | (TRACE_BITS << 16);
+	put_reg(task, PT_SR, srflags);
+}
+
+void user_disable_single_step(struct task_struct *task)
+{
+	unsigned long srflags;
+	srflags = get_reg(task, PT_SR) & ~(TRACE_BITS << 16);
+	put_reg(task, PT_SR, srflags);
+}
+
  /*
   * Called by kernel/ptrace.c when detaching..
   *
@@ -93,10 +107,8 @@ static inline int put_reg(struct task_struct *task, 
int regno,
   */
  void ptrace_disable(struct task_struct *child)
  {
-	unsigned long tmp;
  	/* make sure the single step bit is not set. */
-	tmp = get_reg(child, PT_SR) & ~(TRACE_BITS << 16);
-	put_reg(child, PT_SR, tmp);
+	user_disable_single_step(child);
  }

  long arch_ptrace(struct task_struct *child, long request, long addr, 
long data)



------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
