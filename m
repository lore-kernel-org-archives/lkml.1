Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbZBCLis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbZBCLis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:38:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZBCLih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:38:37 -0500
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:46817 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751961AbZBCLig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:38:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FCAeOJw53nABLnNdf5bdQcdpd1ufO2HuVSOncxsmCvrH0AZAjcZgQiQWdgrC04RUc6WEsI5hoZmKSSYaNZNCKNXxoexIZSyhnN0tYeXbNywhw0Z8ijQ1g587mFa9QIS6mKSM1kdboq0hxsDvjj0EOGcuBHZpLwoNuatyiDJU+vA=  ;
X-YMail-OSG: LsOqAQ0VM1ltn9lkELKHZ5osxZSn6fNXZrDPYGRVP_lJh2kngw3088R8Kjy4ynAwIy79UNzYd9zv1hLOeJ8oDymJ9.sWo2NVhQH.efhY32XXfPhtiYS9_EUQqm_IRzCQvgq95bgNEQDD1kLdny32jVvC6y8tcQISgsM7w9.jwba9y6IOk_aUP2u9i6_k_ptXXna8fgZdKTXT1gm9T3GGhoQjKBYA0X4-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Date: Tue, 3 Feb 2009 22:38:06 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: jarkao2@gmail.com, zbr@ioremap.net, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
References: <20090126212130.GA4338@ioremap.net> <20090127074048.GA4197@ff.dom.local> <20090130.134227.123379239.davem@davemloft.net>
In-Reply-To: <20090130.134227.123379239.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032238.08497.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 January 2009 08:42:27 David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Tue, 27 Jan 2009 07:40:48 +0000
>
> > I think the main problem is to respect put_page() more, and maybe you
> > mean to add this to your allocator too, but using slab pages for this
> > looks a bit complex to me, but I can miss something.
>
> Hmmm, Jarek's comments here made me realize that we might be
> able to do some hack with cooperation with SLAB.
>
> Basically the idea is that if the page count of a SLAB page
> is greater than one, SLAB will not use that page for new
> allocations.

Wouldn't your caller need to know what objects are already
allocated in that page too?


> It's cheesy and the SLAB developers will likely barf at the
> idea, but it would certainly work.

It is nasty, yes. Using the page allocator directly seeems
like a better approach.

And btw. be careful of using page->_count for anything, due
to speculative page references... basically it is useful only
to test zero or non-zero refcount. If designing a new scheme
for the network layer, it would be nicer to begin by using
say _mapcount or private or some other field in there for a
refcount (and I have a patch to avoid the atomic
put_page_testzero in page freeing for a caller that does their
own refcounting, so don't fear that extra overhead too much :)).


