Return-Path: <linux-kernel-owner+w=401wt.eu-S1767148AbXDTQj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767148AbXDTQj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993280AbXDTQj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:39:59 -0400
Received: from ns2.suse.de ([195.135.220.15]:57094 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993277AbXDTQj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:39:57 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: "Ulrich Drepper" <drepper@gmail.com>
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
Date: Fri, 20 Apr 2007 18:40:07 +0200
User-Agent: KMail/1.9.5
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       "Andrew Morton" <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704201721.29825.agruen@suse.de> <a36005b50704200824i228f98ccq80f88a0f9d64abb2@mail.gmail.com>
In-Reply-To: <a36005b50704200824i228f98ccq80f88a0f9d64abb2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704201840.07247.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 April 2007 17:24, Ulrich Drepper wrote:
> On 4/20/07, Andreas Gruenbacher <agruen@suse.de> wrote:
> > Yes, that one, sorry. The values it obtains that way are not reliable.
>
> Why should the mount point info together with the filesystem type not
> be reliable?

Ah ... I overlooked that fstatvfs() also checks the device number, not only 
the name, and so then it can find the right device from that.

So for how glibc uses /proc/mounts in fstatvfs(), hiding unreachable mount 
points from /proc/mounts wouldn't improve things. The heuristic already 
doesn't work for file descriptors from other namespaces, so it's already 
broken unfortunately. A more robust mechanism for glibc to use would be nice; 
not sure it would be worth it only for fstatvfs though.

The code also seems to stop at the first matching mount point. You can have 
the same device mounted on the same mount point multiple times but with 
different mount options, e.g.,

	$ dd if=/dev/zero of=/var/tmp/ext2 bs=4096 count=16384
	$ mkfs.ext2 -F /var/tmp/ext2
	$ mount -o loop /var/tmp/ext2 /mnt
	$ mount -o loop,ro /var/tmp/ext2 /mnt
	$ tail -n 2 /proc/mounts
	/dev/loop0 /mnt ext2 rw 0 0
	/dev/loop1 /mnt ext2 ro 0 0

The topmost mount point appears last in /proc/mounts, and so unless I am 
overlooking something else, that's another minor problem.

The third problem, as I already tried to argue several times now, is that the 
mount points path that /proc/mounts reports may or may not actually exist. 
That's a problem for glibc, and you should be one of the first to notice and 
acknowledge that. I gave a chroot example that showed that in the current 
implementation, you can get pretty random clashes between mounts; there are 
other cases with lazy unmounts as well.

> You're trying to find an excuse to break tings, that seems all there is.

Now what makes you think that??

Andreas
