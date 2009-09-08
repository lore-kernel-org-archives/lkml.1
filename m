Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbZIHT1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbZIHT1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbZIHT1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:27:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbZIHT1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:27:17 -0400
Date: Tue, 8 Sep 2009 12:26:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: reinette chatre <reinette.chatre@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
Subject: Re: [Bug #13819] system freeze when switching to console
In-Reply-To: <20090908112014.002a35af@jbarnes-g45>
Message-ID: <alpine.LFD.2.01.0909081219130.7458@localhost.localdomain>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera> <Vm51Upp4EV.A.r-D.mgBpKB@chimera> <1252427375.14735.130.camel@rc-desk> <alpine.LFD.2.01.0909080943030.7458@localhost.localdomain> <1252431375.14735.139.camel@rc-desk> <alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
 <20090908112014.002a35af@jbarnes-g45>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Sep 2009, Jesse Barnes wrote:
> 
> Theoretically i915_gem_idle should prevent any user interrupts from
> coming in.

That is _entirely_ immaterial.

The thing is, interrupts can be shared. So it does not matter ONE WHIT 
that you are trying to idle the hardware - there may be _other_ hardware 
in the machine that is not idle, and that raises the same shared 
interrupt. End result: the irq handler will be called, whether your 
particular hardware is idle or not.

So if you tear down data structures that the interrupt handler needs, you 
_ABSOLUTELY_ must first unregister the whole interrupt.

Also, even if there are no shared interrupts or any other devices, there 
can easily be old pending interrupts still queued up on IO-APIC's etc. So 
even though you quiesce the hardware, there is no guarantee that there 
aren't some pending interrupts that happened just before you turned off 
the interrupt from the hardware side, and are still "en route" to the CPU.

Which gets us exactly the same rule as if there were shared interrupts: if 
your interrupt handler depends on some data structure, you must tear down 
the interrupt handler _before_ you tear down the data structures it 
depends on (and in the reverse order when setting things up, of course).

> If we uninstall the IRQ first we i915_gem_idle probably
> won't work anymore, since it queues an interrupt and waits for it.

So then you'd better fix that. Because the code as is is very 
fundamentally buggy.

> Eric, any thoughts on this?  We shouldn't be racing to queue new work
> after the idle call since we suspend GEM at that point, so we must be
> failing to manage our active lists properly somehow?

See my previous email. The bug is that you do

  i915_gem_cleanup_ringbuffer ->
    i915_gem_cleanup_hws ->
      dev_priv->hw_status_page = NULL;

while interrupts are still enabled and coming in. And the interrupt path 
wants to access that hw_status_page. Which you just destroyed.

			Linus
