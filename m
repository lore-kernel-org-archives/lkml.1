Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbYJKP6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbYJKP6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYJKP6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:58:42 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:34210 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYJKP6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:58:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=L4vFEem89grlevemjB14S+PmMTKhsqd/x05+lhqljhOp0OIiCXuTENxPgFvy4FPiUf
         rgtttMh0yV+u8AL/mLnZA3ZkI3cQP5hqgq1BwtnUU6RY7I3flzvLC8P+y6JMq7bE6w02
         K1+CmdGwLtvAvfsy0zSSnejwy94TE6pHA3DYQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/7] ide: locking improvements
Date: Sat, 11 Oct 2008 17:56:37 +0200
User-Agent: KMail/1.9.10
Cc: petkovbb@gmail.com, Robert Hancock <hancockr@shaw.ca>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <fa.Ke90oacfRjgiI4x5LejzjssRBEg@ifi.uio.no> <200810111645.27847.bzolnier@gmail.com> <20081011150532.GU19428@kernel.dk>
In-Reply-To: <20081011150532.GU19428@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810111756.37278.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 October 2008, Jens Axboe wrote:
> On Sat, Oct 11 2008, Bartlomiej Zolnierkiewicz wrote:
> > On Saturday 11 October 2008, Jens Axboe wrote:
> > > On Sat, Oct 11 2008, Borislav Petkov wrote:
> > > > > >From my perspective the main gain of these patches is the increased
> > > > > maintainability and sanity of the code, scalability improvements are
> > > > > just an added bonus.
> > > > 
> > > > and better code/improved scalability is a bad thing because... ?!
> > > 
> > > It's a bad thing because nobody on earth cares about IDE scalability,
> > 
> > JFYI: just yesterday I got mail proving otherwise. ;)
> 
> Well, there are lots of crazy people in the world, a request from
> someone doesn't necessarily make it a good idea :-)
> 
> > > from a performance POV a modern SATA controller is just better on
> > > several levels. I don't think anybody cares about IDE scaling on 8-16
> > > cores or more, simply because NOBODY is using IDE on such systems.
> > > 
> > > As such, trying to improve locking is a pointless exercise. And that is
> > > a bad thing, because code change invariably brings in code bugs. Then
> > > see previous mail on lack of coverage testing, and it can naturally be
> > > harmful.
> > 
> > Your concerns were already addressed in my reply but I worry that having
> > a discussion based on technical arguments is not your goal.
> 
> You make it sound like I have an alterior motive, which I definitely do
> not. I just wondered what all the IDE churn was supposed to be good
> for...
> 
> > Just to repeat: these patches are not hardware specific and obviously
> > they are not going to be merged today, tomorrow or in a week (they are
> > 2.6.29 material after months of time in pata tree / linux-next).
> 
> It's less about this specific patchset than in general. The specific one
> looked fine by itself, it's just the path to to 'IDE lock scaling' that
> is a bit crazy to me. Moving IDE to the softirq completion like SCSI
> would be a better start, imho. IDE still does most of the processing

We are getting there but this can't be done without fixing some other
stuff (like the patch posted today to not process the next request from
hard-IRQ context).  Any help would be much appreciated.

> under its ide_lock, which isn't even necessary. Making the locking more

Well, actually it doesn't do most work under ide_lock (never has been)
as the main means of protection is hwgroup->busy (which is protected by
ide_lock).

[ OTOH some changes in this patchset were inspired by _your_ comments about
  "room for locking improvements" in ide-io.c (IIRC) so kudos to you! ]

> finely grained is what I think is pretty crazy.

The more fine grained locking changes that were posted in separate patch
were first done 3 years ago by Scalex86 guys and they were extensively
tested on Intel hardware (however since other host drivers and things
like IDE settings were abusing ide_lock applying this change back than
was impossible - all of these stuff is fixed in the current Linus' tree).

Sorry for not explaining this clearly in the changelog.

> > > > > > rather like putting makeup on a corpse to me..
> > > > 
> > > > so _NOT_ true.
> > > 
> > > Depends on what you think is the corpse. Since IDE is essentially dead
> > > and frozen, it IS a corpse and the phrase is then very appropriate. This
> > > is not a personal jab at the IDE guys and does not reflect on the
> > > (mostly) good work they do, just a reflection on the state of IDE in
> > > general.
> > 
> > Interesting statement given that i.e. diffstat-wise pata tree has more
> > than twice as much stuff queued up for 2.6.28 than "some other" trees
> > (and we have history of being a _very_ conservative w.r.t. to needlessly
> > moving code around in drivers/ide/).
> > 
> > Please stop being silly and pushing your view/idea on what other people
> > should be doing (not to mention ignoring real facts).
> 
> Please start by actually _reading_ what I write. Your reply is based on
> the code base, my statement pertains to IDE on the hardware side
> (devices, controllers, etc). On the scalability front, what new hardware
> do you envision shipping with IDE controllers that are actually used for
> pushing large amounts of data? People would have to be borderline insane
> to make such new hw today.

Please understand that we are not doing new-hardware-driven-development
here but rather a big maintainance project.  Like I said in reply to Robert
the scalability improvements are an added bonus from my POV -> the main
goal is making the code simpler, harder to abuse and easier to maintain.

> I'm not pushing my views on anyone, but I am free to share what I
> actually think. I actually care about old code stability, hence my
> concern with the amount of IDE changes.

The actual users' feedback about amount of IDE changes have been mostly
positive (some ask for even more changes :) so I don't think that it
should be a reason of a great worries.  I hope that all other concerns
have been also cleared now.

Thanks,
Bart
