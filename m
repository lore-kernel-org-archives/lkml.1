Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbYFSOzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbYFSOzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbYFSOzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:55:05 -0400
Received: from relay1.sgi.com ([192.48.171.29]:38799 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750907AbYFSOzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:55:03 -0400
Date: Thu, 19 Jun 2008 09:54:53 -0500
From: Cliff Wickman <cpw@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, andi@firstfloor.org
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] X86: reboot-notify additions
Message-ID: <20080619145453.GA11929@sgi.com>
References: <E1K95kd-00081i-B6@eag09.americas.sgi.com> <20080619110214.GJ15228@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080619110214.GJ15228@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Jun 19, 2008 at 01:02:14PM +0200, Ingo Molnar wrote:
> 
> * Cliff Wickman <cpw@sgi.com> wrote:
> 
> > From: Cliff Wickman <cpw@sgi.com>
> > 
> > X86 reboot-notify additions.

As Andi Kleen pointed out, this is not X86-specific.  (it started out
to be, but what I hoped to achieve for X86 turns out to be generic).

> > This patch adds scans of the "reboot_notifier_list" callback chain in
> > a three other places where the kernel is being stopped and/or restarted.
> > 
> > Adds calls to blocking_notifier_call_chain() in:
> >    crash_kexec(), emergency_restart(), sys_kexec_load()
> > 
> > In the crash_kexec() and emergency_restart() cases it is indicated to the
> > called-back function that the system is not in a sane state, so that
> > it can avoid taking a lock or some such potentially blocking action.
> > 
> > These callbacks are important to a partition system. The stopped kernel needs
> > to inform other partitions of their need to disconnect (stop sharing memory).
> > 
> > Diffed against 2.6.26-rc6
> > 
> > Signed-off-by: Cliff Wickman <cpw@sgi.com>
> > ---
> >  include/linux/notifier.h |    4 ++++
> >  kernel/kexec.c           |    5 +++++
> >  kernel/sys.c             |    1 +
> >  3 files changed, 10 insertions(+)
> > 
> > Index: linux/include/linux/notifier.h
> > ===================================================================
> > --- linux.orig/include/linux/notifier.h
> > +++ linux/include/linux/notifier.h
> > @@ -202,6 +202,10 @@ static inline int notifier_to_errno(int 
> >  #define SYS_RESTART	SYS_DOWN
> >  #define SYS_HALT	0x0002	/* Notify of system halt */
> >  #define SYS_POWER_OFF	0x0003	/* Notify of system power off */
> > +#define SYS_INSANE	0x0004	/* Notify of system error/panic/oops */
> > +/* For the SYS_INSANE case, no locks should be taken by the called-back
> > + * function.  The kernel is ready for an immediate reboot.
> > + */
> >  
> >  #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
> >  
> > Index: linux/kernel/kexec.c
> > ===================================================================
> > --- linux.orig/kernel/kexec.c
> > +++ linux/kernel/kexec.c
> > @@ -1001,6 +1001,9 @@ asmlinkage long sys_kexec_load(unsigned 
> >  		if (result)
> >  			goto out;
> >  	}
> > +
> > +	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, NULL);
> > +
> >  	/* Install the new kernel, and  Uninstall the old */
> >  	image = xchg(dest_image, image);
> >  
> > @@ -1068,6 +1071,8 @@ void crash_kexec(struct pt_regs *regs)
> >  	if (!locked) {
> >  		if (kexec_crash_image) {
> >  			struct pt_regs fixed_regs;
> > +			blocking_notifier_call_chain(&reboot_notifier_list,
> > +				SYS_INSANE, NULL);
> >  			crash_setup_regs(&fixed_regs, regs);
> >  			crash_save_vmcoreinfo();
> >  			machine_crash_shutdown(&fixed_regs);
> > Index: linux/kernel/sys.c
> > ===================================================================
> > --- linux.orig/kernel/sys.c
> > +++ linux/kernel/sys.c
> > @@ -270,6 +270,7 @@ out_unlock:
> >   */
> >  void emergency_restart(void)
> >  {
> > +	blocking_notifier_call_chain(&reboot_notifier_list, SYS_INSANE, NULL);
> >  	machine_emergency_restart();
> >  }
> >  EXPORT_SYMBOL_GPL(emergency_restart);
> 
> i dont think this is a good idea. reboot_notifier_list is a blocking 
> notifier, i.e. it comes with a notifier->rwsem read-write mutex that is 
> taken when blocking_notifier_call_chain() is executed.
> 
> i.e. this patch puts a sleeping mutex operation (a down_read()) into a 
> highly critical code path of the kernel. This will decrease the 
> reliability of the kernel.

Andi pointed this out, too.

For these emergency cases (I'll change "SYS_INSANE" to "SYS_EMERGENCY")
I probably should be using raw_notifier_call_chain(), which requires
a slightly different form of list header but doesn't try to protect
against someone else adding to the notifier list.
> 
> what exactly are you trying to achieve?
> 
> 	Ingo

The impetus for these additions is to call back a driver in every case
that the kernel is going down.  In a partitioned system we need such a
driver to inform all other partitions that they need to disconnect from
the rebooting/halting/panicing partition (kernel image).  If they are not
informed, they may bring themselves crashing down as well.
(xpc is such a cross_partition driver)



I propose this revision of the patch instead:


Subject: [PATCH] reboot-notify additions

reboot-notify additions

This patch adds scans of the "reboot_notifier_list" callback chain in
the remaining places where the kernel is being stopped and/or restarted.

Adds 3 calls to {raw|blocking}_notifier_call_chain() in:
   crash_kexec(), sys_kexec_load(), emergency_restart()

Diffed against 2.6.26-rc6

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 include/linux/notifier.h |    3 +++
 kernel/kexec.c           |   10 ++++++++++
 kernel/sys.c             |    7 +++++++
 3 files changed, 20 insertions(+)

Index: linux/include/linux/notifier.h
===================================================================
--- linux.orig/include/linux/notifier.h
+++ linux/include/linux/notifier.h
@@ -202,6 +202,9 @@ static inline int notifier_to_errno(int 
 #define SYS_RESTART	SYS_DOWN
 #define SYS_HALT	0x0002	/* Notify of system halt */
 #define SYS_POWER_OFF	0x0003	/* Notify of system power off */
+#define SYS_EMERGENCY	0x0004	/* Notify of system error/panic/oops */
+/* For the SYS_EMERGENCY case, no locks should be taken by the called-back
+ * function. */
 
 #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
 
Index: linux/kernel/kexec.c
===================================================================
--- linux.orig/kernel/kexec.c
+++ linux/kernel/kexec.c
@@ -24,6 +24,7 @@
 #include <linux/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/numa.h>
+#include <linux/notifier.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1001,6 +1002,9 @@ asmlinkage long sys_kexec_load(unsigned 
 		if (result)
 			goto out;
 	}
+
+	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, NULL);
+
 	/* Install the new kernel, and  Uninstall the old */
 	image = xchg(dest_image, image);
 
@@ -1063,11 +1067,17 @@ void crash_kexec(struct pt_regs *regs)
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
