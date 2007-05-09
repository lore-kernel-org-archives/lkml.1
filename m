Return-Path: <linux-kernel-owner+w=401wt.eu-S969038AbXEIBIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969038AbXEIBIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 21:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1033134AbXEIBHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 21:07:53 -0400
Received: from science.horizon.com ([192.35.100.1]:11351 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1033124AbXEIBHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 21:07:51 -0400
Date: 8 May 2007 21:07:49 -0400
Message-ID: <20070509010749.14584.qmail@science.horizon.com>
From: linux@horizon.com
To: linux-kernel@vger.kernel.org, mzhao@lizotech-inc.com
Subject: Re: increase Linux kernel address space 3.5 G memory on Redhat Enterprise
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi:
> I am running Redhat Linux Enterprise version 4 update 4 on a dual-core
> 4G memory machine.  There are many references on the web talking about
> increasing default user address space to 3.5 G however lacking specific
> instructions. My questions:
> 
> 1. What is the specific steps to be done for the kernel to support 3.5 G 
>    address space?
> 2. Do I need to re-compile kernel to make this happen? If so, any 
>    specific instruction?

2. Yes, you need to re-compile the kernel.  Instructions all over the web.
   Basically, "cd /usr/src/linux", make sure a reasonable default .config
   file is installed (the distribution should supply one for its default
   kernel), "make menuconfig" or "make xconfig", change the options you
   want changed, then "make" and "make install".  The latter *usually*
   works; the usual worst case is that it installs it somewhere other than
   your boot loader is looking and rebooting will find the old kernel.

   The fun comes when you left an option out of your new kernel that you
   need to boot - like the hard drive controller!  Then you need to go
   back to an old, known working kernel.

   It's not at all difficult, but you do need to be careful; a mistake
   can be awkward to recover from if you don't plan ahead.

1. First of all, that's not necessarily a good idea.  Doing that would limit
   you to 384 MB of kernel memory, after the usual 128 MB deduction for
   PCI devices.  That has to fit the kernel binary, all page tables, inode
   cache, network buffers, and so on.  For some workloads, that can be
   a bottleneck.

   If your application is heavily biased toward file data that the kernel
   doesn't have to look at, such as databases, it might be okay.

   A much better thing would be to take advantage of the fact that
   every multi-core processor I've heard of (IBM's POWER4, Sun Niagara,
   and a few by some companies you may not have heard of like Intel and
   AMD) is a 64-bit processor.  So you can run a 64bit kernel and get
   terabytes of user address space.  Even 32-bit applications get a full
   4G of address space, as the 64-bit kernel doesn't need to share.

   That would make your user application happier *and* the kernel happier.
   It would increase kernel data structure size, but it's still usually a
   net win.

1b. If you really want to do it, it's not a normally selectable option,
    but you can add it to arch/i386/Kconfig by following the pattern of
    the others.  You need CONFIG_PAGE_OFFSET=0xE0000000, and you need to
    be sure that CONFIG_HIGHMEM64G is turned OFF.  (If it's on, you're
    using PAE, and its 3-level page table structure requires using a
    1G boundary.)

    Then configure the kernel, select CONFIG_EMBEDDED under "General setup",
    then your memory split under "Processor type and features".

    Compile, install the new kernel, and reboot.
