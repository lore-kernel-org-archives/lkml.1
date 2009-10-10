Return-Path: <linux-kernel-owner+w=401wt.eu-S932550AbZJJOim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbZJJOim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 10:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761497AbZJJOij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 10:38:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760866AbZJJOii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 10:38:38 -0400
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
From: James Bottomley <James.Bottomley@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0910081309310.3432@localhost.localdomain>
References: <1254844007.4383.85.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain>
	 <1254862442.4383.183.camel@mulgrave.site>
	 <1255012399.4187.24.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain>
	 <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain>
	 <1255031298.4187.260.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain>
	 <1255032244.4187.267.camel@mulgrave.site>
	 <alpine.LFD.2.01.0910081309310.3432@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 10 Oct 2009 09:37:56 -0500
Message-Id: <1255185476.2894.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-08 at 13:25 -0700, Linus Torvalds wrote:
> 
> On Thu, 8 Oct 2009, James Bottomley wrote:
> > 
> > OK, you're saying the merge window exemption should only apply to
> > drivers which meet our coding standards.
> 
> Well, to me, it's not even "coding standards". It's more about "letting 
> things slide so that users get their hands on things earlier, since it 
> can't really regress". Coding standards are obviously a part of that, but 
> I think the coding standard question should come into this mainly in the 
> sense of "should it go through staging or not" kind of sense, not in the 
> timing sense.
> 
> The reason I object to this driver at this point is that I really think 
> there's a _huge_ difference between some random average driver, and a 50 
> kloc monster driver that basically seems to implement its own protocol.

The protocol it's implementing is a Fibre Channel state engine (it is a
FC driver, after all).  We have an embryonic project in SCSI to do this:
libfc.  libfc was separated from the fcoe project when we thought it
might prove useful.  However, it isn't quite production ready yet, but I
do have agreement that the bca driver will move to it in the near
future.

Just for comparison with other enterprise FC drivers:

qla2xxx: 30k LOC
lpfc: 58k LOC

so it's not even our biggest FC driver.

The other reason for the big state engine is that this isn't a fat
firmware (everything done inside the firmware of the card) type driver.
We like thin firmware hardware because it's easier to fix when things go
wrong.

If you give the perception of penalising drivers for being "huge" you're
sending the message to hardware manufacturers that they'll have an
easier time of it if they simply shove all the nasty bits into firmware
and present the kernel community with a tiny driver for a bloated fat
firmware card.

> Most random new drivers tend to be a few hundred lines of code, in some 
> cases a few thousand. They don't generally bring in their own subsystem 
> code, they often just hook into existing things like the libata layer or 
> the network driver infrastructure etc.

Right, and in this case, it will eventually plug into libfc ... we just
haven't quite got the infrastructure ready yet.

The functional infrastructure we need it to plug into for the userspace
ABI: scsi_transport_fc is all there and working.

> So most drivers are in a totally different class than the one I'm 
> objecting to in the SCSI tree.
> 
> And I also really do think there is a huge difference between some 
> specialized high-end SCSI driver that is only relevant to enterprise 
> people and some more average driver that is expected to perhaps exist in 
> lots of consumer devices. How many people does it affect, and what's their 
> ability to handle it?

Actually, larger than you would think.  Our primary customer at
distributions is the enterprise.  Now, you may say that enterprise
distro users aren't at the bleeding edge of kernel development.
However, we use the club of not being backported to a distro until
you're upstream to try and force driver writers/hardware vendors to
engage with the community.  The carrot to them is that as soon as they
make it upstream, the distros will incorporate the driver.  This makes
the merge window exemption an important part of that carrot, since
otherwise they might find themselves on the wrong side of a three month
cycle.

> Another way of putting that "consumer" vs "enterprise" thing: how big is 
> the _upside_ of merging the driver outside fo the merge window? Again, I 
> simply think pure number of potential users matters for the "should we let 
> it slide" question.

The upside is that I can use this as an inducement to other driver
writers for good behaviour, plus the bfa driver can get picked up by the
enterprise distributions early.  To people engaged in convincing
hardware vendors to work upstream and release early and often, that's a
very big upside.

James


