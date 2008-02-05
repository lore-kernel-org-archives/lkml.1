Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbYBEOkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbYBEOkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 09:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbYBEOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 09:39:52 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:55015 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYBEOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 09:39:51 -0500
Subject: Re: [patch 2/3] CONFIG_HIGHPTE vs. sub-page page tables.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080204025133.511ac3e2.akpm@linux-foundation.org>
References: <20071112143009.425807965@de.ibm.com>
	 <20071112144009.831296895@de.ibm.com>
	 <20080201151541.8e3e0359.akpm@linux-foundation.org>
	 <1202017020.7208.2.camel@pasglop>
	 <20080202215315.3ac6907d.akpm@linux-foundation.org>
	 <1202121409.31801.7.camel@localhost>
	 <20080204025133.511ac3e2.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 05 Feb 2008 15:39:47 +0100
Message-Id: <1202222388.25021.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-04 at 02:51 -0800, Andrew Morton wrote:
> > > Look: I can't fix *everyone's* stuff.  This was a consequence of ongoing
> > > unbounded churn in the x86 tree.  If we can find a way of preventing those
> > > guys (and everyone else) from trashing everyone else's stuff then we'd have
> > > much smoother sailing.
> > 
> > Understood. That is where I jump in and regenerate my patches on the
> > latest available level. That the patches did hold up for some months in
> > -mm now without really breaking anything is an indication that we can
> > push them upstream now, isn't ? That would make the patch problem go
> > away and I could queue my s390 specific page table rework. Our KVM
> > people keep asking about it.
> 
> yes, against 2.6.24-mm1 would be good, thanks.  I really don't know what
> went wrong in i386 but I ended up getting all grumpy at the macro mess
> we've made in all the pagetable handling.  Please do take a look at
> improving that.

I'm trying to replace the __pte_free_tlb macros my patch touches for the
different architectures. Not much luck yet, there is a reason why
__pte_free_tlb is a macro in the first place: welcome to #include hell.
I'm starting to get grumpy as well..

Just an example for x86-64:
* asm-x86/tlb.h includes asm-generic/tlb.h
* asm-generic/tlb.h includes asm-x86/pgalloc.h
* asm-x86/pgalloc.h includes asm-x86/pgalloc_64.h
* asm-x86/pgalloc_64.h includes asm-x86/tlb.h
* since asm-x86/tlb.h started this #include chain it expands to nothing
* asm-x86/pgalloc_64.h calls tlb_remove_page which is defined in
  asm-x86/tlb.h but the compiler hasn't seen the definition yet
* you loose..

I got x86-64 compiled by removing the #include <asm/pgalloc.h> from
asm-generic/tlb.h. But who knows what will break if the include is
missing .. I'll cross compile some of the other architectures next.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


