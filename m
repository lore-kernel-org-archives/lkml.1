Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbZLHLnC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbZLHLnC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 06:43:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZLHLnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 06:43:00 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:58763 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbZLHLm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 06:42:59 -0500
X-Trace: 303358016/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AicBAArLHUtQKW/F/2dsb2JhbAAI11uEMgQ
X-IronPort-AV: E=Sophos;i="4.47,361,1257120000"; 
   d="scan'208";a="303358016"
Date: Tue, 8 Dec 2009 11:42:55 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHSET] mremap/mmap mess
In-Reply-To: <20091208060701.GM14381@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0912081142280.31223@sister.anvils>
References: <E1NGzzu-0008RH-T2@ZenIV.linux.org.uk> <20091207035857.GF14381@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0912071710540.14445@sister.anvils> <20091207193048.GI14381@ZenIV.linux.org.uk>
 <Pine.LNX.4.64.0912071953490.24794@sister.anvils> <20091208060701.GM14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Dec 2009, Al Viro wrote:
> 
> Why do we want user_get_pages(), anyway?  It's not that we lacked an
> easy way to do large arrays, especially since the use is purely sequential.
> Even a linked list of vmalloc'ed pages would do just fine (i.e. start with
> static array in bprm, keep the pointer to last filled entry + number of
> entries left before the next allocation; use the last pointer in array
> for finding the next page-sized chunk).
> 
> What do we lose if we go that way?  Inserting all these pages into mm
> at once shouldn't be slower.  Memory overhead is not really an issue
> (one page per 511 or 1023 pages of argv).  Am I missing something?

I think what you lose that way is swappability.

Since we're supporting unlimited args and env here, it is important
that those pages can belong to an mm, be discoverable by rmap, and
be swapped out if really necessary.  Whereas I think you're proposing
an internal list of those pages, unknown to rmap, unswappable.

Of course, a page is pinned in core between get_user_pages() and
put_page(), but unless I've got it wrong, get_user_pages() is being
applied one by one to these pages, each unpinned as the next is pinned.

It is conceivable that it actually doesn't work in the way I'm
expecting: that although it's all designed to leave those pages
swappable, some mod here or there has interfered with that.  But if
so, that would be a bug: the intention, and I believe it's important,
is that those pages are swappable.

I have a different reason for wanting to change how it's done:
it's the major user of non-atomic kmap() and its global kmap_lock,
and rather swamps other uses of kmap() (which have better use for
the cached virtual address).  So I'd be happy with a better way
of doing it, but not at the cost of losing swappability.

Hugh

> 
> The benefit, AFAICS, is that we get rid of the mess with forced high
> address use, get *sane* get_user_pages() (we always have matching
> task_struct with the right personality, so we can avoid massive PITA
> for doing checks right) and we get unified mmu/nommu code in fs/exec.c
> out of that.
> 
> If you see serious problems I've missed, please tell.  Otherwise I'm
> going to hack up a prototype and post it here...
