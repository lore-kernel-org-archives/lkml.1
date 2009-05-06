Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbZEFNWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbZEFNWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 09:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbZEFNWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 09:22:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45362 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbZEFNWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 09:22:25 -0400
Date: Wed, 6 May 2009 15:17:35 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Izik Eidus <ieidus@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, chrisw@redhat.com,
       alan@lxorguk.ukuu.org.uk, device@lanana.org, linux-mm@kvack.org,
       hugh@veritas.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 2/6] ksm: dont allow overlap memory addresses
	registrations.
Message-ID: <20090506131735.GW16078@random.random>
References: <1241475935-21162-1-git-send-email-ieidus@redhat.com> <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <4A00DD4F.8010101@redhat.com> <4A015C69.7010600@redhat.com> <4A0181EA.3070600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0181EA.3070600@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 08:26:18AM -0400, Rik van Riel wrote:
> The user can break up the underlying VMAs though.
>
> I am just wondering out loud if we really want two
> VMA-like objects in the kernel, the VMA itself and
> a separate KSM object, with different semantics.
>
> Maybe this is fine, but I do think it's a question
> that needs to be thought about.

If we want to keep KVM self contained we need a separate object. If we
want to merge part of KVM into the kernel VM core, then it can use the
vma and use madvise or better its own syscall (usually madvise doesn't
depend on admin starting kernel threads) or similar and the semantics
will change slightly. From a practical point of view I don't think
there's much difference and it can be done later if we change our
mind, given the low amount of apps that uses KVM (but for those few
apps like KVM, KSM can save tons of memory).

For example for the swapping of KSM pages we've been thinking of using
external rmap hooks to avoid the VM to know anything specific to KSM
pages but to still allow their unmapping and swap. Otherwise if there
are other modules like KVM that wants to extend the VM they'll also
have to add their own PG_ bitflags just for allow the swapping of
their own pages in the VM LRUs etc..
