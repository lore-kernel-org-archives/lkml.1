Return-Path: <linux-kernel-owner+w=401wt.eu-S1758536AbYGCMcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758536AbYGCMcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757572AbYGCMcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:32:00 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:38723 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343AbYGCMb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:31:58 -0400
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 08:31:54 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: nfs client readdir caching issue?
Date: Thu, 3 Jul 2008 09:47:06 +0100
Message-ID: <0F10A59FDFFDFD4E9BEBD7365DE6725501F64C4B@uk-email.terastack.bluearc.com>
In-Reply-To: <1215020245.9783.10.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: nfs client readdir caching issue?
Thread-Index: Acjcak83m6Ql7XJ8TCiqq0jEbrXEVAAc9nvQ
References: <0F10A59FDFFDFD4E9BEBD7365DE6725501EC3707@uk-email.terastack.bluearc.com> <1215020245.9783.10.camel@localhost>
From: "Andy Chittenden" <andyc@bluearc.com>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: <linux-kernel@vger.kernel.org>
X-Spam: [F=0.1000000000; S=0.100(2008062001)]
X-MAIL-FROM: <andyc@bluearc.com>
X-SOURCE-IP: [62.190.48.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If so, then invalidate_inode_pages2_range() would have to be broken:
we
> always clear the readdir cache immediately after reading in the page
> with index 0 (i.e. the first readdir page).

I'm confused by the call to invalidate_inode_pages2_range:

        if (page->index == 0)
                invalidate_inode_pages2_range(inode->i_mapping,
PAGE_CACHE_SIZE, -1);

That's passing in a pgoff_t of 4096 as the start page offset from which
to invalidate. And an enormous number for the end page to invalidate to.
So it looks like the nfs client is trying to invalidate from a *byte*
offset of 4096 (but if that's true, the first page could contain less
than 4096 bytes depending on the size of the readdir response it
received but I'll leave that to one side for the moment).

What's confusing me is that when I look at the implementation of
invalidate_inode_pages2_range, I see this call to pagevec_lookup:

                pagevec_lookup(&pvec, mapping, next,
                        min(end - next, (pgoff_t)PAGEVEC_SIZE - 1) + 1))
{

looking at the pagevec_lookup comments, it claims the fourth parameter
is the number of pages:

* @nr_pages:   The maximum number of pages

So how can (end - next) be a number of pages? (next will be 4096 in the
call from the nfs client). IE it looks like
invalidate_inode_pages2_range is expecting a page range (as the name
suggests). IE I'm wondering whether the call to
invalidate_inode_pages2_range should be:

        if (page->index == 0)
                invalidate_inode_pages2_range(inode->i_mapping, 1, -1);

FWIW We've also seen this on larger directories so I'm wondering what
would happen if a readdir part way down the cookie chain returned more
data (or less) than it did last time. IE if the above is correct, then
replace the two lines with:

	invalidate_inode_pages2_range(inode->i_mapping, page->index + 1,
-1);

IE purge the rest of the pages for the inode.

-- 
Andy, BlueArc Engineering

