Return-Path: <linux-kernel-owner+w=401wt.eu-S1752419AbZHYIbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbZHYIbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZHYIbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:31:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53771 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZHYIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:31:44 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
 memory  (f6f6e1a4), by kmemleak's scan_block()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1251188859.15678.6.camel@pc1117.cambridge.arm.com>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <1251187716.7261.2.camel@penberg-laptop>
	 <1251188859.15678.6.camel@pc1117.cambridge.arm.com>
Date: Tue, 25 Aug 2009 11:31:45 +0300
Message-Id: <1251189105.7261.4.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 09:27 +0100, Catalin Marinas wrote:
> On Tue, 2009-08-25 at 11:08 +0300, Pekka Enberg wrote:
> > On Tue, 2009-08-25 at 10:04 +0200, Vegard Nossum wrote:
> > > 2009/8/25 Ingo Molnar <mingo@elte.hu>:
> > > > FYI, -tip testing triggered the following kmemcheck warning in
> > > > kmemleak:
> > > >
> > > > PM: Adding info for No Bus:vcsa7
> > > > WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6f6e1a4)
> > > > d873f9f600000000c42ae4c1005c87f70000000070665f666978656400000000
> > > >  i i i i u u u u i i i i i i i i i i i i i i i i i i i i i u u u
> [...]
> > > Already the patch to make kmemcheck and kmemleak mutually exclusive is
> > > underway. It is not surprising that kmemleak is scanning uninitialized
> > > memory. But if you say that you have tried it before, it is strange
> > > that it didn't appear until now.
> > 
> > Why isn't it surprising? Yes, it's non-fatal for kmemleak to scan
> > uninitialized memory but we could be looking at non-initialized struct
> > member that's a bug waiting to happen elsewhere in the code (that
> > doesn't trigger often).
> 
> It isn't surprising to me either. Kmemleak scans the memory periodically
> but it cannot know whether such memory was initialised or not to avoid
> scanning it. So I would expect such warnings if both kmemleak and
> kmemcheck are enabled. Scanning uninitialised memory is fine with
> kmemleak, it just increases the number of false negatives (with
> SLAB_DEBUG enabled, however, the allocated blocks are pre-initialised).
> 
> So kmemleak and kmemcheck should be exclusive, unless there is a way for
> kmemleak to validate an address with kmemcheck before deciding whether
> to scan a memory block.

It's possible. Look at the kmemcheck_shadow_lookup() and
kmemcheck_shadow_test() calls in kmemcheck_read_strict(), for example.

Vegard, what do you think? I think making kmemcheck and kmemleak play
nice with each other is useful for people like Ingo who do automated
testing.

			Pekka

