Return-Path: <linux-kernel-owner+w=401wt.eu-S1751929AbZIHTby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbZIHTby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:31:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbZIHTbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:31:53 -0400
Received: from outbound-mail-27.bluehost.com ([69.89.17.193]:33684 "HELO
	outbound-mail-27.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751830AbZIHTbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:31:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Rc6tj+2OazeILl55MuE86lCGaNcUH68cEgYHJgM+vcfr/UOqp8NU4DzVTxgsw5cXY9iKDS7oKCF/SS7ImTmFyr+0XQqY2D0isCZvdrKAzlxfYUl8vK6nzthCExeBzh0j;
Date: Tue, 8 Sep 2009 12:31:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
Subject: Re: [Bug #13819] system freeze when switching to console
Message-ID: <20090908123151.1f2b18fe@jbarnes-g45>
In-Reply-To: <alpine.LFD.2.01.0909081219130.7458@localhost.localdomain>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
	<Vm51Upp4EV.A.r-D.mgBpKB@chimera>
	<1252427375.14735.130.camel@rc-desk>
	<alpine.LFD.2.01.0909080943030.7458@localhost.localdomain>
	<1252431375.14735.139.camel@rc-desk>
	<alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
	<20090908112014.002a35af@jbarnes-g45>
	<alpine.LFD.2.01.0909081219130.7458@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009 12:26:45 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 8 Sep 2009, Jesse Barnes wrote:
> > 
> > Theoretically i915_gem_idle should prevent any user interrupts from
> > coming in.
> 
> That is _entirely_ immaterial.
> 
> The thing is, interrupts can be shared. So it does not matter ONE
> WHIT that you are trying to idle the hardware - there may be _other_
> hardware in the machine that is not idle, and that raises the same
> shared interrupt. End result: the irq handler will be called, whether
> your particular hardware is idle or not.

Which is fine.  We can handle interrupts in the shared case.  It's
specific IRQ statuses we can't handle.  E.g. if we've explicitly turned
off vblank events we definitely won't expect to see them in the handler
(assuming we've taken care to barrier things like you mention below).

> So if you tear down data structures that the interrupt handler needs,
> you _ABSOLUTELY_ must first unregister the whole interrupt.
> 
> Also, even if there are no shared interrupts or any other devices,
> there can easily be old pending interrupts still queued up on
> IO-APIC's etc. So even though you quiesce the hardware, there is no
> guarantee that there aren't some pending interrupts that happened
> just before you turned off the interrupt from the hardware side, and
> are still "en route" to the CPU.

The way we barrier things should handle that case.

> Which gets us exactly the same rule as if there were shared
> interrupts: if your interrupt handler depends on some data structure,
> you must tear down the interrupt handler _before_ you tear down the
> data structures it depends on (and in the reverse order when setting
> things up, of course).
> 
> > If we uninstall the IRQ first we i915_gem_idle probably
> > won't work anymore, since it queues an interrupt and waits for it.
> 
> So then you'd better fix that. Because the code as is is very 
> fundamentally buggy.
> 
> > Eric, any thoughts on this?  We shouldn't be racing to queue new
> > work after the idle call since we suspend GEM at that point, so we
> > must be failing to manage our active lists properly somehow?
> 
> See my previous email. The bug is that you do
> 
>   i915_gem_cleanup_ringbuffer ->
>     i915_gem_cleanup_hws ->
>       dev_priv->hw_status_page = NULL;
> 
> while interrupts are still enabled and coming in. And the interrupt
> path wants to access that hw_status_page. Which you just destroyed.

Yeah, saw that.  I don't think that's the root cause though.  If we see
a user interrupt after gem_idle is called we may have serious issues in
our command handling code.

-- 
Jesse Barnes, Intel Open Source Technology Center
