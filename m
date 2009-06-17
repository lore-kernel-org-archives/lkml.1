Return-Path: <linux-kernel-owner+w=401wt.eu-S933271AbZFQNYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271AbZFQNYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 09:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbZFQNYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 09:24:11 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:56563 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904AbZFQNYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 09:24:10 -0400
Subject: Re: [PATCH] kmemleak: Only use GFP_KERNEL|GFP_ATOMIC for the
	internal  allocations
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <84144f020906170601l254d3b29udc688d02426ea247@mail.gmail.com>
References: <200906162232.n5GMWRZe026963@imap1.linux-foundation.org>
	 <20090616223649.719ea378.akpm@linux-foundation.org>
	 <20090617111800.GA15261@elte.hu> <20090617113120.GA5061@elte.hu>
	 <1245240677.11889.17.camel@pc1117.cambridge.arm.com>
	 <20090617122803.GD28529@csn.ul.ie>
	 <1245242160.11889.23.camel@pc1117.cambridge.arm.com>
	 <20090617124034.GE28529@csn.ul.ie>
	 <1245243130.11889.27.camel@pc1117.cambridge.arm.com>
	 <84144f020906170601l254d3b29udc688d02426ea247@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 17 Jun 2009 14:23:27 +0100
Message-Id: <1245245007.11889.42.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2009 13:23:28.0789 (UTC) FILETIME=[CD50EC50:01C9EF4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 16:01 +0300, Pekka Enberg wrote:
> On Wed, Jun 17, 2009 at 3:52 PM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> > Kmemleak allocates memory for pointer tracking and it tries to avoid
> > using GFP_ATOMIC if the caller doesn't require it. However other gfp
> > flags may be passed by the caller which aren't required by kmemleak.
> > This patch filters the gfp flags so that only GFP_KERNEL | GFP_ATOMIC
> > are used.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> Is this really safe? What if we're in a middle of a filesystem
> operation that uses GFP_NOFAIL and all of a sudden kmemleak allocation
> fails and causes a panic?

A kmemleak_panic() call only disables the kmemleak but doesn't stop the
kernel. The __GFP_NOFAIL allocation had already happened and the pointer
returned to the caller.

If we pass the __GFP_NOFAIL flag via the kmemleak's alloc, we get the
warning reported by Ingo (though it's not clear to me why this happens
as a kmemleak_object cache allocation is 192 bytes on a 32 bit machine).

Are there (common) situations where we expect kmemleak's alloc to fail
without __GFP_NOFAIL?

-- 
Catalin

