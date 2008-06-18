Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbYFRGnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbYFRGnF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 02:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbYFRGmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 02:42:53 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:35415 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754683AbYFRGmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 02:42:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qq0BVpPi2K1nNVlTvYNcVf1ic6pa6Sf5L3wdIQHjrbvZdaN4J9gTMefsinjf4G5xE++Y6XGZzQ2Al2H+kUrgXjROyNr/bJG56xKDy5rFxLxs5Z+MzgOLlzI/z5GRuln7nOUB/Gt3r2cwsGVC8Tv5Pz2TGn2cpZglU30gwwjZHvo=  ;
X-YMail-OSG: 63BQe94VM1nhE3JC8HfCkZd_BseILyVs6rS8OXabntSE0vfspKDBvcdjCZPfr9mfQEH7aZJTnrBACDBIv1F9qnSKKnWbrksoopezrj9AaLUx0KTFxuyl_AswN78W0r0qpSE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] migration_entry_wait fix.
Date: Wed, 18 Jun 2008 16:42:37 +1000
User-Agent: KMail/1.9.5
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       "hugh@veritas.com" <hugh@veritas.com>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <200806181535.58036.nickpiggin@yahoo.com.au> <20080618150436.dca5eb75.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080618150436.dca5eb75.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181642.38379.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008 16:04, KAMEZAWA Hiroyuki wrote:
> On Wed, 18 Jun 2008 15:35:57 +1000
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Wednesday 18 June 2008 11:54, KAMEZAWA Hiroyuki wrote:
> > > On Wed, 18 Jun 2008 10:13:49 +0900
> > >
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > +	if (!page_cache_get_speculative())
> > > > +		goto out;
> > >
> > > This is obviously buggy....sorry..quilt refresh miss..
> > >
> > > ==
> > > In speculative page cache lookup protocol, page_count(page) is set to 0
> > > while radix-tree modification is going on, truncation, migration,
> > > etc...
> >
> > These tend to all happen while the page is locked, and in particular
> > while the page does not have any references other than the current
> > code path and the pagecache. So no page tables should point to it.
> >
> > So migration_entry_wait should not find pages with a refcount of zero.
> >
> > > While page migration, a page fault to page under migration should wait
> > > unlock_page() and migration_entry_wait() waits for the page from its
> > > pte entry. It does get_page() -> wait_on_page_locked() -> put_page()
> > > now.
> > >
> > > In page migration, page_freeze_refs() -> page_unfreeze_refs() is
> > > called.
> > >
> > > Here, page_unfreeze_refs() expects page_count(page) == 0 and panics
> > > if page_count(page) != 0. To avoid this, we shouldn't touch
> > > page_count() if it is zero. This patch uses
> > > page_cache_get_speculative() to avoid the panic.
> >
> > At any rate, page_cache_get_speculative() should not be used for this
> > purpose, but for when we _really_ don't have any references to a page.
>
> Then, I got NAK. what should I do ?

Well, not nack as such as just wanting to find out a bit more about
how this happens (I'm a little bit slow...)

> (This fix is not related to lock_page() problem.)
>
> If I read your advice correctly, we shouldn't use lock_page() here.
>
> Before speculative page cache, page_table_entry of a page under migration
> has a pte entry which encodes pfn as special pte entry. and wait for the
> end of page migration by lock_page().

What I don't think I understand, is how we can have a page in the
page tables (and with the ptl held) but with a zero refcount... Oh,
it's not actually a page but a migration entry! I'm not quite so
familiar with that code.

Hmm, so we might possibly see a page there that has a zero refcount
due to page_freeze_refs? In which case, I think the direction of you
fix is good. Sorry for my misunderstanding the problem, and thank
you for fixing up my code!

I would ask you to use get_page_unless_zero rather than
page_cache_get_speculative(), because it's not exactly a speculative
reference -- a speculative reference is one where we elevate _count
and then must recheck that the page we have is correct.

Also, please add a comment. It would really be nicer to hide this
transiently-frozen state away from migration_entry_wait, but I can't
see any lock that would easily solve it.

Thanks,
Nick
