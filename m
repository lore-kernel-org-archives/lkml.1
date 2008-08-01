Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYHARRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYHARRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYHARRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:17:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776AbYHARRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:17:31 -0400
Date: Fri, 1 Aug 2008 10:16:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
cc: Arthur Jones <ajones@riverbed.com>,
       Dan Williams <dan.j.williams@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PULL REQUEST] md bug fixes and minor improvements
In-Reply-To: <18578.31924.259887.735206@notabene.brown>
Message-ID: <alpine.LFD.1.10.0808011007240.3277@nehalem.linux-foundation.org>
References: <18578.31924.259887.735206@notabene.brown>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Aug 2008, Neil Brown wrote:
> 
> Hi Linus,
>  please pull the following bugfixes for drivers/md.

Hmm. This doesn't seem to include any fix for the reported unlocked 
blk_plug() from MD?

See the emails from Rafael on the kernel mailing list for details 
(WARNING: at /home/rafael/src/linux-next/include/linux/blkdev.h:447), but 
it boils down to

	WARNING: at /home/rafael/src/linux-2.6/include/linux/blkdev.h:447 blk_plug_device+0x9b/0xb0()
	Pid: 2268, comm: kjournald Not tainted 2.6.27-rc1-git #211

	Call Trace:
	 [<ffffffff8023af5f>] warn_on_slowpath+0x5f/0x80
	 [<ffffffff8034fc7b>] blk_plug_device+0x9b/0xb0
	 [<ffffffff8044d5bf>] bitmap_startwrite+0xbf/0x1b0

where it really looks like "bitmap_startwrite()" just calls 
blk_plug_device() without holding the queue lock. The rule for that 
function is documented to be:

 * This is called with interrupts off and no requests on the queue and
 * with the queue lock held.

Hmm?

Now, admittedly, the blk interfaces here are a bit inconsistent: I think 
blk_unplug() is supposed to be called _without_ the lock, so it's a bit 
odd that blk_plug_device() is supposed to b called with it held, but 
somebody should double-check me on that one.

I guess Jens is gone too..

		Linus
