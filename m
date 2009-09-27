Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZI0TKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZI0TKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 15:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZI0TKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 15:10:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33777 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZI0TKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 15:10:16 -0400
Date: Sun, 27 Sep 2009 20:09:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Solving section mismatches
Message-ID: <20090927190953.GE20093@n2100.arm.linux.org.uk>
References: <20090927164115.GB20093@n2100.arm.linux.org.uk> <20090927182707.GA10405@merkur.ravnborg.org> <20090927183904.GD20093@n2100.arm.linux.org.uk> <20090927184645.GA10454@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927184645.GA10454@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 08:46:45PM +0200, Sam Ravnborg wrote:
> Please look at the above and realise that cpu_die() is only ever defined
> in case that HOTPLUG_CPU is defined. So there is nothing to discard if
> HOTPLUG_CPU equals to n.
> 
> And just to repeat myself....
> The only correct use of __cpu* annotation is for function/data that is
> used with or without HOTPLUG_CPU equals to y.
> Which is NOT the case for cpu_die().
> 
> The __cpu* annotation is not a replacement for ifdeffed out code that is
> not relevant for the non-HOTPLUG_CPU case.

Ok.  But that still doesn't solve:

WARNING: arch/arm/kernel/built-in.o(.text+0x6274): Section mismatch in reference from the function cpu_die() to the function .cpuinit.text:secondary_start_kernel()
The function cpu_die() references
the function __cpuinit secondary_start_kernel().
This is often because cpu_die lacks a __cpuinit 
annotation or the annotation of secondary_start_kernel is wrong.

So are you saying secondary_start_kernel should not have __cpuinit?

That seems wrong, since we do want it to be discarded as __init in the
non-hotplug case, but we do want it kept around in the hotplug cpu
case.  I guess something like the following could be used instead:

#ifdef CONFIG_HOTPLUG_CPU
asmlinkage void secondary_start_kernel(void)
#else
asmlinkage void __init secondary_start_kernel(void)
#endif
{
...
}

but my understanding was that's what __cpuinit was supposed to be
doing for us in the first place.
