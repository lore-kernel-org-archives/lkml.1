Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYGGMSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYGGMSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYGGMSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:18:21 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:33705 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753316AbYGGMSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:18:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=U4ucyP8gsliNqktxlDlQSrAMQikrPVvu1T88Q4Xz2sOUAvKSLCumQ8rmE/D6P5KqNAhvJtxbxBURaoz1RL+q2us6uP4z5pRSKd3fQ5yW5KWzspo6bdh2mzQnYF2ZYNUW9rp7fLxixGVoA/Fu5vzu5vRJ35ELTWUqQNIB9w7gBuY=  ;
X-YMail-OSG: wmtP14EVM1kF_W4aHZp6TLiHS6hxg7CMuwlCQ7J7SrANjt0.uKYXq7A9KQ8FoJrY2P7ialN2_PPf4GYvvWTpRGTHyEf2eZG60x_JJ6uobmE7Sl7lGNGkav_0mCUuxxPhjC0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch 1/2] mm: dont clear PG_uptodate in invalidate_complete_page2()
Date: Mon, 7 Jul 2008 22:17:57 +1000
User-Agent: KMail/1.9.5
Cc: jamie@shareable.org, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org, hugh@veritas.com
References: <20080625124038.103406301@szeredi.hu> <200807072101.58963.nickpiggin@yahoo.com.au> <E1KFpRL-0001pA-Aq@pomaz-ex.szeredi.hu>
In-Reply-To: <E1KFpRL-0001pA-Aq@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807072217.57509.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 July 2008 22:03, Miklos Szeredi wrote:
> On Mon, 7 Jul 2008, Nick Piggin wrote:
> > And it isn't just a fuse problem is it? Other places can invalidate
> > and truncate pages which might be spliced into a pipe, can't they?
>
> Yes.  There are several different problems here actually, and it's not
> completely clear how splice should handle them:
>
> Case 1: page is completely truncated while in the pipe
>
>   Currently splice() will detect this and return a short read count on
>   the splice-out.  Which sounds sane, and consistent with the fact
>   that a zero return value can happen on EOF.

OK.


> Case 2: page is partially truncated while in the pipe
>
>   Splice doesn't detect this, and returns the contents of the whole
>   page on splice-out, which will contain the zeroed-out part as well.
>   This is not so nice, but other than some elaborate COW schemes, I
>   don't see how this could be fixed.

There is a race window in the read(2) path where this can happen too.
The window for splice is larger, but I don't know if it is worth a
song and dance about if we're not bothering with the read(2) problem.

Maybe a note in the man page.


> Case 3: page is invalidated while in the pipe
>
>   This can happen on pages in the middle of the file, and splice-out
>   can return a zero count.  This is *BAD*, callers of splice really
>   should be able to assume, that a zero return means EOF.
>
> Page invalidation (the invalidate_inode_pages2 kind) is done by only a
> few filesystems (FUSE, NFS, AFS, 9P), and by O_DIRECT hackery.  So
> case 3 only affects these, and only fuse can be re-exported by nfsd
> (and that's only in -mm yet), hence this is very unlikely to be hit
> for any of the others.

Things that are using invalidate_complete_page2 are probably
also subtly broken if they allow mmap of the same pages, BTW.
It is easy to get wrong. If they have to handle the case of
invalidation failure _anyway_, then we really should have them
just use the safe invalidate...

That would "solve" the splice issue... Although if they handle
failure with a wait/retry loop, then it probably opens a window
to DoS by leaving your pipe filled. In theory one could have a
slowpath function triggered when invalidate fails which copies
the page data and then replaces them with copies in the pipe.
The hard part I suspect is to walk through everybodies pipes and
going through all pages. Probably not realistically solveable.


> But it's bad despite being rare, because once it hits it can cause
> data corruption (like with fuse/nfsd) and could be very hard to debug.
> OK, case 2 could also cause corruption if caller is not expecting it.
>
> Splice is a cool concept, but it isn't easy to get the implementation
> right...

Indeed.
