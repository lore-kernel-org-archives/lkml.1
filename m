Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbYA0GFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbYA0GFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 01:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757173AbYA0GEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 01:04:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756810AbYA0GEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 01:04:36 -0500
Date: Sat, 26 Jan 2008 22:03:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: hugh@veritas.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: fix PageUptodate data race
Message-Id: <20080126220356.0b77f0e9.akpm@linux-foundation.org>
In-Reply-To: <20080122040114.GA18450@wotan.suse.de>
References: <20080122040114.GA18450@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Jan 2008 05:01:14 +0100 Nick Piggin <npiggin@suse.de> wrote:
> 
> After running SetPageUptodate, preceeding stores to the page contents to
> actually bring it uptodate may not be ordered with the store to set the page
> uptodate.
> 
> Therefore, another CPU which checks PageUptodate is true, then reads the
> page contents can get stale data.
> 
> Fix this by having an smp_wmb before SetPageUptodate, and smp_rmb after
> PageUptodate.
> 
> Many places that test PageUptodate, do so with the page locked, and this
> would be enough to ensure memory ordering in those places if SetPageUptodate
> were only called while the page is locked. Unfortunately that is not always
> the case for some filesystems, but it could be an idea for the future.
> 
> Also bring the handling of anonymous page uptodateness in line with that of
> file backed page management, by marking anon pages as uptodate when they _are_
> uptodate, rather than when our implementation requires that they be marked as
> such. Doing allows us to get rid of the smp_wmb's in the page copying
> functions, which were especially added for anonymous pages for an analogous
> memory ordering problem. Both file and anonymous pages are handled with the
> same barriers.
> 

So...  it's two patches in one.


What kernel is this against?  Looks like mainline.  Is it complete and
correct when applied against the large number of pending MM changes?

