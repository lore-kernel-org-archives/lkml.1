Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbXJ0GjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbXJ0GjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 02:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbXJ0GjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 02:39:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55240 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbXJ0GjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 02:39:04 -0400
Date: Sat, 27 Oct 2007 07:38:49 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Jeff Dike <jdike@addtoit.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [x86 patch] Fix UML signal.h build errors
Message-ID: <20071027063849.GL8181@ftp.linux.org.uk>
References: <20071025130022.8720.77346.sendpatchset@balbir-laptop> <20071025150541.GB5968@c2.user-mode-linux.org> <4720B6E8.4090003@linux.vnet.ibm.com> <20071027031309.GI8181@ftp.linux.org.uk> <4722D516.8020902@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4722D516.8020902@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 11:35:10AM +0530, Balbir Singh wrote:
> > b) I'd rather have __arch_um__ mentioned explicitly in 3 places where
> > we do care about difference between i386 and uml/i386 than have certain
> > to be forgotten rules for places like include/asm-x86
> > 
> > c) if you look at those places, you'll see
> > 	* drivers/char/mem.c::uncached_access().  Really per-architecture
> > and I wonder if it might be include/asm-* fodder...
> > 	* kernel/signal.c debugging printks.  Should die or be sanitized, IMO.
> > 	* raid6 algorithms.  Hell knows - immediate reason why we don't do
> > those on uml is the lack of kernel_fpu_begin()/kernel_fpu_end() (and
> > boot_cpu_has(), but that's easier to add).  Do we care to implement that
> > stuff?

> I suspect that list might grow and anybody writing i386 or x86_64 code
> will need to double check if the code will work under __arch_um__.
> Probably worth documenting somewhere.

For x86-only code it's not really a problem - i.e. if we pull it into
uml build at all, checks for BITS_PER_LONG/__i386__/CONFIG_64BIT/etc.
are all the same.  For arch-dependent drivers... we have very good
reasons not pull them into uml builds anyway.  And arch-independent
code shouldn't care at all, so we are left with random bits of arch-dependent
code ifdefed in generic one _and_ not handled via asm/*.h.  I.e. with very
few odd cases - it's not that we wanted to add and keep such places anyway,
uml or no uml.

I'd say that raid6 is the only legitimate current case and even that is
somewhat dubious - we might e.g. not bother with x86-only parts of
raid456-objs on other targets and handle that on Kconfig/Makefile level.
