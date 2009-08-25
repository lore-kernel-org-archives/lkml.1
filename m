Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbZHYJZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbZHYJZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZHYJZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:25:52 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:48379 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754445AbZHYJZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:25:51 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory  (f6f6e1a4), by kmemleak's scan_block()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1251191755.26351.4.camel@penberg-laptop>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <20090825083222.GC17692@elte.hu> <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop>
	 <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
	 <1251191478.15678.14.camel@pc1117.cambridge.arm.com>
	 <1251191755.26351.4.camel@penberg-laptop>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 25 Aug 2009 10:25:40 +0100
Message-Id: <1251192340.15678.27.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Aug 2009 09:25:41.0500 (UTC) FILETIME=[03DA23C0:01CA2566]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 12:15 +0300, Pekka Enberg wrote:
> On Tue, 2009-08-25 at 10:11 +0100, Catalin Marinas wrote:
> > Yes, that's possible.
> > 
> > Does kmemcheck work on a page-range basis. If an object doesn't cross
> > page boundaries, would it be considered fully initialised after writing
> > a single location?
> > 
> > > I think it would be better to ask kmemcheck on a per-pointer basis
> > > (i.e. for each pointer-sized word in the object), whether it is
> > > initialized or not.
> > 
> > This should work but how expensive is this check?
> 
> Everything in kmemcheck is expensive :-). kmemcheck_shadow_lookup()
> needs to do PTE lookup to find the shadow page where we record object
> states. I'm not sure why that's a problem, though. If you've enabled
> kmemcheck, everything is already dead slow and kmemleak scanning happens
> in background, no? 

It happens in background but the scan_block() function is called, in
most cases, with interrupts disabled and a spinlock held (to avoid the
object being freed during scanning). In my kmemleak branch, queued for
the next merging window, there are patches to allow rescheduling during
object scanning (by releasing the lock temporarily), so it shouldn't be
a problem.

-- 
Catalin

