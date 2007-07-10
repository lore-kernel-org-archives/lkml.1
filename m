Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXGJBIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXGJBIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 21:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758939AbXGJBIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 21:08:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:34931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758121AbXGJBH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 21:07:59 -0400
Date: Tue, 10 Jul 2007 03:07:58 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
Message-ID: <20070710010757.GD8779@wotan.suse.de>
References: <20070624014528.GA17609@wotan.suse.de> <Pine.LNX.4.64.0707091002170.15696@schroedinger.engr.sgi.com> <20070710005419.GB8779@wotan.suse.de> <Pine.LNX.4.64.0707091756020.2348@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707091756020.2348@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 05:59:47PM -0700, Christoph Lameter wrote:
> On Tue, 10 Jul 2007, Nick Piggin wrote:
> 
> > > Hmmm.... I did not notice that yet but then I have not done much work 
> > > there.
> > 
> > Notice what?
> 
> The bad code for the buffer heads.

Oh. Well my first mail in this thrad listed some of the problems
with them.


> > > > - A real "nobh" mode. nobh was created I think mainly to avoid problems
> > > >   with buffer_head memory consumption, especially on lowmem machines. It
> > > >   is basically a hack (sorry), which requires special code in filesystems,
> > > >   and duplication of quite a bit of tricky buffer layer code (and bugs).
> > > >   It also doesn't work so well for buffers with non-trivial private data
> > > >   (like most journalling ones). fsblock implements this with basically a
> > > >   few lines of code, and it shold work in situations like ext3.
> > > 
> > > Hmmm.... That means simply page struct are not working...
> > 
> > I don't understand you. jbd needs to attach private data to each bh, and
> > that can stay around for longer than the life of the page in the pagecache.
> 
> Right. So just using page struct alone wont work for the filesystems.
> 
> > There are no changes to the filesystem API for large pages (although I
> > am adding a couple of helpers to do page based bitmap ops). And I don't
> > want to rely on contiguous memory. Why do you think handling of large
> > pages (presumably you mean larger than page sized blocks) is strange?
> 
> We already have a way to handle large pages: Compound pages.

Yes but I don't want to use large pages and I am not going to use
them (at least, they won't be mandatory).

 
> > Conglomerating the constituent pages via the pagecache radix-tree seems
> > logical to me.
> 
> Meaning overhead to handle each page still exists? This scheme cannot 
> handle large contiguous blocks as a single entity?

Of course some things have to be done per-page if the pages are not
contiguous. I actually haven't seen that to be a problem or have much
reason to think it will suddenly become a problem (although I do like
Andrea's config page sizes approach for really big systems that cannot
change their HW page size).
