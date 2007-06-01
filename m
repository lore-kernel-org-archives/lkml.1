Return-Path: <linux-kernel-owner+w=401wt.eu-S1761208AbXFABeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761208AbXFABeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbXFABeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:34:05 -0400
Received: from mx1.suse.de ([195.135.220.2]:41621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757713AbXFABeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:34:04 -0400
Date: Fri, 1 Jun 2007 03:34:02 +0200
From: Nick Piggin <npiggin@suse.de>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1 - page_mkwrite() breakage
Message-ID: <20070601013402.GB28585@wotan.suse.de>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070531231354.GR20632@ca-server1.us.oracle.com> <20070601010129.GA15878@wotan.suse.de> <20070601012440.GS20632@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601012440.GS20632@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 06:24:40PM -0700, Mark Fasheh wrote:
> On Fri, Jun 01, 2007 at 03:01:29AM +0200, Nick Piggin wrote:
> > Ah, I didn't realise you were using that yet. I expect ocfs2 is using
> > VM_CAN_INVALIDATE there anyway.
> > 
> > Hmm, this becomes easier to deal with after page_mkwrite is merged with
> > ->fault. But for now, can we just lock the page at the do_wp_page site
> > as well, and change the API? All users I have seen want the page locked
> > there anyway...
> 
> Unfortunately that doesn't work for ocfs2 for exactly the same reasons page
> lock doesn't work during a write either - there's a cluster lock inversion
> and we might have to zero adjacent pages for an allocating write.

I guess you could just fail the page_mkwrite and have it try again? ..
that would require changing it not to always go SIGBUS though.


> What's involved in merging it with ->fault?

Just I have't sent the patch (because at the time there were no
page_mkwrite users to look at).

It is nicer too, because the nopage path only has  to call into
the filesystem once, to return the page (the filesystem can check
whether it is for write, and do the page_mkwrite thing at that
time). do_wp_page obviously still involves the extra call, and
that will be with a flag telling the fs that it isn't a "nopage"
fault, but a write fault on an existing page.

 
> Here's a nasty idea... Would it be valid for ->page_mkwrite to unlock the
> page, so long as it's returned in a locked state? Though, do we even need
> the page lock that early? It seemed to me that you were adding it for
> consistency reasons (I could be wrong though).

You could do that, but you'd have to probably check that it is
within i_size after you relock it, I think... yeah, that might
be the best thing for ocfs to do for now.
