Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYFCI3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYFCI3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 04:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYFCI3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 04:29:30 -0400
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:37859 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751456AbYFCI32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 04:29:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pmnXmE2565MxavqU3mVSHa9FB4U0wEDVYOWqj9rN96NCnbeM07WHMcjBVIxT3EyihKyqRc7XIQybSbydu2cIl73+uReZ9qdBUPgOjCBWTp52BqJFSZloO7BkuP/KxTEuiuc4jJvKsFPFqBhkOMi99P+JXQ9zcR1jeD2BtYlxdbY=  ;
X-YMail-OSG: jCiRmWgVM1kG19BgGQIJHCbk6KL6vC7HugYFyweG7OHv4Jbw1zEmIkCF9NwaZuneSOyicmOOOXotPyuNa9plk37ijyK8qUqU0wwXbL8nr6fNEB8l8aoRLuqBLQqa2MnjydE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: schwidefsky@de.ibm.com
Subject: Re: [PATCH] Optimize page_remove_rmap for anon pages
Date: Tue, 3 Jun 2008 18:29:13 +1000
User-Agent: KMail/1.9.5
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org
References: <1212069392.16984.25.camel@localhost> <200806030957.49069.nickpiggin@yahoo.com.au> <1212480363.7746.19.camel@localhost>
In-Reply-To: <1212480363.7746.19.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031829.14150.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 June 2008 18:06, Martin Schwidefsky wrote:
> On Tue, 2008-06-03 at 09:57 +1000, Nick Piggin wrote:
>
> First of all: thanks for looking into this. Games with the dirty bit are
> scary and any change needs careful consideration.
>
> > I don't know if it is that simple, is it?
>
> It should be analog to the fact that for the two place the page_zap_rmap
> function is supposed to be used the pte dirty bit isn't checked as well.

pte dirty bit is checked in zap_pte_range. In do_wp_page, the pte dirty
bit is not checked because it cannot have been dirtied via that mapping.
However, this may not necessarily be true in the s390 case where it might
be dirtied by _another_ mapping which has subsequently exited but not
propogated the physical dirty bit (I don't know, but I'm just wary about
it).


> > I don't know how you are guaranteeing the given page ceases to exist.
> > Even checking for the last mapper of the page (which you don't appear
> > to do anyway) isn't enough because there could be a swapcount, in which
> > case you should still have to mark the page as dirty.
> >
> > For example (I think, unless s390 somehow propogates the dirty page
> > bit some other way that I've missed), wouldn't the following break:
> >
> > process p1 allocates anonymous page A
> > p1 dirties A
> > p1 forks p2, A now has a mapcount of 2
> > p2 VM_LOCKs A (something to prevent it being swapped)
> > page reclaim unmaps p1's pte, fails on p2
> > p2 exits, page_dirty does not get checked because of this patch
> > page has mapcount 0, PG_dirty is clear
> > Page reclaim can drop it without writing it to swap
>
> Indeed, this would break. Even without the VM_LOCK there is a race of
> try_to_unmap vs. process exit.
>
> > As far as the general idea goes, it might be possible to avoid the
> > check somehow, but you'd want to be pretty sure of yourself before
> > diverging the s390 path further from the common code base, no?
>
> I don't want to diverge more than necessary. But the performance gains
> of the SSKE/ISKE avoidance makes it worthwhile for s390, no?

I guess it's worth exploring.


> > The "easy" way to do it might be just unconditionally mark the page
> > as dirty in this path (if the pte was writeable), so you can avoid
> > the page_test_dirty check and be sure of not missing the dirty bit.
>
> Hmm, but then an mprotect() can change the pte to read-ony and we'd miss
> the dirty bit again. Back to the drawing board.

Hmm, I guess you _could_ set_page_dirty in mprotect.


> By the way there is another SSKE I want to get rid of: __SetPageUptodate
> does a page_clear_dirty(). For all uses of __SetPageUptodate the page
> will be dirty after the application did its first write. To clear the
> page dirty bit only to have it set again shortly after doesn't make much
> sense to me. Has there been any particular reason for the
> page_clear_dirty in __SetPageUptodate ?

I guess it is just to match SetPageUptodate. Not all __SetPageUptodate
paths may necessarily dirty the page, FWIW.
