Return-Path: <linux-kernel-owner+w=401wt.eu-S935639AbXJQBsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935639AbXJQBsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 21:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761546AbXJQBsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 21:48:16 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:46336 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753617AbXJQBsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 21:48:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=IJc/suSOztTA1cda+zf/6CXL2z83TTv7A8pkDR8J3s+LmLTmu2NDSN/LauFILb9LuDC16LIjC9kG1FbyOjkeIfzriS50dHqFmunWTZgb6ZOZp3TvHJAC/6CjCQKYIlVUTq7q9FboiWj054okgWtdjERrd4r42cy+AcadWL2CABQ=  ;
X-YMail-OSG: 3sZa7L8VM1lDvrpcoZ0OZpqu8VgsoqtjuCIdFsWA6AfNUJul.IoG2oZiAQtby4nrPfM3xRCPLg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch][rfc] rewrite ramdisk
Date: Wed, 17 Oct 2007 11:47:48 +1000
User-Agent: KMail/1.9.5
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <200710151028.34407.borntraeger@de.ibm.com> <200710171028.23226.nickpiggin@yahoo.com.au> <m1ir56fsq8.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ir56fsq8.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710171147.48364.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 October 2007 11:13, Eric W. Biederman wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:

> > We have 2 problems. First is that, for testing/consistency, we
> > don't want BLKFLSBUF to throw out the data. Maybe hardly anything
> > uses BLKFLSBUF now, so it could be just a minor problem, but still
> > one to fix.
>
> Hmm.  This is interesting because we won't be doing anything that
> effects correctness if we don't special case BLKFLSBUF just something
> that effects efficiency.  So I think we can get away with just
> changing blkflsbuf as long as there is a way to get rid of
> the data.

Technically, it does change correctness: after BLKFLSBUF, the
ramdisk should contain zeroes.

I'm assuming it would also cause problems in tight embedded
environments if ramdisk ram is supposed to be thrown away but
isn't. So maybe not technically a correctness problem, but could
be the difference between working and not working.


> > Second is actually throwing out the ramdisk data. dd from /dev/null
> > isn't trivial because it isn't a "command" from the kernel's POV.
> > rd could examine the writes to see if they are zero and page aligned,
> > I suppose... but if you're transitioning everyone over to a new
> > method anyway, might as well make it a nice one ;)
>
> Well I was thinking you can examine the page you just wrote to
> and if it is all zero's you don't need to cache that page anymore.
> Call it intelligent compression.
>
> Further it does make forwards and backwards compatibility simple
> because all you would have to do to reliably free a ramdisk is:
>
> dd if=/dev/zero of=/dev/ramX
> blockdev --flushbufs /dev/ramX

Sure, you could do that, but you still presumably need to support
the old behaviour.

As a test vehicle for filesystems, I'd much rather it didn't do this
of course, because subsequent writes would need to reallocate the
page again.
