Return-Path: <linux-kernel-owner+w=401wt.eu-S935091AbYEUQ2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935091AbYEUQ2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 12:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760606AbYEUQ14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 12:27:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:57265 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYEUQ14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 12:27:56 -0400
Message-ID: <48344D5B.1020308@windriver.com>
Date: Wed, 21 May 2008 11:27:07 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: kgdb test suite failure
References: <a4423d670805090714iaae7d4fj2883889ede15a4be@mail.gmail.com>	 <4832EBCF.2000407@windriver.com> <a4423d670805201130l649440acl3ef31f60503b279d@mail.gmail.com>
In-Reply-To: <a4423d670805201130l649440acl3ef31f60503b279d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2008 16:27:07.0801 (UTC) FILETIME=[833AB890:01C8BB5F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> 2008/5/20 Jason Wessel <jason.wessel@windriver.com>:
>> Alexander Beregalov wrote:
>>> Hi
>>> I tried to run the latest git kernel and got the following error.
>>>
>>> See an attachment for full dmesg.
>>>
>>> kgdbts: ERROR PUT: end of test buffer on 'do_fork_test' line 5
>>> expected OK got $E02#a7
>>> ------------[ cut here ]------------
>>> WARNING: at drivers/misc/kgdbts.c:721 run_simple_test+0x1de/0x20e()
>>> Modules linked in:
>>> Pid: 6, comm: khelper Not tainted 2.6.26-rc1-00279-g28a4acb #12
>>> [<c011a00a>] warn_on_slowpath+0x41/0x6c
>>> [<c011aa77>] ? vprintk+0x3e7/0x407
>>> [<c0254cf4>] ? number+0x10d/0x1cf
>>> [<c012d3da>] ? sched_clock_cpu+0x70/0x88
>>> [<c011aaac>] ? printk+0x15/0x17
>>>
>> Is this a problem you can reproduce every time?  Basically what line 5
> Yes, it happened every time when kernel booted, even before init.
> 
>> of the test does is to write a value into the register struct to rewind
>> the PC after hitting a breakpoint such that the instruction will be
>> executed again.   This is stored in memory which will be used for a
>> context switch back to the process.   The test also replaces the
>> original instruction in memory.  In this case the memory write failed.
>> This will certainly be fatal to the operation of the kernel and
>> stability would be called into question if the kernel doesn't just crash
>> and oops in strange ways immediately.
>>
>> I looked in your dmesg log and noticed:
>> [   21.027632] Testing CPA: undo c035d000-c044e000
>> [   21.083029] Testing CPA: write protecting again
>> [   21.297278] kgdbts: ERROR PUT: end of test buffer on 'do_fork_test'
>> line 5 expected OK got $E02#a7
>>
>>
>> I looked through the kernel source in the tip of the tree for the
>> "Testing CPA: write protecting again".  It seems this code is only used
>> when CONFIG_DEBUG_RODATA is set.  Perhaps this option is mutually
>> exclusive of the use of kgdb?  Today kgdb assumes it can write anywhere
>> without any kind of special concession for page protection bits.


I duplicated the problem by trying the kernel out with the
CONFIG_DEBUG_RODATA, which appears to only be implemented on the x86
architecture.  I am not exactly certain what the right level of fix
should be in this case, or if it should be fixed at all.  It seems
that the probe_kernel_write should have a force option to force
writing to a read-only memory page (meaning it will be
unprotected/re-protected), or there should be another function to deal
with writes that are deemed to be critical which calls the
probe_kernel_write() from with in kgdb.

It is an interesting problem, but the first inclination is not to fix
it at all because debugging read-only text sections is generally a job
for hardware breakpoints.  The kgdb test suite fell into the trap of
trying to debug a function call that was in a read-only page using
software breakpoints with trap instructions.

An RFC type patch follows which addresses the problem, but in my
opinion not in a terribly clean way...  Perhaps other folks will
comment on a different or better way to approach the problem or chime
in on if it should be fixed at all.  Certainly the test suite could be
changed to use HW breakpoints for the case where the text segments are
going to be read only as an example.

Another approach I considered was to add a global option to kgdb which
causes it to force write to read only pages.  This could be used by
the kgdb test suite as well as by a "human" via a debugger to change
the setting as needed.  How often you might want to set a software
breakpoint in a read-only page remains to be seen, but it does seem
like something that is marginally useful.

Jason.


===RFC only to illustrate a work around===

---
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 60bcb5b..e4d0039 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -737,7 +737,7 @@ static int change_page_attr_set_clr(unsigned long addr, int numpages,
 	/*
 	 * Check whether we really changed something:
 	 */
-	if (!cpa.flushtlb)
+	if (!cpa.flushtlb || in_atomic())
 		goto out;
 
 	/*
diff --git a/mm/maccess.c b/mm/maccess.c
index ac40796..7609fb9 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -4,6 +4,7 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/mm.h>
+#include <asm/cacheflush.h>
 
 /**
  * probe_kernel_read(): safely attempt to read from a location
@@ -42,11 +43,24 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
 long probe_kernel_write(void *dst, void *src, size_t size)
 {
 	long ret;
+#ifdef CONFIG_X86
+	unsigned int level;
+	pte_t *pte = lookup_address((unsigned long)dst, &level);
+	int unprotect = !pte_write(*pte);
+#endif
 	mm_segment_t old_fs = get_fs();
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
+#ifdef CONFIG_X86
+	if (unprotect)
+		set_memory_rw(((unsigned long)dst) & PAGE_MASK, 1);
+#endif
 	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
+#ifdef CONFIG_X86
+	if (unprotect)
+		set_memory_ro(((unsigned long)dst) & PAGE_MASK, 1);
+#endif
 	pagefault_enable();
 	set_fs(old_fs);
 
