Return-Path: <linux-kernel-owner+w=401wt.eu-S1750851AbYGIQ10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851AbYGIQ10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYGIQ1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:27:18 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:43695 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751194AbYGIQ1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:27:17 -0400
Date: Wed, 9 Jul 2008 12:27:15 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jan Willem van den Brand <janwillem.dev@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] ext3/jbd, kernel 2.6.13, make ext3 mountable as ext2
	when journal is empty.
Message-ID: <20080709162715.GC11797@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Willem van den Brand <janwillem.dev@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <c56f29cb0807090821x74d0652ekc3ae4bb5725df76c@mail.gmail.com> <c56f29cb0807090824k727b0da7se1a019394cdbeea7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c56f29cb0807090824k727b0da7se1a019394cdbeea7@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 05:24:25PM +0200, Jan Willem van den Brand wrote:
> This patch makes ext3 mountable as ext2 even in case of a power
> failure while mounted as ext3. We have tested it for kernel 2.6.13 but
> it should be fairly easy to get it to work for other versions.

What's the rationale for doing this.  Why is it *useful* to have the
filesystem be mountable as ext2 in case of a power failure?  The whole
point of ext3 is to be able to keep the filesystem consistent in case
of a power failure.

So the patch as given would never go into the kernel as-is, and in the
general case it is totally counterproductive.  Maybe it could go in as
a optional behaviour enabled by a mount option, but that's assuming we
can be convinced it's a good idea.

> In case of a power failure, the INCOMPAT flag is not reset. Systems
> that suffer from frequent power failure (e.g. SD-cards that are
> unsafely removed) will often not be mountable as ext2.

So what?  Why can't you just run the journal and check the filesystem
for consistency?  If the user did a hot-eject while the SD-card was
being written, even with your patch there is no guarantee that the
card will even be readable.  Some SD-cards go totally non-functional
due to corruption at the flash translation layer when they are yanked
in the middle of an update....

> Obviously, this solution will result in poor performance when many
> small files are frequently closed after write but that is not the case
> in our system (TomTom navigation device).

How often does your TomTom device need to update files?  A better
(userspace-only) solution might be keep the filesystem mounted
read-only, and when you need to write to the filesystem, turn on the
LED (which hopefully will be a hint to the users to keep their grubby
little paws off the eject button), remount it read/write, do your file
writes, then remount it read/only, and turn off the LED.

Regards,

						- Ted
