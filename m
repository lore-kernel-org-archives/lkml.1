Return-Path: <linux-kernel-owner+w=401wt.eu-S1757132AbZCYX3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132AbZCYX3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752178AbZCYX3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:29:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbZCYX3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:29:23 -0400
Date: Wed, 25 Mar 2009 16:21:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090325215137.GQ32307@mit.edu>
Message-ID: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
References: <20090324091545.758d00f5@lxorguk.ukuu.org.uk> <20090324093245.GA22483@elte.hu> <20090324101011.6555a0b9@lxorguk.ukuu.org.uk> <20090324103111.GA26691@elte.hu> <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz>
 <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Mar 2009, Theodore Tso wrote:
> 
> Um, no, ext3 shouldn't block on writepage().  Since it doesn't do
> delayed allocation, it should always be able to push out a dirty page
> to the disk.

Umm. Maybe I'm mis-reading something, but they seem to all synchronize 
with the journal with "ext3_journal_start/stop".

Which will at a minimum wait for 'j_barrier_count == 0' and 't_state != 
T_LOCKED'. Along with making sure that there are enough transaction 
buffers.

Do I understand _why_ ext3 does that? Hell no. The code makes no sense to 
me. But I don't think I'm wrong.

Look at the sane case (data=ordered): it still does

	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
	...
	err = ext3_journal_stop(handle);

around all the IO starting. Never mind that the IO shouldn't be needing 
any journal activity at all afaik in any common case. 

Yes, yes, it may need to allocate backing store (a page that was dirtied 
by mmap), and I'm sure that's the reason for it all, but the point is, 
most of the time there should be no journal activity at all, yet it looks 
very much like a simple writepage() will synchronize with a full journal 
and wait for the journal to get space.

No?

So tell me again how the VM can rely on the filesystem not blocking at 
random points.

			Linus
