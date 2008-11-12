Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbYKLWv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbYKLWv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:51:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbYKLWvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:51:16 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:44391 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754AbYKLWvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:51:16 -0500
Date: Wed, 12 Nov 2008 16:50:46 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] Allocate module.ref array dynamically
In-Reply-To: <200811130831.11499.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0811121630390.2379@quilx.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811122029.24482.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0811121408290.31606@quilx.com> <200811130831.11499.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Rusty Russell wrote:

> > > You've introduced a third set of per-cpu primitives, yet the second set
> > > still has 0 users.
> >
> > What second set?
>
> percpu_alloc().

That is a variant of allocpercpu. We have thinned the allocpercpu API
somewhat already. I can drop more portions or I can drop it completely at
the very end of the patchset.

> > cpu. The difference between THIS_CPU and __THIS_CPU is the context check
> > by smp_processor_id()
>
> Thanks, I figured that out, but it's not documented.  I'll happily create a
> patch, but see below.  BTW, did you end up using __THIS_CPU anywhere?

Yes in later patches. This is a total set of 40 or so patches.

> > The caps functions are macros not functions. Macros are
> > capitalized.
>
> Traditionally, yes, but we seem to be more ambivalent in the kernel.
> list_for_each() et. al spring to mind: code would be uglier if we made them
> caps.

Macros being capitalized have a reason: They may do strange things with
the parameters. In particular CPU_ALLOC/CPU_FREE do a determination of
the size of the type. The macros do not take an argument in the
traditional sense. Frankly alloc_percpu(type) is something that looks not
right to me.

> > alloc_percpu must stay until the last remains have been
> > evicted.
>
> OK, you anticipate replacement of all alloc_percpu users?

Yes. If you look at the full patchsets that were posted at various times
during the last year you see that allocpercpu will be gone.

> > And the API does work differently.
>
> I'm afraid the difference has escaped me so far.  Please explain why you can't
> use the current API.  Is this subtle difference going to make the transition
> difficult?

The old api was based on an attempt to introduce a cpu mask. That mask was
never used. See percpu_alloc_mask. The handling is not consistent with the
nature of the percpu sections for other percpu data because allocation is
only done for online processors. So we have semantic differences. The API
is inconsistent and underwent rot. Having to allocate percpu sections if
processors are onlined and offlined causes the need for more hooks. The
cpu alloc patchset gets rid of about half the hooks in the page allocator
and slab allocator.
