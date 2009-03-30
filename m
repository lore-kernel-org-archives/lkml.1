Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbZC3RRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbZC3RRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757878AbZC3RPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:15:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45495 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022AbZC3RPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:15:06 -0400
Message-ID: <49D0FD4C.1010007@redhat.com>
Date: Mon, 30 Mar 2009 13:11:40 -0400
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
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx> <49D0AA4A.6020308@redhat.com> <alpine.LFD.2.00.0903300817400.3948@localhost.localdomain> <49D0EF1E.9040806@redhat.com> <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903300922231.3948@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 30 Mar 2009, Ric Wheeler wrote:
>> I still disagree strongly with the don't force flush idea - we have an
>> absolute and critical need to have ordered writes that will survive a power
>> failure for any file system that is built on transactions (or data base).
> 
> Read that sentence of yours again.
> 
> In particular, read the "we" part, and ponder.
> 
> YOU have that absolute and critical need.
> 
> Others? Likely not so much. The reason people run "data=ordered" on their 
> laptops is not just because it's the default - rather, it's the default 
> _because_ it's the one that avoids most obvious problems. And for 99% of 
> all people, that's what they want. 

My "we" is meant to be the file system writers - we build our journalled file 
systems on top of these assumptions about ordering.  Not having them punts this 
all to fsck running most likely in a manual repair.

> 
> And as mentioned, if you have to have absolute requirements, you 
> absolutely MUST be using real RAID with real protection (not just RAID0). 
> 
> Not "should". MUST. If you don't do redundancy, your disk _will_ 
> eventually eat your data. Not because the OS wrote in the wrong order, or 
> the disk cached writes, but simply because bad things do happen.

Simply not true. To build reliable systems, you need reliable components.

It is perfectly normal to build non-raided systems that are components of a 
larger storage pool that don't do raid.

Easy example would be two desktops using rsync, most "cloud" storage systems do 
something similar at the whole file level (i.e., write out my file 3 times).

If you acknowledge back to a client a write, then have a power outage, the 
client should reasonably be able to expect that the data survived the power outage.

> 
> But turn that around, and say: if you don't have redundant disks, then 
> pretty much by definition those drive flushes won't be guaranteeing your 
> data _anyway_, so why pay the price?

They do in fact provide that promise for the extremely common case of power 
outage and as such, can be used to build reliable storage if you need to.

>> The big issues are that for s-ata drives, our flush mechanism is really,
>> really primitive and brutal. We could/should try to validate a better and less
>> onerous mechanism (with ordering tags? experimental flush ranges? etc).
> 
> That's one of the issues. The cost of those flushes can be really quite 
> high, and as mentioned, in the absense of redundancy you don't actually 
> get the guarantees that you seem to think that you get.

I have measured the costs of the write flushes on a variety of devices, 
routinely, a cache flush is on the order of 10-20 ms with a healthy s-ata drive.

Compared to the write speed of writing any large file from DRAM to storage, one 
20ms cost to make sure it is on disk is normally in the noise.

The trade off is clearly not as good for small files.

And I will add, my data is built on years of real data from commodity hardware 
running normal Linux kernels - no special hardware. There are also a lot of good 
papers that the USENIX FAST people have put out (looking at failures in NetApp 
gear, the HPC servers in national labs and at google) that can help provide 
realistic & accurate data.


> 
>> I spent a very long time looking at huge numbers of installed systems
>> (millions of file systems deployed in the field), including  taking part in
>> weekly analysis of why things failed, whether the rates of failure went up or
>> down with a given configuration, etc. so I can fully appreciate all of the
>> ways drives (or SSD's!) can magically eat your data.
> 
> Well, I can go mainly by my own anecdotal evidence, and so far I've 
> actually had more catastrophic data failure from failed drives than 
> anything else. OS crashes in the middle of a "yum update"? Yup, been 
> there, done that, it was really painful. But it was painful in a "damn, I 
> need to force a re-install of a couple of rpms".
> 
> Actual failed drives that got read errors? I seem to average almost one a 
> year. It's been overheating laptops, and it's been power outages that 
> apparently happened at really bad times. I have a UPS now.

Heat is a major killer of spinning drives (as is severe cold). A lot of times, 
drives that have read errors only (not failed writes) might be fully recoverable 
if you can re-write that injured sector. What you should look for is a peak in 
the remapped sectors (via hdparm) - that usually is a moderately good indicator 
(but note that it is normal to have some, just not 10-25% remapped!).

> 
>> What you have to keep in mind is the order of magnitude of various buckets of
>> failures - software crashes/code bugs tend to dominate, followed by drive
>> failures, followed by power supplies, etc.
> 
> Sure. And those "write flushes" really only cover a rather small 
> percentage. For many setups, the other corruption issues (drive failure) 
> are not just more common, but generally more disastrous anyway. So why 
> would a person like that worry about the (rare) power failure?

This is simply not a true statement from what I have seen personally.

> 
>> I have personally seen a huge reduction in the "software" rate of failures
>> when you get the write barriers (forced write cache flushing) working properly
>> with a very large installed base, tested over many years :-)
> 
> The software rate of failures should only care about the software write 
> barriers (ie the ones that order the OS elevator - NOT the ones that 
> actually tell the disk to flush itself).
> 
> 			Linus


The elevator does not issue write barriers on its own - those write barriers are 
sent down by the file systems for transaction commits.

I could be totally confused at this point, but I don't know of any sequential 
ordering needs that CFQ, etc have for their internal needs.

ric


