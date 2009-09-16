Return-Path: <linux-kernel-owner+w=401wt.eu-S1758600AbZIPJkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600AbZIPJkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 05:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZIPJkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 05:40:07 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:62693 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZIPJkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 05:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lNOSUHOVtZr36DfeU6X3MhUk8O8Xn9k0UXPMPX0vBthNOOmVcpFvR8M4JOkY8I9rjg
         SNiJme7YIopA8IWzXwofD9IZ6Kdxe/3tPiNrme7+mLf7XzBjk3DJ8g8IG3j52LF6T/dv
         Ix6NPbn4v9f4QdmTkERD5usAHetTPjdUAboA8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0909011347470.6044@xanadu.home>
References: <6d53329e0908250342g2cfb73f6v90f73c283c0d391c@mail.gmail.com>
	 <alpine.LFD.2.00.0908251333410.6044@xanadu.home>
	 <6d53329e0908302227l63420351m1005d0c76346e2ec@mail.gmail.com>
	 <6d53329e0908310311v55ef3909na0cbec756e63ccab@mail.gmail.com>
	 <6d53329e0908312355y7bd2038ds6ba8efe671d98bc9@mail.gmail.com>
	 <tnxocpu7osx.fsf@pc1117.cambridge.arm.com>
	 <20090901142549.GA21501@flint.arm.linux.org.uk>
	 <1251816239.10349.66.camel@pc1117.cambridge.arm.com>
	 <alpine.LFD.2.00.0909011347470.6044@xanadu.home>
Date: Wed, 16 Sep 2009 15:10:08 +0530
Message-ID: <6d53329e0909160240w7d1ad1ddke9b57b43dc3ba22@mail.gmail.com>
Subject: Re: ARM + jprobes/kretprobes SEGV/hangs/OOPS in 2.6.29 kernel
From: venki kaps <venkiece2005@gmail.com>
To: Nicolas Pitre <nico@cam.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       "sagar.abhishek@gmail.com" <sagar.abhishek@gmail.com>,
       "jkenisto@us.ibm.com" <jkenisto@us.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "prasanna@in.ibm.com" <prasanna@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have done some more analysis with respect to ARM kretprobes
and describing as below,

Before disabling unwinding support,
i have tested mainlined sample kretprobes_example.c with some changes.
the changes are,

Index: b/samples/kprobes/kretprobe_example.c
===================================================================
--- a/samples/kprobes/kretprobe_example.c
+++ b/samples/kprobes/kretprobe_example.c
@@ -59,6 +59,9 @@ static int ret_handler(struct kretprobe_
        s64 delta;
        ktime_t now;

+       printk("%s %d, Stack_dump :\n", __FILE__, __LINE__);
+       dump_stack();
+
        now = ktime_get();
        delta = ktime_to_ns(ktime_sub(now, data->entry_stamp));
        printk(KERN_INFO "%s returned %d and took %lld ns to execute\n",

$ insmod kretprobe_example.ko
$ ls
    <---- system hang

As i mentioned jprobes and kretprobes are having some issues with backtrace
with enabling unwinding support and as we know well about ARM, unwinding tables
are not stabilized which was pending issue in present kernels.

After disabling unwinding support,
              Kernel hacking  --->
	                 -*- frame pointer support
	            [] Enable stack unwinding support

Based on the above settings, I have verified the above test with dump_stack and
noticed test result as PASS.

I wanted to rely on FRAME_POINTER So have just added
'''select FRAME_POINTER''' to kprobe related configs as below as,

Index: b/samples/Kconfig
===================================================================
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -31,6 +31,7 @@ config SAMPLE_KOBJECT
 config SAMPLE_KPROBES
 	tristate "Build kprobes examples -- loadable modules only"
 	depends on KPROBES && m
+	select FRAME_POINTER
 	help
 	  This build several kprobes example modules.

@@ -38,6 +39,7 @@ config SAMPLE_KRETPROBES
 	tristate "Build kretprobes example -- loadable modules only"
 	default m
 	depends on SAMPLE_KPROBES && KRETPROBES
+	select FRAME_POINTER

 config SAMPLE_PSRWLOCK
 	tristate "Build psrwlock example -- loadable modules only"
Index: b/arch/Kconfig
===================================================================
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -36,6 +36,7 @@ config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES
 	depends on HAVE_KPROBES
+	select FRAME_POINTER
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
@@ -68,6 +69,7 @@ config HAVE_SYSCALL_WRAPPERS
 config KRETPROBES
 	def_bool y
 	depends on KPROBES && HAVE_KRETPROBES
+	select FRAME_POINTER

 config HAVE_IOREMAP_PROT
 	bool

I have some queries,
- shall i rely on FRAME_POINTER in kprobe related configs?
- shall i proceed with above changes?

Best Regards,
Venkappa



On Tue, Sep 1, 2009 at 11:26 PM, Nicolas Pitre <nico@cam.org> wrote:
> On Tue, 1 Sep 2009, Catalin Marinas wrote:
>
>> On Tue, 2009-09-01 at 15:25 +0100, Russell King wrote:
>> > On Tue, Sep 01, 2009 at 02:54:54PM +0100, Catalin Marinas wrote:
>> > > venki kaps <venkiece2005@gmail.com> wrote:
>> > > > I have found the exact problem with respect to ARM jprobes.
>> > > >
>> > > > The problem with configure i.e, CONFIG_ARM_UNWIND = y; is enabled.
>> > >
>> > > I haven't followed the kprobes implementation for ARM but does it make
>> > > any assumptions about the existence of a frame pointer on the stack?
>> > > Enabling stack unwinding automatically disables the framepointer.
>> >
>> > If it uses CALLER_ADDRESSx() then it won't work with unwinding enabled.
>> > See 5613/1 (which is pending in the devel branch.)
>>
>> In addition to that, when CONFIG_FRAME_POINTER is disabled, the lr
>> register isn't always saved on the stack by the called function. I'm not
>> sure whether kretprobe_trampoline is aware of this.
>
> The way a kretprobe works is to put a trap at the very first instruction
> of the targetted function, preserve the value of LR when the trap is
> hit, and substitute it with the address of kretprobe_trampoline.  Then
> the original first instruction is emulated to pass over the trap point
> and normal execution is resumed.  So whether or not LR is then saved on
> the stack doesn't matter to kretprobe_trampoline as it will restore the
> LR value saved during the initial trap.
>
> Of course if you end up generating a backtrace within a kretprobed
> function then the result might look funny.
>
>
> Nicolas
>
