Return-Path: <linux-kernel-owner+w=401wt.eu-S1754906AbZC3QZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906AbZC3QZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZC3QZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:25:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbZC3QZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:25:28 -0400
Date: Mon, 30 Mar 2009 09:13:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ric Wheeler <rwheeler@redhat.com>
cc: Mark Lord <lkml@rtr.ca>, Chris Mason <chris.mason@oracle.com>,
       "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D0E4E8.20508@redhat.com>
Message-ID: <alpine.LFD.2.00.0903300841420.3948@localhost.localdomain>
References: <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de>
 <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <49D0710A.1030805@ursus.ath.cx> <20090330100546.51907bd2@the-village.bc.nu> <49D0A3D6.4000300@ursus.ath.cx>
 <49D0AA4A.6020308@redhat.com> <49D0CDBA.7040702@rtr.ca> <49D0D08E.3090100@redhat.com> <49D0DAD3.6030507@rtr.ca> <49D0DDFE.5080701@redhat.com> <49D0E35E.9080003@rtr.ca> <49D0E4E8.20508@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Ric Wheeler wrote:
> 
> A modern S-ATA drive has up to 32MB of write cache. If you lose power or
> suffer a sudden reboot (that can reset the bus at least), I am pretty sure
> that your above assumption is simply not true.

At least traditionally, it's worth to note that 32MB of on-disk cache is 
not the same as 32MB of kernel write cache.

The drive caches tend to be more like track caches - you tend to have a 
few large cache entries (segments), not something like a sector cache. And 
I seriously doubt the disk will let you fill them up with writes: it 
likely has things like the sector remapping tables in those caches too.

It's hard to find information about the cache organization of modern 
drives, but at least a few years ago, some of them literally had just a 
single segment, or just a few segments (ie a "8MB cache" might be eight 
segments of one megabyte each).

The reason that matters is that those disks are very good at linear 
throughput.

The latency for writing out eight big segments is likely not really 
noticeably different from the latency of writing out eight single sectors 
spread out across the disk - they both do eight operations, and the 
difference between an op that writes a big chunk of a track and writing a 
single sector isn't necessarily all that noticeable.

So if you have a 8MB drive cache, it's very likely that the drive can 
flush its cache in just a few seeks, and we're still talking milliseconds. 
In contrast, even just 8MB of OS caches could have _hundreds_ of seeks and 
take several seconds to write out.

			Linus
