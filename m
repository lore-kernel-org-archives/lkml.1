Return-Path: <linux-kernel-owner+w=401wt.eu-S1765889AbYEFQmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765889AbYEFQmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760561AbYEFQme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:42:34 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:60614 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759924AbYEFQmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:42:32 -0400
Date: Tue, 6 May 2008 10:42:31 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080506164231.GK19219@parisc-linux.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <alpine.LFD.1.10.0805060931450.32269@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805060931450.32269@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 09:36:06AM -0700, Linus Torvalds wrote:
> On Tue, 6 May 2008, Matthew Wilcox wrote:
> > I've wanted to fix file locks for a while.  Here's a first attempt.
> > It was done quickly, so I concede that it may well have bugs in it.
> > I found (and fixed) one with LTP.
> 
> Hmm. Wouldn't it be nicer to make the lock be a per-inode thing? Or is 
> there some user that doesn't have the inode info, or does anything that 
> might cross inode boundaries?

/proc/locks and deadlock detection both cross inode boundaries (and even
filesystem boundaries).  The BKL-removal brigade tried this back in 2.4
and the locking ended up scaling worse than just plonking a single
spinlock around the whole thing.

> This does seem to drop all locking around the "setlease()" calls down to 
> the filesystem, which worries me. That said, we clearly do need to do 
> this. Probably should have done it a long time ago.

The only filesystems that are going to have their own setlease methods
will be remote ones (nfs, smbfs, etc).  They're going to need to sleep
while the server responds to them.  So holding a spinlock while we call
them is impolite at best.

> Also, why do people do this:
> 
> > -find_conflict:
> > + find_conflict:
> 
> Hmm?

So that find_conflict doesn't end up in the first column, which causes
diff to treat it as a function name for the purposes of the @@ lines.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
