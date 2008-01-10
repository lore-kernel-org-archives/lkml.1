Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbYAJXBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbYAJXBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:01:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbYAJXB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:01:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039AbYAJXB2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:01:28 -0500
From: Neil Brown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Fri, 11 Jan 2008 10:01:18 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18310.41918.555194.701639@notabene.brown>
Cc: Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: [PATCH][RFC] fast file mapping for loop
In-Reply-To: message from Jens Axboe on Thursday January 10
References: <20080109085231.GE6650@kernel.dk>
	<20080109231628.GB4039@agk.fab.redhat.com>
	<20080110083130.GP6258@kernel.dk>
	<20080110074738.6be1c1ad@think.oraclecorp.com>
	<20080110125740.GY6258@kernel.dk>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday January 10, jens.axboe@oracle.com wrote:
> On Thu, Jan 10 2008, Chris Mason wrote:
> > On Thu, 10 Jan 2008 09:31:31 +0100
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Wed, Jan 09 2008, Alasdair G Kergon wrote:
> > > > Here's the latest version of dm-loop, for comparison.
> > > > 
> > > > To try it out, 
> > > >   ln -s dmsetup dmlosetup
> > > > and supply similar basic parameters to losetup.
> > > > (using dmsetup version 1.02.11 or higher)
> > > 
> > > Why oh why does dm always insist to reinvent everything? That's bad
> > > enough in itself, but on top of that most of the extra stuff ends up
> > > being essentially unmaintained.
> > 
> > I don't quite get how the dm version is reinventing things.  They use
> 
> Things like raid, now file mapping functionality. I'm sure there are
> more examples, it's how dm was always developed probably originating
> back to when they developed mostly out of tree. And I think it's a bad
> idea, we don't want duplicate functionality. If something is wrong with
> loop, fix it, don't write dm-loop.

I'm with Jens here.

We currently have two interfaces that interesting block devices can be
written for: 'dm' and 'block'.
We really should aim to have just one.  I would call it 'block' and
move anything really useful from dm into block.

As far as I can tell, the important things that 'dm' has that 'block'
doesn't have are:

  - a standard ioctl interface for assembling and creating interesting
     devices.
     For 'block', everybody just rolls there own. e.g. md, loop, and
     nbd all use totally different approaches for setup and tear down
     etc. 

  - suspend/reconfigure/resume.
    This is something that I would really like to see in 'block'.  If
    I had a filesystem mounted on /dev/sda1 and I wanted to make it a
    raid1, it would be cool if I could
	suspend /dev/sda1
	build a raid1 from sda1 and something else
	plug tha raid1 in as 'sda1'.
	resume sda1

  - Integrated 'linear' mapping.
    This is the bit of 'dm' that I think of as yucky.  If I read the
    code correctly, every dm device is a linear array of a bunch of
    targets.  Each target can be a stripe-set(raid0) or a multipath or
    a raid1 or a plain block device or whatever.
    Having 'linear' at a different level to everything else seems a
    bit ugly, but it isn't really a big deal.

I would really like to see every 'dm' target being just a regular
'block' device.  Then a 'linear' block device could be used to
assemble dm targets into a dm device.  Or the targets could be used
directly if the 'linear' function wasn't needed.

Each target/device could respond to both dm ioctls and 'adhoc'
ioctls.  That is a bit ugly, but backwards compatibility always is,
but it isn't a big cost.

I think the way forward here is to put the important
suspend/reconfig/resume functionality into the block layer, then
work on making code work with multiple ioctl interfaces.

I *don't* think the way forward is to duplicate current block devices
as dm targets.  This is duplication of effort (which I admit isn't
always a bad thing) and a maintenance headache (which is).

 "Help, I'm having a problem with the loop driver"
 "Which one, dm or regular, because if it is the 'dm' one you have to
  ask over there ..."

 It has already happened occasionally with raid1 and multipath - both
 of which have pointless multiple implementations.


> 
> > the dmsetup command that they use for everything else and provide a
> > small and fairly clean module for bio specific loop instead of piling
> > it onto loop.c....

I'm missing something here... "fairly clean module for bio specific
loop".  Isn't that what 'loop.c' is meant to be?

NeilBrown
