Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbXDMOuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbXDMOuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 10:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbXDMOuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 10:50:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbXDMOub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 10:50:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070413162909.c436a732.dada1@cosmosbay.com> 
References: <20070413162909.c436a732.dada1@cosmosbay.com>  <20070413124303.GD966@wotan.suse.de> <20070413100416.GC31487@wotan.suse.de> <25821.1176466182@redhat.com> <30644.1176471112@redhat.com> 
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] generic rwsems 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 13 Apr 2007 15:49:06 +0100
Message-ID: <31965.1176475746@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> wrote:

> If space considerations are that important, we could then reserve one bit
> for the 'wait_lock spinlock'

That makes life quite a bit more tricky, though it does have the advantage
that it closes the reader-jumping-writer window I mentioned.

> Another possibility to save space would be to move wait_lock/wait_list
> outside of rw_semaphore, in a hashed global array.

I suspect moving wait_list out would be a bad idea.  The ordering of things in
the list is very important.  You need to perform several operations on the
list, all of which would be potentially slower:

 (1) glance at the first element of the list to see what sort of wake up to do

 (2) iteration of the list when waking up multiple readers

 (3) seeing if the list is empty (so you know that there's no more contention)

Moving the spinlock out, on the other hand, might be worth it to cut down on
cacheline bouncing some more...

David
