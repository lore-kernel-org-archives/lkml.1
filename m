Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZIJPyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZIJPyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 11:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbZIJPyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 11:54:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:34806 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbZIJPyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 11:54:39 -0400
Subject: Re: [RFC][PATCH 7/7] writeback: balance_dirty_pages() shall write
 more than dirtied pages
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090910154116.GA10856@localhost>
References: <20090909145141.293229693@intel.com>
	 <20090909150601.159061863@intel.com> <20090909154413.GC7949@duck.suse.cz>
	 <20090910014201.GB10957@localhost> <20090910125742.GH5106@think>
	 <20090910132154.GA6446@localhost> <1252594564.7205.36.camel@laptop>
	 <20090910151458.GA10767@localhost> <1252596698.7205.59.camel@laptop>
	 <20090910154116.GA10856@localhost>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 17:54:29 +0200
Message-Id: <1252598069.7205.87.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 23:41 +0800, Wu Fengguang wrote:
> > > So btrfs_file_write() explicitly calls
> > > balance_dirty_pages_ratelimited_nr() to get throttled.
> > 
> > Right, so what is wrong with than, and how does this patch fix that?
> > 
> > [ the only thing you have to be careful with is that you don't
> > excessively grow the error bound on the dirty limit ]
> 
> Then we could form a loop:
> 
>         btrfs_file_write():     dirty 1024 pages
>         balance_dirty_pages():  write up to 12 pages (= ratelimit_pages * 1.5)
> 
> in which the writeback rate cannot keep up with dirty rate,
> and the dirty pages go all the way beyond dirty_thresh.

Ah, ok so this is to keep the error bound on the dirty limit bounded,
because we can break out of balance_dirty_pages() early, the /* We've
done our duty */ break.

Which unbalances the duty vs the dirty ratio.

I figure that with the task dirty limit stuff we could maybe try to get
rid of this break.. worth a try.

> Sorry for writing such a vague changelog!

np, as long as we get there :-)

Change makes sense now, thanks!

