Return-Path: <linux-kernel-owner+w=401wt.eu-S1760532AbYGKVY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760532AbYGKVY1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 17:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbYGKVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 17:24:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:60950 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbYGKVYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 17:24:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,347,1212390000"; 
   d="scan'208";a="591902649"
Date: Fri, 11 Jul 2008 14:24:19 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Message-ID: <20080711212418.GV1678@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710195320.GA23322@elte.hu> <20080710215617.GM1678@linux-os.sc.intel.com> <20080711102814.GA17938@elte.hu> <20080711200957.GA8173@elte.hu> <20080711203151.GU1678@linux-os.sc.intel.com> <86802c440807111342j5fbf21e1ibd5129718cde4e43@mail.gmail.com> <20080711204521.GA15689@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711204521.GA15689@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 01:45:21PM -0700, Ingo Molnar wrote:
> 
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > Setting APIC routing to physical flat
> > Kernel panic - not syncing: Boot APIC ID in local APIC unexpected (0 vs 4)
> > Pid: 1, comm: swapper Not tainted 2.6.26-rc9-tip-01763-g74f94b1-dirty #320
> >
> > Call Trace:
> >  [<ffffffff80a21505>] ? set_cpu_sibling_map+0x38c/0x3bd
> >  [<ffffffff80245215>] ? read_xapic_id+0x25/0x3e
> >  [<ffffffff80e5a2c3>] ? verify_local_APIC+0x139/0x1b9
> >  [<ffffffff80245215>] ? read_xapic_id+0x25/0x3e
> >  [<ffffffff80e589af>] ? native_smp_prepare_cpus+0x224/0x2e9
> >  [<ffffffff80e4881a>] ? kernel_init+0x64/0x341
> >  [<ffffffff8022a439>] ? child_rip+0xa/0x11
> >  [<ffffffff80e487b6>] ? kernel_init+0x0/0x341
> >  [<ffffffff8022a42f>] ? child_rip+0x0/0x11
> >
> >
> > guess read_apic_id changing cuase some problem...

Yinghai, Can you please try the appended patch to see if it fixes your problem?

I guess you need to try the tip/x86/x2apic tree now please :(

BTW, I don't know why we even do verify_local_APIC() in 64bit. Especially
when we don't care for the return value, it should be a no-op.

---
genapic's read_apic_id() returns the actual apic id extracted from
the APIC_ID register. And in some cases like UV, read_apic_id()
returns completely different values from APIC ID register.

Use the native apic register read, rather than genapic read_apic_id()
in verify_local_APIC()

And also, lapic_suspend() should also use native apic register read.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 9a319d7..dd05010 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -698,10 +698,10 @@ int __init verify_local_APIC(void)
 	/*
 	 * The ID register is read/write in a real APIC.
 	 */
-	reg0 = read_apic_id();
+	reg0 = apic_read(APIC_ID);
 	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg0);
 	apic_write(APIC_ID, reg0 ^ APIC_ID_MASK);
-	reg1 = read_apic_id();
+	reg1 = apic_read(APIC_ID);
 	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg1);
 	apic_write(APIC_ID, reg0);
 	if (reg1 != (reg0 ^ APIC_ID_MASK))
@@ -1336,7 +1336,7 @@ static int lapic_suspend(struct sys_device *dev, pm_message_t state)
 
 	maxlvt = lapic_get_maxlvt();
 
-	apic_pm_state.apic_id = read_apic_id();
+	apic_pm_state.apic_id = apic_read(APIC_ID);
 	apic_pm_state.apic_taskpri = apic_read(APIC_TASKPRI);
 	apic_pm_state.apic_ldr = apic_read(APIC_LDR);
 	apic_pm_state.apic_dfr = apic_read(APIC_DFR);
