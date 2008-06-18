Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbYFRFgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbYFRFgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 01:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754653AbYFRFgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 01:36:10 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:44804 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754652AbYFRFgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 01:36:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SlkCzkrn34SjgAhCQiQUVGNZGP7C4Z8B2585Ld/JfGeP2iczGuFy0zlyFOQ6UDJsW/Az62tWuMYQRMHwbcxyp8zqPAeYnZzqYg77LJTXwsOtcAyeDyt6pCZmRikrFmwNbGG8NAJDB9hq/weXaorjSZ5QsAQOeKoE4CRPyu2L1QQ=  ;
X-YMail-OSG: jujbvpoVM1n2ttLvQoj5gthburGcAS3gC8gsSg74kGcSGhmZO0fUZUPRYOLul.1iswTgkSeo84.UOjX.EtuQEHuh64zGiDeQs2iG39ZxXKXvYN_NhHe2khTtT5S8sUcVvQE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] migration_entry_wait fix.
Date: Wed, 18 Jun 2008 15:35:57 +1000
User-Agent: KMail/1.9.5
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       "hugh@veritas.com" <hugh@veritas.com>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <20080618101349.db4d5205.kamezawa.hiroyu@jp.fujitsu.com> <20080618105435.de10d6bc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080618105435.de10d6bc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181535.58036.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008 11:54, KAMEZAWA Hiroyuki wrote:
> On Wed, 18 Jun 2008 10:13:49 +0900
>
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > +	if (!page_cache_get_speculative())
> > +		goto out;
>
> This is obviously buggy....sorry..quilt refresh miss..
>
> ==
> In speculative page cache lookup protocol, page_count(page) is set to 0
> while radix-tree modification is going on, truncation, migration, etc...

These tend to all happen while the page is locked, and in particular
while the page does not have any references other than the current
code path and the pagecache. So no page tables should point to it.

So migration_entry_wait should not find pages with a refcount of zero.


> While page migration, a page fault to page under migration should wait
> unlock_page() and migration_entry_wait() waits for the page from its
> pte entry. It does get_page() -> wait_on_page_locked() -> put_page() now.
>
> In page migration, page_freeze_refs() -> page_unfreeze_refs() is called.
>
> Here, page_unfreeze_refs() expects page_count(page) == 0 and panics
> if page_count(page) != 0. To avoid this, we shouldn't touch page_count()
> if it is zero. This patch uses page_cache_get_speculative() to avoid
> the panic.

At any rate, page_cache_get_speculative() should not be used for this
purpose, but for when we _really_ don't have any references to a page.
