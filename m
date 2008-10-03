Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYJCFBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYJCFBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 01:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752672AbYJCFAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 01:00:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:44790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbYJCFAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 01:00:54 -0400
Date: Thu, 2 Oct 2008 22:00:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002220040.7963596c@infradead.org>
In-Reply-To: <20081002215026.a63ba0d0.akpm@linux-foundation.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002061236.3c71c877@infradead.org>
	<20081002132457.46ad8d05.akpm@linux-foundation.org>
	<20081002210117.0f5062f7@infradead.org>
	<20081002212355.621a4fb6@infradead.org>
	<20081002214000.89420bb3.akpm@linux-foundation.org>
	<20081002214353.30873f98@infradead.org>
	<20081002215026.a63ba0d0.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 21:50:26 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > 
> > I also notice it's part of "file_update_time". Do we really need to
> > go all the way down to this level of synchronicity for that?
> 
> Well, we've tossed that around many times but never implemented it. 
> Once you get into the details it gets a bit nasty.  Need to keep the
> dirtiness state in the VFS (or fs) inode, and going backwards from a
> plain old buffer_head at commit time isn't possible.  We usually
> tempfixed the problem by adding increasingly fancy ways of not doing
> the atime update at all.

given that this is the write path, I was assuming this was mtime rather
than atime; doesn't change your answer though.
> 
> Of course, fixing this running-vs-committing contention point would
> fix a lot more things than just atime updates.

yes clearly. It's waaay above my paygrade to hack on though; JBD is one
of those places in the kernel that scare me for doing fundamental
changes ;-(

> 
> > (I also randomly wonder if we, in the write path, dirty the inode
> > twice, once for size once for item, and if we then also reserve two
> > slots in the journal for that.....
> 
> That shouldn't be the case - once we have write access to the buffer
> it remains freely modifiable for the rest of the transaction period.
> I think.

I hope you're right otherwise we'd always hit this; once for the size
change, then block for the mtime. That would thoroughly suck; so much
so that you just must be right.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
