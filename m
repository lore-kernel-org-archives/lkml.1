Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbZC3S3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbZC3S3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbZC3STi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:19:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34689 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbZC3STh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:19:37 -0400
Message-ID: <49D10C43.8020507@redhat.com>
Date: Mon, 30 Mar 2009 14:15:31 -0400
From: Ric Wheeler <rwheeler@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain> <49D0FD4C.1010007@redhat.com> <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903301038100.3948@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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


They actually are reliable in this way, I have not seen disks fail as you seem 
to think that they do after a simple power failure. With barriers (and barrier 
flushes enabled), you don't get that kind of bad reads for tracks after a normal 
power outage.

Some of the odd cases come from hot spotting of drives (say, rewriting the same 
sector over and over again) which can over many, many writes impact the 
integrity of the adjacent tracks. Or, you can get IO errors from temporary 
vibration (dropped the laptop or rolled a new machine down the data center). 
Those temporary errors are the ones that can be repaired.

I don't know how else to convince you (lots of good wine? beer? :-)), but I have 
personally looked at this in depth. Certainly, "Trust me, I know disks" is not 
really an argument that you have to buy...


> 
>> Heat is a major killer of spinning drives (as is severe cold). A lot of times,
>> drives that have read errors only (not failed writes) might be fully
>> recoverable if you can re-write that injured sector.
> 
> It's not worked for me, and yes, I've tried. Maybe I've been unlucky, but 
> every single case I can remember of having read failures, that drive has 
> been dead. Trying to re-write just the sectors with the error (and around 
> it) didn't do squat, and rewriting the whole disk didn't work either.

Lap top drives are more likely to fail hard - you might have really just had a 
bad head or similar issue.

Mark Lord hacked in support for doing low level writes into hdparm - might be 
worth playing with that next time you get a dud disk.

> 
> I'm sure it works for some "ok, the write just failed to take, and the CRC 
> was bad" case, but that's apparently not what I've had. I suspect either 
> the track markers got overwritten (and maybe a disk-specific low-level 
> reformat would have helped, but at that point I was not going to trust the 
> drive anyway, so I didn't care), or there was actual major physical damage 
> due to heat and/or head crash and remapping was just not able to cope.
> 
>>> Sure. And those "write flushes" really only cover a rather small percentage.
>>> For many setups, the other corruption issues (drive failure) are not just
>>> more common, but generally more disastrous anyway. So why would a person
>>> like that worry about the (rare) power failure?
>> This is simply not a true statement from what I have seen personally.
> 
> You yourself said that software errors were your biggest issue. The write 
> flush wouldn't matter for those (but the elevator barrier would)

How you bucket software issues in a hardware company (old job, not here at Red 
Hat) would include things like "file system corrupt, but disk hardware good" 
which results from improper barrier configuration.

A disk hardware failure would be something like the drive does not spin up, it 
has bad memory in the write cache, a broken head (actually, one of the most 
common errors). Those usually would result in the drive failing to mount.


> 
>> The elevator does not issue write barriers on its own - those write barriers
>> are sent down by the file systems for transaction commits.
> 
> Right. But "elevator write barrier" vs "sending a drive flush command" are 
> two totally independent issues. You can do one without the other (although 
> doing a drive flush command without the write barrier is admittedly kind 
> of pointless ;^)
> 
> And my point is, IT MAKES SENSE to just do the elevator barrier, _without_ 
> the drive command. If you worry much more about software (or non-disk 
> component) failure than about power failures, you're better off just doing 
> the software-level synchronization, and leaving the hardware alone.
> 
> 			Linus

I guess we have to agree to disagree.

File systems need ordering for transactions and recoverability. Doing barriers 
just in the elevator will appear to work well for casual users, but in any given 
large population (including desktops here), will produce more corrupted file 
systems, manual recoveries after power failure, etc.

File systems people can work harder to reduce fsync latency, but getting rid of 
these fundamental building blocks is not really a good plan in my opinion. I am 
pretty sure that we can get a safe and high performing file system balance here 
that will not seem as bad as you have experienced.

Ric




