Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbXGOKl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbXGOKl7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 06:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbXGOKlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 06:41:50 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38424 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbXGOKlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 06:41:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Sun, 15 Jul 2007 12:49:25 +0200
User-Agent: KMail/1.9.5
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707142116.10237.rjw@sisk.pl> <1184491804.1898.121.camel@caritas-dev.intel.com>
In-Reply-To: <1184491804.1898.121.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707151249.26148.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 15 July 2007 11:30, Huang, Ying wrote:
> On Sat, 2007-07-14 at 21:16 +0200, Rafael J. Wysocki wrote:
> > > The devices should be quiesced and the state of devices should be saved
> > > in kexec_jump, before relocate_kernel is called. This needs the
> > > implementation of device hibernating as you mentioned before.
> > 
> > Hmm, at which point devices are normally shut down when kexec is used?
> 
> I think putting devices in quiescent state (not in low power state) is
> sufficient for booting a new kernel with kexec, is it? According to my
> experiment, the new kernel can be booted with kexec if the .suspend
> method the drivers is called before kexec (given CONFIG_ACPI is not
> selected).

Well, this illustrates the problem.  With ACPI, the devices are suspended
and without it their kind of quiesced.

Generally, we need to make them be quiesced with or without ACPI.  IOW,
the per-driver callbacks used before hibernation should be different from those
used before the suspend (to RAM and similar).
 
> Do we need a device quiesce/save + device shutdown for kexeced kernel to
> work? I don't think so.

No, we don't.

Still, my question was related to how kexec _normally_ handles devices.  Are
they shut down or they are just left in the state in which they were before?

I assume that kexec loads a new kernel into memory and then passes control
to it, but I think the new kernel needs to set up devices for itself.  I assume
that this is done in a usual way, ie. devices are detected, registered,
initialized, etc.  So, my question is if kexec prepares devices for that in any
way.

> > > > >   4. In relocate_kernel, 0~16M is backupped firstly, then the
> > > > >      hibernating kernel and initramfs is copied to 0~16M, after that,
> > > > >      the hibernating kernel is booted.
> > > > >   5. In hibernating kernel, the memory of normal kernel (it is in
> > > > >      16M~512M) is saved into a hibernation image through /dev/mem
> > > > >      and ELF header.
> > > > 
> > > > I don't think it can be _that_ simple:
> > > > (a) what about processes' memory
> > > > (b) what about areas that shouldn't be saved?
> > > 
> > > The mem_map (struct page[]) of every zone of hibernated kernel is
> > > checked.  Necessary pages are saved, like memory snapshot of software
> > > suspend, but in user space.
> > 
> > Well, it's not enough to check that, sorry.  That's why we have
> > register_nosave_region().
> 
> After some investigation, I found the usage of "nosave" is as follow on
> i386:
> 
> 1. __nosavedata
>    used only for global variable in_suspend and swsusp_pg_dir
> 2. PG_nosave page flags
>    used for snapshot itself

We don't use PG_nosave flags any more at all.

> Both are not necessary for kexec based hibernation. Because the image
> are written from a different kernel, the memory of hibernating kernel
> will not be saved, they can be used freely during image writing/reading.

This is not the point.  There are memory regions that you should not _restore_,
because that will cause harm.

> On x86_64, there is another usage of nosave during processing E820
> memory map. But I don't know why the memory region other than E820_RAM
> are marked as nosave. I think only the memory region of type E820_RAM
> will be thought of normal memory, others will be thought as reserved. Is
> it sufficient just to check whether the page is reserved?

No, it's not.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
