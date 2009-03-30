Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZC3NsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZC3NsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 09:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZC3Nrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 09:47:55 -0400
Received: from THUNK.ORG ([69.25.196.29]:47830 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbZC3Nry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:47:54 -0400
Date: Mon, 30 Mar 2009 09:45:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090330134552.GE13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Trenton D. Adams" <trenton.d.adams@gmail.com>,
	Mark Lord <lkml@rtr.ca>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca> <20090329231451.GR26138@disturbed> <20090330003948.GA13356@mit.edu> <9b1675090903291829u7a69df36m65b6698290773859@mail.gmail.com> <20090330032827.GD13356@mit.edu> <9b1675090903292055q6f0f5126we47d853b96a385f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b1675090903292055q6f0f5126we47d853b96a385f6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 09:55:59PM -0600, Trenton D. Adams wrote:
> > (This is with a filesystem formated as ext3, and mounted as either
> > ext3 or ext4; if the filesystem is formatted using "mke2fs -t ext4",
> > what you see is a very smooth 1.2-1.5 seconds fsync latency, indirect
> > blocks for very big files end up being quite inefficient.)
> 
> Oh.  I thought I had read somewhere that mounting ext4 over ext3 would
> solve the problem.  Not sure where I read that now.  Sorry for wasting
> your time.

Well, I believe it should solve it for most realistic workloads (where
I don't think "dd if=/dev/zero of=bigzero.img" is realistic).  

Looking more closely at the statistics, the delays aren't coming from
trying to flush the data blocks in data=ordered mode.  If we disable
delayed allocation (mount -o nodelalloc), you'll see this when you
look at /proc/fs/jbd2/<dev>/history:

R/C  tid   wait  run   lock  flush log   hndls  block inlog ctime write drop  close
R    12    23    3836  0     1460  2563  50129  56    57   
R    13    0     5023  0     1056  2100  64436  70    71   
R    14    0     3156  0     1433  1803  40816  47    48   
R    15    0     4250  0     1206  2473  57623  63    64   
R    16    0     5000  0     1516  1136  61087  67    68   

Note the amount of time in milliseconds in the flush column.  That's
time spent flusing the allocated data blocks to disk.  This goes away
once you enable delayed allocation:

R/C  tid   wait  run   lock  flush log   hndls  block inlog ctime write drop  close
R    56    0     2283  0     10    1250  32735  37    38   
R    57    0     2463  0     13    1126  31297  38    39   
R    58    0     2413  0     13    1243  35340  40    41   
R    59    3     2383  0     20    1270  30760  38    39   
R    60    0     2316  0     23    1176  33696  38    39   
R    61    0     2266  0     23    1150  29888  37    38   
R    62    0     2490  0     26    1140  35661  39    40   

You may see slightly worse times since I'm running with a patch (which
will be pushed for 2.6.30) that makes sure that the blocks we are
writing during the "log" phase are written using WRITE_SYNC instead of
WRITE.  (Without this patch, the huge amount of writes caused by the
VM trying to keep up with pages being dirtied at CPU speeds via "dd
if=/dev/zero..." will interfere with writes to the journal.)

During the log phase (which is averaging around 2 seconds for
nodealloc, and 1 seconds with delayed allocation enabled), we write
the metadata to the journal.  The number of blocks that we are
actually writing to the journal is small (around 40 per transaction)
so I suspect we're seeing some lock contention or some accounting
overhead caused by the metadata blocks constantly getting dirtied by
dd if=/dev/zero task.  We can look to see if this can be improved,
possibly by changing how we handle the locking, but it's no longer
being caused by the data=ordered flushing behaviour.

> Yes, I realize that.  When trying to find performance problems I try
> to be as *unfair* as possible. :D

And that's a good thing from a development point of view when trying
to fix performance problems.  When making statements about what people
are likely to find in real life, it's less useful.

    	      	      	   	      	   - Ted
