Return-Path: <linux-kernel-owner+w=401wt.eu-S1759184AbYEHBfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759184AbYEHBfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbYEHBfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:35:04 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:50618
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbYEHBfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:35:01 -0400
Date: Thu, 8 May 2008 03:34:59 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       steiner@sgi.com, holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
Message-ID: <20080508013459.GS8276@duo.random>
References: <6b384bb988786aa78ef0.1210170958@duo.random> <alpine.LFD.1.10.0805071349200.3024@woody.linux-foundation.org> <20080507212650.GA8276@duo.random> <alpine.LFD.1.10.0805071429170.3024@woody.linux-foundation.org> <20080507222205.GC8276@duo.random> <20080507153103.237ea5b6.akpm@linux-foundation.org> <20080507224406.GI8276@duo.random> <1210202918.1421.20.camel@pasglop> <20080507234521.GN8276@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507234521.GN8276@duo.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for not having completely answered to this. I initially thought
stop_machine could work when you mentioned it, but I don't think it
can even removing xpmem block-inside-mmu-notifier-method requirements.

For stop_machine to solve this (besides being slower and potentially
not more safe as running stop_machine in a loop isn't nice), we'd need
to prevent preemption in between invalidate_range_start/end.

I think there are two ways:

1) add global lock around mm_lock to remove the sorting

2) remove invalidate_range_start/end, nuke mm_lock as consequence of
   it, and replace all three with invalidate_pages issued inside the
   PT lock, one invalidation for each 512 pte_t modified, so
   serialization against get_user_pages becomes trivial but this will
   be not ok at all for SGI as it increases a lot their invalidation
   frequency

For KVM both ways are almost the same.

I'll implement 1 now then we'll see...
