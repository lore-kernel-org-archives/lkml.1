Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbZBCR7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbZBCR7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZBCR7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:59:30 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:46044 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbZBCR73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:59:29 -0500
Subject: Re: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down
 Berkeley DB
From: Chris Mason <chris.mason@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
In-Reply-To: <200902031311.02378.nickpiggin@yahoo.com.au>
References: <20090130012315.GB19554@duck.suse.cz>
	 <200902031224.20856.nickpiggin@yahoo.com.au>
	 <1233626066.2604.114.camel@ymzhang>
	 <200902031311.02378.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 11:12:45 -0500
Message-Id: <1233677565.7246.15.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.498885CE.0084:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 13:11 +1100, Nick Piggin wrote:
> On Tuesday 03 February 2009 12:54:26 Zhang, Yanmin wrote:
> > On Tue, 2009-02-03 at 12:24 +1100, Nick Piggin wrote:
> > > On Friday 30 January 2009 12:23:15 Jan Kara wrote:
> > > >   Hi,
> > > >
> > > >   today I found that commit 31a12666d8f0c22235297e1c1575f82061480029
> > > > (mm: write_cache_pages cyclic fix) slows down operations over Berkeley
> > > > DB. Without this "fix", I can add 100k entries in about 5 minutes 30s,
> > > > with that change it takes about 20 minutes.
> > > >   What is IMO happening is that previously we scanned to the end of
> > > > file, we left writeback_index at the end of file and went to write next
> > > > file. With the fix, we wrap around (seek) and after writing some more
> > > > we go to next file (seek again).
> >
> > We also found this commit causes about 40~50% regression with iozone
> > mmap-rand-write. #iozone -B -r 4k -s 64k -s 512m -s 1200m
> >
> > My machine has 8GB memory.
> 
> Ah, thanks. Yes BDB I believe is basically just doing an mmap-rand-write,
> so maybe this is a good test case.
> 
> The interesting thing is why is this causing such a slowdown. If there is
> only a single main file active in the workload, then I don't see why this
> patch should make such a big difference. In either case, wouldn't pdflush
> come back and just start writing out from the start of the file anyway?

Perhaps the difference is that without the patch, pdflush will return
after running congestion_wait()?  This would give bdb and iozone a
chance to fill in more pages, and increases the chances we'll do
sequential IO.

-chris


