Return-Path: <linux-kernel-owner+w=401wt.eu-S1030230AbXBTQaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030230AbXBTQaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030211AbXBTQaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:30:17 -0500
Received: from pat.uio.no ([129.240.10.15]:37260 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030230AbXBTQaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:30:15 -0500
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion
	event
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Chris Mason <chris.mason@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070220160854.GO6133@think.oraclecorp.com>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net>
	 <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411>
	 <20070219215048.GI6133@think.oraclecorp.com>
	 <20070220002109.GG31205@kvack.org>
	 <1171987310.6271.23.camel@heimdal.trondhjem.org>
	 <20070220160854.GO6133@think.oraclecorp.com>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 11:29:48 -0500
Message-Id: <1171988988.6271.26.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: A772B8D4B1E2F0DB0F7FCA2A72DD18AF6CB3BD6D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 735 total 583817 max/h 2803 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 11:08 -0500, Chris Mason wrote:
> On Tue, Feb 20, 2007 at 11:01:50AM -0500, Trond Myklebust wrote:
> > On Mon, 2007-02-19 at 19:21 -0500, Benjamin LaHaise wrote:
> > > On Mon, Feb 19, 2007 at 04:50:48PM -0500, Chris Mason wrote:
> > > > aio is not responsible for this particular synchronization.  Those fixes
> > > > (if we make them) should come from other places.  The patch is important
> > > > to get aio error handling right.
> > > > 
> > > > I would argue that one common cause of the EIO is userland
> > > > error (mmap concurrent with O_DIRECT), and EIO is the correct answer.
> > > 
> > > I disagree.  That means that using the pagecache to synchronize things like 
> > > the proposed online defragmentation will occasionally make O_DIRECT users 
> > > fail.  O_DIRECT doesn't prevent the sysadmin from copying files or other 
> > > page cache uses, which implies that generating an error in these cases is 
> > > horrifically broken.  If only root could do it, I wouldn't complain, but 
> > > this would seem to imply that user vs root holes still exist.
> > 
> > We don't try to resolve "conflicting" writes between ordinary mmap() and
> > write(), so why should we be doing it for mmap and O_DIRECT?
> > 
> > mmap() is designed to violate the ordinary mutex locks for write(), so
> > if a conflict arises, whether it be with O_DIRECT or ordinary writes
> > then it is a case of "last writer wins".
> 
> There are some strange O_DIRECT corner cases in here such that the 'last
> writer' may actually be a 'last reader' and winning can mean have a copy
> of the page in page cache older than the copy on disk.

As long as it is marked dirty so that it eventually gets synced to disk,
it shouldn't matter.

> One option is to have invalidate_inode_pages2_range continue if it can't
> toss a page but still return something that O_DIRECT ignores (living
> with the race), but it looks like I can make a launder_page op that does
> the right thing.  I'll give it a shot.

I already sent in a patch to do that last week.

Cheers
  Trond

