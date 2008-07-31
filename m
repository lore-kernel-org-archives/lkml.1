Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYGaCQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYGaCQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbYGaCQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:16:25 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:43381 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754219AbYGaCQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:16:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=K0sJNY8Nq4daYiUep4jy7l3Cjy8X5vCvnJuCBYogiEaDXZ9gB7FafTO1Vh3lVexc7DtTu03RM+j6p0XJow6+78Wi/KGSnTp3pXIxzzfBzsaXGRw940QI2VQY/7pGJl9Vnf+0DxJWRXB7VKUwCkMx4glc6jv9q6EpyTMJWdhjXsw=  ;
X-YMail-OSG: CLZW.S8VM1k_mHOIBIxbst9fN718rG9n.j4HgJ6fqUR.gqXjUgPyZtqOYOQHAVayF6ZRsvVvONJ7IHHasV8.shxlXiCtUgijo.LEnxvXzi5MSZaSi7.9JKqHeQQ1z1FZ_zY-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch v3] splice: fix race with page invalidation
Date: Thu, 31 Jul 2008 12:16:16 +1000
User-Agent: KMail/1.9.5
Cc: Miklos Szeredi <miklos@szeredi.hu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <E1KO8DV-0004E4-6H@pomaz-ex.szeredi.hu> <E1KOFUi-0000EU-0p@pomaz-ex.szeredi.hu> <20080730175406.GN20055@kernel.dk>
In-Reply-To: <20080730175406.GN20055@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311216.16335.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 03:54, Jens Axboe wrote:
> On Wed, Jul 30 2008, Miklos Szeredi wrote:
> > On Wed, 30 Jul 2008, Linus Torvalds wrote:
> > > On Wed, 30 Jul 2008, Miklos Szeredi wrote:
> > > > There are no real disadvantages: splice() from a file was
> > > > originally meant to be asynchronous, but in reality it only did
> > > > that for non-readahead pages, which happen rarely.
> > >
> > > I still don't like this. I still don't see the point, and I still
> > > think there is something fundamentally wrong elsewhere.
>
> You snipped the part where Linus objected to dismissing the async
> nature, I fully agree with that part.
>
> > We discussed the possible solutions with Nick, and came to the
> > conclusion, that short term (i.e. 2.6.27) this is probably the best
> > solution.
>
> Ehm where? Nick also said that he didn't like removing the ->confirm()
> bits as they are completely related to the async nature of splice. You
> already submitted this exact patch earlier and it was nak'ed.
>
> > Long term sure, I have no problem with implementing async splice.
> >
> > In fact, I may even have personal interest in looking at splice,
> > because people are asking for a zero-copy interface for fuse.
> >
> > But that is definitely not 2.6.27, so I think you should reconsider
> > taking this patch, which is obviously correct due to its simplicity,
> > and won't cause any performance regressions either.
>
> Then please just fix the issue, instead of removing the bits that make
> this possible.

The only "real" objection I had to avoiding the ClearPageUptodate there
I guess is that it would weaken some assertions. I was more concerned
about the unidentified problems... but there probably shouldn't be
too many places in the VM that really care that much anymore (and those
that do might already be racy).

Now it seems to be perfectly fine to use the actual page itself that may
have been truncated, and we have been doing that for a long time (see
get_user_pages). So I'm not so worried about a bad data corruption or
anything but just the VM getting confused, which we could fix anyway.

I guess that kind of patch could sit in -mm for a while then get merged.
Linus probably wouldn't think highly of a post-rc1 merge, but if it
really is a bugfix, maybe?
