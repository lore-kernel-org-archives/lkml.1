Return-Path: <linux-kernel-owner+w=401wt.eu-S933754AbXHFTmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbXHFTmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbXHFTlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:41:52 -0400
Received: from master.altlinux.org ([62.118.250.235]:3851 "EHLO
	master.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760790AbXHFTlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:41:50 -0400
Date: Mon, 6 Aug 2007 23:41:22 +0400
From: Sergey Vlasov <vsu@altlinux.ru>
To: "Lindsay Roberts" <lindsay.roberts.os@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: Add romfs version 2
Message-Id: <20070806234122.d6c82f24.vsu@altlinux.ru>
In-Reply-To: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>
References: <8734b7880707122301m400294d4nf12072f949c95fa4@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.10.6; x86_64-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__6_Aug_2007_23_41_23_+0400_p+1Hc3e=bLxusi8w"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Aug_2007_23_41_23_+0400_p+1Hc3e=bLxusi8w
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Fri, 13 Jul 2007 16:01:48 +1000 Lindsay Roberts wrote:

> * Increases romfs partition size limit from 2GB to 4GB.

This should be a separate patch.

> * Adds new derivative of romfs filesystem (rom2fs) with
>   block aligned regular file data to bring performance
>   parity with ext2/3. This is about 225% of the read
>   speed of the existing romfs.
>
> Signed-off-by: Lindsay Roberts <lindsay.roberts.os@gmail.com>
> ---
> genromfs patch available at http://rom2fs.googlepages.com .
>
>  Documentation/filesystems/romfs.txt |   34 +++++--
>  fs/romfs/inode.c                    |  195 +++++++++++++++++++++++++++++------
>  include/linux/romfs_fs.h            |    1 +
>  3 files changed, 187 insertions(+), 43 deletions(-)
>
> diff --git a/Documentation/filesystems/romfs.txt
> b/Documentation/filesystems/romfs.txt
> index 2d2a7b2..170b1cc 100644
> --- a/Documentation/filesystems/romfs.txt
> +++ b/Documentation/filesystems/romfs.txt
> @@ -7,6 +7,10 @@ similar feature, and even the possibility of a small
> kernel, with a
>  file system which doesn't take up useful memory from the router
>  functions in the basement of your office.
>
> +The romfs version 2 filesystem is a slight derivation created to fix
> +performance issues with file data unaligned to logical disk blocks.
> +It differs only in its placement of regular file data.
> +
>  For comparison, both the older minix and xiafs (the latter is now
>  defunct) filesystems, compiled as module need more than 20000 bytes,
>  while romfs is less than a page, about 4000 bytes (assuming i586
> @@ -18,7 +22,10 @@ with romfs, it needed 3079 blocks.
>
>  To create such a file system, you'll need a user program named
>  genromfs.  It is available via anonymous ftp on sunsite.unc.edu and
> -its mirrors, in the /pub/Linux/system/recovery/ directory.
> +its mirrors, in the /pub/Linux/system/recovery/ directory, as well as
> +at the sourceforge project http://romfs.sourceforge.net/ . A genromfs
> +patch to support version 2 is available at
> +http://rom2fs.googlepages.com/ .
>
>  As the name suggests, romfs could be also used (space-efficiently) on
>  various read-only media, like (E)EPROM disks if someone will have the
> @@ -43,6 +50,11 @@ from the network, and you will have all the
> tools/modules available
>  from a nearby server, so you don't want to carry two disks for this
>  purpose, just because it won't fit into ext2.
>
> +romfs also has a secondary use in reproducibility. The absence of
> +both timestamps and permission information coupled with the read-only
> +nature of the file system gives it amazing capability as a byte
> +reproducible medium for a given directory structure.

Not sure about this - the placement of file headers in romfs is
completely unspecified (a linked list is used), file names in
directories are not required to be in a sorted order...  Of course, a
particular genromfs implementation could always produce the same
bytestream for a given set of files, but the format itself does not
really have any particular advantages.

> +
>  romfs operates on block devices as you can expect, and the underlying
>  structure is very simple.  Every accessible structure begins on 16
>  byte boundaries for fast access.  The minimum space a file will take
> @@ -50,7 +62,8 @@ is 32 bytes (this is an empty file, with a less than
> 16 character
>  name).  The maximum overhead for any non-empty file is the header, and
>  the 16 byte padding for the name and the contents, also 16+14+15 = 45
>  bytes.  This is quite rare however, since most file names are longer
> -than 3 bytes, and shorter than 15 bytes.
> +than 3 bytes, and shorter than 15 bytes. romfs version 2 adds
> +additional overhead in order to align file data to (1k) disk blocks.
>
>  The layout of the filesystem is the following:
>
> @@ -59,7 +72,7 @@ offset	    content
>  	+---+---+---+---+
>    0	| - | r | o | m |  \
>  	+---+---+---+---+	The ASCII representation of those bytes
> -  4	| 1 | f | s | - |  /	(i.e. "-rom1fs-")
> +  4	| 1 | f | s | - |  /	(i.e. "-rom1fs-" or "-rom2fs-")
>  	+---+---+---+---+
>    8	|   full size	|	The number of accessible bytes in this fs.
>  	+---+---+---+---+
> @@ -101,8 +114,10 @@ offset	    content
>   16	| file name     |	The zero terminated name of the file,
>  	:               :	padded to 16 byte boundary
>  	+---+---+---+---+
> - xx	| file data	|
> -	:		:
> + xx	| file data	|       In the case of romfs version 2 - regular
> +	:		:       files, this offset is padded to the next
> +                                1024 byte block relative to the start of
> +                                the filesystem.

You add padding between the file header and data.  But you can also
add padding before the file header to make it end on a block boundary;
I don't see any requirement that the next file header must be placed
immediately after the previous file data (the header contains an
explicit pointer to the next file header in the directory).  The only
file header which has a fixed position is the first file header in the
root directory - but it should be the "." entry, which does not
contain any data and therefore does not require alignment; all other
file headers can be placed at arbitrary positions.

And if you add padding before file headers, you do not need to change
the filesystem format at all - just check ROMFS_I(i)->i_dataoffset in
romfs_read_inode() and select your new aops if the offset is
appropriately aligned.  This way you will get perfect compatibility in
both directions - a filesystem with aligned file data will just
perform faster with a patched kernel.  And genromfs could even choose
to align only some files (e.g., bigger than some threshold).

[...]

--Signature=_Mon__6_Aug_2007_23_41_23_+0400_p+1Hc3e=bLxusi8w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQFGt3lmW82GfkQfsqIRAl1eAJ9nrFfzTQMzCJp6BqGSvLzbz5EZKQCghr/S
kMrVCC9SqPzabyrJVxZLPx8=
=Dqc2
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Aug_2007_23_41_23_+0400_p+1Hc3e=bLxusi8w--
