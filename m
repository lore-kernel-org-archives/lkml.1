Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbYFTPRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbYFTPRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755866AbYFTPRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:17:04 -0400
Received: from relay2.sgi.com ([192.48.171.30]:37385 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755802AbYFTPRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:17:02 -0400
Date: Fri, 20 Jun 2008 10:16:50 -0500
From: Cliff Wickman <cpw@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] X86: reboot-notify additions
Message-ID: <20080620151650.GA5606@sgi.com>
References: <E1K95kd-00081i-B6@eag09.americas.sgi.com> <20080619110214.GJ15228@elte.hu> <20080619145453.GA11929@sgi.com> <m1d4mdksau.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d4mdksau.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2008 at 02:50:49PM -0700, Eric W. Biederman wrote:
> Cliff Wickman <cpw@sgi.com> writes:
> 
> >> > This patch adds scans of the "reboot_notifier_list" callback chain in
> >> > a three other places where the kernel is being stopped and/or restarted.
> >> > 
> >> > Adds calls to blocking_notifier_call_chain() in:
> >> >    crash_kexec(), emergency_restart(), sys_kexec_load()
> >> > 
> >> > In the crash_kexec() and emergency_restart() cases it is indicated to the
> >> > called-back function that the system is not in a sane state, so that
> >> > it can avoid taking a lock or some such potentially blocking action.
> >> > 
> >> > These callbacks are important to a partition system. The stopped kernel
> > needs
> >> > to inform other partitions of their need to disconnect (stop sharing
> > memory).
> >> > 
> >> > Index: linux/kernel/kexec.c
> >> > ===================================================================
> >> > --- linux.orig/kernel/kexec.c
> >> > +++ linux/kernel/kexec.c
> >> > @@ -1001,6 +1001,9 @@ asmlinkage long sys_kexec_load(unsigned 
> >> >  		if (result)
> >> >  			goto out;
> >> >  	}
> >> > +
> >> > +	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, NULL);
> >> > +
> >> >  	/* Install the new kernel, and  Uninstall the old */
> >> >  	image = xchg(dest_image, image);
> >> >  

I withdraw the above chunk.  As Eric pointed out, sys_kexec_load() is
not where the new kernel is started.  That is done in kernel_kexec()
which already runs the reboot_notifier_list.

> >> i dont think this is a good idea. reboot_notifier_list is a blocking 
> >> notifier, i.e. it comes with a notifier->rwsem read-write mutex that is 
> >> taken when blocking_notifier_call_chain() is executed.
> >> 
> >> i.e. this patch puts a sleeping mutex operation (a down_read()) into a 
> >> highly critical code path of the kernel. This will decrease the 
> >> reliability of the kernel.
> >
> > Andi pointed this out, too.
> >
> > For these emergency cases (I'll change "SYS_INSANE" to "SYS_EMERGENCY")
> > I probably should be using raw_notifier_call_chain(), which requires
> > a slightly different form of list header but doesn't try to protect
> > against someone else adding to the notifier list.
> >> 
> >> what exactly are you trying to achieve?
> >> 
> >> 	Ingo
> >
> > The impetus for these additions is to call back a driver in every case
> > that the kernel is going down.  In a partitioned system we need such a
> > driver to inform all other partitions that they need to disconnect from
> > the rebooting/halting/panicing partition (kernel image).  If they are not
> > informed, they may bring themselves crashing down as well.
> > (xpc is such a cross_partition driver)
> 
> Cool.  Someone who wants this kind of functionality and has code in
> the kernel.  Perhaps we can have a reasonable discussion about this.
> The last time this came up people wanted a hook so they could support
> their out of tree blobs in an enterprise kernel.
> 
> emergency_restart only happens or only should happen with explicit admin
> request Sysreq-r.  Or when a watchdog detects the system is borked.
> By design it is not expected to call drivers.  The kexec on panic
> case is similar.

I suppose one could trust that someone with superuser permission would
not stop one partition of a multi-partitioned system in a cavalier manner.
I'm inclined to think we should run the reboot_notifier_list even in those
situations.

But definitely on some watchdog timeout event.  Some kind of mechanism
should be invoked to communicate the stoppage.
 
> sys_kexec_load is a ridiculous place to call any kind of reboot notifier
> because it is a prep function that doesn't require any kind of connection
> to rebooting.

agree
done
 
> As far as this being a generic problem I half agree.  It seems to depend
> on your platform if you need something like this.
> 
> With that said.  I suggest we have a single platform specific function 
> that can be called.  Possibly something like pm_power_off.  It is
> insanely important that we be able to audit all of the code on these
> code paths, and that a random loadable driver not be able to get in
> and mess things up.

The panic() function has the panic_notifier_list for those cases where
crash_kexec() does not find a crash kernel to exec.

That leaves holes for watchdog-type events and crash_kexec().
Can you elborate on the problem with running a non-blocking scan of 
the reboot_notifier_list in those situations?

What do you have in mind as a platform specific function, that would
be an improvement over the reboot_notifier_list?




My current (v2) proposed patch for using the reboot_notifier_list as
this mechanism looks like this:
(and I'm not sure if using atomic_notifier_call_chain() might be a better
 alternative to raw_notifier_call_chain())


Subject: [PATCHv2] reboot-notify additions

reboot-notify additions

This patch adds scans of the "reboot_notifier_list" callback chain in
the remaining places where the kernel is being stopped and/or restarted.

Adds 2 calls to raw_notifier_call_chain() in:
   crash_kexec(), emergency_restart()


Diffed against 2.6.26-rc6

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 include/linux/notifier.h |    5 +++++
 kernel/kexec.c           |    6 ++++++
 kernel/sys.c             |    7 +++++++
 3 files changed, 18 insertions(+)

Index: linux/include/linux/notifier.h
===================================================================
--- linux.orig/include/linux/notifier.h
+++ linux/include/linux/notifier.h
@@ -202,6 +202,11 @@ static inline int notifier_to_errno(int 
 #define SYS_RESTART	SYS_DOWN
 #define SYS_HALT	0x0002	/* Notify of system halt */
 #define SYS_POWER_OFF	0x0003	/* Notify of system power off */
+#define SYS_EMERGENCY	0x0004	/* Notify of system error/panic/oops */
+/*
+ * For the SYS_EMERGENCY case, no locks should be taken by the called-back
+ * function.
+ */
 
 #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
 
Index: linux/kernel/kexec.c
===================================================================
--- linux.orig/kernel/kexec.c
+++ linux/kernel/kexec.c
@@ -1063,11 +1063,17 @@ void crash_kexec(struct pt_regs *regs)
 	 * If the crash kernel was not located in a fixed area
 	 * of memory the xchg(&kexec_crash_image) would be
 	 * sufficient.  But since I reuse the memory...
+	 *
+	 * The reboot_notifier_list uses a header for a blocking-form scan.
+	 * Use a local header suitable for a non-blocking scan.
 	 */
 	locked = xchg(&kexec_lock, 1);
 	if (!locked) {
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
+        		struct raw_notifier_head rh;
+        		rh.head = reboot_notifier_list.head;
+        		raw_notifier_call_chain(&rh, SYS_EMERGENCY, NULL);
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
Index: linux/kernel/sys.c
===================================================================
--- linux.orig/kernel/sys.c
+++ linux/kernel/sys.c
@@ -267,9 +267,16 @@ out_unlock:
  *	reboot the system.  This is called when we know we are in
  *	trouble so this is our best effort to reboot.  This is
  *	safe to call in interrupt context.
+ *
+ *	The reboot_notifier_list uses a header for a blocking-form scan.
+ *	Use a local header suitable for a non-blocking scan.
  */
 void emergency_restart(void)
 {
+	struct raw_notifier_head rh;
+
+	rh.head = reboot_notifier_list.head;
+	raw_notifier_call_chain(&rh, SYS_EMERGENCY, NULL);
 	machine_emergency_restart();
 }
 EXPORT_SYMBOL_GPL(emergency_restart);

-- 
Cliff Wickman
Silicon Graphics, Inc.
cpw@sgi.com
(651) 683-3824
