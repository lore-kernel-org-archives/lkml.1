Return-Path: <linux-kernel-owner+w=401wt.eu-S937912AbXHHXxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937912AbXHHXxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762621AbXHHXxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:53:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:50557 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762196AbXHHXxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:53:32 -0400
Message-ID: <46BA57AC.2040306@suse.com>
Date: Wed, 08 Aug 2007 19:54:20 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: Tom Mortensen <tmmlkml@gmail.com>
Cc: tony@tvortex.net, linux-kernel@vger.kernel.org,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: reiserfs fs/reiserfs/bitmap.c:1287
References: <15366.199.125.14.2.1184261266.squirrel@localmail-dr.mcsimons.com>	 <46967D7D.5090204@suse.com> <a52a95e30708081529i7cee02ddq61471378c2a12ffa@mail.gmail.com>
In-Reply-To: <a52a95e30708081529i7cee02ddq61471378c2a12ffa@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Tom Mortensen wrote:
> I'm wondering if any resolution to this particular bug?  I see this
> exact kernel bug in copying large data sets (40GB+), and can reproduce
> fairly well.  Running reiserfsck produces this message:
> 
> "Zero bit found in on-disk bitmap after the last valid bit."

BTW, this error describes the following condition:

With a 4KiB blocksize (assumed), each bitmap describes 128MiB chunks. If
your file system is of such a size that it's not an even multiple of
128MiB, the final bitmap will describe blocks that aren't part of the
file system. The easiest way to represent them is to mark them used so
that they won't end up getting allocated, ever.

The message quoted above means that some of the bits that describe the
blocks beyond the end of the file system have been zeroed, indicating
that the space is available. If you were actually hit by this condition
at runtime, you'd get "attempt to access beyond end of device" or
something like that in your log.

In any event, something is corrupting your bitmaps and that needs to get
tracked down. The size of the file system is important. I've been seeing
reports of users hitting similar problems with file systems larger than
8 TiB. The cause is that the s_bmap_nr field in the superblock is 16
bit, and the file system assumes it's correct. mkreiserfs < 3.6.20 will
happily create those file systems with a value that has wrapped, while
mkreiserfs >= 3.6.20 will zero the value out, causing a mount failure
unless the kernel has been patched to support the full size and to
interpret s_bmap_nr == 0 as "value has overflowed."

I've posted some lightly tested versions of patches to handle > 8TiB
file systems on the reiserfs-devel mailing list and hope to finalize
them this week. If your file system isn't larger than 8 TiB, then we'll
have to do a bit more hunting.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGulesLPWxlyuTD7IRAsK2AJ9hHXP/u/U39ilYbJzuJZH1Ak7n3ACfb/Oo
2GIGKznayXqevH6lVGh8vew=
=q4Ca
-----END PGP SIGNATURE-----
