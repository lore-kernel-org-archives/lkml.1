Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbXGOJbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbXGOJbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 05:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbXGOJbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 05:31:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:58465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901AbXGOJbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 05:31:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,540,1175497200"; 
   d="scan'208";a="266427311"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <200707142116.10237.rjw@sisk.pl>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <200707141159.47289.rjw@sisk.pl>
	 <1184410554.1898.84.camel@caritas-dev.intel.com>
	 <200707142116.10237.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sun, 15 Jul 2007 17:30:04 +0800
Message-Id: <1184491804.1898.121.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 15 Jul 2007 09:30:58.0088 (UTC) FILETIME=[D9A6A280:01C7C6C2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 21:16 +0200, Rafael J. Wysocki wrote:
> > The devices should be quiesced and the state of devices should be saved
> > in kexec_jump, before relocate_kernel is called. This needs the
> > implementation of device hibernating as you mentioned before.
> 
> Hmm, at which point devices are normally shut down when kexec is used?

I think putting devices in quiescent state (not in low power state) is
sufficient for booting a new kernel with kexec, is it? According to my
experiment, the new kernel can be booted with kexec if the .suspend
method the drivers is called before kexec (given CONFIG_ACPI is not
selected).

Do we need a device quiesce/save + device shutdown for kexeced kernel to
work? I don't think so.

> > > >   4. In relocate_kernel, 0~16M is backupped firstly, then the
> > > >      hibernating kernel and initramfs is copied to 0~16M, after that,
> > > >      the hibernating kernel is booted.
> > > >   5. In hibernating kernel, the memory of normal kernel (it is in
> > > >      16M~512M) is saved into a hibernation image through /dev/mem
> > > >      and ELF header.
> > > 
> > > I don't think it can be _that_ simple:
> > > (a) what about processes' memory
> > > (b) what about areas that shouldn't be saved?
> > 
> > The mem_map (struct page[]) of every zone of hibernated kernel is
> > checked.  Necessary pages are saved, like memory snapshot of software
> > suspend, but in user space.
> 
> Well, it's not enough to check that, sorry.  That's why we have
> register_nosave_region().

After some investigation, I found the usage of "nosave" is as follow on
i386:

1. __nosavedata
   used only for global variable in_suspend and swsusp_pg_dir
2. PG_nosave page flags
   used for snapshot itself

Both are not necessary for kexec based hibernation. Because the image
are written from a different kernel, the memory of hibernating kernel
will not be saved, they can be used freely during image writing/reading.

On x86_64, there is another usage of nosave during processing E820
memory map. But I don't know why the memory region other than E820_RAM
are marked as nosave. I think only the memory region of type E820_RAM
will be thought of normal memory, others will be thought as reserved. Is
it sufficient just to check whether the page is reserved?
 
Best Regards,
Huang Ying
