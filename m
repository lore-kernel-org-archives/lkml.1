Return-Path: <linux-kernel-owner+w=401wt.eu-S1757708AbYFXDCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708AbYFXDCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 23:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYFXDCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 23:02:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbYFXDCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 23:02:36 -0400
Date: Mon, 23 Jun 2008 20:01:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, sct@redhat.com,
       adilger@sun.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, jack@suse.cz,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [RFC][PATCH] ext3: don't read inode block if the buffer has a
 write error
In-Reply-To: <20080623191733.52c3491c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806231958010.2926@woody.linux-foundation.org>
References: <485F8822.5030205@hitachi.com> <200806232146.28379.nickpiggin@yahoo.com.au> <20080623191733.52c3491c.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jun 2008, Andrew Morton wrote:
> > I don't know why it was done like this, or if anybody actually tested
> > any of it, but AFAIKS the best way to fix this is to simply not
> > clear any uptodate bits upon write errors.
> 
> There's a plausible-sounding reason for this behaviour which I forgot
> about three years ago.  Maybe Linus remembers?

We have to drop the data at _some_ point. Maybe some errors are transient, 
but a whole lot aren't. Jank out your USB memory stick, and those writes 
will continue fail. So you can't just keep things dirty - and that also 
implies that the buffer sure as heck isn't up-to-date either.

Yes, we could haev a "retry once or twice", but quite frankly, that has 
always been left to the low-level driver. By the time the buffer cache or 
page cache sees the error, it should be considered more than "transient", 
and the data in memory is simply not _useful_ any more.

So clearing the uptodate bit seems to be the logical thing to do. But on 
the other hand, it's probably not helping much either, so I don't 
personally care if we keep it "uptodate" - as long as the dirty bit 
doesn't get set, and as long as there is *some* way to get rid of the bad 
buffer later.

		Linus
