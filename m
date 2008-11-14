Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYKNAVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYKNAVs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 19:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYKNAVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 19:21:40 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:36877 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYKNAVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 19:21:38 -0500
Date: Thu, 13 Nov 2008 18:20:41 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] Allocate module.ref array dynamically
In-Reply-To: <200811141019.49493.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0811131759250.7010@quilx.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811131951.07686.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0811130830210.19293@quilx.com> <200811141019.49493.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2008, Rusty Russell wrote:

> > alloc_percpu() does not allow specifying a GFP mask therefore does not
> > support zeroing and is not extendable for the future.
>
> It is defined to be zeroing.  And it is very unclear that (1) future
> implementations will be able to support GFP_ATOMIC reasonably, and (2) that we
> want people to do that.  If we do, we fix it.

But some uses do not need zeroing. They currently have no choice. And
other flags can become necessary if percpu areas gain the ability of
being dynamically extended. Zeroing percpu areas on systems with
lots of cpus can take awhile in particular since these areas may be on
remote nodes.

> > It does not allow
> > specifying an alignment therefore tight packing is not possible.
>
> It absolutely does.  That's why it takes a type!

alloc_percpu is based on __alloc_percpu which currently does not take an
alignment. Guess we could get there by removing the intermediate
functions and making alloc_percpu call cpu_alloc.

However, there are only a few places that use allocpercpu and all of
those are touched by necesssity by the full cpu alloc patchset. At mininum
we need to add the allocation flags and add cpu ops as well as review the
preemption at each call site etcin order to use the correct
call. So why bother with the old API?

> > CPU_PTR and THIS_CPU can be applied both to percpu pointers and
> > percpu variables. The new API unifies the handling which is required in
> > order for the new cpu_ops to work both on statically and dynamically
> > allocated percpu data.
>
> And if you called them per_cpu_ptr and __get_cpu_ptr they would have these
> same properties.  But now the names would be consistent.

Having macros that do type casting on results and do macro operations on
parameters look like functions does not seem to be right. We can make it
consistent at the end by renaming the remaining ones.

Having an uppercase CPU_PTR and such in the source clarifies
that something special is going on. This is consistent with other
uses in the kernel. This is CPP magic after all (see examples in
include/linux/kernel.h or slab.h f.e.)
