Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZD0HqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZD0HqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZD0HqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:46:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:35824 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbZD0HqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:46:08 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 27 Apr 2009 17:46:21 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18933.25293.145925.707478@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Fix race between callers of read_cache_page_async and
 invalidate_inode_pages.
In-Reply-To: message from Andrew Morton on Sunday April 26
References: <18933.16534.862316.787808@notabene.brown>
	<20090426223744.72edc7f4.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday April 26, akpm@linux-foundation.org wrote:
> On Mon, 27 Apr 2009 15:20:22 +1000 Neil Brown <neilb@suse.de> wrote:
> 
> hrm.  And where is it written that PageError() will remain inviolable
> after it has been set?

  ...it follows as night the day....

What use would PageError be if it can just disappear when you most
want to test it?
Then again, what use is PageUptodate if it can just disappear?  My
other thought for fixing this was to change truncate_complete_page to
not clear PageUptodate.....
Oh.  That's already been done in 2.6.27-rc2.

So I guess this isn't a bug in mainline anymore... sorry for the noise :-)
(I'll just go quietly fix some enterprise kernels).
> 
> A safer and more formal (albeit somewhat slower) fix would be to lock
> the page and check its state under the lock.
> 
> y:/usr/src/linux-2.6.30-rc3> grep -r ClearPageError . | wc -l
> 21

I think each of these do one of:
   - clear the error after a successful read
   - clear the error before a read attempt
   - clear the error before a write
all (I think) while the page is locked.  None of these would
invalidate the change I made. (and I still think that it would read
better to say
   if (PageError(page))
     goto error;

than
   if (!PageUptodate(page))
     goto error;

but no matter).

Thanks anyway.
NeilBrown
