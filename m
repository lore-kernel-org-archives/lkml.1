Return-Path: <linux-kernel-owner+w=401wt.eu-S1751740AbZIHTT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbZIHTT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZIHTTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:19:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284AbZIHTTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:19:24 -0400
Date: Tue, 8 Sep 2009 12:19:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: reinette chatre <reinette.chatre@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Anholt <eric@anholt.net>, "Ma, Ling" <ling.ma@intel.com>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>
Subject: Re: [Bug #13819] system freeze when switching to console
In-Reply-To: <alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909081209260.7458@localhost.localdomain>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera>  <Vm51Upp4EV.A.r-D.mgBpKB@chimera> <1252427375.14735.130.camel@rc-desk>  <alpine.LFD.2.01.0909080943030.7458@localhost.localdomain> <1252431375.14735.139.camel@rc-desk>
 <alpine.LFD.2.01.0909081039300.7458@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Sep 2009, Linus Torvalds wrote:
> 
> The code here is
> 
> 	  16:	48 8b 80 00 01 00 00 	mov    0x100(%rax),%rax
> 	  1d:	48 8b 50 08          	mov    0x8(%rax),%rdx
> 	  21:	48 85 d2             	test   %rdx,%rdx
> 	  24:	74 11                	je     0x37
> 	  26:	49 8b 44 24 78       	mov    0x78(%r12),%rax
> 	  2b:*	8b 80 84 00 00 00    	mov    0x84(%rax),%eax     <-- trapping instruction
> 	  31:	89 82 08 08 00 00    	mov    %eax,0x808(%rdx)
> 	  37:	f6 45 a0 02          	testb  $0x2,-0x60(%rbp)
> 
> and that "testb $0x2, -0x60(%rbp)" seems to be the
> 
> 	if (iir & I915_USER_INTERRUPT) {

Yeah, that seems to be the right thing.

So the actual faulting instruction is from this:

                if (dev->primary->master) {
                        master_priv = dev->primary->master->driver_priv;
                        if (master_priv->sarea_priv)
                                master_priv->sarea_priv->last_dispatch =
					READ_BREADCRUMB(dev_priv);

and it looks like %rax starts out being 'dev', then the

	mov    0x100(%rax),%rax

means that %rax is now 'dev->primary', and then

	mov    0x8(%rax),%rdx

moves 'dev->primary->master' into %rdx. It's not zero, so we then do that 
READ_BREADCRUMB(dev_priv), which expands to

	READ_HWSP(dev_priv, I915_BREADCRUMB_INDEX)

which in turn is

	(((volatile u32*)(dev_priv->hw_status_page))[reg])

and it looks like dev_priv->hw_status_page is NULL.

You can verify this by looking at teh exception address:

	BUG: unable to handle kernel NULL pointer dereference at 0000000000000084

and that '84' is I915_BREADCRUMB_INDEX*4 (0x21*4).

And the problem seems to be that we've cleared the hw_status_page pointer 
in i915_gem_cleanup_hws():

	dev_priv->hw_status_page = NULL;

and we did that in 

  i915_gem_idle() ->
    i915_gem_cleanup_ringbuffer() ->
      i915_gem_cleanup_hws()

so now since interrupts are still enabled, you'll get a NULL pointer 
dereference.

I think my patch is correct.

		Linus
