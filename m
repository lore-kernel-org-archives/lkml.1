Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbZCaWDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbZCaWDJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbZCaWCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:02:55 -0400
Received: from france.micfo.com ([92.48.68.3]:58000 "EHLO france.micfo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbZCaWCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:02:54 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 and the "30 second window of death"
Date: Wed, 1 Apr 2009 00:02:46 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.28-ARCH; KDE/4.2.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu>
In-Reply-To: <20090331134547.GJ13356@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904010002.47077.info@gnebu.es>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - france.micfo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009 15:45:47 Theodore Tso wrote:
> On Tue, Mar 31, 2009 at 02:52:05PM +0200, Alberto Gonzalez wrote:
> > You've proposed that in laptop mode, fsync's should be held until next
> > write cycle (say every 30 seconds) so that the disk is not spun up
> > unnecessarily, wasting battery and shortening it's lifespan too. I
> > absolutely agree with this, and as a trade-off I'm ok with losing my last
> > paragraph even if I did hit Ctrl+S to save it a few seconds before a
> > crash. But again, with Ext4 will I just lose that last paragraph or the
> > whole book in this case?
>
> Laptop mode is already set up such that the moment the disk spins up,
> any pending writes are immediately flushed to disk --- the idea being
> that if the disk is spinning, we might as well take advantage of it to
> get everything pushed out to disk.  As long as we actually keep a
> linked list of those fsync's which were "held up", and we make sure
> all of the delayed allocation blocks are also allocated before we push
> them out, the right thing will happen.  If we just ignore the fsync's,
> then we might not allocate the delayed allocation blocks.  So
> basically, we need to be careful about how we implement this addition
> to laptop_mode.

In fact, thinking about it, this option would be the ideal one for desktops 
and especially laptops (servers running databases are a different thing). What 
we need is that _no_ application uses fsync. The decision as to when the data 
should be written to disk should be left to the filesystem. And then the user 
can choose how often they want this to happen (every 5, 15, 30, 60... 
seconds). So if Ext4 could have a "nofsync" mount option that would disable 
fsync from applications (i.e, it wouldn't honor an fsync call), that would be 
wonderful. But then of course we have to make sure that if the kernel crashes 
(or there's a power-off, etc..), we will just lose the new data that hasn't 
been written to disk, but the old data will still be there. So maybe this 
could be achieved with mounting the filesystem with nofsync, nodelalloc? 

> The bottom line is that it *can* be implemented safely, but there are
> some things that we would need to pay attention to in order to make
> sure it *was* safe.

If you could do this, many of us would be willing to buy you a beer :)

>
> 						- Ted

And of course, thanks for your patience with this issue. And sorry for all 
you're having to take from us uninformed but somehow worried users (I run Ext4 
now, but added the nodelalloc option when all this started).

Alberto.
