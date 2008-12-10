Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYLJDJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYLJDJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 22:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYLJDJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 22:09:13 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:56347 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbYLJDJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 22:09:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wshmRLgQKwXylNffalEfsg/cnrAXUYF/1X0vTF1jOKaM9iawwG1vBCyaLNFi9dONMG
         pV/adFT0gnvd4RUiniDZU7YfJ+DRxo1RSnL7f22S2GpElvNo2qc1UzcGdYQ/zQoHu1/n
         Sb26FcAE05oI3V+zM0RCi9ZcVM6G+7K924cUk=
Message-ID: <804dabb00812091909i739eedc3scffa1f1f406a474d@mail.gmail.com>
Date: Wed, 10 Dec 2008 11:09:10 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <srostedt@redhat.com>
Subject: Re: [PATCH] tracing: allow tracing of suspend/resume & hibernation code again
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <804dabb00811240747r30d60e1x6d8da177478571af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00811220047q6e0f24eap23e9a7c4c7bd71b6@mail.gmail.com>
	 <200811221359.24808.rjw@sisk.pl> <20081123094124.GO30453@elte.hu>
	 <804dabb00811230737g4c958ca1p74b661faabfece0b@mail.gmail.com>
	 <804dabb00811240747r30d60e1x6d8da177478571af@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if it helps, but the patch you sent earlier in do resume
successfully, after I remove the CONFIG_DEBUG_PAGEALLOC option (and
some of the FTRACE option as well):

--- .config2Dec2008_with_ftrace 2008-12-02 05:12:04.000000000 +0800
+++ .config     2008-12-07 02:10:31.000000000 +0800
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc6
-# Mon Nov 24 12:57:54 2008
+# Linux kernel version: 2.6.28-rc7
+# Sun Dec  7 02:10:31 2008
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
@@ -3671,10 +3671,8 @@ CONFIG_SCHED_TRACER=y
 CONFIG_CONTEXT_SWITCH_TRACER=y
 # CONFIG_BOOT_TRACER is not set
 CONFIG_STACK_TRACER=y
-CONFIG_DYNAMIC_FTRACE=y
-CONFIG_FTRACE_MCOUNT_RECORD=y
-CONFIG_FTRACE_SELFTEST=y
-CONFIG_FTRACE_STARTUP_TEST=y
+# CONFIG_DYNAMIC_FTRACE is not set
+# CONFIG_FTRACE_STARTUP_TEST is not set
 # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
 # CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
 # CONFIG_BUILD_DOCSRC is not set
@@ -3693,7 +3691,7 @@ CONFIG_EARLY_PRINTK=y
 # CONFIG_EARLY_PRINTK_DBGP is not set
 # CONFIG_DEBUG_STACKOVERFLOW is not set
 # CONFIG_DEBUG_STACK_USAGE is not set
-CONFIG_DEBUG_PAGEALLOC=y
+# CONFIG_DEBUG_PAGEALLOC is not set
 # CONFIG_DEBUG_PER_CPU_MAPS is not set
 CONFIG_X86_PTDUMP=y
 CONFIG_DEBUG_RODATA=y

Applying the above config changes without the CONFIG_DEBUG_PAGEALLOC
removal will not resume successfully.

So after applying the above config changes, effectively the FTRACE
option left in compilation are:

CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_FUNCTION_TRACER=y

Now my questions are:

a.   With these option, is the function tracer still called?  (which
as Steven explained before will call smp_processor_id(), which crash
the system during resume)   But now since we can resume successfully,
does it mean the function tracer is no longer called?

b.   (now I am asking more on the Ftrace internal).      With the
option above, I still can get ftrace output in /debug/tracing/trace:

            Xorg-3399  [000]   144.926256: fget_light <-sys_read
            Xorg-3399  [000]   144.926256: vfs_read <-sys_read
            Xorg-3399  [000]   144.926256: rw_verify_area <-vfs_read
            Xorg-3399  [000]   144.926257: security_file_permission
<-rw_verify_area
            Xorg-3399  [000]   144.926257: cap_file_permission
<-security_file_permission
            Xorg-3399  [000]   144.926257: do_sync_read <-vfs_read

I took a peek at vfs_read() API in kernel memory, and found the
bytecode same as the compiled vmlinux output.   So question is, how
does FTRACE managed to intercept vfs_read(), or any function shown
above, ahead before it is called?   Do u do function analysis
dynamically to see what are the potential functions that is to be
called, and somehow intercept ahead before it is called, dynamically?
 Or does it maintained its own list of functions to be traced?
(since now set_ftrace_filter is now not writeable, which means that we
cannot specify the functions to trace).

Thank you for the effort in explanation :-).

On Mon, Nov 24, 2008 at 11:47 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> I can confirm it is not working, as I revert back again to my previous
> copy, recompile and resume successfully, but the patch currently
> proposed failed to resume for me.
>
> What should I do next?
>
> On Sun, Nov 23, 2008 at 11:37 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
>> Thanks Ingo,
>>
>> I applied the patch (manually) agains Linus's git:
>>
>> git describe
>> v2.6.28-rc6-7-ged31348
>>
>> Previously, before the patch, I had no problem resuming - for
>> v2.6.28-rc6.   Now after s2ram, it cannot resume properly - nothing is
>> displayed.   And I had not applied any changes to ftrace's
>> /debug/tracing files yet.
>>
>> Let me test it out again.   Thanks.   (I am on FC7).
>>
>> On Sun, Nov 23, 2008 at 5:41 PM, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>
>>>> > Q2: how to ftrace s2ram and resume?  I attempted to do it, but the
>>>> > trace output is always filled with "resume" related functions when
>>>> > it started up, which is only logical.
>>>>
>>>> The tracing is disabled during suspend/resume, so you can't.
>>>
>>> i think we could lift this restriction now that dftrace is gone for
>>> good - which was causing most of the trouble.
>>>
>>>  41108eb10142e0552f2de1e4c0675b108c5f018f
>>>  f42ac38c59e0a03d6da0c24a63fb211393f484b0
>>>
>>> Completely untested patch below. Peter, does it work for you?
>>>
>>>        Ingo
>>>
>>> ------------------->
>>> From 3134c953216111a35d17f77b784e5d1fa2ba36d5 Mon Sep 17 00:00:00 2001
>>> From: Ingo Molnar <mingo@elte.hu>
>>> Date: Sun, 23 Nov 2008 10:37:12 +0100
>>> Subject: [PATCH] tracing: allow tracing of suspend/resume & hibernation code again:
>>>
>>> Now that the ftrace kernel thread is gone, we can allow tracing
>>> during suspend/resume again.
>>>
>>> So revert these two commits:
>>>
>>>  f42ac38c5 "ftrace: disable tracing for suspend to ram"
>>>  41108eb10 "ftrace: disable tracing for hibernation"
>>>
>>> This should be tested very carefully, as it could interact with
>>> altneratives instruction patching, etc.
>>>
>>> Not-Yet-Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>> ---
>>>  kernel/power/disk.c |   13 +++----------
>>>  kernel/power/main.c |    5 +----
>>>  2 files changed, 4 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/kernel/power/disk.c b/kernel/power/disk.c
>>> index c9d7408..f77d381 100644
>>> --- a/kernel/power/disk.c
>>> +++ b/kernel/power/disk.c
>>> @@ -22,7 +22,6 @@
>>>  #include <linux/console.h>
>>>  #include <linux/cpu.h>
>>>  #include <linux/freezer.h>
>>> -#include <linux/ftrace.h>
>>>
>>>  #include "power.h"
>>>
>>> @@ -257,7 +256,7 @@ static int create_image(int platform_mode)
>>>
>>>  int hibernation_snapshot(int platform_mode)
>>>  {
>>> -       int error, ftrace_save;
>>> +       int error;
>>>
>>>        /* Free memory before shutting down devices. */
>>>        error = swsusp_shrink_memory();
>>> @@ -269,7 +268,6 @@ int hibernation_snapshot(int platform_mode)
>>>                goto Close;
>>>
>>>        suspend_console();
>>> -       ftrace_save = __ftrace_enabled_save();
>>>        error = device_suspend(PMSG_FREEZE);
>>>        if (error)
>>>                goto Recover_platform;
>>> @@ -299,7 +297,6 @@ int hibernation_snapshot(int platform_mode)
>>>  Resume_devices:
>>>        device_resume(in_suspend ?
>>>                (error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
>>> -       __ftrace_enabled_restore(ftrace_save);
>>>        resume_console();
>>>  Close:
>>>        platform_end(platform_mode);
>>> @@ -370,11 +367,10 @@ static int resume_target_kernel(void)
>>>
>>>  int hibernation_restore(int platform_mode)
>>>  {
>>> -       int error, ftrace_save;
>>> +       int error;
>>>
>>>        pm_prepare_console();
>>>        suspend_console();
>>> -       ftrace_save = __ftrace_enabled_save();
>>>        error = device_suspend(PMSG_QUIESCE);
>>>        if (error)
>>>                goto Finish;
>>> @@ -389,7 +385,6 @@ int hibernation_restore(int platform_mode)
>>>        platform_restore_cleanup(platform_mode);
>>>        device_resume(PMSG_RECOVER);
>>>  Finish:
>>> -       __ftrace_enabled_restore(ftrace_save);
>>>        resume_console();
>>>        pm_restore_console();
>>>        return error;
>>> @@ -402,7 +397,7 @@ int hibernation_restore(int platform_mode)
>>>
>>>  int hibernation_platform_enter(void)
>>>  {
>>> -       int error, ftrace_save;
>>> +       int error;
>>>
>>>        if (!hibernation_ops)
>>>                return -ENOSYS;
>>> @@ -417,7 +412,6 @@ int hibernation_platform_enter(void)
>>>                goto Close;
>>>
>>>        suspend_console();
>>> -       ftrace_save = __ftrace_enabled_save();
>>>        error = device_suspend(PMSG_HIBERNATE);
>>>        if (error) {
>>>                if (hibernation_ops->recover)
>>> @@ -452,7 +446,6 @@ int hibernation_platform_enter(void)
>>>        hibernation_ops->finish();
>>>  Resume_devices:
>>>        device_resume(PMSG_RESTORE);
>>> -       __ftrace_enabled_restore(ftrace_save);
>>>        resume_console();
>>>  Close:
>>>        hibernation_ops->end();
>>> diff --git a/kernel/power/main.c b/kernel/power/main.c
>>> index eaa122b..142e005 100644
>>> --- a/kernel/power/main.c
>>> +++ b/kernel/power/main.c
>>> @@ -22,7 +22,6 @@
>>>  #include <linux/freezer.h>
>>>  #include <linux/vmstat.h>
>>>  #include <linux/syscalls.h>
>>> -#include <linux/ftrace.h>
>>>
>>>  #include "power.h"
>>>
>>> @@ -321,7 +320,7 @@ static int suspend_enter(suspend_state_t state)
>>>  */
>>>  int suspend_devices_and_enter(suspend_state_t state)
>>>  {
>>> -       int error, ftrace_save;
>>> +       int error;
>>>
>>>        if (!suspend_ops)
>>>                return -ENOSYS;
>>> @@ -332,7 +331,6 @@ int suspend_devices_and_enter(suspend_state_t state)
>>>                        goto Close;
>>>        }
>>>        suspend_console();
>>> -       ftrace_save = __ftrace_enabled_save();
>>>        suspend_test_start();
>>>        error = device_suspend(PMSG_SUSPEND);
>>>        if (error) {
>>> @@ -364,7 +362,6 @@ int suspend_devices_and_enter(suspend_state_t state)
>>>        suspend_test_start();
>>>        device_resume(PMSG_RESUME);
>>>        suspend_test_finish("resume devices");
>>> -       __ftrace_enabled_restore(ftrace_save);
>>>        resume_console();
>>>  Close:
>>>        if (suspend_ops->end)
>>>
>>
>
>
> --
> Regards,
> Peter Teoh
>
> Ernest Hemingway - "Never mistake motion for action."
>



-- 
Regards,
Peter Teoh

Ernest Hemingway - "Never mistake motion for action."
