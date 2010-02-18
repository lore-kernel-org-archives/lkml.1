Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab0BRVkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 16:40:18 -0500
Received: from mail.windriver.com ([147.11.1.11]:55475 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab0BRVkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 16:40:16 -0500
Message-ID: <4B7DB39F.1040707@windriver.com>
Date: Thu, 18 Feb 2010 15:39:43 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu
Subject: Re: [PATCH 26/28] kdb,panic,debug_core: Allow the debug core to receive
 a panic before smp_send_stop()
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com><1266014143-29444-27-git-send-email-jason.wessel@windriver.com><20100212150027.f875bbde.akpm@linux-foundation.org><4B75E7AB.4060102@windriver.com><20100212204141.cc42f298.akpm@linux-foundation.org> <m1zl37yywj.fsf@fess.ebiederm.org>
In-Reply-To: <m1zl37yywj.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2010 21:39:37.0058 (UTC) FILETIME=[DE34CC20:01CAB0E2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Andrew Morton <akpm@linux-foundation.org> writes:
> 
>> On Fri, 12 Feb 2010 17:43:39 -0600 Jason Wessel <jason.wessel@windriver.com> wrote:
>>
>>>>>  	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
>>>>>  #ifdef CONFIG_DEBUG_BUGVERBOSE
>>>>>  	dump_stack();
>>>>> @@ -91,8 +94,6 @@ NORET_TYPE void panic(const char * fmt, ...)
>>>>>  	 */
>>>>>  	smp_send_stop();
>>>>>  
>>>>> -	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>>>>> -
>>>>>  	bust_spinlocks(0);
>>>>>  
>>>>>  	if (!panic_blink)
>>>>>     
>>>> So the notifier call now happens before all the printks and the kexec
>>>> and kmsg_dump handling.  What effect does this have upon the code which
>>>> implements kexec and kmsg_dump?
>>>>
>>>>   
>>> I certainly don't want to break kexec or alter any behavior, does that
>>> mean kgdb / kdb should hook the kexec for notification?
>>>
>>> I think ideally it is a end user's preference as to if they want in via
>>> kexec or the kernel debugger.  Calling the smp_send_stop() prior to the
>>> notifier was a death sentence for the kernel debugger. 
>>>
>>> Perhaps I can move the notifier before smp_send_stop()?
>> Well.  My question can be simplified to "does this break existing code"?
> 
> Yes.  Removing the bust_spinlocks(1) and moving the panic notification up


The bust_spinlocks(1) was not removed but moved around, but the point
is moot.  Yes, it confirmed beyond the shadow of a doubt to break
existing code.

The revised patch does not touch anything in kernel/panic.c.  Instead
we make a best effort to get the kernel debugger first in line to the
notifier.  It turns out one of the other notifiers was the culprit in
the hanging the system during the panic tests.

If anyone further objects, I will simply drop the kdb panic
notification registration entirely.

Thanks,
Jason.

---

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] kdb,debug_core: Allow the debug core to receive a panic notification

It is highly desirable to trap into kdb on panic.  The debug core will
attempt to register as the first in line for the panic notifier.

CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 kernel/debug/debug_core.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -754,11 +754,28 @@ static struct sysrq_key_op sysrq_dbg_op 
 };
 #endif
 
+static int kgdb_panic_event(struct notifier_block *self,
+			    unsigned long val,
+			    void *data)
+{
+	if (dbg_kdb_mode)
+		kdb_printf("PANIC: %s\n", (char *)data);
+	kgdb_breakpoint();
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kgdb_panic_event_nb = {
+       .notifier_call	= kgdb_panic_event,
+       .priority	= INT_MAX,
+};
+
 static void kgdb_register_callbacks(void)
 {
 	if (!kgdb_io_module_registered) {
 		kgdb_io_module_registered = 1;
 		kgdb_arch_init();
+		atomic_notifier_chain_register(&panic_notifier_list,
+					       &kgdb_panic_event_nb);
 #ifdef CONFIG_MAGIC_SYSRQ
 		register_sysrq_key('g', &sysrq_dbg_op);
 #endif
@@ -778,6 +795,8 @@ static void kgdb_unregister_callbacks(vo
 	 */
 	if (kgdb_io_module_registered) {
 		kgdb_io_module_registered = 0;
+		atomic_notifier_chain_unregister(&panic_notifier_list,
+					       &kgdb_panic_event_nb);
 		kgdb_arch_exit();
 #ifdef CONFIG_MAGIC_SYSRQ
 		unregister_sysrq_key('g', &sysrq_dbg_op);


