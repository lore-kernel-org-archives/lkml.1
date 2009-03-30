Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZC3SBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZC3SBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbZC3SA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:00:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262AbZC3SAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:00:54 -0400
Date: Mon, 30 Mar 2009 10:51:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ric Wheeler <rwheeler@redhat.com>
cc: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D0FD4C.1010007@redhat.com>
Message-ID: <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx>
 <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain> <49D0FD4C.1010007@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Ric Wheeler wrote:
> >
> > But turn that around, and say: if you don't have redundant disks, then
> > pretty much by definition those drive flushes won't be guaranteeing your
> > data _anyway_, so why pay the price?
> 
> They do in fact provide that promise for the extremely common case of power
> outage and as such, can be used to build reliable storage if you need to.

No they really effectively don't. Not if the end result is "oops, the 
whole track is now unreadable" (regardless of whether it happened due to a 
write durign power-out or during some entirely unrelated disk error). Your 
"flush" didn't result in a stable filesystem at all, it just resulted in a 
dead one.

That's my point. Disks simply aren't that reliable. Anything you do with 
flushing and ordering won't make them magically not have errors any more.

> Heat is a major killer of spinning drives (as is severe cold). A lot of times,
> drives that have read errors only (not failed writes) might be fully
> recoverable if you can re-write that injured sector.

It's not worked for me, and yes, I've tried. Maybe I've been unlucky, but 
every single case I can remember of having read failures, that drive has 
been dead. Trying to re-write just the sectors with the error (and around 
it) didn't do squat, and rewriting the whole disk didn't work either.

I'm sure it works for some "ok, the write just failed to take, and the CRC 
was bad" case, but that's apparently not what I've had. I suspect either 
the track markers got overwritten (and maybe a disk-specific low-level 
reformat would have helped, but at that point I was not going to trust the 
drive anyway, so I didn't care), or there was actual major physical damage 
due to heat and/or head crash and remapping was just not able to cope.

> > Sure. And those "write flushes" really only cover a rather small percentage.
> > For many setups, the other corruption issues (drive failure) are not just
> > more common, but generally more disastrous anyway. So why would a person
> > like that worry about the (rare) power failure?
> 
> This is simply not a true statement from what I have seen personally.

You yourself said that software errors were your biggest issue. The write 
flush wouldn't matter for those (but the elevator barrier would)

> The elevator does not issue write barriers on its own - those write barriers
> are sent down by the file systems for transaction commits.

Right. But "elevator write barrier" vs "sending a drive flush command" are 
two totally independent issues. You can do one without the other (although 
doing a drive flush command without the write barrier is admittedly kind 
of pointless ;^)

And my point is, IT MAKES SENSE to just do the elevator barrier, _without_ 
the drive command. If you worry much more about software (or non-disk 
component) failure than about power failures, you're better off just doing 
the software-level synchronization, and leaving the hardware alone.

			Linus
