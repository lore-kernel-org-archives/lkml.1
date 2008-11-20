Return-Path: <linux-kernel-owner+w=401wt.eu-S1756707AbYKTQsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbYKTQsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 11:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbYKTQs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 11:48:26 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:56240 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYKTQsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 11:48:25 -0500
Date: Thu, 20 Nov 2008 10:47:24 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] Allocate module.ref array dynamically
In-Reply-To: <200811161030.34054.rusty@rustcorp.com.au>
Message-ID: <Pine.LNX.4.64.0811201038580.19948@quilx.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811141019.49493.rusty@rustcorp.com.au>
 <Pine.LNX.4.64.0811131759250.7010@quilx.com> <200811161030.34054.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008, Rusty Russell wrote:

> > And other flags can become necessary if percpu areas gain the ability of
> > being dynamically extended.
>
> And other flags become impossible, eg. GFP_ATOMIC.

There are other flags that may become relevant like GFP_THISNODE, reclaim
settings (counter allocation from filesystem context) etc.

> The strange indirection was from someone's failed experiment at only
> allocating only online cpus.  We should kill that as a separate patch.

I fully agree.

> There are several seperate things here (this is to make sure my head is
> straight and to clarify for others skimming):
>
> 1) Make the dynamic percpu allocator use the static percpu system.
>    - Agreed, always the aim, never quite happened.

Ack.

> 2) Make zeroing optional
>    - Disagree, adds API complexity for corner case with no gain.  Using
>      gfp_t for it is even worse, since it implies GFP_ATOMIC is valid or
>      sensible.

It does not imply that. Various allocations limit the type of flags that
can be passed. Also there may be situations in which GFP_ATOMIC will make
sense in the future f.e. if a percpu counter structure has to be allocated
from an interrupt context.

GFP_FS, GFP_IO, GFP_NOFAIL GFP_ZERO GFP_NOMEMALLOC GFP_THISNODE and
GFP_HARDWALL could all be relevant for a dynamically extending percpu
allocator since memory reclaim could be triggered.

> 3) Change API to use CAPS for macros
>    - Strongly disagree, Linus doesn't use CAPS for type-taking macros
>      (list_entry, container_of, min_t), it's ugly, and status-quo wins.

That is the cause for many problems because people assume these can be
handled like a function.

> 4) Get rid of unused "online-only" percpu allocators.
>    - Agree, and will simplify implementation and macro tangle.

Ack.

> 5) Make dynamic percpu var access more efficient.
>    - Agree, obviously.  x86 for the moment, the rest can follow (or not).

Ack.
>
> 6) Use percpu allocations more widely.
>    - Definitely, I have some other patches which use it too.  And makes even
>      more sense once (5) is done.

Ack.

> 7) Make percpu area grow dynamically.
>    - Yes, but a thorny tangle esp. with IA64.  The cmdline hack is probably
>      sufficient meanwhile, and parallels can be drawn with vmalloc.

Allright. Please check with David Miller who wants to allocate thousands
of network interfaces which all need a MIB block.

