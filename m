Return-Path: <linux-kernel-owner+w=401wt.eu-S937158AbXGSNqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937158AbXGSNqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757105AbXGSNqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:46:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:48453 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbXGSNqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:46:13 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: new text patching for review
Date: Thu, 19 Jul 2007 15:46:08 +0200
User-Agent: KMail/1.9.6
Cc: jbeulich@novell.com, "S. P. Prasanna" <prasanna@in.ibm.com>,
       linux-kernel@vger.kernel.org, patches@x86-64.org
References: <200707191105.44056.ak@suse.de> <20070719133852.GA5490@Krystal>
In-Reply-To: <20070719133852.GA5490@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707191546.08919.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Ewwwwwwwwwww.... you plan to run this in SMP ? So you actually go byte
> by byte changing pieces of instructions non atomically and doing
> non-Intel's errata friendly XMC. You are really looking for trouble
> there :) Two distinct errors can occur: 

In this case it is ok because this only happens when transitioning
from 1 CPU to 2 CPUs or vice versa and in both cases the other CPUs
are essentially stopped.

All the other manipulations currently are single byte.

I suppose for your immediate value patches something stronger is needed,
but we can worry about that post .23.

> What I don't like about this particular implementation is that it does
> not support "poking" more than 1 byte. In order to support this, you
> would have to deal with the case where the address range spans over more
> than one page.

I considered it, but the function would have been at least twice as big
to handle all the corner cases. And for the current callers it's all fine.

> Also, doing the copy in the same interface seems a bit awkward.

Splitting it would also seem quite awkward.
 
> 
> I would much prefer something like:
> 
> void *map_shadow_write(void *addr, size_t len);
> (returns a pointer to the shadow writable pages, at the same page offset
> as "addr")
> 
> int unmap_shadow_write(void *shadow_addr, size_t len);
> (unmap the shadow pages)
> 
> Then, the in-kernel user is free to modify their pages as they like.
> Since we cannot foresee each modification pattern, I think that leaving
> this kind of flexibility is useful.

You could as well call vmap directly then; it's not that much
more complicated.  I don't really see much value in complicating
it right now.

-Andi

