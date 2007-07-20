Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbXGTOu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbXGTOu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 10:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932607AbXGTOuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 10:50:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:40894 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765405AbXGTOuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 10:50:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,563,1175497200"; 
   d="scan'208";a="108225927"
Subject: Re: [linux-pm] Re: Hibernation considerations
From: "Huang, Ying" <ying.huang@intel.com>
To: Milton Miller <miltonm@bga.com>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J.Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, David Lang <david@lang.hm>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
In-Reply-To: <40fa2626aff7b6b590ad6aa4737fc873@bga.com>
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm>
	 <Pine.LNX.4.44L0.0707171416120.3728-100000@iolanthe.rowland.org>
	 <200707172217.01890.rjw@sisk.pl> <87odiag45q.fsf@jbms.ath.cx>
	 <200707151433.34625.rjw@sisk.pl> <200707172320.16279.rjw@sisk.pl>
	 <40fa2626aff7b6b590ad6aa4737fc873@bga.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Jul 2007 22:48:38 +0800
Message-Id: <1184942918.13737.23.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 20 Jul 2007 14:49:20.0251 (UTC) FILETIME=[277E24B0:01C7CADD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-20 at 09:01 -0500, Milton Miller wrote:
> Simplifying kjump: the proposal for v3.
> 
> The current code is trying to use crash dump area as a safe, reserved 
> area to run the second kernel.   However, that means that the kernel 
> has to be linked specially to run in the reserved area.   I think we 
> need to finish separating kexec_jump from the other code paths.
> 
> (1) add a new command line argument that specifies the kexec_jump 
> target area (or just size?)
> 
> (2) add a kjump flag to the flags parameter, used by kexec_load.   When 
> loading a jump kernel, it is loaded like a normal kernel, however, 
> additional control pages are allocated to (a) save this kenrel's use of 
> the kexec_jump target area (b) save the backed up region that is used 
> by all kernels like crash dump, and (c) space for invoking 
> relocate_new_kernel that will get its args from the execution entry 
> point and will restore the kernel then call resume and suspend.

Backuping target memory before kexec and restoring it after kexec is
planed feature for kexec jump. But I will work on image writing/reading
first.

> (3) replace jump_huf_pfn with two command line addresses that specify 
> the (a) return point for after resume, and (b) the return point for 
> after image save.   Actually these can be done in userspace; the second 
> restore kernel can just specify the null copy list and the entry points 
> supplied by the suspended kernel.  To do resume we also need (c) where 
> to store resume address for the save kernel.

There is many free spaces in jump_buf_pfn page now. I think passing the
needed information through jump_buf_pfn is more convenient than through
kernel command line. That is, the jump_buf_pfn can be seen as a meta
interface, which is passed to kexeced kernel though command line, while
other information can be passed though jmp_buf_pfn.

> The seperation should be whoever builds a scatter copy list builds the 
> inverse list.  This is why I propose simple jump entry points.  I 
> expect just a few instructions to establish arguments for the call to 
> the exstinging relocate_new_kernel code.

If the "scatter copy" is replaced by "scatter swap", we need not the
inverse list, and the state of kexeced kernel can be backuped too. There
are "scatter copy" support in normal kexec implementation in
"relocate_kernel".

> As a first stage of suspend and resume, we can save to dedicated 
> partitions all memory (as supplied to crash_dump) that is not marked 
> nosave and not part of the save kernel's image.   The fancy block lists 
> and memory lists can be added later.
> 
> Mmaking these changes will allow us to use a normal kernel invoked
> with 
> acpi=off apm=off mem=xxk as the save and restore kernel.

Yes, I am working on this.

> If we want to keep the second kernel booted, then we need to add a save 
> area for the booted jump target.   Note that the save and restore lists 
> to relocate_new_kernel can be computed once and saved.   Longer term we 
> could implement sys_kexec_load(UNLOAD) that would retrieve the saved 
> list back to application space to save to disk in a file.   This means 
> you could save the booted save kernel, it just couldn't have any shared 
> storage open.

Yes, this is also in plan. But with lower priority and will only be
added if necessary.

Best Regards,
Huang Ying
