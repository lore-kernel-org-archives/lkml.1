Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbYCRM3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbYCRM3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 08:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYCRM3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 08:29:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37302 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbYCRM3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 08:29:43 -0400
Subject: Re: [patch 4/8] mm: allow not updating BDI stats in
	end_page_writeback()
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <E1JbaTH-0005jN-4r@pomaz-ex.szeredi.hu>
References: <20080317191908.123631326@szeredi.hu>
	 <20080317191945.122011759@szeredi.hu> <1205840031.8514.346.camel@twins>
	 <E1JbaTH-0005jN-4r@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Tue, 18 Mar 2008 13:29:35 +0100
Message-Id: <1205843375.8514.357.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-18 at 12:59 +0100, Miklos Szeredi wrote:
> > On Mon, 2008-03-17 at 20:19 +0100, Miklos Szeredi wrote:
> > > plain text document attachment (end_page_writeback_nobdi.patch)
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > Fuse's writepage will need to clear page writeback separately from
> > > updating the per BDI counters.
> > 
> > This is because of the juggling with temporary pages, right?
> > 
> > Would be nice to have some comments in the code explaining this.
> 
> Yup, well it will go through a bigger cleanup, as discussed with
> Andrew, if that's OK with you?

Well, I was pondering that - it hadn't made its way out to the other
side of my brain yet.. but I'll dump have I have:

Yes, it does two things, _however_ those two things are very much
related. Your use-case that breaks this relation is an execption - and I
haven't really grasped it yet..

I'm in general not too keen about you having to export the BDI
accounting stuff and using it explicitly like this, but I'm afraid I
don't see a way around it - the danger is that other filesystems will
get creative (hence the req for GPL - that excludes the most creative
ones).

Yes, it makes sense to delay the write completion accounting until its
actually completed.. but I would suggest all writeback accounting.

So the thing that's in your way is that removing a page from the radix
tree doesn't imply its done writing. So perhaps we should make that
distinction instead?

So instead of conditionally do part of the accounting, never do it and
require something like: page_writeback_complete() to be called after a
successfull test_clear_page_writeback().


