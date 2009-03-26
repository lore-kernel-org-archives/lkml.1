Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZCZCup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZCZCup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 22:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZCZCug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 22:50:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:37802 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbZCZCuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 22:50:35 -0400
From: Neil Brown <neilb@suse.de>
To: Theodore Tso <tytso@mit.edu>
Date: Thu, 26 Mar 2009 13:50:10 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18890.60770.371109.185593@notabene.brown>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: message from Theodore Tso on Wednesday March 25
References: <alpine.LFD.2.00.0903231617550.3032@localhost.localdomain>
	<49C87B87.4020108@krogh.cc>
	<72dbd3150903232346g5af126d7sb5ad4949a7b5041f@mail.gmail.com>
	<49C88C80.5010803@krogh.cc>
	<72dbd3150903241200v38720ca0x392c381f295bdea@mail.gmail.com>
	<20090325183011.GN32307@mit.edu>
	<alpine.LFD.2.00.0903251139260.3032@localhost.localdomain>
	<20090325220530.GR32307@mit.edu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday March 25, tytso@mit.edu wrote:
> On Wed, Mar 25, 2009 at 11:40:28AM -0700, Linus Torvalds wrote:
> > On Wed, 25 Mar 2009, Theodore Tso wrote:
> > > I'm beginning to think that using a "ratio" may be the wrong way to
> > > go.  We probably need to add an optional dirty_max_megabytes field
> > > where we start pushing dirty blocks out when the number of dirty
> > > blocks exceeds either the dirty_ratio or the dirty_max_megabytes,
> > > which ever comes first.
> > 
> > We have that. Except it's called "dirty_bytes" and 
> > "dirty_background_bytes", and it defaults to zero (off).
> > 
> > The problem being that unlike the ratio, there's no sane default value 
> > that you can at least argue is not _entirely_ pointless.
> 
> Well, if the maximum time that someone wants to wait for an fsync() to
> return is one second, and the RAID array can write 100MB/sec, then
> setting a value of 100MB makes a certain amount of sense.  Yes, this
> doesn't take seek overheads into account, and it may be that we're not
> writing things out in an optimal order, as Alan as pointed out.  But
> 100MB is much lower number than 5% of 32GB (1.6GB).  It would be
> better if these numbers were accounted on a per-filesystem instead of
> a global threshold, but for people who are complaining about huge
> latencies, it at least a partial workaround that they can use today.

We do a lot of dirty accounting on a per-backing_device basis.  This
was added to stop slow devices from sucking up too much for the "40%
dirty" space.  The allowable dirty space is now shared among all
devices in rough proportion to how quickly they write data out.

My memory of how it works isn't perfect, but we count write-out
completions both globally and per-bdi and maintain a fraction:
      my-writeout-completions
    --------------------------
    total-writeout-completions

That device then gets a share of the available dirty space based on
the fraction.

The counts decay some-how so that the fraction represents recent
activity.

I shouldn't be too hard to add some concept of total time to this.
If we track the number of write-outs per unit time and use that together
with a "target time for fsync" to scale the 'dirty_bytes' number, we
might be able to auto-tune the amount of dirty space to fit the speeds
of the drives.

We would probably start with each device having a very low "max dirty"
number which would cause writeouts to start soon.  Once the device
demonstrates that it can do n-per-second (or whatever) the VM would
allow the "max dirty" number to drift upwards.  I'm not sure how best
to get it to move downwards if the device slows down (or the kernel
over-estimated).  Maybe it should regularly decay so that the device
keeps have to "prove" itself.

We would still leave the "dirty_ratio" as an upper-limit because we
don't want all of memory to be dirty (and 40% still sounds about
right).  But we would not have a time-based value to set a more
realistic limit when there is enough memory to keep the devices busy
for multiple minutes.

Sorry, no code yet.  But I think the idea is sound.

NeilBrown
