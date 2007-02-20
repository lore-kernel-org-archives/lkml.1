Return-Path: <linux-kernel-owner+w=401wt.eu-S965225AbXBTQLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965225AbXBTQLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965332AbXBTQLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:11:18 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:19861 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965225AbXBTQLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:11:17 -0500
Date: Tue, 20 Feb 2007 11:08:54 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion event
Message-ID: <20070220160854.GO6133@think.oraclecorp.com>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net> <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411> <20070219215048.GI6133@think.oraclecorp.com> <20070220002109.GG31205@kvack.org> <1171987310.6271.23.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171987310.6271.23.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 11:01:50AM -0500, Trond Myklebust wrote:
> On Mon, 2007-02-19 at 19:21 -0500, Benjamin LaHaise wrote:
> > On Mon, Feb 19, 2007 at 04:50:48PM -0500, Chris Mason wrote:
> > > aio is not responsible for this particular synchronization.  Those fixes
> > > (if we make them) should come from other places.  The patch is important
> > > to get aio error handling right.
> > > 
> > > I would argue that one common cause of the EIO is userland
> > > error (mmap concurrent with O_DIRECT), and EIO is the correct answer.
> > 
> > I disagree.  That means that using the pagecache to synchronize things like 
> > the proposed online defragmentation will occasionally make O_DIRECT users 
> > fail.  O_DIRECT doesn't prevent the sysadmin from copying files or other 
> > page cache uses, which implies that generating an error in these cases is 
> > horrifically broken.  If only root could do it, I wouldn't complain, but 
> > this would seem to imply that user vs root holes still exist.
> 
> We don't try to resolve "conflicting" writes between ordinary mmap() and
> write(), so why should we be doing it for mmap and O_DIRECT?
> 
> mmap() is designed to violate the ordinary mutex locks for write(), so
> if a conflict arises, whether it be with O_DIRECT or ordinary writes
> then it is a case of "last writer wins".

There are some strange O_DIRECT corner cases in here such that the 'last
writer' may actually be a 'last reader' and winning can mean have a copy
of the page in page cache older than the copy on disk.

One option is to have invalidate_inode_pages2_range continue if it can't
toss a page but still return something that O_DIRECT ignores (living
with the race), but it looks like I can make a launder_page op that does
the right thing.  I'll give it a shot.

-chris

