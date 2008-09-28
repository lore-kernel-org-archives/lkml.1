Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbYI1PSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbYI1PSv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 11:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYI1PSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 11:18:40 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49785 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYI1PSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:18:40 -0400
Date: Sun, 28 Sep 2008 16:18:35 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Swap on loop device on tmpfs locks up machine
In-Reply-To: <19f34abd0809261146j72a68765i964466336a3a34dc@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0809281604100.17064@blonde.site>
References: <19f34abd0809261146j72a68765i964466336a3a34dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2008, Vegard Nossum wrote:
> 
> It turns out that swap over loop device on tmpfs will lock up the
> machine. That is, all programs become blocked, but I can still do
> things like switch VT consoles.
> 
> To reproduce (as root):
> 
>     mount -t tmpfs tmpfs /mnt
>     dd if=/dev/zero of=/mnt/disk
>     swapoff -a
>     losetup -f /mnt/disk
>     mkswap /dev/loop0 # replace loop0 with actual loop device
>     swapon /dev/loop0
>     <memory hog, like continuous malloc()>
> 
> I'm not sure it's really a very good idea to do this in the first
> place, but should something give a warning or prevent a user from
> doing it?

It's just a "don't do that" in my opinion, and it doesn't seem
to have caused much trouble for sysadmins down the years.

It's good to have a loop driver that can make regular files look
like block devices, and it's good to have that working on tmpfs;
and I'm glad that trying to swapon a tmpfs file directly just
happens to fail because tmpfs doesn't support bmap().

But I don't think it's worth adding in some "valid for swap" call
to block devices, and saying no when loop or when loop over tmpfs.
Trying to swap to loop over tmpfs is a particularly clear example
of something that will end badly - unless the tmpfs file is locked
in memory? haven't tried that - but I wouldn't recommend swapping
to loop over anything (it interposes levels between swap and device
which just increase the likelihood of hang).

Just don't do that.

Hugh
