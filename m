Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZC2BTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZC2BTy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 21:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZC2BTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 21:19:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40714 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZC2BTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 21:19:43 -0400
Message-ID: <49CECC7B.70100@garzik.org>
Date: Sat, 28 Mar 2009 21:18:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk> <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org> <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain> <49CD2C47.4040300@garzik.org> <alpine.LFD.2.00.0903271443440.3994@localhost.localdomain> <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca>
In-Reply-To: <49CE3F74.6090103@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> The better solution seems to be the rather obvious one:
> 
>   the filesystem should commit data to disk before altering metadata.
> 
> Much easier and more reliable to centralize it there, rather than
> rely (falsely) upon thousands of programs each performing numerous
> performance-killing fsync's.

Firstly, the FS data/metadata write-out order says nothing about when 
the write-out is started by the OS.  It only implies consistency in the 
face of a crash during write-out.  Hooray for BSD soft-updates.

If the write-out is started immediately during or after write(2), 
congratulations, you are on your way to reinventing synchronous writes.

If the write-out does not start immediately, then you have a 
many-seconds window for data loss.  And it should be self-evident that 
userland application writers will have some situations where design 
requirements dictate minimizing or eliminating that window.


Secondly, this email sub-thread is not talking about thousands of 
programs, it is talking about Firefox behavior.  Firefox is a multi-OS 
portable application that has a design requirement that user data must 
be protected against crashes.  (same concept as your word processor's 
auto-save feature)

The author of such a portable application must ensure their app saves 
data against Windows Vista kernel crashes, HPUX kernel crashes, OS X 
window system crashes, X11 window system crashes, application crashes, etc.

Can a portable app really rely on what Linux kernel hackers think the 
underlying filesystem _should_ do?

No, it is either (a) not going to care at all, or (b) uses fsync(2) or 
FlushFileBuffers() because if guarantees provided across the OS 
spectrum, in light of the myriad OS filesystem caching, flushing, and 
ordering algorithms.



Was the BSD soft-updates idea of FS data-before-metadata a good one? 
Yes.  Obviously.

It is the cornerstone of every SANE journalling-esque database or 
filesystem out there -- don't leave a window where your metadata is 
inconsistent.  "Duh" :)

But that says nothing about when a userland app's design requirements 
include ordered writes+flushes of its own application data.  That is the 
common case when a userland app like Firefox uses a transactional 
database such as sqlite or db4.

Thus it is the height of silliness to think that FS data/metadata 
write-out order permits elimination of fsync(2) for the class of 
application that must care about ordered writes/flushes of its own 
application data.

That upstream sqlite replaced fsync(2) with fdatasync(2) makes it 
obvious that FS data/metadata write-out order is irrelevant to Firefox.

The issue with transactional databases is more simply a design tradeoff 
-- level of fsync punishment versus performance etc.  Tweaking the OS 
filesystem doesn't help at all with those design choices.

	Jeff



