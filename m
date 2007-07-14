Return-Path: <linux-kernel-owner+w=401wt.eu-S1760926AbXGNJwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760926AbXGNJwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 05:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754447AbXGNJwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 05:52:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbXGNJwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 05:52:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Sat, 14 Jul 2007 11:59:46 +0200
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <m1k5t4dzl4.fsf@ebiederm.dsl.xmission.com> <1184392129.1898.69.camel@caritas-dev.intel.com>
In-Reply-To: <1184392129.1898.69.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707141159.47289.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 July 2007 07:48, Huang, Ying wrote:
> On Fri, 2007-07-13 at 10:43 -0600, Eric W. Biederman wrote:
> > > Why a assembly stub is necessary? Is it not sufficient that just
> > > continue to complete a normal boot (hot add the reset of memory) or load
> > > the hibernated kernel (hibernated image) and jump to it?
> > 
> > I was thinking the assembly stub would be the small piece that jumps
> > to loaded hibernated kernel.  Quite possibly we could just get away
> > with providing no memory and just an entry point to kexec but it
> > makes sense to me to plan on running a couple of instructions.
> 
> Oh, I got it. In my patch, there is such assembly stub in
> arch/i386/kernel/kexec_jump.S. I think it is needed to restore basic CPU
> state and accommodate some position independent restore code (such as
> memory restore code).
> 
> > Actually the way the kexec infrastructure it might be reasonable to
> > just use sys_kexec_load to load the entire hibernated image.  Except
> > for the fact that sys_kexec_load requires the source pages to be
> > in the processes memory image the code shouldn't have the 50% of
> > memory limitation already.
> > 
> > If we can get that going we don't even need to restrict the first
> > kernels memory.  So it might just require teaching sys_kexec_load
> > how to steal process pages.  Anyway something to think about.
> 
> As for memory backupping and restoring during hibernating and resuming,
> I think a possible picture can be as follow:
> 
> Memory:
> 
>   Total memory: 512M
>   Memory used by hibernating/resuming kernel: 0~16M
> 
> 
> Hibernating process:
> 
>   1. Normal kernel running
>   2. Hibernating is triggered, sys_kexec_load is used to load
>      hibernating kernel and initramfs into memory. Then
>      sys_reboot(LINUX_REBOOT_CMD_KSPAWN) is invoked.
>   3. In sys_reboot, kexec_jump is called to save device/CPU state,
>      then relocate_kernel is called. kexec_jump and relocate_kernel
>      reside in individual page in 16M~512M.

OK

What's going to happen to devices at this point?

>   4. In relocate_kernel, 0~16M is backupped firstly, then the
>      hibernating kernel and initramfs is copied to 0~16M, after that,
>      the hibernating kernel is booted.
>   5. In hibernating kernel, the memory of normal kernel (it is in
>      16M~512M) is saved into a hibernation image through /dev/mem
>      and ELF header.

I don't think it can be _that_ simple:
(a) what about processes' memory
(b) what about areas that shouldn't be saved?

> Resume process:
> 
>   1. Resuming kernel is booted as a normal kernel, but the memory is
>      restricted to 0~16M.
>   2. Checking whether there is a effective hibernation image. If
>      there isn't, the memory of 16M~512M is hot added, and the normal
>      boot up process continues; If there is, a resuming process is
>      triggered.
>   3. sys_kexec_load is used to restore the memory state of hibernated
>      kernel. The sys_kexec_load works in crashdump way, that is, the
>      hibernation image is copied to destination location in 16M~512M
>      in sys_kexec_load instead of relocate_kernel. There is no half
>      of memory size restriction.
>   4. sys_reboot is called to trigger jumping back, which will jump back
>      to kexec_jump of hibernated kernel.
>   5. In kexec_jump of hibernated kernel, the memory of 0~16M is copied
>      back from the backup area in 16M~512M. The memory state of
>      hibernated kernel is restored totally. The CPU and device state
>      can be restored after that.

Well, I don't know why this needs to be that complicated.  We already have
code in the mainline that's able to load a large hibernation image into memory
and jump to the kernel being restored.  And it has _no_ 50% of RAM limitation,
this is the _saving_ part of the current code that this limitation comes from.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
