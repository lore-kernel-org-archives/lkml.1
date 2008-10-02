Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYJBXnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYJBXnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbYJBXnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:43:25 -0400
Received: from www.tglx.de ([62.245.132.106]:56869 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbYJBXnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:43:24 -0400
Date: Fri, 3 Oct 2008 01:42:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Olaf Kirch <okir@suse.de>,
       Jiri Kosina <jkosina@suse.cz>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-netdev@vger.kernel.org,
       kkeil@suse.de, agospoda@redhat.com, arjan@linux.intel.com,
       david.graham@intel.com, bruce.w.allan@intel.com, john.ronciak@intel.com,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] e1000e: prevent concurrent access to NVRAM
In-Reply-To: <200810021703.43770.okir@suse.de>
Message-ID: <alpine.LFD.1.10.0810030041060.5549@apollo.tec.linutronix.de>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com> <20080930031952.22950.45228.stgit@jbrandeb-bw.jf.intel.com> <Pine.LNX.4.64.0810021624380.1887@twin.jikos.cz> <200810021703.43770.okir@suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, Olaf Kirch wrote:

> On Thursday 02 October 2008 16:28:42 Jiri Kosina wrote:
> >
> > 15:50:52 linux-pr0e kernel: WARNING: at drivers/net/e1000e/ich8lan.c:424 e1000_acquire_swflag_ich8lan+0x5a/0xdc [e1000e]()
> > 15:50:52 linux-pr0e kernel: e1000e mutex contention. Owned by pid 4162
> > 15:50:52 linux-pr0e kernel: Call Trace:
> > 15:50:52 linux-pr0e kernel:  [<ffffffff8020e41e>] show_trace_log_lvl+0x41/0x58
> > 15:50:52 linux-pr0e kernel:  [<ffffffff80493716>] dump_stack+0x69/0x6f
> > 15:50:52 linux-pr0e kernel:  [<ffffffff8023ee54>] warn_slowpath+0xb4/0xdc
> > 15:50:52 linux-pr0e kernel:  [<ffffffffa022ce2e>] e1000_acquire_swflag_ich8lan+0x5a/0xdc [e1000e]
> > 15:50:52 linux-pr0e kernel:  [<ffffffffa02317ba>] e1000e_read_phy_reg_igp+0x19/0x64 [e1000e]
> > 15:50:52 linux-pr0e kernel:  [<ffffffffa02319f8>] e1000e_phy_has_link_generic+0x50/0xcc [e1000e]
> > 15:50:52 linux-pr0e kernel:  [<ffffffffa02306f9>] e1000e_check_for_copper_link+0x24/0x86 [e1000e]
> > 15:50:52 linux-pr0e kernel:  [<ffffffffa0236982>] e1000_watchdog_task+0x5c/0x5eb [e1000e]
> > 15:50:52 linux-pr0e kernel:  [<ffffffff8024ecdb>] run_workqueue+0xa4/0x14c
> > 15:50:52 linux-pr0e kernel:  [<ffffffff8024ee5b>] worker_thread+0xd8/0xe7
> > 15:50:52 linux-pr0e kernel:  [<ffffffff80251fe5>] kthread+0x47/0x73
> > 15:50:52 linux-pr0e kernel:  [<ffffffff8020d7a9>] child_rip+0xa/0x11
> 
> Looks like the e1000 watchdog racing with some dhclient activity (upping the interface).
> 
> I just noticed that the driver actually uses register pages. So it looks like it's
> possible to have something like this without the mutex:
> 
> 	process A selects page A
> 	process B selects page B
> 	process A writes to register at offset A'
> 
> So we may end up writing to the wrong register. I think I heard Vojtech mention
> that the e1000e also has a register based interface to erase/rewrite the NVM
> programmatically. Do we know at which offsets these registers live?

Linus,

can you please apply the patch below which prevents the concurrent
access to the NVRAM. It triggered the trace which Olaf reported above.

I worked out that patch on Sept 24th and it triggered a couple of
problems in the e1000e code right away. These have been addressed by
Jesse and are part of the patch series he posted in the last days.

Still, all we have in mainline is some "hopefully bug preventing"
patch which does not address the root cause at all.

The confirmed bugs where the nvram acquire code was called
concurrently are still in your tree and the prevention patch along
with the resulting bugfixes are stuck in some obscure intel QA
process.

Please apply at least the bug prevention patch below.

Thanks,

	tglx
---
Subject: e1000e prevent concurrent access and debug contention on NVM SWFALG
Date: Wed, 24 Sep 2008 00:45:08 -0700
From: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: jesse.brandeburg@intel.com
---

 drivers/net/e1000e/ich8lan.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6/drivers/net/e1000e/ich8lan.c
===================================================================
--- linux-2.6.orig/drivers/net/e1000e/ich8lan.c
+++ linux-2.6/drivers/net/e1000e/ich8lan.c
@@ -382,6 +382,9 @@ static s32 e1000_get_variants_ich8lan(st
 	return 0;
 }
 
+static DEFINE_MUTEX(nvm_mutex);
+static pid_t nvm_owner = -1;
+
 /**
  *  e1000_acquire_swflag_ich8lan - Acquire software control flag
  *  @hw: pointer to the HW structure
@@ -395,6 +398,15 @@ static s32 e1000_acquire_swflag_ich8lan(
 	u32 extcnf_ctrl;
 	u32 timeout = PHY_CFG_TIMEOUT;
 
+	WARN_ON(preempt_count());
+
+	if (!mutex_trylock(&nvm_mutex)) {
+		WARN(1, KERN_ERR "e1000e mutex contention. Owned by pid %d\n",
+		     nvm_owner);
+		mutex_lock(&nvm_mutex);
+	}
+	nvm_owner = current->pid;
+
 	while (timeout) {
 		extcnf_ctrl = er32(EXTCNF_CTRL);
 		extcnf_ctrl |= E1000_EXTCNF_CTRL_SWFLAG;
@@ -409,6 +421,8 @@ static s32 e1000_acquire_swflag_ich8lan(
 
 	if (!timeout) {
 		hw_dbg(hw, "FW or HW has locked the resource for too long.\n");
+		nvm_owner = -1;
+		mutex_unlock(&nvm_mutex);
 		return -E1000_ERR_CONFIG;
 	}
 
@@ -430,6 +444,9 @@ static void e1000_release_swflag_ich8lan
 	extcnf_ctrl = er32(EXTCNF_CTRL);
 	extcnf_ctrl &= ~E1000_EXTCNF_CTRL_SWFLAG;
 	ew32(EXTCNF_CTRL, extcnf_ctrl);
+
+	nvm_owner = -1;
+	mutex_unlock(&nvm_mutex);
 }
 
 /**



