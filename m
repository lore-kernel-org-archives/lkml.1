Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbXJ0JJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbXJ0JJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 05:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbXJ0JJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 05:09:48 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:20859 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbXJ0JJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 05:09:47 -0400
Message-ID: <47230059.80202@msgid.tls.msk.ru>
Date: Sat, 27 Oct 2007 13:09:45 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: vince.kim@access-company.com
CC: linux-kernel@vger.kernel.org, "Richard Purdie [rpurdie"@openedhand.com
Subject: Re: [PATCH 1/2 ] Add support LZO in cramfs
References: <1193441153.17726.17.camel@vince-desktop>
In-Reply-To: <1193441153.17726.17.camel@vince-desktop>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vince kim wrote:
> This is a kernel patch to add support LZO compression in cramfs. 
[]
> --- linux-2.6.23/fs/cramfs/inode.c      2007-10-09 13:31:38.000000000 -0700
> +++ linux-2.6.23_cramfs_lzo/fs/cramfs/inode.c    2007-10-26 14:35:59.000000000 -0700
> @@ -31,6 +31,8 @@
>  static const struct inode_operations cramfs_dir_inode_operations;
>  static const struct file_operations cramfs_directory_operations;
>  static const struct address_space_operations cramfs_aops; 
> +/* function pointer to uncompress block */
> +static int (* cramfs_uncompress_block) (void *dst, int dstlen, void *src, int srclen);

Shouldn't this pointer be mountpoint-specific?  I mean,
if I've two cramfs images, one using zlib and another
using lzo, the two will not work at the same time.

[]
> --- linux-2.6.23/fs/Kconfig     2007-10-09 13:31:38.000000000 -0700
> +++ linux-2.6.23_cramfs_lzo/fs/Kconfig  2007-10-26 14:19:01.000000000 -0700
> @@ -1348,6 +1348,7 @@
>         tristate "Compressed ROM file system support (cramfs)" 
>         depends on BLOCK
>         select ZLIB_INFLATE
> +       select LZO_DECOMPRESS
>         help
>           Saying Y here includes support for CramFs (Compressed ROM File
>           System).  CramFs is designed to be a simple, small, and compressed 

Hmm.  How about using modular decompressor? I mean,
it isn't really necessary for a given config to handle
both lzo- and zlib-compressed cramfs images, only one
may be needed, so the other compression library becomes
a useless dependency.  This is especially important for
embedded environments where memory/disk space is limited.
Since you're using a pointer-to-function anyway, it can
be done fully dynamically, by requesting a module to de-
compress the thing at runtime.  Pretty much like it's
done f.e. in crypto/ipsec layer currently.

By the way, your patch is word-wrapped.

/mjt
