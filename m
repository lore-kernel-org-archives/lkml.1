Return-Path: <linux-kernel-owner+w=401wt.eu-S1751262AbZIHSUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbZIHSUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZIHSUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:20:16 -0400
Received: from outbound-mail-27.bluehost.com ([69.89.17.193]:38515 "HELO
	outbound-mail-27.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752090AbZIHSUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:20:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DJf4Ezg7Cz69Q0lpRJbD48/vgHDK5kszvPPi+WZogPijTroywTARnhn+z9chw4v0byy3VI30nd9hyseN9lERjc2TujXKblPvjXPaNq++QEcw40z4WPFyaR7Oee5xMb4a;
Date: Tue, 8 Sep 2009 11:20:14 -0700
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
Message-ID: <20090908112014.002a35af@jbarnes-g45>
In-Reply-To: <alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>
	<Vm51Upp4EV.A.r-D.mgBpKB@chimera>
	<1252427375.14735.130.camel@rc-desk>
	<alpine.LFD.2.01.0909080943030.7458@localhost.localdomain>
	<1252431375.14735.139.camel@rc-desk>
	<alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009 11:06:21 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 8 Sep 2009, reinette chatre wrote:
> > 
> > As you can see from the kernel version it is not a build of a
> > vanilla kernel. It only contains changes related to the wireless
> > networking work I am doing.
> > 
> > Here is the output:
> 
> Thanks, this is great. It pinpoints the problem very effectively.
> 
> > [  352.803960] BUG: unable to handle kernel NULL pointer
> > dereference at 0000000000000084 [  352.804006] IP:
> > [<ffffffffa03ecaab>] i915_driver_irq_handler+0x26b/0xd20 [i915]
> 
> The code here is
> 
> 	  16:	48 8b 80 00 01 00 00 	mov
> 0x100(%rax),%rax 1d:	48 8b 50 08          	mov
> 0x8(%rax),%rdx 21:	48 85 d2             	test
> %rdx,%rdx 24:	74 11                	je     0x37
> 	  26:	49 8b 44 24 78       	mov
> 0x78(%r12),%rax 2b:*	8b 80 84 00 00 00    	mov
> 0x84(%rax),%eax     <-- trapping instruction 31:	89 82 08 08
> 00 00    	mov    %eax,0x808(%rdx) 37:	f6 45 a0
> 02          	testb  $0x2,-0x60(%rbp)
> 
> and that "testb $0x2, -0x60(%rbp)" seems to be the
> 
> 	if (iir & I915_USER_INTERRUPT) {
> 
> test if I'm reading things right. Although it could also be the
> 
> 	if (eir & I915_ERROR_MEMORY_REFRESH) {
> 
> thing. The disassembly is totally impossible to read, because the
> stupid i915 driver is chock-full of crap like
> 
> 	if (IS_G4X(dev)) {
> 		..
> 
> which expands to insane amounts of code that check the PCI ID's one
> by one.
> 
> Intel guys: could you _please_ stop doing that. Create a capability
> mask in the device or something, so that you can test for "is this a
> G4x" with a single bit test, rather than have code like this:
> 
>         mov    0x31c(%rsi),%eax
>         cmp    $0x2982,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x2972,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x2992,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x29a2,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x2a02,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x2a12,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x2a42,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x2e02,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x2e12,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x2e22,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x2e32,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
>         cmp    $0x42,%eax
>         je     0xffffffff8124b669 <i915_driver_irq_handler+177>
> 
> for that IS_G4X() thing (I'm not kidding - that's exactly a hundred
> bytes of code for that _stupid_ test, and it's inlined!)

Yeah things are getting a bit out of hand there...  We've moved to
feature tests for some things, but they're still PCI ID based; however
they should be easy to convert.

> 
> Anyway, we're getting that DRM irq, and it has a normal IRQ stack
> trace:
> 
> > [  352.804006] Process Xorg (pid: 4424, threadinfo
> > ffff8800b6b1a000, task ffff880037373c00) [  352.804006] Call Trace:
> > [  352.804006]  <IRQ> 
> > [  352.804006]  [<ffffffff8106db7d>] ? mark_held_locks+0x6d/0x90
> > [  352.804006]  [<ffffffff81098ee8>] handle_IRQ_event+0x68/0x170
> > [  352.804006]  [<ffffffff8109ac01>] handle_edge_irq+0xc1/0x160
> > [  352.804006]  [<ffffffff8100e76f>] handle_irq+0x1f/0x30
> > [  352.804006]  [<ffffffff8100dc6a>] do_IRQ+0x6a/0xf0
> > [  352.804006]  [<ffffffff8100c793>] ret_from_intr+0x0/0xf
> 
> .. but it happened just as we're tearing down the DRM irq handling:
> 
> > [  352.804006]  <EOI> 
> > [  352.804006]  [<ffffffff81070b88>] ? lock_acquire+0xe8/0x100
> > [  352.804006]  [<ffffffffa03c0b85>] ? drm_irq_uninstall+0x65/0x180
> > [drm] [  352.804006]  [<ffffffff8132d7b5>] ?
> > mutex_lock_nested+0x45/0x320 [  352.804006]  [<ffffffffa03c0b85>] ?
> > drm_irq_uninstall+0x65/0x180 [drm] [  352.804006]
> > [<ffffffff8106de85>] ? trace_hardirqs_on_caller+0x145/0x190
> > [  352.804006]  [<ffffffff8106dedd>] ? trace_hardirqs_on+0xd/0x10
> > [  352.804006]  [<ffffffffa03c0b85>] ? drm_irq_uninstall+0x65/0x180
> > [drm] [  352.804006]  [<ffffffffa03f3335>] ?
> > i915_gem_idle+0x225/0x330 [i915] [  352.804006]
> > [<ffffffffa03f34c7>] ? i915_gem_leavevt_ioctl+0x37/0x50 [i915]
> > [  352.804006]  [<ffffffffa03bdafd>] ? drm_ioctl+0x17d/0x3c0 [drm]
> > [  352.804006]  [<ffffffffa03f3490>] ?
> > i915_gem_leavevt_ioctl+0x0/0x50 [i915]
> 
> so what is going on is that the i915 driver has obviously torn down
> some state before it uninstalls the irq, so the irq happens when the
> state has already been torn down, and the irq handler is not ready
> for that.
> 
> This patch *may* fix it - simply by getting rid of the irq early.
> However, I did not check whether maybe something in i915_gem_idle()
> actually needs the interrupt to be able to happen, so this is TOTALLY
> UNTESTED!
> 
> 		Linus
> ---
>  drivers/gpu/drm/i915/i915_gem.c |    6 +-----
>  1 files changed, 1 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c
> b/drivers/gpu/drm/i915/i915_gem.c index 7edb5b9..80e5ba4 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -4232,15 +4232,11 @@ int
>  i915_gem_leavevt_ioctl(struct drm_device *dev, void *data,
>  		       struct drm_file *file_priv)
>  {
> -	int ret;
> -
>  	if (drm_core_check_feature(dev, DRIVER_MODESET))
>  		return 0;
>  
> -	ret = i915_gem_idle(dev);
>  	drm_irq_uninstall(dev);
> -
> -	return ret;
> +	return i915_gem_idle(dev);
>  }

Theoretically i915_gem_idle should prevent any user interrupts from
coming in.  If we uninstall the IRQ first we i915_gem_idle probably
won't work anymore, since it queues an interrupt and waits for it.

Eric, any thoughts on this?  We shouldn't be racing to queue new work
after the idle call since we suspend GEM at that point, so we must be
failing to manage our active lists properly somehow?

-- 
Jesse Barnes, Intel Open Source Technology Center
