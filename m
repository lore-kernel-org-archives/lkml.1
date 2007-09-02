Return-Path: <linux-kernel-owner+w=401wt.eu-S933801AbXIBNxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933801AbXIBNxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 09:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbXIBNx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 09:53:26 -0400
Received: from canuck.infradead.org ([209.217.80.40]:60828 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952AbXIBNxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 09:53:25 -0400
Subject: Re: [jffs2] [rfc] fix write deadlock regression
From: David Woodhouse <dwmw2@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Jason Lunz <lunz@falooley.org>, lkml <linux-kernel@vger.kernel.org>,
       jffs-dev@axis.com, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070902132034.GA20902@wotan.suse.de>
References: <20070830182354.GA25077@falooley.org>
	 <20070831212636.GB12868@falooley.org> <20070901190602.GA5926@falooley.org>
	 <20070902042012.GA5864@wotan.suse.de>
	 <1188735203.3834.16.camel@shinybook.infradead.org>
	 <20070902132034.GA20902@wotan.suse.de>
Content-Type: text/plain
Date: Sun, 02 Sep 2007 14:48:04 +0100
Message-Id: <1188740884.3834.22.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-02 at 15:20 +0200, Nick Piggin wrote:
> OK, but then hasn't the patch just made the deadlock harder to hit,
> or is there some invariant that says that readpage() will never be
> invoked if gc was invoked on the same page as we're commit_write()ing?

> The Q/A comments aren't very sure about this. I guess from the look
> of it, prepare_write/commit_write make sure the page will be uptodate
> by the start of commit_write, 

That's the intention, yes.

> and you avoid GCing the page in
> prepare_write because your new page won't have any nodes allocated
> yet that can possibly be GCed?

We _might_ GC the page -- it might not be a new page; we might be
overwriting it. But it's fine if we do. Actually it's slightly
suboptimal because we'll write out the same data twice -- once in GC and
then immediately afterward in the write which we were making space for.
But that's not the end of the world, and it's not very common.

> BTW. with write_begin/write_end, you get to control the page lock,
> so for example if the readpage in prepare_write for partial writes
> is *only* for the purpose of avoiding this deadlock later, you
> could possibly avoid the RMW with the new aops. Maybe it would
> help you with data nodes crossing page boundaries too...

I'll look at that; thanks.
 
> OK, thanks for looking at it. If you'd care to pass it on to Linus
> before he releases 2.6.23 in random() % X days time... ;)

Not before the Kernel Summit now, I suspect. But yes, I'll do that later
today or in the morning (the linuxconf.eu conference has already
started).


-- 
dwmw2

