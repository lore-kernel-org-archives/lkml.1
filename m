Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZFYV06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZFYV06 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 17:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZFYV0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 17:26:49 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:40057 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbZFYV0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 17:26:48 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Date: Thu, 25 Jun 2009 23:26:28 +0200
From: Andreas Dilger <adilger@sun.com>
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-reply-to: <20090625203743.GD6472@mit.edu>
To: Theodore Tso <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de, linux-ext4@vger.kernel.org
Message-id: <20090625212628.GO3385@webber.adilger.int>
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20090624130121.99321cca.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241312090.3154@localhost.localdomain>
 <alpine.LFD.2.01.0906241334260.3154@localhost.localdomain>
 <20090624150714.c7264768.akpm@linux-foundation.org>
 <20090625132544.GB9995@mit.edu>
 <alpine.DEB.2.00.0906251135440.30090@chino.kir.corp.google.com>
 <20090625193806.GA6472@mit.edu> <20090625194423.GB6472@mit.edu>
 <alpine.DEB.2.00.0906251257040.3086@chino.kir.corp.google.com>
 <20090625203743.GD6472@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 25, 2009  16:37 -0400, Theodore Ts'o wrote:
> On Thu, Jun 25, 2009 at 01:18:59PM -0700, David Rientjes wrote:
> > Isn't there also a problem in jbd2_journal_write_metadata_buffer(), 
> > though?
> > 
> > 		tmp = jbd2_alloc(bh_in->b_size, GFP_NOFS);
> 		...
> > 		memcpy(tmp, mapped_data + new_offset, jh2bh(jh_in)->b_size);
> > 
> > jbd2_alloc() is just a wrapper to __get_free_pages() and if it fails, it 
> > appears as though the memcpy() would cause a NULL pointer.
> 
> Nicely spotted.  Yeah, that's a bug; we need to do something about
> that one, too.

IIRC, in the past, jbd_alloc() had a retry mechanism that would loop
indefinitely for some allocations, because they couldn't be aborted
easily.  This was removed for some reason, I'm not sure why.

> And what we're doing is a bit silly; it may make sense
> to use __get_free_pages if filesystem blocksize == PAGE_SIZE, but
> otherwise we should be using a sub-page allocator.  Right now, we're
> chewing up a 16k PPC page for every 4k filesystem metadata page
> allocated in journal_write_metadata_buffer(), and on x86, for the
> (admittedly uncommon) 1k block filesystem, we'd be chewing up a 4k
> page for a 1k block buffer.

IIRC there was also a good reason for this in the past, related to
the buffers being submitted to the block device layer, and if they
were allocated from the slab cache with CONFIG_DEBUG_SLAB or something
similar enabled the buffer would be misaligned and cause grief.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

