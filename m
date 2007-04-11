Return-Path: <linux-kernel-owner+w=401wt.eu-S1030367AbXDKUEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367AbXDKUEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030342AbXDKUEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:04:05 -0400
Received: from kanga.kvack.org ([66.96.29.28]:46340 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030367AbXDKUEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:04:01 -0400
Date: Wed, 11 Apr 2007 16:03:48 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Ken Chen <kenchen@google.com>, akpm@linux-foundation.org,
       linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] convert aio event reap to use atomic-op instead of spin_lock
Message-ID: <20070411200348.GN13621@kvack.org>
References: <20070410235353.325A7346F64@localhost> <20070411180038.GN28322@mami.zabbo.net> <b040c32a0704111228t5065253en9249ff88db5b1384@mail.gmail.com> <20070411194504.GM13621@kvack.org> <20070411195256.GD9602@mami.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070411195256.GD9602@mami.zabbo.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 12:52:56PM -0700, Zach Brown wrote:
> I'm worried that virtual aliasing spells doom for the current
> home-brewed serialization that fs/aio.c is doing with the shared ring
> head/tail accesses.  Am I worrying about nothing here?

Adding a flush_dcache_page() should fix that, but it might also need a 
change in the layout of the ring buffer header to get things completely 
correct.  What I'm thinking of is that the head and tail bits might need 
to be on different cachelines to ensure any aliasing that does occur will 
not result in updates colliding.  I'm not that much of an expert on virtually 
aliased caches, though.

> > > I will look into this aside from this patch.
> > 
> > That's probably the case.  Also, any changes in this area *must* correctly 
> > update the compat/incompat feature flags in the ring buffer header.  That 
> > has been missed in the past...
> 
> Do you know of anyone using the current ring info ABI?
> 
> The *only* user I know of is the check of ctx->magic in libaio.

But... any libaio implementing the new sematics must be able to run on old 
kernels by falling back to the syscall when it notices that required bits 
aren't set in the header.  It's easy enough to implement the checks, they 
just need to be carefully checked before being shipped.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
