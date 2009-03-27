Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZC0SCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZC0SCV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZC0SCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:02:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbZC0SCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:02:08 -0400
Date: Fri, 27 Mar 2009 10:57:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <20090327170208.GA27646@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
References: <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu> <20090327145156.GB24819@srcf.ucam.org> <20090327150811.09b313f5@lxorguk.ukuu.org.uk>
 <20090327152221.GA25234@srcf.ucam.org> <20090327161553.31436545@lxorguk.ukuu.org.uk> <20090327162841.GA26860@srcf.ucam.org> <20090327165150.7e69d9e1@lxorguk.ukuu.org.uk> <20090327170208.GA27646@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Mar 2009, Matthew Garrett wrote:
> 
> If every application that does a clobbering rename has to call 
> fbarrier() first, then the kernel should just guarantee to do so on the 
> application's behalf. ext3, ext4 and btrfs all effectively do this, so 
> we should just make it explicit that Linux filesystems are expected to 
> behave this way. If people want to make their code Linux specific then 
> that's their problem, not the kernel's.

It would probably be good to think about something like this, because 
there are currently really two totally different cases of "fsync()" users.

 (a) The "critical safety" kind (aka the "traditional" fsync user), where 
     there is a mail server or similar that will reply "all done" to the 
     sender, and has to _guarantee_ that the file is on disk in order for 
     data to simply not be lost.

     This is a very different case from most desktop uses, and it's a evry 
     hard "we have to wait until the thing is physically on disk" 
     situation. And it's the only case where people really traditionally 
     used "fsync()".

 (b) The non-traditional UNIX usage where people historically didn't use
     fsync() for: people editing their config files either 
     programmatically or by hand.

     And this one really doesn't need at all the same kind of hard "wait 
     for it to hit the disk" semantics. It may well want a much softer 
     kind of "at least don't delete the old version until the new version 
     is stable" kind of thing.

And Alan - you can argue that fsync() has been around forever, but you 
cannot possibly argue that people have used fsync() for file editing. 
That's simply not true. It has happened, but it has been very rare. Yes, 
some editors (vi, emacs) do it, but even there it's configurable. And 
outside of databases, server apps and big editors, fsync is virtually 
unheard of. How many sed-scripts have you seen to edit files? None of them 
ever used fsync.

And with the ext3 performance profile for it, it sure is not getting any 
more common either. If you have a desktop app that uses fsync(), that 
application is DEAD IN THE WATER if people are doing anything else on the 
machine. Those multi-second pauses aren't going to make people happy.

So the fact is, "people should always use fsync" simply isn't a realistic 
expectation, nor is it historically accurate. Claiming it is is just 
obviously bogus. And claiming that people _should_ do it is crazy, since 
it performs badly enough to simply not be realistic.

Alternatives should be looked at. For desktop apps, the best alternatives 
are likely simply stronger default consistency guarantees. Exactly the 
"we don't guarantee that your data hits the disk, but we do guarantee that 
if you renamed on top of another file, you'll not have lost _both_ 
contents".

			Linus
