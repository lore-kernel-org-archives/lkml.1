Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbXGNFuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbXGNFuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 01:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXGNFtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 01:49:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:36935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbXGNFtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 01:49:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,538,1175497200"; 
   d="scan'208";a="106167521"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m1k5t4dzl4.fsf@ebiederm.dsl.xmission.com>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <20070711172243.ab44c4d4.akpm@linux-foundation.org>
	 <1184251423.9346.55.camel@caritas-dev.intel.com>
	 <m14pk9fuqa.fsf@ebiederm.dsl.xmission.com>
	 <1184368525.1069.68.camel@caritas-dev.intel.com>
	 <m1k5t4dzl4.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 14 Jul 2007 13:48:49 +0800
Message-Id: <1184392129.1898.69.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 14 Jul 2007 05:49:46.0917 (UTC) FILETIME=[C900E550:01C7C5DA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 10:43 -0600, Eric W. Biederman wrote:
> > Why a assembly stub is necessary? Is it not sufficient that just
> > continue to complete a normal boot (hot add the reset of memory) or load
> > the hibernated kernel (hibernated image) and jump to it?
> 
> I was thinking the assembly stub would be the small piece that jumps
> to loaded hibernated kernel.  Quite possibly we could just get away
> with providing no memory and just an entry point to kexec but it
> makes sense to me to plan on running a couple of instructions.

Oh, I got it. In my patch, there is such assembly stub in
arch/i386/kernel/kexec_jump.S. I think it is needed to restore basic CPU
state and accommodate some position independent restore code (such as
memory restore code).

> Actually the way the kexec infrastructure it might be reasonable to
> just use sys_kexec_load to load the entire hibernated image.  Except
> for the fact that sys_kexec_load requires the source pages to be
> in the processes memory image the code shouldn't have the 50% of
> memory limitation already.
> 
> If we can get that going we don't even need to restrict the first
> kernels memory.  So it might just require teaching sys_kexec_load
> how to steal process pages.  Anyway something to think about.

As for memory backupping and restoring during hibernating and resuming,
I think a possible picture can be as follow:

Memory:

  Total memory: 512M
  Memory used by hibernating/resuming kernel: 0~16M


Hibernating process:

  1. Normal kernel running
  2. Hibernating is triggered, sys_kexec_load is used to load
     hibernating kernel and initramfs into memory. Then
     sys_reboot(LINUX_REBOOT_CMD_KSPAWN) is invoked.
  3. In sys_reboot, kexec_jump is called to save device/CPU state,
     then relocate_kernel is called. kexec_jump and relocate_kernel
     reside in individual page in 16M~512M.
  4. In relocate_kernel, 0~16M is backupped firstly, then the
     hibernating kernel and initramfs is copied to 0~16M, after that,
     the hibernating kernel is booted.
  5. In hibernating kernel, the memory of normal kernel (it is in
     16M~512M) is saved into a hibernation image through /dev/mem
     and ELF header.


Resume process:

  1. Resuming kernel is booted as a normal kernel, but the memory is
     restricted to 0~16M.
  2. Checking whether there is a effective hibernation image. If
     there isn't, the memory of 16M~512M is hot added, and the normal
     boot up process continues; If there is, a resuming process is
     triggered.
  3. sys_kexec_load is used to restore the memory state of hibernated
     kernel. The sys_kexec_load works in crashdump way, that is, the
     hibernation image is copied to destination location in 16M~512M
     in sys_kexec_load instead of relocate_kernel. There is no half
     of memory size restriction.
  4. sys_reboot is called to trigger jumping back, which will jump back
     to kexec_jump of hibernated kernel.
  5. In kexec_jump of hibernated kernel, the memory of 0~16M is copied
     back from the backup area in 16M~512M. The memory state of
     hibernated kernel is restored totally. The CPU and device state
     can be restored after that.


If there is too much difficulty to hot add memory in step 2. A more
conservative method can be used as step 1 and step 2.

  1. A normal kernel is booted.
  2. Checking whether there is a effective hibernation image. If there
     isn't, continue the normal boot process; otherwise, a resuming
     kernel is kexeced in memory 0~16M. The resuming process will
     continue in kexeced resuming kernel.

Best Regards,
Huang Ying
