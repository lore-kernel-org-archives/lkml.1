Return-Path: <linux-kernel-owner+w=401wt.eu-S966251AbXIBMNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966251AbXIBMNi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964828AbXIBMN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:13:29 -0400
Received: from canuck.infradead.org ([209.217.80.40]:43843 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964820AbXIBMN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:13:27 -0400
Subject: Re: [jffs2] [rfc] fix write deadlock regression
From: David Woodhouse <dwmw2@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Jason Lunz <lunz@falooley.org>, lkml <linux-kernel@vger.kernel.org>,
       jffs-dev@axis.com, Hugh Dickins <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070902042012.GA5864@wotan.suse.de>
References: <20070830182354.GA25077@falooley.org>
	 <20070831212636.GB12868@falooley.org> <20070901190602.GA5926@falooley.org>
	 <20070902042012.GA5864@wotan.suse.de>
Content-Type: text/plain
Date: Sun, 02 Sep 2007 13:13:23 +0100
Message-Id: <1188735203.3834.16.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason, thank you _so_ much for finding the underlying cause of this.

On Sun, 2007-09-02 at 06:20 +0200, Nick Piggin wrote:
> Hmm, thanks for that. It does sound like it is deadlocking via
> commit_write(). OTOH, it seems like it could be using the page
> before it is uptodate -- it _may_ only be dealing with uptodate
> data at that point... but if so, why even read_cache_page at
> all?

jffs2_readpage() is synchronous -- there's no chance that the page won't
be up to date. We're doing this for garbage collection -- if there are
many log entries covering a single page of data, we want to write out a
single replacement which covers the whole page, obsoleting the previous
suboptimal representation of the same data.

> However, it is a regression. So unless David can come up with a
> more satisfactory approach, I guess we'd have to go with your
> patch. 

I think Jason's patch is the best answer for the moment. At some point
in the very near future I want to improve the RAM usage and compression
ratio by dropping the rule that data nodes may not cross page boundaries
-- in which case garbage collection will need to do something other than
reading the page using read_cache_page() and then writing it out again;
it'll probably need to end up using its own internal buffer. But for
now, Jason's patch looks good.

Thanks.

-- 
dwmw2

