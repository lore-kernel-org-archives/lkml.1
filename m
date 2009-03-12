Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZCLAdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZCLAdI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZCLAcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:32:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:52475 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZCLAcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:32:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,346,1233561600"; 
   d="scan'208";a="672250743"
Subject: Re: [PATCH] VM, x86, PAT: Change implementation of
 is_linear_pfn_mapping
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Frans Pop <elendil@planet.nl>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
       "thellstrom@vmware.com" <thellstrom@vmware.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Nick Piggin <npiggin@suse.de>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>
In-Reply-To: <200903112309.40145.elendil@planet.nl>
References: <498B5ADE.3090602@vmware.com> <m1tz78pdwy.fsf@fess.ebiederm.org>
	 <498C062C.201@vmware.com> <20090304060857.GA18318@linux-os.sc.intel.com>
	 <130CA3A191875048A0624FB523A55EC7075DA7CA@PA-EXMBX51.vmware.com>
	 <20090310013953.GA11312@linux-os.sc.intel.com>
	 <49B6232B.4050503@vmware.com>
	 <1236706959.4529.56.camel@localhost.localdomain>
	 <49B781B6.3060704@vmware.com> <20090311093338.GC12814@elte.hu>
	 <20090311093338.GC12814@elte.hu>
	 <20090311175452.GA1702@linux-os.sc.intel.com>
	 <200903112309.40145.elendil@planet.nl>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 17:31:52 -0700
Message-Id: <1236817912.4529.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 15:09 -0700, Frans Pop wrote:
> Pallipadi, Venkatesh wrote:
> > Use of vma->vm_pgoff to identify the pfnmaps that are fully
> > mapped at mmap time is broke. vm_pgoff is set by generic mmap
> > code even for cases where drivers are setting up the mappings
> > at the fault time.
> > 
> > The problem was originally reported here.
> > http://marc.info/?l=linux-kernel&m=123383810628583&w=2
> > 
> > Change is_linear_pfn_mapping logic to overload VM_NONLINEAR
> > flag along with VM_PFNMAP to mean full PFNMAP setup at mmap
> > time.
> > 
> > Acked-by: Thomas Hellstrom <thellstrom@vmware.com>
> > Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > Signed-off-by: Suresh Siddha <suresh.b.siddha>@intel.com>
> 
> I've applied this patch on top of v2.6.29-rc7-143-g99adcd9 [1] and since 
> then I've had my system, or rather X/KDE, hang several times. The last 
> time the problem seems to have been KDE's kicker. I was running a kernel 
> compile in a konsole window and that just continued and finished, but the 
> keyboard was completely dead.
> I could still ssh in from another box. 'ps' would show the top processes, 
> but hang as well at some point (in the middle of listing KDE processes.
> 
> The hang was with pat enabled. I've now booted with nopat.

Frans,

Thanks for testing this. I don't seem to reproduce this on any of my
test systems with this patch on either tip or latest git. Do you see the
hang on every boot or once in a while? Are things stable with nopat?

> The log shows (full log attached):
> kernel: BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000008
> kernel: IP: [<ffffffff80322504>] prio_tree_remove+0x9c/0xcc
> kernel: PGD 7cab1067 PUD 7d644067 PMD 0
> kernel: Oops: 0000 [#1] SMP
> kernel: last sysfs file: /sys/class/power_supply/C23D/charge_full
> kernel: CPU 1
> kernel: Pid: 5415, comm: kicker Not tainted 2.6.29-rc7 #4 HP Comp
> aq 2510p Notebook PC
> kernel: RIP: 0010:[<ffffffff80322504>]  [<ffffffff80322504>] prio
> _tree_remove+0x9c/0xcc
> [...]
> kernel: Call Trace:
> kernel:  [<ffffffff803225df>] prio_tree_insert+0xab/0x22a
> kernel:  [<ffffffff8027e90d>] vma_prio_tree_insert+0x23/0xc2
> kernel:  [<ffffffff802864af>] __vma_link_file+0x70/0x72
> kernel:  [<ffffffff80286c15>] vma_link+0x7d/0xab
> kernel:  [<ffffffff802881ea>] mmap_region+0x313/0x479
> kernel:  [<ffffffff80288646>] do_mmap_pgoff+0x2f6/0x35c
> kernel:  [<ffffffff802ea99a>] do_shmat+0x28a/0x36c
> kernel:  [<ffffffff802eaa8d>] sys_shmat+0x11/0x1c
> kernel:  [<ffffffff8020c25b>] system_call_fastpath+0x16/0x1b
> 
> From the symptoms I strongly suspect this patch to be the culprit.
> 
> [1] Together with some other patches (mainly Rafael's latest patchset 
> for "Rework disabling of interrupts during suspend-resume"), but I doubt 
> any of those are related to this issue.
> 

Nothing obvious strikes me with this patch and above OOPs. Can you
please try this patch alone on latest git and check whether you still
see the failures?

Thanks,
Venki

