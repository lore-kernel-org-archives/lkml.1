Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXDZQ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXDZQ5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXDZQ5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:57:20 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754857AbXDZQ5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:57:19 -0400
Date: Thu, 26 Apr 2007 09:56:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <1177573348.5025.224.camel@nigel.suspend2.net>
Message-ID: <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> 
 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
 <1177573348.5025.224.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Apr 2007, Nigel Cunningham wrote:
> 
> * Doing things in the right order? (Prepare the image, then do the
> atomic copy, then save).

I'd actually like to discuss this a bit..

I'm obviously not a huge fan of the whole user/kernel level split and 
interfaces, but I actually do think that there is *one* split that makes 
sense:

 - generate the (whole) snapshot image entirely inside the kernel

 - do nothing else (ie no IO at all), and just export it as a single image 
   to user space (literally just mapping the pages into user space). 
   *one* interface. None of the "pretty UI update" crap. Just a single 
   system call:

	void *snapshot_system(u32 *size);

   which will map in the snapshot, return the mapped address and the size 
   (and if you want to support snapshots > 4GB, be my guest, but I suspect 
   you're actually *better* off just admitting that if you cannot shrink 
   the snapshot to less than 32 bits, it's not worth doing)

User space gets a fully running system, with that one process having that 
one image mapped into its address space. It can then compress/write/do 
whatever to that snapshot.

You need one other system call, of course, which is

	int resume_snapshot(void *snapshot, u32 size);

and for testing, you should be able to basically do

	u32 size;
	void *buffer = snapshot_system(&size);
	if (buffer != MAP_FAILED)
		resume_snapshot(buffer, size);

and it should obviously work.

And btw, the device model changes are a big part of this. Because I don't 
think it's even remotely debuggable with the full suspend/resume of the 
devices being part of generating the image! That freeze/snapshot/unfreeze 
sequence is likely a lot more debuggable, if only because freeze/unfreeze 
is actually a no-op for most devices, and snapshotting is trivial too.

Once you have that snapshot image in user space you can do anything you 
want. And again: you'd hav a fully working system: not any degradation 
*at*all*. If you're in X, then X will continue running etc even after the 
snapshotting, although obviously the snapshotting will have tried to page 
a lot of stuff out in order to make the snapshot smaller, so you'll likely 
be crawling.

> * Mulithreaded I/O (might as well use multiple cores to compress the
> image, now that we're hotplugging later).
> * Support for > 1 swap device.
> * Support for ordinary files.
> * Full image option.
> * Modular design?

I'd really suggest _just_ the "full image". Nothing else is probably ever 
worth supporting. Your "snapshot to disk" wouldn't be _quite_ as simple as 
"echo disk > /sys/power/state", but it should not necessarily be much 
worse than

	snapshot_kernel | gzip -9 > /dev/snapshot

either (and resuming from the snapshot would just be the reverse)!

And if you want to send the snapshot over a TCP connection to another 
host, be my guest. With pretty images while it's transferring. Whatever.

			Linus
