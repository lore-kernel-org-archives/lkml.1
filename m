Return-Path: <linux-kernel-owner+w=401wt.eu-S1763581AbZEHM7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763581AbZEHM7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 08:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758301AbZEHM7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 08:59:39 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:41198 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbZEHM7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 08:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TSvDvgh3kLVhS2XsumEOmNJZVu2+vuf43w2fdHfkoxz9jS9nmhmQENML7JnccR+lYN
         I6DGhWDwW5P++MPNLJKe9dOZYvpY0VGpTiQYO/aMftiHEWfBBQZKQa6b5sUnlCFPdhUh
         sbLJzeIuX6oZjHNXgzysNRa5slb5708SYzXok=
MIME-Version: 1.0
In-Reply-To: <a276da400905080524o1a56b895ldc2788458deaf1ff@mail.gmail.com>
References: <20090506222439.GB22327@kroah.com>
	 <a276da400905070451j550d9a9ajcdd3ab30b03278aa@mail.gmail.com>
	 <20090508040101.GC31689@kroah.com>
	 <a276da400905072340j6130615bu3ef524be5bd48143@mail.gmail.com>
	 <a276da400905080524o1a56b895ldc2788458deaf1ff@mail.gmail.com>
Date: Fri, 8 May 2009 20:59:37 +0800
Message-ID: <a276da400905080559ra7da1d0yef9d87797b49b373@mail.gmail.com>
Subject: Re: usbutils 0.82 release
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 8, 2009 at 8:24 PM, Xiaofan Chen <xiaofanc@gmail.com> wrote:
> I still do not know the exact reason but it seems to be related to the
> generated config.h file or zlib.
>
> If I use the file config.h from 0.73, there will be no warning. It is
> longer than the one generated in 0.82 or git.
>
> And if I undefine HAVE_LIBZ in names.c, there will be no warning.
>
> The warning is not only in gcc 4.4.0, but also in gcc 4.3.3.
>

I think the problem is in zlib. I got the warning under Ubuntu 9.04
(gcc 4.3.2 and zlib 1.2.3.3) and Arch Linux (gcc 4.4.0 and zlib 1.2.3.3).

zlib 1.2.3.3 in Ubuntu 9.04 and Arch Linux

typedef voidp gzFile;

/*
ZEXTERN gzFile ZEXPORT gzopen  OF((const char *path, const char *mode));

     Opens a gzip (.gz) file for reading or writing. The mode parameter
   is as in fopen ("rb" or "wb") but can also include a compression level
   ("wb9") or a strategy: 'f' for filtered data as in "wb6f", 'h' for
   Huffman only compression as in "wb1h", or 'R' for run-length encoding
   as in "wb1R". (See the description of deflateInit2 for more information
   about the strategy parameter.)

     gzopen can be used to read a file which is not in gzip format; in this
   case gzread will directly read from the file without decompression.

     gzopen returns NULL if the file could not be opened or if there was
   insufficient memory to allocate the (de)compression state; errno
   can be checked to distinguish the two cases (if errno is zero, the
   zlib error is Z_MEM_ERROR).  */

ZEXTERN gzFile ZEXPORT gzdopen  OF((int fd, const char *mode));
/*
     gzdopen() associates a gzFile with the file descriptor fd.  File
   descriptors are obtained from calls like open, dup, creat, pipe or
   fileno (in the file has been previously opened with fopen).
   The mode parameter is as in gzopen.
     The next call of gzclose on the returned gzFile will also close the
   file descriptor fd, just like fclose(fdopen(fd), mode) closes the file
   descriptor fd. If you want to keep fd open, use gzdopen(dup(fd), mode).
     gzdopen returns NULL if there was insufficient memory to allocate
   the (de)compression state.
*/

I got no warning under Fedora 10 (gcc 4.3.3 and zlib 1.2.3).

zlib 1.2.3 in Fedora 10. But this seems strange. It defines two version
of gzopen. The first one seems to be used so that no warning is caused.

typedef voidp gzFile;

ZEXTERN gzFile ZEXPORT gzopen  OF((const char *path, const char *mode));
/*
     Opens a gzip (.gz) file for reading or writing. The mode parameter
   is as in fopen ("rb" or "wb") but can also include a compression level
   ("wb9") or a strategy: 'f' for filtered data as in "wb6f", 'h' for
   Huffman only compression as in "wb1h", or 'R' for run-length encoding
   as in "wb1R". (See the description of deflateInit2 for more information
   about the strategy parameter.)

     gzopen can be used to read a file which is not in gzip format; in this
   case gzread will directly read from the file without decompression.

     gzopen returns NULL if the file could not be opened or if there was
   insufficient memory to allocate the (de)compression state; errno
   can be checked to distinguish the two cases (if errno is zero, the
   zlib error is Z_MEM_ERROR).  */

ZEXTERN gzFile ZEXPORT gzdopen  OF((int fd, const char *mode));
/*
     gzdopen() associates a gzFile with the file descriptor fd.  File
   descriptors are obtained from calls like open, dup, creat, pipe or
   fileno (in the file has been previously opened with fopen).
   The mode parameter is as in gzopen.
     The next call of gzclose on the returned gzFile will also close the
   file descriptor fd, just like fclose(fdopen(fd), mode) closes the file
   descriptor fd. If you want to keep fd open, use gzdopen(dup(fd), mode).
     gzdopen returns NULL if there was insufficient memory to allocate
   the (de)compression state.
*/


-- 
Xiaofan http://mcuee.blogspot.com
