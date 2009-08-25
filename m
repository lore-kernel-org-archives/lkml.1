Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614AbZHYJL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbZHYJL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 05:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZHYJLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 05:11:25 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47384 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636AbZHYJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 05:11:24 -0400
Subject: Re: WARNING: kmemcheck: Caught 32-bit read from uninitialized
	memory  (f6f6e1a4), by kmemleak's scan_block()
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
References: <20090825071959.GA25877@elte.hu>
	 <19f34abd0908250104y6e877545y485a2104c2b97cfd@mail.gmail.com>
	 <20090825083222.GC17692@elte.hu> <1251189914.7261.11.camel@penberg-laptop>
	 <20090825084808.GA14003@elte.hu> <1251190466.7261.12.camel@penberg-laptop>
	 <19f34abd0908250203h52257f52v306545a3d8890577@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 25 Aug 2009 10:11:18 +0100
Message-Id: <1251191478.15678.14.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Aug 2009 09:11:19.0308 (UTC) FILETIME=[01F214C0:01CA2564]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 11:03 +0200, Vegard Nossum wrote:
> 2009/8/25 Pekka Enberg <penberg@cs.helsinki.fi>:
> > diff --git a/arch/x86/mm/kmemcheck/kmemcheck.c b/arch/x86/mm/kmemcheck/kmemcheck.c
> > index 2c55ed0..528bf95 100644
> > --- a/arch/x86/mm/kmemcheck/kmemcheck.c
> > +++ b/arch/x86/mm/kmemcheck/kmemcheck.c
> > @@ -331,6 +331,20 @@ static void kmemcheck_read_strict(struct pt_regs *regs,
> >        kmemcheck_shadow_set(shadow, size);
> >  }
> >
> > +bool kmemcheck_is_obj_initialized(unsigned long addr, size_t size)
> > +{
> > +       enum kmemcheck_shadow status;
> > +       void *shadow;
> > +
> > +       shadow = kmemcheck_shadow_lookup(addr);
> > +       if (!shadow)
> > +               return true;
> > +
> > +       status = kmemcheck_shadow_test(shadow, size);
> > +
> > +       return status == KMEMCHECK_SHADOW_INITIALIZED;
> > +}
[...]
> I don't know so much about the kmemleak internals, but this I can say
> about the kmemcheck part: According to your definition, an object is
> initialized if all the bytes of an object are initialized.
> 
> Is it possible that because of this, if we have a partially
> uninitialized object, kmemleak will not record the pointers found in
> that object? If so, it might skip valid pointers, and deem an object
> unreferenced. Which could make kmemleak give false-positives.

Yes, that's possible.

Does kmemcheck work on a page-range basis. If an object doesn't cross
page boundaries, would it be considered fully initialised after writing
a single location?

> I think it would be better to ask kmemcheck on a per-pointer basis
> (i.e. for each pointer-sized word in the object), whether it is
> initialized or not.

This should work but how expensive is this check?

-- 
Catalin

