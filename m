Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbYKYD3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbYKYD3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 22:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbYKYD3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 22:29:10 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:36774 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYKYD3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 22:29:09 -0500
Date: Mon, 24 Nov 2008 20:28:52 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Tejun Heo <teheo@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Dongjun Shin <djshin90@gmail.com>,
       chris.mason@oracle.com
Subject: Re: about TRIM/DISCARD support and barriers
Message-ID: <20081125032851.GC25548@parisc-linux.org>
References: <4928E010.4090801@kernel.org> <4929023C.2060302@suse.de> <20081123123514.GI5707@parisc-linux.org> <1227447584.4901.405.camel@macbook.infradead.org> <1227480776.25499.3.camel@localhost.localdomain> <1227517430.26957.20.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227517430.26957.20.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 09:03:50AM +0000, David Woodhouse wrote:
> And _then_ we can think about special cases which let us merge
> non-contiguous discards.

I've been thinking about what a solution would look like that lets us
send non-contiguous discards down, and I don't like the look of any of
them.  Right now, discard bios get turned into discard requests and
those are handled by the block device drivers as being a discard of the
range (sector, sector + nr_sectors).

If we're going to allow discontiguous ranges to be merged into one
request, then we need somewhere to store the ranges.  The obvious answer
is in the ->bio list.  But then, an unconverted driver will discard the
wrong sectors (presuming nr_sectors gets updated to the length of all
discarded sectors).

There's also murmurings from vendors that they want to restrict the
number of ranges transmitted in a single UNMAP/TRIM command, and that's
more information to be passed to the elevator.

How about an interface that lets the driver's discard function scan back
through the queue and see if there are any more discard bios queued up?
If there are, (and it has room for them) it can retire them from the
queue early. 

I'm open to other ideas, of course.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
