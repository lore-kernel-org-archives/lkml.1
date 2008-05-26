Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYEZRvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYEZRvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYEZRvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:51:36 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37510 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753099AbYEZRvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:51:35 -0400
Date: Mon, 26 May 2008 13:50:39 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Oliver Neukum <oliver@neukum.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080526175039.GC11330@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Bart Van Assche <bart.vanassche@gmail.com>,
	Oliver Neukum <oliver@neukum.org>, Ingo Molnar <mingo@elte.hu>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <4836EE8C.1010200@linux.intel.com> <20080526164858.GA24098@elte.hu> <20080526170147.GB9893@mit.edu> <200805261909.59032.oliver@neukum.org> <e2e108260805261028o204d4fc7l3f20ad3919cf778b@mail.gmail.com> <20080526173848.GM32407@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526173848.GM32407@duck.suse.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 07:38:48PM +0200, Jan Kara wrote:
> > Looking at the filesystem UUID could help -- this is an ID that is
> > present as data on the disk, and that is even independent of the bus
> > type. See also /dev/disk/by-uuid.
>   Yes, but as Oliver wrote if someone modified the filesystem in the mean
> time, you won't notice it - UUID doesn't help here.

That part you could figure out in userspace, by looking at the last
mount and last modified time in the superblock.  But the problem is
it's too late.  If you had buffers which had been "in flight" at the
time when the USB stick was pulled, the kernel isn't going to be able
to send them to the new instantiation of the device for the freshly
installed USB stick.  And I don't think we want to put
filesystem-specific UUID and superblock parsing code in the generic
USB layer!

I suspect that if we want to do this, the only way would be with
massive amounts of userspace help, and with the dm layer interposing
between the filesystem and the device.  So when the USB stick gets
pulled, from the dm-multipath side it looks like the last I/O path has
been pulled, and it role-plays accordingly (with some kind of
intelligence where it holds dirty buffers for some reasonable amount
of time --- where reasonable is not easy to define) and then when
someone re-inserts a USB stick, userspace will have to figure out that
it was the same filesystem, and that it apparently hasn't been
tampered with, cross its fingers, and then associate the (possibly
different USB device) with the dm-multipath device.

If we have a super-bright student who needs humbling, it might make
for an interesting GSOC project.  :-)

						- Ted
