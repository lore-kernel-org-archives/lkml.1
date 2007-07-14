Return-Path: <linux-kernel-owner+w=401wt.eu-S1762231AbXGNK5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762231AbXGNK5T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 06:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760967AbXGNK45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 06:56:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:18498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760340AbXGNK4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 06:56:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,538,1175497200"; 
   d="scan'208";a="106209113"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <200707141159.47289.rjw@sisk.pl>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <m1k5t4dzl4.fsf@ebiederm.dsl.xmission.com>
	 <1184392129.1898.69.camel@caritas-dev.intel.com>
	 <200707141159.47289.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 14 Jul 2007 18:55:54 +0800
Message-Id: <1184410554.1898.84.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 14 Jul 2007 10:56:51.0164 (UTC) FILETIME=[AEB5E1C0:01C7C605]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-07-14 at 11:59 +0200, Rafael J. Wysocki wrote:
> > Hibernating process:
> > 
> >   1. Normal kernel running
> >   2. Hibernating is triggered, sys_kexec_load is used to load
> >      hibernating kernel and initramfs into memory. Then
> >      sys_reboot(LINUX_REBOOT_CMD_KSPAWN) is invoked.
> >   3. In sys_reboot, kexec_jump is called to save device/CPU state,
> >      then relocate_kernel is called. kexec_jump and relocate_kernel
> >      reside in individual page in 16M~512M.
> 
> OK
> What's going to happen to devices at this point?
> 

The devices should be quiesced and the state of devices should be saved
in kexec_jump, before relocate_kernel is called. This needs the
implementation of device hibernating as you mentioned before.

> >   4. In relocate_kernel, 0~16M is backupped firstly, then the
> >      hibernating kernel and initramfs is copied to 0~16M, after that,
> >      the hibernating kernel is booted.
> >   5. In hibernating kernel, the memory of normal kernel (it is in
> >      16M~512M) is saved into a hibernation image through /dev/mem
> >      and ELF header.
> 
> I don't think it can be _that_ simple:
> (a) what about processes' memory
> (b) what about areas that shouldn't be saved?

The mem_map (struct page[]) of every zone of hibernated kernel is
checked.  Necessary pages are saved, like memory snapshot of software
suspend, but in user space.

> > Resume process:
> > 
> >   1. Resuming kernel is booted as a normal kernel, but the memory is
> >      restricted to 0~16M.
> >   2. Checking whether there is a effective hibernation image. If
> >      there isn't, the memory of 16M~512M is hot added, and the normal
> >      boot up process continues; If there is, a resuming process is
> >      triggered.
> >   3. sys_kexec_load is used to restore the memory state of hibernated
> >      kernel. The sys_kexec_load works in crashdump way, that is, the
> >      hibernation image is copied to destination location in 16M~512M
> >      in sys_kexec_load instead of relocate_kernel. There is no half
> >      of memory size restriction.
> >   4. sys_reboot is called to trigger jumping back, which will jump back
> >      to kexec_jump of hibernated kernel.
> >   5. In kexec_jump of hibernated kernel, the memory of 0~16M is copied
> >      back from the backup area in 16M~512M. The memory state of
> >      hibernated kernel is restored totally. The CPU and device state
> >      can be restored after that.
> 
> Well, I don't know why this needs to be that complicated.  We already have
> code in the mainline that's able to load a large hibernation image into memory
> and jump to the kernel being restored.  And it has _no_ 50% of RAM limitation,
> this is the _saving_ part of the current code that this limitation comes from.

There is much similarity between sys_kexec_load and software resuming.
If resuming can be done by sys_kexec_load, then we need not two similar
functionality in kernel.

Best Regards,
Huang Ying
