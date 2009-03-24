Return-Path: <linux-kernel-owner+w=401wt.eu-S1761513AbZCXPap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbZCXPap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 11:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761378AbZCXPaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 11:30:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761380AbZCXPaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 11:30:04 -0400
Date: Tue, 24 Mar 2009 16:29:59 +0100
From: Jan Kara <jack@suse.cz>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Martin J. Bligh" <mbligh@mbligh.org>, linux-ext4@vger.kernel.org,
       Ying Han <yinghan@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
Message-ID: <20090324152959.GG23439@duck.suse.cz>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com> <20090324125510.GA9434@duck.suse.cz> <20090324132637.GA14607@duck.suse.cz> <200903250130.02485.nickpiggin@yahoo.com.au> <20090324144709.GF23439@duck.suse.cz> <1237906563.24918.184.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237906563.24918.184.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 24-03-09 15:56:03, Peter Zijlstra wrote:
> On Tue, 2009-03-24 at 15:47 +0100, Jan Kara wrote:
> > 
> > Or we could implement ext3_mkwrite() to allocate buffers already when we
> > make page writeable. But it costs some performace (we have to write page
> > full of zeros when allocating those buffers, where previously we didn't
> > have to do anything) and it's not trivial to make it work if pagesize >
> > blocksize (we should not allocate buffers outside of i_size so if i_size
> > = 1024, we create just one block in ext3_mkwrite() but then we need to
> > allocate more when we extend the file).
> 
> I think this is the best option, failing with SIGBUS when we fail to
> allocate blocks seems consistent with other filesystems as well.
  I agree this looks attractive at the first sight. But there are drawbacks
as I wrote - the problem with blocksize < pagesize, slight performance
decrease due to additional write, page faults doing allocation can take a
*long* time and overall fragmentation is going to be higher (previously
writepage wrote pages for us in the right order, now we are going to
allocate in the first-accessed order). So I'm not sure we really want to
go this way.
  Hmm, maybe we could play a trick ala delayed allocation - i.e., reserve
some space in mkwrite() but don't actually allocate it. That would be done
in writepage(). This would solve all the problems I describe above. We could
use PG_Checked flag to track that the page has a reservation and behave
accordingly in writepage() / invalidatepage(). ext3 in data=journal mode
already uses the flag but the use seems to be compatible with what I want
to do now... So it may actually work.
  BTW: Note that there's a plenty of filesystems that don't implement
mkwrite() (e.g. ext2, UDF, VFAT...) and thus have the same problem with
ENOSPC. So I'd not speak too much about consistency ;).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
