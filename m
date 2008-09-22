Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbYIVPAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbYIVPAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYIVPAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:00:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbYIVPAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:00:08 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0809201649400.13926@blonde.site>
References: <Pine.LNX.4.64.0809201649400.13926@blonde.site> <20080910121217.GA16013@elte.hu> <20080910144812.GB18644@wotan.suse.de> <1221058864.30429.291.camel@twins.programming.kicks-ass.net> <20080910152651.GE18644@wotan.suse.de> <20080911082709.GA14378@elte.hu> <20080914073906.GA6184@elte.hu> <20080914004442.4f8e851f.akpm@linux-foundation.org> <20080914080631.GA10720@elte.hu> <20080914221231.GG27080@wotan.suse.de> <20080917131419.e6b7622e.akpm@linux-foundation.org> <20080918111226.GD29968@elte.hu> <48D2ABFD.3040103@goop.org> <1221772310.4779.29.camel@calx> <1221877119.8533.2.camel@nimitz> 
To: Hugh Dickins <hugh@veritas.com>
Cc: dhowells@redhat.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch] mm: tiny-shmem fix lor, mmap_sem vs i_mutex
Date: Mon, 22 Sep 2008 15:54:09 +0100
Message-ID: <13787.1222095249@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hugh Dickins <hugh@veritas.com> wrote:

> But now looking into it further, I see this is all a red herring,
> your rearrangement is not the significant difference: before that
> there was David Howells' Jan 2006 commit
> b0e15190ead07056ab0c3844a499ff35e66d27cc
> [PATCH] NOMMU: Make SYSV IPC SHM use ramfs facilities on NOMMU
> which is the one which adds do_truncate() into tiny-shmem.c's
> shmem_file_setup() but not into shmem.c's - presumably because
> config SHMEM depends on MMU so it was irrelevant in shmem.c.
>
> *That* is the relevant commit, which introduced the bad i_mutex
> within mmap_sem lock ordering, and it seems that Nick's current
> patch is wrong just to remove that do_truncate(), a significant
> change hidden inside his restoration of the original arrangement.

That would break SYSV IPC SHM under CONFIG_MMU=n conditions.

The truncate is necessary as I explained in my patch:

     (2) ramfs files now need resizing using do_truncate() rather than by
         modifying the inode size directly (see shmem_file_setup()). This
         causes ramfs to attempt to bind a block of pages of sufficient size to
         the inode.

What I didn't belabour in the patch, and perhaps I should have, is that to do
SYSV IPC SHM under NOMMU conditions, it is necessary to allocate a *contiguous*
set of pages - something that ramfs has been taught to do under NOMMU when
truncating a file upwards from zero size.  This makes POSIX SHM on ramfs files
viable also.

David
