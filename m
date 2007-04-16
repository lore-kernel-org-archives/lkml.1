Return-Path: <linux-kernel-owner+w=401wt.eu-S1030868AbXDPQcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030868AbXDPQcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 12:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030874AbXDPQcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 12:32:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030871AbXDPQcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 12:32:23 -0400
Date: Mon, 16 Apr 2007 12:30:57 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: Rik van Riel <riel@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] make MADV_FREE lazily free memory
Message-ID: <20070416163057.GH355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <461C6452.1000706@redhat.com> <461D6413.6050605@cosmosbay.com> <461D67A9.5020509@redhat.com> <461DC75B.8040200@cosmosbay.com> <461DCCEB.70004@yahoo.com.au> <461DCDDA.2030502@yahoo.com.au> <461DDE44.2040409@redhat.com> <20070416161039.GA979@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416161039.GA979@kryten>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 11:10:39AM -0500, Anton Blanchard wrote:
> > Making the pte clean also needs to clear the hardware writable
> > bit on architectures where we do pte dirtying in software.
> > 
> > If we don't, we would have corruption problems all over the VM,
> > for example in the code around pte_clean_one :)
> > 
> > >But as Linus recently said, even hardware handled faults still
> > >take expensive microarchitectural traps.
> > 
> > Nowhere near as expensive as a full page fault, though...
> 
> Unfortunately it will be expensive on architectures that have software
> referenced and changed. It would be great if we could just leave them
> dirty in the pagetables and transition between a clean and dirty state
> via madvise calls, but thats just wishful thinking on my part :)

That would mean an additional syscall.  Furthermore, if you allocate a big
chunk of memory, dirty it, then free (with madvise (MADV_FREE)) it and soon
allocate the same size of memory again, it is better to start that with
non-dirty memory, it might be that this time you e.g. don't modify a big
part of the chunk.  If all that memory was kept dirty all the time and
just marked/unmarked for lazy reuse with MADV_FREE/MADV_UNDO_FREE, all that
memory would need to be saved to disk when paging out as it was marked
dirty, while with current Rik's MADV_FREE that will happen only for pages
that were actually dirtied after the last malloc.

	Jakub
