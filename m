Return-Path: <linux-kernel-owner+w=401wt.eu-S1758068AbYFKEGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbYFKEGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 00:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbYFKEGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 00:06:42 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:28007 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751108AbYFKEGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 00:06:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mM+8A8qZ0s2UHxvlcDLmhxRySwGfUuQ15IgDm572DcKdpU4J+s/P+1ghMuM8RK1VBmw4Xh65vHvYRF4pvr0eBUSaRmOE5PdEMoopVXzcwaDgaCT4El7MB1RRImQeggbY5XVC+8IKpyWtNCzhy7VxaKFMPJ+PQKtwjKosoM1/BcU=  ;
X-YMail-OSG: 6e4V6IQVM1kK7rl2QEUzzj90eyiteRh9j77q964WOKPNBZ1NAQmM56vS91AQCiYYtWvb9kO0At8uE0YSf298.pUpcHgPqSAd085zLb8LmgyxHcfMfGRvQqoliZ5V4mAUhCk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: benh@kernel.crashing.org
Subject: Re: MMIO and gcc re-ordering issue
Date: Wed, 11 Jun 2008 14:06:27 +1000
User-Agent: KMail/1.9.5
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-arch@vger.kernel.org,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Trent Piepho <tpiepho@freescale.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       David Miller <davem@davemloft.net>, scottwood@freescale.com,
       linuxppc-dev@ozlabs.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
References: <1211852026.3286.36.camel@pasglop> <200806111329.35894.nickpiggin@yahoo.com.au> <1213155644.25745.60.camel@pasglop>
In-Reply-To: <1213155644.25745.60.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806111406.28411.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 June 2008 13:40, Benjamin Herrenschmidt wrote:
> On Wed, 2008-06-11 at 13:29 +1000, Nick Piggin wrote:
> > Exactly, yes. I guess everybody has had good intentions here, but
> > as noticed, what is lacking is coordination and documentation.
> >
> > You mention strong ordering WRT spin_unlock, which suggests that
> > you would prefer to take option #2 (the current powerpc one): io/io
> > is ordered and io is contained inside spinlocks, but io/cacheable
> > in general is not ordered.
>
> IO/cacheable -is- ordered on powepc in what we believe is the direction
> that matter: IO reads are fully ordered vs. anything and IO writes are
> ordered vs. previous cacheable stores. The only "relaxed" situation is
> IO writes followed by cacheable stores, which I believe shouldn't be
> a problem. (except for spinlocks for which we use the flag trick)

Spinlocks... mutexes, semaphores, rwsems, rwlocks, bit spinlocks, bit
mutexes, open coded bit locks (of which there are a number floating
around in drivers/).

But even assuming you get all of that fixed up. I wonder what is such
a big benefit to powerpc that you'll rather add the exception "cacheable
stores are not ordered with previous io stores" than to say "any driver
which works on x86 will work on powerpc as far as memory ordering goes"?
(don't you also need something to order io reads with cacheable reads?
as per my observation that your rmb is broken according to IBM docs)

Obviously you already have a sync instruction in your writel, so 1)
adding a second one doesn't slow it down by an order of mangnitude or
anything, just some small factor; and 2) you obviously want to be
converting high performance drivers to a more relaxed model anyway
regardless of whether there is one sync or two in there.

Has this ever been measured or thought carefully about? Beyond the
extent of "one sync good, two sync bad" ;)
