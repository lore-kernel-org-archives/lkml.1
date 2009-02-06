Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZBFVBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZBFVBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:01:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZBFVBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:01:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38241 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257AbZBFVBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:01:38 -0500
Date: Fri, 6 Feb 2009 13:00:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: kosaki.motohiro@jp.fujitsu.com, rjw@sisk.pl, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3][RFC] swsusp: shrink file cache first
Message-Id: <20090206130009.99400d43.akpm@linux-foundation.org>
In-Reply-To: <20090206044907.GA18467@cmpxchg.org>
References: <20090206031125.693559239@cmpxchg.org>
	<20090206031324.004715023@cmpxchg.org>
	<20090206122129.79CC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20090206044907.GA18467@cmpxchg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009 05:49:07 +0100
Johannes Weiner <hannes@cmpxchg.org> wrote:

> > and, I think you should mesure performence result.
> 
> Yes, I'm still thinking about ideas how to quantify it properly.  I
> have not yet found a reliable way to check for whether the working set
> is intact besides seeing whether the resumed applications are
> responsive right away or if they first have to swap in their pages
> again.

Describing your subjective non-quantitative impressions would be better
than nothing...

The patch bugs me.

The whole darn point behind the whole darn page reclaim is "reclaim the
pages which we aren't likely to need soon".  There's nothing special
about the swsusp code at all!  We want it to do exactly what page
reclaim normally does, only faster.

So why do we need to write special hand-rolled code to implement
something which we've already spent ten years writing?

hm?  And if this approach leads to less-than-optimum performance after
resume then the fault lies with core page reclaim - it reclaimed the
wrong pages!

That actually was my thinking when I first worked on
shrink_all_memory() and it did turn out to be surprisingly hard to
simply reuse the existing reclaim code for this application.  Things
kept on going wrong.  IIRC this was because we were freeing pages as we
were reclaiming, so the page reclaim logic kept on seeing all these
free pages and kept on wanting to bale out.

Now, the simple and obvious fix to this is not to free the pages - just
keep on allocating pages and storing them locally until we have
"enough" memory.  Then when we're all done, dump them all straight onto
to the freelists.

But for some reason which I do not recall, we couldn't do that.

It would be good to revisit all this.
