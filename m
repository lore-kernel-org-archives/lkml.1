Return-Path: <linux-kernel-owner+w=401wt.eu-S1761334AbZCXOQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761334AbZCXOQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757963AbZCXOH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:07:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758256AbZCXOHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:07:25 -0400
Date: Tue, 24 Mar 2009 15:07:21 +0100
From: Jan Kara <jack@suse.cz>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Nick Piggin <nickpiggin@yahoo.com.au>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
       Ying Han <yinghan@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Message-ID: <20090324140720.GE23439@duck.suse.cz>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <200903200248.22623.nickpiggin@yahoo.com.au> <20090319164638.GB3899@duck.suse.cz> <200903241844.22851.nickpiggin@yahoo.com.au> <20090324123935.GD23439@duck.suse.cz> <20090324125510.GA9434@duck.suse.cz> <20090324132637.GA14607@duck.suse.cz> <1237903305.17910.4.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237903305.17910.4.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 24-03-09 10:01:45, Chris Mason wrote:
> On Tue, 2009-03-24 at 14:26 +0100, Jan Kara wrote:
> > On Tue 24-03-09 13:55:10, Jan Kara wrote:
> 
> > >   And one more interesting thing I don't yet fully understand - I see pages
> > > having PageError() set when they are removed from page cache (and they have
> > > been faulted in before). It's probably some interaction with pagecache
> > > readahead...
> >   Argh... So the problem seems to be that get_block() occasionally returns
> > ENOSPC and we then discard the dirty data (hmm, we could give at least a
> > warning for that). I'm not yet sure why getblock behaves like this because
> > the filesystem seems to have enough space but anyway this seems to be some
> > strange fs trouble as well.
> > 
> 
> Ouch.  Perhaps the free space is waiting on a journal commit?
  Yes, exactly. I've already found there's lot of space hold by the
committing transaction (it can easily hold a few hundred megs or a few gigs
with larger journal and my UML images aren't that big...). And writepage()
implementation in ext3 does not have a logic to retry. Also
block_write_full_page() clears buffers dirty bits so it's not easy to retry
even if we did it. I'm now looking into how to fix this...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
