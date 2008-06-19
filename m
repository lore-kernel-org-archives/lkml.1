Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYFSWBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYFSWBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 18:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYFSWBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 18:01:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54352 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbYFSWBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 18:01:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cliff Wickman <cpw@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, andi@firstfloor.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
References: <E1K95kd-00081i-B6@eag09.americas.sgi.com>
	<20080619110214.GJ15228@elte.hu> <20080619145453.GA11929@sgi.com>
Date: Thu, 19 Jun 2008 14:50:49 -0700
In-Reply-To: <20080619145453.GA11929@sgi.com> (Cliff Wickman's message of
	"Thu, 19 Jun 2008 09:54:53 -0500")
Message-ID: <m1d4mdksau.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cliff Wickman <cpw@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.2836]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Sft_Co_L33T XM_Sft_Co_L33T
	*  0.0 XM_Sft_Brands_C00 XM_Sft_Brands_C00
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] X86: reboot-notify additions
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cliff Wickman <cpw@sgi.com> writes:

> On Thu, Jun 19, 2008 at 01:02:14PM +0200, Ingo Molnar wrote:
>> 
>> * Cliff Wickman <cpw@sgi.com> wrote:
>> 
>> > From: Cliff Wickman <cpw@sgi.com>
>> > 
>> > X86 reboot-notify additions.
>
> As Andi Kleen pointed out, this is not X86-specific.  (it started out
> to be, but what I hoped to achieve for X86 turns out to be generic).
>
>> > This patch adds scans of the "reboot_notifier_list" callback chain in
>> > a three other places where the kernel is being stopped and/or restarted.
>> > 
>> > Adds calls to blocking_notifier_call_chain() in:
>> >    crash_kexec(), emergency_restart(), sys_kexec_load()
>> > 
>> > In the crash_kexec() and emergency_restart() cases it is indicated to the
>> > called-back function that the system is not in a sane state, so that
>> > it can avoid taking a lock or some such potentially blocking action.
>> > 
>> > These callbacks are important to a partition system. The stopped kernel
> needs
>> > to inform other partitions of their need to disconnect (stop sharing
> memory).
>> > 
>> > Diffed against 2.6.26-rc6
>> > 
>> > Signed-off-by: Cliff Wickman <cpw@sgi.com>
>> > ---
>> >  include/linux/notifier.h |    4 ++++
>> >  kernel/kexec.c           |    5 +++++
>> >  kernel/sys.c             |    1 +
>> >  3 files changed, 10 insertions(+)
>> > 
>> > Index: linux/include/linux/notifier.h
>> > ===================================================================
>> > --- linux.orig/include/linux/notifier.h
>> > +++ linux/include/linux/notifier.h
>> > @@ -202,6 +202,10 @@ static inline int notifier_to_errno(int 
>> >  #define SYS_RESTART	SYS_DOWN
>> >  #define SYS_HALT	0x0002	/* Notify of system halt */
>> >  #define SYS_POWER_OFF	0x0003	/* Notify of system power off */
>> > +#define SYS_INSANE	0x0004	/* Notify of system error/panic/oops */
>> > +/* For the SYS_INSANE case, no locks should be taken by the called-back
>> > + * function.  The kernel is ready for an immediate reboot.
>> > + */
>> >  
>> >  #define NETLINK_URELEASE	0x0001	/* Unicast netlink socket released */
>> >  
>> > Index: linux/kernel/kexec.c
>> > ===================================================================
>> > --- linux.orig/kernel/kexec.c
>> > +++ linux/kernel/kexec.c
>> > @@ -1001,6 +1001,9 @@ asmlinkage long sys_kexec_load(unsigned 
>> >  		if (result)
>> >  			goto out;
>> >  	}
>> > +
>> > +	blocking_notifier_call_chain(&reboot_notifier_list, SYS_RESTART, NULL);
>> > +
>> >  	/* Install the new kernel, and  Uninstall the old */
>> >  	image = xchg(dest_image, image);
>> >  
>> > @@ -1068,6 +1071,8 @@ void crash_kexec(struct pt_regs *regs)
>> >  	if (!locked) {
>> >  		if (kexec_crash_image) {
>> >  			struct pt_regs fixed_regs;
>> > +			blocking_notifier_call_chain(&reboot_notifier_list,
>> > +				SYS_INSANE, NULL);
>> >  			crash_setup_regs(&fixed_regs, regs);
>> >  			crash_save_vmcoreinfo();
>> >  			machine_crash_shutdown(&fixed_regs);
>> > Index: linux/kernel/sys.c
>> > ===================================================================
>> > --- linux.orig/kernel/sys.c
>> > +++ linux/kernel/sys.c
>> > @@ -270,6 +270,7 @@ out_unlock:
>> >   */
>> >  void emergency_restart(void)
>> >  {
>> > +	blocking_notifier_call_chain(&reboot_notifier_list, SYS_INSANE, NULL);
>> >  	machine_emergency_restart();
>> >  }
>> >  EXPORT_SYMBOL_GPL(emergency_restart);
>> 
>> i dont think this is a good idea. reboot_notifier_list is a blocking 
>> notifier, i.e. it comes with a notifier->rwsem read-write mutex that is 
>> taken when blocking_notifier_call_chain() is executed.
>> 
>> i.e. this patch puts a sleeping mutex operation (a down_read()) into a 
>> highly critical code path of the kernel. This will decrease the 
>> reliability of the kernel.
>
> Andi pointed this out, too.
>
> For these emergency cases (I'll change "SYS_INSANE" to "SYS_EMERGENCY")
> I probably should be using raw_notifier_call_chain(), which requires
> a slightly different form of list header but doesn't try to protect
> against someone else adding to the notifier list.
>> 
>> what exactly are you trying to achieve?
>> 
>> 	Ingo
>
> The impetus for these additions is to call back a driver in every case
> that the kernel is going down.  In a partitioned system we need such a
> driver to inform all other partitions that they need to disconnect from
> the rebooting/halting/panicing partition (kernel image).  If they are not
> informed, they may bring themselves crashing down as well.
> (xpc is such a cross_partition driver)

Cool.  Someone who wants this kind of functionality and has code in
the kernel.  Perhaps we can have a reasonable discussion about this.
The last time this came up people wanted a hook so they could support
their out of tree blobs in an enterprise kernel.

emergency_restart only happens or only should happen with explicit admin
request Sysreq-r.  Or when a watchdog detects the system is borked.
By design it is not expected to call drivers.  The kexec on panic
case is similar.

sys_kexec_load is a ridiculous place to call any kind of reboot notifier
because it is a prep function that doesn't require any kind of connection
to rebooting.

As far as this being a generic problem I half agree.  It seems to depend
on your platform if you need something like this.

With that said.  I suggest we have a single platform specific function 
that can be called.  Possibly something like pm_power_off.  It is
insanely important that we be able to audit all of the code on these
code paths, and that a random loadable driver not be able to get in
and mess things up.

Eric
