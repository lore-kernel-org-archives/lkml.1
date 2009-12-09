Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbZLITch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbZLITch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757253AbZLITcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:32:36 -0500
Received: from claw.goop.org ([74.207.240.146]:41118 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028AbZLITcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:32:36 -0500
Message-ID: <4B1FFB59.2080404@goop.org>
Date: Wed, 09 Dec 2009 11:32:41 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091125 Fedora/3.0-3.12.rc1.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
References: <20091203210913.GA24351@elte.hu> <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain> <20091209073632.GD8187@elte.hu> <4B1FED0D.7060003@goop.org> <alpine.LFD.2.00.0912091039050.3560@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912091039050.3560@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/09 10:47, Linus Torvalds wrote:
>
> On Wed, 9 Dec 2009, Jeremy Fitzhardinge wrote:
>    
>> How does this look?
>>      
> I would actually prefer it if the calling convention was just made to
> match on both x86 and x86-64. Wouldn't it be nice if they both just had
>
>    
>> +/* kernel/ioport.c */
>> +asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
>>      
> as the prototype, and looked the same?
>
> I realize that right now the 32-bit PTREGSCALL() thing doesn't support
> that (very different macros for entry.S x86-32 and -64), but isn't that
> just another thing we should try to fix too?
>
> IOW, maybe something like this would be good, and would change the x86-32
> calling convention to match the x86-64 one?
>
> NOTE NOTE NOTE! Totally untested. Is the second argument even in %edx? I
> don't remember, I didn't check, I'm just throwing this out as a "hey,
> maybe something _like_ this can work" patch, and will be immediately
> removing it from my machine after sending this email.
>    

I came up with this:

From: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
Date: Wed, 9 Dec 2009 11:17:52 -0800
Subject: [PATCH] x86/iopl: make 32bit iopl also get level argument

This makes it match the 64-bit prototype, and simplifies the whole thing.

Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 70497f0..4e567d5 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -18,6 +18,7 @@
  /* Common in X86_32 and X86_64 */
  /* kernel/ioport.c */
  asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
+long sys_iopl(unsigned int, struct pt_regs *);

  /* kernel/process.c */
  int sys_fork(struct pt_regs *);
@@ -36,7 +37,6 @@ asmlinkage int sys_get_thread_area(struct user_desc __user *);
  /* X86_32 only */
  #ifdef CONFIG_X86_32
  /* kernel/ioport.c */
-asmlinkage long sys_iopl(struct pt_regs *);

  /* kernel/process_32.c */
  int sys_clone(struct pt_regs *);
@@ -71,9 +71,6 @@ int sys_vm86(struct pt_regs *);

  /* X86_64 only */

-/* kernel/ioport.c */
-asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
-
  /* kernel/process_64.c */
  asmlinkage long sys_clone(unsigned long, unsigned long,
  			  void __user *, void __user *,
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 50b9c22..737b81f 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -725,13 +725,15 @@ END(syscall_badsys)
  /*
   * System calls that need a pt_regs pointer.
   */
-#define PTREGSCALL(name) \
+#define PTREGSCALL_ARG(name,arg) \
  	ALIGN; \
  ptregs_##name: \
-	leal 4(%esp),%eax; \
+	leal 4(%esp),arg; \
  	jmp sys_##name;
-
-PTREGSCALL(iopl)
+#define PTREGSCALL(name) \
+	PTREGSCALL_ARG(name, %eax)
+	
+PTREGSCALL_ARG(iopl,%edx)
  PTREGSCALL(fork)
  PTREGSCALL(clone)
  PTREGSCALL(vfork)
diff --git a/arch/x86/kernel/ioport.c b/arch/x86/kernel/ioport.c
index b1cbac5..f435e42 100644
--- a/arch/x86/kernel/ioport.c
+++ b/arch/x86/kernel/ioport.c
@@ -103,7 +103,7 @@ asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on)
   * on system-call entry - see also fork() and the signal handling
   * code.
   */
-static int do_iopl(unsigned int level, struct pt_regs *regs)
+long sys_iopl(unsigned int level, struct pt_regs *regs)
  {
  	struct thread_struct *t =&current->thread;
  	unsigned int old = (regs->flags>>  12)&  3;
@@ -122,15 +122,3 @@ static int do_iopl(unsigned int level, struct pt_regs *regs)

  	return 0;
  }
-
-#ifdef CONFIG_X86_64
-long sys_iopl(unsigned int level, struct pt_regs *regs)
-{
-	return do_iopl(level, regs);
-}
-#else
-long sys_iopl(struct pt_regs *regs)
-{
-	return do_iopl(regs->bx, regs);
-}
-#endif


