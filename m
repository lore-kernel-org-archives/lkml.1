Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbZBCByt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbZBCByt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbZBCByh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:54:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:16431 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbZBCByg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:54:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,368,1231142400"; 
   d="scan'208";a="383378028"
Subject: Re: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down
	Berkeley DB
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
In-Reply-To: <200902031224.20856.nickpiggin@yahoo.com.au>
References: <20090130012315.GB19554@duck.suse.cz>
	 <200902031224.20856.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 09:54:26 +0800
Message-Id: <1233626066.2604.114.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 12:24 +1100, Nick Piggin wrote:
> On Friday 30 January 2009 12:23:15 Jan Kara wrote:
> >   Hi,
> >
> >   today I found that commit 31a12666d8f0c22235297e1c1575f82061480029 (mm:
> > write_cache_pages cyclic fix) slows down operations over Berkeley DB.
> > Without this "fix", I can add 100k entries in about 5 minutes 30s, with
> > that change it takes about 20 minutes.
> >   What is IMO happening is that previously we scanned to the end of file,
> > we left writeback_index at the end of file and went to write next file.
> > With the fix, we wrap around (seek) and after writing some more we go
> > to next file (seek again).
We also found this commit causes about 40~50% regression with iozone mmap-rand-write.
#iozone -B -r 4k -s 64k -s 512m -s 1200m

My machine has 8GB memory.

> Hmm, but isn't that what pdflush has asked for? It is wanting to flush
> some of the dirty data out of this file, and hence it wants to start
> from where it last flushed out and then cycle back and flush more?
> 
> 
> >   Anyway, I think the original semantics of "cyclic" makes more sence, just
> > the name was chosen poorly. What we should do is really scan to the end of
> > file, reset index to start from the beginning next time and go for the next
> > file.
> 
> Well, if we think of a file as containing a set of dirty pages (as it
> appears to the high level mm), rather than a sequence, then behaviour
> of my patch is correct (ie. there should be no distinction between dirty
> pages at different offsets in the file).
> 
> However, clearly there is some problem with that assumption if you're
> seeing a 4x slowdown :P I'd really like to know how it messes up the IO
> patterns. How many files in the BDB workload? Are filesystem blocks
> being allocated at the end of the file while writeout is happening?
> Delayed allocation?
> 
> 
> >   I can write a patch to introduce this semantics but I'd like to hear
> > opinions of other people before I do so.
> 
> I like dirty page cleaning to be offset agnostic as far as possible,
> but I can't argue with numbers like that. Though maybe it would be
> possible to solve it some other way.


