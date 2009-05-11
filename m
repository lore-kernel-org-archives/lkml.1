Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZEKNLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZEKNLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZEKNL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:11:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56252 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754832AbZEKNL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:11:28 -0400
Date: Mon, 11 May 2009 14:10:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511141057.24a5f8ed@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<20090510152005.GA9461@suse.de>
	<1241980263.9562.380.camel@laptop>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
	<m1pregmkld.fsf@fess.ebiederm.org>
	<ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk>
	<ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And I did, and it's obvious that creating a single file along with the
> ~10 we already create in /sys, instead of running through /sys or
> /proc later and reconstruct what we missed, is always, and in every
> case faster and simpler. It gets rid of a bunch of things we need to

Arjan's numbers for sysfs are 0.06 seconds if I remember the mail
correctly. That doesn't account for any meaningful speedup.

> > - That dumping more crap in kernel without policy and management is a
> >  good idea
> 
> What exactly do you find is "crap"? What do you mean with "management"?

Device spaces have user controlled naming rules, user controlled
permissions, user controlled labelling and the like. That is policy, and
the administering of that is management.

That was one of the things that killed devfs eventually, and it's not a
problem your proposal or devfs solved.

> 
> > - That the other proposals are worse than yours.
> 
> I also did, in exactly this thread.

Sorry, but I can't find any convincing evidence in the mails. I see
unhelpful things like you calling Arjan's numbers "made up", despite the
fact he has spent months working on speeding up boot and has probably the
most detailed analysis and data sets anyone does.

In fact I see a litany of comments in response to technical queries and
asking you to justify the code (as opposed to you trying to ask anyone to
justify why it shouldn't get dumped in tree)

Most of those comments are not helpful

> > Arjan produced detailed boot graphs and boots a box very fast indeed. I
> > see no boot graphs, no detailed analysis here.
> 
> I did in a reply to your earlier mail. And also mentioned the
> init=/bin/sh case, which I think, would be reason enough alone,
> without all the other gains, to do that.

I think you actually hit the nail on the head a lot earlier when you
asked Arjan  "How will you solve the dynamic device numbers". Which is
that we could fix them ....

What is the real underlying concern and what problem should we fix.

We have at least six takes on this

1.	What problem ?
2.	The udev userspace setup you are using sucks so fix it
3.	Udev sucks because it can't get the early boot events so has to
do it the hard way - so queue them
4.	Udev sucks because it can't get the early boot events so create
a single table for it to read
5.	Make the new big block numbers stable
6.	Recreate devfs in a new but more clean form

I don't buy take #1 so I would like to understand

- Why Arjan's systems boot very fast and yours don't

- Why you think sysfs changes will help when the stats say its 0.06 of a
  second and udev is not it appears taking much time anyway

- How you think you've solved the devfs problems about persistency and
  the like and what performance cost that has. That killed devfs in the
  end.

But even more I'd like to know wtf we don't just fix the stability of the
big block device numbering by attaching them to the existing block device
nodes using minors > 256 which are currently unused in this space.
Historically it didn't happen because Al Viro jumped up and down about
the initial proposal but its cleaner than a new devfs and it solves the
problem for everyone.

Given most distros use udev sorting udev out is obviously useful but its
not the 0.06 seconds - its the rest of the time that matters. If a sysfs
table of devices or buffering the events until it starts sorts that then
we have a far better model.

Udev tackles all the hard stuff - policy in user space, event triggering
for management etc, that your new devfs simply doesn't address. Fixing
udev isn't so much fun but it does actually get us something featureful
and useful that does what people want.


