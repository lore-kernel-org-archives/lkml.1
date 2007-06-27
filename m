Return-Path: <linux-kernel-owner+w=401wt.eu-S1763303AbXF0Vri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763303AbXF0Vri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 17:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbXF0Vra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 17:47:30 -0400
Received: from web30515.mail.mud.yahoo.com ([68.142.201.243]:24472 "HELO
	web30515.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752158AbXF0Vra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 17:47:30 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 17:47:29 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=t3DFkADs+maK/ep7/ycCJRFuNyTb9CQxea7TDNwv5cmG+j9u0Re4bH3dTKQYy1zWlLvlG6AADQ/Meb8yjCiIsLRqoQdh3kvg2SircTkvVbvkNMuMJH0tm/JQp0ujFPIMTbv1fl+bftJEnq5uqbKhLcDiCF0v/YvQ9tK14a6yGig=;
X-YMail-OSG: TEKftSQVM1kBMf2dc7jvcf33_G63JeNb7UbHkFGYxG2sapc9HkGLM._hdzhG8BuI66KT9QRVeQ--
Date: Wed, 27 Jun 2007 14:40:49 -0700 (PDT)
From: Casey Leedom <casey_leedom@yahoo.com>
Subject: Re: ZERO_PAGE() vs. loadable modules in Redhat 4.4 i386 kernels ...
To: linux-kernel@vger.kernel.org
In-Reply-To: <1182975482.2800.3.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <159834.25233.qm@web30515.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Arjan van de Ven <arjan@infradead.org> wrote:

> On Wed, 2007-06-27 at 11:53 -0700, Casey Leedom wrote:
> >   Sorry, my bad.  I'm just diving into Linux for the first time and wasn't
> > aware of the protocols.  Here's the code fragment I'm currently using:
> 
> code fragments are only very limited useful because they don't
> compile... use the power of open source and just post your entire source
> code..  (and it's open source, right?)
> 
> you sort of gave too little, we can't see how this is being used for
> example..

  Yes, it's open source -- the company I work for, Chelsio Communications,
makes it money off of the hardware and gives away all of the driver source both
under GPL and BSD licenses.  I just thought that dumping the entire driver
source would bother people.  Basically the problem is that when you call
get_user_pages() and the "write" parameter is 0, get_user_pages() calls
follow_page() with FOLL_ANON in the foll_flags parameter.  This causes
follow_page() to return a reference to empty_zero_page if the page is an
unmodified /dev/zero mapping and any portion of the PGD/PUD/PMD/PTE hierarchy
is missing.  This is all fine, but later on in our driver when we want to
follow down the PGD/PUD/PMD/PTE hierarchy to mark pages COW we fail because of
the missing mappings.

  I've thought of several solutions to this problem:

 1. If the "zero copy" DMA path comes across any /dev/zero mapped page,
    fail the zero copy path and fall back to the normal copy path.  This
    would be a minor performance loss but even worse, it requires being
    able to recognize ZERO_PAGE() which is the problem I'm battling now.

 2. Force get_user_pages() not to pass FOLL_ANON in to follow_page().
    The simplest way to do this is to pass in a non-zero "write"
    parameter but I'm leary of this because of the potential for
    side effects (lots of pages getting marked dirty, etc.)

 3. In the DMA-timeout/COW/return-to-user optimization path, if we run
    across ZERO_PAGE() then just skip to the next page since ZERO_PAGE()
    doesn't need to be marked COW.  This is our current fix but we've
    run across this inability to determine if a page we're looking at is
    the ZERO_PAGE() in an i386 32-bit Redhat 4.4 kernel ... (sigh)  This
    does work on the x86_64 kernel since empty_zero_page is an
    EXPORT_SYMBOL() under that architecture.

 4. Somehow force the PGD/PUD/PMD/PTE hierarchy to instantiate for each
    page.  Not sure how to do this ...  (I'm very new to the Linux kernel
    and working hard to catch up with everything.)

Sorry for the long drawn out explanation -- most of you probably already know
all about these paths but I just found out most of the above so I figured I
should explain what I _think_ is going on in case I've got some misconceptions.

Casey
