Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZC3SjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZC3SjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZC3SjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:39:10 -0400
Received: from rtr.ca ([76.10.145.34]:34063 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355AbZC3SjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:39:09 -0400
Message-ID: <49D111C9.4020502@rtr.ca>
Date: Mon, 30 Mar 2009 14:39:05 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>	 <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>	 <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca>	 <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>	 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de>	 <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed>	 <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx>	 <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx>	 <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca>	 <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca>	 <49D0DDFE.5080701@redhat.com> <49D0E35E.9080003@rtr.ca>	 <49D0E4E8.20508@redhat.com>	 <alpine.LFD.2.00.0903300841420.3948@localhost.localdomain>	 <49D0F399.5010407@rtr.ca>	 <alpine.LFD.2.00.0903300946050.3948@localhost.localdomain> <1238435832.30488.83.camel@think.oraclecorp.com>
In-Reply-To: <1238435832.30488.83.camel@think.oraclecorp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
>
> I had some fun trying things with this, and I've been able to reliably
> trigger stalls in write cache of ~60 seconds on my seagate 500GB sata
> drive.  The worst I saw was 214 seconds.
..

I'd be more interested in how you managed that (above),
than the quite different test you describe below.

Yes, different, I think.  The test below just times how long a single
chunk of data might stay in-drive cache under constant load,
rather than how long it takes to flush the drive cache on command.

Right?

Still, useful for other stuff.

> It took a little experimentation, and I had to switch to the noop
> scheduler (no idea why).  
> 
> Also, I had to watch vmstat closely.  When the test first started,
> vmstat was reporting 500kb/s or so write throughput.  After the test ran
> for a few minutes, vmstat jumped up to 8MB/s.
> 
> My guess is that the drive has some internal threshold for when it
> decides to only write in cache.  The switch to 8MB/s is when it switched
> to cache only goodness.  Or perhaps the attached program is buggy and
> I'll end up looking silly...it was some quick coding.
> 
> The test forks two procs.  One proc does 4k writes to the first 26MB of
> the test file (/dev/sdb for me).  These writes are O_DIRECT, and use a
> block size of 4k.
> 
> The idea is that we fill the cache with work that is very beneficial to
> keep in cache, but that the drive will tend to flush out because it is
> filling up tracks.
> 
> The second proc O_DIRECT writes to two adjacent sectors far away from
> the hot writes from the first proc, and it puts in a timestamp from just
> before the write.  Every second or so, this timestamp is printed to
> stderr.  The drive will want to keep these two sectors in cache because
> we are constantly overwriting them.
> 
> (It's worth mentioning this is a destructive test.  Running it
> on /dev/sdb will overwrite the first 64MB of the drive!!!!)
> 
> Sample output:
> 
> # ./wb-latency /dev/sdb
> Found tv 1238434622.461527
> starting hot writes run
> starting tester run
> current time 1238435045.529751
> current time 1238435046.531250
> ...
> current time 1238435063.772456
> current time 1238435064.788639
> current time 1238435065.814101
> current time 1238435066.847704
> 
> Right here, I pull the power cord.  The box comes back up, and I run:
> 
> # ./wb-latency -c /dev/sdb
> Found tv 1238435067.347829
> 
> When -c is passed, it just reads the timestamp out of the timestamp
> block and exits.  You compare this value with the value printed just
> before you pulled the block.
> 
> For the run here, the two values are within .5s of each other.  The
> tester only prints the time every one second, so anything that close is
> very good.  I had pulled the plug before the drive got into that fast
> 8MB/s mode, so the drive was doing a pretty good job of fairly servicing
> the cache.
> 
> My drive has a cache of 32MB.  Smaller caches probably need a smaller
> hot zone.
> 
> -chris
> 
> 

