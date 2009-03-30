Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZC3TNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZC3TNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759033AbZC3TMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:12:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48358 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756925AbZC3TMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:12:53 -0400
Message-ID: <49D118BB.9070003@sandeen.net>
Date: Mon, 30 Mar 2009 14:08:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain> <49D0FD4C.1010007@redhat.com> <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 30 Mar 2009, Ric Wheeler wrote:
>>> But turn that around, and say: if you don't have redundant disks, then
>>> pretty much by definition those drive flushes won't be guaranteeing your
>>> data _anyway_, so why pay the price?
>> They do in fact provide that promise for the extremely common case of power
>> outage and as such, can be used to build reliable storage if you need to.
> 
> No they really effectively don't. Not if the end result is "oops, the 
> whole track is now unreadable" (regardless of whether it happened due to a 
> write durign power-out or during some entirely unrelated disk error). Your 
> "flush" didn't result in a stable filesystem at all, it just resulted in a 
> dead one.
> 
> That's my point. Disks simply aren't that reliable. Anything you do with 
> flushing and ordering won't make them magically not have errors any more.

But this is apples and oranges isn't it?

All of the effort that goes into metadata journalling in ext3, ext4,
xfs, reiserfs, jfs ... is to save us from the fsck time on restart, and
ensure a consistent filesystem framework (metadata, that is, in
general), after an unclean shutdown.  That could be due to a system
crash or a power outage.  This is much more common in my personal
experience than a drive failure.

That journalling requires ordering guarantees, and with large drive
write caches, and no ordering, it's not hard for it to go south to the
point where things *do* get corrupted when you lose power or the drive
resets in the middle of basically random write cache destaging.  See
Chris Mason's tests from a year or so ago, proving that ext3 is quite
vulnerable to this - it likely explains some of the random htree
corruption that occasionally gets reported to us.

And yes, sometimes drives die, and then you are really screwed, but
that's orthogonal to all of the above, I think.

-Eric
