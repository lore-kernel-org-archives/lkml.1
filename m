Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYFTTSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYFTTSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYFTTSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:18:39 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43927 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751197AbYFTTSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:18:37 -0400
Date: Fri, 20 Jun 2008 14:18:26 -0500
From: Cliff Wickman <cpw@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] X86: reboot-notify additions
Message-ID: <20080620191826.GA9936@sgi.com>
References: <E1K95kd-00081i-B6@eag09.americas.sgi.com> <20080619110214.GJ15228@elte.hu> <20080619145453.GA11929@sgi.com> <m1d4mdksau.fsf@frodo.ebiederm.org> <20080620151650.GA5606@sgi.com> <m1wskkt281.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wskkt281.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2008 at 11:01:34AM -0700, Eric W. Biederman wrote:
> Cliff Wickman <cpw@sgi.com> writes:

>>  void emergency_restart(void)
>>  {
>> +     struct raw_notifier_head rh;
>> +
>> +     rh.head = reboot_notifier_list.head;
>> +     raw_notifier_call_chain(&rh, SYS_EMERGENCY, NULL);
>>       machine_emergency_restart();
>>  }

> that's still not a good idea - a blocking notifier list is that: a list
> that has stuff which might block. emergency_restart() might get called
> by non-blocking codepaths as well and it expects the restart to occur.
>
>         Ingo

Oh. I get it now.  I was just looking at how the types of lists protect
against additions to the list.

Seems an atomic list would do what we want.  By definition the functions
on such a list should not block.
 
> >> 
> >> Cool.  Someone who wants this kind of functionality and has code in
> >> the kernel.  Perhaps we can have a reasonable discussion about this.
> >> The last time this came up people wanted a hook so they could support
> >> their out of tree blobs in an enterprise kernel.
> >> 
> >> emergency_restart only happens or only should happen with explicit admin
> >> request Sysreq-r.  Or when a watchdog detects the system is borked.
> >> By design it is not expected to call drivers.  The kexec on panic
> >> case is similar.
> >
> > I suppose one could trust that someone with superuser permission would
> > not stop one partition of a multi-partitioned system in a cavalier manner.
> > I'm inclined to think we should run the reboot_notifier_list even in those
> > situations.
> 
> NACK  emergency_restart is for when calling a normal reboot doesn't
> work i.e. calling the reboot_notifier_list is broken.
> 
> emergency_restart is by definition a hack.

Perhaps there should be a normal_restart() and an emergency_restart().
Currently, on x86, emergency_restart() is called in both sane and error
situations.

> Also now that I think about it now that we have the device tree
> notifications the last few users of the reboot_notifier_list should
> be updated and the reboot_notifier_list should just be removed.
> 
> > But definitely on some watchdog timeout event.  Some kind of mechanism
> > should be invoked to communicate the stoppage.
> 
> I'm not certain why this is important if you have a hardware partition
> that looks like real hardware.  In that case the firmware should
> easily be able to detect this because we reboot the partition.

I suppose the firmware could get involved.  It's true that the live
partitions have no problem until the dead partition is rebooted and
memory barriers are raised to the memory the live partitions are accessing.
I suppose the rebooting partition could communicate to the firmware in
the live partitions.  But to communicate to a driver in the OS, and then
back again to the firmware in the dead partition might be pretty messy.
 
> >> As far as this being a generic problem I half agree.  It seems to depend
> >> on your platform if you need something like this.
> >> 
> >> With that said.  I suggest we have a single platform specific function 
> >> that can be called.  Possibly something like pm_power_off.  It is
> >> insanely important that we be able to audit all of the code on these
> >> code paths, and that a random loadable driver not be able to get in
> >> and mess things up.
> >
> > The panic() function has the panic_notifier_list for those cases where
> > crash_kexec() does not find a crash kernel to exec.
> >
> > That leaves holes for watchdog-type events and crash_kexec().
> > Can you elborate on the problem with running a non-blocking scan of 
> > the reboot_notifier_list in those situations?
> >
> > What do you have in mind as a platform specific function, that would
> > be an improvement over the reboot_notifier_list?
> 
> In the general case it is WRONG to notify or run any function before
> crash_kexec.  The assumption is that the current kernel is BROKEN.  So the
> goal is to keep our exposure to kernel bugs to a minimum.  There is currently
> too _much_ code being run on the crash_kexec path.

We do have an atomic panic_notifier_list.  How about using that?
The functions on the list are supposed to be non-blocking.

(currently I only see 5 of them in use -- lguest_panic panic_event
wdog_panic_handler panic_happened softlock_panic)

> In the crash_kexec case we can call functions on the other side of the
> kexec notifier.  So there is very much a hook there.

Sorry, I'm not understanding that.  What is that hook?

> > My current (v2) proposed patch for using the reboot_notifier_list as
> > this mechanism looks like this:
> > (and I'm not sure if using atomic_notifier_call_chain() might be a better
> >  alternative to raw_notifier_call_chain())
> 
> I am willing to look at performing actions in the crash_kexec path
> on a case by case basis.  Which means essentially a hard coded function
> call that compiles out on the hardware where it is meaningless.
> 
> As for emergency_restart.  That is for those times when doing a proper
> reboot doesn't work and you just want to rest the hardware. 

Perhaps a split of emergency_restart() into normal_restart() and
emergency_restart() would reserve emergency_restart() for just those cases.
Then we could use the emergency procedures only in the emergency cases.

> So can we please start with what exactly you need to do on the xpc and
> why?

See xpc_system_reboot() [drivers/misc/sgi-xp/xpc_main.c]
It is called from the reboot_notifier_list when the system is being
rebooted.
The driver calls xpc_do_exit() go through its normal exit processing.  This
involves some significant waiting.

And xpc_system_die().
It is called from the die_chain (on ia64).  But on x86 there are these
couple of cases where no callback occurs from the reboot or panic lists.
The driver is to be called back when the kernel is restarted or halted due
to some sort of failure. It calls xpc_die_disengage() to notify other
partitions to disengage from all references to the dying partition's memory.
There is some waiting for the other partitions.

-Cliff

Below is my current thought for covering the crash_kexec and
emergency_restart cases:


Subject: [PATCH] panic-notify additions

This patch adds scans of the "panic_notifier_list" callback chain in
the places where the kernel is going down in an error situation, but in
which no notification was provided.

Adds 2 calls to atomic_notifier_call_chain() in:
   crash_kexec(), emergency_restart()
Differentiates as to the source of the call with arguments SYS_PANIC,
SYS_KEXEC and SYS_EMERGENCY.

The panic_notifier_list is used instead of the reboot_notifier_list
because it is atomic. That is, by definition, the functions on this type
of list run in an atomic context so they must not block.

Diffed against 2.6.26-rc6

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 include/linux/notifier.h |    3 +++
 kernel/kexec.c           |    2 ++
 kernel/panic.c           |    2 +-
 kernel/sys.c             |    2 ++
 4 files changed, 8 insertions(+), 1 deletion(-)

Index: linux/include/linux/notifier.h
===================================================================
--- linux.orig/include/linux/notifier.h
+++ linux/include/linux/notifier.h
@@ -202,6 +202,9 @@ static inline int notifier_to_errno(int 
 #define SYS_RESTART	SYS_DOWN
 #define SYS_HALT	0x0002	/* Notify of system halt */
 #define SYS_POWER_OFF	0x0003	/* Notify of system power off */
+#define SYS_PANIC	0x0004	/* Notify of a panic */
+#define SYS_KEXEC	0x0005	/* Notify of kexec of a kernel */
+#define SYS_EMERGENCY	0x0006	/* Notify of emergency restart */
 
 #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
 
Index: linux/kernel/kexec.c
===================================================================
--- linux.orig/kernel/kexec.c
+++ linux/kernel/kexec.c
@@ -1068,6 +1068,8 @@ void crash_kexec(struct pt_regs *regs)
 	if (!locked) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
+			atomic_notifier_call_chain(&panic_notifier_list,
+				SYS_KEXEC, "kexec");
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
Index: linux/kernel/sys.c
===================================================================
--- linux.orig/kernel/sys.c
+++ linux/kernel/sys.c
@@ -270,6 +270,8 @@ out_unlock:
  */
 void emergency_restart(void)
 {
+	atomic_notifier_call_chain(&panic_notifier_list, SYS_EMERGENCY,
+		"emergency restart");
 	machine_emergency_restart();
 }
 EXPORT_SYMBOL_GPL(emergency_restart);
Index: linux/kernel/panic.c
===================================================================
--- linux.orig/kernel/panic.c
+++ linux/kernel/panic.c
@@ -98,7 +98,7 @@ NORET_TYPE void panic(const char * fmt, 
 	smp_send_stop();
 #endif
 
-	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
+	atomic_notifier_call_chain(&panic_notifier_list, SYS_PANIC, buf);
 
 	if (!panic_blink)
 		panic_blink = no_blink;

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
