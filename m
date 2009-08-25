Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZHYI1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZHYI1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 04:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbZHYI1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 04:27:49 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:44868 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753947AbZHYI1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 04:27:48 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory  (f6f6e1a4), by kmemleak's scan_block()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1251187716.7261.2.camel@penberg-laptop>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <1251187716.7261.2.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 25 Aug 2009 09:27:39 +0100
Message-Id: <1251188859.15678.6.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Aug 2009 08:27:40.0482 (UTC) FILETIME=[E900F220:01CA255D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 11:08 +0300, Pekka Enberg wrote:
> On Tue, 2009-08-25 at 10:04 +0200, Vegard Nossum wrote:
> > 2009/8/25 Ingo Molnar <mingo@elte.hu>:
> > > FYI, -tip testing triggered the following kmemcheck warning in
> > > kmemleak:
> > >
> > > PM: Adding info for No Bus:vcsa7
> > > WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (f6f6e1a4)
> > > d873f9f600000000c42ae4c1005c87f70000000070665f666978656400000000
> > >  i i i i u u u u i i i i i i i i i i i i i i i i i i i i i u u u
[...]
> > Already the patch to make kmemcheck and kmemleak mutually exclusive is
> > underway. It is not surprising that kmemleak is scanning uninitialized
> > memory. But if you say that you have tried it before, it is strange
> > that it didn't appear until now.
> 
> Why isn't it surprising? Yes, it's non-fatal for kmemleak to scan
> uninitialized memory but we could be looking at non-initialized struct
> member that's a bug waiting to happen elsewhere in the code (that
> doesn't trigger often).

It isn't surprising to me either. Kmemleak scans the memory periodically
but it cannot know whether such memory was initialised or not to avoid
scanning it. So I would expect such warnings if both kmemleak and
kmemcheck are enabled. Scanning uninitialised memory is fine with
kmemleak, it just increases the number of false negatives (with
SLAB_DEBUG enabled, however, the allocated blocks are pre-initialised).

So kmemleak and kmemcheck should be exclusive, unless there is a way for
kmemleak to validate an address with kmemcheck before deciding whether
to scan a memory block.

-- 
Catalin

