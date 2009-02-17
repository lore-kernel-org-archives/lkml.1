Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbZBQJiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbZBQJiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbZBQJiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:38:08 -0500
Received: from ns1.suse.de ([195.135.220.2]:43384 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbZBQJiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:38:07 -0500
Date: Tue, 17 Feb 2009 10:38:05 +0100
From: Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Edward Shishkin <edward.shishkin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ryan Hope <rmh3093@gmail.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: [patch 2/4] vfs: add set_page_dirty_notag
Message-ID: <20090217093805.GB31323@wotan.suse.de>
References: <18837.24581.181196.569183@edward.zelnet.ru> <1234530519.6519.46.camel@twins> <49957C43.7050701@gmail.com> <1234534150.6519.101.camel@twins> <18838.49922.215481.399653@edward.zelnet.ru> <1234645893.4695.8.camel@laptop> <18841.60432.329341.514726@edward.zelnet.ru> <1234861781.4744.21.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234861781.4744.21.camel@laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:09:41AM +0100, Peter Zijlstra wrote:
> On Tue, 2009-02-17 at 01:43 +0300, Edward Shishkin wrote:
> 
> >  > How much performance gain do you see by avoiding that radix tree op? 
> >  > 
> > 
> > Nop. We want to use it with extended semantics.
> > All dirty pages are divided into 2 categories:
> > 
> > A) tagged in the radix tree (with PAGECACHE_TAG_DIRTY).
> > B) captured by atoms (usual linked lists).
> > 
> > reiser4_writepages() looks for pages of "A" in the radix tree
> > and moves them to "B". set_page_dirty_notag(), introduced by
> > my patch, is needed for pages of "B".
> > 
> > If "B" is empty, then we get the traditional semantics with
> > regular ->writepages().
> > 
> > That's all!
> 
> Ah, indeed. I had not considered such a scheme.

It is a great shame that filesystems are not properly notified
that a page may become dirty before the actual set_page_dirty
event (which is not allowed to fail and is called after the
page is already dirty).

This is a big problem I have with fsblock simply in trying to
make the memory allocation robust. page_mkwrite unfortunately
is racy and I've fixed problems there... the big problem though
is get_user_pages. Fixing that properly seems to require fixing
callers so it is not really realistic in the short term.

As such...
 
> > Add set_page_dirty_notag() to the core library to enable
> > extended functionality of radix tree attached to inode->i_mapping.
> > 
> > Signed-off-by: Edward Shishkin<edward.shishkin@gmail.com>
> 
> Looks good to me
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

I'm fine with it too.

Acked-by: Nick Piggin <npiggin@suse.de>

You know... it wouldn't be terribly painful to introduce a new
pagecache radix tree tag for filesystem private use (doesn't bloat
the radix tree node size) if there is a strong need for it. But if
you have this workaround then I think it is also reasonable.

